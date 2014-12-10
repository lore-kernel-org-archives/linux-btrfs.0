Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:44449 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaLJWTJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 17:19:09 -0500
Message-ID: <5488C6CF.1080608@pobox.com>
Date: Wed, 10 Dec 2014 14:18:55 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I started looking at the mkfs.btrfs manual page with an eye towards 
documenting some of the tidbits like metadata automatically switching 
from dup to raid1 when more than one device is used.

In experimenting I ended up with some questions...

(1) why is the dup profile for data restricted to only one device and 
only if it's mixed mode?

Gust t # mkfs.btrfs -f /dev/loop{0..1} -d dup
Error: unable to create FS with data profile 16 (have 2 devices)

Gust t # mkfs.btrfs -f /dev/loop0 -d dup
Error: dup for data is allowed only in mixed mode


(2) why is metadata dup profile restricted to only one device on 
creation when it will run that way just fine after a device add?

Gust t # mkfs.btrfs -f /dev/loop{0..1} -m dup
Error: unable to create FS with metadata profile 32 (have 2 devices)

(3) why can I make a raid5 out of two devices? (I understand that we are 
currently just making mirrors, but the standard requires three devices 
in the geometry etc. So I would expect a two device RAID5 to be 
considered degraded with all that entails. It just looks like its asking 
for trouble to allow this once the support is finalized as suddenly a 
working RAID5 thats really a mirror would become something that can only 
be mounted with the degraded flag.)

Gust t # mkfs.btrfs -f /dev/loop{0..1} -d raid5 -m raid5
Btrfs v3.17.1
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (2.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
Turning ON incompat feature 'raid56': raid56 extended format
Performing full device TRIM (2.00GiB) ...
adding device /dev/loop1 id 2
fs created label (null) on /dev/loop0
         nodesize 16384 leafsize 16384 sectorsize 4096 size 4.00GiB


(4) Same question for raid6 but with three drives instead of the 
mandated four.

(5) If I can make a RAID5 or RAID6 device with one missing element, why 
can't I make a RAID1 out of one drive, e.g. with one missing element?

(6) If I make a RAID1 out of three devices are there three copies of 
every extent or are there always two copies that are semi-randomly 
spread across three devices? (ibid for more than three).

---

It seems to me (very dangerous words in computer science, I know) that 
we need a "failed" device designator so that a device can be in the 
geometry (e.g. have a device ID) but not actually exist. Reads/writes to 
the failed device would always be treated as error returns.

The failed device would be subject to replacement with "btrfs dev 
replace", and could be the source of said replacement to drop a 
problematic device out of an array.

EXAMPLE:
Gust t # mkfs.btrfs -f /dev/loop0 failed -d raid1 -m raid1
Btrfs v3.17.1
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (2.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
Processing explicitly missing device
adding device (failed) id 2 (phantom device)

mount /dev/loop0 /mountpoint

btrfs replace start 2 /dev/loop1 /mountpoint

(and so on)

Being able to "replace" a faulty device with a phantom "failed" device 
would nicely disambiguate the whole device add/remove versus replace 
mistake.

It would make the degraded status less mysterious.

A filesystem with an explicitly failed element would also make the 
future roll-out of full RAID5/6 less confusing.
