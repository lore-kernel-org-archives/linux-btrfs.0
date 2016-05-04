Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37948 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbcEDLkh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 07:40:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1axvAL-0002ux-W9
	for linux-btrfs@vger.kernel.org; Wed, 04 May 2016 13:40:30 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 13:40:29 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 13:40:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
Date: Wed, 4 May 2016 11:40:19 +0000 (UTC)
Message-ID: <pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niccolò Belli posted on Wed, 04 May 2016 11:46:10 +0200 as excerpted:

> Hi,
> I have the following options for my rootfs in /etc/fstab:
> rw,relatime,compress=lzo,ssd,discard,space_cache,autodefrag,
> subvolid=257,subvol=/@
> 
> grub2 already placed rootflags=subvol=@ in its cmdline, but not the
> other options. I suppose that some of them will automatically be set
> during remount, but I'm not sure if all of them will.
> 
> Do you know which ones should I manually add to GRUB_CMDLINE_LINUX in
> /etc/default/grub?
> 
> Is there any way to check to if they are already enabled?
> mount shows /dev/mapper/cryptroot on / type btrfs
> (rw,relatime,compress=lzo,ssd,discard,space_cache,autodefrag,
> subvolid=257,subvol=/@)
> but I'm not sure if I can trust it: I read that space_cache should
> trigger "enabling free space tree" in dmesg but I can't see it and I
> don't know about the others.

The mount output should be correct.

Two points about space_cache in particular:

1) There are now two forms of space-cache, the older and still default 
(normal) space_cache, and the newer space-cache-tree, aka space-cache-v2.  
I don't yet use the latter myself and thus haven't been paying extremely 
close attention to the details, but the point here is... See that "tree" 
on the end of the dmesg entry you thought was missing?  That's only if 
you've enabled the tree/v2 version.  So that you don't see it simply 
means you haven't specifically enabled the not-yet-default tree/v2 
version, not that (the original) space_cache isn't enabled.

For the older/default space_cache, you should see "disk space caching is 
enabled".

2) space_cache is the default these days.  I've never specifically 
enabled it on any of my btrfs, yet I get both that "disk space caching is 
enabled" in the kernel log (where I copied it from) and mount (and /proc/
self/mounts) reporting it.

So you shouldn't have to specifically enable space_cache any longer, and 
can omit that from your mount options.  It should just be enabled unless 
you specifically turn it off.  Of course if you want to use the v2/tree 
stuff, you have to specifically enable it -- once.  Then it's enabled by 
default as well (with a rollback to v1 available if you want, be sure to 
read up a bit on how to get back to v1 if you need to, before actually 
enabling v2).


About the others...

* compress=lzo you need to keep in your mount options.  Older blocks will 
remain as they are, but newly written blocks won't be compressed without 
a compression option on the current mount.

* autodefrag, similar.  FWIW, here, I make sure it's enabled from first 
mount of the filesystem -- the filesystem is never mounted writable 
without it.

* ssd is often autodetected.  You might wish to try taking out that 
option and see if it still shows up once the filesystem is mounted.  
(Technically, the ssd autodetect triggers on the setting of the 
rotational file for the associated device in sysfs.  That should be 
correct for physical devices, but various intermediate layers like 
dmcrypt, md/dmraid, etc, may not pass it thru.)  I don't have to have it 
in my options here for btrfs to enable it, but YMMV.

* discard is never enabled by default, because there's some ssds it 
doesn't work well on.  So you always have to specify that if you want it.


*** Finally, unless you have specific reason not to, specifying noatime 
is recommended, strongly recommended if you do snapshotting.  The default 
relatime is a reasonable compromise on most filesystems, as it avoids 
breaking old apps (like mutt) that depend on atime, but there's very 
little if anything modern that depends on atime, on ssds even relatime is 
almost always a needless waste of limited write-cycles, and on btrfs with 
snapshotting, even relatime updates can be a large part of your metadata 
changes between shapshots, so it's definitely worth turning off (with 
noatime) in that case unless you specifically know you need it.


As for setting them in grub using rootflags, or in fstab, with or without 
also setting them in your initr* (if you have one), here, setting them in 
fstab (without setting them in the initr* that I'm aware of, anyway), 
works just fine.

However, unlike many, I actually keep my root filesystem mounted read-
only by default -- ro in my fstab mount options along with autodefrag, 
compress=lzo, etc, and only mount it writable for system updates.  If I 
were mounting it writable even as early as the initial mount in the 
initr*, I'd want to ensure that I had autodefrag,compress=lzo,noatime, 
set there as well, either by specifically including it in the initr*, or 
by setting rootflags= on the kernel commandline via grub or whatever.  If 
your initr* first mounts it read-only, and it's not mounted writable 
until you've switched to the main system and are using the main system's 
fstab, then fstab should be fine.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

