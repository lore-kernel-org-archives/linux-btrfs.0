From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs warnings from 2.6.39-rc5
Date: Tue, 03 May 2011 10:52:49 -0400
Message-ID: <4DC016C1.2070505@redhat.com>
References: <4DB863B4.3070900@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4DB863B4.3070900@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/2011 02:43 PM, Jim Schutt wrote:
> Hi,
>
> I'm not sure if they matter, but I got these warnings on
> one of the machines I'm using as a Ceph OSD server:
>
> [ 1806.549469] ------------[ cut here ]------------
> [ 1806.554593] WARNING: at fs/btrfs/extent-tree.c:5790
> use_block_rsv+0xa7/0x101 [btrfs]()
> [ 1806.562903] Hardware name: PowerEdge 1950
> [ 1806.567126] Modules linked in: loop btrfs zlib_deflate lzo_compress
> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
> x_tables bridge stp i2c_dev i2c_core ext3 jbd ib_iser libi]
> [ 1806.689084] Pid: 12025, comm: cosd Not tainted
> 2.6.39-rc5-00006-g7b0bd4b #2
> [ 1806.697425] Call Trace:
> [ 1806.700332] [<ffffffffa06fe816>] ? use_block_rsv+0xa7/0x101 [btrfs]
> [ 1806.707032] [<ffffffff810494d8>] ? warn_slowpath_common+0x85/0x9e
> [ 1806.713502] [<ffffffff8104950b>] ? warn_slowpath_null+0x1a/0x1c
> [ 1806.720755] [<ffffffffa06fe816>] ? use_block_rsv+0xa7/0x101 [btrfs]
> [ 1806.731488] [<ffffffffa070590b>] ? btrfs_alloc_free_block+0x30/0x198
> [btrfs]
> [ 1806.743858] [<ffffffffa072ae8a>] ?
> map_private_extent_buffer+0xb2/0xd9 [btrfs]
> [ 1806.752600] [<ffffffffa072a4b8>] ? __kmap_atomic+0x12/0x47 [btrfs]
> [ 1806.760057] [<ffffffffa072b036>] ? read_extent_buffer+0xc2/0xd4 [btrfs]
> [ 1806.770897] [<ffffffffa06f84ac>] ? __btrfs_cow_block+0x10e/0x2f5 [btrfs]
> [ 1806.779552] [<ffffffffa0709dbe>] ? btrfs_header_generation+0x1f/0x25
> [btrfs]
> [ 1806.788994] [<ffffffffa06f878f>] ? btrfs_cow_block+0xfc/0x121 [btrfs]
> [ 1806.798434] [<ffffffffa06fa746>] ? btrfs_search_slot+0x144/0x3ae [btrfs]
> [ 1806.806444] [<ffffffffa0709877>] ? btrfs_lookup_inode+0x31/0x86 [btrfs]
> [ 1806.813611] [<ffffffffa071618b>] ? btrfs_update_inode+0x52/0xc1 [btrfs]
> [ 1806.820904] [<ffffffffa071668c>] ? btrfs_truncate+0x239/0x297 [btrfs]
> [ 1806.829290] [<ffffffffa071bb23>] ? btrfs_setsize+0x8c/0x9b [btrfs]
> [ 1806.835962] [<ffffffffa071bb93>] ? btrfs_setattr+0x61/0x9d [btrfs]
> [ 1806.842892] [<ffffffff81127ea4>] ? notify_change+0x174/0x1bc
> [ 1806.850878] [<ffffffff81110c4f>] ? do_truncate+0x6e/0x8a
> [ 1806.857374] [<ffffffff8111b126>] ? generic_permission+0x1c/0x8e
> [ 1806.868498] [<ffffffff81110e42>] ? do_sys_truncate+0xf8/0x10a
> [ 1806.877746] [<ffffffff81110e62>] ? sys_truncate+0xe/0x10
> [ 1806.902751] [<ffffffff813b6deb>] ? system_call_fastpath+0x16/0x1b
> [ 1806.909736] ---[ end trace cd0ae33f1a4433d9 ]---
> [ 1812.142333] ------------[ cut here ]------------
> [ 1812.146996] WARNING: at fs/btrfs/inode.c:2180
> btrfs_orphan_commit_root+0x8c/0xab [btrfs]()
> [ 1812.155275] Hardware name: PowerEdge 1950
> [ 1812.159280] Modules linked in: loop btrfs zlib_deflate lzo_compress
> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
> x_tables bridge stp i2c_dev i2c_core ext3 jbd ib_iser libi]
> [ 1812.240872] Pid: 7923, comm: kworker/3:2 Tainted: G W
> 2.6.39-rc5-00006-g7b0bd4b #2
> [ 1812.249216] Call Trace:
> [ 1812.251712] [<ffffffffa0715048>] ? btrfs_orphan_commit_root+0x8c/0xab
> [btrfs]
> [ 1812.258976] [<ffffffff810494d8>] ? warn_slowpath_common+0x85/0x9e
> [ 1812.265199] [<ffffffff8104950b>] ? warn_slowpath_null+0x1a/0x1c
> [ 1812.271420] [<ffffffffa0715048>] ? btrfs_orphan_commit_root+0x8c/0xab
> [btrfs]
> [ 1812.278704] [<ffffffffa070f5e0>] ? commit_fs_roots+0x95/0xfd [btrfs]
> [ 1812.285220] [<ffffffffa07039b3>] ? btrfs_run_delayed_refs+0x112/0x15e
> [btrfs]
> [ 1812.292459] [<ffffffff810367bf>] ? need_resched+0x23/0x2d
> [ 1812.297961] [<ffffffff810367d7>] ? should_resched+0xe/0x2f
> [ 1812.303604] [<ffffffffa07105e3>] ?
> btrfs_commit_transaction+0x349/0x5a3 [btrfs]
> [ 1812.310999] [<ffffffff8106622c>] ? list_del_init+0x21/0x21
> [ 1812.316615] [<ffffffffa071085c>] ? do_async_commit+0x1f/0x2c [btrfs]
> [ 1812.323055] [<ffffffff8106076b>] ? process_one_work+0x124/0x1e0
> [ 1812.329083] [<ffffffffa071083d>] ?
> btrfs_commit_transaction+0x5a3/0x5a3 [btrfs]
> [ 1812.336526] [<ffffffff81061dd8>] ? workqueue_congested+0x1e/0x1e
> [ 1812.342636] [<ffffffff81061e67>] ? worker_thread+0x8f/0x124
> [ 1812.348353] [<ffffffff81065d26>] ? kthread+0x72/0x7a
> [ 1812.353439] [<ffffffff813b7ed4>] ? kernel_thread_helper+0x4/0x10
> [ 1812.359555] [<ffffffff813b07ad>] ? retint_restore_args+0xe/0xe
> [ 1812.365484] [<ffffffff81065cb4>] ? kthread_bind+0x64/0x64
> [ 1812.370986] [<ffffffff813b7ed0>] ? gs_change+0xb/0xb
> [ 1812.376047] ---[ end trace cd0ae33f1a4433da ]---
>
> Please let me know if I can do anything to help sort these out.
>

I just posted a patch for this problem, it's titled

     Btrfs: fix how we do space reservation for truncate

Please apply it and test it and see if it makes this problem go away. 
Thanks,

Josef
