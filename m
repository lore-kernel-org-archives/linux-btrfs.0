Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53531 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbbHZBRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 21:17:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUPL7-0006i0-6V
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 03:17:21 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 03:17:21 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 03:17:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Response to Bcachefs Claims
Date: Wed, 26 Aug 2015 01:17:14 +0000 (UTC)
Message-ID: <pan$ac59$d5b01668$cfc6f266$3accc55c@cox.net>
References: <1440516154.040713246@apps.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vincent Olivier posted on Tue, 25 Aug 2015 11:22:34 -0400 as excerpted:

> Hi,
> 
> I have been using Btrfs for almost a year now with a 16x4TB RAID10 and
> its 8x4TB RAID0 backup (using incremental snapshots diffs). I have
> always tried to stay at the latest stable kernel (currently 4.1.6). But
> I might be moving to Fedora 22 because Centos 7 has significant
> incompatibilities with the 4.1.x kernel series.
> 
> I have seen the news about Bcachefs aiming to be Btrfs-complete while
> being extX-stable.
> 
> What are the chances Bcachefs beats Btrfs at being the Linux kernel's
> next "official" file system ? I chose Btrfs over ZFS because it seemed
> like the only "next-gen" heir to ext4/xfs.

I've seen the news and welcome the btrfs competition, but expect it'll be 
quite some time before they're both as featureful and at least as "not 
fully stable, but getting there" as btrfs is.  Like the btrfs devs 
originally, I think their estimates will turn out to be wildly 
optimistic, altho it /is/ quite likely they'll do it in fewer years than 
btrfs, as there's more data on what actually works and what doesn't work 
well in the Linux context, now, and because they're starting from an 
already working bcache base.

But meanwhile, either features or stability will suffer.  I strongly 
suspect they may go for stability and speed first, with ext4-comparable 
features first in the development queue except that bcache is already 
multi-device by definition, and may indeed beat btrfs to simple-case full 
stability, since btrfs went broad before deep, covering many features 
before stabilizing.  What would be missing?  I'd guess things like 
transparent compression, some of the available on btrfs raid levels, 
perhaps subvolumes/snapshots, and very possibly quotas, which have proven 
devilishly complex and hard to get right on btrfs, so omitting that alone 
for the initial to-stable feature list could easily mean a few man-years 
of development they can simply skip, to be implemented later.

> I have been having a few problems with Btrfs myself. I have only one
> that remains unresolved : I haven't found the best way to mount Btrfs at
> boot time. "LABEL=" won't work for known reasons (I don't understand
> however why a mount can't do its own "device scan" transparently).
> "UUID=" won't work for unknown reasons (haven't got a reply on this,
> maybe it's the same as "LABEL="). And I will use /dev/* in fstab for
> stability reasons. Right now I'm mounting the fs manually after a
> "device scan" and picking up the first device that shows up in the "fi
> show" run. I can "live" with that but I suppose that things like this
> contribute to the feeling that Btrfs is actually still experimental
> contrarily to claims that it is production-ready.

Basically, there's no way to do multi-device btrfs as rootfs without an 
initr*.  In theory, the kernel commandline rootflags=device= should do 
it, but last I checked anyway, some kernel versions ago, it was still 
broken, tho rootflags=degraded, for instance, would work (mounting the 
pair-devices btrfs raid1 filesystem with only the single device pointed 
at with root=), so there was definitely something wrong with device=, 
specifically.  (My theory is that the kernel commandline parser is seeing 
the two = chars and trying to break at the wrong one, thus instead of 
seeing rootflags and parsing the options from it, it's seeing 
rootflags=device, which the kernel doesn't know anything about, so 
ignores.)

Tho people do use device= in fstab or otherwise provided to mount, and it 
works.  It's just the kernel that can't deal with it in rootflags=, for 
whatever reason.

A multi-device btrfs mounted after / (and /usr...) are up, however, 
should work, provided a btrfs device scan has been performed already, so 
the kernel knows where all the individual device components are.  That's 
also how a working initr* mounts a multi-device btrfs root, BTW, doing a 
btrfs device scan before attempting the mount.  Otherwise, the mount will 
fail.

As for mounting using LABEL= (my preferred method), UUID=, PARTUUID=, 
PARTLABEL=, ID=, PATH=... those are all setup by udev, so udev must be 
run before mounts of that nature will work.  Again, shouldn't be a 
problem for a rootfs if the initr* has udev running before the mount 
attempt; indeed, I use root=LABEL= as a kernel commandline option from 
grub all the time and it just works; but if the initr* doesn't run udev 
first, or if it's a direct kernel root mount with no initr*, it's almost 
certainly not going to work, because udev is what creates those /dev/disk/
by-* entries that both the kernel and mount use for mounts using *= as 
the device.

> For my own sake and other's I would like to maintain (if nobody is
> already working on that nor needs any help) a centralized human-readable
> digest of known issues that would be featured prominently on top of the
> Btrfs wiki. I would merge the Gotchas page and the various known issues
> pages (including the various multi-device mount gotchas here and there).
> 
> Answers ? Comments ? Help ?

I'd personally just put a link to the gotchas page up right near the top, 
preferably in a warning box to increase visibility, and put the real work 
into collecting everything to the gotchas page and then keeping it 
current.  But since it's you volunteering to do the work, you can do it 
your way, big list on the front page, if you like. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

