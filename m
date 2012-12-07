Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:56404 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423740Ab2LGTEH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2012 14:04:07 -0500
Message-ID: <50C23D8F.7000008@sandia.gov>
Date: Fri, 7 Dec 2012 12:03:43 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: "Chris Mason" <chris.mason@fusionio.com>
cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: 3.7.0-rc8 btrfs locking issue
References: <50BF7129.90602@sandia.gov>
In-Reply-To: <50BF7129.90602@sandia.gov>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2012 09:07 AM, Jim Schutt wrote:
> Hi,
>
> I'm hitting a btrfs locking issue with 3.7.0-rc8.
>
> The btrfs filesystem in question is backing a Ceph OSD
> under a heavy write load from many cephfs clients.
>
> I reported this issue a while ago:
> http://www.spinics.net/lists/linux-btrfs/msg19370.html
> when I was testing what I thought might be part of the
> 3.7 btrfs patch queue, using Josef Bacik's btrfs-next tree.
>
> I spent some time attempting to bisect the btrfs patch queue
> just before it was merged for 3.7, but got nowhere due to
> false negatives.
>
> I've just been able to get back to testing 3.7-rc, and found
> that I can still trigger the issue.
>
> First I get this lockdep splat:
>
> [ 1184.201331] =============================================
> [ 1184.206716] [ INFO: possible recursive locking detected ]
> [ 1184.212111] 3.7.0-rc8-00013-gdf2fc24 #438 Not tainted
> [ 1184.217156] ---------------------------------------------
> [ 1184.222544] ceph-osd/42177 is trying to acquire lock:
> [ 1184.227589]  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.237270]
> [ 1184.237270] but task is already holding lock:
> [ 1184.243114]  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.252786]
> [ 1184.252786] other info that might help us debug this:
> [ 1184.259303]  Possible unsafe locking scenario:
> [ 1184.259303]
> [ 1184.265220]        CPU0
> [ 1184.267680]        ----
> [ 1184.270133]   lock(&fs_info->chunk_mutex);
> [ 1184.274276]   lock(&fs_info->chunk_mutex);
> [ 1184.278417]
> [ 1184.278417]  *** DEADLOCK ***

To try to debug this, I applied this patch:

-----cut here -----
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c72ead8..86da319 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1470,6 +1470,10 @@ struct btrfs_fs_info {
  	int backup_root_index;

  	int num_tolerated_disk_barrier_failures;
+
+	/* protect against recursive do_chunk_alloc() */
+	const void *chunk_alloc_task;
+	const struct btrfs_space_info *prev_sinfo;
  };

  /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cda519..d61e93d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2087,6 +2087,9 @@ int open_ctree(struct super_block *sb,

  	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
  	set_nlink(fs_info->btree_inode, 1);
+
+	fs_info->chunk_alloc_task = NULL;
+	fs_info->prev_sinfo = NULL;
  	/*
  	 * we set the i_size on the btree inode to the max possible int.
  	 * the real end of the address space is determined by all of
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..1e0e421 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3582,6 +3582,16 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
  	}
  	BUG_ON(!space_info); /* Logic error */

+	if (mutex_is_locked(&fs_info->chunk_mutex) &&
+	    unlikely(fs_info->chunk_alloc_task == current)) {
+		WARN_ONCE(1, "do_chunk_alloc() about to recursively acquire "
+			  "fs_info->chunk_mutex: impending deadlock avoided!\n"
+			  "outer call space_info = %p flags %#llx\n"
+			  "nested call space_info = %p flags %#llx\n",
+			  fs_info->prev_sinfo, fs_info->prev_sinfo->flags,
+			  space_info, space_info->flags);
+		return -EDEADLK;
+	}
  again:
  	spin_lock(&space_info->lock);
  	if (force < space_info->force_alloc)
@@ -3603,6 +3613,8 @@ again:
  	spin_unlock(&space_info->lock);

  	mutex_lock(&fs_info->chunk_mutex);
+	fs_info->chunk_alloc_task = current;
+	fs_info->prev_sinfo = space_info;

  	/*
  	 * The chunk_mutex is held throughout the entirety of a chunk
@@ -3655,6 +3667,8 @@ again:
  	space_info->chunk_alloc = 0;
  	spin_unlock(&space_info->lock);
  out:
+	fs_info->chunk_alloc_task = NULL;
+	fs_info->prev_sinfo = NULL;
  	mutex_unlock(&fs_info->chunk_mutex);
  	return ret;
  }
-----cut here -----

After a few trials, I got this during a test:

[ 1614.213516] ------------[ cut here ]------------
[ 1614.218185] WARNING: at fs/btrfs/extent-tree.c:3592 do_chunk_alloc+0xec/0x3f0 [btrfs]()
[ 1614.226228] Hardware name: X8DTH-i/6/iF/6F
[ 1614.230484] do_chunk_alloc() about to recursively acquire fs_info->chunk_mutex: impending deadlock avoided!
[ 1614.230484] outer call space_info = ffff880c214dac00 flags 0x1
[ 1614.230484] nested call space_info = ffff880c214dbc00 flags 0x4
[ 1614.251968] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput joydev sg hid_generic sd_mod iTCO_wdt iTCO_vendor_support ata_piix libata button coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1614.320138] Pid: 84332, comm: ceph-osd Not tainted 3.7.0-rc8-00031-g2ec1a5f #458
[ 1614.327564] Call Trace:
[ 1614.330054]  [<ffffffff8103ff04>] warn_slowpath_common+0x94/0xc0
[ 1614.336145]  [<ffffffff8103ffe6>] warn_slowpath_fmt+0x46/0x50
[ 1614.342081]  [<ffffffffa052053c>] do_chunk_alloc+0xec/0x3f0 [btrfs]
[ 1614.348431]  [<ffffffffa052966c>] find_free_extent+0xa3c/0xb70 [btrfs]
[ 1614.355013]  [<ffffffffa051c9e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1614.362580]  [<ffffffffa0529822>] btrfs_reserve_extent+0x82/0x190 [btrfs]
[ 1614.369404]  [<ffffffffa05299b5>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 1614.376417]  [<ffffffffa0515b6a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
[ 1614.383127]  [<ffffffffa056b2b3>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
[ 1614.390716]  [<ffffffffa051656d>] btrfs_cow_block+0x18d/0x230 [btrfs]
[ 1614.397288]  [<ffffffffa0519460>] btrfs_search_slot+0x360/0x730 [btrfs]
[ 1614.403988]  [<ffffffffa051a26d>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
[ 1614.411202]  [<ffffffff81157413>] ? kmem_cache_alloc+0xd3/0x170
[ 1614.417248]  [<ffffffffa055cfe5>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
[ 1614.424271]  [<ffffffffa0561197>] __btrfs_alloc_chunk+0x6a7/0x750 [btrfs]
[ 1614.431142]  [<ffffffffa056129e>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[ 1614.437625]  [<ffffffffa0520391>] ? check_system_chunk+0x71/0x130 [btrfs]
[ 1614.444468]  [<ffffffffa05207be>] do_chunk_alloc+0x36e/0x3f0 [btrfs]
[ 1614.450853]  [<ffffffffa051c9e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1614.458422]  [<ffffffffa052440c>] btrfs_check_data_free_space+0x13c/0x2b0 [btrfs]
[ 1614.466046]  [<ffffffffa0525fb0>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
[ 1614.473573]  [<ffffffffa054a39e>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
[ 1614.480691]  [<ffffffffa054a8c9>] btrfs_file_aio_write+0x209/0x320 [btrfs]
[ 1614.487642]  [<ffffffffa053a550>] ? btrfs_end_transaction+0x10/0x20 [btrfs]
[ 1614.494723]  [<ffffffffa054ed73>] ? __btrfs_setxattr+0xf3/0x110 [btrfs]
[ 1614.501398]  [<ffffffff814abf0e>] ? mutex_unlock+0xe/0x10
[ 1614.506918]  [<ffffffffa054a6c0>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
[ 1614.514098]  [<ffffffff81162754>] do_sync_readv_writev+0x94/0xe0
[ 1614.520240]  [<ffffffff81163813>] do_readv_writev+0xe3/0x1e0
[ 1614.526005]  [<ffffffff81180ca2>] ? fget_light+0x122/0x170
[ 1614.531537]  [<ffffffff81163956>] vfs_writev+0x46/0x60
[ 1614.536752]  [<ffffffff81163a8f>] sys_writev+0x5f/0xc0
[ 1614.542167]  [<ffffffff812637de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1614.548678]  [<ffffffff814b77c2>] system_call_fastpath+0x16/0x1b
[ 1614.554884] ---[ end trace 5c724b2e8e635fff ]---

So, evidently a do_chunk_alloc() call for BTRFS_BLOCK_GROUP_DATA ended
up needing more space for metadata, resulting in a recursive call to
do_chunk_alloc() for BTRFS_BLOCK_GROUP_METADATA.

Since the metadata allocation fails, I get some aborted transactions:

[ 1614.564332] WARNING: at fs/btrfs/super.c:246 __btrfs_abort_transaction+0x60/0x110 [btrfs]()
[ 1614.572784] Hardware name: X8DTH-i/6/iF/6F
[ 1614.577028] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput joydev sg hid_generic sd_mod iTCO_wdt iTCO_vendor_support ata_piix libata button coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1614.647280] Pid: 84332, comm: ceph-osd Tainted: G        W    3.7.0-rc8-00031-g2ec1a5f #458
[ 1614.655759] Call Trace:
[ 1614.658359]  [<ffffffff8103ff04>] warn_slowpath_common+0x94/0xc0
[ 1614.664505]  [<ffffffff8103ffe6>] warn_slowpath_fmt+0x46/0x50
[ 1614.670357]  [<ffffffffa050e5c0>] __btrfs_abort_transaction+0x60/0x110 [btrfs]
[ 1614.677681]  [<ffffffffa05296ad>] find_free_extent+0xa7d/0xb70 [btrfs]
[ 1614.684309]  [<ffffffffa051c9e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1614.691889]  [<ffffffffa0529822>] btrfs_reserve_extent+0x82/0x190 [btrfs]
[ 1614.698803]  [<ffffffffa05299b5>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 1614.705871]  [<ffffffffa0515b6a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
[ 1614.712666]  [<ffffffffa056b2b3>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
[ 1614.720393]  [<ffffffffa051656d>] btrfs_cow_block+0x18d/0x230 [btrfs]
[ 1614.727042]  [<ffffffffa0519460>] btrfs_search_slot+0x360/0x730 [btrfs]
[ 1614.733884]  [<ffffffffa051a26d>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
[ 1614.741202]  [<ffffffff81157413>] ? kmem_cache_alloc+0xd3/0x170
[ 1614.747361]  [<ffffffffa055cfe5>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
[ 1614.754573]  [<ffffffffa0561197>] __btrfs_alloc_chunk+0x6a7/0x750 [btrfs]
[ 1614.761638]  [<ffffffffa056129e>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[ 1614.768288]  [<ffffffffa0520391>] ? check_system_chunk+0x71/0x130 [btrfs]
[ 1614.775403]  [<ffffffffa05207be>] do_chunk_alloc+0x36e/0x3f0 [btrfs]
[ 1614.781998]  [<ffffffffa051c9e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1614.789694]  [<ffffffffa052440c>] btrfs_check_data_free_space+0x13c/0x2b0 [btrfs]
[ 1614.797419]  [<ffffffffa0525fb0>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
[ 1614.805054]  [<ffffffffa054a39e>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
[ 1614.812341]  [<ffffffffa054a8c9>] btrfs_file_aio_write+0x209/0x320 [btrfs]
[ 1614.819510]  [<ffffffffa053a550>] ? btrfs_end_transaction+0x10/0x20 [btrfs]
[ 1614.826800]  [<ffffffffa054ed73>] ? __btrfs_setxattr+0xf3/0x110 [btrfs]
[ 1614.833847]  [<ffffffff814abf0e>] ? mutex_unlock+0xe/0x10
[ 1614.839543]  [<ffffffffa054a6c0>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
[ 1614.847074]  [<ffffffff81162754>] do_sync_readv_writev+0x94/0xe0
[ 1614.853294]  [<ffffffff81163813>] do_readv_writev+0xe3/0x1e0
[ 1614.859233]  [<ffffffff81180ca2>] ? fget_light+0x122/0x170
[ 1614.865064]  [<ffffffff81163956>] vfs_writev+0x46/0x60
[ 1614.870338]  [<ffffffff81163a8f>] sys_writev+0x5f/0xc0
[ 1614.875708]  [<ffffffff812637de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1614.882356]  [<ffffffff814b77c2>] system_call_fastpath+0x16/0x1b
[ 1614.888536] ---[ end trace 5c724b2e8e636000 ]---
[ 1614.893309] BTRFS warning (device dm-64): find_free_extent:5878: Aborting unused transaction(error 35).
[ 1614.902879] BTRFS warning (device dm-64): __btrfs_alloc_chunk:3488: Aborting unused transaction(error 35).
[ 1614.912806] BTRFS warning (device dm-64): find_free_extent:5878: Aborting unused transaction(Object already exists).
[ 1614.916914] divide error: 0000 [#1] SMP
[ 1614.916955] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput joydev sg hid_generic sd_mod iTCO_wdt iTCO_vendor_support ata_piix libata button coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1614.916961] CPU 21
[ 1614.916961] Pid: 84341, comm: ceph-osd Tainted: G        W    3.7.0-rc8-00031-g2ec1a5f #458 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 1614.916985] RIP: 0010:[<ffffffffa056031d>]  [<ffffffffa056031d>] __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1614.916986] RSP: 0018:ffff8804dad7bad8  EFLAGS: 00010246
[ 1614.916987] RAX: 0000000002c00000 RBX: 0000000002c00000 RCX: 0000000040000000
[ 1614.916988] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1614.916989] RBP: ffff8804dad7bb68 R08: 0000000000000001 R09: 0000000000000000
[ 1614.916990] R10: ffff880c14f99990 R11: 0000000000000000 R12: ffff8804dad7bb90
[ 1614.916991] R13: ffff880b49e5c080 R14: ffff880c16324298 R15: ffff8804dad7be68
[ 1614.916992] FS:  00007fffe6cba700(0000) GS:ffff880c3fd20000(0000) knlGS:0000000000000000
[ 1614.916993] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1614.916994] CR2: ffffffffff600400 CR3: 00000009cb6ba000 CR4: 00000000000007e0
[ 1614.916995] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1614.916997] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1614.916998] Process ceph-osd (pid: 84341, threadinfo ffff8804dad7a000, task ffff8804dad5de20)
[ 1614.916999] Stack:
[ 1614.917004]  ffff8804dad5e4d8 000000ec54c11738 ffff880c14f99990 ffff880754c11cc0
[ 1614.917008]  0000000000000000 ffffffff81110eed 0000000000000000 0000000000000000
[ 1614.917011]  00000000dad7bb98 0000000000000046 0000000000000000 ffffffff81110eed
[ 1614.917011] Call Trace:
[ 1614.917019]  [<ffffffff81110eed>] ? test_set_page_writeback+0x6d/0x170
[ 1614.917021]  [<ffffffff81110eed>] ? test_set_page_writeback+0x6d/0x170
[ 1614.917032]  [<ffffffffa05608ce>] btrfs_map_block+0xe/0x10 [btrfs]
[ 1614.917042]  [<ffffffffa053d387>] btrfs_merge_bio_hook+0x57/0x80 [btrfs]
[ 1614.917052]  [<ffffffffa0551c23>] submit_extent_page+0xc3/0x1d0 [btrfs]
[ 1614.917054]  [<ffffffff81107960>] ? find_get_pages_tag+0x1e0/0x1e0
[ 1614.917068]  [<ffffffffa0557aff>] __extent_writepage+0x69f/0x760 [btrfs]
[ 1614.917081]  [<ffffffffa0551f50>] ? extent_io_tree_init+0x90/0x90 [btrfs]
[ 1614.917091]  [<ffffffffa0557fd2>] extent_write_cache_pages.clone.3+0x242/0x3d0 [btrfs]
[ 1614.917102]  [<ffffffffa05581af>] extent_writepages+0x4f/0x70 [btrfs]
[ 1614.917112]  [<ffffffffa05436b0>] ? btrfs_lookup+0x70/0x70 [btrfs]
[ 1614.917116]  [<ffffffff81180ca2>] ? fget_light+0x122/0x170
[ 1614.917127]  [<ffffffffa053de77>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1614.917130]  [<ffffffff81112cb3>] do_writepages+0x23/0x40
[ 1614.917134]  [<ffffffff8110702e>] __filemap_fdatawrite_range+0x4e/0x50
[ 1614.917137]  [<ffffffff811072e3>] filemap_fdatawrite_range+0x13/0x20
[ 1614.917143]  [<ffffffff81193399>] sys_sync_file_range+0x109/0x170
[ 1614.917148]  [<ffffffff814b77c2>] system_call_fastpath+0x16/0x1b
[ 1614.917167] Code: 66 0f 1f 44 00 00 4d 8b 6a 60 48 29 c3 8b 45 c4 41 39 45 18 b8 00 00 00 00 0f 4d 45 c4 31 d2 89 45 c4 49 63 75 10 48 89 d8 89 f7 <48> f7 f7 49 89 c6 48 89 45 c8 4c 0f af f6 4c 39 f3 73 10 0f 0b
[ 1614.917178] RIP  [<ffffffffa056031d>] __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1614.917179]  RSP <ffff8804dad7bad8>
[ 1614.917687] ---[ end trace 5c724b2e8e636001 ]---

But from there, things go downhill:

[ 1615.971959] divide error: 0000 [#2] SMP
[ 1615.975920] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput joydev sg hid_generic sd_mod iTCO_wdt iTCO_vendor_support ata_piix libata button coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1616.041983] CPU 10
[ 1616.043917] Pid: 33589, comm: kworker/10:0 Tainted: G      D W    3.7.0-rc8-00031-g2ec1a5f #458 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 1616.055643] RIP: 0010:[<ffffffffa056031d>]  [<ffffffffa056031d>] __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1616.064894] RSP: 0018:ffff880c1704f778  EFLAGS: 00010246
[ 1616.070198] RAX: 0000000003000000 RBX: 0000000003000000 RCX: 0000000040000000
[ 1616.077312] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1616.084434] RBP: ffff880c1704f808 R08: 0000000000000000 R09: 0000000000000000
[ 1616.091556] R10: ffff880c14f99990 R11: 0000000000000000 R12: ffff880c1704f830
[ 1616.098669] R13: ffff880b49e5c080 R14: ffff880c16324298 R15: ffff880c1704fb08
[ 1616.105783] FS:  0000000000000000(0000) GS:ffff880c3fc80000(0000) knlGS:0000000000000000
[ 1616.113855] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1616.119603] CR2: 00007ffff7ddc020 CR3: 00000009cb6ba000 CR4: 00000000000007e0
[ 1616.126719] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1616.133839] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1616.140951] Process kworker/10:0 (pid: 33589, threadinfo ffff880c1704e000, task ffff880c19d48000)
[ 1616.149795] Stack:
[ 1616.151808]  ffff8804f8b71000 ffff880754c44c60 ffff880c14f99990 ffff880754c451e8
[ 1616.159280]  0000000000000000 ffffffff81110eed 0000000000000000 0000000000000000
[ 1616.166749]  000000001704f838 0000000000000046 0000000000000000 ffffffff81110eed
[ 1616.174217] Call Trace:
[ 1616.176679]  [<ffffffff81110eed>] ? test_set_page_writeback+0x6d/0x170
[ 1616.183199]  [<ffffffff81110eed>] ? test_set_page_writeback+0x6d/0x170
[ 1616.189745]  [<ffffffffa05608ce>] btrfs_map_block+0xe/0x10 [btrfs]
[ 1616.195935]  [<ffffffffa053d387>] btrfs_merge_bio_hook+0x57/0x80 [btrfs]
[ 1616.202651]  [<ffffffffa0551c23>] submit_extent_page+0xc3/0x1d0 [btrfs]
[ 1616.209257]  [<ffffffff81107960>] ? find_get_pages_tag+0x1e0/0x1e0
[ 1616.215447]  [<ffffffffa0557aff>] __extent_writepage+0x69f/0x760 [btrfs]
[ 1616.222158]  [<ffffffffa0551f50>] ? extent_io_tree_init+0x90/0x90 [btrfs]
[ 1616.228953]  [<ffffffffa0557fd2>] extent_write_cache_pages.clone.3+0x242/0x3d0 [btrfs]
[ 1616.236875]  [<ffffffffa05581af>] extent_writepages+0x4f/0x70 [btrfs]
[ 1616.243325]  [<ffffffffa05436b0>] ? btrfs_lookup+0x70/0x70 [btrfs]
[ 1616.249499]  [<ffffffff8117c660>] ? igrab+0x40/0x70
[ 1616.254393]  [<ffffffffa053de77>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1616.260735]  [<ffffffff81112cb3>] do_writepages+0x23/0x40
[ 1616.266127]  [<ffffffff8110702e>] __filemap_fdatawrite_range+0x4e/0x50
[ 1616.272674]  [<ffffffff814aebbb>] ? _raw_spin_unlock+0x2b/0x50
[ 1616.278499]  [<ffffffff8110724c>] filemap_flush+0x1c/0x20
[ 1616.283905]  [<ffffffffa053be64>] btrfs_start_delalloc_inodes+0xd4/0x240 [btrfs]
[ 1616.291301]  [<ffffffffa0539a95>] btrfs_commit_transaction+0x2c5/0xa10 [btrfs]
[ 1616.298521]  [<ffffffffa053a560>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 1616.305479]  [<ffffffff81067c70>] ? wake_up_bit+0x40/0x40
[ 1616.310888]  [<ffffffffa053a5d6>] do_async_commit+0x76/0x90 [btrfs]
[ 1616.317168]  [<ffffffffa053a560>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 1616.324117]  [<ffffffff8105fd33>] process_one_work+0x2d3/0x4b0
[ 1616.329947]  [<ffffffff8105fc98>] ? process_one_work+0x238/0x4b0
[ 1616.335980]  [<ffffffffa053a560>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 1616.342937]  [<ffffffff8106219a>] worker_thread+0x20a/0x330
[ 1616.348512]  [<ffffffff81061f90>] ? manage_workers+0x170/0x170
[ 1616.354340]  [<ffffffff81067561>] kthread+0xe1/0xf0
[ 1616.359228]  [<ffffffff81067480>] ? __init_kthread_worker+0x70/0x70
[ 1616.365496]  [<ffffffff814b771c>] ret_from_fork+0x7c/0xb0
[ 1616.370905]  [<ffffffff81067480>] ? __init_kthread_worker+0x70/0x70
[ 1616.377155] Code: 66 0f 1f 44 00 00 4d 8b 6a 60 48 29 c3 8b 45 c4 41 39 45 18 b8 00 00 00 00 0f 4d 45 c4 31 d2 89 45 c4 49 63 75 10 48 89 d8 89 f7 <48> f7 f7 49 89 c6 48 89 45 c8 4c 0f af f6 4c 39 f3 73 10 0f 0b
[ 1616.397533] RIP  [<ffffffffa056031d>] __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1616.404461]  RSP <ffff880c1704f778>
[ 1616.410313] ---[ end trace 5c724b2e8e636002 ]---
[ 1616.419293] BUG: unable to handle kernel paging request at ffffffffffffffa8
[ 1616.426291] IP: [<ffffffff81066be0>] kthread_data+0x10/0x20
[ 1616.431886] PGD 1a0d067 PUD 1a0e067 PMD 0
[ 1616.436059] Oops: 0000 [#3] SMP
[ 1616.439335] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput joydev sg hid_generic sd_mod iTCO_wdt iTCO_vendor_support ata_piix libata button coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1616.504982] CPU 10
[ 1616.506911] Pid: 33589, comm: kworker/10:0 Tainted: G      D W    3.7.0-rc8-00031-g2ec1a5f #458 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 1616.518630] RIP: 0010:[<ffffffff81066be0>]  [<ffffffff81066be0>] kthread_data+0x10/0x20
[ 1616.526632] RSP: 0018:ffff880c1704f448  EFLAGS: 00010082
[ 1616.531930] RAX: 0000000000000000 RBX: ffff880c3fc932c0 RCX: 000000000000000a
[ 1616.539045] RDX: ffffffff81ccaa20 RSI: 000000000000000a RDI: ffff880c19d48000
[ 1616.546161] RBP: ffff880c1704f448 R08: ffff880c19d48070 R09: 0000000000000001
[ 1616.553271] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000000a
[ 1616.560385] R13: 000000000000000a R14: 0000000000000001 R15: 0000000000000000
[ 1616.567498] FS:  0000000000000000(0000) GS:ffff880c3fc80000(0000) knlGS:0000000000000000
[ 1616.575562] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1616.581284] CR2: ffffffffffffffa8 CR3: 0000000b7429b000 CR4: 00000000000007e0
[ 1616.588390] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1616.595502] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1616.602609] Process kworker/10:0 (pid: 33589, threadinfo ffff880c1704e000, task ffff880c19d48000)
[ 1616.611451] Stack:
[ 1616.613464]  ffff880c1704f478 ffffffff8105f861 000000000000000a ffff880c3fc932c0
[ 1616.620896]  000000000000000a ffff880c19d483c0 ffff880c1704f508 ffffffff814acb4e
[ 1616.628329]  0000000000000018 ffff880c1704ffd8 ffff880c1704e010 ffff880c1704e000
[ 1616.635765] Call Trace:
[ 1616.638217]  [<ffffffff8105f861>] wq_worker_sleeping+0x21/0xa0
[ 1616.644031]  [<ffffffff814acb4e>] __schedule+0x17e/0x690
[ 1616.649327]  [<ffffffff814ad3dd>] schedule+0x5d/0x60
[ 1616.654281]  [<ffffffff810456c3>] do_exit+0x3e3/0x430
[ 1616.659320]  [<ffffffff814afe68>] oops_end+0xd8/0xf0
[ 1616.664273]  [<ffffffff8100593a>] die+0x6a/0x80
[ 1616.668792]  [<ffffffff814af7be>] do_trap+0x7e/0x170
[ 1616.673747]  [<ffffffff81002f45>] do_divide_error+0x95/0xa0
[ 1616.679321]  [<ffffffffa056031d>] ? __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1616.686003]  [<ffffffff8126381d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1616.692510]  [<ffffffff814af08c>] ? restore_args+0x30/0x30
[ 1616.697983]  [<ffffffff814b8758>] divide_error+0x18/0x20
[ 1616.703292]  [<ffffffffa056031d>] ? __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1616.709981]  [<ffffffffa05602a1>] ? __btrfs_map_block+0x51/0x670 [btrfs]
[ 1616.716663]  [<ffffffff81110eed>] ? test_set_page_writeback+0x6d/0x170
[ 1616.723169]  [<ffffffff81110eed>] ? test_set_page_writeback+0x6d/0x170
[ 1616.729688]  [<ffffffffa05608ce>] btrfs_map_block+0xe/0x10 [btrfs]
[ 1616.735859]  [<ffffffffa053d387>] btrfs_merge_bio_hook+0x57/0x80 [btrfs]
[ 1616.742551]  [<ffffffffa0551c23>] submit_extent_page+0xc3/0x1d0 [btrfs]
[ 1616.749144]  [<ffffffff81107960>] ? find_get_pages_tag+0x1e0/0x1e0
[ 1616.755316]  [<ffffffffa0557aff>] __extent_writepage+0x69f/0x760 [btrfs]
[ 1616.762008]  [<ffffffffa0551f50>] ? extent_io_tree_init+0x90/0x90 [btrfs]
[ 1616.768784]  [<ffffffffa0557fd2>] extent_write_cache_pages.clone.3+0x242/0x3d0 [btrfs]
[ 1616.776686]  [<ffffffffa05581af>] extent_writepages+0x4f/0x70 [btrfs]
[ 1616.783114]  [<ffffffffa05436b0>] ? btrfs_lookup+0x70/0x70 [btrfs]
[ 1616.789276]  [<ffffffff8117c660>] ? igrab+0x40/0x70
[ 1616.794151]  [<ffffffffa053de77>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1616.800486]  [<ffffffff81112cb3>] do_writepages+0x23/0x40
[ 1616.805872]  [<ffffffff8110702e>] __filemap_fdatawrite_range+0x4e/0x50
[ 1616.812380]  [<ffffffff814aebbb>] ? _raw_spin_unlock+0x2b/0x50
[ 1616.818196]  [<ffffffff8110724c>] filemap_flush+0x1c/0x20
[ 1616.823591]  [<ffffffffa053be64>] btrfs_start_delalloc_inodes+0xd4/0x240 [btrfs]
[ 1616.830974]  [<ffffffffa0539a95>] btrfs_commit_transaction+0x2c5/0xa10 [btrfs]
[ 1616.838182]  [<ffffffffa053a560>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 1616.845121]  [<ffffffff81067c70>] ? wake_up_bit+0x40/0x40
[ 1616.850517]  [<ffffffffa053a5d6>] do_async_commit+0x76/0x90 [btrfs]
[ 1616.856774]  [<ffffffffa053a560>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 1616.863712]  [<ffffffff8105fd33>] process_one_work+0x2d3/0x4b0
[ 1616.869530]  [<ffffffff8105fc98>] ? process_one_work+0x238/0x4b0
[ 1616.875531]  [<ffffffffa053a560>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 1616.882469]  [<ffffffff8106219a>] worker_thread+0x20a/0x330
[ 1616.888028]  [<ffffffff81061f90>] ? manage_workers+0x170/0x170
[ 1616.893844]  [<ffffffff81067561>] kthread+0xe1/0xf0
[ 1616.898711]  [<ffffffff81067480>] ? __init_kthread_worker+0x70/0x70
[ 1616.904960]  [<ffffffff814b771c>] ret_from_fork+0x7c/0xb0
[ 1616.910345]  [<ffffffff81067480>] ? __init_kthread_worker+0x70/0x70
[ 1616.916593] Code: 68 03 00 00 48 8b 40 98 c9 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 87 68 03 00 00 <48> 8b 40 a8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
[ 1616.936489] RIP  [<ffffffff81066be0>] kthread_data+0x10/0x20
[ 1616.942150]  RSP <ffff880c1704f448>
[ 1616.945626] CR2: ffffffffffffffa8
[ 1616.948930] ---[ end trace 5c724b2e8e636003 ]---
[ 1616.953536] Fixing recursive fault but reboot is needed!


Is there some way to avoid this do_chunk_alloc() deadlock by learning
before a call to do_chunk_alloc() for more data space that more metadata
space will be needed, and doing that call first?

Or, is there some other way to fix this problem?

Thanks -- Jim

