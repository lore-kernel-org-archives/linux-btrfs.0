Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38447 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755966AbcK3NMq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 08:12:46 -0500
Received: by mail-wm0-f52.google.com with SMTP id f82so219366814wmf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 05:12:39 -0800 (PST)
From: Wilson Meier <wilson.meier@gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
 <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com>
 <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
Message-ID: <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com>
Date: Wed, 30 Nov 2016 14:12:36 +0100
MIME-Version: 1.0
In-Reply-To: <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 30/11/16 um 11:41 schrieb Duncan:
> Wilson Meier posted on Wed, 30 Nov 2016 09:35:36 +0100 as excerpted:
>
>> Am 30/11/16 um 09:06 schrieb Martin Steigerwald:
>>> Am Mittwoch, 30. November 2016, 10:38:08 CET schrieb Roman Mamedov:
>>>> [snip]
>>> So the stability matrix would need to be updated not to recommend any
>>> kind of BTRFS RAID 1 at the moment?
>>>
>>> Actually I faced the BTRFS RAID 1 read only after first attempt of
>>> mounting it "degraded" just a short time ago.
>>>
>>> BTRFS still needs way more stability work it seems to me.
>>>
>> I would say the matrix should be updated to not recommend any RAID Level
>> as from the discussion it seems they all of them have flaws.
>> To me RAID is broken if one cannot expect to recover from a device
>> failure in a solid way as this is why RAID is used.
>> Correct me if i'm wrong. Right now i'm making my thoughts about
>> migrating to another FS and/or Hardware RAID.
> It should be noted that no list regular that I'm aware of anyway, would 
> make any claims about btrfs being stable and mature either now or in the 
> near-term future in any case.  Rather to the contrary, as I generally put 
> it, btrfs is still stabilizing and maturing, with backups one is willing 
> to use (and as any admin of any worth would say, a backup that hasn't 
> been tested usable isn't yet a backup; the job of creating the backup 
> isn't done until that backup has been tested actually usable for 
> recovery) still extremely strongly recommended.  Similarly, keeping up 
> with the list is recommended, as is staying relatively current on both 
> the kernel and userspace (generally considered to be within the latest 
> two kernel series of either current or LTS series kernels, and with a 
> similarly versioned btrfs userspace).
>
> In that context, btrfs single-device and raid1 (and raid0 of course) are 
> quite usable and as stable as btrfs in general is, that being stabilizing 
> but not yet fully stable and mature, with raid10 being slightly less so 
> and raid56 being much more experimental/unstable at this point.
>
> But that context never claims full stability even for the relatively 
> stable raid1 and single device modes, and in fact anticipates that there 
> may be times when recovery from the existing filesystem may not be 
> practical, thus the recommendation to keep tested usable backups at the 
> ready.
>
> Meanwhile, it remains relatively common on this list for those wondering 
> about their btrfs on long-term-stale (not a typo) "enterprise" distros, 
> or even debian-stale, to be actively steered away from btrfs, especially 
> if they're not willing to update to something far more current than those 
> distros often provide, because in general, the current stability status 
> of btrfs is in conflict with the reason people generally choose to use 
> that level of old and stale software in the first place -- they 
> prioritize tried and tested to work, stable and mature, over the latest 
> generally newer and flashier featured but sometimes not entirely stable, 
> and btrfs at this point simply doesn't meet that sort of stability/
> maturity expectations, nor is it likely to for some time (measured in 
> years), due to all the reasons enumerated so well in the above thread.
>
>
> In that context, the stability status matrix on the wiki is already 
> reasonably accurate, certainly so IMO, because "OK" in context means as 
> OK as btrfs is in general, and btrfs itself remains still stabilizing, 
> not fully stable and mature.
>
> If there IS an argument as to the accuracy of the raid0/1/10 OK status, 
> I'd argue it's purely due to people not understanding the status of btrfs 
> in general, and that if there's a general deficiency at all, it's in the 
> lack of a general stability status paragraph on that page itself 
> explaining all this, despite the fact that the main https://
> btrfs.wiki.kernel.org landing page states quite plainly under stability 
> status that btrfs remains under heavy development and that current 
> kernels are strongly recommended.  (Tho were I editing it, there'd 
> certainly be a more prominent mention of keeping backups at the ready as 
> well.)
>
Hi Duncan,

i understand your arguments but cannot fully agree.
First of all, i'm not sticking with old stale versions of whatever as i
try to keep my system up2date.
My kernel is 4.8.4 (Gentoo) and btrfs-progs is 4.8.4.
That being said, i'm quite aware of the heavy development status of
btrfs but pointing the finger on the users saying that they don't fully
understand the status of btrfs without giving the information on the
wiki is in my opinion not the right way. Heavy development doesn't mean
that features marked as ok are "not" or "mostly" ok in the context of
overall btrfs stability.
There is no indication on the wiki that raid1 or every other raid
(except for raid5/6) suffers from the problems stated in this thread.
If there are know problems then the stability matrix should point them
out or link to a corresponding wiki entry otherwise one has to assume
that the features marked as "ok" are in fact "ok".
And yes, the overall btrfs stability should be put on the wiki.

Just to give you a quick overview of my history with btrfs.
I migrated away from MD Raid and ext4 to btrfs raid6 because of its CoW
and checksum features at a time as raid6 was not considered fully stable
but also not as badly broken.
After a few months i had a disk failure and the raid could not recover.
I looked at the wiki an the mailing list and noticed that raid6 has been
marked as badly broken :(
I was quite happy to have a backup. So i asked on the btrfs IRC channel
(the wiki had no relevant information) if raid10 is usable or suffers
from the same problems. The summary was "Yes it is usable and has no
known problems". So i migrated to raid10. Now i know that raid10 (marked
as ok) has also problems with 2 disk failures in different stripes and
can in fact lead to data loss.
I thought, hmm ok, i'll split my data and use raid1 (marked as ok). And
again the mailing list states that raid1 has also problems in case of
recovery.

It is really disappointing to not have this information in the wiki
itself. This would have saved me, and i'm quite sure others too, a lot
of time.
Sorry for being a bit frustrated.

