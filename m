Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56350 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752864AbdGXWm1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 18:42:27 -0400
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
To: Chris Mason <clm@fb.com>, dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <20170724142508.GW2866@twin.jikos.cz>
 <25d92d3d-52a8-8763-0936-c891d903c588@fb.com>
 <20170724184135.GA2866@twin.jikos.cz>
 <f4b9d041-6c07-fc31-91d2-b4f2f034df61@fb.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <85c34b15-adf6-3fc8-dd6c-25f94bc24a1f@mendix.com>
Date: Tue, 25 Jul 2017 00:42:25 +0200
MIME-Version: 1.0
In-Reply-To: <f4b9d041-6c07-fc31-91d2-b4f2f034df61@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 07/24/2017 08:53 PM, Chris Mason wrote:
> On 07/24/2017 02:41 PM, David Sterba wrote:
>> On Mon, Jul 24, 2017 at 02:01:07PM -0400, Chris Mason wrote:
>>> On 07/24/2017 10:25 AM, David Sterba wrote:
>>>
>>>> Thanks for the extensive historical summary, this change really
>>>> deserves
>>>> it.
>>>>
>>>> Decoupling the assumptions about the device's block management is
>>>> really
>>>> a good thing, mount option 'ssd' should mean that the device just has
>>>> cheap seeks. Moving the the allocation tweaks to ssd_spread provides a
>>>> way to keep the behaviour for anybody who wants it.
>>>>
>>>> I'd like to push this change to 4.13-rc3, as I don't think we need more
>>>> time to let other users to test this. The effects of current ssd
>>>> implementation have been debated and debugged on IRC for a long time.
>>>
>>> The description is great, but I'd love to see many more benchmarks.

Before starting a visual guide through a subset of benchmark-ish
material that I gathered in the last months, I would first like to point
at a different kind of benchmark, which is not a technical one. It would
be about measuring the end user adoption of the btrfs file system.

There are weeks in which no day goes by on IRC without a user joining
the channel in tears, asking "why is btrfs telling me my disk is full
when df says it's only 50% used"? Every time the IRC tribe has to do the
whole story about chunks, allocated space, used space, balance, the user
understands it a bit, or the user might give up, being confused why all
of this is necessary and why btrfs cannot just manage its own space a
bit, etc. Since a few weeks the debugging sessions have become a lot
shorter. "Ok, remount -o nossd, now try balance again, yay now it works
without "another xyz enospc during balance" errors, and keep it in your
fstab, kthxbye."

These are the users that know IRC or try the mailinglist. Others just
rage quit btrfs again accompanied with some not so nice words in a
twitter message.

This patch solves a significant part of this bad 'out of the box' behaviour.

This behaviour (fully allocating raw space and then crashing) has also
been the main reason at work to only keep btrfs for a few specific use
cases, in tightly controlled environment with extra monitoring on it.
With the -o nossd behaviour, I can start doing much more fun things with
it now, not having to walk around all day, using balance to clean up.

>>> At
>>> Facebook we use the current ssd_spread mode in production on top of
>>> hardware raid5/6 (spinning storage) because it dramatically reduces the
>>> read/modify/write cycles done for metadata writes.
>>
>> Well, I think this is an example that ssd got misused because of the
>> side effects of the allocation. If you observe good patterns for raid5,
>> then the allocator should be adapted for that case, otherwise
>> ssd/ssd_spread should be independent of the raid level.

If I have an iSCSI lun on a NetApp filer with rotating disks, which is
seek-free for random writes (they go to NVRAM and then to WAFL), but not
for random reads, does that make it an ssd, or not? (don't answer, it's
a useless question)

When writing this patch, I deliberately went for a scenario with minimal
impact in the code, but maximum impact in default behaviour for the end
user.

> Absolutely.  The optimizations that made ssd_spread useful for first
> generation flash are the same things that raid5/6 need.  Big writes, or
> said differently a minimum size for fast writes.
> 
>>
>>> If we're going to play around with these, we need a good way to measure
>>> free space fragmentation as part of benchmarks, as well as the IO
>>> patterns coming out of the allocator.

Yes! First a collection of use cases, then some reproducible
simulations, then measurements and timelapse pictures... Interesting.

By the way. In the last weeks I've been trying to debug excessive
metadata write IO behaviour of a large filesystem.

(from show_metadata_tree_sizes.py output:)
EXTENT_TREE  15.64GiB  0(1021576) 1(3692) 2(16) 3(1)

So far the results only point in the direction of btrfs meaning
butterfly effects, since I cannot seem to reliably cause things to
happen. However, I'll start a separate mail thread about the findings so
far, and some helper code for measuring things. Let's not do that in
here. This was about the data part at first.

>> Hans has a tool that visualizes the fragmentation. Most complaints I've
>> seen were about 'ssd' itself, excessive fragmentation, early ENOSPC. Not
>> many people use ssd_spread, 'ssd' gets turned on automatically so it has
>> much wider impact.
>>
>>> At least for our uses, ssd_spread matters much more for metadata than
>>> data (the data writes are large and metadata is small).

Exactly. Metadata. But that's a completely different story from data.
Actually, thanks for the idea, I'm gonna try a test with this later...
'nossd' data and 'ssd_spread' metadata.

>>  From the changes overview:
>>
>>> 1. Throw out the current ssd_spread behaviour.
>>
>> would it be ok for you to keep ssd_working as before?
>>
>> I'd really like to get this patch merged soon because "do not use ssd
>> mode for ssd" has started to be the recommended workaround. Once this
>> sticks, we won't need to have any ssd mode anymore ...

E.g. Debian Stretch has just been released with a 4.9 kernel. So, that
workaround will continue to be used for quite a while I guess...

> Works for me.  I do want to make sure that commits in this area include
> the workload they were targeting, how they were measured and what
> impacts they had.

For this one, it simply is... Btrfs default options that are supposed to
optimize things for an ssd must not exhibit behaviour that causes the
ssd to actually wear out faster.

> That way when we go back to try and change this again
> we'll understand what profiles we want to preserve.

Ok, there we go.

1. Just after I finished chunk level btrfs-heatmap. This shows a
continous fight against -o ssd filesystem with balance. 1 picture per
day, 2.5TiB or so fs.

https://www.youtube.com/watch?v=Qj1lxAasytc

2. The behaviour of -o ssd on a filesystem with a postfix mailserver,
mailman mailinglist server and mail logging in /var/log. Data-extent
level btrfs-heatmap timelapse, 4 pictures per hour, 4 block groups with
the highest vaddr:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-19-noautodefrag-ichiban.mp4

3. The behaviour of -o nossd on the same filesystem as 2:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4

4. Again, same fs as in 2 and 3. Guess at which point I switched from -o
ssd (automatically chosen, it's not even an ssd at all) to adding an
explicit -o nossd...

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-07-19-btrfs_usage_ssd_vs_nossd.png

(When it goes down, that's using balance)

5. A video of a ~40TiB filesystem that switches from -o ssd (no, it's
not an ssd, it was automatically chosen for me) to explicit -o nossd at
some point. I think you should be able to guess when exactly this
happens. 1 picture per day, ordered on virtual address space.

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-ssd-to-nossd.mp4

6. The effect of -o ssd on the filesystem in 5. At this point it was
already impossible to keep the allocated space down with balance.

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-backups-16-Q23.png

7. A collection of pictures of what block groups look like after they've
been abused by -o ssd:

https://syrinx.knorrie.org/~knorrie/btrfs/fragmented/

These pictures are from the filesystem in 5. After going nossd, I wrote
a custom balance script that operates on free space fragmentation level,
and started cleaning up the mess, worst fragmented first. It turned out
that for the fragmentation number it returned for a data block group
(second number in the file name), fragmented > 200 was quite bad, < 200
was not that bad.

8. Same timespan as the timelapse in 5, displayed as totals.

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-07-25-backups-17-Q23.png

All of the examples and more details about them can be found in mailing
list threads from the last months.

Have fun,

-- 
Hans van Kranenburg
