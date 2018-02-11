Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38828 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752936AbeBKBC5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Feb 2018 20:02:57 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
Date: Sun, 11 Feb 2018 02:02:53 +0100
MIME-Version: 1.0
In-Reply-To: <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

On 02/10/2018 07:29 PM, Ellis H. Wilson III wrote:
> Thank you very much for your response Hans.  Comments in-line, but I did
> want to handle one miscommunication straight-away:
> 
> I'm a huge fan of BTRFS.  If I came off like I was complaining, my
> sincere apologies.   To be completely transparent we are using BTRFS in
> a very large project at my company, which I am lead architect on, and
> while I have read the academic papers, perused a subset of the source
> code, and been following it's development in the background, I now need
> to deeply understand where there might be performance hiccups.

I'd suggest just trying to do what you want to do for real, finding out
what the problems are and then finding out what to do about them, but I
think that's already almost exactly what you've started doing now. :)

If you ask 100 different btrfs users about your specific situation, you
probably get 100 different answers. So, I'll just throw some of my own
thoughts in here, which may or may not make sense for you.

> All of
> our foreground I/O testing with BTRFS in RAID0/RAID1/single across
> different SSDs and HDDs has been stellar, but we haven't dug too far
> into snapshot performance, balancing, and other more background-oriented
> performance.  Hence my interest in finding documentation and analysis I
> can read and grok myself on the implications of snapshot operations on
> foreground I/O if such exists.

> More in-line below:
> 
> On 02/09/2018 03:36 PM, Hans van Kranenburg wrote:
>>> This has proven thus far less than helpful, as
>>> the response tends to be "use less snapshots," or "disable quotas," both
>>> of which strike me as intellectually unsatisfying answers
>>
>> Well, sometimes those answers help. :) "Oh, yes, I disabled qgroups, I
>> didn't even realize I had those, and now the problem is gone."
> 
> I meant less than helpful for me, since for my project I need detailed
> and fairly accurate capacity information per sub-volume, and the
> relationship between qgroups and subvolume performance wasn't being
> spelled out in the responses.  Please correct me if I am wrong about
> needing qgroups enabled to see detailed capacity information
> per-subvolume (including snapshots).

Aha, so you actually want to use qgroups.

>>> the former in a filesystem where snapshots are supposed to be
>>> "first-class citizens."

They are. But if you put extra optional feature X Y and Z on top which
kill your performance, then they are still supposed to be first-class
citizens, but feature X Y and Z might start blurring it a bit.

The problem is that qgroups and quota etc is still in development and if
you ask the developers, they are probably honest about the fact that you
cannot just enable that part of the functionality without some expected
and unexpected performance side effects.

>> Throwing complaints around is also not helpful.
> 
> Sorry about this.  It wasn't directed in any way at BTRFS developers,
> but rather some of the suggestions for solution proposed in random
> forums online.
> As mentioned I'm a fan of BTRFS, especially as my
> project requires the snapshots to truly be first-class citizens in that
> they are writable and one can roll-back to them at-will, unlike in ZFS
> and other filesystems.  I was just saying it seemed backwards to suggest
> having less snapshots was a solution in a filesystem where the
> architecture appears to treat them as a core part of the design.

And I was just saying that subvolumes and snapshots are fine, and that
you shouldn't blame them while your problems might be more likely
qgroups/quota related.

>> The "performance implications" are highly dependent on your specific
>> setup, kernel version, etc, so it really makes sense to share:
>>
>> * kernel version
>> * mount options (from /proc/mounts|grep btrfs)
>> * is it ssd? hdd? iscsi lun?
>> * how big is the FS
>> * how many subvolumes/snapshots? (how many snapshots per subvolume)
> 
> I will answer the above, but would like to reiterate my previous comment
> that I still would like to understand the fundamental relationships here
> as in my project kernel version is very likely to change (to more
> recent), along with mount options and underlying device media.  Once
> this project hits the field I will additionally have limited control
> over how large the FS gets (until physical media space is exhausted of
> course) or how many subvolumes/snapshots there are.  If I know that
> above N snapshots per subvolume performance tanks by M%, I can apply
> limits on the use-case in the field, but I am not aware of those kinds
> of performance implications yet.
> 
> My present situation is the following:
> - Fairly default opensuse 42.3.
> - uname -a: Linux betty 4.4.104-39-default #1 SMP Thu Jan 4 08:11:03 UTC
> 2018 (7db1912) x86_64 x86_64 x86_64 GNU/Linux

You're ignoring 2 years of development and performance improvements. I'd
suggest jumping forward to 4.14 to see which part of your problems will
disappear already.

> - /dev/sda6 / btrfs
> rw,relatime,ssd,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot
> 0 0

Note that changes on atime cause writes to metadata, which means cowing
metadata blocks and unsharing them from a previous snapshot, only when
using the filesystem, not even when changing things (!). I don't know
what the exact pattern of consequences for quota and subvolume removal
is, but I always mount with noatime to prevent unnecessary metadata
writes from happening when just accessing files.

> (I have about 10 other btrfs subvolumes, but this is the only one being
> snapshotted)
> - At the time of my noticing the slow-down, I had about 24 snapshots, 10
> of which were in the process of being deleted
> - Usage output:
> ~> sudo btrfs filesystem usage /
> Overall:
>     Device size:          40.00GiB

Ok, so small filesystem.

>     Device allocated:          11.54GiB
>     Device unallocated:          28.46GiB
>     Device missing:             0.00B
>     Used:               7.57GiB
>     Free (estimated):          32.28GiB    (min: 32.28GiB)
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:          28.44MiB    (used: 0.00B)
> Data,single: Size:11.01GiB, Used:7.19GiB
>    /dev/sda6      11.01GiB
> Metadata,single: Size:512.00MiB, Used:395.91MiB
>    /dev/sda6     512.00MiB
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/sda6      32.00MiB
> Unallocated:
>    /dev/sda6      28.46GiB
> 
>> And what's essential to look at is what your computer is doing while you
>> are throwing a list of subvolumes into the cleaner.
>>
>> * is it using 100% cpu?
>> * is it showing 100% disk read I/O utilization?
>> * is it showing 100% disk write I/O utilization? (is it writing lots and
>> lots of data to disk?)
> 
> I noticed the problem when Thunderbird became completely unresponsive. I
> fired up top, and btrfs-cleaner was at the top, along with snapper.

Oh, snapper? Is there a specific reason why you want to use snapper as
the tool for whatever thing you're planning to do?

> btrfs-cleaner was at 100% cpu (single-core) for the entirety of the
> time.

Ok, so your problem is 100% cpu, not excessive disk I/O.

> I knew I had about 24 snapshots prior to this, and after about
> 60s when the pain subsided only about 14 remained, so I estimate 10 were
> deleted as part of snapper's cleaning algorithm.  I quickly also ran
> dstat during the slow-down, and after 5s it finally started and reported
> only about 3-6MB/s in terms of read and write to the drive in question.
> 
> I have since run top and dstat before running snapper cleaner manually,
> and the system lock-up does still occur, albeit for shorter times as
> I've only done it with a few snapshots and not much changed in each.

There certainly are performance improvements made in qgroups in the last
few years, so to repeat myself, please get a recent kernel version first.

I don't use qgroups/quota myself, so I can't be of much help on a
detailed level.

-- 
Hans van Kranenburg
