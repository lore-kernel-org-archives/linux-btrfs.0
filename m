Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60796 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754672AbcK3KlT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 05:41:19 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cC2K8-0003Ue-JJ
        for linux-btrfs@vger.kernel.org; Wed, 30 Nov 2016 11:41:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Convert from RAID 5 to 10
Date: Wed, 30 Nov 2016 10:41:06 +0000 (UTC)
Message-ID: <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
        <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
        <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
        <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wilson Meier posted on Wed, 30 Nov 2016 09:35:36 +0100 as excerpted:

> Am 30/11/16 um 09:06 schrieb Martin Steigerwald:
>> Am Mittwoch, 30. November 2016, 10:38:08 CET schrieb Roman Mamedov:
>>> On Wed, 30 Nov 2016 00:16:48 +0100
>>>
>>> Wilson Meier <wilson.meier@gmail.com> wrote:
>>>> That said, btrfs shouldn't be used for other then raid1 as every
>>>> other raid level has serious problems or at least doesn't work as the
>>>> expected raid level (in terms of failure recovery).
>>> RAID1 shouldn't be used either:
>>>
>>> *) Read performance is not optimized: all metadata is always read from
>>> the first device unless it has failed, data reads are supposedly
>>> balanced between devices per PID of the process reading. Better
>>> implementations dispatch reads per request to devices that are
>>> currently idle.
>>>
>>> *) Write performance is not optimized, during long full bandwidth
>>> sequential writes it is common to see devices writing not in parallel,
>>> but with a long periods of just one device writing, then another.
>>> (Admittedly have been some time since I tested that).
>>>
>>> *) A degraded RAID1 won't mount by default.
>>>
>>> If this was the root filesystem, the machine won't boot.
>>>
>>> To mount it, you need to add the "degraded" mount option.
>>> However you have exactly a single chance at that, you MUST restore the
>>> RAID to non-degraded state while it's mounted during that session,
>>> since it won't ever mount again in the r/w+degraded mode, and in r/o
>>> mode you can't perform any operations on the filesystem, including
>>> adding/removing devices.
>>>
>>> *) It does not properly handle a device disappearing during operation.
>>> (There is a patchset to add that).
>>>
>>> *) It does not properly handle said device returning (under a
>>> different /dev/sdX name, for bonus points).
>>>
>>> Most of these also apply to all other RAID levels.
>> So the stability matrix would need to be updated not to recommend any
>> kind of BTRFS RAID 1 at the moment?
>>
>> Actually I faced the BTRFS RAID 1 read only after first attempt of
>> mounting it "degraded" just a short time ago.
>>
>> BTRFS still needs way more stability work it seems to me.
>>
> I would say the matrix should be updated to not recommend any RAID Level
> as from the discussion it seems they all of them have flaws.
> To me RAID is broken if one cannot expect to recover from a device
> failure in a solid way as this is why RAID is used.
> Correct me if i'm wrong. Right now i'm making my thoughts about
> migrating to another FS and/or Hardware RAID.

It should be noted that no list regular that I'm aware of anyway, would 
make any claims about btrfs being stable and mature either now or in the 
near-term future in any case.  Rather to the contrary, as I generally put 
it, btrfs is still stabilizing and maturing, with backups one is willing 
to use (and as any admin of any worth would say, a backup that hasn't 
been tested usable isn't yet a backup; the job of creating the backup 
isn't done until that backup has been tested actually usable for 
recovery) still extremely strongly recommended.  Similarly, keeping up 
with the list is recommended, as is staying relatively current on both 
the kernel and userspace (generally considered to be within the latest 
two kernel series of either current or LTS series kernels, and with a 
similarly versioned btrfs userspace).

In that context, btrfs single-device and raid1 (and raid0 of course) are 
quite usable and as stable as btrfs in general is, that being stabilizing 
but not yet fully stable and mature, with raid10 being slightly less so 
and raid56 being much more experimental/unstable at this point.

But that context never claims full stability even for the relatively 
stable raid1 and single device modes, and in fact anticipates that there 
may be times when recovery from the existing filesystem may not be 
practical, thus the recommendation to keep tested usable backups at the 
ready.

Meanwhile, it remains relatively common on this list for those wondering 
about their btrfs on long-term-stale (not a typo) "enterprise" distros, 
or even debian-stale, to be actively steered away from btrfs, especially 
if they're not willing to update to something far more current than those 
distros often provide, because in general, the current stability status 
of btrfs is in conflict with the reason people generally choose to use 
that level of old and stale software in the first place -- they 
prioritize tried and tested to work, stable and mature, over the latest 
generally newer and flashier featured but sometimes not entirely stable, 
and btrfs at this point simply doesn't meet that sort of stability/
maturity expectations, nor is it likely to for some time (measured in 
years), due to all the reasons enumerated so well in the above thread.


In that context, the stability status matrix on the wiki is already 
reasonably accurate, certainly so IMO, because "OK" in context means as 
OK as btrfs is in general, and btrfs itself remains still stabilizing, 
not fully stable and mature.

If there IS an argument as to the accuracy of the raid0/1/10 OK status, 
I'd argue it's purely due to people not understanding the status of btrfs 
in general, and that if there's a general deficiency at all, it's in the 
lack of a general stability status paragraph on that page itself 
explaining all this, despite the fact that the main https://
btrfs.wiki.kernel.org landing page states quite plainly under stability 
status that btrfs remains under heavy development and that current 
kernels are strongly recommended.  (Tho were I editing it, there'd 
certainly be a more prominent mention of keeping backups at the ready as 
well.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

