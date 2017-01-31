Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35748 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdAaDyQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 22:54:16 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cYPVq-0005iU-SR
        for linux-btrfs@vger.kernel.org; Tue, 31 Jan 2017 04:53:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: File system is oddly full after kernel upgrade, balance doesn't
 help
Date: Tue, 31 Jan 2017 03:53:40 +0000 (UTC)
Message-ID: <pan$61590$8b4273ea$8cd79913$19b8f7cc@cox.net>
References: <CAE8gLhk=Gf7Qejs6zit+hGdFNeNSPexJZ=jgCY1CADt6xoNHhA@mail.gmail.com>
        <pan$bea71$c88f268f$3fe2f55a$caf61eb5@cox.net>
        <CAE8gLhkjgOzRgJXKL=az8Mw8njCg+m6d0zyH8WmDPNx_-Wp9Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MegaBrutal posted on Sat, 28 Jan 2017 19:15:01 +0100 as excerpted:

> Of course I can't retrieve the data from before the balance, but here is
> the data from now:

FWIW, if it's available, btrfs fi usage tends to yield the richest 
information.  But it's also a (relatively) new addition to the btrfs-
tools suite, and the results of btrfs fi show combined with btrfs fi df 
are the older version, together displaying the same critical information, 
tho without quite as much multi-device information.  Meanwhile, both 
btrfs fi usage and btrfs fi df require a mounted btrfs, so when it won't 
mount, btrfs fi show is about the best that can be done, at least staying 
within the normal admin-user targeted commands (there's developer 
diagnostics targeted commands, but I'm not a dev, just a btrfs list 
regular and btrfs user myself, and to date have left those commands for 
the devs to play with).

But since usage is available, that's all I'm quoting, here:

> root@vmhost:~# btrfs fi usage /tmp/mnt/curlybrace
> Overall:
>     Device size:              2.00GiB
>     Device allocated:         1.90GiB
>     Device unallocated:     103.38MiB
>     Device missing:             0.00B
>     Used:                   789.94MiB
>     Free (estimated):       162.18MiB    (min: 110.50MiB)
>     Data ratio:                  1.00
>     Metadata ratio:              2.00
>     Global reserve:         512.00MiB    (used: 0.00B)
> 
> Data,single: Size:773.62MiB, Used:714.82MiB
>    /dev/mapper/vmdata--vg-lxc--curlybrace     773.62MiB
> 
> Metadata,DUP: Size:577.50MiB, Used:37.55MiB
>    /dev/mapper/vmdata--vg-lxc--curlybrace       1.13GiB
> 
> System,DUP: Size:8.00MiB, Used:16.00KiB
>    /dev/mapper/vmdata--vg-lxc--curlybrace      16.00MiB
> 
> Unallocated:
>    /dev/mapper/vmdata--vg-lxc--curlybrace     103.38MiB
> 
> 
> So... if I sum the data, metadata, and the global reserve, I see why
> only ~170 MB is left. I have no idea, however, why the global reserve
> sneaked up to 512 MB for such a small file system, and how could I
> resolve this situation. Any ideas?

That's an interesting issue I've not seen before, tho my experience is 
relatively limited compared to say Chris (Murphy)'s or Hugo's, as other 
than my own systems, my experience is limited to the list, while they do 
the IRC channels, etc.

I've no idea how to resolve it, unless per some chance balance removes 
excess global reserve as well (I simply don't know, it has never come up 
that I've seen before).

But IIRC one of the devs (or possibly Hugo) mentioned something about 
global reserve being dynamic, based on... something, IDR what.  Given my 
far lower global reserve on multiple relatively small btrfs and the fact 
that my own use-case doesn't use subvolumes or snapshots, if yours does 
and you have quite a few, that /might/ be the explanation.

FWIW, while I tend to use rather small btrfs as well, in my case they're 
nearly all btrfs dual-device raid1.  However, a usage comparison based on 
my closest sized filesystem can still be useful, particularly the global 
reserve.  Here's my /, as you can see, 8 GiB per device raid1, so one 
copy (comparable to single mode if it were a single device, no dup mode 
metadata as it's a copy on each device) on each:

# btrfs fi u /
Overall:
    Device size:                  16.00GiB
    Device allocated:              7.06GiB
    Device unallocated:            8.94GiB
    Device missing:                  0.00B
    Used:                          4.38GiB
    Free (estimated):              5.51GiB      (min: 5.51GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,RAID1: Size:3.00GiB, Used:1.96GiB
   /dev/sda5       3.00GiB
   /dev/sdb5       3.00GiB

Metadata,RAID1: Size:512.00MiB, Used:232.77MiB
   /dev/sda5     512.00MiB
   /dev/sdb5     512.00MiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/sda5      32.00MiB
   /dev/sdb5      32.00MiB

Unallocated:
   /dev/sda5       4.47GiB
   /dev/sdb5       4.47GiB


It is worth noting that global reserve actually comes from metadata.  
That's why metadata never reports fully used, because global reserve 
isn't included in the used count, but can't normally be used for normal 
metadata.

Also note that under normal conditions, global reserve is always 0 used 
as btrfs is quite reluctant to use it for routine metadata storage, and 
will normally only use it for getting out of COW-based jams due to the 
fact that because of COW, even deleting something means temporarily 
allocating additional space to write the new metadata, without the 
deleted stuff, into.  Normally, btrfs will only write to global reserve 
if metadata space is all used and it thinks that by doing so it can end 
up actually freeing space.  In normal operations it will simply see the 
lack of regular metadata space available and will error out, without 
using the global reserve.

So if at any time btrfs reports more than 0 global reserve used, it means 
btrfs thinks it's in pretty serious straits and it's in quite a pickle, 
making non-zero global reserve usage a primary indicator of a filesystem 
in trouble, no matter what else is reported.


So with all that said, you can see that on that 8-gig per device, pair-
device raid1, btrfs has allocated only 512 MiB of metadata on each 
device, of which 232 MiB on each is used, *nominally* leaving 280 MiB 
metadata unused on each device, tho global reserve comes from that.

But, there's only 16 MiB of global reserve, counted only once.  If we 
assume it'd be used equally from each device, that's 8 MiB of global 
reserve on each device subtracted from that 280 MiB nominally free, 
leaving 272 MiB of metadata free, a reasonably healthy filesystem state, 
considering that's more metadata than actually used, plus there's nearly 
4.5 GiB entirely unallocated on each device, that can be allocated to 
data or metadata as needed.

That's quite a contrast compared to yours, a quarter the size, 2 GiB 
instead of 8, and as you have only the single device, the metadata 
defaulted to dup, so it uses twice as much space on the single device.

But the *real* contrast is as you said, your global reserve, an entirely 
unrealistic half a GiB, on a 2 GiB filesystem!

Of course global reserve being accounted single, while your metadata is 
dup, half should come from each side of that dup, so your real metadata 
usage vs. free can be calculated as 577.5 size (per side of the dup) - 
37.5 (normal used), - 256 (half of the global reserve), basically 284 MiB 
of usable metadata space (per side of the dup, but each side should be 
used equally).

Add to that the ~100 MiB unallocated, tho if used for dup metadata you'd 
only have half that usable, and you're not in /horrible/ shape.

But that 512 MiB global reserve, a quarter of the total filesystem size, 
is just killing you.

And unless it has something to do with snapshots/subvolumes, I don't have 
a clue why, or what to do about it.

But here's what I'd try, based on the answer to the question of whether 
you use snapshots/subvolumes (or use any of the btrfs reflink-based dedup 
tools as they have many of the same implications as snapshots, tho the 
scope is of course a bit different), and how many you have if so:

* Snapshots and reflinks are great, but unfortunately, have limited 
scaling ability at this time.  While on normal sized btrfs the limit 
before scaling becomes an issue seems to be a few hundred (under 1000 and 
for most under 500), it /may/ be that on a btrfs as small as your two-
GiB, more than say 10 may be an issue.

As I said, I don't /know/ if it'll help, but if you're over this, I'd 
certainly try reducing the number of snapshots/reflinks to under 10 per 
subvolume/file and see if it helps at all.

* You /may/ be able to try btrfs bal start -musage=, starting with a 
relatively low value (you tried 0, it's percentage, try 2, 5, 10.. up 
toward 100%, until you see some results or you get ENOSPC errors), and 
see some results.  However, typical metadata chunks are 256 MiB in size, 
tho they should be smaller on a 2 GiB btrfs, but I'm not sure by how 
much, and it's relatively likely you'll run into ENOSPC errors due to 
metadata chunks larger than half (dup so it'll take two chunks of the 
same size) your unallocated space size, before you get anywhere, even if 
balancing would otherwise help -- which again I'm not even sure it will, 
as I don't know whether it helps with bloated global reserve, or not.

* If the balance ENOSPCs, you may of course try (temporarily) increasing 
the size of the filesystem, possibly by adding a device.  There's 
discussion of that on the wiki.  But I honestly don't know how global 
reserve will behave, because something's clearly going on with it and I 
have no idea what.  For all I know, it'll eat most of the new space 
again, and you'll be in an even worse position, as it won't then let you 
remove the device you added to try to fix the problem.

* Similarly, but perhaps less risky with regard to global reserve size, 
tho definitely being more risky in terms of data safety in case something 
goes wrong (but the data's backed up, right?), you could try doing a 
btrfs balance start -mconvert=single, to reduce the metadata usage from 
dup to single mode.  Tho personally, I'd probably bother with the risk, 
simply double-checking my backups, then going ahead with the next one 
instead of this one.

* Since in data admin terms, data without a backup is considered to be 
defined by the lack thereof of that backup, as worth less than the time 
and trouble necessary to do it, and that applies even stronger to a still 
under heavy development and not yet fully stable filesystem such as 
btrfs, it's relatively safe to assume you either have a backup, or don't 
really care about the possibility of losing the data in the first place.  
Certainly that's the case here, tho I can't honestly say I always keep 
the backups fresh, but I equally honestly know that if I lose what's not 
backed up, it's purely because my actions defined that data as not worth 
the trouble, so in any case I saved what was worth more to me, either the 
data, or the time necessary to ensure it's safety via backup.

As such, what I'd be very likely to do here, before spending /too/ much 
time or effort or worry trying to fix things with no real guarantee it'll 
work anyway, would be to first freshen the backups if necessary, then 
simply blow away the existing filesystem and start over, restoring from 
backups to a freshly mkfsed btrfs.

* But, and this may well be the most practically worthwhile piece of the 
entire post, on a redo, I'd /strongly/ consider using the -M/--mixed 
mkfs.btrfs option.

What this does is tell btrfs to create mixed data/metadata block-groups 
aka chunks, instead of separating data and metadata into their own chunk 
types.  --mixed used to be default for btrfs under 1 GiB, and is still 
extremely strongly recommended for such small btrfs, as managing separate 
data and metadata chunks at that size is simply impractical.  The general 
on-list consensus seems to be that --mixed should be strongly considered 
for small btrfs of over a gig as well, with any disagreement being more 
one of whether the line should be closer to 8 GiB or 64 GiB, before the 
tradeoff between the lower hassle factor of --mixed vs. its somewhat 
lower efficiency compared to separate data/metadata swings toward higher 
efficiency.

Tho to a large extent I believe it's installation (hardware and layout 
factors), use-case and individual admin tech-detail-task tolerance 
specific.  Personally, I run gentoo and have a reasonably higher 
tolerance for minding the minor tech details than I suppose most do, and 
I still run, and believe it's appropriate for me to run, separate data/
metadata on my 8-gig*2-device / (and it's primary backup) btrfs.  But I 
run mixed on the 256-meg*1-device-in-dup-mode /boot (and its backup /boot 
on the other device), and would almost certainly run mixed on a 2 GiB 
btrfs as well.  By 4 GiB, tho, I'd consider separate data/metadata for me 
personally, tho would still recommend mixed for those who would prefer 
that it "just work" with the least constant fooling with it possible, up 
to probably 16 GiB at least.  And for some users I'd recommend it up to 
32 GiB or even 64 GiB, tho probably not above that, and in practice, the 
users I'd recommend it for at 32 or 64 GiB I'd probably recommend that 
they stay off btrfs until it stabilizes a bit further, because I simply 
don't think btrfs in general is appropriate for them yet if they're so 
relatively averse to tech detail that I'd consider mixed at 64 GiB an 
appropriate recommendation for them.

But for 2 GiB, I'd *definitely* be considering mixed mode, here, and 
almost certainly using it, tho there's one additional caveat to be aware 
of with mixed mode.

* Because mixed mode mixes data and metadata in the same chunks, they 
have to have the same redundancy level.

Which means if you want dup metadata, the normal default and recommended 
for metadata safety, if you're doing mixed mode, that means dup data as 
well.

And while dup data does give you a second copy on a single device, and 
thus a way for scrub to fix not only metadata (which is usually duped) 
but also data (which is usually single and thus error detectable but not 
correctable), it *ALSO* generally means far more space usage, and that 
you basically only get to use have the space of the filesystem, because 
it's keeping a second copy of /everything/ then.  And some people 
consider only half space availability simply too high a price to pay on 
what are already by definition small filesystems with relatively limited 
space.

One thing I know for sure.  When I did the layout of my current system, I 
planned for btrfs raid1 mode for nearly everything, and due to having 
some experience over the years, I got nearly everything pretty much 
correct in terms of partition and filesystem sizes.  But what I did *not* 
get quite right was /boot, because I failed to figure in the doubled 
space usage of dup for data and metadata both.

So what was supposed to be a 256 MiB available for usage /boot, became 
128 MiB available for usage due to dup, which does crimp my style a bit, 
particularly when I'm trying to git-bisect a kernel bug and I have to 
keep removing the extra kernels every few bisect loops, because I simply 
don't have space for them all.

So when I redo the layout, I'll probably make them 384 MiB, 192 MiB usage 
due to dup, or possibly even 512/256.

So there is a real down side to mixed mode.  For single device btrfs 
anyway, you have to choose either single for both data/metadata, or dup 
for both data/metadata, the first being a bit more risky than I'm 
comfortable with, the second, arguably overkill, considering if the 
device dies, both copies are on the same device, so it's gone, and the 
same if the btrfs itself dies.  Given that and the previously mentioned 
no-backup-defines-the-data-as-throwaway rule, meaning there's very likely 
another copy of the data anyway, arguably, if both have to be set the 
same as they do for mixed, single mode for both makes more sense than dup 
mode for both.

Which, given that I /do/ have a /boot backup setup on the other device, 
selectable via BIOS if necessary, means I may just go ahead and leave my /
boots at 256 MiB each anyway, and just set them both to single mode for 
the mixed data/metadata, to make use of the full 256 MiB and not have to 
worry about /boot size constraints like I do now with only 128 MiB 
available due to dup.  We'll see...

But anyway, do consider --mixed for your 2 GiB btrfs, the next time you 
mkfs.btrfs it, whether that's now, or whenever later.  I'd almost 
certainly be using it here, even if that /does/ mean I have to have the 
same mode for data and metadata because they're mixed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

