Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57904 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbbBJEmh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 23:42:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YL2ec-0007pV-LF
	for linux-btrfs@vger.kernel.org; Tue, 10 Feb 2015 05:42:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 05:42:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 05:42:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Date: Tue, 10 Feb 2015 04:42:25 +0000 (UTC)
Message-ID: <pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

P. Remek posted on Mon, 09 Feb 2015 18:26:49 +0100 as excerpted:

> Hello,
> 
> I am benchmarking Btrfs and when benchmarking random writes with fio
> utility, I noticed following two things:
> 
> 1) On first run when target file doesn't exist yet, perfromance is about
> 8000 IOPs. On second, and every other run, performance goes up to 70000
> IOPs. Its massive difference. The target file is the one created during
> the first run.

You say a file size of 10 GiB with a block size of 4 KiB, but don't say 
whether you're using the autodefrag mount option, or whether you had set 
nocow on the file at creation (generally done by setting it on the 
directory, so new files inherit the option, chattr +C).

What I /suspect/ is happening, is that at the 10 GiB files size, on 
original file creation, btrfs is creating a large file of several 
comparatively large extents (possibly 1 GiB each, the nominal data chunk 
size, tho it can be larger on large enough filesystems).  Note that btrfs 
will normally wait to sync, accumulating further writes into the file 
before actually writing it.  By default it's 30 seconds, but there's a 
mount option to change that.  So btrfs is probably waiting, then writing 
out all changes for the last 30 seconds at once, allowing it to use 
fairly large extents when it does so.

Then when the file already exists,, keeping in mind that btrfs is COW 
(copy-on-write) and that by default it keeps two copies of metadata (dup 
on a single device, or one each on two separate devices, on a multi-
device filesystem), one copy of data (single on a single device, I 
believe raid0 on multi-device), it's having to COW individual 4K blocks 
within the file as they are rewritten.

This is going to massively fragment the file, driving up IOPs 
tremendously.  On top of that, each time a data fragment is written, 
there's going to be two metadata updates due to the dup/raid1 metadata 
default, and while they won't be updated immediately, every commit (30 
seconds), those metadata changes are going to replicate up the metadata 
tree to its root.

So instead of having a few orderly GiB-ish size extents written, along 
with their metadata, as at file-create, now you're writing a new extent 
for each changed 4 KiB block, plus 2X metadata updates for each one, plus 
every commit, the updated metadata chain up to the root.

Those 70K IOPs are all the extra work the filesystem is doing in ordered 
to track those 4 KiB COWed writes!

The autodefrag option will likely increase this even further, as it 
doesn't prevent the COWs, but instead, queues up any files it detects as 
fragmented, for later cleanup via autodefrag worker thread.  This is one 
reason this option isn't recommended for large (say quarter to half-gig-
plus) heavy-internal-rewrite-pattern use-cases (typically VM images or 
large database files), tho it works quite well for files upto a couple 
hundred MiB or so (typical of firefox sqlite database files, etc), since 
those get rewritten pretty fast.

The nocow file attribute can be used on these larger files, but it does 
have additional implications.  Nocow turns off btrfs compression for that 
file, if you had it enabled (mount option), and also turns off 
checksumming.  Turning off checksumming means btrfs will no longer detect 
file corruption, but many databases and vm tools have their own 
corruption detection and possibly correction schemes already, since they 
use them on filesystems such as ext* that don't have builtin 
checksumming, so turning off the btrfs checksumming and error detection 
for these files isn't as bad as it would otherwise seem, and in many 
cases prevents the filesystem duplicating work that the application is 
already doing.  (Also, on btrfs, nocow must be set at file creation, when 
it is still zero-sized.  As mentioned above, this is usually accomplished 
by setting it on the directory and letting new files and subdirs inherit 
the attribute.)

But with the nocow file attribute properly applied, these random rewrites 
will be done in-place, no cascading fragmentation and metadata updates, 
and my guess is that you'll see the IOPs on existing nocow files reduce 
to something far more sane as a result.

> 2) There are windows during the test where IOPs drop to 0 and stay 0
> about 10 seconds and then it goes back again, and after couple of
> seconds again to 0. This is reproducible 100% times.

I recall this periodic behavior coming up in at least one earlier thread 
as well, but I'm not a dev, just a btrfs user and list regular, and I 
don't recall what the explanation was, unless it was related to internal 
btrfs bookkeeping due to that 30-second commit cycle I mentioned above.

But I'm guessing that if you properly set nocow on the file, you'll 
probably see this go away as well, since you won't be overwhelming btrfs 
and the hardware with IOPs any longer.

Perhaps someone with a better understanding of the situation will jump in 
and explain this bit better than I can...

> Can somobody shred some light on what's happening?
> 
> 
> Command: fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
> --name=test9 --filename=test9 --bs=4k --iodepth=256 --size=10G
> --numjobs=1 --readwrite=randwrite
> 
> Environment:
> CPU: dual socket: E5-2630 v2
> RAM: 32 GB ram
> OS: Ubuntu server 14.10
> Kernel: 3.19.0-031900rc2-generic
> btrfs tools: Btrfs v3.14.1
> 2x LSI 9300 HBAs
> - SAS3 12/Gbs 8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs

I suppose you're already aware that you're running a rather outdated 
userspace/btrfs-progs (what I assume you meant by tools).  Userspace 
versions sync with the kernel cycle, with a particular 3.x.0 version 
typically being released a couple weeks after the kernel of the same 
version, usually with a couple 3.x.y, y-update releases following before 
the next kernel-synced x-version bump.

So userspace/progs v3.19.0 isn't out yet (tho rc2 is available), but 
3.18.2 is current, well beyond your 3.14.1.

FWIW, a current kernel is most important during normal operation, as the 
userspace simply tells the kernel what to do at a high level and the 
kernel follows thru with its lower level code.  So for normal operation, 
userspace getting a bit behind isn't a major issue unless you want a 
feature only available in a newer version.

But if something goes wrong and you're trying to diagnose and repair from 
userspace, THAT is when the userspace low-level code is run, and thus 
when userspace version becomes vitally important.

So as long as nothing's going wrong, you're probably OK with that 3.14 
userspace.  But I'd still recommend updating to current and keeping 
current, because you don't want to be scrambling to build a newer 
userspace after something goes wrong, in ordered to have the best chance 
at recovery.

Kudos on having a current kernel, at least.  There have been quite a few 
kernel bugs fixed since 3.14 era, and you're running a current kernel so 
at least aren't needlessly risking the known bugs of the older ones where 
it's operationally important. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

