Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:59448 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab2LROIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:08:44 -0500
Date: Tue, 18 Dec 2012 09:08:40 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?T=F3th?= Csaba <tsabi@tsabi.hu>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs problem
Message-ID: <20121218140840.GE2403@localhost.localdomain>
References: <50CE3AF2.6000900@tsabi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <50CE3AF2.6000900@tsabi.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 16, 2012 at 02:19:46PM -0700, Tóth Csaba wrote:
> Dear Community,
> 
> i have a linux server with a btrfs root filesystem. After some time, or
> a specific action (i don't know what exactly) it crashes. Sometimes it
> needs some day, sometimes when i make a concrete action, like subvolume
> delete, or make a new directory, etc.
> 
> this is what i see from the dmesg output:
> 
> [ 7595.865982] ------------[ cut here ]------------
> [ 7595.865989] WARNING: at fs/btrfs/super.c:221
> __btrfs_abort_transaction+0xc5/0xe0()
> [ 7595.865991] Hardware name: VMware Virtual Platform
> [ 7595.865992] btrfs: Transaction aborted
> [ 7595.865993] Modules linked in:
> [ 7595.865994]  ipv6 iptable_filter ip_tables x_tables 8250_pnp vmwgfx
> 8250 ttm serial_core drm i2c_piix4 sr_mod ppdev parport_pc e1000
> i2c_core cdrom pcspkr parport floppy ghash_clmulni_intel microcode
> [ 7595.866006] Pid: 13959, comm: btrfs Not tainted 3.5.4-gentoo-03 #1
> [ 7595.866006] Call Trace:
> [ 7595.866010]  [<ffffffff8103b589>] ? warn_slowpath_common+0x79/0xc0
> [ 7595.866012]  [<ffffffff8103b685>] ? warn_slowpath_fmt+0x45/0x50
> [ 7595.866013]  [<ffffffff81242f55>] ? __btrfs_abort_transaction+0xc5/0xe0
> [ 7595.866016]  [<ffffffff81270e04>] ? btrfs_unlink_subvol+0x204/0x360
> [ 7595.866020]  [<ffffffff8129b28e>] ? btrfs_ioctl_snap_destroy+0x39e/0x4f0
> [ 7595.866021]  [<ffffffff8129d1bb>] ? btrfs_ioctl+0x81b/0x1250
> [ 7595.866024]  [<ffffffff810259d2>] ? do_page_fault+0x182/0x440
> [ 7595.866027]  [<ffffffff8105ef63>] ? __wake_up+0x43/0x70
> [ 7595.866030]  [<ffffffff810fa1ef>] ? do_vfs_ioctl+0x8f/0x520
> [ 7595.866033]  [<ffffffff810e9d10>] ? vfs_write+0x140/0x190
> [ 7595.866034]  [<ffffffff810fa6c9>] ? sys_ioctl+0x49/0x80
> [ 7595.866038]  [<ffffffff815e8ca6>] ? system_call_fastpath+0x1a/0x1f
> [ 7595.866039] ---[ end trace 1d7d6e7d89b14907 ]---
> [ 7595.866041] BTRFS error (device sda5) in btrfs_unlink_subvol:3176:
> error 28
> [ 7595.866042] btrfs is forced readonly
> [ 7595.866044] BTRFS error (device sda5) in
> btrfs_ioctl_snap_destroy:2038: error 28
> 
> 
> fwt portage # uname -a
> Linux fwt 3.5.4-gentoo-03 #1 SMP Thu Oct 4 20:13:12 CEST 2012 x86_64
> Intel(R) Xeon(R) CPU X5650 @ 2.67GHz GenuineIntel GNU/Linux
> 
> 
> Please if you can help me how to stabilize the file system, as i use
> this as the root filesystem.
> 
> I am not in the mail list.

Can you try a newer kernel and see if you still have problems?  I think 3.7.1
just got released, give that a whirl if you want to stay on a stable kernel, or
give btrfs-next a whirl if you don't mind trying something a little less stable.
Thanks,

Josef
