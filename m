Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53886 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752899Ab3L3Dsm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 22:48:42 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:53355 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VxTqI-000TxN-H7
	for linux-btrfs@vger.kernel.org; Sun, 29 Dec 2013 20:48:38 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Migrate to bcache: A few questions
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <fgu6pa-f1b.ln1@hurikhan77.spdns.de>
Date: Sun, 29 Dec 2013 20:48:37 -0700
Message-Id: <278C02FA-6920-428A-A9A8-1E81F2E8E192@colorremedies.com>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de> <45EA1F82-A774-4729-9279-D58ACF819B05@colorremedies.com> <fgu6pa-f1b.ln1@hurikhan77.spdns.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 29, 2013, at 6:22 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> So you are saying that data 
> may not be fully written to SSD although the kernel thinks so?

Drives shouldn't lie when asked to flush to disk, but they do. Older article about this at lwn is a decent primer on the subject of write barriers.

http://lwn.net/Articles/283161/

> This is 
> probably very dangerous. The bcache module could not ensure coherence 
> between its backing devices and its own contents - and data loss will occur 
> and probably destroy important file system structures.

I don't know the details, there's more detail on lkml.org and bcache lists. My impression is that short of bugs, it should be much safer than you describe. It's not like a linear/concat md or LVM device fail scenario. There's good info in the bcache.h file:

http://lxr.free-electrons.com/source/drivers/md/bcache/bcache.h

If anything, once the kinks are worked out, under heavy random write IO I'd expect bcache to improve the likelihood data isn't lost. Faster speed of SSD means we get a faster commit of the data to stable media. Also bcache assumes the cache is always dirty on startup, no matter whether the shutdown was clean or dirty, so the code is explicitly designed to resolve the state of the cache relative to the backing device. It's actually pretty fascinating work.

It may not be required, but I'd expect we'd want the write cache on the backing device disabled. It should still honor write barriers but it kinda seems unnecessary and riskier to have it enabled (which is the default with consumer drives).


> As I understand, bcache may use write-through for sequential writes, but 
> write-back for random writes. In this case, part of the data may have hit 
> the backing device, other data does only exist in the bcache. If that last 
> transaction is not closed due to power-loss, and then thrown away, we have 
> part of the transaction already written to the backing device that the 
> filesystem does not know of after resume.

In the write through case we should be no worse off than the bare drive in a power loss. In the write back case the SSD should have committed more data than the HDD could have in the same situation. I don't understand the details of how partially successful writes to the backing media are handled when the system comes back up. Since bcache is also COW, SSD blocks aren't reused until data is committed to the backing device.


Chris Murphy