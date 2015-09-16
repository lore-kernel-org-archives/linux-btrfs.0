Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58846 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbbIPD5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 23:57:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zc3qQ-0004ri-JY
	for linux-btrfs@vger.kernel.org; Wed, 16 Sep 2015 05:57:18 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 05:57:18 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 05:57:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS as image store for KVM?
Date: Wed, 16 Sep 2015 03:57:12 +0000 (UTC)
Message-ID: <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
References: <55F88ECC.1040604@menke.ac>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gert Menke posted on Tue, 15 Sep 2015 23:34:04 +0200 as excerpted:

> I'm not 100% sure if this is the right place to ask[.]

It is. =:^)

> I want to build a virtualization server to replace my current home
> server. I'm thinking about a Debian system with libvirt/KVM. The system
> will have one or two SSDs and five harddisks with some kind of software
> RAID5 for storage. I'd like to have a filesystem with data checksums, so
> BTRFS seems like the right way to go. However, I read that BTRFS does
> not perform well as storage for KVM disk images.
> (See here: http://www.linux-kvm.org/page/Tuning_KVM )
> 
> Is this still true?
> 
> I would appreciate any comments and/or tips you might have on this
> topic.
> 
> Is anyone using BTRFS as an image store? Are there any special settings
> I should be aware of to make it work well?

Looks like you're doing some solid research before you deploy. =:^)

Here's the deal.  The problem is fragmentation, which is much more of an 
issue on spinning rust than it typically is on ssds, since ssds have 
effectively zero seek-time.  If you can put the VMs on those ssds you 
mentioned, not on the spinning rust, the fragmentation won't matter so 
much, and you may well not have to worry about it.

Any copy-on-write filesystem (which btrfs is), is going to have serious 
problems with a file-internal-rewrite write pattern (as contrasted to 
append, or simply rewrite the entire thing sequentially, beginning to 
end), because as various blocks are rewritten, they get written 
elsewhere, worst-case one at a time, dramatically increasing 
fragmentation -- hundreds of thousands of extents are not unheard-of with 
files in the multi-GiB size range.[1]

The two typical problematic cases are database files and VM images (your 
case).

Btrfs has two possible solutions to work around the problem.  The first 
one is the autodefrag mount option, which detects file fragmentation 
during the write and queues up the affected file for a defragmenting 
rewrite by a lower priority worker thread.  This works best on the small 
end, because as file size increases, so does time to actually write it 
out, and at some point, depending on the size of the file and how busy 
the database/VM is, writes are (trying to) come in faster than the file 
can be rewritten.  Typically, there's no problem under a quarter GiB, 
with people beginning to notice performance issues at half to 3/4 GiB, 
tho on fast disks and not too busy VMs/DBs (which may well include your 
home system, depending on what you use the VMs for), you might not see 
problems until size reaches 2 GiB or so.  As such, autodefrag tends to be 
a very good option for firefox sqlite database files, for instance, as 
they tend to be small enough not to have issues.  But it's not going to 
work so well for multi-GiB VM images.

The second solution, or more like workaround, for larger internal-rewrite-
pattern files, generally 1 GiB plus (so many VMs), is to use the NOCOW 
file attribute (set with chattr +C), which tells btrfs to rewrite the 
file in-place instead of using the usual copy-on-write method.  However, 
you're not going to like the side effects, as btrfs turns off both 
checksumming and transparent compression on nocow files, because there's 
serious checksum/data-it-covers write-race issues with in-place rewrite, 
and of course the rewritten data may compress better or worse than the 
old version, so rewriting a compressed copy in-place is problematic as 
well.

So setting nocow turns off checksumming, the biggest reason you're 
considering btrfs in the first place, likely making this option 
effectively unworkable for you. =:^(

Which means btrfs itself likely isn't a particularly good choice, UNLESS 
(a) your VM images are small (under a GiB, ideally under a quarter-gig, 
admittedly a pretty small VM), OR (b) your VMs are primarily reading, not 
writing, or aren't likely to be busy enough for autodefrag to be a 
problem, given the size, OR (c) you put the VM images (and thus the btrfs 
containing them) on ssd, not spinning rust.

Meanwhile, quickly tying up a couple loose ends with nocow in case you do 
decide to use it for this or some other use-case:

a) On btrfs, setting nocow on a file that's already larger than zero-size 
doesn't work as expected (cow writes can continue to occur for some 
time).  Typically the easiest way to ensure that the file is nocow before 
getting data, is to set nocow on its containing directory before the file 
is created, so new files inherit the attribute.  For existing files, set 
it on the dir and copy the file in from a different filesystem (or move 
it to say a tmpfs and back), so the file gets created with the nocow 
attribute as it is copied in.

b) Btrfs' snapshot feature depends on COW, locking in place the existing 
version of the file, forcing otherwise nocow files to be what I've seen 
described as cow1 -- the first write to a file block will cow it to a new 
location because the existing version is locked in place in the old 
location.  However, the file retains its nocow attribute, and further 
writes to the same block will now rewrite the existing first-cowed 
location instead of forcing further cows... until yet another snapshot 
locks the new existing block in place once again.  While this isn't too 
much of a problem for the occasional snapshot, it does create problems 
for high-frequency scheduled snapshotting, since then the otherwise nocow 
files will be cowing quite a lot anyway, and as a result fragmenting, due 
to the snapshotting locking existing versions in place so often.

Finally, as I said above, fragmentation doesn't affect ssds like it does 
spinning rust (tho it's still not ideal, since scheduling all those 
individual accesses instead of fewer accesses to larger extents does have 
a cost, and with sub-erase-block-size fragments, there's wear-leveling 
and write-cycle issues to consider), so you might not have to worry about 
it at all if you put the btrfs and thus the VMs it contains on ssd.

---
[1] Btrfs file blocks are kernel memory page size, 4 KiB on x86, 32-bit 
or 64-bit, so there's 256 blocks per MiB, 1024 MiB per GiB, so 262,144 
blocks per GiB.  The theoretical worst-case fragmentation, each block its 
own extent, is thus 262,144 extents per GiB.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

