Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:35732
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab3A3X64 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 18:58:56 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping process which writes a lot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <510934E6.7080302@statystyka.net>
Date: Wed, 30 Jan 2013 16:58:51 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com>
References: <510934E6.7080302@statystyka.net>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2013, at 7:57 AM, Adam Ryczkowski <adam.ryczkowski@statystyka.net> wrote:
> 
> I suspect it has something to do with snapshots I make for backup. I have 35 of them, and I ask bedup to find duplicates across all subvolumes.


Assuming most files do have identical duplicates, implies the same file in all 35 subvolumes is actually in the same physical location; it differs only in subvol reference. But it's not btrfs that determines the "duplicate" vs "unique" state of those 35 file instances, but unison. The fs still must send all 35x instances for the state to be determined, as if they were unique files.

Another thing, I'd expect this to scale very poorly if the 35 subvolumes contain any appreciable uniqueness, because searches can't be done in parallel. So the more subvolumes you add, the more disk contention you get, but also enormous amounts of latency as possibly 35 locations on the disk are being searched if they happen to be unique.

So in either case "duplicate" vs "unique" you have a problem, just different kinds. And as the storage grows, it increasingly encounters both problems at the same time. Small problem. What size are the files?

And that's on a bare drive before you went and did this:

> My filesystem /dev/vg-adama-docs/lv-adama-docs is 372GB in size, and is a quite complex setup:
> It is based on logical volume (LVM2), which has a single physical volume made by dm-crypt device /dev/dm-1, which subsequently sits on top of /dev/md1 linux raid 6, which is built with 4 identical 186GB GPT partitions on each of my SATA 3TB hard drives.

Why are you using raid6 for four disks, instead of raid10?  What's the chunk size for the raid 6? What's the btrfs leaf size? What's the dedup chunk size?

Why are you using LVM at all, while the /dev/dm-1 is the same size as the LV? You say the btrfs volume on LV is on dm-1 which means they're all the same size, obviating the need for LVM in this case entirely.

Chris Murphy

