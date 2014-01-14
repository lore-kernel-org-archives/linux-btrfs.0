Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35887 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaANFxM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 00:53:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2ww2-0002fu-L5
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 06:53:10 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 06:53:10 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 06:53:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Issues with "no space left on device" maybe related to 3.13
Date: Tue, 14 Jan 2014 05:52:46 +0000 (UTC)
Message-ID: <pan$13b5$4830a55$8e383081$f7bb4fd7@cox.net>
References: <20140113002532.3975c806@ws> <52D3C012.9040308@kuther.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Kuther posted on Mon, 13 Jan 2014 11:29:38 +0100 as excerpted:

>> This shows only half the story, tho.  You also need the output of btrfs
>> fi show /mnt/ssd.  Btrfs fi show displays how much of the total
>> available space is chunk-allocated; btrfs fi df displays how much of
>> the chunk- allocation for each type is actually used.  Only with both
>> of them is the picture complete enough to actually see what's going on.
> 
> └» sudo btrfs fi show /mnt/ssd Label: none  uuid:
> 52bc94ba-b21a-400f-a80d-e75c4cd8a936
>         Total devices 1 FS bytes used 93.22GiB devid
>         1 size 119.24GiB used 119.24GiB path /dev/sda2
> 
> Btrfs v3.12
> └» sudo btrfs fi df /mnt/ssd
> Data, single: total=113.11GiB, used=90.79GiB
> System, DUP: total=64.00MiB, used=24.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=3.00GiB, used=2.43GiB
> 
> So, this looks like it's really full.

Well, you have 100% space allocated, but not all that allocated space is 
actually used.  113+ gigs allocated for data, but only just under 91 gigs 
used, so ~22.5 gigs are allocated for data but not used.  Metadata's 
closer, particularly considering it's dup-mode so allocations happen 2-at-
a-time.  Metadata chunks are 256 MiB by default, *2 due to dup, so 512 MiB 
allocated at once.  That means you're within a single allocation-unit of 
full on metadata.

And since all space is allocated, when those existing metadata chunks 
fill up, as they presumably originally did to trigger this thread, 
there's nothing left to allocate so out-of-space!

Normally you'd do a data balance to consolidate data in the data chunks 
and return the now freed chunks to the unallocated space pool, but you're 
going to have problems doing that ATM, for two reasons.  The likely 
easiest to work around is that since all space is allocated and balance 
works by allocating new chunks and copying data/metadata from the old 
chunks over, rewriting, defragging and consolidating as it goes, but 
there's no space left to allocate that new one...

The usual solution to that is to temporarily btrfs device add another 
device with a few gigs available, do the rebalance with it providing the 
necessary new-chunk space, then btrfs device delete, to move the chunks 
on the temporary-add back to the main device so you can safely remove the 
temporary-add.  Ordinarily, even a loopback on tmpfs could be used to 
provide a few gigs, and that should be enough, but of course you can't 
reboot while the chunks are on that tmpfs-based loopback or you'll lose 
that data, and the below will likely trigger a live-lock and you'll 
pretty much HAVE to reboot, so having those chunks on tmpfs probably 
isn't such a good idea after all.  But a few gig thumbdrive should work, 
and should keep the data safe over a reboot, so that's probably what I'd 
recommend ATM.

The more worrisome problem is that nasty multi-extent morass of a VM 
image.  When the rebalance hits that, it'll live-lock just as an 
attempted defrag or the like does.  =:^(

But with a bit of luck and perhaps playing with the balance filters a 
bit, you may be able to get at least a few chunks rebalanced first, 
hopefully freeing up a gig or two to unallocated, thus getting you out of 
the worst of the bind and making that space available to metadata if it 
needs it.  And as long as you're not using a RAM-backed device as your 
temp-storage, that balance should be reasonably safe if you have to 
reboot due to live-lock in the middle of it.


For future reference, I'd suggest trying to keep at least enough 
unallocated space around to allocate one more each data (1 GiB) and 
metadata (256 MiB *2 = 512 MiB) chunks free, thus allowing a balance to 
allocate it to hopefully free more space when needed.  Which in practice 
means doubling that to two each (3 GiB total), and as soon as the second 
one gets allocated, do a balance to hopefully free more room before your 
reserved chunk space gets allocated too.


As for the subvolume/snapshots thing (discussion snipped), I don't 
actually use subvolumes here, preferring fully independent partitions so 
my eggs aren't all in one still-under-development-filesystem basket.  And 
I and don't use snapshots that much.  So I really haven't followed the 
subvolume stuff, and don't know how that interacts with fragmented VM-
image bug we're dealing with here at all.

So I honestly don't know whether it's still that VM-image file implicated 
here, or whether we need to look for something else as the subvolumes 
should keep that interference from happening.

Actually, I'm not sure the devs know yet on this one, since it's 
obviously a situation that's much worse than they anticipated, too, which 
means that there's /some/ aspect of it that they don't understand what's 
going on with the interaction.


Were it my system, I'd probably do one of two things.  Either I'd try to 
get a dev actively working with me to trace/reproduce/solve the problem 
and thus eliminate it once and for all, or I'd take advantage of your 
qemu-img-convert idea to get a backup of the problem file, take (and 
test!!) a backup of everything else on the filesystem if I didn't have 
one already, and simply nuke the entire filesystem with a mkfs.btrfs, 
starting over fresh.  Currently that seems to be the only efficient way 
out of the live-lock triggering file situation once you find yourself in 
it, unfortunately, since defrag and balance, as well as simply trying to 
copy the file elsewhere (using anything but your qemu-image trick) simply 
trigger that live-lock once again. =:^(

Then if at all possible, put your VM image(s) on a dedicated filesystem, 
probably something other than btrfs since btrfs just seems broken for 
that usage ATM, and keep btrfs for the stuff it seems to actually work 
with ATM.

That's what I'd do.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

