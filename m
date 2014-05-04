Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47738 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbaEDVtk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 May 2014 17:49:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wh4Hx-0004m9-RV
	for linux-btrfs@vger.kernel.org; Sun, 04 May 2014 23:49:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 23:49:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 23:49:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
Date: Sun, 4 May 2014 21:49:24 +0000 (UTC)
Message-ID: <pan$a3b93$98e8eca3$3f96ad92$ba13c4f@cox.net>
References: <20140503232702.GC9061@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 03 May 2014 16:27:02 -0700 as excerpted:

> So, I was thinking. In the past, I've done this:
> mkfs.btrfs -d raid0 -m raid1 -L btrfs_raid0 /dev/mapper/raid0d*
> 
> My rationale at the time was that if I lose a drive, I'll still have
> full metadata for the entire filesystem and only missing files.
> If I have raid1 with 2 drives, I should end up with 4 copies of each
> file's metadata, right?

Brendan has answered well, but sometimes a second way of putting things 
helps, especially when there was originally some misconception to clear 
up, as seems to be the case here.  So let me try to be that rewording. 
=:^)

No.  Btrfs raid1 (the multi-device metadata default) is (still only) two 
copies, as is btrfs dup (which is the single-device metadata default 
except for SSDs).  The distinction is that dup is designed for the single 
device case and puts both copies on that single device, while raid1 is 
designed for the multi-device case, and ensures that the two copies 
always go to different devices, so loss of the single device won't kill 
the metadata.

Additional details:

I am not aware of any current possibility of having more than two copies, 
no matter the mode, with a possible exception during mode conversion (say 
between raid1 and raid6), altho even then, there should be only two /
active/ copies.

Dup mode being designed for single device usage only, it's normally not 
available on multi-device filesystems.  As Brendan mentions, the way 
people sometimes get it is starting with a single-device filesystem in dup 
mode and adding devices.  If they then fail to balance-convert, old 
metadata chunks will be dup mode on the original device, while new ones 
should be created as raid1 by default.  Of course a partial balance-
convert will be just that, partial, with whatever failed to convert still 
dup mode on the original single device.

As a result, originally (and I believe still) it was impossible to 
configure dup mode on a multi-device filesystem at all.  However, someone 
did post a request that dup mode on multi-device be added as a (normally 
still heavily discouraged) option, to allow a conversion back to single-
device, without at any point dropping to non-redundant single-copy-only.  
Using the two-device raid1 to single-device dup conversion as an example, 
currently you can't btrfs device delete below two devices as that's no 
longer raid1.  Of course if both data and metadata are raid1, it's 
possible to physically disconnect one device, leaving the other as the 
only online copy but having the disconnected one in reserve, but that's 
not possible when the data is single mode, and even if it was, that 
physical disconnection will trigger read-only mode on filesystem as it's 
no longer raid1, thereby making the balance-conversion back to dup 
impossible.  And you can't balance-convert to dup on a multi-device 
filesystem, so balance-converting to single, thereby losing the 
protection of the second copy, then doing the btrfs device delete, 
becomes the only option.  Thus the request to allow balance-convert to dup 
mode on a multi-device filesystem, for the sole purpose of then allowing 
btrfs device delete of the second device, converting it back to a single-
device filesystem without ever losing second-copy redundancy protection.

Finally, for the single-device-filesystem case, dup mode is normally only 
allowed for metadata (where it is again the default, except on ssd), 
*NOT* for data.  However, someone noticed and posted that one of the side-
effects of mixed-block-group mode, used by default on filesystems under 1 
GiB but normally discouraged on filesystems above 32-64 gig for 
performance reasons, because in mixed-bg mode data and metadata share the 
same chunks, mixed-bg mode actually allows (and defaults to, except on 
SSD) dup for data as well as metadata.  There was some discussion in that 
thread as to whether that was a deliberate feature or simply an 
accidental result of the sharing.  Chris Mason confirmed it was the 
latter.  The intention has been that dup mode is a special case for 
rather critical metadata on a single device in ordered to provide better 
protection for it, and the fact that mixed-bg mode allows (indeed, even 
defaults to) dup mode for data was entirely an accident of mixed-bg mode 
implementation -- albeit one that's pretty much impossible to remove.  
But given that accident and the fact that some users do appreciate the 
ability to do dup mode data via mixed-bg mode on larger single-device 
filesystems even if it reduces performance and effectively halves storage 
space, I expect/predict that at some point, dup mode for data will be 
added as an option as well, thereby eliminating the performance impact of 
mixed-bg mode while offering single-device duplicate data redundancy on 
large filesystems, for those that value the protection such duplication 
provides, particularly given btrfs' data checksumming and integrity 
features.


> But now I have 2 questions

> 1) btrfs has two copies of all metadata on even a single drive, correct?

By default, yes, except on SSD, where dup remains an option.  But not if 
single (the default metadata mode for single-device SSD) or (for multi-
device) raid0 modes are chosen instead of dup.

> If so, and I have a -d raid0 -m raid0 filesystem, are both copies of the
> metadata on the same drive or is btrfs smart enough to spread out
> metadata copies so that they're not on the same drive?

If you specify raid0 metadata, there's no second metadata copy, on the 
same drive or elsewhere.  Further, raid0 mode stripes metadata across all 
available devices so it's even more fragmented than single mode, 
practically eliminating any chance of recovery in the event of device 
failure.

IOW, if you have raid0 metadata and a device fails or even simply does 
what would be a relatively minor temporary dropout in other raid cases, 
consider the filesystem toast.  (If you're extremely lucky and the 
dropout was temporary, such that you can recreate the raid0 with the 
dropped device, you /may/ be able to save it.  And it should drop to read-
only mode as soon as a dropped device is detected to help maximize the 
chance of that.  But don't count on it!  Simply don't use raid0 for 
anything you value at all, and you won't have to worry about it.)

> 2) does btrfs lay out files on raid0 so that files aren't striped across
> more than one drive, so that if I lose a drive, I only lose whole files,
> but not little chunks of all my files, making my entire FS toast?

No.  That's the distinction between raid0 mode and single mode.  Raid0 
mode effectively sacrifices everything else for (single thread sequential 
access) speed.  If a device drops out, consider anything that was raid0 
toast.

In theory at least, if the metadata is intact (as it should be with a 
single device drop for metadata raid1 mode), a file smaller than a single 
raid0 "strip" (the size of a stripe on a single device) may still be 
intact as well.  And as more devices are added to the raid0 stripe, 
dropping a single one does allow the lucky-case recovery file-size to 
increase as well, up to stripe-size minus strip-size for a single device 
drop-out, while also increasing the absolute chances for sub-strip-size 
files since their chances approximate N-1/N (where N is the number of 
devices in the stripe and -1 is the single device drop).

Additionally, it can be noted that if a file is small enough, btrfs may 
actually store it in metadata instead of going to the trouble of 
allocating a data chunk extent for it, and the sub-block end of a file 
may similarly be stored in metadata instead of taking another whole block 
of data.  (Reiserfs users will be familiar with this as tail-packing.)  
Of course if the metadata is dup/raid1/whatever instead of raid0/single, 
these small metadata-only-stored files should be recoverable as well.

But those are the lucky cases.  As I said above, the general rule is that 
anything on raid0 is destroyed if a device drops, so you never NEVER 
stick anything on raid0 that you value at all, and then you won't have to 
worry about it! =:^)

(Meanwhile, from experience I can say that the speed of raid0 isn't 
always as good as one might expect, either.  It does speed up the single-
thread sequential-access case as one might expect, but on today's multi-
core multi-threading many-tasking systems, single-IO-thread filesystem 
access is actually rather rare.  Then of course there's random-access as 
well.  As a result, at least for my use-case which apparently includes 
far more independent task parallel read than some, I actually found mdraid 
with its N-copies raid1 and surprisingly good parallel multi-IO-thread 
read scheduling faster than its raid0, with writes still occurring at 
normal single-device speed (unlike raid5/6 which penalizes writes) due to 
the bottleneck being the physical spinning rust.  (Obviously fast SSDs 
will change that bottleneck factor, with the individual bus to SSD speed 
usually becoming the bottleneck except for the underpowered CPU case, but 
raid1 write speed still remains reasonably close to the slowest device 
write speed in most cases.)  Of course btrfs raid1 currently limits to 
two copies and may or may not be as efficiently scheduled as md/raid1, 
but that's yet another reason why I really /really/ want N-way-mirroring 
for btrfs, since two-thread-parallel-read-access certainly beats single-
thread, but from experience I know that at least for my use-case and on 
spinning-rust, a 3-4-thread-parallel-read pattern is common enough that I 
see the benefits.  That said, I'm switching to SSD now, and the speed 
there is sufficient that I suspect I'm unlikely to see much benefit above 
3-thread-parallel and I might not actually see much from 3-thread-
parallel either.  But I'd sure like the chance to try it, and with the 
data-integrity benefits of 3-way-mirroring on btrfs as well, I'm really 
eager to see the feature introduced. =:^)

Of course the much safer and more flexible but still speedy compromise is 
raid10, which remains the general case ideal -- with the only caveat 
being the relatively high entry four-device-minimum entry cost.  (Tho 
mdraid10 does have some flexibility in that regard and can do its form of 
raid10 on fewer than four devices, at the cost of increased conceptual 
complexity and speed.)

The bottom line remains, however, don't put anything on raid0 that you 
value at all, such that you're entirely OK considering it toast and 
simply putting the remaining devices to other uses instead of even trying 
to recover, if a device drops out of the raid0.  Raid0 is optimized for 
one thing only, speed, and that in only one rather narrow and 
increasingly uncommon in the modern age use-case, single-thread-
sequential-access.  And the price it pays for that optimization is, IMO, 
very rarely worth it, tho if you have that use-case and are prepared to 
pay the cost in terms of data-loss risk, it can /indeed/ be worth it.  
Just be sure that's your use case, preferably testing a raid0 deployment 
in actual use to be sure it's giving you that extra speed, because in 
many cases, it won't, and then it's simply NOT worth the data risk cost, 
period.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

