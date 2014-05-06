Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48275 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbaEFULy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 16:11:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhlEi-0002My-QG
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 21:41:08 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:41:08 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:41:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
Date: Tue, 6 May 2014 19:05:52 +0000 (UTC)
Message-ID: <pan$31100$5edd829$14fe1b2f$4e1f4bd7@cox.net>
References: <pan$a3b93$98e8eca3$3f96ad92$ba13c4f@cox.net>
	<20140505012719.GD10159@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 04 May 2014 18:27:19 -0700 as excerpted:

> On Sun, May 04, 2014 at 09:44:41AM +0200, Brendan Hide wrote:
>> >Ah, I see the man page now "This is because SSDs can remap blocks
>> >internally so duplicate blocks could end up in the same erase block
>> >which negates the benefits of doing metadata duplication."
>> 
>> You can force dup but, per the man page, whether or not that is
>> beneficial is questionable.
> 
> So the reason I was confused originally was this:
> legolas:~# btrfs fi df /mnt/btrfs_pool1
> Data, single: total=734.01GiB, used=435.39GiB
> System, DUP: total=8.00MiB, used=96.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=8.50GiB, used=6.74GiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> This is on my laptop with an SSD. Clearly btrfs is using duplicate
> metadata on an SSD, and I did not ask it to do so.
> Note that I'm still generally happy with the idea of duplicate metadata
> on an SSD even if it's not bulletproof.

In regard to metadata defaulting to single rather than the (otherwise) dup 
on single-device ssd:

1) In ordered to do that, btrfs (I guess mkfs.btrfs in this case) must be 
able to detect that the device *IS* ssd.  Depending on the SSD, the 
kernel version, and whether the btrfs is being created direct on bare-
metal device or on some device layered (lvm or dmcrypt or whatever) on 
top of the bare metal, btrfs may or may not successfully detect that.

Obviously in your case[1] the ssd wasn't detected.

Question:  Does btrfs detect ssd and automatically add it to the mount 
options for that btrfs?  I suspect not, thus consistent behavior in not 
detecting the SSD.  FWIW, it is detected here.  I've never specifically 
added ssd to any of my btrfs mount options, but it's always there in 
/proc/self/mounts when I check.[2]

I believe I've seen you mention using dmcrypt or the like, however, which 
probably doesn't pass whatever is used for ssd protection on thru, thus 
explaining btrfs not seeing it and having to specify it yourself, if you 
wish.

While I'm not sure, I /think/ btrfs may use the sysfs rotational file (or 
rather, the same information that the kernel exports to that file) for 
this detection.  For my bare-metal devices that's:

/sys/block/sdX/queue/rotational

For my ssds that file contains "0" while for spinning rust, it contains 
"1".

The contents of that file are derived in turn from the information 
exported by the device.  I believe the same information can be seen with 
hdparm -I, in the Configuration section, as Nominal Media Rotation Rate.

For my spinning rust that returns an RPM value such as 7200.  For my sdds 
it returns "Solid State Device".

The same information can be seen with smartctl -i, which has much shorter 
output so it's easier to find.  Look for Rotation Rate.

Again, my ssds report "Solid State Device", while my spinning rust 
reports a value such as "7200 rpm".

2) The only reason I happen to know about the SSD metadata single-device 
single mode default exception (where metadata otherwise defaults to dup 
mode on single-device, and to raid1 mode on multi-device regardless of 
the media), is as a result of I believe Chris Mason commenting on it in 
an on-list reply.

The reasoning given in that reply was not the erase-block reason I've 
seen someone else mention here (and which doesn't quite make sense to me, 
since I don't know why that would make a difference), but rather:

Some SSD firmware does automatic deduplication and compression.  On these 
devices, DUP-mode would almost certainly be stored as a single internal 
data block with two external address references anyway, so it would 
actually be single in any case, and defaulting to single (a) doesn't hide 
that fact, and (b) reduces overhead that's justified for safety 
otherwise, but if the firmware is doing an end run around that safety 
anyway, might as well just shortcut the overhead as well.

However, while the btrfs default will apply to all (detected) ssds, not 
all ssds have firmware that does this internal deduplication!

In fact, the documentation for my ssds sells its LACK of such compression 
and deduplication as a feature, pointing out that such features tend to 
make the behavior of a device far less predictable[3], tho they do 
increase maximum speed and capacity.

Which is why I've chosen to specify dup mode on my single-device btrfs 
here, even on ssds.[4]  While it'd be the wrong choice on ssds that do 
compression and deduplication, on mine, it's still the right choice. =:^)


If your SSDs don't do firmware-based dedup/compression, then dup metadata 
is still arguably the best choice on ssd.  But if they do, the single 
metadata default does indeed make more sense, even if that's not the 
default you're getting due to lack of ssd detection.

---
[1] Obviously ssd not detected: Assuming you didn't specify metadata 
level, probably a safe assumption or we'd not be having the discussion.  
Personally, I always make a point of specifying both data and metadata 
level here when doing a mkfs.btrfs, just to be sure.

[2] My btrfs are all on SSD.  I'm still using legacy reiserfs on my 
legacy spinning rust, but reiserfs' journaling behavior isn't appropriate 
for ssd, so where I've upgraded to ssd I use btrfs.  Which works out 
great since the spinning rust is backup for the ssds, and the very mature 
reiserfs is backup for the still under heavy development btrfs. =:^)

[3] Compression/deduplication performance:  Indeed, both the speed and 
capacity of devices with compression and deduplication varies greatly 
depending on the compressibility of the data, tho maximum speed and 
capacity is certainly greater, but it's not easily predictable.

[4] Most of my btrfs are raid1 mode across two devices.  I do have a 
couple single-device btrfs, however, /boot and its backup on the other 
device, instead of the usual raid1 mode across both devices but with a 
second raid1 btrfs primary backup of the first on a second set of 
partitions across the same devices, with the /boot exception being 
because it's a lot easier to tell the BIOS to boot from the other device 
and thus select the backup /that/ way, than it is to tell grub to use a 
different /boot!  Altho with grub2, it's actually possible to have it 
select the /boot too, but the BIOs selector method is stiff easier.

Of course being /boot and its backup, those single-device btrfs are both 
quite small, 256 MiB each, and I use mixed-bg (-M in mkfs.btrfs) mode for 
them as a result.  That means I dup both data and metadata at the same 
time, since their mixed together, which in turn means the effective 
filesystem capacity is half the filesystem size, 128 MiB instead of 256.  
But 128 MiB is fine for /boot.  I just have to track the number of 
kernels (with attached initramfs on each one, dramatically increasing the 
individual kernel size) I have available a bit closer and delete them 
sooner than I might otherwise, plus watch the btrfs fi show output a bit 
more closely and do a balance when unallocated gets too low.  But I still 
have room to track a couple stable kernels, plus a dozen or so pre-
releases when I'm bisecting a kernel bug, before I have to start deleting.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

