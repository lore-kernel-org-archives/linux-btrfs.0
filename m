Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51543 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbcACOZg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Jan 2016 09:25:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aFjbB-0000g1-GS
	for linux-btrfs@vger.kernel.org; Sun, 03 Jan 2016 15:25:33 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 15:25:33 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 15:25:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: WARNING CPU at linux/fs/btrfs/ioctl.c:558 create_subvol BTRFS
 Transaction aborted (error -2)
Date: Sun, 3 Jan 2016 14:25:27 +0000 (UTC)
Message-ID: <pan$adec0$9aa96a93$995ad4e8$faf97fc@cox.net>
References: <CA+X5Wn66VabG5mnQPfPvgUuadgEs5a+UtNLSohjrr-pe1GOoog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

james harvey posted on Sat, 02 Jan 2016 23:40:38 -0500 as excerpted:

> I notice snapper always forces me to have a subvolume
> "main/var/lib/machines".  I don't store vm files there, I've tried
> deleting it, but snapper forces it back.  But, when running off the
> archiso the subvolume delete for the .snapshots folder, I don't see the
> "main/var/lib/machines" subvolume... So I'm thinking this oddity may be
> a pointer toward why this is happening.
> 
> I was confused why I was even seeing "create_subvol" during boot.  It
> must be then snapper makes the "main/var/lib/machines" subvolume during
> boot, not when on the archiso.  So, deleting the .snapshots volume
> booted off the ISO must be leaving btrfs in a bad state, so on reboot
> when a subvol is created by snapper, it fails.

FWIW...

I don't use snapper, or indeed, subvolumes/snapshots at all, on my (gentoo 
with systemd) installation, but FWIW, recent versions of systemd will try 
to create /var/lib/machines (and a few others) as a subvolume at boot 
time, if it doesn't already exist.

Older versions of systemd, before it integrated more btrfs support, 
created normal subdirs at these locations (tho the /var/lib/machines one 
was /var/lib/container or some such, back then).

I happen to know about it as the first systemd version (218, IIRC, or was 
it 219?) that attempted to include that integration didn't handle the 
errors from attempts to do the subvolume create on a still read-only-
mounted / [1], so the corresponding tmpfs.d running service failed.  The 
previous version's mkdir -p calls had worked fine, since mkdir -p 
succeeds when the dirs already exist.  That wasn't fixed until 221 or 
perhaps 222.

Of course your post mentions main/var/lib/machines, not simply /var/lib/
machines, but obviously, in the correct context the main/ version is 
there due to the /var/lib/machines case, and /var/lib/machines may in 
fact be seen as main/var/lib/machines depending on subvolume usage and 
mounting.

So I'm guessing either it's systemd creating it (with the /var/ context) 
and not snapper, or it's snapper creating it (with the main/ context), 
knowing that systemd uses the corollary, so it can manage the systemd 
created subvolume in snapshot context as well.

Doesn't solve your transaction aborted situation, but should provide a 
bit more information on those specific subvols/subdirs and why snapper or 
systemd is trying to create them.

---
[1] Read-only mounte /: I keep my / mounted read-only by default, only 
mounting it writable when I want to update or change configuration.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

