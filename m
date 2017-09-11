Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45780 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbdIKAMy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 20:12:54 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1drCKz-0000Y9-9j
        for linux-btrfs@vger.kernel.org; Mon, 11 Sep 2017 02:12:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help me understand what is going on with my RAID1 FS
Date: Mon, 11 Sep 2017 00:12:16 +0000 (UTC)
Message-ID: <pan$8d4b3$ad684062$c16fc0e3$fa59ca26@cox.net>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FLJ posted on Sun, 10 Sep 2017 15:45:42 +0200 as excerpted:

> I have a BTRFS RAID1 volume running for the past year. I avoided all
> pitfalls known to me that would mess up this volume. I never
> experimented with quotas, no-COW, snapshots, defrag, nothing really.
> The volume is a RAID1 from day 1 and is working reliably until now.
> 
> Until yesterday it consisted of two 3 TB drives, something along the
> lines:
> 
> Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
>         Total devices 2 FS bytes used 2.47TiB
>         devid    1 size 2.73TiB used 2.47TiB path /dev/sdb
>         devid    2 size 2.73TiB used 2.47TiB path /dev/sdc

I'm going to try a different approach than I see in the two existing 
subthreads, so I started from scratch with my own subthread...

So the above looks reasonable so far...

> 
> Yesterday I've added a new drive to the FS and did a full rebalance
> (without filters) over night, which went through without any issues.
> 
> Now I have:
>  Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
>         Total devices 3 FS bytes used 2.47TiB
>         devid    1 size 2.73TiB used 1.24TiB path /dev/sdb
>         devid    2 size 2.73TiB used 1.24TiB path /dev/sdc
>         devid    3 size 7.28TiB used 2.48TiB path /dev/sda

That's exactly as expected, after a balance.

Note the size, 2.73 TiB (twos-power) for the smaller two, not 3 (tho it's 
probably 3 TB, tens-power), 7.28 TiB, not 8, for the larger one.

The most-free-space chunk allocation, with raid1-paired chunks, means the 
first chunk of every pair will get allocated to the largest, 7.28 TiB 
device.  The other two devices are equal in size, 2.73 TiB each, and the 
second chunk can't get allocated to the largest device as only one chunk 
of the pair can go there, so the allocator will in general alternate 
allocations from the smaller two, for the second chunk of each pair.  (I 
say in general, because metadata chunks are smaller than data chunks, so 
it's possible that two chunks in a row, a metadata chunk and a data 
chunk, will be allocated from the same device, before it switches to the 
other.)

Because the larger device is larger than the other two combined, it'll 
always get one copy, while the others fill up evenly at half the usage of 
the larger device, until both smaller devices are full, at which point 
you won't be able to allocate further raid1 chunks and you'll ENOSPC.

> # btrfs fi df /mnt/BigVault/
> Data, RAID1: total=2.47TiB, used=2.47TiB
> System, RAID1: total=32.00MiB, used=384.00KiB
> Metadata, RAID1: total=4.00GiB, used=2.74GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

Still looks reasonable.

Note that assuming you're using a reasonably current btrfs-progs, there's 
also the btrfs fi usage and btrfs dev usage commands.  Btrfs fi df is an 
older form that has much less information than the fi and dev usage 
commands, tho between btrfs fi show and btrfs fi df, /most/ of the 
filesystem-level information in btrfs fi usage can be deduced, tho not 
necessarily the device-level detail.  Btrfs fi usage is thus preferred, 
assuming it's available to you.  (In addition to btrfs fi usage being 
newer, both it and btrfs fi df require a mounted btrfs.  If the 
filesystem refuses to mount, btrfs fi show may be all that's available.)

While I'm digressing, I'm guessing you know this already, but for others, 
global reserve is reserved from and comes out of metadata, so you can add 
global reserve total to metadata used.  Normally, btrfs won't use 
anything from the global reserve, so usage there will be zero.  If it's 
not, that's a very strong indication that your filesystem believes it is 
very short on space (even if data and metadata say they both have lots of 
unused space left, for some reason, very likely a bug in that case, the 
filesystem believes otherwise) and you need to take corrective action 
immediately, or risk the filesystem effectively going read-only when 
nothing else can be written.
 
> But still df -h is giving me:
> Filesystem           Size  Used Avail Use% Mounted on
> /dev/sdb             6.4T  2.5T  1.5T  63% /mnt/BigVault
> 
> Although I've heard and read about the difficulty in reporting free
> space due to the flexibility of BTRFS, snapshots and subvolumes, etc.,
> but I only have a single volume, no subvolumes, no snapshots, no quotas
> and both data and metadata are RAID1.

The most practical advice I've seen regarding "normal" df (that is, the 
one from coreutils, not btrfs fi df) in the case of uneven device sizes 
in particular, is simply ignore its numbers -- they're not reliable.  The 
only thing you need to be sure of is that it says you have enough space 
for whatever you're actually doing ATM, since various applications will 
trust its numbers and may refuse to do whatever filesystem operation at 
all, if it says there's not enough space.

The algorithm reasonably new coreutils df (and the kernel calls it 
depends on) uses is much better than it used to be for btrfs, but it 
remains too simplistic to get it correct in "complex" cases such as 
uneven device sizes with raid1, because it makes use of an older 
interface that simply does not and cannot for backward compatibility 
reasons, provide enough information to actually calculate accurate 
numbers.

Tho as you use space, the accuracy of what df sees as remaining should 
improve, so that by the time you're counting in 10s to a couple hundred 
GiB reported left by df, it should be accurate to within several GiB, and 
by the time you're counting in MiB, it should be accurate to that level.

Knowing the fact that your two smaller devices combined are still smaller 
than the largest device, and given the numbers provided by the btrfs fi 
show and btrfs fi df commands above, we can reasonably easily manually 
calculate the total usable and unused space, but don't expect coreutils' 
df to do it, because it simply doesn't have the information available to 
it that it would need to be accurate.

Again, btrfs fi usage should be quite helpful here.  But let's just 
calculate given the above.

* Given that the two smaller devices will fill up evenly, and when 
they're full, no more raid1 chunks can be allocated, we can sum their 
sizes to get the total usable:

>From the btrfs fi show output:

2.73 TiB * 2 ~= 5.5 TiB total usable space.

(Note again that we're working in TiB, twos-power, not TB, tens-power, so 
it's not 6 TiB usable, tho it may be 6 TB tens-power usable.)

Of that ~ 5.5 TiB usable, ~ 1.25 * 2 TiB ~= 2.5 TiB is used (that is, 
allocated to chunks).

You should thus have ~ 5.5 TiB - 2.5 TiB = 3 TiB usable-as-raid1-space to 
be allocated.

In addition to that, you can look at btrfs fi df (or usage, which will 
provide a more practically usable without additional math output) to see 
how much space is remaining within already allocated chunks.  As it 
happens, since you just did a full balance, there's not significant 
already allocated chunk-space that's not yet actually used by files, but 
after some months of normal usage without further balances, you'll likely 
have tens to hundreds of GiB of chunk-allocated but not yet used space 
available, enough so it'd show in the hundredths-TiB figures reported.

> My expectation would've been that in case of BigVault Size == Used +
> Avail.
> 
> Actually based on http://carfax.org.uk/btrfs-usage/index.html I would've
> expected 6 TB of usable space. Here I get 6.4 which is odd,
> but that only 1.5 TB is available is even stranger.

If by that you mean you'd expect it to say 6T, instead of the 6.4T it 
lists, you'd be failing to account for the fact that df -h reports in 
powers-of-two, not powers-of-10 (despite it not using the standardized 
TiB, as df's output likely predates the TiB standard significantly, and 
again, that'd be changing the interface that many scripts have 
standardized on over the years).  If you wanted powers-of-10, you'd use
-H instead. See the manpage.

But of course 6.4 TiB is even further from the expected ~ 5.5 TiB than 
from the powers-mixed-up 6T you mention...

Of course you could dig into the specific df code and see where it gets 
its numbers if you wanted.  But in practice, it doesn't matter.  What 
matters in practice is that (coreutils') df's numbers simply aren't 
reliable in complex btrfs cases such as yours.  After the changes a few 
versions ago, they're /somewhat/ accurate in less complex cases like your 
previous setup, two devices of identical size in raid1.  

Meanwhile, as it happens two identically sized devices in btrfs raid1 
happens to be what I'm running here for all my btrfs except the /boot and 
its backups (which are single device dup mode), so coreutils' df happens 
to be relatively accurate for me, too, but I still don't rely on it, 
because I've simply learned not to.  FWIW, I actually don't tend to run 
normal df much at all these days, but do see the same numbers reported as 
total and free in my file managers (generally mc for admin hat work, 
sometimes kde's dolphin or gwenview or the like when I'm wearing my user 
hat).  As I said, mostly all I worry about is whether they show enough 
room for my current operations.  If they look way out of whack, I'll run 
the appropriate btrfs commands in a terminal to see what's up, but I 
don't trust the df/fileman numbers, because I know on btrfs, they really 
/cannot/ be trusted.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

