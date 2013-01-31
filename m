Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:57262 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab3AaUfn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 15:35:43 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping process which writes a lot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <510AC367.2070605@statystyka.net>
Date: Thu, 31 Jan 2013 13:35:41 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <1D33B281-7EAD-4E78-B1D1-3F5D9ED60F7B@colorremedies.com>
References: <510934E6.7080302@statystyka.net> <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com> <5109C2A8.7090005@statystyka.net> <150353F1-2795-4FDD-A1F4-8F544813E7A0@colorremedies.com> <510A4DF5.8020308@statystyka.net> <D0563603-0770-4058-9A40-030FE1A127B7@colorremedies.com> <510AC367.2070605@statystyka.net>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 31, 2013, at 12:17 PM, Adam Ryczkowski <adam.ryczkowski@statystyka.net> wrote:
>>> 
>> When you create a btrfs file system, by default the data profile is single, and metadata profile is dup. When you add another device to the volume, it stays this way. The single data profile behaves similar to LVM linear, except btrfs will alternate chunk allocations between devices, so that one isn't just sitting there spinning for a month and not being used at all.
>> 
>> So it's not striping. But even if it were striping, that would help you on write performance in particular because now it's effectively RAID 60. I don't see why striping is considered fragmentation.
> Well, if the devices are on the same physical hard-drive, than sequential file reading would cause hard drive heads to seek between the first and the other partition on every extent. This is something equivalent to defragmentation;

You wouldn't make the volume larger by adding devices in this case regardless of the profile used. You'd first grow the underlying layers. And then resize the file system.

> it is only good if the partitions are on separate hard drives.

Yes obviously. But even better is to not partition your devices at all if you're concerned about efficiency. Just use the whole drive as the device.


Chris Murphy

