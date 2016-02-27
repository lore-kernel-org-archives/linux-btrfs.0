Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:47786 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbcB0Vgw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 16:36:52 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aZmCQ-0001Fp-HZ
	for linux-btrfs@vger.kernel.org; Sat, 27 Feb 2016 22:14:50 +0100
Date: Sat, 27 Feb 2016 22:14:50 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Again, no space left on device while rebalancing and recipe  doesnt
 work
Message-ID: <20160227211450.GS26042@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have again the issue of no space left on device while rebalancing
(with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):

mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
ERROR: error during balancing '/mnt/fanbtr': No space left on device
mh@fan:~$ sudo btrfs fi show /mnt/fanbtr
mh@fan:~$ sudo btrfs fi show -m
Label: 'fanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
        Total devices 1 FS bytes used 116.49GiB
        devid    1 size 417.19GiB used 177.06GiB path /dev/mapper/fanbtr
mh@fan:~$ sudo btrfs fi df /mnt/fanbtr
Data, single: total=113.00GiB, used=112.77GiB
System, DUP: total=32.00MiB, used=48.00KiB
Metadata, DUP: total=32.00GiB, used=3.72GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
mh@fan:~$

The filesystem was recently resized from 300 GB to 420 GB.

Why does btrfs fi show /mnt/fanbtr not give any output? Wy does btrfs
fi df /mnt/fanbtr say that my data space is only 113 GiB large?

btrfs balance start -dusage=5 works up to -dusage=100:

mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
Done, had to relocate 111 out of 179 chunks
mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
Done, had to relocate 111 out of 179 chunks
mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
Done, had to relocate 110 out of 179 chunks
mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
Done, had to relocate 109 out of 179 chunks
mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
ERROR: error during balancing '/mnt/fanbtr': No space left on device
mh@fan:~$

What is going on here? How do I get away from here?

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
