Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([203.199.60.171]:57475 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLZPgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 10:36:55 -0500
From: Ankur Tank <Ankur.Tank@LntTechservices.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs doesn't format eMMC if previous filesystem is ext4
Date: Fri, 26 Dec 2014 15:24:59 +0000
Message-ID: <CFB3B8F56DDE9F45B45EBDEBED372A6644232D@POCITMSEXMB05.LntUniverse.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I wanted to test btrfs on the eMMC of beaglebone black based custom board.
Precondition: eMMC is formatted with ext4 filesystem
Use case:
        Format eMMC with mkfs.btrfs  -L  <label>  <dev>
Result:
        Mkfs.btrfs denies formatting eMMC because its existing filesystem

# mkfs.btrfs -L "1storage" /dev/mmcblk0p2
/dev/mmcblk0p2 appears to contain an existing filesystem (ext4).
Error: Use the -f option to force overwrite.

If I add "-f" its possible to format the eMMC.

# mkfs.btrfs -f -L "1storage" /dev/mmcblk0p2
Detected a SSD, turning off metadata duplication.  Mkfs with -m dup if you want to force metadata duplication.
Btrfs v3.17
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (1.72GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
[273917.692896] btrfs: device label 1storage devid 1 transid 3 /dev/mmcblk0p2
fs created label 1storage on /dev/mmcblk0p2
        nodesize 16384 leafsize 16384 sectorsize 4096 size 1.72GiB

I had downloaded debian package from following link
https://packages.debian.org/sid/armhf/btrfs-tools/download

Is it a bug ? or I am missing something ?

Thank you,

Regards,
Ankur
L&T Technology Services Ltd

www.LntTechservices.com<http://www.lnttechservices.com/>

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
