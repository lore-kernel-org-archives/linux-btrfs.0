Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2GLTI5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 15:08:57 -0400
Message-ID: <4FFF20C6.1030303@cv-sv.de>
Date: Thu, 12 Jul 2012 21:08:54 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfsck crashes
References: <4FF9B07C.8090209@cv-sv.de> <4FFA52BC.9010401@oracle.com> <4FFB4BB4.4080408@cv-sv.de> <4FFBCC1A.8020800@oracle.com> <1462124570.240756.1341911618590.JavaMail.open-xchange@email.1und1.de> <333721177.250041.1341918535801.JavaMail.open-xchange@email.1und1.de> <4FFD278D.20804@oracle.com>
In-Reply-To: <4FFD278D.20804@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain schrieb:
>
>
>   If this is a deliberate corruption can you pls share the test-case ?
>   if not have you tried mount with recovery and the scrub. ? scrub
>   would be preferred choice over btrfsck.
>
>
>

Scrub does not fix the problem. I replaced the real host name with "myhost".
Strange for me: the mentioned pathes for errors point to the same file names,
just a part of the "myhost" is different.

The btrfsck fails with the same crash after the scrub.


speedy:/home/cv # btrfs scrub status /backup.old
scrub status for fa7034c8-86d4-4aa3-9fde-ecd7051ff43c
         scrub started at Thu Jul 12 20:21:08 2012 and finished after 1495 seconds
         total bytes scrubbed: 115.49GiB with 9 errors
         error details: verify=3 csum=6
         corrected errors: 3, uncorrectable errors: 6, unverified errors: 0

Should I continue with any analysis for bug hunting or just reformat and forget?

Best regard,
Christian

[ 5059.168649] btrfs: checksum/header error at logical 1532956672 on dev /dev/md3, sector 7204744: metadata leaf (level 0) in tree 2
[ 5059.168656] btrfs: checksum/header error at logical 1532956672 on dev /dev/md3, sector 7204744: metadata leaf (level 0) in tree 2
[ 5065.581348] btrfs: fixed up error at logical 1532956672 on dev /dev/md3
[ 5065.587844] btrfs: checksum/header error at logical 1532960768 on dev /dev/md3, sector 7204752: metadata leaf (level 0) in tree 2
[ 5065.587851] btrfs: checksum/header error at logical 1532960768 on dev /dev/md3, sector 7204752: metadata leaf (level 0) in tree 2
[ 5065.599317] btrfs: fixed up error at logical 1532960768 on dev /dev/md3
[ 5065.599500] btrfs: checksum/header error at logical 1532964864 on dev /dev/md3, sector 7204760: metadata leaf (level 0) in tree 2
[ 5065.599506] btrfs: checksum/header error at logical 1532964864 on dev /dev/md3, sector 7204760: metadata leaf (level 0) in tree 2
[ 5065.607379] btrfs: fixed up error at logical 1532964864 on dev /dev/md3
[ 5074.964900] btrfs: checksum error at logical 2327654400 on dev /dev/md3, sector 8756888: metadata leaf (level 0) in tree 5
[ 5074.964907] btrfs: checksum error at logical 2327654400 on dev /dev/md3, sector 8756888: metadata leaf (level 0) in tree 5
[ 5075.977763] btrfs: unable to fixup (regular) error at logical 2327654400 on dev /dev/md3
[ 5085.133646] btrfs: checksum error at logical 2327654400 on dev /dev/md3, sector 10854040: metadata leaf (level 0) in tree 5
[ 5085.133653] btrfs: checksum error at logical 2327654400 on dev /dev/md3, sector 10854040: metadata leaf (level 0) in tree 5
[ 5086.148842] btrfs: unable to fixup (regular) error at logical 2327654400 on dev /dev/md3
[ 6436.036292] btrfs: checksum error at logical 139801403392 on dev /dev/md3, sector 331786256, root 5, inode 2960268, offset 1345069056, length 4096, links 1 (path: int-www-mail/int-www-2012-07-05-22_28_57/srv/www/vhosts/"myhost".de/statistics/logs/access_ssl_log.processed)
[ 6436.036300] btrfs: unable to fixup (regular) error at logical 139801403392 on dev /dev/md3
[ 6454.615722] btrfs: checksum error at logical 141661282304 on dev /dev/md3, sector 335418832, root 5, inode 2968078, offset 104292352, length 4096, links 1 (path: int-www-mail/int-www-2012-07-05-22_28_57/srv/www/vhosts/"myhost".no/statistics/logs/error_log)
[ 6454.615736] btrfs: unable to fixup (regular) error at logical 141661282304 on dev /dev/md3
[ 6455.523759] btrfs: checksum error at logical 140794101760 on dev /dev/md3, sector 333725120, root 5, inode 2964438, offset 87449600, length 4096, links 1 (path: int-www-mail/int-www-2012-07-05-22_28_57/srv/www/vhosts/"myhost".fr/statistics/logs/access_log.processed)
[ 6455.523775] btrfs: unable to fixup (regular) error at logical 140794101760 on dev /dev/md3
[ 6475.865387] btrfs: checksum error at logical 143052115968 on dev /dev/md3, sector 338135304, root 5, inode 3000621, offset 1078595584, length 4096, links 1 (path: int-www-mail/int-www-2012-07-05-22_28_57/srv/www/vhosts/"otherhost".com/statistics/logs/access_log.processed)
[ 6475.865403] btrfs: unable to fixup (regular) error at logical 143052115968 on dev /dev/md3

speedy:/tmp/btrfs/btrfs-progs # ./btrfsck /dev/md3
checking extents
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
Csum didn't match
owner ref check failed [2327654400 4096]
ref mismatch on [101138354176 98304] extent item 1, found 0
Incorrect local backref count on 101138354176 root 5 owner 1867898 offset 0 found 0 wanted 1 back 0x787c260
backpointer mismatch on [101138354176 98304]
owner ref check failed [101138354176 98304]
ref mismatch on [101138452480 106496] extent item 1, found 0
Incorrect local backref count on 101138452480 root 5 owner 1867899 offset 0 found 0 wanted 1 back 0x787c2a0
backpointer mismatch on [101138452480 106496]
owner ref check failed [101138452480 106496]
ref mismatch on [101138558976 8192] extent item 1, found 0
Incorrect local backref count on 101138558976 root 5 owner 1867901 offset 0 found 0 wanted 1 back 0x2d2a700
backpointer mismatch on [101138558976 8192]
owner ref check failed [101138558976 8192]
ref mismatch on [101138567168 16384] extent item 1, found 0
Incorrect local backref count on 101138567168 root 5 owner 1867902 offset 0 found 0 wanted 1 back 0x2d2a740
backpointer mismatch on [101138567168 16384]
owner ref check failed [101138567168 16384]
ref mismatch on [101138583552 16384] extent item 1, found 0
Incorrect local backref count on 101138583552 root 5 owner 1867903 offset 0 found 0 wanted 1 back 0x2d2a780
backpointer mismatch on [101138583552 16384]
owner ref check failed [101138583552 16384]
Errors found in extent allocation tree
checking fs roots
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
Csum didn't match
btrfsck: btrfsck.c:1177: walk_down_tree: Assertion `!(1)' failed.
Abgebrochen
s
