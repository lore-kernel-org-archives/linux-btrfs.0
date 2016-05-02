Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48772 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbcEBFah (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 01:30:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ax6RH-00072f-75
	for linux-btrfs@vger.kernel.org; Mon, 02 May 2016 07:30:35 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 07:30:35 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 07:30:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/2] [RFC] btrfs: create degraded-RAID1 chunks
Date: Mon, 2 May 2016 05:30:28 +0000 (UTC)
Message-ID: <pan$48047$9ab8b06b$3a7e36c0$b044169e@cox.net>
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
	<20160429163727.GD29353@suse.cz> <5726D3AF.5010103@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Mon, 02 May 2016 12:12:31 +0800 as excerpted:

> On 04/30/2016 12:37 AM, David Sterba wrote:
>> On Thu, Apr 28, 2016 at 11:06:18AM +0800, Anand Jain wrote:
>>>  From the comments that commit[1] deleted
>>>
>>> - /*
>>> - * we add in the count of missing devices because we want
>>> - * to make sure that any RAID levels on a degraded FS
>>> - * continue to be honored.
>>> - *
>>>
>>> appear to me that automatic reduced-chunk-allocation when RAID1 is
>>> degraded wasn't in the original design.
>>>
>>> which also introduced unpleasant things like automatically allocating
>>> single chunks when RAID1 is mounted in degraded mode, which will
>>> hinder further RAID1 mount in degraded mode.
>>
>> Agreed. As the automatic conversion cannot be turned off, it causes
>> some surprises. We've opposed against such things in the past, so I'm
>> for not doing the 'single' allocations. Independly, I got a feedback
>> from a user who liked the proposed change..
> 
> yes.

Sounds good to this user too. =:^)

>>> And now to fix the original issue that is - chunk allocation fails
>>> when RAID1 is degraded, The reason for the problem seems to be that we
>>> had the devs_min attribute for RAID1 set wrongly. Correcting this also
>>> means that its time to fix the RAID1 fixmes in the functions
>>> __btrfs_alloc_chunk() patch [2] does that, and is for review.
>>
>> This means we'd allow full writes to a degraded raid1 filesystem. This
>> can bring surprises as well. The question is what to do if the device
>> pops out, some writes happen, and then is added.
> 
>> One option is to set some bit in the degraded filesystem that degraded
>> writes happened.
> 
>> After that, mounting the whole filesystem would recommend running scrub
>> before dropping the bit.
> 
> Right some flag should tell to fix the degraded chunks. Any suggestion
> on naming? (as of now calling it degraded-chunk-write-flag).

I almost replied earlier, suggesting dirty-raid as the name...  of course 
if my understanding is right, if not it may be inappropriate.

> Also as of now I think its ok to fail the mount when its found that both
> of the RAID1 devices has degraded-chunk-write-flag set (a split brain
> situation) so that user can mount one of the device and freshly
> btrfs-device-add the other.

That idea solves the problem I found in my own early testing, where 
mounting each one separately and writing to it could produce 
unpredictable results, particularly if the generations happened to match 
up.

>> Forcing a read-only mount here would be similar to read-only degraded
>> mount, so I guess we'd have to somehow deal with the missing writes.
> 
>> I haven't thought about all details, the raid1 auto-repair can handle
>> corrupted data, I think missing metadata should be handled as well and
>> repaired.
> 
> 
> I found raid5 scrub nicely handles the missing writes. However RAID1
> (and guess raid10 as well) needs balance. (I would like to keep it as it
> is as of now). IMO RAID1 should do what RAID5 is doing.

??  In my own btrfs raid1 experience, a full scrub fixed things for raid1 
as well.  

One angle of that experience was suspend to ram, with resume failing to 
resume one of the devices because it took too long to come back up, 
resulting in a crash soon after resume so I had to reboot and do a scrub 
anyway.  Ultimately I decided that resume to both devices simply wasn't 
reliable enough to continue testing fate, when much of the time I had to 
reboot AND do a scrub afterward anyway.  So I quit doing suspend to RAM 
at all, and simply started shutting down instead.  (Back with spinning 
rust I really hated to shut down and dump all that cache, but on the ssds 
I run now, it's not a big issue either way, and shutdown/startup is fast 
enough on systemd on ssd that it's not worth worrying about either, so...)

The other angle was continuing to run a defective and slowly failing ssd 
for some time after I realized it was failing, just to see how both the 
ssd and btrfs raid1 dealt with the problems.  I *know* a decent amount of 
those corruptions were metadata, due in part to scrub returning layers of 
unverified errors that would after another run be detected and corrected 
errors, some of which in turn would produce another layer of unverified 
errors, until a repeated scrub eventually came up with no unverified 
errors, at which point that run would correct the remaining errors and 
further runs would return no errors at all.

So AFAIK, raid1 scrub handles the missing writes well too, as long as 
scrub is run again whenever there's unverified errors, so it can detect 
and correct more on the next run after the parent layer was fixed so it 
was possible.

Tho that was a couple kernel cycles ago now, so it's possible raid1 scrub 
regressed since then.


Again, unless I'm misunderstanding what you guys are referring to...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

