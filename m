Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:35495 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752223AbcKSBi2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 20:38:28 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
 <02310b0f-5fed-746a-ca05-d655dce7d57a@cn.fujitsu.com>
 <9945f788-2516-007b-43ce-dabcff263cd8@mendix.com>
 <b2e58da2-7f47-8827-3179-31ff50c9b6b9@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <ef9152fa-3c5c-ad23-a09e-e018ac0d0d6b@mendix.com>
Date: Sat, 19 Nov 2016 02:38:24 +0100
MIME-Version: 1.0
In-Reply-To: <b2e58da2-7f47-8827-3179-31ff50c9b6b9@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 11/19/2016 01:57 AM, Qu Wenruo wrote:
> On 11/18/2016 11:08 PM, Hans van Kranenburg wrote:
>> On 11/18/2016 03:08 AM, Qu Wenruo wrote:
>>>>> I don't see what displaying a blockgroup-level aggregate usage number
>>>>> has to do with multi-device, except that the same %usage will appear
>>>>> another time when using RAID1*.
>>>
>>> Although in fact, for profiles like RAID0/5/6/10, it's completely
>>> possible that one dev_extent contains all the data, while another
>>> dev_extent is almost empty.
>>
>> When using something like RAID0 profile, I would expect 50% of the data
>> to end up in one dev_extent and 50% in the other?
> 
> First I'm mostly OK with current grayscale.
> What I'm saying can be considered as nitpicking.
> 
> The only concern is, the for full fs output, we are in fact output
> dev_extents of each device.
> 
> In that case, we should output info at the same level of dev_extent.
> 
> So if we really need to provide *accurate* gray scale, then we should
> base on the %usage of a dev extent.
> 
> And for 50%/50% assumption for RAID0, it's not true and we can easily
> create a case where it's 100%/0%
> 
> [...]
> 
> Then, only the 2nd data stripe has data, while the 1st data stripe are
> free.

Ah, yes, I see, that's a good example.

So technically, for others than single and RAID1, just using the
blockgroup usage might be wrong. OTOH, for most cases it will still be
"correct enough" for the eye, because statistically seen, distribution
of data over the stripes will be more uniform more often than not. It's
good to realize, but I'm fine with having this as a "known limitation".

> Things will become more complicated when RAID5/6 is involved.

Yes.

So being able to show a specific dev extent with the actual info (sorted
by physical byte location) would be a nice addition. Since it also
requires walking the extent tree for the related block group and doing
calculations on the ranges, it's not feasible for the high level file
system picture to do.

>>> Strictly speaking, at full fs or dev level, we should output things at
>>> dev_extent level, then greyscale should be representing dev_extent
>>> usage(which is not possible or quite hard to calculate)
>>
>> That's what it's doing now?
>>
>>> Anyway, the greyscale is mostly OK, just as a good addition output for
>>> full fs graph.
>>
>> I don't follow.
>>
>>> Although if it could output the fs or specific dev without gray scale, I
>>> think it would be better.
>>> It will be much clearer about the dev_extent level fragments.
>>
>> I have no idea what you mean, sorry.
> 
> The point is, for full fs or per-device output, a developer may focus on
> the fragments of unallocated space in each device.
> 
> In that case, an almost empty bg will be much like unallocated space.

The usage (from 0 to 100) is translated into a brightness between 16 and
255, which already causes empty allocated space to be visually
distinguishable from unallocated space:

def _brightness(self, used_pct):
    return 16 + int(round(used_pct * (255 - 16)))

If you need it to be more clear, just increase the value to more than 16
and voila.

> So I hope if there is any option to disable greyscale at full fs output,
> it would be much better.

It's just some python, don't hesitate to change it and try things out.

     def _brightness(self, used_pct):
+        return 255
-        return 16 + int(round(used_pct * (255 - 16)))

Et voila, 0% used is bright white now. The experience of the resulting
image is really different, but if it helps in certain situations, it's
quite easy to get it done.

> Just like the blockgroup output, only black and while, and the example
> in the github is really awesome!
> 
> It shows a lot of thing I didn't have a clear view before.
> Like batched metadata extents (mostly for csum tree) and fragmented
> metadata for other trees.

:D

First thing I want to do with the blockgrouplevel pics is make a
"rolling heatmap" of the 4 highest vaddr blockgroups combined of the
filesystem that this thread was about:

http://www.spinics.net/lists/linux-btrfs/msg54940.html

First I'm going to disable autodefrag again, take a picture a few times
per hour, let it run for a few days, and then do the same thing again
with autodefrag enabled. (spoiler: even with autodefrag enabled, it's a
disaster)

But the resulting timelapse videos will show really interesting
information on the behaviour of autodefrag I guess. Can't wait to see them.

-- 
Hans van Kranenburg
