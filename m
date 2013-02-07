Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50053 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566Ab3BGNbQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2013 08:31:16 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E3C367C04D7
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2013 06:31:15 -0700 (MST)
Date: Thu, 7 Feb 2013 08:31:13 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [RFC][PATCH] Btrfs: fix deadlock due to unsubmitted
Message-ID: <20130207133113.GC21679@shiny>
References: <51137DF7.7050006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51137DF7.7050006@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 03:12:07AM -0700, Miao Xie wrote:
> The deadlock problem happened when running fsstress(a test program in LTP).
> 
> Steps to reproduce:
>  # mkfs.btrfs -b 100M <partition>
>  # mount <partition> <mnt>
>  # <Path>/fsstress -p 3 -n 10000000 -d <mnt>
> 
> The reason is:
> btrfs_direct_IO()
>  |->do_direct_IO()
>      |->get_page()
>      |->get_blocks()
>      |	 |->btrfs_delalloc_resereve_space()
>      |	 |->btrfs_add_ordered_extent() -------	Add a new ordered extent
>      |->dio_send_cur_page(page0) --------------	We didn't submit bio here
>      |->get_page()
>      |->get_blocks()
> 	 |->btrfs_delalloc_resereve_space()
> 	     |->flush_space()
> 		 |->btrfs_start_ordered_extent()
> 		     |->wait_event() ----------	Wait the completion of
> 						the ordered extent that is
> 						mentioned above
> 
> But because we didn't submit the bio that is mentioned above, the ordered
> extent can not complete, we would wait for its completion forever.
> 
> There are two methods which can fix this deadlock problem:
> 1. submit the bio before we invoke get_blocks()
> 2. reserve the space before we do dio
> 
> Though the 1st is the simplest way, we need modify the code of VFS, and it
> is likely to break contiguous requests, and introduce performance regression
> for the other filesystems.
> 
> So we have to choose the 2nd way.

The 3rd option is to have get_blocks return -EAGAIN to the direct-io.c
code and let the higher levels submit the bios they have built.

Josef will probably go for option #4, which is dropping the generic code
completely and doing it all ourselves.

But I do like your approach, it makes sense here.

-chris
