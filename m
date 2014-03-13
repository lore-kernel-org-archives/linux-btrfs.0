Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59212 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753504AbaCMWEf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 18:04:35 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:59370 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WODju-000gj9-QJ
	for linux-btrfs@vger.kernel.org; Thu, 13 Mar 2014 16:04:34 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Incremental backup for a raid1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5491122.Fap633Kp83@fuchsia>
Date: Thu, 13 Mar 2014 16:04:33 -0600
Message-Id: <0AD708D8-5380-465E-8119-DD6FDD1BF1BA@colorremedies.com>
References: <1564384.fRV1HUkfCq@fuchsia> <20140313192832.GE6151@carfax.org.uk> <53220BA7.1060702@gmail.com> <5491122.Fap633Kp83@fuchsia>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 13, 2014, at 3:14 PM, Michael Schuerig <michael.lists@schuerig.de> wrote:

> On Thursday 13 March 2014 14:48:55 Andrew Skretvedt wrote:
>> On 2014-Mar-13 14:28, Hugo Mills wrote:
>>> On Thu, Mar 13, 2014 at 08:12:44PM +0100, Michael Schuerig wrote:
>>>> My backup use case is different from the what has been recently
>>>> discussed in another thread. I'm trying to guard against hardware
>>>> failure and other causes of destruction.
>>>> 
>>>> I have a btrfs raid1 filesystem spread over two disks. I want to
>>>> backup this filesystem regularly and efficiently to an external
>>>> disk (same model as the ones in the raid) in such a way that
>>>> 
>>>> * when one disk in the raid fails, I can substitute the backup and
>>>> rebalancing from the surviving disk to the substitute only applies
>>>> the missing changes.
>>>> 
>>>> * when the entire raid fails, I can re-build a new one from the
>>>> backup.
>>>> 
>>>> The filesystem is mounted at its root and has several nested
>>>> subvolumes and snapshots (in a .snapshots subdir on each subvol).
> [...]
> 
>> I'm new; btrfs noob; completely unqualified to write intelligently on
>> this topic, nevertheless:
>> I understand your setup to be btrfs RAID1 with /dev/A /dev/B, and a
>> backup device someplace /dev/C
>> 
>> Could you, at the time you wanted to backup the filesystem:
>> 1) in the filesystem, break RAID1: /dev/A /dev/B <-- remove /dev/B
>> 2) reestablish RAID1 to the backup device: /dev/A /dev/C <-- added
>> 3) balance to effect the backup (i.e. rebuilding the RAID1 onto
>> /dev/C) 4) break/reconnect the original devices: remove /dev/C;
>> re-add /dev/B to the fs
> 
> I've thought of this but don't dare try it without approval from the 
> experts. At any rate, for being practical, this approach hinges on an 
> ability to rebuild the raid1 incrementally. That is, the rebuild would 
> have to start from what already is present on disk B (or C, when it is 
> re-added). Starting from an effectively blank disk each time would be 
> prohibitive.
> 
> Even if this would work, I'd much prefer keeping the original raid1 
> intact and to only temporarily add another mirror: "lazy mirroring", to 
> give the thing a name.

At best this seems fragile, but I don't think it works and is an edge case from the start. This is what send/receive is for.

In the btrfs replace scenario, the missing device is removed from the volume. It's like a divorce. Missing device 2 is replaced by a different physical device also called device 2. If you then removed 2b and readd (formerly replaced) device 2a, what happens? I don't know, I'm pretty sure the volume knows this is not device 2b as it should be, and won't accept formerly replaced device 2a. But it's an edge case to do this because you've said "device replace". So lexicon wise, I wouldn't even want this to work, we'd need a different command even if not different logic.

In the btfs device add case, you now have a three disk raid1 which is a whole different beast. Since this isn't n-way raid1, each disk is not stand alone. You're only assured data survives a one disk failure meaning you must have two drives. You've just increased your risk by doing this, not reduced it. It further proposes running an (ostensibly) production workflow with an always degraded volume, mounted with -o degraded, on an on-going basis. So it's three strikes.  It's not n-way, you have no uptime if you lose one of two disks onsite, you's have to go get the offsite/onshelf disk to keep working. Plus that offsite disk isn't stand alone, so why even have it offsite? This is a fail.

So the btrfs replace scenario might work but it seems like a bad idea. And overall it's a use case for which send/receive was designed anyway so why not just use that?

Chris Murphy

