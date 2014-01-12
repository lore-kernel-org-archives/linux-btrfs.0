Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:60597 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALUYi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 15:24:38 -0500
Received: from frontend1.mail.m-online.net (unknown [192.168.8.180])
	by mail-out.m-online.net (Postfix) with ESMTP id 3f2TtX4bPtz4KK2J
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 21:24:36 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.68])
	by mail.m-online.net (Postfix) with ESMTP id 3f2TtX2hsqzbbfS
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 21:24:36 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.8.180])
	by localhost (dynscan1.mail.m-online.net [192.168.6.68]) (amavisd-new, port 10024)
	with ESMTP id APuS5HP__e08 for <linux-btrfs@vger.kernel.org>;
	Sun, 12 Jan 2014 21:24:35 +0100 (CET)
Received: from mail.kuther.net (ppp-188-174-36-10.dynamic.mnet-online.de [188.174.36.10])
	by mail.mnet-online.de (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 21:24:34 +0100 (CET)
Received: from [192.168.1.2] (kuther.net [192.168.1.2])
	by mail.kuther.net (Postfix) with ESMTPSA id 186771AD7653
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 21:24:32 +0100 (CET)
Message-ID: <52D2F9FF.5060905@kuther.net>
Date: Sun, 12 Jan 2014 21:24:31 +0100
From: Thomas Kuther <tom@kuther.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Issues with "no space left on device" maybe related to 3.13 and/or
 kvm disk image fragmentation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm experiencing an interesting issue with the BTRFS filesystem on my
SSD drive. It first occured some time after the upgrade to kernel
3.13-rc (-rc3 was my first 3.13-rc) but I'm not sure if it is related.

The obvious symptoms are that services on my system started crashing
with "no space left on device" errors.

└» mount |grep "/mnt/ssd"
/dev/sda2 on /mnt/ssd type btrfs
(rw,noatime,compress=lzo,ssd,noacl,space_cache)

└» btrfs fi df /mnt/ssd
Data, single: total=113.11GiB, used=90.02GiB
System, DUP: total=64.00MiB, used=24.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=3.00GiB, used=2.46GiB


I use snapper on two subvolumes of that BTRFS volume (/ and /home) -
each keeping 7 daily snapshots and up to 10 hourlys.

When I saw those errors I started to delete most of the older snapshots,
and the issue went away instantly, but this couldn't be a solution nor a
workaround.

I do though have a "usual suspect" on that BTRFS volume. A KVM disk
image of a Win8 VM (I _need_ Adobe Lightroom)

» lsattr /mnt/ssd/kvm-images/
---------------C /mnt/ssd/kvm-images/Windows_8_Pro.qcow2

So the image has CoW disabled. Now comes the interesting part:
I'm trying to copy off the image to my raid5 array (BTRFS ontop of a
mdraid 5 - absolutely no issues with that one), but the cp process seems
like it's stalled.

After one hour the size of the destination copy is still 0 bytes. iotop
almost constantly show values like

 TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 4636 be/4 tom        14.40 K/s    0.00 B/s  0.00 %  0.71 % cp
/mnt/ssd/kvm-images/Windows_8_Pro.qcow2 .

It tries to read the file with some 14K/s and writes absolutely nothing.

Any idea what's going wrong here, or suggestions how to get that qcow
file copied off? I do have a backup, but honestly that one is quite aged
- so simply rm'ing it would be the very last thing I'd like to try.

Regards,
Tom

PS: please reply-to-all, I'm not subscribed. Thanks.

