Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:59250 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbcHAEKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 00:10:40 -0400
Date: Mon, 1 Aug 2016 00:00:45 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs fi usage bug during shrink
Message-ID: <20160801040044.GA18667@coach.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all. I was resizing (shrinking) a btrfs partition, and figured I'd
check in on how it was going with "btrfs fi usage." It was quite
startling:

$ sudo btrfs fi usage /mnt/

Overall:
    Device size:		 370.00GiB
    Device allocated:		 372.03GiB
    Device unallocated:		  16.00EiB
    Device missing:		     0.00B
    Used:			 360.56GiB
    Free (estimated):		     0.00B	(min: 8.00EiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 224.00MiB	(used: 0.00B)

Data,single: Size:370.02GiB, Used:359.31GiB
   /dev/mapper/c1	 370.02GiB

Metadata,DUP: Size:1.00GiB, Used:639.22MiB
   /dev/mapper/c1	   2.00GiB

System,DUP: Size:8.00MiB, Used:64.00KiB
   /dev/mapper/c1	  16.00MiB

Unallocated:
   /dev/mapper/c1	  16.00EiB


It's reasonably obvious what's going on, here. The overall size has been
set to the final size, and now the worker is going through balancing all
the chunks that are now out of bounds. 

I feel like "fi usage" should probably have some logic to detect this
situation and report something more sensible. Thankfully, it's only
transient, and returns to normal once the resize completes.

Thanks,

--Sean

