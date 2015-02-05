Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59130 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbBFArL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 19:47:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJX4e-00069O-4T
	for linux-btrfs@vger.kernel.org; Fri, 06 Feb 2015 01:47:08 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 01:47:08 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 01:47:08 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS EFI Boot question
Date: Fri, 06 Feb 2015 00:54:55 +0100
Message-ID: <ffcdqb-15o.ln1@hurikhan77.spdns.de>
References: <005001d0418a$e980a980$bc81fc80$@lksmith.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lucas Smith <vedalken@lksmith.net> schrieb:

> Hey folks!
> 
> Having a confusing question brought up to me by my Debian Testing
> installer and am unsure what the implications are for it. I want to run
> btrfs in RAID10 on 4x1TB WD RE3 drives. Apparently, my system is set up to
> boot using EFI. Are there any reasons not to use EFI Booting in this
> circumstance?

I'm using UEFI boot with btrfs RAID-1 on three devices (including bcache 
meanwhile). It works without problems. The only caveat is, that for both, 
bcache and multi-device btrfs (or combination of both) you need to boot 
using initramfs because the kernel by itself can neither detect multi-device 
btrfs not initialize bcache. This applies if you want to use it for the 
rootfs.

You are all fine if rootfs is something more traditional.

My layout is having the ESP (mounted as /boot), a resume swap and bcache 
caching device on an SSD, the rest is 3x 1TB spinning rust with btrfs, 
containing root and all the other subvolumes.

-- 
Replies to list only preferred.

