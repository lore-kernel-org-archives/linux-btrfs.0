Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32801 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755886Ab3HYFS3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 01:18:29 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Help interpreting RAID1 space allocation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <093e4c7d21b5e734c86fc4bb1703a69e@lixil.net>
Date: Sat, 24 Aug 2013 23:18:26 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D8D710C1-2FEC-41E1-A139-522F351E0464@colorremedies.com>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net> <093e4c7d21b5e734c86fc4bb1703a69e@lixil.net>
To: Joel Johnson <mrjoel@lixil.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 24, 2013, at 11:24 AM, Joel Johnson <mrjoel@lixil.net> wrote:
> 
> Similar to what Duncan described in his response, on a hot-remove (without doing the proper btrfs device delete), there is no opportunity for a rebalance or metadata change on the pulled drives, so I would expect there to be a signature of some sort for consistency checking before readding it. At least, btrfs shouldn't add the readded device back as an active device when it's really still inconsistent and not being used, even if it indicates the same UUID.

Question: On hot-remove, does 'mount' show the volume as degraded?

I find the degraded mount option confusing. What does it mean to use -o degraded when mounting a volume for which all devices are present and functioning?


>> If I create the file system, mount it, but I do not copy any data, upon adding
>> new and deleting missing, the data profile is changed from raid1 to single. If
>> I've first copied data to the volume prior to device failure/missing, this
>> doesn't happen, it remains raid1.
> 
> And yet, the tools indicate that it is still raid1, even if internally it reverts to single???

No. btrfs fi df <mp> does reflect that the data profile has flipped from raid1 to single. As I mention later, this is reproducible only if the volume has had no data written to it. If I first write a file, then the reversion from raid1 to single doesn't happen upon 'btrfs device delete'.


> Based on my experience with this and Duncan's feedback, I'd like to see the wiki have some warnings about dealing with multidevice filesystems, especially surrounding the degraded mount option.

To me, degraded is an array or volume state, not up to the user to set as an option. So I'd like to know if the option is temporary, to more easily handle a particular problem for now, but the intention is to handle it better (differently) in the future.

> 
> Looking again at the wiki Gotchas page, it does say
> On a multi device btrfs filesystem, mistakingly re-adding
> a block device that is already part of the btrfs fs with
> btrfs device add results in an error, and brings btrfs in
> an inconsistent state.

For raid1 and raid10 this seems a problem for a file system that can become very large. The devices have enough information to determine exactly how far behind temporarily kicked devices are; it seems they effectively have an mdraid write-intent bitmap.


> 
> 1. btrfs filesystem show - shouldn't list devices as present unlesss they're in use and in a consistent state.

Or mark them as being inconsistent/unavailable.


> 
> As Chris said, "There isn't a readd option in btrfs, which in md parlance is used for readding a device previously part of an array." However, when I hotplugged the drive and it reappeared in the 'fi show' output, I assumed exactly the md semantics had occurred, with the drive having been readded and made consistent - it didn't take any time, but I hadn't copied data yet and knew btrfs may only sync the used data and metadata blocks.

The md semantics is that there is no auto add or readd. You must tell it to do this once the dropped device is made available again. If there's a write-intent bitmap, the readded device is caught up very quickly. 

I think it's a problem if there isn't an write-intent bitmap equivalent for btrfs raid1/raid10, and right now there doesn't seem to be one. A compulsory rebalance means hours or days of rebalance just because one drive was dropped for a short while.


> 
> In other words, I never ran a device add or remove, but still saw what appeared to be consistent behavior.
> 
> 2. data profile shouldn't revert to single if adding/deleting before copying data

Yes I think it's a bug too, but it's probably benign.

> 
> This then drives the question, how does one check the degraded state of a filesystem if not the mount flag. I (quite likely with an md-raid bias) expected to use the 'filesystem show' output, listed the devices as well as a status flag of fully-consistent or rebalance in progress. If that's not the correct or intended location, then provide documentation on how to properly check the consistency state and degraded state of a filesystem.

Yeah I think something functionally equivalent to a combination of mdadm -D and -E. mdadm distinguishes between array status/metadata vs member device status/metadata with those two commands.



Chris Murphy