Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:41538 "HELO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761994Ab2ERMEd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 08:04:33 -0400
Received: by lbbgg6 with SMTP id gg6so2537925lbb.36
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 05:04:30 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 May 2012 14:04:30 +0200
Message-ID: <CAJ6utUJHYU2hziAr2v47ZPHh3F9Ei++nK8KdEy94yPimRPUtPQ@mail.gmail.com>
Subject: Problem with restore of filesystem
From: Lars Bahner <bahner@onlinebackupcompany.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have sinned!

I had a production filesystem without a replica - which is bonked :(

Running restore ( i have tried Debian's btrfs-tools; master and
dangerdonteveruse branches version ) on kernels 3.2 and 3.3 I
consistently get this error message, and I would like suggestions as
to how i might proceed.

root@foo:/net/users/home/bahner/src/btrfs-progs# btrfs-restore -si
/dev/sdc /opt/data/restore/
failed to read /dev/sr0
failed to read /dev/sr0
parent transid verify failed on 5083380932608 wanted 332337 found 339991
parent transid verify failed on 5083380932608 wanted 332337 found 339991
parent transid verify failed on 5083380932608 wanted 332337 found 339991
parent transid verify failed on 5083380932608 wanted 332337 found 339991
Ignoring transid failure
Root objectid is 5
Skipping existing file
/opt/data/restore/data/move/treungen-s01/db/BackupSet/1322218096564/2011-11-25-14-15-41.log
If you wish to overwrite use the -o option to overwrite
btrfs-restore: disk-io.c:589: btrfs_read_fs_root: Assertion
`!(location->objectid == -8ULL || location->offset != (u64)-1)'
failed.
Aborted
root@foo:/net/users/home/bahner/src/btrfs-progs#

There is supposed to be a folder "data/users"
(/opt/data/restore/data/users) I thought i could somehow "bypass" the
rootaccess by giving a "-m 'data/users/*'"-parameter, for instance.
But thinking about I realize I was clutching a straws. And pointers in
the right direction is appreciated.

I have run find-root and tried with the latest blockid for the "-t" parameter.

Kind regards,
Lars Bahner
