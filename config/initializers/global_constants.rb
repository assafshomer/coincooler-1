KEYS_DEFAULT = 10
KEYS_LIMIT = 100
SHARES_LIMIT = 9
DEFAULT_SSSN = 5
DEFAULT_SSSK = 3
PI = `cat /etc/rpi-issue` =~ /Raspberry Pi/ || `cat /etc/os-release` =~ /Raspbian/
DEV = Rails.env.development?
PROD = Rails.env.production?
TEST = Rails.env.test?
HEROKU = Rails.root.to_path == "/app"
COPY = PI || TEST
AJAXON = true
DEBUG = false
HOT = ConnectionHelper::internet_connection?
PBKDF2_ITERATIONS = PROD ? 1_000_000 : 10
ENCRYPTION_LIBRARY = CryptoHelper::check_pbkdf2
ID = rand(100000..999999)
FLASH_DELAY_SECONDS = PI ? 5 : 3
FLASH_FADE_SECONDS = 2
PBKDF_ALERT_DELAY_SECONDS = PI ? 3 : 1
VERSION = 11
