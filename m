Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30245 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaHYEMZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 00:12:25 -0400
Date: Mon, 25 Aug 2014 12:12:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fuzz testing a 32 bit x86 user mode linux guest brought a BUG in
Message-ID: <20140825041213.GD22848@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <53ED3095.4070004@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <53ED3095.4070004@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 11:56:37PM +0200, Toralf Förster wrote:
> 
> Hello,
> 
> a recent kernel brought up this while using trinity inside a x86 UML (stable Gentoo Linux):

Could you please elaborate what options of trinity you're using?

thanks,
-liubo

> 
> 
> Aug 14 22:07:06 trinity kernel: ------------[ cut here ]------------
> Aug 14 22:07:06 trinity kernel: WARNING: CPU: 0 PID: 5860 at fs/btrfs/extent_io.c:430 insert_state+0x69/0x170()
> Aug 14 22:07:06 trinity kernel: BTRFS: end < start 4094 18446744073709551615
> Aug 14 22:07:06 trinity kernel: CPU: 0 PID: 5860 Comm: trinity-c1 Tainted: G    B          3.16.0-11149-gba36899-dirty #7
> Aug 14 22:07:06 trinity kernel: Stack:
> Aug 14 22:07:06 trinity kernel: 085bfd28 085bfd28 00000003 086f0547 0d2e0000 0d2e7cec 085da26e 0d2e7ca4
> Aug 14 22:07:06 trinity kernel: 08501e1f 00000000 0d2e7c78 0d2e7cdc 0807cb95 085ed604 0d2e7d08 000016e4
> Aug 14 22:07:06 trinity kernel: 085da26e 000001ae 082c9109 000001ae 082c9109 00000000 00000000 0d2e7d88
> Aug 14 22:07:06 trinity kernel: Call Trace:
> Aug 14 22:07:06 trinity kernel: [<08501e1f>] dump_stack+0x26/0x28
> Aug 14 22:07:06 trinity kernel: [<0807cb95>] warn_slowpath_common+0x75/0xa0
> Aug 14 22:07:06 trinity kernel: [<082c9109>] ? insert_state+0x69/0x170
> Aug 14 22:07:06 trinity kernel: [<082c9109>] ? insert_state+0x69/0x170
> Aug 14 22:07:06 trinity kernel: [<0807cc0e>] warn_slowpath_fmt+0x2e/0x30
> Aug 14 22:07:06 trinity kernel: [<082c9109>] insert_state+0x69/0x170
> Aug 14 22:07:06 trinity kernel: [<082c9527>] __set_extent_bit+0x177/0x730
> Aug 14 22:07:06 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
> Aug 14 22:07:06 trinity kernel: [<082cab09>] lock_extent_bits+0x59/0x230
> Aug 14 22:07:06 trinity kernel: [<080975ac>] ? finish_task_switch.constprop.53+0x3c/0x90
> Aug 14 22:07:06 trinity kernel: [<08504fc2>] ? mutex_lock+0x12/0x30
> Aug 14 22:07:06 trinity kernel: [<082bcea5>] btrfs_file_llseek+0x1a5/0x440
> Aug 14 22:07:06 trinity kernel: [<08504f9d>] ? __mutex_lock_slowpath+0x28d/0x2a0
> Aug 14 22:07:06 trinity kernel: [<0810d1bf>] vfs_llseek+0x3f/0x50
> Aug 14 22:07:06 trinity kernel: [<0810d217>] SyS_lseek+0x47/0xb0
> Aug 14 22:07:06 trinity kernel: [<080629e0>] handle_syscall+0x60/0x80
> Aug 14 22:07:06 trinity kernel: [<084c04cc>] ? ptrace+0x2c/0x70
> Aug 14 22:07:06 trinity kernel: [<080794a2>] ? get_fp_registers+0x22/0x40
> Aug 14 22:07:06 trinity kernel: [<080745ac>] userspace+0x46c/0x5e0
> Aug 14 22:07:06 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
> Aug 14 22:07:06 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
> Aug 14 22:07:06 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
> Aug 14 22:07:06 trinity kernel: [<0805f720>] fork_handler+0x60/0x70
> Aug 14 22:07:06 trinity kernel:
> Aug 14 22:07:06 trinity kernel: ---[ end trace 77e962ef58783178 ]---
> Aug 14 22:07:06 trinity trinity: Detected kernel tainting. Last seed was 1274643378
> Aug 14 23:28:04 trinity kernel: 08501e1f 00000000 859afb64 859afbc8 0807cb95 085ed604 859afbf4 000015fd
> Aug 14 23:28:04 trinity kernel: 085da26e 000001ae 082c9109 000001ae 082c9109 8640e500 00000000 859afc74
> Aug 14 23:28:04 trinity kernel: Call Trace:
> Aug 14 23:28:04 trinity kernel: [<08501e1f>] dump_stack+0x26/0x28
> Aug 14 23:28:04 trinity kernel: [<0807cb95>] warn_slowpath_common+0x75/0xa0
> Aug 14 23:28:04 trinity kernel: [<082c9109>] ? insert_state+0x69/0x170
> Aug 14 23:28:04 trinity kernel: [<082c9109>] ? insert_state+0x69/0x170
> Aug 14 23:28:04 trinity kernel: [<0807cc0e>] warn_slowpath_fmt+0x2e/0x30
> Aug 14 23:28:04 trinity kernel: [<082c9109>] insert_state+0x69/0x170
> Aug 14 23:28:04 trinity kernel: [<082c9527>] __set_extent_bit+0x177/0x730
> Aug 14 23:28:04 trinity kernel: [<082cab09>] lock_extent_bits+0x59/0x230
> Aug 14 23:28:04 trinity kernel: [<082b593d>] btrfs_evict_inode+0x14d/0x5a0
> Aug 14 23:28:04 trinity kernel: [<08125ffd>] evict+0xdd/0x1b0
> Aug 14 23:28:04 trinity kernel: [<08506281>] ? _raw_spin_lock+0x11/0x20
> Aug 14 23:28:04 trinity kernel: [<08126c7d>] iput+0x16d/0x180
> Aug 14 23:28:04 trinity kernel: [<08122888>] __dentry_kill+0x138/0x200
> Aug 14 23:28:04 trinity kernel: [<081230a6>] dput+0x156/0x180
> Aug 14 23:28:04 trinity kernel: [<0810ed45>] __fput+0x175/0x190
> Aug 14 23:28:04 trinity kernel: [<0810eb90>] ? file_free_rcu+0x0/0x40
> Aug 14 23:28:04 trinity kernel: [<0810ed9b>] ____fput+0xb/0x10
> Aug 14 23:28:04 trinity kernel: [<08092756>] task_work_run+0x76/0x90
> Aug 14 23:28:04 trinity kernel: [<0807e8dd>] do_exit+0x32d/0x940
> Aug 14 23:28:04 trinity kernel: [<0807efd2>] do_group_exit+0xa2/0xf0
> Aug 14 23:28:04 trinity kernel: [<0807f037>] SyS_exit_group+0x17/0x20
> Aug 14 23:28:04 trinity kernel: [<080629e0>] handle_syscall+0x60/0x80
> Aug 14 23:28:04 trinity kernel: [<080e4290>] ? shmem_setattr+0xc0/0x2d0
> Aug 14 23:28:04 trinity kernel: [<084c04cc>] ? ptrace+0x2c/0x70
> Aug 14 23:28:04 trinity kernel: [<080794a2>] ? get_fp_registers+0x22/0x40
> Aug 14 23:28:04 trinity kernel: [<080745ac>] userspace+0x46c/0x5e0
> Aug 14 23:28:04 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
> Aug 14 23:28:04 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
> Aug 14 23:28:04 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
> Aug 14 23:28:04 trinity kernel: [<0805f720>] fork_handler+0x60/0x70
> Aug 14 23:28:04 trinity kernel:
> Aug 14 23:28:04 trinity kernel: ---[ end trace 77e962ef5942c6fc ]---
> Aug 14 23:28:04 trinity kernel: ------------[ cut here ]------------
> Aug 14 23:28:04 trinity kernel: WARNING: CPU: 0 PID: 5629 at fs/btrfs/extent_io.c:430 insert_state+0x69/0x170()
> Aug 14 23:28:04 trinity kernel: BTRFS: end < start 4094 18446744073709551615
> Aug 14 23:28:04 trinity kernel: CPU: 0 PID: 5629 Comm: trinity-main Tainted: G    B   W    L 3.16.0-11149-gba36899-dirty #7
> Aug 14 23:28:04 trinity kernel: Stack:
> Aug 14 23:28:04 trinity kernel: 085bfd28 085bfd28 00000003 086f0547 859a8000 859afbd8 085da26e 859afb90
> Aug 14 23:28:04 trinity kernel: 08501e1f 00000000 859afb64 859afbc8 0807cb95 085ed604 859afbf4 000015fd
> Aug 14 23:28:04 trinity kernel: 085da26e 000001ae 082c9109 000001ae 082c9109 8640e500 00000000 859afc74
> Aug 14 23:28:04 trinity kernel: Call Trace:
> Aug 14 23:28:04 trinity kernel: [<08501e1f>] dump_stack+0x26/0x28
> Aug 14 23:28:04 trinity kernel: [<0807cb95>] warn_slowpath_common+0x75/0xa0
> Aug 14 23:28:04 trinity kernel: [<082c9109>] ? insert_state+0x69/0x170
> Aug 14 23:28:04 trinity kernel: [<082c9109>] ? insert_state+0x69/0x170
> Aug 14 23:28:04 trinity kernel: [<0807cc0e>] warn_slowpath_fmt+0x2e/0x30
> Aug 14 23:28:04 trinity kernel: [<082c9109>] insert_state+0x69/0x170
> Aug 14 23:28:04 trinity kernel: [<082c9527>] __set_extent_bit+0x177/0x730
> Aug 14 23:28:04 trinity kernel: [<082cab09>] lock_extent_bits+0x59/0x230
> Aug 14 23:28:04 trinity kernel: [<082b593d>] btrfs_evict_inode+0x14d/0x5a0
> Aug 14 23:28:04 trinity kernel: [<08125ffd>] evict+0xdd/0x1b0
> Aug 14 23:28:04 trinity kernel: [<08506281>] ? _raw_spin_lock+0x11/0x20
> Aug 14 23:28:04 trinity kernel: [<08126c7d>] iput+0x16d/0x180
> Aug 14 23:28:04 trinity kernel: [<08122888>] __dentry_kill+0x138/0x200
> Aug 14 23:28:04 trinity kernel: [<081230a6>] dput+0x156/0x180
> Aug 14 23:28:04 trinity kernel: [<0810ed45>] __fput+0x175/0x190
> Aug 14 23:28:04 trinity kernel: [<0810eb90>] ? file_free_rcu+0x0/0x40
> Aug 14 23:28:04 trinity kernel: [<0810ed9b>] ____fput+0xb/0x10
> Aug 14 23:28:04 trinity kernel: [<08092756>] task_work_run+0x76/0x90
> Aug 14 23:28:04 trinity kernel: [<0807e8dd>] do_exit+0x32d/0x940
> Aug 14 23:28:04 trinity kernel: [<0807efd2>] do_group_exit+0xa2/0xf0
> Aug 14 23:28:04 trinity kernel: [<0807f037>] SyS_exit_group+0x17/0x20
> Aug 14 23:28:04 trinity kernel: [<080629e0>] handle_syscall+0x60/0x80
> Aug 14 23:28:04 trinity kernel: [<080e4290>] ? shmem_setattr+0xc0/0x2d0
> Aug 14 23:28:04 trinity kernel: [<084c04cc>] ? ptrace+0x2c/0x70
> Aug 14 23:28:04 trinity kernel: [<080794a2>] ? get_fp_registers+0x22/0x40
> Aug 14 23:28:04 trinity kernel: [<080745ac>] userspace+0x46c/0x5e0
> Aug 14 23:28:04 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
> Aug 14 23:28:04 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
> Aug 14 23:28:04 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
> Aug 14 23:28:04 trinity kernel: [<0805f720>] fork_handler+0x60/0x70
> Aug 14 23:28:04 trinity kernel:
> Aug 14 23:28:04 trinity kernel: ---[ end trace 77e962ef5942c6fd ]---
> 
> 
> 
> (The "dirty" comes from an UML fix for kernel/resource.c pending to be come into mainline soon)
> 
> -- 
> Toralf
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
