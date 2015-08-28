Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58228 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbbH1PA6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 11:00:58 -0400
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 28 Aug 2015 20:30:55 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id B3F413940060
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 20:30:53 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7SF0oxb48562412
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 20:30:50 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7SF0kI3011806
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 20:30:46 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V2] Btrfs: Direct I/O: Fix space accounting
Date: Fri, 28 Aug 2015 20:30:45 +0530
Message-ID: <1799477.BQMYSeN9Uy@localhost.localdomain>
In-Reply-To: <20150828020810.GA12392@localhost.localdomain>
References: <1440698940-6102-1-git-send-email-chandan@linux.vnet.ibm.com> <20150828020810.GA12392@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 28 Aug 2015 10:10:54 Liu Bo wrote:
> On Thu, Aug 27, 2015 at 11:39:00PM +0530, Chandan Rajendra wrote:
> > The following call trace is seen when generic/095 test is executed,
> > 
> > WARNING: CPU: 3 PID: 2769 at
> > /home/chandan/code/repos/linux/fs/btrfs/inode.c:8967
> > btrfs_destroy_inode+0x284/0x2a0() Modules linked in:
> > CPU: 3 PID: 2769 Comm: umount Not tainted 4.2.0-rc5+ #31
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > 1.7.5-20150306_163512-brownie 04/01/2014> 
> >  ffffffff81c08150 ffff8802ec9cbce8 ffffffff81984058 ffff8802ffd8feb0
> >  0000000000000000 ffff8802ec9cbd28 ffffffff81050385 ffff8802ec9cbd38
> >  ffff8802d12f8588 ffff8802d12f8588 ffff8802f15ab000 ffff8800bb96c0b0
> > 
> > Call Trace:
> >  [<ffffffff81984058>] dump_stack+0x45/0x57
> >  [<ffffffff81050385>] warn_slowpath_common+0x85/0xc0
> >  [<ffffffff81050465>] warn_slowpath_null+0x15/0x20
> >  [<ffffffff81340294>] btrfs_destroy_inode+0x284/0x2a0
> >  [<ffffffff8117ce07>] destroy_inode+0x37/0x60
> >  [<ffffffff8117cf39>] evict+0x109/0x170
> >  [<ffffffff8117cfd5>] dispose_list+0x35/0x50
> >  [<ffffffff8117dd3a>] evict_inodes+0xaa/0x100
> >  [<ffffffff81165667>] generic_shutdown_super+0x47/0xf0
> >  [<ffffffff81165951>] kill_anon_super+0x11/0x20
> >  [<ffffffff81302093>] btrfs_kill_super+0x13/0x110
> >  [<ffffffff81165c99>] deactivate_locked_super+0x39/0x70
> >  [<ffffffff811660cf>] deactivate_super+0x5f/0x70
> >  [<ffffffff81180e1e>] cleanup_mnt+0x3e/0x90
> >  [<ffffffff81180ebd>] __cleanup_mnt+0xd/0x10
> >  [<ffffffff81069c06>] task_work_run+0x96/0xb0
> >  [<ffffffff81003a3d>] do_notify_resume+0x3d/0x50
> >  [<ffffffff8198cbc2>] int_signal+0x12/0x17
> > 
> > This means that the inode had non-zero "outstanding extents" during
> > eviction. This occurs because, during direct I/O a task which successfully
> > used up its reserved data space would set BTRFS_INODE_DIO_READY bit and
> > does not clear the bit after finishing the DIO write. A future DIO write
> > could actually fail and the unused reserve space won't be freed because
> > of the previously set BTRFS_INODE_DIO_READY bit.
> > 
> > Clearing the BTRFS_INODE_DIO_READY bit in btrfs_direct_IO() caused the
> > following issue,
> > 
> > |-----------------------------------+-------------------------------------
> > ||
> > |
> > | Task A                            | Task B                             
> > | |
> > |
> > |-----------------------------------+-------------------------------------
> > ||
> > |
> > | Start direct i/o write on inode X |                                    
> > | |
> > | reserve space                     |                                    
> > | |
> > | Allocate ordered extent           |                                    
> > | |
> > | release reserved space            |                                    
> > | |
> > | Set BTRFS_INODE_DIO_READY bit     |                                    
> > | |
> > | 
> > |                                   | Start direct i/o write on inode X  
> > |                                   | |
> > |                                   | reserve space                      
> > |                                   | |
> > |                                   | dio_refill_pages()                 
> > |                                   | |
> > |                                   | - sdio->blocks_available == 0      
> > |                                   | |
> > |                                   | - Return -EFAULT                   
> > |                                   | |
> > |                                   | Since BTRFS_INODE_DIO_READY is set,
> > |                                   | |
> > |                                   | we don't release reserved space.   
> > |                                   | |
> > |                                   | Clear BTRFS_INODE_DIO_READY bit.   
> > |                                   | |
> > | 
> > | -EIOCBQUEUED is returned.         |                                    
> > | |
> > |
> > |-----------------------------------+-------------------------------------
> > ||
> 
> This doesn't explain why dio_refill_pages() returns -EFAULT when
> normally it doesn't, and I think it's important to save reviewers' time to
> understand the failure.
> 
> Also it'd be better to add a changelog for this v2 patch.
> 
> Thanks,
> 
> -liubo
>

Sorry for the trouble Liu. The reason for -EFAULT is exactly the same as what
you had found it to be on your machine i.e. splice() provides kernel space
address where as iov_iter_get_pages() expects a user space address. I will
update the commit message and also add the changelog for version V3 of the
patch.


-- 
chandan

