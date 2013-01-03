Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:36579 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3ACSpK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 13:45:10 -0500
Message-ID: <50E5D19E.3060406@sandia.gov>
Date: Thu, 3 Jan 2013 11:44:46 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: "Josef Bacik" <jbacik@fusionio.com>
cc: "Liu Bo" <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
In-Reply-To: <20121218135242.GC2403@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Thanks for the patch - sorry for the long delay in testing...


On 12/18/2012 06:52 AM, Josef Bacik wrote:
> On Wed, Dec 12, 2012 at 06:52:37PM -0700, Liu Bo wrote:
>> An user reported that he has hit an annoying deadlock while playing with
>> ceph based on btrfs.
>>
>> Current updating device tree requires space from METADATA chunk,
>> so we -may- need to do a recursive chunk allocation when adding/updating
>> dev extent, that is where the deadlock comes from.
>>
>> If we use SYSTEM metadata to update device tree, we can avoid the recursive
>> stuff.
>>
> 
> This is going to cause us to allocate much more system chunks than we used to
> which could land us in trouble.  Instead let's just keep us from re-entering if
> we're already allocating a chunk.  We do the chunk allocation when we don't have
> enough space for a cluster, but we'll likely have plenty of space to make an
> allocation.  Can you give this patch a try Jim and see if it fixes your problem?
> Thanks,
> 
> Josef
> 

With your patch applied to 3.7.1, I get the following on one
of my servers running Ceph OSDs.  The end effect is that some
of my ceph client writes hang. 

[ 1440.335752] ------------[ cut here ]------------
[ 1440.340602] WARNING: at fs/btrfs/super.c:246 __btrfs_abort_transaction+0x60/0x110 [btrfs]()
[ 1440.349117] Hardware name: X8DTH-i/6/iF/6F
[ 1440.353252] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput sg joydev sd_mod iTCO_wdt iTCO_vendor_support hid_generic button ata_piix libata coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1440.419398] Pid: 48686, comm: ceph-osd Not tainted 3.7.1-00006-gc794580 #484
[ 1440.426614] Call Trace:
[ 1440.429083]  [<ffffffff8103fed4>] warn_slowpath_common+0x94/0xc0
[ 1440.435110]  [<ffffffff8103ffb6>] warn_slowpath_fmt+0x46/0x50
[ 1440.440894]  [<ffffffffa05425c0>] __btrfs_abort_transaction+0x60/0x110 [btrfs]
[ 1440.448135]  [<ffffffffa059513d>] __btrfs_alloc_chunk+0x6cd/0x750 [btrfs]
[ 1440.454941]  [<ffffffffa059521e>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[ 1440.461382]  [<ffffffffa05543a1>] ? check_system_chunk+0x71/0x130 [btrfs]
[ 1440.468188]  [<ffffffffa055474c>] do_chunk_alloc+0x2ec/0x370 [btrfs]
[ 1440.474562]  [<ffffffffa05509e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1440.482050]  [<ffffffffa055839c>] btrfs_check_data_free_space+0x13c/0x2b0 [btrfs]
[ 1440.489558]  [<ffffffffa0559f40>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
[ 1440.497013]  [<ffffffffa057e31e>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
[ 1440.504095]  [<ffffffffa057e849>] btrfs_file_aio_write+0x209/0x320 [btrfs]
[ 1440.511000]  [<ffffffffa057e640>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
[ 1440.518062]  [<ffffffff81164ef4>] do_sync_readv_writev+0x94/0xe0
[ 1440.524105]  [<ffffffff81165f03>] do_readv_writev+0xe3/0x1e0
[ 1440.529792]  [<ffffffff81182ff2>] ? fget_light+0x122/0x170
[ 1440.535275]  [<ffffffff81166046>] vfs_writev+0x46/0x60
[ 1440.540412]  [<ffffffff8116617f>] sys_writev+0x5f/0xc0
[ 1440.545547]  [<ffffffff81264b3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1440.551987]  [<ffffffff814b7102>] system_call_fastpath+0x16/0x1b
[ 1440.558016] ---[ end trace 764e83a458dabca6 ]---
[ 1440.562662] BTRFS warning (device dm-32): __btrfs_alloc_chunk:3488: Aborting unused transaction(error 28).
[ 1440.595987] BTRFS warning (device dm-32): find_free_extent:5871: Aborting unused transaction(Object already exists).
[ 1440.606542] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1440.614382] IP: [<ffffffffa0584e5e>] map_private_extent_buffer+0xe/0xf0 [btrfs]
[ 1440.621704] PGD 6138e8067 PUD 56749f067 PMD 0 
[ 1440.626190] Oops: 0000 [#1] SMP 
[ 1440.629442] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput sg joydev sd_mod iTCO_wdt iTCO_vendor_support hid_generic button ata_piix libata coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1440.694855] CPU 16 
[ 1440.696784] Pid: 48687, comm: ceph-osd Tainted: G        W    3.7.1-00006-gc794580 #484 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 1440.707803] RIP: 0010:[<ffffffffa0584e5e>]  [<ffffffffa0584e5e>] map_private_extent_buffer+0xe/0xf0 [btrfs]
[ 1440.717544] RSP: 0018:ffff880b740db9f8  EFLAGS: 00010292
[ 1440.722841] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880b740dba28
[ 1440.729947] RDX: 0000000000000004 RSI: 0000000000000076 RDI: 0000000000000000
[ 1440.737055] RBP: ffff880b740dba08 R08: ffff880b740dba20 R09: ffff880b740dba18
[ 1440.744167] R10: ffff88092bba8000 R11: ffff880a4138c320 R12: 0000000000000000
[ 1440.751280] R13: 0000000000000065 R14: 0000000000000011 R15: 0000000000000076
[ 1440.758395] FS:  00007fffeb4c3700(0000) GS:ffff880627d40000(0000) knlGS:0000000000000000
[ 1440.766460] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1440.772188] CR2: 0000000000000000 CR3: 00000004bd2a4000 CR4: 00000000000007e0
[ 1440.779303] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1440.786416] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1440.793523] Process ceph-osd (pid: 48687, threadinfo ffff880b740da000, task ffff8808f801bec0)
[ 1440.802018] Stack:
[ 1440.804030]  ffff880b740dbb98 0000000000000000 ffff880b740dba68 ffffffffa0581e3c
[ 1440.811464]  ffff880977dbd030 ffff880c00000002 ffff8808f801c5f0 0000000000000053
[ 1440.818897]  ffff880b740dbae4 ffff880612084c60 0000000000000000 ffff880612084c60
[ 1440.826330] Call Trace:
[ 1440.828800]  [<ffffffffa0581e3c>] btrfs_get_token_32+0x8c/0xf0 [btrfs]
[ 1440.835327]  [<ffffffffa056042d>] btrfs_match_dir_item_name+0x4d/0x140 [btrfs]
[ 1440.842545]  [<ffffffffa0560919>] insert_with_overflow+0x59/0x120 [btrfs]
[ 1440.849315]  [<ffffffffa0560ca6>] btrfs_insert_xattr_item+0xb6/0x1d0 [btrfs]
[ 1440.856343]  [<ffffffffa056d279>] ? join_transaction+0x29/0x370 [btrfs]
[ 1440.862945]  [<ffffffffa056d30f>] ? join_transaction+0xbf/0x370 [btrfs]
[ 1440.869536]  [<ffffffff81159ac3>] ? kmem_cache_alloc+0xd3/0x170
[ 1440.875450]  [<ffffffffa0582b3a>] do_setxattr+0x17a/0x240 [btrfs]
[ 1440.881534]  [<ffffffffa0582c8b>] __btrfs_setxattr+0x8b/0x110 [btrfs]
[ 1440.887965]  [<ffffffffa0582f27>] btrfs_setxattr+0xa7/0xc0 [btrfs]
[ 1440.894130]  [<ffffffff8118a19b>] __vfs_setxattr_noperm+0x7b/0x150
[ 1440.900287]  [<ffffffff8118a2fe>] vfs_setxattr+0x8e/0xc0
[ 1440.905591]  [<ffffffff8118a4e5>] setxattr+0x1b5/0x230
[ 1440.910713]  [<ffffffff81167347>] ? __sb_start_write+0x1b7/0x200
[ 1440.916702]  [<ffffffff81185378>] ? mnt_want_write_file+0x28/0x60
[ 1440.922778]  [<ffffffff81182f40>] ? fget_light+0x70/0x170
[ 1440.928168]  [<ffffffff81185378>] ? mnt_want_write_file+0x28/0x60
[ 1440.934242]  [<ffffffff81182ff2>] ? fget_light+0x122/0x170
[ 1440.939713]  [<ffffffff8118a5ec>] sys_fsetxattr+0x8c/0xe0
[ 1440.945097]  [<ffffffff814b7102>] system_call_fastpath+0x16/0x1b
[ 1440.951083] Code: ef 88 00 00 00 48 89 e5 e8 a0 ff ff ff c9 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 <4c> 8b 17 41 81 e2 ff 0f 00 00 4a 8d 04 16 4c 8d 5c 10 ff 48 89 
[ 1440.971006] RIP  [<ffffffffa0584e5e>] map_private_extent_buffer+0xe/0xf0 [btrfs]
[ 1440.978415]  RSP <ffff880b740db9f8>
[ 1440.981896] CR2: 0000000000000000
[ 1440.985557] ---[ end trace 764e83a458dabca7 ]---
[ 1440.990075] divide error: 0000 [#2] SMP 
[ 1440.990133] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput sg joydev sd_mod iTCO_wdt iTCO_vendor_support hid_generic button ata_piix libata coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1440.990139] CPU 20 
[ 1440.990139] Pid: 48693, comm: ceph-osd Tainted: G      D W    3.7.1-00006-gc794580 #484 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 1440.990163] RIP: 0010:[<ffffffffa059429d>]  [<ffffffffa059429d>] __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1440.990187] RSP: 0018:ffff880b740f5ad8  EFLAGS: 00010246
[ 1440.990194] RAX: 0000000000800000 RBX: 0000000000800000 RCX: 0000000040000000
[ 1440.990195] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1440.990195] RBP: ffff880b740f5b68 R08: 0000000000000000 R09: 0000000000000000
[ 1440.990196] R10: ffff88062311f6e8 R11: 0000000000000000 R12: ffff880b740f5b90
[ 1440.990200] R13: ffff8805054971c0 R14: ffff880c182f4298 R15: ffff880b740f5e68
[ 1440.990201] FS:  00007fffe6cba700(0000) GS:ffff880c3fd00000(0000) knlGS:0000000000000000
[ 1440.990202] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1440.990203] CR2: ffffffffff600400 CR3: 00000004bd2a4000 CR4: 00000000000007e0
[ 1440.990207] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1440.990207] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1440.990209] Process ceph-osd (pid: 48693, threadinfo ffff880b740f4000, task ffff8809877d8000)
[ 1440.990209] Stack:
[ 1440.990217]  ffff88092bba8000 ffff880156a22e00 ffff88062311f6e8 ffff880156a23388
[ 1440.990225]  0000000000000000 ffffffff8111365d 0000000000000000 0000000000000000
[ 1440.990230]  00000000740f5b98 0000000000000046 0000000000000000 ffffffff8111365d
[ 1440.990230] Call Trace:
[ 1440.990236]  [<ffffffff8111365d>] ? test_set_page_writeback+0x6d/0x170
[ 1440.990291]  [<ffffffff8111365d>] ? test_set_page_writeback+0x6d/0x170
[ 1440.990307]  [<ffffffffa059484e>] btrfs_map_block+0xe/0x10 [btrfs]
[ 1440.990349]  [<ffffffffa0571307>] btrfs_merge_bio_hook+0x57/0x80 [btrfs]
[ 1440.990458]  [<ffffffffa0585ba3>] submit_extent_page+0xc3/0x1d0 [btrfs]
[ 1440.990487]  [<ffffffff8110a2f0>] ? find_get_pages+0x1c0/0x1c0
[ 1440.990525]  [<ffffffffa058ba7f>] __extent_writepage+0x69f/0x760 [btrfs]
[ 1440.990571]  [<ffffffffa0585ed0>] ? extent_io_tree_init+0x90/0x90 [btrfs]
[ 1440.990680]  [<ffffffffa058bf52>] extent_write_cache_pages.clone.3+0x242/0x3d0 [btrfs]
[ 1440.990733]  [<ffffffffa058c12f>] extent_writepages+0x4f/0x70 [btrfs]
[ 1440.990784]  [<ffffffffa0577630>] ? btrfs_lookup+0x70/0x70 [btrfs]
[ 1440.990848]  [<ffffffff81182ff2>] ? fget_light+0x122/0x170
[ 1440.990870]  [<ffffffffa0571df7>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1440.990886]  [<ffffffff81115423>] do_writepages+0x23/0x40
[ 1440.990889]  [<ffffffff811099ce>] __filemap_fdatawrite_range+0x4e/0x50
[ 1440.990920]  [<ffffffff81109c83>] filemap_fdatawrite_range+0x13/0x20
[ 1440.990982]  [<ffffffff81195589>] sys_sync_file_range+0x109/0x170
[ 1440.991022]  [<ffffffff814b7102>] system_call_fastpath+0x16/0x1b
[ 1440.991149] Code: 66 0f 1f 44 00 00 4d 8b 6a 60 48 29 c3 8b 45 c4 41 39 45 18 b8 00 00 00 00 0f 4d 45 c4 31 d2 89 45 c4 49 63 75 10 48 89 d8 89 f7 <48> f7 f7 49 89 c6 48 89 45 c8 4c 0f af f6 4c 39 f3 73 10 0f 0b 
[ 1440.991174] RIP  [<ffffffffa059429d>] __btrfs_map_block+0xcd/0x670 [btrfs]
[ 1440.991203]  RSP <ffff880b740f5ad8>
[ 1440.991206] ---[ end trace 764e83a458dabca8 ]---
[ 1451.948155] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a9
[ 1451.956010] IP: [<ffffffffa05949d4>] btrfs_map_bio+0x184/0x220 [btrfs]
[ 1451.962580] PGD 0 
[ 1451.964620] Oops: 0000 [#3] SMP 
[ 1451.967887] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput sg joydev sd_mod iTCO_wdt iTCO_vendor_support hid_generic button ata_piix libata coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core ehci_hcd uhci_hcd ioatdma i7core_edac dm_mod edac_core nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 1452.033336] CPU 5 
[ 1452.035177] Pid: 25627, comm: btrfs-worker-1 Tainted: G      D W    3.7.1-00006-gc794580 #484 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 1452.046715] RIP: 0010:[<ffffffffa05949d4>]  [<ffffffffa05949d4>] btrfs_map_bio+0x184/0x220 [btrfs]
[ 1452.055688] RSP: 0018:ffff88050e967cc8  EFLAGS: 00010202
[ 1452.060987] RAX: 000000000000000c RBX: ffff880959c9ea80 RCX: ffff880959c9ea80
[ 1452.068100] RDX: ffff88060bd03060 RSI: 0000000000000001 RDI: ffff88062311f6e8
[ 1452.075212] RBP: ffff88050e967d28 R08: ffff88060bd03060 R09: 0000000000000009
[ 1452.082327] R10: ffff88062311f6e8 R11: 0000000000000000 R12: 0000000000000001
[ 1452.089442] R13: 0000000000000000 R14: 0000000000000004 R15: ffff88092bba8000
[ 1452.096554] FS:  0000000000000000(0000) GS:ffff880627ca0000(0000) knlGS:0000000000000000
[ 1452.104621] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1452.110352] CR2: 00000000000000a9 CR3: 0000000001a0b000 CR4: 00000000000007e0
[ 1452.117466] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1452.124577] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1452.131693] Process btrfs-worker-1 (pid: 25627, threadinfo ffff88050e966000, task ffff880612418000)
[ 1452.140707] Stack:
[ 1452.142720]  0000000000000000 000000000040e010 00000001182f5470 0000000100000000
[ 1452.150160]  ffff88060bd03060 000000003f7fe000 ffff88050e967d38 ffff880959c9e7c8
[ 1452.157601]  ffff880959c9e780 ffff880c182f5470 ffff880c182f5428 ffff880c182f5418
[ 1452.165061] Call Trace:
[ 1452.167540]  [<ffffffffa0570bab>] __btrfs_submit_bio_done+0x1b/0x20 [btrfs]
[ 1452.174501]  [<ffffffffa0566a41>] run_one_async_done+0xc1/0xd0 [btrfs]
[ 1452.181027]  [<ffffffffa0596a93>] run_ordered_completions+0x83/0xd0 [btrfs]
[ 1452.187991]  [<ffffffffa05975c8>] worker_loop+0x1b8/0x410 [btrfs]
[ 1452.194087]  [<ffffffffa0597410>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
[ 1452.201639]  [<ffffffff81066df1>] kthread+0xe1/0xf0
[ 1452.206528]  [<ffffffff81066d10>] ? __init_kthread_worker+0x70/0x70
[ 1452.212779]  [<ffffffff814b705c>] ret_from_fork+0x7c/0xb0
[ 1452.218167]  [<ffffffff81066d10>] ? __init_kthread_worker+0x70/0x70
[ 1452.224411] Code: 48 89 51 48 48 8d 14 40 48 8b 45 c0 48 c1 e2 03 48 01 d0 48 8b 40 38 48 c1 e8 09 48 89 01 48 03 55 c0 48 8b 72 30 48 85 f6 74 4c <48> 8b 86 a8 00 00 00 48 85 c0 74 40 41 83 fc 01 75 0a 8b 56 60 
[ 1452.244357] RIP  [<ffffffffa05949d4>] btrfs_map_bio+0x184/0x220 [btrfs]
[ 1452.250995]  RSP <ffff88050e967cc8>
[ 1452.254485] CR2: 00000000000000a9
[ 1452.258149] ---[ end trace 764e83a458dabca9 ]---


