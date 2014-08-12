Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaHLI2C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 04:28:02 -0400
Date: Tue, 12 Aug 2014 16:27:54 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15 btrfs free space cache oops
Message-ID: <20140812082754.GE9244@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAMVG2stLXT+Yo=C8fsNx9g+6h9h4r-Yni3D=EeRVQObCVhw98w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMVG2stLXT+Yo=C8fsNx9g+6h9h4r-Yni3D=EeRVQObCVhw98w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Daniel,

On Tue, Aug 12, 2014 at 01:14:08PM +0800, Daniel J Blueman wrote:
> When running MonetDB over a BTRFS RAID-0 set over 4 SSDs [1] on
> 3.15.5, we see io_ctl have a bad address of 0x200000, causing a fatal
> pagefault in memcpy():
> 
> (gdb) list *(__btrfs_write_out_cache+0x3e4)
> 0xffffffff81365984 is in __btrfs_write_out_cache
> (fs/btrfs/free-space-cache.c:521).
> 516            if (io_ctl->index >= io_ctl->num_pages)
> 517                return -ENOSPC;
> 518            io_ctl_map_page(io_ctl, 0);
> 519        }
> 520
> 521        memcpy(io_ctl->cur, bitmap, PAGE_CACHE_SIZE);
> 522        io_ctl_set_crc(io_ctl, io_ctl->index - 1);
> 523        if (io_ctl->index < io_ctl->num_pages)
> 524            io_ctl_map_page(io_ctl, 0);
> 525        return 0;
> 
> I can try to reproduce it if more data is useful?

It's strange, in fact we seldom get such kind of page fault crash. 

Does it happens with 3.16, or can you get CONFIG_DEBUG_PAGEALLOC=y?

thanks,
-liubo

> 
> Thanks,
>   Daniel
> 
> -- [1]
> 
> mkfs.btrfs -f -m raid0 -d raid0 -n 16k -l 16k -O skinny-metadata
> /dev/sda2 /dev/sdc2 /dev/sdb2 /dev/sdd2
> mount /dev/sda2 /scratch -o noatime,discard,nodatasum,nobarrier,ssd_spread
> 
> -- [2]
> 
> BUG: unable to handle kernel paging request at 0000000000200000
> IP: [<ffffffff8135a374>] __btrfs_write_out_cache+0x3e4/0x8e0
> PGD 3bca02c067 PUD 3bcf5fb067 PMD 0
> Oops: 0000 [#1] SMP
> Modules linked in:
> CPU: 34 PID: 46645 Comm: mserver5 Not tainted 3.15.5-server #7
> Hardware name: Dell Inc. PowerEdge R815/0W13NR, BIOS 3.1.1 [1.1.54] 10/16/2013
> task: ffff880a8c7234f0 ti: ffff8809aefcc000 task.ti: ffff8809aefcc000
> RIP: 0010:[<ffffffff8135a374>] [<ffffffff8135a374>]
> __btrfs_write_out_cache+0x3e4/0x8e0
> RSP: 0018:ffff8809aefcfc40 EFLAGS: 00010246
> RAX: 0000004fb9321000 RBX: ffff8809aefcfca8 RCX: 0000000000000200
> RDX: 0000000000001000 RSI: 0000000000200000 RDI: ffff884fb9321000
> RBP: ffff8809aefcfd48 R08: 0000000000000200 R09: 0000000000000000
> R10: 0000000000000000 R11: ffff884fb9320ffc R12: ffff8831e3303740
> R13: ffff880100579970 R14: ffff880bb38061c0 R15: 0000000000200000
> FS: 00007fb9447ed700(0000) GS:ffff884bbfc80000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000200000 CR3: 000000329b71c000 CR4: 00000000000407e0
> Stack:
>  ffff8809aefcfc90 0000000000000011 0000000e00000000 ffff884fbbc2c870
>  ffff880bb38061c0 ffff8809aefcfc90 ffff880bb3806058 ffff880b000002ec
>  ffff883bcd523800 ffff8833d338f2c0 ffff88476b1eb4e0 000000b890cde000
> Call Trace:
>  [<ffffffff81a75b4b>] ? _raw_spin_lock+0xb/0x20
>  [<ffffffff8135c0e1>] btrfs_write_out_cache+0xb1/0xf0
>  [<ffffffff8130be0b>] btrfs_write_dirty_block_groups+0x58b/0x670
>  [<ffffffff813199c5>] commit_cowonly_roots+0x195/0x250
>  [<ffffffff8131b92f>] btrfs_commit_transaction+0x41f/0x9b0
>  [<ffffffff81358e85>] ? btrfs_log_dentry_safe+0x55/0x70
>  [<ffffffff8132b6b2>] btrfs_sync_file+0x182/0x2a0
>  [<ffffffff8114a450>] do_fsync+0x50/0x80
>  [<ffffffff8114a6de>] SyS_fdatasync+0xe/0x20
>  [<ffffffff81a766e6>] system_call_fastpath+0x1a/0x1f
> Code: ff 4d 89 fc 49 89 c7 e9 ab 00 00 00 0f 1f 00 40 f6 c7 02 0f 85
> fe 00 00 00 40 f6 c7 04 0f 85 14 01 00 00 89 d1 c1 e9 03 f6 c2 04 <f3>
> 48 a5 74 09 8b 0e 89 0f b9 04 00 00 00 f6 c2 02 74 0e 44 0f
> RIP [<ffffffff8135a374>] __btrfs_write_out_cache+0x3e4/0x8e0
>  RSP <ffff8809aefcfc40>
> CR2: 0000000000200000
> -- 
> Daniel J Blueman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
