Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shiva.centershock.net ([85.214.87.241]:35506 "EHLO
	h1774498.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3HKNyY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 09:54:24 -0400
Received: from horus.localnet (host44-2.natpool.mwn.de [138.246.2.44])
	by h1774498.stratoserver.net (Postfix) with ESMTPSA id 15FBE21F8157
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Aug 2013 15:44:11 +0200 (CEST)
From: Florian Lindner <mailinglists@centershock.net>
To: linux-btrfs@vger.kernel.org
Subject: (un)mounting takes a long time
Date: Sun, 11 Aug 2013 15:44:10 +0200
Message-ID: <2929473.GGcWYBHif4@horus>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I'm using ArchLinux with kernel Linux horus 3.10.5-1-ARCH #1 SMP PREEMPT. 
Mounting and unmounting takes a long time:

# time mount -v /mnt/Archiv         
mount: /dev/sde1 mounted on /mnt/Archiv.
mount -v /mnt/Archiv  0,00s user 0,16s system 1% cpu 9,493 total

# sync && time umount -v /mnt/Archiv
umount: /mnt/Archiv (/dev/sdd1) unmounted
umount -v /mnt/Archiv  0,00s user 0,33s system 1% cpu 23,247 total

fstab:

LABEL=Archiv    /mnt/Archiv             btrfs           defaults,compress=zlib 
0 0

Archiv is a RAID 0 comprised of two discs:

Label: 'Archiv'  uuid: b2504193-efeb-4ef3-8797-a8d73536a416
        Total devices 2 FS bytes used 1.99TB
        devid    2 size 2.73TB used 1023.01GB path /dev/sde1
        devid    1 size 2.73TB used 1023.03GB path /dev/sdd1

Are un(mounting) times like these normal?

Regards,
Florian
