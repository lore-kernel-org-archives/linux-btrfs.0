Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56944 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab3EIJ01 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 May 2013 05:26:27 -0400
Received: from mailout-de.gmx.net ([10.1.76.32]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lqod2-1U5Ay8202c-00eHyI for
 <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 11:26:26 +0200
Message-ID: <518B6BC1.8020504@gmx.de>
Date: Thu, 09 May 2013 11:26:25 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: syslog message repeated 3x
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm just curious why the last of the following 3 commands :

$> dd if=/dev/zero of=/mnt/ramdisk/disk1 bs=1M count=257
$> yes | /sbin/mkfs.btrfs /mnt/ramdisk/disk1
$> mount -o loop /mnt/ramdisk/disk1 /mnt/t

gives 3x the same log message :

2013-05-09T11:23:00.230+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-a2a7-066e9384c901 devid 1 transid 4 /dev/loop1
2013-05-09T11:23:00.581+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-a2a7-066e9384c901 devid 1 transid 4 /dev/loop1
2013-05-09T11:23:00.583+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-a2a7-066e9384c901 devid 1 transid 4 /dev/loop1

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
