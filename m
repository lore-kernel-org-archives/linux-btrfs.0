Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout1.rambler.ru ([81.19.67.203]:54625 "EHLO mxout1.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbbDBTt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 15:49:29 -0400
Received: from saddam4.rambler.ru (saddam4.rambler.ru [10.32.16.4])
	by mxout1.rambler.ru (Postfix) with ESMTP id C8E1AC2CC3A
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2015 22:41:00 +0300 (MSK)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by saddam4.rambler.ru (Postfix) with ESMTP id B40889561C2
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2015 22:41:00 +0300 (MSK)
From: =?koi8-r?B?7cnIwcnMIOzFzdbJzg==?= <mihal@rambler.ru>
To: linux-btrfs@vger.kernel.org
Reply-To: =?koi8-r?B?7cnIwcnMIOzFzdbJzg==?= <mihal@rambler.ru>
Subject: btrfszero-log fs_image to developers
Date: Thu, 2 Apr 2015 22:41:00 +0300
Content-Type: text/plain; charset="utf-8"; format="flowed"
Message-Id: <1428003660.670888.5667.20379@mail.rambler.ru>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello!
As say in this page https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log 
I send output data of 
#btrfs-image -c 9 -t 8 /dev/mapper/root /tmp/fs_image
to developers.
File link: https://onedrive.live.com/redir?resid=31ECDF5D805029B7!403759&authkey=!AMWoAxWRnpVkJY4&ithint=file%2c

Additional informaion:
[lm@mothership ~]$ uname -a
Linux mothership 3.19.2-1-ARCH #1 SMP PREEMPT Wed Mar 18 16:21:02 CET 2015 x86_64 GNU/Linux
[lm@mothership ~]$ btrfs --version
btrfs-progs v3.19
[lm@mothership ~]$ btrfs fi show
ERROR: could not open /dev/sdb3
ERROR: could not open /dev/sdb4
btrfs-progs v3.19
[lm@mothership ~]$ btrfs fi df /
Data, single: total=18.01GiB, used=16.25GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.00GiB, used=448.55MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=160.00MiB, used=0.00B

p.s. After hard reset root partition did not mount with BTRFS: open_ctree failed error.
p.p.s. partition /dev/sdb3 has been fixed by #btrfs-zero-log /dev/sdb3
--
Best regards,
Mikhail Lemhzhin