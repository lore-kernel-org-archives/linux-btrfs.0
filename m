Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:49281 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2GGMXG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Jul 2012 08:23:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by seven.medozas.de (Postfix) with ESMTP id D1AF196A07E5
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Jul 2012 14:23:01 +0200 (CEST)
Date: Sat, 7 Jul 2012 14:23:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: linux-btrfs@vger.kernel.org
Subject: block rsv returned -28
Message-ID: <alpine.LNX.2.01.1207071357370.3391@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


- RAID10 btrfs volume consisting of 4 disks.
- One disk failed, was replaced, resync started
	(`btrfs dev add /dev/sdf /srv; btrfs dev del missing /srv`)
- Another disk failed before resync was done.
  Disk was replaced, resync restarted.
        (`btrfs dev add /dev/sdc /srv; btrfs dev del missing /srv`)

Naturally I don't expect it to recover from 2 failures, but
doing the attempt was worth a try, for this throws kernel warnings 
(below).

Can I somehow just have all inodes unlinked from the filesystem that are 
not recoverable? That would be preferable to re-mkfs.

The current status per fi show:
Label: 'srv'  uuid: 88300cd5-dbcb-4147-9ee4-c65a1c895e1d
        Total devices 6 FS bytes used 1.71TiB
        devid    7 size 1.36TiB used 29.50GiB path /dev/sdc
        devid    2 size 1.36TiB used 1.13TiB path /dev/sdd
        devid    3 size 1.36TiB used 1.13TiB path /dev/sde
        devid    6 size 1.36TiB used 377.00GiB path /dev/sdf
        *** Some devices missing


[ 1013.381148] btrfs: found 5451 extents
[ 1105.177601] btrfs: block rsv returned -28
[ 1105.177608] ------------[ cut here ]------------
[ 1105.177684] WARNING: at /home/abuild/rpmbuild/BUILD/kernel-default-3.4.4~jng6/linux-3.4/fs/btrfs/extent-tree.c:6219 use_block_rsv+0xb8/0x104 [btrfs]()
[ 1105.177692] Hardware name: RX945GC
[ 1105.177696] Modules linked in: f71882fg nfs fscache nfsd lockd nfs_acl auth_rpcgss sunrpc bonding mperf btrfs zlib_deflate crc32c libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer i915 snd drm_kms_helper drm coretemp sg intel_agp led_class soundcore snd_page_alloc r8169 iTCO_wdt iTCO_vendor_support microcode i2c_i801 i2c_algo_bit intel_gtt agpgart i2c_core button pcspkr mii rng_core video edd autofs4 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid0 raid1 md_mod ata_piix uhci_hcd ehci_hcd usbcore usb_common processor thermal_sys hwmon
[ 1105.177810] Pid: 2912, comm: btrfs Not tainted 3.4.4-jng6-default #1
[ 1105.177815] Call Trace:
[ 1105.177842]  [<ffffffff81003b0e>] dump_trace+0x89/0x1e9
[ 1105.177858]  [<ffffffff813bdd45>] dump_stack+0x69/0x6f
[ 1105.177871]  [<ffffffff8102d9d4>] warn_slowpath_common+0x78/0x8c
[ 1105.177937]  [<ffffffffa02fcaf6>] use_block_rsv+0xb8/0x104 [btrfs]
[ 1105.178092]  [<ffffffffa02fef88>] btrfs_alloc_free_block+0x29/0x1bd [btrfs]
[ 1105.178236]  [<ffffffffa02f17fe>] __btrfs_cow_block+0x10e/0x350 [btrfs]
[ 1105.178338]  [<ffffffffa02f1b34>] btrfs_cow_block+0xf4/0x13f [btrfs]
[ 1105.178441]  [<ffffffffa02f4753>] btrfs_search_slot+0x230/0x531 [btrfs]
[ 1105.178581]  [<ffffffffa0342990>] do_relocation+0x104/0x3fe [btrfs]
[ 1105.179050]  [<ffffffffa0342d29>] finish_pending_nodes+0x9f/0x103 [btrfs]
[ 1105.179518]  [<ffffffffa03456b5>] relocate_tree_blocks+0x124/0x14a [btrfs]
[ 1105.179994]  [<ffffffffa034624e>] relocate_block_group+0x21a/0x439 [btrfs]
[ 1105.180774]  [<ffffffffa03465ac>] btrfs_relocate_block_group+0x13f/0x267 [btrfs]
[ 1105.181471]  [<ffffffffa032b849>] btrfs_relocate_chunk.isra.51+0x4b/0x2ce [btrfs]
[ 1105.182037]  [<ffffffffa032e532>] btrfs_shrink_device+0x1fa/0x34d [btrfs]
[ 1105.182623]  [<ffffffffa033011f>] btrfs_rm_device+0x1f4/0x4a6 [btrfs]
[ 1105.183206]  [<ffffffffa0331ad2>] btrfs_ioctl_rm_dev+0x95/0xbe [btrfs]
[ 1105.183797]  [<ffffffffa0335632>] btrfs_ioctl+0x3b4/0x6d6 [btrfs]
[ 1105.184369]  [<ffffffff8110f9af>] do_vfs_ioctl+0x240/0x254
[ 1105.184390]  [<ffffffff8110fa0e>] sys_ioctl+0x4b/0x71
[ 1105.184412]  [<ffffffff813d8b79>] system_call_fastpath+0x16/0x1b
[ 1105.184455]  [<00007fb47191a837>] 0x7fb47191a836
[ 1105.184464] ---[ end trace 7a7259f915d317e1 ]---
 (many of these as it attempted to resync/rebalance)
