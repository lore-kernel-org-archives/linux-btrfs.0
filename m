Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60324 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751154AbaA3RdZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 12:33:25 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:56959 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W8vUQ-003yF9-VH
	for linux-btrfs@vger.kernel.org; Thu, 30 Jan 2014 10:33:23 -0700
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
Date: Thu, 30 Jan 2014 10:33:21 -0700
Message-Id: <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 29, 2014, at 12:16 PM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:

> My situation:
> 
> Former btrfs-RAID1 on two luks encrypted partitions (bunkerA and bunkerB).
> Disk holding bunkerB died online.
> Now I started rebalancing bunkerA to single,


You're doing an online conversion of a degraded raid1 volume into single? Does anyone know if this is expected or intended to work?

Obviously the tools allow you to start it, but for some reason to me it doesn't seem like a good idea.  I'd just leave it -o degraded until I get a replacement drive. Deciding to do a conversion on a degraded volume doesn't seem like proper timing.

> 
> Now the damaged disk disappeared completely. No sign of it in /proc/diskstats.

I don't know what you mean by it's disappeared complete. Are you talking about the physical block device? Or the dm logical block device?

What do you get for:
lsblk
blkid
btrfs device scan --all-devices
btrfs fi show



> But now, I can't mount bunkerA degraded,RW because degraded
> filesystems are not allowed to be mounted RW (?)

Have you tried? What errors do you get in user space and dmesg?


Chris Murphy

