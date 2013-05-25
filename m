Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48805 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3EYRgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 13:36:06 -0400
Received: from merkaba.localnet (ppp-93-104-137-191.dynamic.mnet-online.de [93.104.137.191])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 3D2DEC5
	for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 19:35:50 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: No space left on device with 3.10-rc2
Date: Sat, 25 May 2013 19:36:03 +0200
Message-ID: <6232345.YVWHbJQOVs@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Now I got it myself what I read again and again on this mailinglist: During apt-get upgrade I get no space left on device.

But there is:

merkaba:~> df -hT /
Dateisystem                Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/mapper/merkaba-debian btrfs   19G     14G  4,6G   76% /


merkaba:[…]> ./btrfs fi df /
Disk size:                18.62GB
Disk allocated:           18.62GB
Disk unallocated:            0.00
Used:                     13.79GB
Free (Estimated):          4.84GB       (Max: 4.84GB, min: 4.84GB)
Data to disk ratio:         100 %
merkaba:[…]> ./btrfs fi disk-usage /
Data,Single: Size:17.61GB, Used:13.04GB
   /dev/mapper/merkaba-debian      17.61GB

Metadata,Single: Size:1.01GB, Used:768.00MB
   /dev/mapper/merkaba-debian       1.01GB

System,Single: Size:4.00MB, Used:4.00KB
   /dev/mapper/merkaba-debian       4.00MB

Unallocated:
   /dev/mapper/merkaba-debian         0.00
merkaba:[…]> ./btrfs dev disk-usage /
/dev/mapper/merkaba-debian         18.62GB
   Data,Single:             17.61GB
   Metadata,Single:          1.01GB
   System,Single:            4.00MB
   Unallocated:                0.00

merkaba:[…]> ./btrfs fi sh
[…]

Label: 'debian'  uuid: […]
        Total devices 1 FS bytes used 13.79GB
        devid    1 size 18.62GB used 18.62GB path /dev/dm-0

Btrfs v0.19-367-g711b24a



I think I will let it run a rebalance. Not working as well:

merkaba:~> btrfs fi ba /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#19> dmesg | tail
[…]
[72914.023312] btrfs: relocating block group 19348324352 flags 1
[72914.131856] btrfs: 24 enospc errors during balance



merkaba:~#1> btrfs ba start -musage=5 / 
Done, had to relocate 0 out of 24 chunks
merkaba:~> btrfs ba start -m /       
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#19> btrfs ba start -musage=20 /
Done, had to relocate 0 out of 24 chunks
merkaba:~> btrfs ba start -musage=80 /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#19> btrfs ba start -musage=20 /
Done, had to relocate 0 out of 24 chunks
merkaba:~> btrfs ba start -musage=30 /
Done, had to relocate 0 out of 24 chunks
merkaba:~> btrfs ba start -musage=40 /
Done, had to relocate 0 out of 24 chunks
merkaba:~> btrfs ba start -musage=50 / 
Done, had to relocate 0 out of 24 chunks
merkaba:~> btrfs ba start -musage=60 /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#19> dmesg | tail
[…]
[72914.023312] btrfs: relocating block group 19348324352 flags 1
[72914.131856] btrfs: 24 enospc errors during balance
[72994.276484] btrfs: 5 enospc errors during balance
[73004.238190] btrfs: 4 enospc errors during balance
[73019.385757] btrfs: 1 enospc errors during balance


How do I get this filesystem to an operational state again despite
reformatting?

Seems there are still no space left on device bugs left. Or some have been
introduced with 3.10.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
