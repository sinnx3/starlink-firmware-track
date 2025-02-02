from flask import (
    Blueprint, current_app, render_template, request, flash, redirect, url_for, g
)
import re, requests, json, sqlite3, awoc, pycountry
from datetime import datetime, timedelta
from bs4 import BeautifulSoup

# App imports
from starlink.db import get_db

bp = Blueprint('speedtest', __name__, url_prefix='/speedtests')

requestHeaders = {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Safari/537.36',
    }

speedtestPeriods = ['day', 'week', 'month', 'year', 'all']
continents = ['africa', 'antarctica', 'asia', 'europe', 'north_america', 'oceania', 'south_america']
regionData = awoc.AWOC()

# View to show the index page of speedtest results
@bp.route('/', methods = ['GET'], defaults={'region': 'global'})
@bp.route('/region/<string:region>')
def index(region):
    db = get_db()
    listDict = {}
    statDict = {}
    region = region.lower()
    mapboxKey = current_app.config['MAPBOX_KEY']

    # Latest entry dict
    # Validator to only process if provided region is valid
    if region == "global": # Get latest rows for every country
        regionName = region.capitalize() #Prettify region name
        listDB = db.execute('''
            SELECT id, url, datetime(date_run), country, latency, download, upload
            FROM speedtests
            ORDER BY date_run
            DESC LIMIT 10
            ''').fetchall()

    # Get latest rows for countries within continent
    elif region in continents: 
        regionName = region.replace('_', ' ').title() # Prettify region name
        sqlWhereQuery = ""
        countries = regionData.get_countries_data_of(regionName)
        for country in countries:
            countryCode = country['ISO2'].lower()
            sqlWhereQuery += f'"{countryCode}", '
        sqlWhereQuery = sqlWhereQuery[:-2]
        listDB = db.execute(f'''
            SELECT id, url, datetime(date_run), country, latency, download, upload
            FROM speedtests
            WHERE country in ({sqlWhereQuery})
            ORDER BY date_run
            DESC LIMIT 10
            ''').fetchall()       
    
    else: # Get latest rows for specific country
        regionCheck = pycountry.countries.get(alpha_2=region)  
        if regionCheck:
            regionName = regionCheck.name # Get region name from country code
            listDB = db.execute('''
                SELECT id, url, datetime(date_run), country, latency, download, upload
                FROM speedtests
                WHERE country = ?
                ORDER BY date_run
                DESC LIMIT 10
                ''', (region,)).fetchall()

        # Return invalid region error
        else:
            flash("Supplied region code is incorrect.", "warning")
            return redirect(url_for('speedtest.index'))
        
    for row in listDB:
        id, url, date_run, country, latency, download, upload = row
        convDate = datetime.strptime(date_run, "%Y-%m-%d %H:%M:%S").date().strftime("%Y-%m-%d")
        listDict[id] = {'url': url, 'dateRun': convDate, 'country': country, 'latency': latency, 'download': f'{download/1000:.1f}', 'upload': f'{upload/1000:.1f}'}
    
    # Statistic dict
    statDB = db.execute('''
        SELECT *
        FROM speedtest_stats
        WHERE region = ?
        ''', (region,)).fetchone()

    for period in speedtestPeriods:
        if statDB and statDB[f'{period}_count'] > 0:
            count = statDB[f'{period}_count']
            latencyAvg = f'{statDB[f"{period}_latency_avg"]:.0f}'
            latencyMax = f'{statDB[f"{period}_latency_max"]:.0f}'
            latencyMin = f'{statDB[f"{period}_latency_min"]:.0f}'
            downloadAvg = f'{statDB[f"{period}_download_avg"]/1000:.2f}'
            downloadMax = f'{statDB[f"{period}_download_max"]/1000:.2f}'
            downloadMin = f'{statDB[f"{period}_download_min"]/1000:.2f}'
            uploadAvg = f'{statDB[f"{period}_upload_avg"]/1000:.2f}'
            uploadMax = f'{statDB[f"{period}_upload_max"]/1000:.2f}'
            uploadMin = f'{statDB[f"{period}_upload_min"]/1000:.2f}'
        else:
            count = 0
            latencyAvg = latencyMax = latencyMin = downloadAvg = downloadMax = downloadMin = uploadAvg = uploadMax = uploadMin = "No Data"
            
        statDict[period] = {'count': count, 
            'latencyAvg': latencyAvg, 'latencyMax': latencyMax, 'latencyMin': latencyMin, 
            'downloadAvg': downloadAvg, 'downloadMax': downloadMax, 'downloadMin': downloadMin,
            'uploadAvg': uploadAvg, 'uploadMax': uploadMax, 'uploadMin': uploadMin}
        regionBbox = json.load(open(current_app.root_path + '/static/other/regions-bbox.json'))[region]

    return render_template('speedtest/index.html', regionName=regionName, statDict=statDict, listDict=listDict, mapboxKey=mapboxKey, regionBbox=regionBbox)

# View to show the index page of speedtest results
# Under development
@bp.route('/user/<string:username>', methods = ['GET'])
def user(username):
    db = get_db()
    error = None
    listDict = {}

    userId = db.execute('SELECT id FROM users WHERE username = ?', (username,)).fetchone()

    if userId:
        listDB = db.execute('''
            SELECT id, url, datetime(date_run), country, latency, download, upload
            FROM speedtests
            WHERE user_id = ?
            ORDER BY date_run
            DESC LIMIT 10
            ''', (userId)).fetchall()

        for row in listDB:
            id, url, date_run, country, latency, download, upload = row
            convDate = datetime.strptime(date_run, "%Y-%m-%d %H:%M:%S").date().strftime("%Y-%m-%d")
            listDict[id] = {'url': url, 'dateRun': convDate, 'country': country, 'latency': latency, 'download': f'{download/1000:.1f}', 'upload': f'{upload/1000:.1f}'}
    
    else:
        flash("User not found", "warning")
        return redirect(url_for('speedtest.index'))


    return render_template('speedtest/user.html', listDict=listDict)

# View to show the all time leaderboard
@bp.route('/leaderboard', methods = ['GET'])
def leaderboard():
    db = get_db()
    statDict = {'latency': [], 'download': [], 'upload': []}
    
    latency = db.execute('''
        SELECT latency, url, country, date_run
        FROM speedtests
        ORDER BY latency asc LIMIT 3
        ''').fetchall()
    download = db.execute('''
        SELECT download, url, country, date_run
        FROM speedtests
        ORDER BY download DESC LIMIT 3
        ''').fetchall()
    upload = db.execute('''
        SELECT upload, url, country, date_run
        FROM speedtests
        ORDER BY upload DESC LIMIT 3
        ''').fetchall()

    for result in latency:
        index = latency.index(result)
        statDict['latency'].append({'latency': latency[index][0], 'url': latency[index][1], 'country': latency[index][2], 'date': datetime.strptime(latency[index][3], "%Y-%m-%d %H:%M:%S").date().strftime("%Y-%m-%d")})

    for result in download:
        index = download.index(result)
        statDict['download'].append({'download': f'{download[index][0]/1000:.2f}', 'url': download[index][1], 'country': download[index][2], 'date': datetime.strptime(download[index][3], "%Y-%m-%d %H:%M:%S").date().strftime("%Y-%m-%d")})

    for result in upload:
        index = upload.index(result)
        statDict['upload'].append({'upload': f'{upload[index][0]/1000:.2f}', 'url': upload[index][1], 'country': upload[index][2], 'date': datetime.strptime(upload[index][3], "%Y-%m-%d %H:%M:%S").date().strftime("%Y-%m-%d")})
        
    return render_template('speedtest/leaderboard.html', statDict=statDict)

# View & function to add new speedtests
@bp.route('/add', methods = ['GET', 'POST'])
def add():
    db = get_db()
    error = None
    source = ""

    if request.method == 'POST':
        url = request.form['url']
        apiKey = request.form.get('api-key')

        # Convert into clean url
        if re.search('png', url): # If an image was picked up, get the id and convert to ordinary url
                    url = url.replace(".png", "")
        if re.search('my-result', url):
                    url = url.replace("my-result", "result")

        # Continue if url is valid with base domain
        if re.search('^https://www.speedtest.net/result/.\S*$', url):
            dbCheck = db.execute('SELECT EXISTS (SELECT 1 FROM speedtests WHERE url = ? LIMIT 1)', (url,)).fetchone()[0]
            if dbCheck == 0: # If speedtest result does not exist in db
                try:
                    response = requests.get(url, timeout=5, headers=requestHeaders)
                    page_html = BeautifulSoup(response.text, 'html.parser')
                    scripts = list(filter(lambda script: not script.has_attr("src"), page_html.find_all("script")))[::-1] # Reverse list to improve speed because data script is at the end of <head>
                    dataScript = None
                    for script in scripts:
                        if "window.OOKLA.INIT_DATA" in script.get_text():
                            dataScript = script
                            break
                    if dataScript:
                        result = re.search('({"result").*}}*', dataScript.get_text())       
                        data = json.loads(result.group())['result']
                        if data['isp_name'] == "SpaceX Starlink": # If ISP is Starlink
                            if int(data['distance']) >= 500: # If test conducted has a distance greater than 500 miles between server and Starlink POP
                                error = "The speedtest was measured with a server that is far away from your location. This can lead to inaccurate results. Please ensure you select a server that is close to you."
                            elif int(data['latency']) <= 5 or int(data['download']) >= 600000 or int(data['download']) <= 1000 or int(data['upload']) >= 55000 or int(data['upload']) <= 500: # If test results are not within a valid range (<5ms latency, 1-600mbps download, 0.5-50mbps upload) for Starlink (may change in the future)
                                error = "Speedtest contains potentially inaccurate results. Please try again.\nLimits: Latency (> 5ms), Download (600mbps - 1mbps), Upload(55mbps - 0.5mbps)."
                            else:
                                if apiKey:
                                    apiDetails = db.execute('SELECT user_id, source, use_counter FROM users_api_keys WHERE key = ?', (apiKey,)).fetchone()
                                    if apiDetails: # If the supplied api key is valid
                                        userId = apiDetails['user_id']
                                        source = apiDetails['source']
                                        if source == 'discord-starlink': # If form was submitted by discord bot, lookup user id for discord id.
                                            discordUserId = request.form['discord-user-id']
                                            userIdCheck = db.execute('SELECT id FROM users WHERE discord_id = ?', (discordUserId,)).fetchone()
                                            if userIdCheck: # Set user id if user has set a discord id in account settings
                                                userId = int(userIdCheck['id'])

                                        db.execute('UPDATE users_api_keys SET use_counter = ? WHERE key = ?', (apiDetails['use_counter'] + 1, apiKey))
                                        db.commit()
                                    else:
                                        error = "API key is not valid"
                                else:
                                    if g.user: # Authenticated user on website
                                        userId = g.user['id']
                                        source = 'website-official'
                                    else: # Either website form or external POST (source is classified as website as external POST without an API key is rare)
                                        userId = None
                                        source = 'website-official'
                                 
                                db.execute('INSERT INTO speedtests (date_added, date_run, url, country, server, latency, download, upload, source, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
                                    (datetime.utcnow(), datetime.utcfromtimestamp(data['date']), url, data['country_code'].lower(), data['server_name'], int(data['latency']), int(data['download']), int(data['upload']), source, userId))
                                db.commit()
                        else:
                            error = "Speedtest was not run on Starlink."
                    else:
                        error = "Speedtest result could not be found. Ensure the URL is correct."
                except Exception as e:
                    error = "Speedtest could not be added. Please tag Tech Support."
                    print(e)
            else:
                error = "Speedtest result already exists."
        else:
            error = "URL must be in `https://www.speedtest.net/result/` format as a standalone message."

        if error is None:
            if source == "website-official":
                flash("Speedtest added successfully.", "success")
            else:
                return "Speedtest added successfully, thanks!"     
        else:
            if source == "website-official":
                flash(error, "warning")
            else:
                return error

    return render_template('speedtest/add.html')


# Function to calculate periodic statistics while in thread
def schedSpeedtestCalcBuilder():
    db = sqlite3.connect('instance/starlink.db')
    dbCountries = [row[0] for row in db.execute('SELECT DISTINCT country FROM speedtests').fetchall()] # Get a list of countries and convert into array
    db.close()

    # Global statistic calculation
    schedSpeedtestCalc("global")

    # Country statistic calculation
    for country in dbCountries:
        schedSpeedtestCalc(country, f' AND country in ("{country}")')

    # Collated region statistic calculation
    for continent in continents:
        countries = regionData.get_countries_data_of(continent.replace('_', ' '))
        sqlWhereString = ""
        # Build the SQL WHERE string only with countries with an existing speedtest result in DB to increase speed
        for country in countries:
            countryCode = country['ISO2'].lower()  
            if countryCode in dbCountries:
                sqlWhereString += f'"{countryCode}", '
        sqlWhereString = sqlWhereString[:-2] # Trim off trailing comma
        schedSpeedtestCalc(continent, f' AND country in ({sqlWhereString})')
      
# Common function to calculate periodic statistic for given region
def schedSpeedtestCalc(region, sqlWhereString=""):
    dateTimeNow = datetime.utcnow()
    datePastDay = dateTimeNow - timedelta(days=1)
    datePastWeek = dateTimeNow - timedelta(days=7)
    datePastMonth = dateTimeNow - timedelta(weeks=4)
    datePastYear = dateTimeNow - timedelta(weeks=52)
    dateAll = "1970-01-01"

    db = sqlite3.connect('instance/starlink.db')

    # If a statistic record doesn't exist for the region, make one
    dbCheck = db.execute('SELECT EXISTS (SELECT 1 FROM speedtest_stats WHERE region = ? LIMIT 1)', (region,)).fetchone()[0]
    if dbCheck == 0: 
        db.execute('INSERT INTO speedtest_stats (region) VALUES (?)', (region,))
        db.commit()

    # Calculate and store statistics for each time period
    for period, periodDateTime in {'day': datePastDay, 'week': datePastWeek, 'month': datePastMonth, 'year': datePastYear, 'all': dateAll}.items():
        speedtestCount = db.execute(f'SELECT Count(id) FROM speedtests WHERE date_run BETWEEN ? AND ? {sqlWhereString}', (periodDateTime, dateTimeNow)).fetchone()[0]
        latency = db.execute(f'''
            SELECT avg(latency), max(latency), min(latency)
            FROM speedtests
            WHERE date_run BETWEEN ? AND ?
            {sqlWhereString}
            ''', (periodDateTime, dateTimeNow)).fetchone()
        download = db.execute(f'''
            SELECT avg(download), max(download), min(download)
            FROM speedtests
            WHERE date_run BETWEEN ? AND ?
            {sqlWhereString}
            ''', (periodDateTime, dateTimeNow)).fetchone()
        upload = db.execute(f'''
            SELECT avg(upload), max(upload), min(upload)
            FROM speedtests
            WHERE date_run BETWEEN ? AND ?
            {sqlWhereString}
            ''', (periodDateTime, dateTimeNow)).fetchone()

        # Store updated stats
        db.execute(f'''
            UPDATE speedtest_stats SET date_calculated = ?, {period}_count = ?,
            {period}_latency_avg = ?, {period}_latency_max = ?, {period}_latency_min = ?,
            {period}_download_avg = ?, {period}_download_max = ?, {period}_download_min = ?,
            {period}_upload_avg = ?, {period}_upload_max = ?, {period}_upload_min = ?
            WHERE region = ?
            ''', (dateTimeNow, speedtestCount, latency[0], latency[1], latency[2], download[0], download[1], download[2], upload[0], upload[1], upload[2], region))
        db.commit()
    db.close()