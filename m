Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 206-248-167-68.dsl.teksavvy.com ([206.248.167.68]:55340 "EHLO
	mail.isoar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaHUVVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 17:21:19 -0400
Received: from localhost ([127.0.0.1])
	by mail.isoar.ca with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.80.1 #2)
	id 1XKYq2-0000Oz-1P
	for linux-btrfs@vger.kernel.org; Thu, 21 Aug 2014 16:20:02 -0400
Message-ID: <53F65471.2070205@isoar.ca>
Date: Thu, 21 Aug 2014 16:20:01 -0400
From: "Andrew E. Mileski" <andrewm@isoar.ca>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on using BtrFS for fileserver
References: <20140819162151.GA15166@forwiss.uni-passau.de>
In-Reply-To: <20140819162151.GA15166@forwiss.uni-passau.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/08/14 12:21 PM, M G Berberich wrote:
>
> we are thinking about using BtrFS on standard hardware for a
> fileserver with about 50T (100T raw) of storage (25×4TByte).
>
> ...
>
> · Are there any reports/papers/web-pages about BtrFS-systems this size
>    in use? Praises, complains, performance-reviews, whatever…

For what it is worth, I am running two btrfs filesystems:
1. Primary:  25 TiB, hardware RAID-6, LVM, PCIex8 (11x3TB)
2. Backup :  25 TiB, software RAID-5, LUKS, USB 3.0 (8x4TB)

I am not using btrfs RAID (-d single -m dup), rather hardware or 
software MD.  Neither are partitioned (as they are not bootable).

I do hourly / daily / weekly / monthly / yearly snapshots on subvolumes 
in the primary fs, and pruning excess snapshots (example: I only keep 24 
hourly snapshots).

Currently using stock Fedora 20, though I try to keep the btrfs utility 
up-to-date by building from GIT when an updated RPM is not available.


Overall impressions of btrfs:

* Very resilient.

It has suffered many hardware-related panics and no data-loss or 
filesystem corruption has been detected.  I maintain a backup, which 
includes hashes of everything, and also 5% par2 recovery for some 
critical data.

The data is fairly static though, with the vast majority of operations 
being reads.

* Much higher CPU load than ext4.

This exposes a known reset issue with the old 3Ware 9650SE-ML16 RAID 
controller.  Switching to the NOOP IO scheduler helped reduce the load 
considerably, but it still can get quite high [even without LUKS].

CPU & motherboard replacement hardware is on-hand, and an upgrade is 
imminent (currently using an old Core2 Duo @ 3 GHz, 4 GiB DDR2).

* Slow to mount, but not an unreasonable amount.


~~ Andrew E. Mileski
