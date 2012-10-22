Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:42370 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab2JVTgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 15:36:33 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50857C8F.9030401@gmail.com>
Date: Mon, 22 Oct 2012 13:36:31 -0600
Message-Id: <E9CD3D97-968D-4475-A699-95D803210DF1@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <50857C8F.9030401@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 22, 2012, at 11:04 AM, Goffredo Baroncelli <kreijack@gmail.com> wrote:

> Which version of "btrfs" tool are you using ? There was a bug on this.
> Try the latest.

No idea.

On Oct 22, 2012, at 11:18 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>   It's more like a balance which moves everything that has some (part
> of its) existence on a device. So when you have RAID-0 or RAID-1 data,
> all of the related chunks on other disks get moved too (so in RAID-1,
> it's the mirror chunk as well as the chunk on the removed disk that
> gets rewritten).

Does this mean "device delete" depends on an ability to make writes to the device being removed? I immediately think of SSD failures, which seem to fail writing, while still being able to reliably read. Would that behavior inhibit the ability to remove the device from the volume?


>> [ 2152.257163] btrfs: no missing devices found to remove
>> 
>> So they're missing but not missing?
> 
>   If you run sync, or wait for 30 seconds, you'll find that fi show
> shows the correct information again -- btrfs fi show reads the
> superblocks directly, and if you run it immediately after the dev del,
> they've not been flushed back to disk yet.


Even after an hour, btrfs fi show says there are missing devices. After mkfs.btrfs on that "missing" device, 'btrfs fi show' no longer shows the missing device message.


>   I think we should probably default to single on multi-device
> filesystems, not RAID-0, as this kind of problem bites a lot of
> people, particularly when trying to drop the second disk in a pair.

I'm not thinking of an obvious advantage raid0 has over single other than performance. It seems the more common general purpose use case is better served by single, especially the likelihood of volumes being grown with arbitrary drive capacities.

I found this [1] thread discussing a case where a -d single volume is upgraded to the raid0 profile. I'm not finding this to be the case when trying it today. mkfs.btrfs on 1 drive, then adding a 2nd drive, produces:
Data: total=8.00MB, used=128.00KB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=409.56MB, used=24.00KB
Metadata: total=8.00MB, used=0.00

This appears to retain the single profile. This is expected at this point? What I find a bit problematic is that metadata is still DUP rather than being automatically upgraded to raid1.

What is the likelihood of a mkfs.btrfs 2+ device change in the default data profile from raid0 to single?


[1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16278