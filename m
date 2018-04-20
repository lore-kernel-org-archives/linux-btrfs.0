Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46399 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754355AbeDTJT2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 05:19:28 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1f9SAM-0006uM-Ps
        for linux-btrfs@vger.kernel.org; Fri, 20 Apr 2018 11:17:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recovery from full metadata with all device space consumed?
Date: Fri, 20 Apr 2018 09:17:08 +0000 (UTC)
Message-ID: <pan$85273$f56d4187$3e46812d$76c537cd@cox.net>
References: <20180419220848.GB24508@bottomless.cesspool.net>
        <CAGqmi76R9LwZhcE4KCxNyOJVCRK27GBzaVmO9v5C-HhHsKbQ3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timofey Titovets posted on Fri, 20 Apr 2018 01:32:42 +0300 as excerpted:

> 2018-04-20 1:08 GMT+03:00 Drew Bloechl <drew@cesspool.net>:
>> I've got a btrfs filesystem that I can't seem to get back to a useful
>> state. The symptom I started with is that rename() operations started
>> dying with ENOSPC, and it looks like the metadata allocation on the
>> filesystem is full:
>>
>> # btrfs fi df /broken
>> Data, RAID0: total=3.63TiB, used=67.00GiB
>> System, RAID1: total=8.00MiB, used=224.00KiB
>> Metadata, RAID1: total=3.00GiB, used=2.50GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> All of the consumable space on the backing devices also seems to be in
>> use:
>>
>> # btrfs fi show /broken Label: 'mon_data'  uuid:
>> 85e52555-7d6d-4346-8b37-8278447eb590
>>         Total devices 4 FS bytes used 69.50GiB
>>         devid    1 size 931.51GiB used 931.51GiB path /dev/sda1
>>         devid    2 size 931.51GiB used 931.51GiB path /dev/sdb1
>>         devid    3 size 931.51GiB used 931.51GiB path /dev/sdc1
>>         devid    4 size 931.51GiB used 931.51GiB path /dev/sdd1
>>
>> Even the smallest balance operation I can start fails (this doesn't
>> change even with an extra temporary device added to the filesystem):
>>
>> # btrfs balance start -v -dusage=1 /broken
>> Dumping filters: flags 0x1, state 0x0, force is off
>>   DATA (flags 0x2): balancing, usage=1
>> ERROR: error during balancing '/broken': No space left on device
>> There may be more info in syslog - try dmesg | tail
>> # dmesg | tail -1
>> [11554.296805] BTRFS info (device sdc1): 757 enospc errors during
>> balance
>>
>> The current kernel is 4.15.0 from Debian's stretch-backports
>> (specifically linux-image-4.15.0-0.bpo.2-amd64), but it was Debian's
>> 4.9.30 when the filesystem got into this state. I upgraded it in the
>> hopes that a newer kernel would be smarter, but no dice.
>>
>> btrfs-progs is currently at v4.7.3.
>>
>> Most of what this filesystem stores is Prometheus 1.8's TSDB for its
>> metrics, which are constantly written at around 50MB/second. The
>> filesystem never really gets full as far as data goes, but there's a
>> lot of never-ending churn for what data is there.
>>
>> Question 1: Are there other steps that can be tried to rescue a
>> filesystem in this state? I still have it mounted in the same state,
>> and I'm willing to try other things or extract debugging info.
>>
>> Question 2: Is there something I could have done to prevent this from
>> happening in the first place?
> 
> Not sure why this happening,
> but if you stuck at that state:
>   - Reboot to ensure no other problems will exists
>   - Add any other external device temporary to FS, as example zram.
>     After you free small part of fs, delete external dev from FS and
> continue balance chunks.

He did try adding a temporary device.  Requoting from above:

>> Even the smallest balance operation I can start fails (this doesn't
>> change even with an extra temporary device added to the filesystem):

Never-the-less, that's the right idea in general, but I believe the 
following additional suggestions, now addressed to the original poster, 
will help.

1) Try with -dusage=0.

With any luck there will be some totally empty data chunks, which this 
should free, hopefully getting you at least enough space for the -dusage=1 
to work and free additional space.

The reason this can work is that unlike with actual usage, entirely empty 
chunks don't require writing a fresh block to copy the used extents 
into... because there aren't any.  But of course it does require that 
there's some totally empty chunks available to free, which with your 
numbers is somewhat likely, but not a given, especially since newer 
kernels (well, since some time now, but...) normally free entirely empty 
chunks automatically.

FWIW, 0-usage balances are near instant as all it has to do is eliminate 
the empty chunks from the chunk list.  1% usage balances, once you can do 
them, will go real fast too, and in your state may get you back some 
decent unallocated, tho they probably won't do much for people in less 
extreme unbalance conditions.  10% will do more and take a bit longer, 
but still be fast as it's only writing 1/10th of the chunk size, and as 
long as there's enough chunks at that level, it'll still be returning 10 
for every full one it rewrites.  At 50% it'll take much longer but will 
still be returning 2 chunks for every one it writes.  Above that, the 
payback goes down rather fast, so you're only getting back 1 for 2 
written at 67%, and one for 9 written at 90%.  As such, on spinning rust 
it's rarely worth trying above 70% or so, and often not worth trying 
above 50%, unless of course the filesystem really is almost full and you 
are trying to reclaim every last bit of unused chunk space to unallocated 
you can, regardless of the time it takes.  FWIW I'm on ssd and partition 
up so my filesystems are normally under 100 GiB, so even a full balance 
normally only takes a few minutes, but I still don't normally bother with 
anything over -dusage=70  (or -musage=70, for metadata) or so.

If starting with -dusage=0 doesn't get you anything back...

2) Unfortunately, due to metadata being 100% full (that reserve space 
comes from metadata, and adding reserve to used metadata, you're at 100%) 
and relocating data chunks requiring rewriting metadata, with copy-on-
write so it must be rewritten elsewhere BUT no unallocated space 
available to create more chunks to rewrite it, AND with metadata being 
the default raid1 mode...

Adding a single additional device will still not work, because there's 
still no space to write the raid1 second copy of that needed metadata 
chunk.  That explains the failure in that case.

BUT, adding *TWO* additional devices should work rather better, because 
that'll let btrfs create the necessary raid1 copy of the new metadata 
chunk.  (IDR if btrfs raid0 for the data would require a second device or 
not and my experience is raid1, but it might, and the metadata needs it 
anyway, so...)

The raid0 data suggests data chunks are likely to be 4 GiB (as 1 GiB 
across four devices), so while smaller "extra" devices might work, I'd 
shoot for a pair of say 16 GB each, minimum (bigger would be fine), and 
would be unsurprised if under 5 GiB each failed, with 5-16 GiB each 
possibly working, possibly not.

I don't /think/ you'll need four additional devices, but if two devices 
of 16 gig each minimum doesn't help, it couldn't hurt to try four, just 
in case.  (You probably don't have 64 GiB of free RAM, or maybe you do 
but don't want to risk losing the data in a crash, but a 64 GiB or so 
thumb drive, partitioned up into four 16 GiB partitions so each can be 
used as a different virtual device should do it... if a bit slow due to 
thumb-drive flash.)


Once you get things working again, avoiding the same problem repeating...

3) If perchance the filesystem is getting mounted with the ssd option, 
either because you put it there or implied/detected as such by btrfs due 
to lack of the rotational attribute on the composing devices...

There's a recent (4.14 IIRC, definitely after the 4.9 you were using 
previously) btrfs ssd mode extent-allocator change that should keep btrfs 
from being so data-chunk hungry, as it'll fill in existing partially used 
chunks more instead of constantly allocating new ones.  If it is using 
ssd mode that should help, but with your usage pattern it might not have 
been the only problem, and of course without ssd mode it wouldn't have 
been the problem at all.

In any case, to prevent the same problem again...

4) Keep an eye on your data chunk total vs. used numbers, and more 
importantly, your unallocated space (more about how to get these in #5).  
If the spread between data total and data used gets too big, or the 
unallocated space drops too low, do a balance -dusage= accordingly.

Currently your btrfs fi df shows 3.6+ TiB total data chunks allocated, 
but only 67 GiB used.  That's ***WAY*** out of whack.  Again, your usage 
pattern is at least part of the reason, but ssd mode on older kernels 
would have certainly exacerbated the problem.

Until your filesystem fills up more, try to keep total data chunks 
allocated under say half or one TiB.  That should leave well over a TiB 
of entirely unallocated free space, even if you don't catch a runaway 
right away and it gets to 2 TiB allocated before you catch it.

As your filesystem fills up, you'll obviously need to allow more data 
allocation and drop the unallocated, but keeping at least say 16 GiB free 
(not chunk allocated at all) on each device should keep you out of 
trouble.

5) The easiest way to check usage is the btrfs fi usage command, but it's 
also a relatively new command and isn't available in older btrfs-progs.  
I /think/ progs 4.7 had it, but I'd suggest upgrading to newer in any 
case.  It doesn't have to be the newest (until you want the best chance 
at recovery with btrfs restore or check and repair with btrfs check), but 
something near 4.14 or newer would be nice.

The older and more difficult way to get almost the same information is 
comparing both btrfs fi show and btrfs fi df.  Since that's what you 
posted, I'll use it here:

>> # btrfs fi df /broken
>> Data, RAID0: total=3.63TiB, used=67.00GiB
>> System, RAID1: total=8.00MiB, used=224.00KiB
>> Metadata, RAID1: total=3.00GiB, used=2.50GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> All of the consumable space on the backing devices also seems to be in
>> use:
>>
>> # btrfs fi show /broken Label: 'mon_data'  uuid:
>> 85e52555-7d6d-4346-8b37-8278447eb590
>>         Total devices 4 FS bytes used 69.50GiB
>>         devid    1 size 931.51GiB used 931.51GiB path /dev/sda1
>>         devid    2 size 931.51GiB used 931.51GiB path /dev/sdb1
>>         devid    3 size 931.51GiB used 931.51GiB path /dev/sdc1
>>         devid    4 size 931.51GiB used 931.51GiB path /dev/sdd1

As you suggest, all space on all devices is used.  While fi usage breaks 
out unallocated as its own line-item, both per device and overall, with
fi show/df you have to derive it from the difference between size and 
used on each device listed in the fi show report.

If (after getting it that way with balance) you keep fi show per-device 
used under say 250 or 500 MiB, that'll go to unallocated, as fi usage 
will make clearer.

Meanwhile, for fi df, that data line says 3.6+ TiB total data chunk 
allocations, but only 67 GiB used.  As I said, that's ***WAY*** out of 
whack, and getting it back into something a bit more normal and keeping 
it there, for under 100 GiB actually used, say under say 250 or 500 GiB 
total, with the rest returned to unallocated, dropping the used in the fi 
df report and increasing unallocated in fi usage, should keep you well 
out of trouble.

As for fi usage, While I use a bunch of much smaller filesystems here, 
all raid1 or dup, so it'll be of limited direct help, I'll post the 
output from one of mine, just so you can see how much easier it is to 
read the fi usage report:

$$ sudo btrfs filesystem usage /
Overall:
    Device size:                  16.00GiB
    Device allocated:              7.02GiB
    Device unallocated:            8.98GiB
    Device missing:                  0.00B
    Used:                          4.90GiB
    Free (estimated):              5.25GiB      (min: 5.25GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,RAID1: Size:3.00GiB, Used:2.24GiB
   /dev/sda5       3.00GiB
   /dev/sdb5       3.00GiB

Metadata,RAID1: Size:512.00MiB, Used:209.59MiB
   /dev/sda5     512.00MiB
   /dev/sdb5     512.00MiB

System,RAID1: Size:8.00MiB, Used:16.00KiB
   /dev/sda5       8.00MiB
   /dev/sdb5       8.00MiB

Unallocated:
   /dev/sda5       4.49GiB
   /dev/sdb5       4.49GiB

(FWIW there's also btrfs device usage, if you want a device-focused 
report.)

This is a btrfs raid1 both data and metadata, on a pair of 8 GiB devices, 
thus 16 GiB total.

Of that 8 GiB per device, a very healthy 4.49 GiB per device, over half 
the filesystem, remains entirely chunk-level unallocated and thus free to 
allocate to data or metadata chunks as needed.

Meanwhile, data chunk allocation is 3 GiB total per device, of which 2.24 
GiB is used.  Again, that's healthy, as data chunks are nominally 1 GiB 
so that's probably three 1 GiB chunks allocated, with 2.24 GiB of it used.

By contrast, your in-trouble fi usage report will show (near) 0 
unallocated and a ***HUGE*** gap between size/total and used for data, 
while you should be easily able to get per-device data totals down to say 
250 GiB or so (or down to 10 GiB or so with more work), with it all 
switching to unallocated, and then keep it healthy by doing a balance 
with -dusage= as necessary any time the numbers start getting out of line 
again.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

