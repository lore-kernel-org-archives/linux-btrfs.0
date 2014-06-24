Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:41046 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaFXKrm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 06:47:42 -0400
Received: from [192.168.7.22] (p57BCF87A.dip0.t-ipconnect.de [87.188.248.122])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by m.nv-systems.net (Postfix) with ESMTPSA id 3ECB67D1BB8
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 12:41:51 +0200 (CEST)
Message-ID: <53A955F8.8090101@nv-systems.net>
Date: Tue, 24 Jun 2014 12:42:00 +0200
From: Gerald Hopf <gerald.hopf@nv-systems.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: "-d single" for data blocks on a multiple devices doesn't work as
 it should
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs-developers,

thank you for making such a nice and innovative filesystem. I do have a 
small complaint however :-)

I read the documentation and liked the idea of having a multiple-device 
filesystem with mirrored metadata while having data in "single" mode. 
This would be perfect for my backup purposes, where I don't want to have 
a parity disk - but I also don't want to lose the _entire_ backup in the 
worst case scenario of having already lost the main data RAID5 array and 
then one of my backup HDDs refusing to spin up or failing while restoring).

For testing purposes, I therefore created a 2x 3TB btrfs filesystem as 
described in the "Using BTRFS with Multiple Devices" Wiki:
# Use full capacity of multiple drives with different sizes (metadata 
mirrored, data not mirrored and not striped)
mkfs.btrfs -d single /dev/sdh1 /dev/sdi1

and proceeded to copy about 5.5TB of data on it, about 800 
subdirectories each containing a few small files (1-5KB), a medium sized 
file (50-100MB) and a big file (3GB-15GB). The copy process was 
completely sequential (only one task copying from source to destination, 
no random writes, no simultaneous copies to the btrfs volume).

After copying, I then unmounted the filesystem, switched off one of the 
two 3TB USB disks and mounted the remaining 3TB disk in recovery mode 
(-o degraded,ro) and proceeded to check whether any data was still left 
alive.

Result:
- the directories and files were there and looked good (metadata raid1 
seems to work)
- some small files I tested were fine (probably 50%?)
- even some the medium sized files (50-100MB) were fine (not sure about 
the percentage, might have been less than for the small files)
- not a single one (!) of the big files (3GB-15GB) survived

Conclusion:
The "-d single" allocator is useless (or broken?). It seems to randomly 
write data blocks to each of the multiple devices, thereby combining the 
disadvantage of a single disk (low write speed) with the disadvantage of 
raid0 (loss of all files when a device is missing), while not offering 
any benefits.

In my opinion to offer any benefit compared to raid0 for data, "-d 
single" should never allocate blocks for a single file across multiple 
disks unless you start to run ouf of contiguous space when the disk gets 
almost full. Is there any chance that "-d single" will be fixed at some 
point in the future?

Thanks for listening,
Gerald
