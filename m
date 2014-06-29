Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41596 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbaF2RPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 13:15:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X1Igw-0000LX-AA
	for linux-btrfs@vger.kernel.org; Sun, 29 Jun 2014 19:15:02 +0200
Received: from hsi-kbw-109-192-123-063.hsi6.kabel-badenwuerttemberg.de ([109.192.123.63])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 19:15:02 +0200
Received: from mailinglists by hsi-kbw-109-192-123-063.hsi6.kabel-badenwuerttemberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 19:15:02 +0200
To: linux-btrfs@vger.kernel.org
From: Florian Lindner <mailinglists@xgm.de>
Subject: Scrub being stuck
Date: Sun, 29 Jun 2014 19:14:28 +0200
Message-ID: <lophhk$nj1$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've just completed a scrub on my home filesystem and now I wanted to start 
on my Archiv btrfs RAID 0.

root@horus ~ # uname -
a                                                                                                                                                                                                                 
Linux horus 3.15.2-1-ARCH #1 SMP PREEMPT Fri Jun 27 07:41:19 CEST 2014 
x86_64 GNU/Linux

root@horus ~ # btrfs --version        
Btrfs v3.14.2-dirty

root@horus ~ # btrfs fi show          
Label: 'home'  uuid: 571009c0-6cc4-4598-a77b-f175501d23fd
        Total devices 1 FS bytes used 2.03TiB
        devid    1 size 2.73TiB used 2.04TiB path /dev/sdb1

Label: 'Archiv'  uuid: b2504193-efeb-4ef3-8797-a8d73536a416
        Total devices 2 FS bytes used 5.14TiB
        devid    1 size 2.73TiB used 2.73TiB path /dev/sdd1
        devid    2 size 2.73TiB used 2.73TiB path /dev/sde1

Btrfs v3.14.2-dirty

root@horus ~ # btrfs fi df /mnt/Archiv
Data, RAID0: total=5.44TiB, used=5.13TiB
Data, single: total=8.00MiB, used=244.00KiB
System, RAID1: total=32.00MiB, used=396.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=10.94GiB, used=8.71GiB
unknown, single: total=512.00MiB, used=0.00

root@horus ~ # btrfs scrub status /mnt/Archiv 
scrub status for b2504193-efeb-4ef3-8797-a8d73536a416
        scrub started at Thu Jan  2 21:13:35 2014, running for 1336 seconds
        total bytes scrubbed: 473.28GiB with 0 errors

root@horus ~ # btrfs scrub cancel /mnt/Archiv
ERROR: scrub cancel failed on /mnt/Archiv: not running

root@horus ~ # btrfs scrub resume 
/mnt/Archiv                                                                                                                                                                                           
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /mnt/Archiv'.
To see the status use 'btrfs scrub status [-d] /mnt/Archiv'.

root@horus ~ # btrfs scrub start 
/mnt/Archiv                                                                                                                                                                                            
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /mnt/Archiv'.
To see the status use 'btrfs scrub status [-d] /mnt/Archiv'.


A scrub I started at Jan 02 seems to be stuck somehow. The command outputs 
above were generated right now.

I'll be hapy to provide any more information.

Thx!

Florian

