Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44703 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S935657AbeF3DYe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 23:24:34 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fZ6Sr-0008Vh-GQ
        for linux-btrfs@vger.kernel.org; Sat, 30 Jun 2018 05:22:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unsolvable technical issues?
Date: Sat, 30 Jun 2018 03:22:13 +0000 (UTC)
Message-ID: <pan$15832$609432db$876d9a8a$e5840f46@cox.net>
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
        <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
        <646f0c52-4726-7a7d-0242-4412950bf002@libero.it>
        <64876ad1-9f63-f6f0-9d55-0fa4999f0bf5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 25 Jun 2018 07:26:41 -0400 as
excerpted:

> On 2018-06-24 16:22, Goffredo Baroncelli wrote:
>> On 06/23/2018 07:11 AM, Duncan wrote:
>>> waxhead posted on Fri, 22 Jun 2018 01:13:31 +0200 as excerpted:
>>>
>>>> According to this:
>>>>
>>>> https://stratis-storage.github.io/StratisSoftwareDesign.pdf Page 4 ,
>>>> section 1.2
>>>>
>>>> It claims that BTRFS still have significant technical issues that may
>>>> never be resolved.
>>>
>>> I can speculate a bit.
>>>
>>> 1) When I see btrfs "technical issue that may never be resolved", the
>>> #1 first thing I think of, that AFAIK there are _definitely_ no plans
>>> to resolve, because it's very deeply woven into the btrfs core by now,
>>> is...
>>>
>>> [1)] Filesystem UUID Identification.  Btrfs takes the UU bit of
>>> Universally Unique quite literally, assuming they really *are*
>>> unique, at least on that system[.]  Because
>>> btrfs uses this supposedly unique ID to ID devices that belong to the
>>> filesystem, it can get *very* mixed up, with results possibly
>>> including dataloss, if it sees devices that don't actually belong to a
>>> filesystem with the same UUID as a mounted filesystem.
>> 
>> As partial workaround you can disable udev btrfs rules and then do a
>> "btrfs dev scan" manually only for the device which you need.

> You don't even need `btrfs dev scan` if you just specify the exact set
> of devices in the mount options.  The `device=` mount option tells the
> kernel to check that device during the mount process.

Not that lvm does any better in this regard[1], but has btrfs ever solved 
the bug where only one device= in the kernel commandline's rootflags= 
would take effect, effectively forcing initr* on people (like me) who 
would otherwise not need them and prefer to do without them, if they're 
using a multi-device btrfs as root?

Not to mention the fact that as kernel people will tell you, device 
enumeration isn't guaranteed to be in the same order every boot, so 
device=/dev/* can't be relied upon and shouldn't be used -- but of course 
device=LABEL= and device=UUID= and similar won't work without userspace, 
basically udev (if they work at all, IDK if they actually do).

Tho in practice from what I've seen, device enumeration order tends to be 
dependable /enough/ for at least those without enterprise-level numbers 
of devices to enumerate.  True, it /does/ change from time to time with a 
new kernel, but anybody sane keeps a tested-dependable old kernel around 
to boot to until they know the new one works as expected, and that sort 
of change is seldom enough that users can boot to the old kernel and 
adjust their settings for the new one as necessary when it does happen.  
So as "don't do it that way because it's not reliable" as it might indeed 
be in theory, in practice, just using an ordered /dev/* in kernel 
commandlines does tend to "just work"... provided one is ready for the 
occasion when that device parameter might need a bit of adjustment, of 
course.

> Also, while LVM does have 'issues' with cloned PV's, it fails safe (by
> refusing to work on VG's that have duplicate PV's), while BTRFS fails
> very unsafely (by randomly corrupting data).

And IMO that "failing unsafe" is both serious and common enough that it 
easily justifies adding the point to a list of this sort, thus my putting 
it #1.

>>> 2) Subvolume and (more technically) reflink-aware defrag.
>>>
>>> It was there for a couple kernel versions some time ago, but
>>> "impossibly" slow, so it was disabled until such time as btrfs could
>>> be made to scale rather better in this regard.

> I still contend that the biggest issue WRT reflink-aware defrag was that
> it was not optional.  The only way to get the old defrag behavior was to
> boot a kernel that didn't have reflink-aware defrag support.  IOW,
> _everyone_ had to deal with the performance issues, not just the people
> who wanted to use reflink-aware defrag.

Absolutely.

Which of course suggests making it optional, with a suitable warning as 
to the speed implications with lots of snapshots/reflinks, when it does 
get enabled again (and as David mentions elsewhere, there's apparently 
some work going into the idea once again, which potentially moves it from 
the 3-5 year range, at best, back to a 1/2-2-year range, time will tell).

>>> 3) N-way-mirroring.
>>>
>> [...]
>> This is not an issue, but a not implemented feature
> If you're looking at feature parity with competitors, it's an issue.

Exactly my point.  Thanks. =:^)

>>> 4) (Until relatively recently, and still in terms of scaling) Quotas.
>>>
>>> Until relatively recently, quotas could arguably be added to the list.
>>> They were rewritten multiple times, and until recently, appeared to be
>>> effectively eternally broken.
>> 
>> Even tough what you are reporting is correct, I have to point out that
>> the quota in BTRFS is more complex than the equivalent one of the other
>> FS.

Which, arguably, is exactly Stratis' point.  "More complex" to the point 
it might never, at least in reasonable-planning-horizon-time, actually be 
reliable enough for general production use, and if it /does/ happen to 
meet /that/ qualification, due to all that complexity it could very 
possibly still scale horribly enough that it's /still/ not actually 
practically usable for many planning-horizon use-cases.

And Stratis' answer to that problem they've pointed out with btrfs is to 
use existing and already demonstrated production-stable technologies, 
simply presenting them in a new, now unified-management, whole.

And IMO they have a point, tho AFAIK they've not yet demonstrated that 
they are /the/ solution just yet.  But I hope they do, because zfs, the 
existing all-in-one solution,  has a serious square-zfs-peg-in-round--
linux-hole issue in at least two areas, license-wise and cache-technology-
wise, leaving a serious void that remains to be filled, possibly 
eventually with btrfs, but it's taking its time to get there, and if 
stratis can fill it with more practical, less pie-in-the-sky, until then, 
great!

---
[1] LVM is userspace code on top of the kernelspace devicemapper, and 
therefore requires an initr* if root is on lvm, regardless.  So btrfs 
actually does a bit better here, only requiring it for multi-device btrfs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

