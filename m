Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:52794 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab2JKSmb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 14:42:31 -0400
Message-ID: <50771184.2060807@profihost.ag>
Date: Thu, 11 Oct 2012 20:35:48 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: use_block_rsv problems with 3.6.1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

on i've seen the following backtrace a lot on 3.6.1:
[ 2231.644332] use_block_rsv: 1451 callbacks suppressed
[ 2231.645249] btrfs: block rsv returned -28
[ 2231.645250] ------------[ cut here ]------------
[ 2231.646163] WARNING: at fs/btrfs/extent-tree.c:6323 
use_block_rsv+0x19a/0x1a0 [btrfs]()
[ 2231.647092] Hardware name: Bochs
[ 2231.648051] Modules linked in: ipt_REJECT xt_tcpudp k8temp 
iptable_filter ip_tables x_tables ext2 usbhid microcode i2c_piix4 button 
i2c_core btrfs zlib_deflate lzo_compress sg sd_mod virtio_net uhci_hcd 
ata_generic virtio_scsi ehci_hcd virtio_pci virtio_ring virtio floppy 
usbcore usb_common ata_piix
[ 2231.651137] Pid: 4155, comm: btrfs Tainted: G        W    3.6.1+2-ph #1
[ 2231.652217] Call Trace:
[ 2231.653248]  [<ffffffff8104988a>] warn_slowpath_common+0x7a/0xb0
[ 2231.654296]  [<ffffffff810498d5>] warn_slowpath_null+0x15/0x20
[ 2231.655327]  [<ffffffffa00e91aa>] use_block_rsv+0x19a/0x1a0 [btrfs]
[ 2231.656379]  [<ffffffffa00ed4d8>] btrfs_alloc_free_block+0x38/0x220 
[btrfs]
[ 2231.657377]  [<ffffffff8111d49b>] ? kmem_cache_free+0x1b/0xf0
[ 2231.658347]  [<ffffffffa010f01f>] ? btrfs_get_token_64+0x5f/0xf0 [btrfs]
[ 2231.659293]  [<ffffffffa0112633>] ? read_extent_buffer+0xb3/0x110 [btrfs]
[ 2231.660258]  [<ffffffffa00d96e1>] __btrfs_cow_block+0x121/0x510 [btrfs]
[ 2231.661189]  [<ffffffffa00da0ff>] btrfs_cow_block+0xef/0x200 [btrfs]
[ 2231.662113]  [<ffffffffa00dd149>] btrfs_search_slot+0x359/0x7b0 [btrfs]
[ 2231.663045]  [<ffffffffa00f0de9>] btrfs_del_csums+0x249/0x330 [btrfs]
[ 2231.663980]  [<ffffffffa0113ea7>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 2231.664938]  [<ffffffffa00eb417>] __btrfs_free_extent+0x547/0x730 [btrfs]
[ 2231.665866]  [<ffffffffa00eb8b1>] run_delayed_data_ref+0x151/0x160 
[btrfs]
[ 2231.666799]  [<ffffffffa00eb972>] run_one_delayed_ref+0xb2/0xc0 [btrfs]
[ 2231.667731]  [<ffffffff8127b3d6>] ? __rb_erase_color+0x166/0x1d0
[ 2231.668692]  [<ffffffffa00eba93>] run_clustered_refs+0x113/0x3a0 [btrfs]
[ 2231.669625]  [<ffffffffa00ebe10>] btrfs_run_delayed_refs+0xf0/0x2f0 
[btrfs]
[ 2231.670563]  [<ffffffffa01075d2>] ? btrfs_orphan_cleanup+0x2a2/0x450 
[btrfs]
[ 2231.671498]  [<ffffffffa00fc0b3>] btrfs_commit_transaction+0xa3/0x9e0 
[btrfs]
[ 2231.672465]  [<ffffffff8106c440>] ? wake_up_bit+0x40/0x40
[ 2231.673399]  [<ffffffffa01247db>] create_subvol+0x4db/0x5e0 [btrfs]
[ 2231.674336]  [<ffffffffa00d4c01>] ? btrfs_set_path_blocking+0x31/0x70 
[btrfs]
[ 2231.675276]  [<ffffffff81055800>] ? inode_capable+0x10/0x20
[ 2231.676257]  [<ffffffffa0126c86>] btrfs_mksubvol+0x176/0x190 [btrfs]
[ 2231.677197]  [<ffffffffa0126dc2>] 
btrfs_ioctl_snap_create_transid+0x122/0x190 [btrfs]
[ 2231.678144]  [<ffffffffa0126e89>] btrfs_ioctl_snap_create+0x59/0x80 
[btrfs]
[ 2231.679080]  [<ffffffff81001772>] ? __switch_to+0x1a2/0x440
[ 2231.680036]  [<ffffffffa012a7b3>] btrfs_ioctl+0x7f3/0x890 [btrfs]
[ 2231.680970]  [<ffffffff814c629d>] ? __schedule+0x3dd/0x700
[ 2231.681896]  [<ffffffff8113bf4b>] do_vfs_ioctl+0x7b/0x380
[ 2231.682814]  [<ffffffff8113c29a>] sys_ioctl+0x4a/0x80
[ 2231.683741]  [<ffffffff814c7f79>] system_call_fastpath+0x16/0x1b
[ 2231.684696] ---[ end trace 2176d16bf8fdb18d ]---

Stefan
