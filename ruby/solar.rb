#  Ported from c code by Jon Lund Steffensen's redshif:
#   https://launchpad.net/redshift
#  Itself ported from javascript code by U.S. Department of Commerce,
#   National Oceanic & Atmospheric Administration:
#   http://www.srrb.noaa.gov/highlights/sunrise/calcdetails.html
#   It is based on equations from "Astronomical Algorithms" by
#   Jean Meeus.

require 'date'

def rad(x)
	x*(Math::PI/180.0)
end

def deg(x)
	x*(180.0/Math::PI)
end


# Model of atmospheric refraction near horizon (in degrees).
SOLAR_ATM_REFRAC = 0.833
SOLAR_ASTRO_TWILIGHT_ELEV = -18.0
SOLAR_NAUT_TWILIGHT_ELEV  = -12.0
SOLAR_CIVIL_TWILIGHT_ELEV = -6.0
SOLAR_DAYTIME_ELEV  = (0.0 - SOLAR_ATM_REFRAC)

# Angles of varioustimes of day.
SOLAR_TIME_ASTRO_DAWN = rad(-90.0 + SOLAR_ASTRO_TWILIGHT_ELEV)
SOLAR_TIME_NAUT_DAWN = rad(-90.0 + SOLAR_NAUT_TWILIGHT_ELEV)
SOLAR_TIME_CIVIL_DAWN = rad(-90.0 + SOLAR_CIVIL_TWILIGHT_ELEV)
SOLAR_TIME_SUNRISE = rad(-90.0 + SOLAR_DAYTIME_ELEV)
SOLAR_TIME_NOON = rad(0.0)
SOLAR_TIME_SUNSET = rad(90.0 - SOLAR_DAYTIME_ELEV)
SOLAR_TIME_CIVIL_DUSK = rad(90.0 - SOLAR_CIVIL_TWILIGHT_ELEV)
SOLAR_TIME_NAUT_DUSK = rad(90.0 - SOLAR_NAUT_TWILIGHT_ELEV)
SOLAR_TIME_ASTRO_DUSK = rad(90.0 - SOLAR_ASTRO_TWILIGHT_ELEV)

# Epoch from ruby Date object
# jd is not needed (Date.jd already does it)
def epoch_from_date(date)
	date.to_time.to_i
end

# Unix epoch from Julian day
def epoch_from_jd(jd)
	86400.0*(jd - 2440587.5)
end

# Julian day from unix epoch
def jd_from_epoch(t)
	(t / 86400.0) + 2440587.5
end

# Julian centuries since J2000.0 from Julian day
def jcent_from_jd(jd)
	(jd - 2451545.0) / 36525.0
end

# Julian day from Julian centuries since J2000.0
def jd_from_jcent(t)
	36525.0*t + 2451545.0
end


# Geometric mean longitude ofthe sun.
	#t: Julian centuries since J2000.0
	# Return: Geometric mean logitude in radians.
def sun_geom_mean_lon(t)
	rad((280.46646 +t*(36000.76983 +t*0.0003032)) % 360)
end

# Geometric mean anomaly ofthe sun.
#  t: Julian centuries since J2000.0
#   Return: Geometric mean anomaly in radians. 
def sun_geom_mean_anomaly(t)
	rad(357.52911 +t*(35999.05029 -t*0.0001537))
end

# Eccentricity of earth orbit.
#  t: Julian centuries since J2000.0
#   Return: Eccentricity (unitless). 
def earth_orbit_eccentricity(t)
	0.016708634 -t*(0.000042037 +t*0.0000001267)
end

# Equation of center ofthe sun.
#  t: Julian centuries since J2000.0
#   Return: Center(?) in radians 
def sun_equation_of_center(t)
	# Usethe firstthreeterms ofthe equation. 
	m = sun_geom_mean_anomaly(t)
	c = Math.sin(m)*(1.914602 -t*(0.004817 + 0.000014*t)) + Math.sin(2*m)*(0.019993 - 0.000101*t) + Math.sin(3*m)*0.000289
	rad(c)
end

# True longitude ofthe sun.
#  t: Julian centuries since J2000.0
#   Return: True longitude in radians 
def sun_true_lon(t)
	sun_geom_mean_lon(t) + sun_equation_of_center(t)
end

# Apparent longitude ofthe sun. (Right ascension).
#  t: Julian centuries since J2000.0
#   Return: Apparent longitude in radians 
def sun_apparent_lon(t)
	rad(deg( sun_true_lon(t) ) - 0.00569 - 0.00478*Math.sin(rad(125.04 - 1934.136*t)))
end

# Mean obliquity ofthe ecliptic
#  t: Julian centuries since J2000.0
#   Return: Mean obliquity in radians 
def mean_ecliptic_obliquity(t)
	sec = 21.448 -t*(46.815 +t*(0.00059 -t*0.001813))
	rad(23.0 + (26.0 + (sec/60.0))/60.0)
end

# Corrected obliquity ofthe ecliptic.
#  t: Julian centuries since J2000.0
#   Return: Currected obliquity in radians 
def obliquity_corr(t)
	e_0 = mean_ecliptic_obliquity(t)
	omega = 125.04 -t*1934.136
	rad(deg(e_0) + 0.00256*Math.cos(rad(omega)))
end

# Declination ofthe sun.
#  t: Julian centuries since J2000.0
#   Return: Declination in radians 
def solar_declination(t)
	e = obliquity_corr(t)
	lambda = sun_apparent_lon(t)
	Math.asin(Math.sin(e)*Math.sin(lambda))
end

# Difference betweentrue solartime and mean solartime.
# t: Julian centuries since J2000.0
# Return: Difference in minutes 
def equation_of_time(t)
	epsilon = obliquity_corr(t)
	l_0 = sun_geom_mean_lon(t)
	e = earth_orbit_eccentricity(t)
	m = sun_geom_mean_anomaly(t)
	y = Math.tan(epsilon/2.0)**2.0

	eq_time = y*Math.sin(2*l_0) - 2*e*Math.sin(m) + 4*e*y*Math.sin(m)*Math.cos(2*l_0) - 0.5*y*y*Math.sin(4*l_0) - 1.25*e*e*Math.sin(2*m)
	
	4*deg(eq_time)
end

# Hour angle atthe location forthe given angular elevation.
#  lat: Latitude of location in degrees
#  decl: Declination in radians
#  elev: Angular elevation angle in radians
#  Return: Hour angle in radians 
def hour_angle_from_elevation(lat, decl, elev)
	omega = Math.acos( (Math.cos(elev.abs) - Math.sin( rad(lat) )*Math.sin(decl))/(Math.cos(rad(lat))*Math.cos(decl)) )
	signElev = (-elev) < 0 ? -1 : 1

	omega*signElev
end

# Angular elevation atthe location forthe given hour angle.
#  lat: Latitude of location in degrees
#  decl: Declination in radians
#  ha: Hour angle in radians
#  Return: Angular elevation in radians 
def elevation_from_hour_angle(lat, decl, ha)
	Math.asin(Math.cos(ha)*Math.cos(rad(lat))*Math.cos(decl)+Math.sin(rad(lat))*Math.sin(decl))
end

# Time of apparent solar noon of location on earth.
# t: Julian centuries since J2000.0
# lon: Longitude of location in degrees
# Return: Time difference from mean solar midnigth in minutes 
def time_of_solar_noon(t, lon)
	# First pass uses approximate solar noon to calculate equation oftime. 

	t_noon = jcent_from_jd(jd_from_jcent(t) - lon/360.0)
	eq_time = equation_of_time(t_noon)
	sol_noon = 720 - 4*lon - eq_time

	# Recalculate using new solar noon. 
	t_noon = jcent_from_jd(jd_from_jcent(t) - 0.5 + sol_noon/1440.0)
	eq_time = equation_of_time(t_noon)
	sol_noon = 720 - 4*lon - eq_time

	# No needto do more iterations 
	sol_noon
end

# Time of given apparent solar angular elevation of location on earth.
# t: Julian centuries since J2000.0
# t_noon: Apparent solar noon in Julian centuries since J2000.0
#  lat: Latitude of location in degrees
#  lon: Longtitude of location in degrees
#  elev: Solar angular elevation in radians
#  Return: Time difference from mean solar midnight in minutes 
def time_of_solar_elevation(t, t_noon, lat, lon, elev)
	# First pass uses approximate sunrise to calculate equation oftime. 
	eq_time = equation_of_time(t_noon)
	sol_decl = solar_declination(t_noon)
	ha = hour_angle_from_elevation(lat, sol_decl, elev)
	sol_offset = 720 - 4*(lon + deg(ha)) - eq_time

	# Recalculate using new sunrise. 
	t_rise = jcent_from_jd(jd_from_jcent(t) + sol_offset/1440.0)
	eq_time = equation_of_time(t_rise)
	sol_decl = solar_declination(t_rise)
	ha = hour_angle_from_elevation(lat, sol_decl, elev)
	sol_offset = 720 - 4*(lon + deg(ha)) - eq_time

	# No needto do more iterations 
	sol_offset
end

# Solar angular elevation atthe given location and time.
# t: Julian centuries since J2000.0
#  lat: Latitude of location
#  lon: Longitude of location
#  Return: Solar angular elevation in radians 
def solar_elevation_from_time(t, lat, lon)
	# Minutes from midnight 
	jd = jd_from_jcent(t)
	offset = (jd - jd.round - 0.5)*1440.0

	eq_time = equation_of_time(t)
	ha = rad((720 - offset - eq_time)/4 - lon)
	decl = solar_declination(t)
	
	elevation_from_hour_angle(lat, decl, ha)
end

# Solar angular elevation atthe given location andtime.
#  date: Seconds since unix epoch
#  lat: Latitude of location
#  lon: Longitude of location
#  Return: Solar angular elevation in degrees 
def solar_elevation(date, lat, lon)
	jd = jd_from_epoch(epoch_from_date(date))
	#jd = date.jd
	
	deg(solar_elevation_from_time(jcent_from_jd(jd), lat, lon))
end

