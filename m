Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from st11p05mm-asmtpout001.mac.com ([17.172.108.236]:51163 "EHLO
	st11p05mm-asmtp001.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935459Ab3DITbj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 15:31:39 -0400
Received: from [192.168.1.11]
 (ANantes-653-1-139-189.w90-49.abo.wanadoo.fr [90.49.26.189])
 by st11p05mm-asmtp001.mac.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Jan
  3 2012)) with ESMTPSA id <0ML00093668PSXB0@st11p05mm-asmtp001.mac.com> for
 linux-btrfs@vger.kernel.org; Tue, 09 Apr 2013 19:31:39 +0000 (GMT)
From: Olivier BATARD <obatard@icloud.com>
Content-type: text/plain; charset=us-ascii
Subject: btrfs prof compile error on debian squeeze.
Message-id: <09F43135-B6BE-4549-A42C-52A340CD522B@icloud.com>
Date: Tue, 09 Apr 2013 21:31:08 +0200
To: linux-btrfs@vger.kernel.org
MIME-version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying to build btrfs-prog on debian squeeze but when I'm trying to use make, I have an error :


pc@debian:~/b/btrfs-progs$ make
    [LD]     mkfs.btrfs
mkfs.o: In function `is_ssd':
/home/pc/b/btrfs-progs/mkfs.c:1234: undefined reference to `blkid_probe_get_wholedisk_devno'
collect2: ld returned 1 exit status
make: *** [mkfs.btrfs] Erreur 1


After a few searches over the internet, it seems that my blkid library is out of date. How can I compile btrfs prog on debian squeeze ?

Thanks !


Olivier.