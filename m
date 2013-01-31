Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43468 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3AaNoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 08:44:14 -0500
Received: from merkaba.localnet (ppp-93-104-144-28.dynamic.mnet-online.de [93.104.144.28])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 14DE8AC
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 14:43:39 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: /home on BTRFS on SSD, now highly fragmenting virtuoso database - use autodefrag?
Date: Thu, 31 Jan 2013 14:44:12 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201301311444.12314.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Today I converted my /home from Ext4 to BTRFS by reformatting and copying
all over again.

I created the filesystem with -l 16384 -n 16384 -d single -m single on an
logical volume Intel SSD 320 and mount with compress=lzo,spacecache. Current state:

merkaba:~> btrfs filesystem show
failed to read /dev/sr0
Label: 'home'  uuid: […]
        Total devices 1 FS bytes used 191.98GB
        devid    1 size 223.52GB used 193.02GB path /dev/dm-2
[…]
merkaba:~> btrfs filesystem df /
Data: total=14.01GB, used=9.98GB
System: total=4.00MB, used=4.00KB
Metadata: total=776.00MB, used=573.20MB



Works well so far and I see no issues.


Except for a highly fragmenting file:

martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> ls -lh
insgesamt 1,2G
-rw------- 1 martin martin 1,3G Jan 31 14:07 soprano-virtuoso.db
-rw-r--r-- 1 martin martin   14 Jan 31 14:06 soprano-virtuoso.lck
-rw------- 1 martin martin    0 Jan 27 17:52 soprano-virtuoso.lock
-rw-r--r-- 1 martin martin  13K Jan 31 10:22 soprano-virtuoso.log
-rw-r--r-- 1 martin martin    0 Jan 27 17:52 soprano-virtuoso.pxa
-rw-r--r-- 1 martin martin 8,0M Jan 31 14:07 soprano-virtuoso-temp.db
-rw-r--r-- 1 martin martin  14K Jan 31 14:07 soprano-virtuoso.trx


martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sudo filefrag soprano-virtuoso.db
[sudo] password for martin: 
soprano-virtuoso.db: 481 extents found
[…]

martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sudo btrfs filesystem defragment 
soprano-virtuoso.db
martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend#20> sudo filefrag soprano-
virtuoso.db                   
soprano-virtuoso.db: 481 extents found
[…]
martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sync
martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sudo filefrag soprano-virtuoso.db
soprano-virtuoso.db: 57 extents found
martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sudo filefrag soprano-virtuoso.db
[sudo] password for martin: 
soprano-virtuoso.db: 3946 extents found
martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sudo filefrag soprano-virtuoso.db
soprano-virtuoso.db: 15143 extents found
martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> 

martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sudo filefrag soprano-virtuoso.db
soprano-virtuoso.db: 15900 extents found



Now I do not perceive any bottle neck so far and this is an SSD.

What would be your recommendation: Add autodefrag to mount options or not?

For now I am inclined to let it run that way and see how it goes. I am a bit
reluctant about autodefrag cause of the additional writes it causes.


Well, a direct dd of the file to memory is still quite fast:

merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> echo 3 > 
/proc/sys/vm/drop_caches; LANG=C dd if=soprano-virtuoso.db of=/dev/null bs=1M
1322+0 records in
1322+0 records out
1386217472 bytes (1.4 GB) copied, 5.34167 s, 260 MB/s


Another database is the Akonadi database, but I am using PostgreSQL for this at
the moment which tends to use lots of (smaller) files and due to KDE PIM from
KDE SC 4.4.11 still in Debian, there is no mail metadata in it, just contacts and
calendar metadata.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
