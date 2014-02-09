Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59756 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaBIFTj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Feb 2014 00:19:39 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WCMno-00006H-CU
	for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 21:19:36 -0800
Date: Sat, 8 Feb 2014 21:19:36 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Bedup bug report
Message-ID: <20140209051936.GF10027@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel 3.12.7, python 2.7.6-5, debian testing/unstable, bedup installed as per
pip install --user bedup

I tried installing the git version, but the error is the same:

Anyway, with the other bedup, I get:
gargamel:/mnt/dshelf2/backup# bedup show
Traceback (most recent call last):
  File "/usr/local/bin/bedup", line 9, in <module>
    load_entry_point('bedup==0.9.0', 'console_scripts', 'bedup')()
  File "/root/.local/lib/python2.7/site-packages/bedup/__main__.py", line 483, in script_main
    sys.exit(main(sys.argv))
  File "/root/.local/lib/python2.7/site-packages/bedup/__main__.py", line 472, in main
    return args.action(args)
  File "/root/.local/lib/python2.7/site-packages/bedup/__main__.py", line 70, in cmd_show_vols
    sess = get_session(args)
  File "/root/.local/lib/python2.7/site-packages/bedup/__main__.py", line 105, in get_session
    upgrade_schema(engine, database_exists)
  File "/root/.local/lib/python2.7/site-packages/bedup/migrations.py", line 38, in upgrade_schema
    context = MigrationContext.configure(engine.connect())
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/engine/base.py", line 1678, in connect
    return self._connection_cls(self, **kwargs)
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/engine/base.py", line 59, in __init__
    self.__connection = connection or engine.raw_connection()
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/engine/base.py", line 1747, in raw_connection
    return self.pool.unique_connection()
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/pool.py", line 272, in unique_connection
    return _ConnectionFairy._checkout(self)
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/pool.py", line 608, in _checkout
    fairy = _ConnectionRecord.checkout(pool)
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/pool.py", line 425, in checkout
    rec = pool._do_get()
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/pool.py", line 838, in _do_get
    c = self._create_connection()
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/pool.py", line 277, in _create_connection
    return _ConnectionRecord(self)
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/pool.py", line 402, in __init__
    pool.dispatch.connect(self.connection, self)
  File "/root/.local/lib/python2.7/site-packages/sqlalchemy/event/attr.py", line 247, in __call__
    fn(*args, **kw)
  File "/root/.local/lib/python2.7/site-packages/bedup/__main__.py", line 89, in sql_setup
    assert val == ('wal',), val
AssertionError: (u'delete',)

gargamel:/mnt/dshelf2/backup# bedup dedup --db-path dedup --defrag .
also fails the same way

Last thing that happens is
open("/usr/lib/python2.7/lib-tk/_sqlite3module.so", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
open("/usr/lib/python2.7/lib-tk/_sqlite3.py", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
open("/usr/lib/python2.7/lib-tk/_sqlite3.pyc", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/python2.7/lib-dynload/_sqlite3", 0xff921890) = -1 ENOENT (No such file or directory)
open("/usr/lib/python2.7/lib-dynload/_sqlite3.i386-linux-gnu.so", O_RDONLY|O_LARGEFILE) = 5
open("/usr/lib/python2.7/lib-dynload/_sqlite3.i386-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 6
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib/libsqlite3.so.0", O_RDONLY|O_CLOEXEC) = 6
getcwd("/mnt/dshelf2/backup", 1024)     = 20
stat64("/mnt/dshelf2/backup/dedup", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
open("/mnt/dshelf2/backup/dedup", O_RDWR|O_CREAT|O_LARGEFILE, 0644) = 3
Traceback (most recent call last):
  File "/usr/local/bin/bedup", line 9, in <module>
open("/usr/local/bin/bedup", O_RDONLY|O_LARGEFILE) = 4
    load_entry_point('bedup==0.9.0', 'console_scripts', 'bedup')()
  File "/root/.local/lib/python2.7/site-packages/bedup-0.9.0-py2.7-linux-x86_64.egg/bedup/__main__.py", line 487, in script_main
(...)

Any suggestions?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
