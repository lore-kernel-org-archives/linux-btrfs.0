Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41675 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbcAVKzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 05:55:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aMZMu-00019A-ES
	for linux-btrfs@vger.kernel.org; Fri, 22 Jan 2016 11:55:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 11:55:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 11:55:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 disk upgrade method
Date: Fri, 22 Jan 2016 10:54:58 +0000 (UTC)
Message-ID: <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
References: <20160122034538.GA25196@coach.student.rit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sean Greenslade posted on Thu, 21 Jan 2016 22:45:38 -0500 as excerpted:

> Hi, all. I have a box running a btrfs raid1 of two disks. One of the
> disks started reallocating sectors, so I've decided to replace it
> pre-emptively. And since larger disks are a bit cheaper now, I'm trading
> up. The current disks are 2x 2TB, and I'm going to be putting in 2x 3TB
> disks. Hopefully this should be reasonably straightforward, since the
> raid is still healthy, but I wanted to ask what the best way to go about
> doing this would be.
> 
> I have the ability (through shuffling other drive bays around) to mount
> the 2 existing drives + one new drive all at once. So my first blush
> thought would be to mount one of the new drives, partition it, then
> "btrfs replace" the worse existing drive.

I just did exactly this, not too long ago, tho in my case everything was 
exactly the same size, and SSD.

I had originally purchased three SSDs of the same type and size, with the 
intent of one of them going in my netbook, which disappeared before that 
replacement done, so I had a spare.  The other two were installed in my 
main machine, GPT-partitioned up into about 10 (rather small, nothing 
over 50 GiB) partitions each, with a bunch of space left at the end (I 
needed ~128 GiB SSDs and purchased 256 GB aka 238 GiB SSDs, but the 
recommendation is to leave about 25% unpartitioned for use by the FTL 
anyway and I was ~47%, so...).

Other than the BIOS and EFI reserved partitions (which are both small 
enough I make it a habit to setup both, easier to put the devices in a 
different machine that way even tho only one will actually be used), all 
partitions were btrfs, with both devices partitioned identically and 
working and backup copies of several partitions.  Save for /boot, which 
was btrfs dup mode, working copy on one device, backup on the other, all 
btrfs were raid1 both data and metadata.

One device prematurely started replacing sectors, however, and while I 
continued to run the btrfs raid1 on it for awhile, using btrfs scrub to 
fix things up from the good device, eventually I decided it was time to 
do the switch-out.

First thing of course was setting it up with partitioning identical to 
the other two devices.  Once that was done, on all the btrfs raid1, the 
switch-out was straightforward, btrfs replace start on each.  As 
everything was SSD and the partitions were all under 50 GiB, the replaces 
only took a few minutes each, but of course I had about 8 of them to do...

The /boot partition was also easy enough, simply mkfs.btrfs the new one, 
mount it, and copy everything over as if I was doing a backup, the same 
as I routinely do from working to backup copy on most of my partitions.

Of course then I had to grub-install to the new device, so I could boot 
it.  Again routine, as after grub updates I always grub-install to each 
device, one at a time, rebooting to the grub prompt with the other device 
disconnected after the first grub-install to ensure it installed 
correctly and is still bootable to grub, before doing the second, and 
again in reverse after the second, so if there's any problem, I have 
either the untouched old one or the already tested new one to boot from.

The only two caveats I'm aware of with btrfs replace are the one CMurphy 
already brought up, size and functionality of the device being replaced.  
As my existing device was still working and I had just finished scrubs on 
all btrfs, the replaces went without a hitch.

Size-wise, if the new target device/partition is larger, do the replace, 
and then double-check to see that it used the full device or partition.  
If you need to, resize the btrfs to use the full size.  (If it's smaller, 
as CMurphy says, use the add/delete method instead of replace, but you 
say it's larger in this case so...)

If the old device is in serious trouble but still at least installed, use 
the replace option that only reads from that device if absolutely 
necessary.  If the old one doesn't work at all, procedures are slightly 
different, but that wasn't an issue for me, and by what you posted, 
shouldn't be one for you, either.

> Another possibility is to "btrfs add" the new drive, balance, then
> "btrfs device delete" the old drive. Would that make more sense if the
> old drive is still (mostly) good?

Replace is what I'd recommend in your case as it's the most 
straightforward.  Add then delete works too, and has to be used on older 
systems where replace isn't available yet as an option, or when the 
replacement is smaller.  I think it may still be necessary for raid56 
mode too as last I knew, replace couldn't yet handle that.  But replace 
is more straightforward and thus easier and recommended, where it's an 
option.

However, where people are doing add then delete, there's no need to do 
balance between them, as the device delete runs balance in that process.  
Indeed, running a balance after the add but before the delete simply puts 
more stress on the device being replaced, so is definitely NOT 
recommended if that device isn't perfectly healthy.  Besides taking 
longer, of course, since you're effectively doing two balances, one as a 
balance, one as a device delete, in a row.

> Or maybe I could just create a new btrfs partiton on the new device,
> copy over the data, then shuffle the disks around and balance the new
> single partition into raid1.

That should work just fine as well, but is less straightforward, and in 
theory at least is a bit more risky when the device being replaced is 
still mostly working, since while the new btrfs is single-device, it's 
likely to be single-data as well, so you don't have the fallback to the 
second copy that you get with raid1, if the one copy is bad.  Of course 
if you're getting bad copies on a new device something's already wrong, 
which is why I said in theory, but there you have it.

The one reason you might still want to do it that way is as CMurphy said, 
if the old btrfs was sufficiently old that it was missing features you 
wanted to enable on the new one.

Actually, here, since most of my btrfs are not only raid1, but also have 
two filesystem copies, the working and backup btrfs on different 
partitions of the same two raid1 devices, with that being my primary 
backup (of course I have a secondary backup on other devices, spinning 
rust in my case while the main devices are SSD), I routinely mkfs.btrfs 
the backup copy and copy everything over from the working copy once 
again, thus both updating the backup, and getting the benefit of any new 
btrfs features enabled on the fresh mkfs.btrfs.  Of course a backup isn't 
complete until it's tested, so I routinely reboot and mount the fresh 
backup copy as that test, and while I'm booted to that backup, once I'm 
very sure it's good, it's trivially easy to reverse the process, doing a 
fresh mkfs.btrfs of the normal working copy and copying everything from 
the backup I'm running on back to the fresh normal working copy, thus 
both taking advantage of new features now on the new working copy, and 
ensuring no weird issues due to some long fixed and forgotten about but 
still lurking bug waiting to come out and bite me, on a working copy 
that's been around for years.

For those without the space-luxury of identically partitioned duplicate 
working and backup raid1 copies of the same data, which makes the above 
refreshing of the working copy to a brand new btrfs routine as an 
optional reverse-run of the regular backup cycle, the above "separate 
second filesystem" device upgrade method does have the advantage of 
starting with a fresh btrfs with all the newer features, that the btrfs 
replace or btrfs device add/delete methods on an existing filesystem 
don't.

> Which of these makes the most sense? Or is there something else I
> haven't thought of?

In general, I'd recommend the replace as the most straightforward, unless 
your existing filesystem is old enough that it doesn't have some of the 
newer features enabled, and you want to take the opportunity of the 
switch to enable them, in which case the copy to new filesystem option 
does allow you to do that.

> System info:
> 
> [sean@rat ~]$ uname -a
> Linux rat 4.3.3-3-ARCH #1 SMP PREEMPT Wed Jan 20
> 08:12:23 CET 2016 x86_64 GNU/Linux
> 
> [sean@rat ~]$ btrfs --version
> btrfs-progs v4.3.1
> 
> All drives are spinning rust. Original raid1 was created ~Aug 2013, on
> kernel 3.10.6.

Thank you.  A lot of posts don't include that information, but it's nice 
to have, to be certain you actually have a new enough kernel and 
userspace to actually have a working btrfs replace command, etc. =:^)

And since you do have the raid1 creation kernel info there too, I can 
tell you that yes, a number of filesystem features are now default that 
weren't, back on kernel 3.10, including I believe 16k node size (the 
default back then was 4k, tho 16k was an available option, just not the 
default).  I'm quite sure that was before skinny metadata by default, as 
well.  Whether the newer features are worth the additional hassle of 
doing the new mkfs.btrfs and copy, as opposed to the more straightforward 
btrfs replace, is up to you, but yes, the defaults are slightly different 
now, so you have that additional information to consider when choosing 
your upgrade method. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

