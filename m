From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: bonnie triggers and endless numbers of stack traces
Date: Fri, 19 Aug 2011 18:45:00 +0200
Message-ID: <j2m3ud$u8e$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just for performance tests I run:

./bonnie++ -d /mnt/btrfs -s0 -n 1:256:256:1 -r 0

and this causes and endless number of stack traces. Those seem to 
come from:

use_block_rsv()

	ret = block_rsv_use_bytes(block_rsv, blocksize);
	if (!ret)
		return block_rsv;
	if (ret) {
		WARN_ON(1);
		ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,


Why is there a WARN_ON(1)? Running the bonnie benchmark is basically impossible
that.

Thanks,
Bernd


> Aug 19 18:30:56 fslab2 kernel: [  265.255644] Loglevel set to 9
> Aug 19 18:31:26 fslab2 kernel: [  295.490858] ------------[ cut here ]------------
> Aug 19 18:31:26 fslab2 kernel: [  295.495589] WARNING: at fs/btrfs/extent-tree.c:5711 btrfs_alloc_free_block+0x200/0x360 [btrfs]()
> Aug 19 18:31:26 fslab2 kernel: [  295.504472] Hardware name: H8DCE
> Aug 19 18:31:26 fslab2 kernel: [  295.507750] Modules linked in: nfsd ib_umad rdma_ucm rdma_cm iw_cm ib_addr ib_uverbs sg ib_ipoib ib_cm ib_sa ip
> v6 sd_mod crc_t10dif loop arcmsr md_mod ib_mthca ib_mad pcspkr ib_core 8250_pnp fuse af_packet nfs lockd fscache auth_rpcgss nfs_acl sunrpc btrfs
>  lzo_decompress lzo_compress zlib_deflate crc32c libcrc32c crypto_hash crypto_algapi ata_generic pata_acpi e1000 pata_amd sata_nv libata scsi_mod
>  unix [last unloaded: scsi_wait_scan]
> Aug 19 18:31:26 fslab2 kernel: [  295.548618] Pid: 2074, comm: bonnie++ Not tainted 3.1.0-rc2+ #34
> Aug 19 18:31:26 fslab2 kernel: [  295.554695] Call Trace:
> Aug 19 18:31:26 fslab2 kernel: [  295.557209]  [<ffffffff8105c677>] ? console_unlock+0x227/0x290
> Aug 19 18:31:26 fslab2 kernel: [  295.563111]  [<ffffffff8105bb7f>] warn_slowpath_common+0x7f/0xc0
> Aug 19 18:31:26 fslab2 kernel: [  295.569186]  [<ffffffff8105bbda>] warn_slowpath_null+0x1a/0x20
> Aug 19 18:31:26 fslab2 kernel: [  295.575096]  [<ffffffffa013d0d0>] btrfs_alloc_free_block+0x200/0x360 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.582230]  [<ffffffffa0165d10>] ? lock_delalloc_pages+0x1f0/0x1f0 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.589280]  [<ffffffffa0127b6b>] __btrfs_cow_block+0x14b/0x6e0 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.595978]  [<ffffffffa0179144>] ? btrfs_try_tree_write_lock+0x44/0x80 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.603394]  [<ffffffffa0128217>] btrfs_cow_block+0x117/0x260 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.609920]  [<ffffffffa012e455>] btrfs_search_slot+0x385/0xaa0 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.616621]  [<ffffffffa0140f3f>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.623236]  [<ffffffffa0190eb3>] btrfs_update_delayed_inode+0x73/0x160 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.630644]  [<ffffffff8137163e>] ? mutex_unlock+0xe/0x10
> Aug 19 18:31:26 fslab2 kernel: [  295.636125]  [<ffffffffa0192088>] btrfs_run_delayed_items+0xe8/0x120 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.643254]  [<ffffffffa014a240>] btrfs_commit_transaction+0x230/0x870 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.650585]  [<ffffffffa0149de9>] ? join_transaction+0x69/0x290 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.657274]  [<ffffffff8107f410>] ? wake_up_bit+0x40/0x40
> Aug 19 18:31:26 fslab2 kernel: [  295.662783]  [<ffffffff81171700>] ? __sync_filesystem+0x90/0x90
> Aug 19 18:31:26 fslab2 kernel: [  295.668783]  [<ffffffffa0124ace>] btrfs_sync_fs+0x5e/0xd0 [btrfs]
> Aug 19 18:31:26 fslab2 kernel: [  295.674951]  [<ffffffff811716ce>] __sync_filesystem+0x5e/0x90
> Aug 19 18:31:26 fslab2 kernel: [  295.680764]  [<ffffffff8117171f>] sync_one_sb+0x1f/0x30
> Aug 19 18:31:26 fslab2 kernel: [  295.686061]  [<ffffffff8114751f>] iterate_supers+0x7f/0xe0
> Aug 19 18:31:26 fslab2 kernel: [  295.691613]  [<ffffffff81171775>] sys_sync+0x45/0x70
> Aug 19 18:31:26 fslab2 kernel: [  295.696648]  [<ffffffff8137b4c2>] system_call_fastpath+0x16/0x1b
> Aug 19 18:31:26 fslab2 kernel: [  295.702726] ---[ end trace 5328a9730b4cdff4 ]---
> Aug 19 18:31:26 fslab2 kernel: [  295.707533] ------------[ cut here ]------------
> Aug 19 18:31:26 fslab2 kernel: [  295.712230] WARNING: at fs/btrfs/extent-tree.c:5711 btrfs_alloc_free_block+0x200/0x360 [btrfs]()
> Aug 19 18:31:26 fslab2 kernel: [  295.721114] Hardware name: H8DCE
> Aug 19 18:31:26 fslab2 kernel: [  295.724410] Modules linked in: nfsd ib_umad rdma_ucm rdma_cm iw_cm ib_addr ib_uverbs sg ib_ipoib ib_cm ib_sa ip
> v6 sd_mod crc_t10dif loop arcmsr md_mod ib_mthca ib_mad pcspkr ib_core 8250_pnp fuse af_packet nfs lockd fscache auth_rpcgss nfs_acl sunrpc btrfs
>  lzo_decompress lzo_compress zlib_deflate crc32c libcrc32c crypto_hash crypto_algapi ata_generic pata_acpi e1000 pata_amd sata_nv libata scsi_mod
[...]
repeats at least a few thousand times and fills the logs...



