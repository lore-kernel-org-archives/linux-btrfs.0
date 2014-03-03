Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48242 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbaCCROz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 12:14:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WKWS5-00009C-Vp
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 18:14:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 18:14:53 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 18:14:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Filesystem extremly fragmented after scrub
Date: Mon, 3 Mar 2014 17:14:27 +0000 (UTC)
Message-ID: <pan$98412$1e7f3c8c$26899e53$73d49403@cox.net>
References: <CAFvQSYQ0YvG=kJER-C7fkqyfrM0gVOQortC-=VRe680KyXqkEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clemens Eisserer posted on Mon, 03 Mar 2014 16:50:35 +0100 as excerpted:

> I am using btrfs on a single device with crompress-force=lzo and after I
> scrubbed the device once (kernel-3.12), the filesystem is extremly
> fragmented - running defrag on all file didn't improve the situation
> unfourtunately.
> Because I have a fast SSD this is barely noticeable when booting the
> system natively, however when working through VirtualBox (using direct
> disk access) where each access has far higher latency, the system
> responds really slow for file-system intensive tasks (VirtualBox
> "hdd-led" is constantly lid in this case).
> When booting fsck reports the filesystem is 26% non-continous.
> 
> Is there anything I can try to get the FS into a healthier state?

Some general notes.

1) Btrfs should not need boot-time fsck and in fact it is not 
recommended, as the kernel self-heals a number of typical problems, and 
others require a full unmounted btrfsck.  Additionally, btrfsck without 
the --repair option is read-only and the repair option is only 
recommended as a last resort (when the alternative is a mkfs and restore 
from backup), or as instructed by the devs after they've examined the 
errors and decided a repair won't make things worse instead of better.  
Other options should be tried first.

What that means for boot is that the typical fsck.btrfs filesystem-
specific fsck helper shouldn't really even exist (AFAIK it's not provided 
by upstream btrfs-progs at all, I certainly don't have such an executable 
here), and/or your fstab should set 0 as the fsck passno on any btrfs to 
disable boottime fsck.

2) I'm not sure about fsck (presumably btrfsck), but filefrag does not 
know about btrfs compression yet, and thus reports every 128 KiB 
compressed chunk (I'm not sure if the 128 KiB is the compressed or 
uncompressed measure, but I'd guess uncompressed since I believe the 
compression happens 128 KiB at a time) as a separate extent.

3) VM images, as all large more or less constantly "internally 
rewritten" (as opposed to append-only file modifications) files, are a 
challenge for /any/ copy-on-write filesystem, including btrfs.  The 
current recommendation is to set the NOCOW extended attribute (chattr +C) 
on such files, BEFORE they contain any data.  The easiest way to do that 
is to use dedicated VM-image directories and to set the attribute on the 
directory, so it's inherited by any files created therein.  For existing 
VM-images, create the directory and set NOCOW, then (with the VM not 
running) cp --reflink=never the file into the dir.  (Alternatively, mv/cp 
the file from a different partition, thus forcing the reflink off.)

4) While NOCOW will prevent COW and force update-in-place for normal 
operation, the first time data is rewritten after a snapshot will still 
force a COW and be written out-of-line, thus creating a new extent for 
that data, since the snapshot froze the existing copy in place and it's 
now changing, so the change must be written elsewhere.  Thus, don't 
snapshot your VM files.  If you run snapper or another auto-snapshotting 
tool on the rest of your filesystem, the easiest way to prevent snapshots 
on the VMs is to make the dedicated VM-image directory above a dedicated 
subvolume instead, and then simply don't snapshot that subvolume 
(snapshots stop at subvolume boundaries).

5) Alternatively to points #3 and #4, consider placing your VM images on 
a separate partition, using something other than btrfs (presumably ext4 
or xfs), until btrfs has matured a bit more.  Hopefully it'll handle VM-
images and the like rather better after it has thus matured, and this 
manual NOCOW dance will no longer be necessary.

6) Some of these points (and others) are covered on the btrfs wiki tho 
I'm not sure all of them are there yet.  If you aren't familiar with it 
yet, I suggest you spend some time reading it and familiarizing yourself 
with the information found there. =:^)

https://btrfs.wiki.kernel.org


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

