Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:62609 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbcCPSzn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 14:55:43 -0400
Received: from [192.168.0.88] (p5B0A1C58.dip0.t-ipconnect.de [91.10.28.88])
	by postfix.iai.uni-bonn.de (Postfix) with ESMTP id 3E62B5C452
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 19:49:31 +0100 (MET)
	(envelope-from ochmann@informatik.uni-bonn.de)
	(envelope-to linux-btrfs@vger.kernel.org) (1)
	(internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
To: linux-btrfs@vger.kernel.org
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Subject: Mounting RAID1 degraded+rw only works once
Message-ID: <56E9AAB9.6070408@informatik.uni-bonn.de>
Date: Wed, 16 Mar 2016 19:49:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying to understand how to correctly handle and recover from 
degraded RAID1 setups in btrfs. In particular, I don't understand a 
behavior I'm seeing which somehow takes part of the advantage away from 
the idea of having a RAID for me.

The main issue I have is as follows. I can mount a RAID1 with missing 
devices using the "degraded" option. So far so good. I know I should add 
another device at that point, but let's say I don't have a device ready 
but need to keep my system running. The problem is that once I write 
some data to the device and unmount it, I cannot mount it degraded+rw 
again but only degraded+ro. And at that point I can't make changes such 
as adding new devices and rebalancing as far as I see, rendering the 
degraded RAID useless for me for keeping the system running.

Example:

- Create RAID1 (data+metadata) with 2 devices

- mount the filesystem

- btrfs fi df /something:

Data, RAID1: total=112.00MiB, used=40.76MiB
System, RAID1: total=8.00MiB, used=16.00KiB
Metadata, RAID1: total=32.00MiB, used=768.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

- unmount

- Destroy one of the devices (dd over it or whatever)

- mount with "-o degraded"

- Write some data to the device (not sure if this is strictly necessary).

- unmount the filesystem

- Try to mount with "-o degraded" again. It doesn't allow you to do so 
(if it does, try to unmount and mount again, sometimes it needs two 
tries). dmesg says "missing devices(1) exceeds the limit(0), writable 
mount is not allowed"

- mounting with "-o degraded,ro" works.

- btrfs fi df [dev]:

Data, RAID1: total=112.00MiB, used=40.76MiB
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=8.00MiB, used=0.00B
Metadata, RAID1: total=32.00MiB, used=768.00KiB
Metadata, single: total=28.00MiB, used=80.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

Now there is some RAID1 and some single data. Which could make sense 
since writing to the device in degraded mode could only be done on the 
single device. Still, I cannot make changes to the filesystem now and 
can "only" recover the data from it, but that's not really the idea of a 
RAID1 in my opinion.

Any advice?

Versions:
- Kernel 4.4.5-1-ARCH
- btrfs-progs 4.4.1

Best regards
Sebastian
