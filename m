Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:23784 "EHLO
	mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaEIRy0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 13:54:26 -0400
Received: from webmail.halifax.rwth-aachen.de (www.halifax.rwth-aachen.de [137.226.111.253])
	by mail.halifax.rwth-aachen.de (Postfix) with ESMTP id 82C221080A0
	for <linux-btrfs@vger.kernel.org>; Fri,  9 May 2014 19:44:42 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 09 May 2014 20:02:45 +0200
From: laie <laie@halifax.rwth-aachen.de>
To: linux-btrfs@vger.kernel.org
Subject: destroyed disk in btrfs raid
Message-ID: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I've some trouble with my btrf filesystem. I've lost one backing raid 
device, it's luks header is overwritten and not restoreable.

The lost disk was recently added. 'btrfs filesystem balace' was running 
for some time, but the new device is the smallest in the set.

Data is stored with Raid0, Metadata with Raid1. Degraded mounting works 
fine.

Now I'm looking for a way to tell btrfs to provide me with a list of the 
corrupted files and delete them afterwards. This would be great, because 
otherwise it would take very long to get the data back from slow 
backups.

Thanks in advance
Max


btrfs --version
Btrfs v3.12

btrfs fi show
Label: userspace  uuid: there is one ;)
         Total devices 3 FS bytes used 27.21TiB
         devid    1 size 21.83TiB used 13.03TiB path /dev/dm-3
         devid    2 size 16.37TiB used 13.01TiB path /dev/dm-2
         devid    3 size 8.19TiB used 4.27TiB path

btrfs fi df /home/
Data, RAID0: total=30.24TiB, used=27.18TiB
System, RAID1: total=32.00MiB, used=1.99MiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=32.00GiB, used=31.42GiB

