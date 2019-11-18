// /etc/mailman/mm_cfg.py
MAILMAN_UID = pwd.getpwnam('mainlman')[2]
MAILMAN_GID = grp.getgrnam('mailman')[2]
DEFAULT_URL_HOST = 'ml.nscg.jp'
DEFAULT_EMAIL_HOST = 'nscg.jp'


