Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:46694 "EHLO
	mail.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbbJAREv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 13:04:51 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by mail.sjomar.eu (Postfix) with ESMTPSA id B71325D0F7
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2015 19:04:46 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
Date: Thu, 01 Oct 2015 19:04:43 +0200
Message-ID: <1787237.MVYq6GNlXh@hoefnix>
In-Reply-To: <pan$b6f45$856590$f682594c$bd5aae60@cox.net>
References: <1627746.fEEz2JqgZk@hoefnix> <pan$b6f45$856590$f682594c$bd5aae60@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 01 October 2015 02:21:23 Duncan wrote:

> That's very likely because unlike traditional single-device filesystems
> (including single-device btrfs), multi-device btrfs has multiple devices
> it must know about before it can mount the device, while mount only feeds
> it one device.
> 
> There are two ways to tell btrfs (the kernel side) about the other
> devices.
> 
> 1) Do a btrfs device scan before trying to mount.
> 
> 2) Name the component devices in the mount options, using the device=
> option (multiple times as necessary to list all devices).
> 
Option 2 was to simplest to check and that works. Thanks for the tip!
Still weird that my single devide SSD BTRFS bootdisk just worked fine 
(althought it's using the uuid offcourse)...But it would imply to me that 
there's a btrfs device scan run before mounting it.
Before I created the RAID5 I just had the four disks configures as JBOD in 
btrfs (I used partitions that time though) and mounted it just fine with the 
LABEL only, so it might be something with RAID5.

Anyway it's working now with just a much longer fstab line ;)

Cheers,
Sjoerd

