Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36514 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbcK3QtE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 11:49:04 -0500
Received: by mail-io0-f174.google.com with SMTP id m5so220630810ioe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 08:49:03 -0800 (PST)
Subject: Re: Convert from RAID 5 to 10
To: Wilson Meier <wilson.meier@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
 <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com>
 <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
 <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com>
 <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com>
 <e9a4cba5-53b7-b6f0-af83-467f5f95f5b8@googlemail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <21e6765c-21f9-1726-b06f-9bd5f67c7b49@gmail.com>
Date: Wed, 30 Nov 2016 11:48:57 -0500
MIME-Version: 1.0
In-Reply-To: <e9a4cba5-53b7-b6f0-af83-467f5f95f5b8@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-30 10:49, Wilson Meier wrote:
>
>
> Am 30/11/16 um 15:37 schrieb Austin S. Hemmelgarn:
>> On 2016-11-30 08:12, Wilson Meier wrote:
>>> Am 30/11/16 um 11:41 schrieb Duncan:
>>>> Wilson Meier posted on Wed, 30 Nov 2016 09:35:36 +0100 as excerpted:
>>>>
>>>>> Am 30/11/16 um 09:06 schrieb Martin Steigerwald:
>>>>>> Am Mittwoch, 30. November 2016, 10:38:08 CET schrieb Roman Mamedov:
>>>>>>> [snip]
>>>>>> So the stability matrix would need to be updated not to recommend any
>>>>>> kind of BTRFS RAID 1 at the moment?
>>>>>>
>>>>>> Actually I faced the BTRFS RAID 1 read only after first attempt of
>>>>>> mounting it "degraded" just a short time ago.
>>>>>>
>>>>>> BTRFS still needs way more stability work it seems to me.
>>>>>>
>>>>> I would say the matrix should be updated to not recommend any RAID
>>>>> Level
>>>>> as from the discussion it seems they all of them have flaws.
>>>>> To me RAID is broken if one cannot expect to recover from a device
>>>>> failure in a solid way as this is why RAID is used.
>>>>> Correct me if i'm wrong. Right now i'm making my thoughts about
>>>>> migrating to another FS and/or Hardware RAID.
>>>> It should be noted that no list regular that I'm aware of anyway, would
>>>> make any claims about btrfs being stable and mature either now or in
>>>> the
>>>> near-term future in any case.  Rather to the contrary, as I
>>>> generally put
>>>> it, btrfs is still stabilizing and maturing, with backups one is
>>>> willing
>>>> to use (and as any admin of any worth would say, a backup that hasn't
>>>> been tested usable isn't yet a backup; the job of creating the backup
>>>> isn't done until that backup has been tested actually usable for
>>>> recovery) still extremely strongly recommended.  Similarly, keeping up
>>>> with the list is recommended, as is staying relatively current on both
>>>> the kernel and userspace (generally considered to be within the latest
>>>> two kernel series of either current or LTS series kernels, and with a
>>>> similarly versioned btrfs userspace).
>>>>
>>>> In that context, btrfs single-device and raid1 (and raid0 of course)
>>>> are
>>>> quite usable and as stable as btrfs in general is, that being
>>>> stabilizing
>>>> but not yet fully stable and mature, with raid10 being slightly less so
>>>> and raid56 being much more experimental/unstable at this point.
>>>>
>>>> But that context never claims full stability even for the relatively
>>>> stable raid1 and single device modes, and in fact anticipates that
>>>> there
>>>> may be times when recovery from the existing filesystem may not be
>>>> practical, thus the recommendation to keep tested usable backups at the
>>>> ready.
>>>>
>>>> Meanwhile, it remains relatively common on this list for those
>>>> wondering
>>>> about their btrfs on long-term-stale (not a typo) "enterprise" distros,
>>>> or even debian-stale, to be actively steered away from btrfs,
>>>> especially
>>>> if they're not willing to update to something far more current than
>>>> those
>>>> distros often provide, because in general, the current stability status
>>>> of btrfs is in conflict with the reason people generally choose to use
>>>> that level of old and stale software in the first place -- they
>>>> prioritize tried and tested to work, stable and mature, over the latest
>>>> generally newer and flashier featured but sometimes not entirely
>>>> stable,
>>>> and btrfs at this point simply doesn't meet that sort of stability/
>>>> maturity expectations, nor is it likely to for some time (measured in
>>>> years), due to all the reasons enumerated so well in the above thread.
>>>>
>>>>
>>>> In that context, the stability status matrix on the wiki is already
>>>> reasonably accurate, certainly so IMO, because "OK" in context means as
>>>> OK as btrfs is in general, and btrfs itself remains still stabilizing,
>>>> not fully stable and mature.
>>>>
>>>> If there IS an argument as to the accuracy of the raid0/1/10 OK status,
>>>> I'd argue it's purely due to people not understanding the status of
>>>> btrfs
>>>> in general, and that if there's a general deficiency at all, it's in
>>>> the
>>>> lack of a general stability status paragraph on that page itself
>>>> explaining all this, despite the fact that the main https://
>>>> btrfs.wiki.kernel.org landing page states quite plainly under stability
>>>> status that btrfs remains under heavy development and that current
>>>> kernels are strongly recommended.  (Tho were I editing it, there'd
>>>> certainly be a more prominent mention of keeping backups at the
>>>> ready as
>>>> well.)
>>>>
>>> Hi Duncan,
>>>
>>> i understand your arguments but cannot fully agree.
>>> First of all, i'm not sticking with old stale versions of whatever as i
>>> try to keep my system up2date.
>>> My kernel is 4.8.4 (Gentoo) and btrfs-progs is 4.8.4.
>>> That being said, i'm quite aware of the heavy development status of
>>> btrfs but pointing the finger on the users saying that they don't fully
>>> understand the status of btrfs without giving the information on the
>>> wiki is in my opinion not the right way. Heavy development doesn't mean
>>> that features marked as ok are "not" or "mostly" ok in the context of
>>> overall btrfs stability.
>>> There is no indication on the wiki that raid1 or every other raid
>>> (except for raid5/6) suffers from the problems stated in this thread.
>> The performance issues are inherent to BTRFS right now, and none of
>> the other issues are likely to impact most regular users.  Most of the
>> people who would be interested in the features of BTRFS also have
>> existing monitoring and thus will usually be replacing failing disks
>> long before they cause the FS to go degraded (and catastrophic disk
>> failures are extremely rare), and if you've got issues with devices
>> disappearing and reappearing, you're going to have a bad time with any
>> filesystem, not just BTRFS.
> Ok, so because this is "not likely" there is no need to mention that on
> the wiki?
I never said that at all.  I'm saying that the issues are mitigated by 
secondary choices made by most typical users of BTRFS.  And BTRFS really 
isn't in a state that home-users should be using it for general purpose 
systems (no matter what crap the distro engineers for many of the big 
distros are smoking that makes them think otherwise).
> Do you also have all home users in mind, which go to vacation (sometime
>> 3 weeks) and don't have a 24/7 support team to replace monitored disks
> which do report SMART errors?
Better than 90% of people I know either shut down their systems when 
they're going to be away for a long period of time, or like me have ways 
to log in remotely and tell the FS to not use that disk anymore.
> I'm not saying "btrfs and its devs -> BAD". It's perfectly fine to have
> bugs or maybe even general design problems. But let the people know
> about that.
Agreed, our documentation has issues.
>>> If there are know problems then the stability matrix should point them
>>> out or link to a corresponding wiki entry otherwise one has to assume
>>> that the features marked as "ok" are in fact "ok".
>>> And yes, the overall btrfs stability should be put on the wiki.
>> The stability info could be improved, but _absolutely none_ of the
>> things mentioned as issues with raid1 are specific to raid1.  And in
>> general, in the context of a feature stability matrix, 'OK' generally
>> means that there are no significant issues with that specific feature,
>> and since none of the issues outlined are specific to raid1, it does
>> meet that description of 'OK'.
> I think you mean "should be improved". :)
That really describes a significant majority of OSS documentation in 
general.
>
> Transferring this to car analogy, just to make it a bit more funny:
> The airbag (raid level whatever) itself is ok but the micro controller
> (general btrfs) which has the responsibility to inflate the airbag is
> suffers some problems, sometimes doesn't inflate and the manufacturer
> doesn't mention about that fact.
> From your point of you the airbag is ok. From my point of view -> Don't
> buy that car!!!
> Don't you mean that the fact that the live safer suffers problems should
> be noted and every dependent component should point to that fact?
> I think it should.
> I'm not talking about performance issues, i'm talking about data loss.
> Now the next one can throw in "Backups, always make backups!".
> Sure, but backup is backup and raid is raid. Both have their own concerns.
A better analogy for a car would be something along the lines of the 
radio working fine but the general wiring having issues that cause all 
the electronics in the car to stop working under certain circumstances. 
In that case, the radio itself is absolutely OK, but it suffers from 
issues caused directly by poor design elsewhere in the vehicle.
>>>
>>> Just to give you a quick overview of my history with btrfs.
>>> I migrated away from MD Raid and ext4 to btrfs raid6 because of its CoW
>>> and checksum features at a time as raid6 was not considered fully stable
>>> but also not as badly broken.
>>> After a few months i had a disk failure and the raid could not recover.
>>> I looked at the wiki an the mailing list and noticed that raid6 has been
>>> marked as badly broken :(
>>> I was quite happy to have a backup. So i asked on the btrfs IRC channel
>>> (the wiki had no relevant information) if raid10 is usable or suffers
>>> from the same problems. The summary was "Yes it is usable and has no
>>> known problems". So i migrated to raid10. Now i know that raid10 (marked
>>> as ok) has also problems with 2 disk failures in different stripes and
>>> can in fact lead to data loss.
>> Part of the problem here is that most people don't remember that
>> someone asking a question isn't going to know about stuff like that.
>> There's also the fact that many people who use BTRFS and provide
>> support are like me and replace failing hardware as early as possible,
>> and thus have zero issue with the behavior in the case of a
>> catastrophic failure.
> There wouldn't be any need to remember that, if it would be written in
> the wiki.
Again, agreed, our documentation really sucks in many places.
>>> I thought, hmm ok, i'll split my data and use raid1 (marked as ok). And
>>> again the mailing list states that raid1 has also problems in case of
>>> recovery.
>> Unless you can expect a catastrophic disk failure, raid1 is OK for
>> general usage.  The only times it has issues are if you have an insane
>> number of failed reads/writes, or the disk just completely dies.  If
>> you're not replacing a storage device before things get to that point,
>> you're going to have just as many (if not more) issues with pretty
>> much any other replicated storage system (Yes, I know that LVM and MD
>> will keep working in the second case, but it's still a bad idea to let
>> things get to that point because of the stress it will put on the
>> other disk).
>>
>> Looking at this another way, I've been using BTRFS on all my systems
>> since kernel 3.16 (I forget what exact vintage that is in regular
>> years).  I've not had any data integrity or data loss issues as a
>> result of BTRFS itself since 3.19, and in just the past year I've had
>> multiple raid1 profile filesystems survive multiple hardware issues
>> with near zero issues (with the caveat that I had to re-balance after
>> replacing devices to convert a few single chunks to raid1), and that
>> includes multiple disk failures and 2 bad PSU's plus about a dozen
>> (not BTRFS related) kernel panics and 4 unexpected power loss events.
>> I also have exhaustive monitoring, so I'm replacing bad hardware early
>> instead of waiting for it to actually fail.
>>>
>>> It is really disappointing to not have this information in the wiki
>>> itself. This would have saved me, and i'm quite sure others too, a lot
>>> of time.
>>> Sorry for being a bit frustrated.
> I'm not angry or something like that :) .
> I just would like to have the possibility to read such information about
> the storage i put my personal data (> 3 TB) on its official wiki.
There are more places than the wiki to look for info about BTRFS (and 
this is the case about almost any piece of software, not just BTRFS, 
very few things have one central source for everything).  I don't mean 
to sound unsympathetic, but given what you're saying, it's sounding more 
and more like you didn't look at anything beyond the wiki and should 
have checked other sources as well.
