Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbaJ3KQC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 06:16:02 -0400
Date: Thu, 30 Oct 2014 18:15:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: v3.18-rc2 at a 32 bit KVM gives :"INFO: trying to register
 non-static key.the code is fine but needs lockdep annotation."
Message-ID: <20141030101552.GD26064@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <54511C41.5090603@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <54511C41.5090603@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 29, 2014 at 05:56:33PM +0100, Toralf Förster wrote:
> This is new in my eyes, or ? :

Also new to me, could you please turn on lock debug and try again?

thanks,
-liubo
> 
> Oct 29 17:53:04 n22kvmclone kernel: INFO: trying to register non-static key.
> Oct 29 17:53:04 n22kvmclone kernel: the code is fine but needs lockdep annotation.
> Oct 29 17:53:04 n22kvmclone kernel: turning off the locking correctness validator.
> Oct 29 17:53:04 n22kvmclone kernel: CPU: 0 PID: 2525 Comm: trinity-c0 Not tainted 3.18.0-rc2 #1
> Oct 29 17:53:04 n22kvmclone kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> Oct 29 17:53:04 n22kvmclone kernel:  00000000 00000000 f55e5b70 c2a5d3ba 00000000 f55e5bc4 c2684a7b c2ba5888
> Oct 29 17:53:04 n22kvmclone kernel:  c2a64822 f55a0000 f55e5bb4 00000000 00000000 00000001 00000000 f890b458
> Oct 29 17:53:04 n22kvmclone kernel:  00000000 f55a0df4 f55a0e04 f40c3000 01000000 c2d68578 f5719c94 f62b6ea0
> Oct 29 17:53:04 n22kvmclone kernel: Call Trace:
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2a5d3ba>] dump_stack+0x41/0x52
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2684a7b>] __lock_acquire.isra.31+0x89b/0x9a0
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2a64822>] ? _raw_spin_unlock+0x22/0x30
> Oct 29 17:53:04 n22kvmclone kernel:  [<f890b458>] ? btrfs_make_block_group+0x1d8/0x290 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<c263f360>] ? native_wbinvd+0x10/0x10
> Oct 29 17:53:04 n22kvmclone kernel:  [<c26850ff>] lock_acquire+0x8f/0x110
> Oct 29 17:53:04 n22kvmclone kernel:  [<f894d001>] ? btrfs_alloc_chunk+0x41/0x50 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f8949304>] __btrfs_alloc_chunk+0x684/0xb10 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f894d001>] ? btrfs_alloc_chunk+0x41/0x50 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f894d001>] btrfs_alloc_chunk+0x41/0x50 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f8901f8d>] do_chunk_alloc+0x1dd/0x410 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f88fc196>] ? get_alloc_profile+0x166/0x2d0 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f8903144>] btrfs_check_data_free_space+0x144/0x320 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f8930e8b>] __btrfs_buffered_write+0x10b/0x550 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<f89316c0>] btrfs_file_write_iter+0x3f0/0x6c0 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2755eba>] ? do_iter_readv_writev+0x6a/0xa0
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2755eba>] do_iter_readv_writev+0x6a/0xa0
> Oct 29 17:53:04 n22kvmclone kernel:  [<f89312d0>] ? __btrfs_buffered_write+0x550/0x550 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2757210>] do_readv_writev+0xa0/0x270
> Oct 29 17:53:04 n22kvmclone kernel:  [<f89312d0>] ? __btrfs_buffered_write+0x550/0x550 [btrfs]
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2755f80>] ? do_sync_readv_writev+0x90/0x90
> Oct 29 17:53:04 n22kvmclone kernel:  [<c27720c0>] ? __fdget_pos+0x30/0x40
> Oct 29 17:53:04 n22kvmclone kernel:  [<c269d6c1>] ? do_setitimer+0x121/0x200
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2a64992>] ? _raw_spin_unlock_irq+0x22/0x40
> Oct 29 17:53:04 n22kvmclone kernel:  [<c269d6c1>] ? do_setitimer+0x121/0x200
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2757414>] vfs_writev+0x34/0x60
> Oct 29 17:53:04 n22kvmclone kernel:  [<c27575d6>] SyS_writev+0x56/0xe0
> Oct 29 17:53:04 n22kvmclone kernel:  [<c2a6522b>] sysenter_do_call+0x12/0x12
> 
> -- 
> Toralf
> pgp key: 0076 E94E
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
