Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55351 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaHaJl4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 05:41:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XO1dz-0008ED-1e
	for linux-btrfs@vger.kernel.org; Sun, 31 Aug 2014 11:41:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Aug 2014 11:41:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Aug 2014 11:41:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: find_mount_root() issue
Date: Sun, 31 Aug 2014 09:41:41 +0000 (UTC)
Message-ID: <pan$abcad$cae3304e$722c055b$e8898249@cox.net>
References: <62013C11-1628-42C1-929B-24E46858D38B@yerf-it.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remco Hosman - Yerf IT.nl posted on Sun, 31 Aug 2014 09:37:38 +0200 as
excerpted:

> issue:
> on my system i have 2 entries for /, one with the type ‘rootfs’ and a
> 2nd one with the type ‘btrfs’. find_mount_root() uses the first one and
> reports a fail.
> 
> My change:
> if (longest_matchlen < len) {
> into:
> if (longest_matchlen <= len) {
> 
> i have not tested this, but in my understanding it will use the last
> longest match instead of the first.
> 
> I have no idea if this rootfs entry is normal nor if its always there
> before the ‘proper’ one.
> 
> These are the 2 entries in my mount list:
> rootfs / rootfs rw 0 0
> /dev/sda2 / btrfs rw,noatime,ssd,noacl,space_cache 0 0

AFAIK that rootfs entry is the kernel's built-in initramfs that it 
automatically mounts, even if empty, before mounting your real-root.

If you use an initramfs/initrd, the switch_root process normally hides/
unmounts the initr*, but if you don't and the kernel is using its empty 
one, nothing hides/unmounts it, so it's still there after the normal / is 
mounted over top.

At least, I always booted to root directly without an initr*, and always 
had a rootfs entry until relatively recently, presumably when I switched 
to a two-device btrfs real-rootfs, and had to create and use an initramfs 
to do so[1].  Now I don't have a rootfs entry any longer.

---
[1] Initr* required for multi-device btrfs root: Btrfs has the device= 
mount option, which would normally be passed via a kernel-command-line 
rootflags= option to btrfs, that can be used with multi-device-
filesystems in the absence of btrfs device scan.  Unfortunately, 
rootflags=device= fails for some reason, or at least did last time I 
tried it, so the only way I can get a multi-device btrfs root to mount is 
to use an initr*.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

