Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta.plex.hu ([81.0.120.33]:47855 "EHLO mta.plex.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaILL3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 07:29:47 -0400
Received: from mail.plex.hu (assp.adverticum.local [10.1.1.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta.plex.hu (Postfix) with ESMTPS id D1E572113D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:29:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by highmoon.adverticum.local (Postfix) with ESMTP id E8E712121F
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:29:43 +0200 (CEST)
Received: from highmoon.adverticum.local ([127.0.0.1])
	by localhost (highmoon.adverticum.local [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id RiCN0Ry6SCVu for <linux-btrfs@vger.kernel.org>;
	Fri, 12 Sep 2014 13:29:43 +0200 (CEST)
Received: from highmoon.adverticum.local (highmoon.adverticum.local [10.1.1.60])
	by highmoon.adverticum.local (Postfix) with ESMTP id CBF7021204
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:29:43 +0200 (CEST)
Date: Fri, 12 Sep 2014 13:29:43 +0200 (CEST)
From: Mate Gabri <mgabri@plex.hu>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <sig.33327570cf.1177076079.237320.1410521383731.JavaMail.zimbra@plex.hu>
Subject: breathe life into degraded raid10 (no space left on specific
 device)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear List,

I tried to remove a device from a 12 disk RAID10 array but it failed with a "no space left" and the system crashed. After a reset i could only mount the array in degraded mode because the device was marked as missing. I've tried a replace command but it said that it does not support RAID5/6 arrays so i went with the device add command which added the disk to the array but there was the missing device message still so i issued the "btrfs device delete missing [path]" command which was running for more than 24 hours without happening much. Also if i try to do some disk io (rsync) the system crashes after 10-15 minutes. 

If i try to mount the array as is i get this:

[   15.649539] btrfs: failed to read chunk tree on sdc
[   15.682209] btrfs: open_ctree failed

Mounting with degraded works. Now if i try to "btrfs device delete missing" i get a no space left error on /dev/sdc. I tried to do a rebalance which worked with the data chunks but with metadata it fails with the no space left error. I've tried to delete some snapshots which happened but after that some metadata rebalance started which failed too with no space left error. I've issued a whole array scrub which complained that dev id 12 is missing. A scrub on /dev/sdc finished successfuly without any error. I'm sure that /dev/sdc is broken metadata wise but i'm afraid to remove that device too. Do you have any suggestions what sould i do?

Here's some info:

uname -a:
Linux backup 3.13-0.bpo.1-amd64 #1 SMP Debian 3.13.10-1~bpo70+1 (2014-04-23) x86_64 GNU/Linux

 btrfs --version
Btrfs v3.14.1

btrfs fi show (/dev/sdl was removed and re-added)
Label: 'backup'  uuid: 667ec955-bcaa-4175-827d-3a44eaa515bb
        Total devices 13 FS bytes used 9.29TiB
        devid    1 size 2.71TiB used 1.56TiB path /dev/sda4
        devid    2 size 2.71TiB used 1.56TiB path /dev/sdb4
        devid    3 size 2.73TiB used 1.56TiB path /dev/sdc
        devid    4 size 2.73TiB used 1.56TiB path /dev/sdd
        devid    5 size 2.73TiB used 1.56TiB path /dev/sde
        devid    6 size 2.73TiB used 1.56TiB path /dev/sdf
        devid    7 size 2.73TiB used 1.56TiB path /dev/sdg
        devid    8 size 2.73TiB used 1.56TiB path /dev/sdh
        devid    9 size 2.73TiB used 1.56TiB path /dev/sdi
        devid   10 size 2.73TiB used 1.56TiB path /dev/sdj
        devid   11 size 2.73TiB used 1.56TiB path /dev/sdk
        devid   13 size 2.73TiB used 1.75GiB path /dev/sdl
        *** Some devices missing

Btrfs v3.14.1


Data, RAID10: total=8.87TiB, used=8.79TiB
System, RAID1: total=32.00MiB, used=1.11MiB
Metadata, RAID10: total=518.72GiB, used=516.31GiB

Best regards,
--
GABRI Mate
Rendszergazda
mgabri@plex.hu | +36 (30) 450 9750

Plex Online Kft. | http://plex.hu
H-1118 Budapest, Ugron Gábor u. 35.
T: +36 (1) 445 0167 | F: +36 (1) 248 3250
