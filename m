Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35681 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753326AbeFYL0o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 07:26:44 -0400
Received: by mail-io0-f196.google.com with SMTP id q4-v6so12209281iob.2
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 04:26:43 -0700 (PDT)
Subject: Re: unsolvable technical issues?
To: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
 <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
 <646f0c52-4726-7a7d-0242-4412950bf002@libero.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <64876ad1-9f63-f6f0-9d55-0fa4999f0bf5@gmail.com>
Date: Mon, 25 Jun 2018 07:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <646f0c52-4726-7a7d-0242-4412950bf002@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-24 16:22, Goffredo Baroncelli wrote:
> On 06/23/2018 07:11 AM, Duncan wrote:
>> waxhead posted on Fri, 22 Jun 2018 01:13:31 +0200 as excerpted:
>>
>>> According to this:
>>>
>>> https://stratis-storage.github.io/StratisSoftwareDesign.pdf Page 4 ,
>>> section 1.2
>>>
>>> It claims that BTRFS still have significant technical issues that may
>>> never be resolved.
>>> Could someone shed some light on exactly what these technical issues
>>> might be?! What are BTRFS biggest technical problems?
>>>
>>> If you forget about the "RAID"5/6 like features then the only annoyances
>>> that I have with BTRFS so far is...
>>>
>>> 1. Lack of per subvolume "RAID" levels
>>> 2. Lack of not using the deviceid to re-discover and re-add dropped
>>> devices
>>>
>>> And that's about it really...
>>
>> ... And those both have solutions on the roadmap, with RFC patches
>> already posted for #2 (tho I'm not sure they use devid) altho
>> realistically they're likely to take years to appear and be tested to
>> stability.  Meanwhile...
>>
>> While as the others have said you really need to go to the author to get
>> what was referred to, and I agree, I can speculate a bit.  While this
>> *is* speculation, admittedly somewhat uninformed as I don't claim to be a
>> dev, and I'd actually be interested in what others think so don't be
>> afraid to tell me I haven't a clue, as long as you say why... based on
>> several years reading the list now...
>>
>> 1) When I see btrfs "technical issue that may never be resolved", the #1
>> first thing I think of, that AFAIK there are _definitely_ no plans to
>> resolve, because it's very deeply woven into the btrfs core by now, is...
>>
>> Filesystem UUID Identification.  Btrfs takes the UU bit of Universally
>> Unique quite literally, assuming they really *are* unique, at least on
>> that system, and uses them to identify the possibly multiple devices that
>> may be components of the filesystem, a problem most filesystems don't
>> have to deal with since they're single-device-only.  Because btrfs uses
>> this supposedly unique ID to ID devices that belong to the filesystem, it
>> can get *very* mixed up, with results possibly including dataloss, if it
>> sees devices that don't actually belong to a filesystem with the same UUID
>> as a mounted filesystem.
> 
> As partial workaround you can disable udev btrfs rules and then do a "btrfs dev scan" manually only for the device which you need. The you can mount the filesystem. Unfortunately you cannot mount two filesystem with the same UUID. However I have to point out that also LVM/dm might have problems if you clone a PV....
You don't even need `btrfs dev scan` if you just specify the exact set 
of devices in the mount options.  The `device=` mount option tells the 
kernel to check that device during the mount process.

Also, while LVM does have 'issues' with cloned PV's, it fails safe (by 
refusing to work on VG's that have duplicate PV's), while BTRFS fails 
very unsafely (by randomly corrupting data).
> 
> [...]
> der say 3-5 (or 5-7, or whatever)
>> years.  These could arguably include:
>>
>> 2) Subvolume and (more technically) reflink-aware defrag.
>>
>> It was there for a couple kernel versions some time ago, but "impossibly"
>> slow, so it was disabled until such time as btrfs could be made to scale
>> rather better in this regard.
> 
> Did you try something like that with XFS+DM snapshot ? No you can't, because defrag in XFS cannot traverse snapshot (and I have to suppose that defrag cannot be effective on a dm-snapshot at all)..
> What I am trying to point out is that even tough btrfs is not the fastest filesystem (and for some workload is VERY slow), when you compare it when few snapshots were presents LVM/dm is a lot slower.
> 
> IMHO most of the complaint which affect BTRFS, are due to the fact that with BTRFS an user can quite easily exploit a lot of features and their combinations. When a the slowness issue appears when some advance features combinations are used (i.e. multiple disks profile and (a lot of ) snapshots), this is reported as a BTRFS failure. But in fact even LVM/dm is very slow when the snapshot is used.
I still contend that the biggest issue WRT reflink-aware defrag was that 
it was not optional.  The only way to get the old defrag behavior was to 
boot a kernel that didn't have reflink-aware defrag support.  IOW, 
_everyone_ had to deal with the performance issues, not just the people 
who wanted to use reflink-aware defrag.
> 
> 
>>
>> There's no hint yet as to when that might actually be, if it will _ever_
>> be, so this can arguably be validly added to the "may never be resolved"
>> list.
>>
>> 3) N-way-mirroring.
>>
> [...]
> This is not an issue, but a not implemented feature
If you're looking at feature parity with competitors, it's an issue.
>>
>> 4) (Until relatively recently, and still in terms of scaling) Quotas.
>>
>> Until relatively recently, quotas could arguably be added to the list.
>> They were rewritten multiple times, and until recently, appeared to be
>> effectively eternally broken.
> 
> Even tough what you are reporting is correct, I have to point out that the quota in BTRFS is more complex than the equivalent one of the other FS. In fact it handles (good or bad) quota of gorup of subvolumes. How this concept could be translated in terms of "stratis"
> 
> 
> [...]
>>
>> As for stratis, supposedly they're deliberately taking existing proven in
>> multi-layer-form technology and simply exposing it in unified form.  They
>> claim this dramatically lessens the required new code and shortens time-
>> to-stability to something reasonable, in contrast to the about a decade
>> btrfs has taken already, without yet reaching a full feature set and full
>> stability.  IMO they may well have a point, tho AFAIK they're still new
>> and immature themselves and (I believe) don't have it either, so it's a
>> point that AFAIK has yet to be fully demonstrated.
>>
>> We'll see how they evolve.  I do actually expect them to move faster than
>> btrfs, but also expect the interface may not be as smooth and unified as
>> they'd like to present as I expect there to remain some hiccups in
>> smoothing over the layering issues.  Also, because they've deliberately
>> chosen to go with existing technology where possible in ordered to evolve
>> to stability faster, by the same token they're deliberately limiting the
>> evolution to incremental over existing technology, and I expect there's
>> some stuff btrfs will do better as a result... at least until btrfs (or a
>> successor) becomes stable enough for them to integrate (parts of?) it as
>> existing demonstrated-stable technology.
> 
> I fully agree with the above sentences...
>>
>> The other difference, AFAIK, is that stratis is specifically a
>> corporation making it a/the main money product, whereas btrfs was always
>> something the btrfs devs used at their employers (oracle, facebook), who
>> have other things as their main product.  As such, stratis is much more
>> likely to prioritize things like raid status monitors, hot-spares, etc,
>> that can be part of the product they sell, where they've been lower
>> priority for btrfs.
>>
> 
> 

