Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:34559 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751689AbeFXUbA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Jun 2018 16:31:00 -0400
Reply-To: kreijack@inwind.it
Subject: Re: unsolvable technical issues?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
 <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <646f0c52-4726-7a7d-0242-4412950bf002@libero.it>
Date: Sun, 24 Jun 2018 22:22:47 +0200
MIME-Version: 1.0
In-Reply-To: <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/23/2018 07:11 AM, Duncan wrote:
> waxhead posted on Fri, 22 Jun 2018 01:13:31 +0200 as excerpted:
> 
>> According to this:
>>
>> https://stratis-storage.github.io/StratisSoftwareDesign.pdf Page 4 ,
>> section 1.2
>>
>> It claims that BTRFS still have significant technical issues that may
>> never be resolved.
>> Could someone shed some light on exactly what these technical issues
>> might be?! What are BTRFS biggest technical problems?
>>
>> If you forget about the "RAID"5/6 like features then the only annoyances
>> that I have with BTRFS so far is...
>>
>> 1. Lack of per subvolume "RAID" levels
>> 2. Lack of not using the deviceid to re-discover and re-add dropped
>> devices
>>
>> And that's about it really...
> 
> ... And those both have solutions on the roadmap, with RFC patches 
> already posted for #2 (tho I'm not sure they use devid) altho 
> realistically they're likely to take years to appear and be tested to 
> stability.  Meanwhile...
> 
> While as the others have said you really need to go to the author to get 
> what was referred to, and I agree, I can speculate a bit.  While this 
> *is* speculation, admittedly somewhat uninformed as I don't claim to be a 
> dev, and I'd actually be interested in what others think so don't be 
> afraid to tell me I haven't a clue, as long as you say why... based on 
> several years reading the list now...
> 
> 1) When I see btrfs "technical issue that may never be resolved", the #1 
> first thing I think of, that AFAIK there are _definitely_ no plans to 
> resolve, because it's very deeply woven into the btrfs core by now, is...
> 
> Filesystem UUID Identification.  Btrfs takes the UU bit of Universally 
> Unique quite literally, assuming they really *are* unique, at least on 
> that system, and uses them to identify the possibly multiple devices that 
> may be components of the filesystem, a problem most filesystems don't 
> have to deal with since they're single-device-only.  Because btrfs uses 
> this supposedly unique ID to ID devices that belong to the filesystem, it 
> can get *very* mixed up, with results possibly including dataloss, if it 
> sees devices that don't actually belong to a filesystem with the same UUID 
> as a mounted filesystem.

As partial workaround you can disable udev btrfs rules and then do a "btrfs dev scan" manually only for the device which you need. The you can mount the filesystem. Unfortunately you cannot mount two filesystem with the same UUID. However I have to point out that also LVM/dm might have problems if you clone a PV....

[...]
der say 3-5 (or 5-7, or whatever) 
> years.  These could arguably include:
> 
> 2) Subvolume and (more technically) reflink-aware defrag.
> 
> It was there for a couple kernel versions some time ago, but "impossibly" 
> slow, so it was disabled until such time as btrfs could be made to scale 
> rather better in this regard.

Did you try something like that with XFS+DM snapshot ? No you can't, because defrag in XFS cannot traverse snapshot (and I have to suppose that defrag cannot be effective on a dm-snapshot at all)..
What I am trying to point out is that even tough btrfs is not the fastest filesystem (and for some workload is VERY slow), when you compare it when few snapshots were presents LVM/dm is a lot slower.

IMHO most of the complaint which affect BTRFS, are due to the fact that with BTRFS an user can quite easily exploit a lot of features and their combinations. When a the slowness issue appears when some advance features combinations are used (i.e. multiple disks profile and (a lot of ) snapshots), this is reported as a BTRFS failure. But in fact even LVM/dm is very slow when the snapshot is used. 


> 
> There's no hint yet as to when that might actually be, if it will _ever_ 
> be, so this can arguably be validly added to the "may never be resolved" 
> list.
> 
> 3) N-way-mirroring.
> 
[...]
This is not an issue, but a not implemented feature
> 
> 4) (Until relatively recently, and still in terms of scaling) Quotas.
> 
> Until relatively recently, quotas could arguably be added to the list.  
> They were rewritten multiple times, and until recently, appeared to be 
> effectively eternally broken.

Even tough what you are reporting is correct, I have to point out that the quota in BTRFS is more complex than the equivalent one of the other FS. In fact it handles (good or bad) quota of gorup of subvolumes. How this concept could be translated in terms of "stratis"


[...]
> 
> As for stratis, supposedly they're deliberately taking existing proven in 
> multi-layer-form technology and simply exposing it in unified form.  They 
> claim this dramatically lessens the required new code and shortens time-
> to-stability to something reasonable, in contrast to the about a decade 
> btrfs has taken already, without yet reaching a full feature set and full 
> stability.  IMO they may well have a point, tho AFAIK they're still new 
> and immature themselves and (I believe) don't have it either, so it's a 
> point that AFAIK has yet to be fully demonstrated.
> 
> We'll see how they evolve.  I do actually expect them to move faster than 
> btrfs, but also expect the interface may not be as smooth and unified as 
> they'd like to present as I expect there to remain some hiccups in 
> smoothing over the layering issues.  Also, because they've deliberately 
> chosen to go with existing technology where possible in ordered to evolve 
> to stability faster, by the same token they're deliberately limiting the 
> evolution to incremental over existing technology, and I expect there's 
> some stuff btrfs will do better as a result... at least until btrfs (or a 
> successor) becomes stable enough for them to integrate (parts of?) it as 
> existing demonstrated-stable technology.

I fully agree with the above sentences...
> 
> The other difference, AFAIK, is that stratis is specifically a 
> corporation making it a/the main money product, whereas btrfs was always 
> something the btrfs devs used at their employers (oracle, facebook), who 
> have other things as their main product.  As such, stratis is much more 
> likely to prioritize things like raid status monitors, hot-spares, etc, 
> that can be part of the product they sell, where they've been lower 
> priority for btrfs.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
