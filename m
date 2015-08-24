Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54811 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbbHXIX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 04:23:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZTn2I-0004Un-O2
	for linux-btrfs@vger.kernel.org; Mon, 24 Aug 2015 10:23:22 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 10:23:22 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 10:23:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Newbie: RAID5 available space
Date: Mon, 24 Aug 2015 08:23:15 +0000 (UTC)
Message-ID: <pan$810c2$19bc785$156f5614$f066b53c@cox.net>
References: <CAM_GSFsAAtrGE7K3LYZKShnQN0yhm-b=s5itnsfWrukL8r66Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ivan posted on Mon, 24 Aug 2015 11:52:08 +0800 as excerpted:

> I'm trying out RAID5 to understand its space usage. First off, I've 3
> devices of 2GB each, in RAID5. Old school RAID5 tells me I've 4GB of
> usable space. Actual fact: I've about 3.5GB, until it tells me I'm out
> of space. This is understandable, as Metadata and System took up some
> space.
> 
> Next, I tried device add and remove.
> 
> My "common sense" tells me, I should be able to remove a device of size
> equal or smaller than one I added. (isn't it simply move all blocks from
> old device to new?)
> 
> So I proceeded to add a 4th device of 2GB, and remove the 2nd device (of
> 2GB). btrfs device delete tells me I'm out of space. Why?
> 
> Here are my steps:
> 01. dd if=/dev/zero of=/root/btrfs-test-1 bs=1G count=2
> 02. losetup /dev/loop1 /root/btrfs-test-1
> 03. dd if=/dev/zero of=/root/btrfs-test-2 bs=1G count=2
> 04. losetup /dev/loop2 /root/btrfs-test-2
> 05. dd if=/dev/zero of=/root/btrfs-test-3 bs=1G count=2
> 06. losetup /dev/loop3 /root/btrfs-test-3
> 07. mkfs.btrfs --data raid5 --metadata raid5 --label
> testbtrfs2 --nodiscard -f /dev/loop1 /dev/loop2 /dev/loop3
> 08. mount /dev/loop2 /mnt/b
> 09. dd if=/dev/zero of=/mnt/b/test1g1 bs=1G count=1
> 10. dd if=/dev/zero of=/mnt/b/test1g2 bs=1G count=1
> 11. dd if=/dev/zero of=/mnt/b/test1g3 bs=1G count=1
> 12. dd if=/dev/zero of=/mnt/b/test512M1 bs=512M count=1
> 13. dd if=/dev/zero of=/root/btrfs-test-4 bs=1G count=2
> 14. losetup /dev/loop4 /root/btrfs-test-4
> 15. btrfs device add --nodiscard -f /dev/loop4 /mnt/b
> 16. btrfs device delete /dev/loop2 /mnt/b
> 
> My kernel is 4.0.5-gentoo, btrfs-progs is 4.0.1 from Gentoo.
> 
> AFTER adding /dev/loop4. As can be seen, /dev/loop4 has lots of space,
> almost 2GB.
> # btrfs device usage /mnt/b
> /dev/loop1, ID: 1
>    Device size:             2.00GiB
>    Data,single:             8.00MiB
>    Data,RAID5:              1.76GiB
>    Data,RAID5:             10.50MiB
>    Metadata,single:         8.00MiB
>    Metadata,RAID5:        204.75MiB
>    System,single:           4.00MiB
>    System,RAID5:            8.00MiB
>    Unallocated:               0.00B
> 
> /dev/loop2, ID: 2
>    Device size:             2.00GiB
>    Data,RAID5:              1.78GiB
>    Data,RAID5:             10.50MiB
>    Metadata,RAID5:        204.75MiB
>    System,RAID5:            8.00MiB
>    Unallocated:             1.00MiB
> 
> /dev/loop3, ID: 3
>    Device size:             2.00GiB
>    Data,RAID5:              1.78GiB
>    Data,RAID5:             10.50MiB
>    Metadata,RAID5:        204.75MiB
>    System,RAID5:            8.00MiB
>    Unallocated:             1.00MiB
> 
> /dev/loop4, ID: 4
>    Device size:             2.00GiB
>    Data,RAID5:             10.50MiB
>    Data,RAID5:             19.00MiB
>    Unallocated:             1.97GiB

First, good questions. =:^)  As you've seen, the way btrfs functions 
isn't always entirely intuitive, altho once you understand how it 
functions, things make rather more sense.

But before starting to explain things manually, since you didn't mention 
reading it already, I'll assume you don't yet know about all the user 
documentation including a FAQ, at the btrfs wiki, here:

https://btrfs.wiki.kernel.org

Please take some time familiarizing yourself with the information there 
first, then feel free to come back with any further questions you may 
have.

But meanwhile, I'll address a few points here as well.  Some of this will 
repeat what's on the wiki, some not, so...

1) Btrfs in general isn't entirely stable and mature yet, tho for daily 
use it's stable enough to be used by many, provided they're keeping in 
mind the sysadmin's general rule of backups, that by definition, valuable 
data is backed up data; if it's not backed up, your actions really do 
underline the lie of any claims to actually value that data.  And the 
corollary, an untested would-be backup isn't yet a backup, because a 
backup isn't complete until it's tested usable/restorable.

Because btrfs is /not/ yet fully stable and mature, that rule, applying 
to data on /any/ filesystem, applies double to data on btrfs.  Keep that 
in mind, and regardless of what happens to your working copy on btrfs, if 
it's valuable, you'll have another copy safely stashed elsewhere to fall 
back on.

2) Btrfs remains under heavy development.  As such, while they do try to 
backport btrfs stability fixes, keeping current really can be the 
difference between running btrfs with all known bugs fixed, and running a 
version with bugs both known and unknown that are fixed in current.

3) Btrfs raid56 (the same code is used for both) is *MUCH* newer and less 
stable code, with the raid56 code only completed in kernel 3.19.  Both 
3.19 and early 4.0 still had critical raid56 mode bugs, and while 4.1 and 
now the almost released 4.2 have those fixed, my recommendation has been 
that unless you're actually intending to test new and not yet stabilized 
code, reporting bugs and working with the devs to get them fixed, wait at 
least a year, effectively five kernel cycles so 4.4 or so, before 
expecting raid56 code to be as stable and mature as btrfs in general.  
Until then, the raid56 code should be considered immature and (above and 
beyond the normal backups rule) you should be prepared to lose anything 
put on it.

Given points 2 and 3 together, one really does have to ask why you're 
running btrfs raid56 mode on a stale 4.0 kernel, when not only is a more 
raid56-mode stable 4.1 series available, but 4.2, with even more fixes, 
is already very close to release.  Even for more mature btrfs code, while 
4.0 is still somewhat reasonable, the first thing a reply to a problem 
report is likely to do is ask whether the problem remains on 4.1 or a 
late 4.2-rc, but the raid56 code really is new and unstable enough that 
you either really do want to be running a truly current kernel, or you 
probably should reconsider whether at least the raid56 mode is an 
appropriate choice after all, because it probably isn't.

Meanwhile, as to userspace (btrfs-progs), it generally works like this.  
For normal "online" operation, the btrfs code that counts is in the 
kernel; all userspace does is forward requests to the kernel code to 
process.  However, the moment you have a problem mounting the filesystem, 
the userspace code becomes important, as it's what does the work in btrfs 
check, btrfs restore, etc, trying to get the filesystem back it working 
order (check --repair or other similar options), or failing that, at 
least recover files off the unmountable filesystem (restore).  So in 
normal operation, a current btrfs-progs isn't as vitally important, but 
the moment you have a problem and are trying to get your data back, you 
really want a current userspace as well, with the absolute latest fixes 
and tricks for fixing that troubled filesystem.  And since when the 
filesystem is already broken tends to be a rather inconvenient time to 
try to get a current userspace working, it's generally just simpler to 
run a current userspace all the time, even if it's not as absolutely 
critical as a current kernel... until it is!

And FWIW, current userspace is 4.1.2.

Now, to more directly address your question...

4) Btrfs actually allocates space in two stages.  First, it allocates 
relatively large chunks of the particular type, data, metadata, etc, that 
it needs.  These chunks are nominally[1] sized 1 GiB each for data, 256 
MiB each for metadata, tho if there's lots of unallocated space available 
(think TiB scale filesystems), they may be larger, while as unallocated 
space becomes tight, they'll be smaller.

Then those pre-allocated chunks will be filled with actual data or 
metadata as the need arises, until they're full, and another chunk 
allocation is necessary.

With individual device sizes of "only" a couple GiB each, and default 
data chunk sizes of a GiB, you can already see the potential for a 
problem, as chunk allocation flexibility is going to be extremely limited.

As it happens, for very small filesystems, btrfs has another chunk type 
it uses instead, mixed-bg (block group) mode.  These mixed-mode chunks 
default to the size of metadata (256 MiB), but unlike normal data and 
metadata chunks, can contain both data and metadata in the same chunk, 
thus its "mixed" name.  mkfs.btrfs will actually default to mixed-mode 
for filesystems under a GiB, and there has been talk of upping this to 
perhaps 8 GiB (or 16 or 32) in the future, tho it hasn't happened yet.  
But mixed-bg mode does have a performance penalty attached to it, and on 
single-device-btrfs, like metadata, mixed-bg defaults to dup mode, but 
here for data as well since it's in the same chunks, so will have only 
half the capacity since everything's duplicated (tho of course admins can 
specify something else at mkfs time if desired).  Thus, while it's 
arguable where the precise cutoff should be, at 64 GiB and above pretty 
much everyone agrees it's best to keep the current separate data/metadata 
blocks, and I'd guess most people who know about it would vote to up the 
mixed-bg default cutoff to at least 8 GiB, it just hasn't been done yet, 
so the question is actually where the cutoff should be, between 8 GiB on 
the low end and 32 or possibly 64 GiB on the high end.

So for a filesystem with only 2 GiB individual devices, arguably you 
really should have added the --mixed option to the mkfs.btrfs.  I think 
current btrfs would have still defaulted to separate data/metadata on the 
btrfs device add, with no option there to specify it, but IIRC I saw some 
recent discussion on that, too.  But mixed would have definitely eased 
your problem, tho at only 2 GiB per device, you may have still run into 
it.

5) With raid modes, btrfs actually allocates chunks in parallel on 
multiple devices.  The specifics depend on the raid mode, but for raid5, 
chunk allocations are done across all devices with unallocated space 
remaining, with a two-device minimum.  (Tho FWIW, with only two devices, 
raid5 effectively becomes a more complex raid1; it actually takes three 
devices for a traditional raid5, where data or metadata is striped on two 
of the three, with the third being the parity.  But, btrfs can and does 
handle the two-device-minimum case as well.  But it does require at least 
two in ordered to allocate in raid5 mode.)

With #5, if you look at that device usage above, you can now see why it 
ENOSPCed on you -- only one device has unallocated space, and raid5 mode 
requires at least two devices with unallocated space, in ordered to 
allocate new chunks.  The chunks themselves probably aren't entirely full 
(you'd use btrfs filesystem df or usage to see that), but all available 
space on all but one device is already allocated, and raid5 mode requires 
unallocated space on at least two devices in ordered to do a raid5 mode 
chunk allocation, so the chunk allocation fails.

6) Unlike btrfs device delete, which effectively does a balance that 
reallocates chunks from the device being deleted to other devices as 
space allows, btrfs device add does not automatically trigger such a 
rebalance; if you want a rebalance done after an add, you must manually 
trigger it yourself.

To help solve this problem as well as to save time, in addition to the 
older btrfs device add and delete commands, there's a newer btrfs replace 
command (note, NOT btrfs device replace, replace is its own top-level, 
not part of the btrfs device top-level), which combines the add and 
delete in a single step, when a direct one-for-one replacement is being 
done.

Unfortunately, last I read, with both btrfs raid56 mode and the btrfs 
replace command being fairly new, they were somewhat developed in 
parallel and don't really know about each other, so I believe btrfs 
replace doesn't yet work with raid56 mode.  If it does, I think it's only 
in the very newest code -- very possibly latest release only, if not 
integration-repo only, not yet in a release version at all.

Again, particularly for raid56 mode, you really REALLY want the absolute 
latest code.


OK, I /think/ that explains most of what you were asking about, tho it 
might take a bit to sink in, and it's very possible you won't see the 
whole picture until you read the wiki as well, which in any case I'd 
strongly urge you to do, since it covers a lot of stuff not mentioned 
here.

(Kind of like the gentoo handbook covers all sorts of stuff beyond bare 
installation that it's otherwise easy to miss on gentoo.  I'm a long-time 
gentooer too, since 2004 in fact, and still remember that even tho I got 
stuck on an obscure bug on my first install attempt and couldn't get 
anywhere until new stages were released a few weeks later, unlike a lot 
of users I had actually read the handbook, and was thus helping many 
users who hadn't read it, with problems on their running gentoo 
installations, because I had read the handbook and knew the tricks they 
missed, even tho I didn't yet actually have a running gentoo of my own 
yet due to the bug!  So yes, btrfs is like gentoo in that reading the 
docs actually does help, often quite a lot!  In both cases, the lists are 
there too, for stuff the docs don't cover, but things work best for all 
if people read the docs first, then come to the list with any questions 
left after reading the docs. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

