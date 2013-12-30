Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56261 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752770Ab3L3BDQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 20:03:16 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:49499 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VxRGC-0041M8-QW
	for linux-btrfs@vger.kernel.org; Sun, 29 Dec 2013 18:03:12 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Migrate to bcache: A few questions
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <kof6pa-akd.ln1@hurikhan77.spdns.de>
Date: Sun, 29 Dec 2013 18:03:11 -0700
Message-Id: <45EA1F82-A774-4729-9279-D58ACF819B05@colorremedies.com>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 29, 2013, at 2:11 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> 
> * How stable is it? I've read about some csum errors lately…

Seems like bcache devs are still looking into the recent btrfs csum issues.

> 
> * I want to migrate my current storage to bcache without replaying a backup.
>  Is it possible?
> 
> * Did others already use it? What is the perceived performance for desktop
>  workloads in comparision to not using bcache?
> 
> * How well does bcache handle power outages? Btrfs does handle them very
>  well since many months.
> 
> * How well does it play with dracut as initrd? Is it as simple as telling it
>  the new device nodes or is there something complicate to configure?
> 
> * How does bcache handle a failing SSD when it starts to wear out in a few
>  years?

I think most of these questions are better suited for the bcache list. I think there are still many uncertainties about the behavior of SSDs during power failures when they aren't explicitly designed with power failure protection in mind. At best I'd hope for a rollback involving data loss, but hopefully not a corrupt file system. I'd rather lose the last minute of data supposedly written to the drive, than have to do a fuil restore from backup.

> 
> * Is it worth waiting for hot-relocation support in btrfs to natively use
>  a SSD as cache?

I haven't read anything about it. Don't see it listed in project ideas.

> 
> * Would you recommend going with a bigger/smaller SSD? I'm planning to use
>  only 75% of it for bcache so wear-leveling can work better, maybe use
>  another part of it for hibernation (suspend to disk).

I think that depends greatly on workload. If you're writing or reading a lot of disparate files, or a lot of small file random writes (mail server), I'd go bigger. By default sequential IO isn't cached. So I think you can get a big boost in responsiveness with a relatively small bcache size.


Chris Murphy