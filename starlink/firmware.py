from doctest import debug_script
from flask import (
    Blueprint, current_app, flash, redirect, render_template, request, abort, current_app, url_for
)
from datetime import datetime
from discord_webhook import DiscordWebhook, DiscordEmbed
from starlink.db import get_db

bp = Blueprint('firmware', __name__, url_prefix='/firmware')

# View to show all firmware versions for a specific hardware/software type.
@bp.route('/<string:listType>', methods = ['GET', 'POST'])
def list(listType):
    db = get_db()
    if request.method == 'POST':
        # Add new version entry into db.
        if request.form["btn"] == "addVersion":
            version = request.form['version']
            redditThread = request.form['redditThread']
            db.execute('INSERT INTO fw_versions (date_added, type, version_info, reddit_thread) VALUES (?, ?, ?, ?)', (datetime.now().date(), listType, version, redditThread))
            db.commit()
            sendNotification(version, listType, redditThread)
            flash("Version added successfully", "success")
            return redirect(request.referrer)

        # Remove existing version entry from db.
        if request.form["btn"] == "removeVersion":
            entryID = request.form['entryID']
            db.execute('DELETE FROM fw_versions WHERE id = ?', (entryID,))
            db.commit()
            db.execute('DELETE FROM notes WHERE version_id = ?', (entryID,))
            db.commit()
            flash("Version and all related notes were deleted.", "success")
            return redirect(request.referrer)

    # Retrieve data and render view.
    if listType in ['dishy', 'router', 'app', 'web', 'hardware']: # Return the view only if listType is valid
        listDict = {}
        rowData = db.execute('''
            SELECT id, date_added, version_info, reddit_thread
            FROM fw_versions
            WHERE type = ?
        ''', [listType,]).fetchall()

        
        for row in rowData:
            id, date_added, version, reddit = row
            #convDate = datetime.strptime(date_added, "%Y-%m-%d %H:%M:%S").date().strftime("%Y-%m-%d")
            noteAmount = db.execute('SELECT Count(id) FROM notes WHERE version_id = ?', (id,)).fetchone()[0]
            listDict[id] = {'dateAdded': date_added, 'id': id, 'version': version, 'reddit': reddit, 'noteAmount': noteAmount}

        return render_template('firmware/list.html', listType=listType.capitalize(), listDict=listDict)
    else:
        abort(404)

# View to show all notes for a specific firmware version.
@bp.route('/<string:listType>/<int:entryID>/notes', methods = ['GET', 'POST'])
def notes(listType, entryID):
    db = get_db()
    if request.method == 'POST':
        # Add new note into db.
        if request.form["btn"] == "addNote":
            note = request.form['note']
            db.execute('INSERT INTO notes (date_added, note, version_id) VALUES (?, ?, ?)', (datetime.now().date(), note, entryID))
            db.commit()
            flash("Note added successfully.", "success")
            return redirect(request.referrer)

        # Remove existing note from db.
        if request.form["btn"] == "removeNote":
            entryID = request.form['entryID']
            db.execute('DELETE FROM notes WHERE id = ?', (entryID,))
            db.commit()
            flash("Note deleted successfully.", "success")
            return redirect(request.referrer)

    # Retrieve data and render view.
    listDict = {}
    rowData = db.execute('''
        SELECT id, date_added, note
        FROM notes
        WHERE version_id = ?
    ''', [entryID,]).fetchall()
    for row in rowData:
        id, date_added, note = row
        listDict[id] = {'dateAdded': date_added, 'id': id, 'note': note}
    
    versionName = db.execute('''
        SELECT version_info
        FROM fw_versions
        WHERE id = ?
    ''', (entryID,)).fetchone()[0]

    return render_template('firmware/notes.html', listDict=listDict, versionDetails={'type': listType, 'name': versionName})

def sendNotification(version, type, reddit):
    webhook = DiscordWebhook(url=current_app.config['DISCORD_WEBHOOK'])
    hostDomain = url_for('index', _external=True)[:-1]
    embed = DiscordEmbed(title=version, description=f"[Link]({hostDomain}+'/'+{type})", color=242424)
    embed.add_embed_field(name='Firmware Type', value=type.capitalize())
    if reddit: embed.add_embed_field(name='Reddit', value=f"[Thread]({reddit})")
    else: embed.add_embed_field(name='Reddit Thread', value="Not Provided")
    embed.set_thumbnail(url=hostDomain + url_for('static', filename=f'thumbnails/{type}.png'))
    embed.set_timestamp()
    webhook.add_embed(embed)
    response = webhook.execute()