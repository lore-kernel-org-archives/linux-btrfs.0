From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Wed, 02 Jun 2010 10:59:43 +0800
Message-ID: <4C05C91F.5080906@cn.fujitsu.com>
References: <20100527151515.GA3835@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100527151515.GA3835@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris

on 2010-5-27 23:15, Chris Mason wrote: 
> My commits here are just integrating the two and fixing a few bugs in
> the result.
> 
> Zheng Yan (13) commits (+4076/-2679):
>     Btrfs: Integrate metadata reservation with start_transaction (+678/-528)
>     Btrfs: Update metadata reservation for delayed allocation (+232/-415)
>     Btrfs: Shrink delay allocated space in a synchronized (+88/-121)
>     Btrfs: Introduce contexts for metadata reservation (+853/-385)
>     Btrfs: Link block groups of different raid types (+121/-55)
>     Btrfs: Metadata ENOSPC handling for balance (+1163/-747)
>     Btrfs: Metadata ENOSPC handling for tree log (+156/-128)
>     Btrfs: Metadata reservation for orphan inodes (+365/-66)
>     Btrfs: Pre-allocate space for data relocation (+92/-45)
>     Btrfs: Introduce global metadata reservation (+241/-76)
>     Btrfs: Fix block generation verification race (+1/-1)
>     Btrfs: Kill allocate_wait in space_info (+58/-76)
>     Btrfs: Kill init_btrfs_i() (+28/-36)
> 
> Chris Mason (9) commits (+314/-80):
>     Btrfs: fix preallocation and nodatacow checks in O_DIRECT (+140/-16)
>     Btrfs: move O_DIRECT space reservation to btrfs_direct_IO (+8/-6)
>     Btrfs: don't walk around with task->state != TASK_RUNNING (+4/-3)
>     Btrfs: use async helpers for DIO write checksumming (+52/-17)
>     Btrfs: add more error checking to btrfs_dirty_inode (+13/-2)
>     Btrfs: avoid ENOSPC errors in btrfs_dirty_inode (+11/-3)
>     Btrfs: rework O_DIRECT enospc handling (+49/-30)
>     Btrfs: drop verbose enospc printk (+2/-0)
>     Btrfs: allow unaligned DIO (+35/-3)
> 
> Josef Bacik (5) commits (+829/-134):
>     direct-io: add a hook for the fs to provide its own submit_bio function (+45/-8)
>     fs: allow short direct-io reads to be completed via buffered IO (+31/-5)
>     direct-io: do not merge logically non-contiguous requests (+18/-2)
>     Btrfs: add basic DIO read/write support (+631/-36)
>     Btrfs: do aio_write instead of write (+104/-83)
> 
> Total: (27) commits
> 

In the following mail, You said that you had put the cleanups which Zhao Lei and I contributed
into a .35 queue, but I cannot find those patches have been merged into the .35 kernel...
  http://marc.info/?l=linux-btrfs&m=127049622906168&w=2

Is there anything wrong with those patches?

Regards
Miao

