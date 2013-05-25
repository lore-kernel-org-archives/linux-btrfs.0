Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33012 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3EYRyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 13:54:40 -0400
Received: from merkaba.localnet (ppp-93-104-137-191.dynamic.mnet-online.de [93.104.137.191])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id EC1E3C5
	for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 19:54:24 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: No space left on device with 3.10-rc2
Date: Sat, 25 May 2013 19:54:38 +0200
Message-ID: <4522546.qsGp52SIlN@merkaba>
In-Reply-To: <6232345.YVWHbJQOVs@merkaba>
References: <6232345.YVWHbJQOVs@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 25. Mai 2013, 19:36:03 schrieb Martin Steigerwald:
> Hi!
> 
> Now I got it myself what I read again and again on this mailinglist: During
> apt-get upgrade I get no space left on device.
> 
> But there is:
> 
> merkaba:~> df -hT /
> Dateisystem                Typ   Größe Benutzt Verf. Verw% Eingehängt auf
> /dev/mapper/merkaba-debian btrfs   19G     14G  4,6G   76% /
> 
> 
> merkaba:[…]> ./btrfs fi df /
> Disk size:                18.62GB
> Disk allocated:           18.62GB
> Disk unallocated:            0.00
> Used:                     13.79GB
> Free (Estimated):          4.84GB       (Max: 4.84GB, min: 4.84GB)
> Data to disk ratio:         100 %
> merkaba:[…]> ./btrfs fi disk-usage /
[…]
> I think I will let it run a rebalance. Not working as well:
> 
> merkaba:~> btrfs fi ba /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> merkaba:~#19> dmesg | tail
> […]
> [72914.023312] btrfs: relocating block group 19348324352 flags 1
> [72914.131856] btrfs: 24 enospc errors during balance
[…]
> How do I get this filesystem to an operational state again despite
> reformatting?

btrfs balance start worked a bit farther after apt-get clean and completed
after removing the one and only snapshot from 2013-05-01.

Still I consider this a bug.

Mount options:

martin@merkaba:~> grep "/ .*btrfs" /proc/mounts
/dev/mapper/merkaba-debian / btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0

State after removing snapshot and balance:

merkaba[…]> ./btrfs fi sh
failed to read /dev/sr0
Label: 'home'  uuid: […]
        Total devices 1 FS bytes used 197.65GB
        devid    1 size 223.52GB used 219.04GB path /dev/dm-2

Label: 'debian'  uuid: […]
        Total devices 1 FS bytes used 10.21GB
        devid    1 size 18.62GB used 11.00GB path /dev/dm-0

Btrfs v0.19-367-g711b24a

merkaba:[…]> ./btrfs fi df /
Disk size:                18.62GB
Disk allocated:           11.00GB
Disk unallocated:          7.62GB
Used:                     10.22GB
Free (Estimated):          8.41GB       (Max: 8.41GB, min: 4.59GB)
Data to disk ratio:         100 %

merkaba:[…]> ./btrfs fi disk-usage /
Data,Single: Size:10.00GB, Used:9.61GB
   /dev/mapper/merkaba-debian      10.00GB

Metadata,Single: Size:1.00GB, Used:602.45MB
   /dev/mapper/merkaba-debian       1.00GB

System,Single: Size:4.00MB, Used:4.00KB
   /dev/mapper/merkaba-debian       4.00MB

Unallocated:
   /dev/mapper/merkaba-debian       7.62GB

merkaba:[…]> ./btrfs dev disk-usage /
/dev/mapper/merkaba-debian         18.62GB
   Data,Single:             10.00GB
   Metadata,Single:          1.00GB
   System,Single:            4.00MB
   Unallocated:              7.62GB

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
