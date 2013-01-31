Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:32840 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862Ab3AaTIi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:08:38 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping process which writes a lot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <510A4DF5.8020308@statystyka.net>
Date: Thu, 31 Jan 2013 12:08:25 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D0563603-0770-4058-9A40-030FE1A127B7@colorremedies.com>
References: <510934E6.7080302@statystyka.net> <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com> <5109C2A8.7090005@statystyka.net> <150353F1-2795-4FDD-A1F4-8F544813E7A0@colorremedies.com> <510A4DF5.8020308@statystyka.net>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 31, 2013, at 2:45 AM, Adam Ryczkowski <adam.ryczkowski@statystyka.net> wrote:
>> 
> Yes, you are right. It is important contributing factor, why relatime mount option killed my performance so badly.

So is this what was causing the problem?

>> 
> The dedup chunk size isn't clearly stated, but from the README I infer it deduplicates files as a whole; here is an excerpt from the README (https://github.com/g2p/bedup/blob/master/README.rst)

I wouldn't expect reading file metadata, 

> This is a summary of the granurality of the allocation pieces in the storage hierarchy.
> On mdadm I have chunk size of 512K,

It's quite large for your use case. It's large for most any use case, actually.

> I couldn't find any command that tells me the leaf size of already created btrfs system. Maybe you can tell me?

I don't know that it's easily determined after mkfs time, someone else can maybe answer. Default is 4KB. Otherwise you use flags to set it.


> I will also check, if there is an alignment problem as well. When I was reading a manual for each of the layer I came to the conclusion that each layer is supposed to align to the underlying one automatically. But I try to can check it.

I'm not thinking of an alignment problem, but a poor chosen chunk size for the usage problem. Changing 50 bytes (could be metadata or data), means in your case at least 2MB of RMW with a 512KB chunk. And this gets worse with more disks, because you have more chunks to read. The whole stripe is read, modified, and written on md raid6 currently. You're planning to add four more disks, so that's now 8 disks, and a 4MB full stripe RMW for 50 bytes of changed data.

Depending on what GPT partitioned these 3TB disks, it's remotely possible they aren't aligned to 4K sectors however. gdisk should do this correctly by starting the first partition at LBA 2048, and aligning to 16 sector boundaries. parted of recent versions does something similar, but I forget the details. Older versions can misalign by starting at LBA 63, as can other older non-Linux tools. OS X's Disk Utility starts the first partition at LBA 40 which is OK.

> Can you tell me more? Because I have only learned, that btrfs multi-device support cannot join two volumes without striping. And striping in this case is equivalent to fragmentation, which we want to avoid. In contrast to what LVM can do. LVM can concatenate the underlying storage together, without striping.

When you create a btrfs file system, by default the data profile is single, and metadata profile is dup. When you add another device to the volume, it stays this way. The single data profile behaves similar to LVM linear, except btrfs will alternate chunk allocations between devices, so that one isn't just sitting there spinning for a month and not being used at all. 

So it's not striping. But even if it were striping, that would help you on write performance in particular because now it's effectively RAID 60. I don't see why striping is considered fragmentation.

To change the profile for the volume, you use -dconvert and/or -mconvert with a rebalance operation.

Chris Murphy