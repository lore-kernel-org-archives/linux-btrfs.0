Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36080 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444AbaJaONH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 10:13:07 -0400
Date: Fri, 31 Oct 2014 22:12:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: v3.18-rc2 at a 32 bit KVM gives :"INFO: trying to register
 non-static key.the code is fine but needs lockdep annotation."
Message-ID: <20141031141252.GA7522@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <54511C41.5090603@gmx.de>
 <20141030101552.GD26064@localhost.localdomain>
 <5452CAD7.30602@gmx.de>
 <20141031013626.GA30764@localhost.localdomain>
 <54536615.6030900@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <54536615.6030900@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 31, 2014 at 11:36:05AM +0100, Toralf Förster wrote:
> On 10/31/2014 02:36 AM, Liu Bo wrote:
> > On Fri, Oct 31, 2014 at 12:33:43AM +0100, Toralf Förster wrote:
> >> On 10/30/2014 11:15 AM, Liu Bo wrote:
> >>> On Wed, Oct 29, 2014 at 05:56:33PM +0100, Toralf Förster wrote:
> >>>>> This is new in my eyes, or ? :
> >>> Also new to me, could you please turn on lock debug and try again?
> >>>
> >>> thanks,
> >>> -liubo
> >> you mean CONFIG_PROVE_LOCKING=y right ?
> > 
> > I'd have these open,
> > 
> > CONFIG_DEBUG_SPINLOCK=y
> > CONFIG_DEBUG_LOCK_ALLOC=y
> > CONFIG_DEBUG_LOCKDEP=y
> > 
> > __btrfs_alloc_chunk() uses write_[un]lock and spin_[un]lock, it may tell us something.
> > 
> > thanks,
> > -liubo
> > 
> I activated those config options and got immediately after starting the trinity fuzzer :

Can you please tell me the trinity option?

(I'm using "trinity --dangerous -C 2 -N 200 -c writev -q -l off", But I only got softlockup for one time, others are OOM messages.)

thanks,
-liubo

> 
> 
> Oct 31 11:33:31 n22kvmclone kernel: INFO: trying to register non-static key.
> Oct 31 11:33:31 n22kvmclone kernel: the code is fine but needs lockdep annotation.
> Oct 31 11:33:31 n22kvmclone kernel: turning off the locking correctness validator.
> Oct 31 11:33:31 n22kvmclone kernel: CPU: 1 PID: 2470 Comm: trinity-c1 Not tainted 3.18.0-rc2 #3
> Oct 31 11:33:31 n22kvmclone kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> Oct 31 11:33:31 n22kvmclone kernel:  00000000 00000000 f4209b38 d4e689de d5893078 f4209bc0 d4a89238 d4fb1b3c
> Oct 31 11:33:31 n22kvmclone kernel:  f4fc8e14 f4209b78 00000282 f4fc8df4 f4209b84 00000282 00000000 00000000
> Oct 31 11:33:31 n22kvmclone kernel:  00000282 f8903a16 f4fc8e04 00000000 f4fc8e04 f4209b84 d4e702c2 d5893078
> Oct 31 11:33:31 n22kvmclone kernel: Call Trace:
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4e689de>] dump_stack+0x41/0x52
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4a89238>] __lock_acquire+0x1548/0x1ad0
> Oct 31 11:33:31 n22kvmclone kernel:  [<f8903a16>] ? set_avail_alloc_bits+0xd6/0xe0 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4e702c2>] ? _raw_spin_unlock+0x22/0x30
> Oct 31 11:33:31 n22kvmclone kernel:  [<f8903a16>] ? set_avail_alloc_bits+0xd6/0xe0 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f89134f8>] ? btrfs_make_block_group+0x1d8/0x290 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4a3fdd0>] ? native_wbinvd+0x10/0x10
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4a89d7e>] lock_acquire+0x9e/0x130
> Oct 31 11:33:31 n22kvmclone kernel:  [<f8955661>] ? btrfs_alloc_chunk+0x41/0x50 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f8951854>] __btrfs_alloc_chunk+0x684/0xb10 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f8955661>] ? btrfs_alloc_chunk+0x41/0x50 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f8955661>] btrfs_alloc_chunk+0x41/0x50 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f8909fbd>] do_chunk_alloc+0x1dd/0x410 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f89041ae>] ? get_alloc_profile+0x17e/0x300 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f890b174>] btrfs_check_data_free_space+0x144/0x320 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<f893917b>] __btrfs_buffered_write+0x10b/0x550 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4aa8187>] ? current_kernel_time+0x87/0x120
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4a3fdf0>] ? native_restore_fl+0x10/0x10
> Oct 31 11:33:31 n22kvmclone kernel:  [<f89399f0>] btrfs_file_write_iter+0x430/0x730 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4b5d22a>] ? do_iter_readv_writev+0x6a/0xa0
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4b5d22a>] do_iter_readv_writev+0x6a/0xa0
> Oct 31 11:33:31 n22kvmclone kernel:  [<f89395c0>] ? __btrfs_buffered_write+0x550/0x550 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4b5e520>] do_readv_writev+0xa0/0x270
> Oct 31 11:33:31 n22kvmclone kernel:  [<f89395c0>] ? __btrfs_buffered_write+0x550/0x550 [btrfs]
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4b5d2f0>] ? do_sync_readv_writev+0x90/0x90
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4b79a70>] ? __fdget_pos+0x30/0x40
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4aa8187>] ? current_kernel_time+0x87/0x120
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4a3fdf0>] ? native_restore_fl+0x10/0x10
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4ad2dd4>] ? __audit_syscall_entry+0xa4/0x100
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4a86c0b>] ? trace_hardirqs_on+0xb/0x10
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4b5e724>] vfs_writev+0x34/0x60
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4b5e8e6>] SyS_writev+0x56/0xe0
> Oct 31 11:33:31 n22kvmclone kernel:  [<d4e70d6f>] sysenter_do_call+0x12/0x12
> 
> -- 
> Toralf
> pgp key: 0076 E94E
> 
