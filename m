Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:65012 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751539Ab3K0EzN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 23:55:13 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: missing /sbin/fsck.btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
Date: Tue, 26 Nov 2013 21:55:09 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2D538DF7-452A-420F-9826-C2059564C0A5@colorremedies.com>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com> <pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


If I change the bootloader kernel paramter line from ro to rw, and simply wipe out the roofs entry from fstab, I still have a bootable system. Is there a good reason why rootfs on btrfs should initially mount ro? It seems the legacy reason for this is so rootfs is available, yet can still have fsck run on it, after which it's remounted rw. None of that applies to btrfs does it?

In which case we're slightly faster booting rw from the start, which is a bootloader configuration change. And then having installers exclude / from fstab. (Already systemd is mounting rootfs rw anyway, and, using special GPT partitiontypeguids, it's automounting swap and /home even if they're not listed in fstab.)

Any comments on the efficacy of initial ro state when / is on Btrfs?


Chris Murphy