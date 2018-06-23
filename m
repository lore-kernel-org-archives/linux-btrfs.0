Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53672 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbeFWFON (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Jun 2018 01:14:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fWaq6-0003RO-HB
        for linux-btrfs@vger.kernel.org; Sat, 23 Jun 2018 07:11:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unsolvable technical issues?
Date: Sat, 23 Jun 2018 05:11:52 +0000 (UTC)
Message-ID: <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waxhead posted on Fri, 22 Jun 2018 01:13:31 +0200 as excerpted:

> According to this:
> 
> https://stratis-storage.github.io/StratisSoftwareDesign.pdf Page 4 ,
> section 1.2
> 
> It claims that BTRFS still have significant technical issues that may
> never be resolved.
> Could someone shed some light on exactly what these technical issues
> might be?! What are BTRFS biggest technical problems?
> 
> If you forget about the "RAID"5/6 like features then the only annoyances
> that I have with BTRFS so far is...
> 
> 1. Lack of per subvolume "RAID" levels
> 2. Lack of not using the deviceid to re-discover and re-add dropped
> devices
> 
> And that's about it really...

... And those both have solutions on the roadmap, with RFC patches 
already posted for #2 (tho I'm not sure they use devid) altho 
realistically they're likely to take years to appear and be tested to 
stability.  Meanwhile...

While as the others have said you really need to go to the author to get 
what was referred to, and I agree, I can speculate a bit.  While this 
*is* speculation, admittedly somewhat uninformed as I don't claim to be a 
dev, and I'd actually be interested in what others think so don't be 
afraid to tell me I haven't a clue, as long as you say why... based on 
several years reading the list now...

1) When I see btrfs "technical issue that may never be resolved", the #1 
first thing I think of, that AFAIK there are _definitely_ no plans to 
resolve, because it's very deeply woven into the btrfs core by now, is...

Filesystem UUID Identification.  Btrfs takes the UU bit of Universally 
Unique quite literally, assuming they really *are* unique, at least on 
that system, and uses them to identify the possibly multiple devices that 
may be components of the filesystem, a problem most filesystems don't 
have to deal with since they're single-device-only.  Because btrfs uses 
this supposedly unique ID to ID devices that belong to the filesystem, it 
can get *very* mixed up, with results possibly including dataloss, if it 
sees devices that don't actually belong to a filesystem with the same UUID 
as a mounted filesystem.

But technologies such as LVM allow cloning devices and these additional 
devices naturally have the same filesystem metadata, including filesystem 
UUID, as the original.  Making the problem worse is udev with its plug-n-
play style detection, which will normally trigger a btrfs device scan, 
thus making btrfs aware of new devices containing (a component of) a 
btrfs, as soon as udev detects the device.

So people, including users of redhat/fedora which standardizes on lvm and 
systemd/udev, have to be _very_ careful when cloning devices, etc, with 
existing mounted btrfs, not to allow btrfs to see the new clones, lest it 
get mixed up and write data to the wrong device due to it having the same 
UUID as the mounted filesystem, possibly resulting in data loss.

But btrfs made the choice to use UUID as if it were really unique, just 
as it says it is on the label, many years ago, when btrfs was much 
younger, and that choice is now embedded so deeply it's not practical to 
consider changing it to something else (tho there is a utility to allow a 
suitably careful user to change it on a cloned device, should it be 
necessary).

For someone standardized on a solution such as lvm, that could be 
considered an unsolvable technical issue indeed, and indeed, I don't 
believe anyone here will argue that it's going to change.  Tho I'd 
definitely argue the bug is in apps that deliberately make UUIDs non-UUID 
any longer, no longer unique, not in btrfs, which simply takes the claim 
on the label at face value.


While that's the only truly "unsolvable" one I know of, depending on 
one's strictness in defining "unsolvable" and the scope of the time frame 
under consideration, it's quite conceivable (indeed, having read a bit 
about them before, it seems to be the case, certainly the PR case) that 
stratis, et. al., have lost patience at the slow pace of btrfs 
development, and consider various other still missing features as now 
"practically insolvable as in won't be solved to production ready", at 
least in a "reasonable" time frame of under say 3-5 (or 5-7, or whatever) 
years.  These could arguably include:

2) Subvolume and (more technically) reflink-aware defrag.

It was there for a couple kernel versions some time ago, but "impossibly" 
slow, so it was disabled until such time as btrfs could be made to scale 
rather better in this regard.

There's no hint yet as to when that might actually be, if it will _ever_ 
be, so this can arguably be validly added to the "may never be resolved" 
list.

3) N-way-mirroring.

This one was on the roadmap for "right after raid56 support, since it'll 
use some of that code", since at least 3.5, when raid56 was supposed to 
be introduced in 3.6.  I know because this is the one I've been most 
looking forward to personally, tho my original reason, aging but still 
usable devices that I wanted extra redundancy for, has long since itself 
been aged out of rotation.

Of course we know the raid56 story and thus the implied delay here, if 
it's even still roadmapped at all now, and as with reflink-aware-defrag, 
there's no hint yet as to when we'll actually see this at all, let alone 
see it in a reasonably stable form, so at least in the practical sense, 
it's arguably "might never be resolved."

4) (Until relatively recently, and still in terms of scaling) Quotas.

Until relatively recently, quotas could arguably be added to the list.  
They were rewritten multiple times, and until recently, appeared to be 
effectively eternally broken.

While that has happily changed recently and (based on the list, I don't 
use 'em personally) quotas actually seem at least someone usable these 
days (altho less critical bugs are still being fixed), AFAIK quota 
scalability while doing btrfs maintenance remains a serious enough issue 
that the recommendation is to turn them off before doing balances, and 
the same would almost certainly apply to reflink-aware-defrag (turn 
quotas off before defraging) were it available, as well.  That 
scalability alone could arguably be a "technical issue that may never be 
resolved", and while quotas themselves appear to be reasonably functional 
now, that could arguably justify them still being on the list.


And of course that's avoiding the two you mentioned, tho arguably they 
could go on the "may in practice never be resolved, at least not in the 
non-bluesky lifetime" list as well.


As for stratis, supposedly they're deliberately taking existing proven in 
multi-layer-form technology and simply exposing it in unified form.  They 
claim this dramatically lessens the required new code and shortens time-
to-stability to something reasonable, in contrast to the about a decade 
btrfs has taken already, without yet reaching a full feature set and full 
stability.  IMO they may well have a point, tho AFAIK they're still new 
and immature themselves and (I believe) don't have it either, so it's a 
point that AFAIK has yet to be fully demonstrated.

We'll see how they evolve.  I do actually expect them to move faster than 
btrfs, but also expect the interface may not be as smooth and unified as 
they'd like to present as I expect there to remain some hiccups in 
smoothing over the layering issues.  Also, because they've deliberately 
chosen to go with existing technology where possible in ordered to evolve 
to stability faster, by the same token they're deliberately limiting the 
evolution to incremental over existing technology, and I expect there's 
some stuff btrfs will do better as a result... at least until btrfs (or a 
successor) becomes stable enough for them to integrate (parts of?) it as 
existing demonstrated-stable technology.

The other difference, AFAIK, is that stratis is specifically a 
corporation making it a/the main money product, whereas btrfs was always 
something the btrfs devs used at their employers (oracle, facebook), who 
have other things as their main product.  As such, stratis is much more 
likely to prioritize things like raid status monitors, hot-spares, etc, 
that can be part of the product they sell, where they've been lower 
priority for btrfs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

