Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:46466 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750857AbcHKBvT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 21:51:19 -0400
To: Chris Murphy <lists@colorremedies.com>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
 <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
 <CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com>
 <34532105-4411-2a21-a83d-e48f4311400a@techsquare.com>
 <CAJCQCtRJhvwS2w1iRTxZbQ0tyfDH6Ser1=DBH6w+2Rq4pguf2A@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <4312553d-5187-8160-bb45-643d59442ae8@techsquare.com>
Date: Wed, 10 Aug 2016 21:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRJhvwS2w1iRTxZbQ0tyfDH6Ser1=DBH6w+2Rq4pguf2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This block device is a volume which is on hardware RAID.  We have a few 
machines like this running without issue.  Something odd hit this one.

# free -m
              total       used       free     shared    buffers     cached
Mem:         32143       1258      30885          1         52        973
-/+ buffers/cache:        232      31910
Swap:        32733          0      32733

I'll gather up some more logs, in the meantime it crashed again:

[81348.134017] ------------[ cut here ]------------
[81348.138635] kernel BUG at fs/btrfs/ctree.c:3187!
[81348.143253] invalid opcode: 0000 [#1] SMP
[81348.147267] Modules linked in: ipt_REJECT nf_reject_ipv4 xt_tcpudp 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
iptable_filter ip_tables x_tables ipmi_devintf sb_edac edac_core 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel btrfs kvm 
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel 
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd dm_multipath 
joydev lpc_ich mei_me mei wmi ipmi_si ipmi_msghandler nfsd auth_rpcgss 
nfs_acl nfs lockd grace ioatdma sunrpc shpchp mac_hid fscache lp parport 
ses enclosure scsi_transport_sas raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c 
hid_generic igb raid1 usbhid i2c_algo_bit ahci raid0 dca multipath ptp 
hid megaraid_sas libahci linear pps_core dm_mirror dm_region_hash dm_log
[81348.219932] CPU: 3 PID: 9218 Comm: nfsd Tainted: G        W 
4.7.0-custom #1
[81348.227409] Hardware name: Supermicro 
X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
[81348.236441] task: ffff88046bd28e40 ti: ffff880248b6c000 task.ti: 
ffff880248b6c000
[81348.243921] RIP: 0010:[<ffffffffc06906c4>]  [<ffffffffc06906c4>] 
btrfs_set_item_key_safe+0x154/0x160 [btrfs]
[81348.253799] RSP: 0018:ffff880248b6f578  EFLAGS: 00010246
[81348.259110] RAX: 0000000000000000 RBX: 0000000000000017 RCX: 
000000000000d000
[81348.266233] RDX: 0000000000000000 RSI: ffff880248b6f67e RDI: 
ffff880248b6f597
[81348.273357] RBP: ffff880248b6f5d0 R08: 0000000000004000 R09: 
ffff880248b6f598
[81348.280479] R10: 0000000000000000 R11: 0000000000000003 R12: 
ffff880248b6f586
[81348.287604] R13: ffff8800394c9770 R14: ffff880248b6f67e R15: 
ffff8802b8bb4f50
[81348.294729] FS:  0000000000000000(0000) GS:ffff88046fd80000(0000) 
knlGS:0000000000000000
[81348.302813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[81348.308550] CR2: 00007fa0c244a000 CR3: 0000000001c06000 CR4: 
00000000001406e0
[81348.315674] Stack:
[81348.317687]  ffff88046b402000 335effffc06d30b9 006c0000000001ea 
5e000000000000d0
[81348.325145]  6c0000000001ea33 000000000000d000 ffff8800394c9770 
0000000000003a6b
[81348.332598]  0000000000000000 000000000000e000 ffff8802b8bb4f50 
ffff880248b6f6e0
[81348.340051] Call Trace:
[81348.342517]  [<ffffffffc06ce023>] __btrfs_drop_extents+0x503/0xd30 
[btrfs]
[81348.349403]  [<ffffffffc06d1200>] ? free_extent_map+0x40/0xa0 [btrfs]
[81348.355850]  [<ffffffffc07347fb>] 
btrfs_log_changed_extents+0x2cc/0x5b1 [btrfs]
[81348.363163]  [<ffffffffc0736583>] btrfs_log_inode+0xce4/0xe99 [btrfs]
[81348.369612]  [<ffffffffc06da690>] ? 
extent_write_cache_pages.isra.37.constprop.60+0x3a0/0x450 [btrfs]
[81348.378821]  [<ffffffff810af555>] ? put_prev_entity+0x35/0x730
[81348.384653]  [<ffffffff8102b6ff>] ? __switch_to+0x24f/0x590
[81348.390237]  [<ffffffffc06faf37>] btrfs_log_inode_parent+0x227/0x970 
[btrfs]
[81348.397290]  [<ffffffffc06b6c62>] ? 
wait_current_trans.isra.24+0x22/0x110 [btrfs]
[81348.404764]  [<ffffffff811dc5d6>] ? kmem_cache_alloc+0x1d6/0x1f0
[81348.410782]  [<ffffffffc06b93bf>] ? start_transaction+0x12f/0x4d0 [btrfs]
[81348.417579]  [<ffffffffc06fc542>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
[81348.424372]  [<ffffffffc06d05b3>] btrfs_sync_file+0x283/0x3b0 [btrfs]
[81348.430809]  [<ffffffff8123236d>] vfs_fsync_range+0x3d/0xb0
[81348.436390]  [<ffffffffc06d0aca>] btrfs_file_write_iter+0x3ea/0x4c0 
[btrfs]
[81348.443348]  [<ffffffff811ffa6a>] do_iter_readv_writev+0x9a/0xf0
[81348.449351]  [<ffffffff81200438>] do_readv_writev+0x178/0x210
[81348.455107]  [<ffffffffc06d06e0>] ? btrfs_sync_file+0x3b0/0x3b0 [btrfs]
[81348.461718]  [<ffffffff811fd623>] ? do_dentry_open+0x273/0x320
[81348.467550]  [<ffffffff811fcd60>] ? finish_no_open+0x20/0x20
[81348.473208]  [<ffffffff811fe8d5>] ? vfs_open+0x55/0x80
[81348.478347]  [<ffffffff812006ec>] vfs_writev+0x3c/0x50
[81348.483488]  [<ffffffffc032ce3e>] nfsd_vfs_write+0xbe/0x330 [nfsd]
[81348.489672]  [<ffffffffc032f5b0>] nfsd_write+0x120/0x2f0 [nfsd]
[81348.495591]  [<ffffffffc0335571>] nfsd3_proc_write+0xb1/0x130 [nfsd]
[81348.501942]  [<ffffffffc0328278>] nfsd_dispatch+0xb8/0x1f0 [nfsd]
[81348.508047]  [<ffffffffc01db25c>] svc_process_common+0x40c/0x6a0 [sunrpc]
[81348.514842]  [<ffffffffc01dc655>] svc_process+0x105/0x1c0 [sunrpc]
[81348.521023]  [<ffffffffc0327cd0>] nfsd+0xf0/0x160 [nfsd]
[81348.526337]  [<ffffffffc0327be0>] ? nfsd_destroy+0x60/0x60 [nfsd]
[81348.532426]  [<ffffffff81099109>] kthread+0xc9/0xe0
[81348.537306]  [<ffffffff817db85f>] ret_from_fork+0x1f/0x40
[81348.542702]  [<ffffffff81099040>] ? kthread_park+0x60/0x60
[81348.548188] Code: 48 8b 45 bf 48 8d 7d c7 4c 89 f6 48 89 45 d0 0f b6 
45 be 88 45 cf 48 8b 45 b6 48 89 45 c7 e8 74 f3 ff ff 85 c0 0f 8f 55 ff 
ff ff <0f> 0b 0f 0b 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 b8 00
[81348.568144] RIP  [<ffffffffc06906c4>] 
btrfs_set_item_key_safe+0x154/0x160 [btrfs]
[81348.575649]  RSP <ffff880248b6f578>
[81348.625322] ---[ end trace 336c80ba4db66e7a ]---


Mounting will crash again with this error:

[   79.921962] ------------[ cut here ]------------
[   79.922000] WARNING: CPU: 6 PID: 2632 at fs/btrfs/file.c:546 
btrfs_drop_extent_cache+0x3e8/0x400 [btrfs]
[   79.922002] Modules linked in: ipt_REJECT nf_reject_ipv4 xt_tcpudp 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
iptable_filter ip_tables x_tables ipmi_devintf sb_edac edac_core 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel btrfs aesni_intel 
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd dm_multipath nfsd 
auth_rpcgss joydev nfs_acl mei_me nfs lpc_ich mei lockd wmi grace 
ipmi_si sunrpc ipmi_msghandler fscache shpchp ioatdma mac_hid lp parport 
ses enclosure scsi_transport_sas raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor hid_generic igb raid6_pq 
i2c_algo_bit libcrc32c dca usbhid raid1 ahci raid0 ptp megaraid_sas 
multipath hid libahci pps_core linear dm_mirror dm_region_hash dm_log
[   79.922063] CPU: 6 PID: 2632 Comm: mount Not tainted 4.7.0-custom #1
[   79.922065] Hardware name: Supermicro 
X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
[   79.922067]  0000000000000000 ffff88046ca1f538 ffffffff813b816c 
0000000000000000
[   79.922071]  0000000000000000 ffff88046ca1f578 ffffffff8107a321 
000002226ca1f5e0
[   79.922074]  ffff880841d19460 000000000000e000 ffff880841e21290 
ffff880841e210c0
[   79.922077] Call Trace:
[   79.922089]  [<ffffffff813b816c>] dump_stack+0x63/0x87
[   79.922096]  [<ffffffff8107a321>] __warn+0xd1/0xf0
[   79.922099]  [<ffffffff8107a40d>] warn_slowpath_null+0x1d/0x20
[   79.922117]  [<ffffffffc05b17c8>] btrfs_drop_extent_cache+0x3e8/0x400 
[btrfs]
[   79.922133]  [<ffffffffc05b20d2>] __btrfs_drop_extents+0x5b2/0xd30 
[btrfs]
[   79.922147]  [<ffffffffc0573b05>] ? 
generic_bin_search.constprop.36+0x85/0x190 [btrfs]
[   79.922160]  [<ffffffffc05715c6>] ? btrfs_set_path_blocking+0x36/0x70 
[btrfs]
[   79.922173]  [<ffffffffc0576468>] ? btrfs_search_slot+0x438/0x970 [btrfs]
[   79.922178]  [<ffffffff811dc5d6>] ? kmem_cache_alloc+0x1d6/0x1f0
[   79.922190]  [<ffffffffc057158a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[   79.922205]  [<ffffffffc05b3839>] btrfs_drop_extents+0x79/0xa0 [btrfs]
[   79.922224]  [<ffffffffc05de179>] replay_one_extent+0x419/0x750 [btrfs]
[   79.922241]  [<ffffffffc05de98b>] replay_one_buffer+0x4db/0x7d0 [btrfs]
[   79.922258]  [<ffffffffc05ba6bf>] ? 
mark_extent_buffer_accessed+0x4f/0x70 [btrfs]
[   79.922274]  [<ffffffffc05dae0c>] walk_down_log_tree+0x1cc/0x3d0 [btrfs]
[   79.922289]  [<ffffffffc05db2ea>] walk_log_tree+0xba/0x1a0 [btrfs]
[   79.922304]  [<ffffffffc05e0773>] btrfs_recover_log_trees+0x213/0x470 
[btrfs]
[   79.922318]  [<ffffffffc05de4b0>] ? replay_one_extent+0x750/0x750 [btrfs]
[   79.922335]  [<ffffffffc0599c6d>] open_ctree+0x264d/0x2760 [btrfs]
[   79.922348]  [<ffffffffc056e8f4>] btrfs_mount+0xc94/0xeb0 [btrfs]
[   79.922353]  [<ffffffff813cd67e>] ? find_next_zero_bit+0x1e/0x20
[   79.922358]  [<ffffffff8119fbbe>] ? pcpu_next_unpop+0x3e/0x50
[   79.922362]  [<ffffffff813cd659>] ? find_next_bit+0x19/0x20
[   79.922368]  [<ffffffff81204179>] mount_fs+0x39/0x160
[   79.922371]  [<ffffffff811a0df5>] ? __alloc_percpu+0x15/0x20
[   79.922375]  [<ffffffff8121fda7>] vfs_kern_mount+0x67/0x110
[   79.922387]  [<ffffffffc056ddeb>] btrfs_mount+0x18b/0xeb0 [btrfs]
[   79.922390]  [<ffffffff813cd67e>] ? find_next_zero_bit+0x1e/0x20
[   79.922394]  [<ffffffff81204179>] mount_fs+0x39/0x160
[   79.922397]  [<ffffffff811a0df5>] ? __alloc_percpu+0x15/0x20
[   79.922399]  [<ffffffff8121fda7>] vfs_kern_mount+0x67/0x110
[   79.922402]  [<ffffffff8122236a>] do_mount+0x22a/0xd90
[   79.922406]  [<ffffffff811dfbcf>] ? __kmalloc_track_caller+0x1af/0x250
[   79.922408]  [<ffffffff8119b831>] ? strndup_user+0x41/0x80
[   79.922411]  [<ffffffff8119b752>] ? memdup_user+0x42/0x70
[   79.922413]  [<ffffffff812231b3>] SyS_mount+0x83/0xd0
[   79.922418]  [<ffffffff817db636>] entry_SYSCALL_64_fastpath+0x1e/0xa8
[   79.922436] ---[ end trace 0db3466cdad31dcf ]---




On 08/09/2016 10:25 PM, Chris Murphy wrote:
> On Tue, Aug 9, 2016 at 6:29 PM, Matt McKinnon <matt@techsquare.com> wrote:
>> Spoke too soon.  Do I need to continue to run with that mount option in
>> place?
>
> It shouldn't be necessary. Something's still wrong for some reason,
> even with DUP metadata being CoW'd so someone else is going to have to
> speak up what the problem is. And that btrfs check not only doesn't
> come up clean but crashes suggests some confluence of things in kernel
> 4.3 and your hardware conspired to make the file system inconsistent
> in a way that isn't immediately recovering the usual way. That is,
> usebackuproots working suggests that there's a bug elsewhere in the
> storage stack because normally that shouldn't be necessary -
> something's happened out of order.
>
> 1 size 50.93TiB used 22.67TiB path /dev/sda1
>
> What is the exact nature of this block device?
>
> If getting this back up and running is urgent I suggest inquiring on
> IRC what the next steps are.
>
> In the meantime I'd get a btrfs-image (which is probably going to be
> quite large given metadata is 60GiB), if that pukes then see if 'btrfs
> inspect-internal dump-tree /dev/sda1 > dumptree.log' which may also
> fail but before it fails might contain something useful. Obviously
> btrfs check shouldn't crash so that's a bug already. What do you get
> for free -m? It's known that btrfs check needs a lot of memory and
> pretty much all the metadata needs to be read in, so... if you have an
> SSD available it might make sense to setup a huge pile of swap on that
> SSD and rerun btrfs check.
>
>
>
