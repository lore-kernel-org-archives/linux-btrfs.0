Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35041 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbIDJCN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 05:02:13 -0400
Received: by obuk4 with SMTP id k4so11952087obu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2015 02:02:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Sep 2015 11:02:12 +0200
Message-ID: <CANXojcwNFqT4+fc3jetTfHFUQ62JG9-rOh7jBzAJ-+BarbA5Ow@mail.gmail.com>
Subject: Announce: fuse-backup
From: Stef Bon <stefbon@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been working on a backup service. There are already
backupprograms, but I missed the ability to easiliy view and access
backups and versions.

The user can assign folders to backup using simple commands, and
assign one or more mimetypes which apply for this backup: only files
with this mimetype will be processed.

Fuse-backup makes a backup of the folder, and this backup is on a
btrfs filesystem. Everytime something has changed, a snapshot is made,
and the changes are stored in a sqlite database.

To access the backup and the contents and the versions, a fuse fs is
used. This FUSE fs presents the different files which are part of the
backup as directories, which contains the versions of this file.

For example:

[sbon@ws-001 fuse-backup]$ pwd
/srv/backupbtrfs/mount/home/sbon/Projects/fuse/fuse-backup
[sbon@ws-001 fuse-backup]$ ls -al
total 2
drwxr-xr-x 16877 sbon  1000 4096 Jun 26 10:36 .
drwxr-xr-x 16877 sbon  1000 4096 Jun 26 10:36 ..
drwxr-xr-x     2 sbon  1000    3 Jan  7  2013 AUTHORS
drwxr-xr-x     2 sbon users    1 Sep  3 17:50 ChangeLog
drwxr-xr-x     2 sbon  1000    3 Jan 19  2015 README
drwxr-xr-x     2 sbon users    7 Jul 26 17:13 backup-stat.c
drwxr-xr-x     2 sbon users    5 Jun 20 14:12 backup-stat.h
drwxr-xr-x     2 sbon users    4 Jun 23 21:14 backupjobs-base.c
drwxr-xr-x     2 sbon users    5 Jul 18 08:48 backupjobs-base.h
drwxr-xr-x     2 sbon users    3 Jun  1 09:20 backupjobs-fsevent.c
drwxr-xr-x     2 sbon users    3 Feb  5  2015 backupjobs-fsevent.h
drwxr-xr-x     2 sbon users    5 Jun 28 17:56 backupjobs-util.c
drwxr-xr-x     2 sbon users    3 Jun 22 10:06 backupjobs-util.h
drwxr-xr-x     2 sbon users   10 Sep  4 10:39 backupjobs.c
drwxr-xr-x     2 sbon  1000    1 Mar 25 18:28 backupjobs.c.keep
drwxr-xr-x     2 sbon users    5 Jul 18 08:54 backupjobs.h
drwxr-xr-x     2 sbon users    3 Apr 18 09:34 backupsync.c
drwxr-xr-x     2 sbon users    3 Feb  1  2015 backupsync.h
drwxr-xr-x     2 sbon users    3 Jun 27 21:37 config.h
drwxr-xr-x     2 sbon users    3 Jun 27 21:36 config.h.in
drwxr-xr-x     2 sbon users    3 May 31 15:43 createsnapshot.c
drwxr-xr-x     2 sbon users    3 May 31 15:43 createsnapshot.h
drwxr-xr-x     2 sbon users    5 Aug  1 16:21 db-common-base.h
--- a lot more ---


An experienced user notices that some number are not correct, like the
link count of the . and .. This is work to be done.

Now this is the backup of this program, in
/home/sbon/Projects/fuse/fuse-backup, and the mimetypes for c and c++
are used, next to the plaintext readme, changelog and readme.

View the version of backupjobs.c:

[sbon@ws-001 fuse-backup]$ ls -al backupjobs.c
total 6
drwxr-xr-x 16877 sbon users    10 Sep  4 10:39 .
drwxr-xr-x 16877 sbon  1000  4096 Jun 26 10:36 ..
-rw-r--r--     1 sbon  1000 43533 Jun  7 00:35 201506062017
-rw-r--r--     1 sbon  1000 50513 Jun 13 09:55 201506121910
-rw-r--r--     1 sbon  1000 51031 Jun 19 09:17 201506190924
-rw-r--r--     1 sbon  1000 53262 Jun 25 23:40 201506271414
-rw-r--r--     1 sbon users 53782 Jun 27 14:29 201506271447
-rw-r--r--     1 sbon users 56333 Jun 30 18:12 201506301810
-rw-r--r--     1 sbon users 56793 Jul 13 23:15 201507111959
-rw-r--r--     1 sbon users 57340 Jul 18 23:06 201507182258
-rw-r--r--     1 sbon users 62614 Aug  1 17:00 201508011659
-rw-r--r--     1 sbon users 62966 Aug  3 09:03 201508030856

Get information of a version:

[sbon@ws-001 fuse-backup]$ cd backupjobs.c
[sbon@ws-001 backupjobs.c]$ getfattr --dump --encoding=text
--match=system 201506062017
# file: 201506062017
system.db_id="57"
system.db_type="5"
system.db_version="changed:unknown"

On the project website:

https://sourceforge.net/projects/fusebackup/

you find some screenshots of a gui (listbackup, using qt5). This gui
is not complete yet. My intention is to write a plugin for Dolphin to
let users manage their backups and access versions of a file with a
few mouseclicks.

Futher I want to write a program which is able to show the differences
of versions of office files, using libreofficekit.

Stef
