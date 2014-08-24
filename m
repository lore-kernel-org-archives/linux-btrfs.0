Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50753 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751682AbaHXTsk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 15:48:40 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49462 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XLdmJ-0047E6-Ct
	for linux-btrfs@vger.kernel.org; Sun, 24 Aug 2014 13:48:39 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: superblock checksum mismatch after crash, cannot mount
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <9896671408899573@web11g.yandex.ru>
Date: Sun, 24 Aug 2014 13:48:38 -0600
Message-Id: <401C8BD0-BE70-4FDF-A37A-D65D131E8843@colorremedies.com>
References: <9896671408899573@web11g.yandex.ru>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 24, 2014, at 10:59 AM, Flash ROM <flashromguru@yandex.com> wrote:
> 
> 1) Formatting and repartitioning SD card? Generally WORST IDEA EVER.

All cameras have a format function, and this function both partitions and formats (creates a filesystem/volume format).  If they can get away with it, so can anyone else.


> While it sounds dumb, this strange thing being done to put partition table in separate erase block, so it never read-modify-written when FAT entries are updated. Should something go wrong, FAR can recover from backup copy. But erased partition table just suxx. Then, FAT tables are aligned in way to fit well around erase block bounds.

I think you seriously overestimate the knowledge of camera manufacturer's about the details of flash storage; and any ability to discover it; and any willingness on the part of the flash manufacturer to reveal such underlying details. The whole point of these cards is to completely abstract the reality of the underlying hardware from the application layer - in this case the camera or mobile device using it.

Also, with SDXC exFAT is now specified. And it has only one FAT there isn't a backup FAT. So they're even more difficult to recover data from should things go awry filesystem wise.


> This said, you can *try* to reformat, BUT no standard OS of firmware formatter will help you with default settings. They can't know geometry of underlying NAND and controller properties. There is no standard, widely accepted way to get such information from card. No matter if you use OS formatter, camera formatter or whatever. YOU WILL RUIN factory format (which is crafted in best possible way) and replace it with another, very likely suboptimal one.

It's recommended by the card manufacturers to reformat it in each camera its inserted into. It's the only recommended way to "erase" the sd card for re-use, they don't recommend selectively deleting images. And it's known that one camera's partition table and formatting can irritate another camera make/model if the card isn't reformatted by that camera.

> So once you trashed factory filesystem, you're really on your own and proceeding on your own risk.

Absurd. It's recommended *by* both device manufacturers (cameras and mobile devices) that consume such cards, as well as the cards' manufacturers. The workflow you're proposing for SD Cards is as a write once device with no practical way of deleting the files on it.


Chris Murphy

