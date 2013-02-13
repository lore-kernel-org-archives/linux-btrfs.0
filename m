Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52450 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab3BMIkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 03:40:36 -0500
Received: from mailout-de.gmx.net ([10.1.76.24]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MgJFg-1UJDQj0O86-00NhtZ for
 <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 09:40:35 +0100
Message-ID: <511B5181.7030206@gmx.net>
Date: Wed, 13 Feb 2013 09:40:33 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: shyam btrfs <shyam.btrfs@gmail.com>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Subject: Re: Heavy memory leak when using quota groups
References: <CAGEjNMfpTD3wMsagrFYinuJj0ieT8+g66uVz_hFpgp=1j4hYFQ@mail.gmail.com>
In-Reply-To: <CAGEjNMfpTD3wMsagrFYinuJj0ieT8+g66uVz_hFpgp=1j4hYFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12.02.2013 08:25, shyam btrfs wrote:
> Hi Arne, Jan,
> 
> I am using btrfs directly from Linux 3.8rc5 (commit
> 949db153b6466c6f7cad5a427ecea94985927311). I am trying to use qgroups
> functionality & with a basic random-write workload, it constantly
> keeps leaking memory & within few minutes of IO, there is either
> out-of-memory killer trying to kill some tasks or there are
> page-allocation failures that btrfs or other kernel module
> experiences.
> 
> This issue is consistently reproducible & to do that this is what I do:
> # mkfs.btrfs on a blockdevice
> # mount with "rw,noatime,nodatasum,nodatacow,nospace_cache"  options
> # btrfs quota enable /mntpoint
> # btrfs qgroup create 100 /mntpoint
> # I setup a subvolume under the mountpoint & fallocate a file of fixed size.
> # Perform 4K write random IO with 4 worker threads with the
> application opening with O_SYNC flag (i.e. there is a fsync() after
> each write). To do this I am exposing the fallocate'd file as a SCST
> iSCSI target lun & doing IO's, but I presume this can be easily
> reproduced with any other IO generator.

Unfortunately I haven't been able to reproduce it yet (using stress.sh),
but I keep trying. Are you sure it is really leaking memory or just needing
more than is available? If you abort the test in the middle, can you reclaim
all your memory by unmounting?

Thanks,
Arne

> 
> I confirmed that if I dont do quota enable/qgroup create, I don't run
> into this issue. So there is somewhere a memory leak with quota-group.
> 
> Below is one stack trace where qgroup accounting code runs into
> allocation failure.
> 
> [ 5123.800178] btrfs-endio-wri: page allocation failure: order:0, mode:0x20
> [ 5123.800188] Pid: 27508, comm: btrfs-endio-wri Tainted: GF
> O 3.8.0-030800rc5-generic #201301251535
> [ 5123.800190] Call Trace:
> [ 5123.800204]  [<ffffffff8113a656>] warn_alloc_failed+0xf6/0x150
> [ 5123.800208]  [<ffffffff8113e28e>] __alloc_pages_nodemask+0x76e/0x9b0
> [ 5123.800213]  [<ffffffff81182945>] ? new_slab+0x125/0x1a0
> [ 5123.800216]  [<ffffffff81185c2c>] ? kmem_cache_alloc+0x11c/0x140
> [ 5123.800221]  [<ffffffff8117a66a>] alloc_pages_current+0xba/0x170
> [ 5123.800239]  [<ffffffffa055f794>] btrfs_clone_extent_buffer+0x64/0xe0 [btrfs]
> [ 5123.800245]  [<ffffffffa051fb33>] btrfs_search_old_slot+0xb3/0x940 [btrfs]
> [ 5123.800252]  [<ffffffff810f78f7>] ? call_rcu_sched+0x17/0x20
> [ 5123.800263]  [<ffffffffa055849e>] ?
> release_extent_buffer.isra.26+0x5e/0xf0 [btrfs]
> [ 5123.800273]  [<ffffffffa055da17>] ? free_extent_buffer+0x37/0x90 [btrfs]
> [ 5123.800280]  [<ffffffffa0522d5d>] btrfs_next_old_leaf+0xed/0x450 [btrfs]
> [ 5123.800290]  [<ffffffffa05955b4>] __resolve_indirect_refs+0x334/0x620 [btrfs]
> [ 5123.800301]  [<ffffffffa059616a>] find_parent_nodes+0x7da/0xf90 [btrfs]
> [ 5123.800311]  [<ffffffffa05969b9>] btrfs_find_all_roots+0x99/0x100 [btrfs]
> [ 5123.800313]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
> [ 5123.800323]  [<ffffffffa059991b>] btrfs_qgroup_account_ref+0xfb/0x550 [btrfs]
> [ 5123.800325]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
> [ 5123.800332]  [<ffffffffa05290d3>]
> btrfs_delayed_refs_qgroup_accounting+0xa3/0x100 [btrfs]
> [ 5123.800341]  [<ffffffffa0540941>] __btrfs_end_transaction+0x81/0x410 [btrfs]
> [ 5123.800349]  [<ffffffffa052b646>] ?
> btrfs_delalloc_release_metadata+0x106/0x180 [btrfs]
> [ 5123.800358]  [<ffffffffa0540d20>] btrfs_end_transaction+0x10/0x20 [btrfs]
> [ 5123.800367]  [<ffffffffa054965d>] btrfs_finish_ordered_io+0x10d/0x3d0 [btrfs]
> [ 5123.800374]  [<ffffffff8106a3a0>] ? cascade+0xa0/0xa0
> [ 5123.800384]  [<ffffffffa0549935>] finish_ordered_fn+0x15/0x20 [btrfs]
> [ 5123.800394]  [<ffffffffa056ac2f>] worker_loop+0x16f/0x5d0 [btrfs]
> [ 5123.800401]  [<ffffffff810888a8>] ? __wake_up_common+0x58/0x90
> [ 5123.800411]  [<ffffffffa056aac0>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
> [ 5123.800415]  [<ffffffff8107f080>] kthread+0xc0/0xd0
> [ 5123.800417]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
> [ 5123.800423]  [<ffffffff816f452c>] ret_from_fork+0x7c/0xb0
> [ 5123.800425]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
> 
> I have attached meminfo/slabinfo that I peridically captured before
> running the test & while the test was going through. Also attached are
> sysrq outputs + debug-tree output after the problem happened.
> 
> Can you pls check whats happening with quota-groups? Thanks.
> 
> --Shyam
> 
> 
> Immediately after the allocation failure, there is this panic
> [ 5123.811593] ------------[ cut here ]------------
> [ 5123.813996] Kernel BUG at ffffffffa055f7f7 [verbose debug info unavailable]
> [ 5123.815286] invalid opcode: 0000 [#1] SMP
> [ 5123.816131] Modules linked in: btrfs(OF) raid1 xt_multiport
> xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
> iptable_filter ip_tables x_tables iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp
> esp4 ah4 8021q garp stp llc bonding deflate zlib_deflate ctr
> twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common
> camellia_generic camellia_x86_64 serpent_sse2_x86_64 glue_helper lrw
> serpent_generic xts gf128mul blowfish_generic blowfish_x86_64
> blowfish_common ablk_helper cryptd cast5_generic cast_common
> des_generic xcbc rmd160 crypto_null af_key xfrm_algo scst_vdisk(OF)
> iscsi_scst(OF) scst(OF) libcrc32c microcode psmouse nfsv4
> virtio_balloon serio_raw nfsd(OF) nfs_acl auth_rpcgss nfs fscache
> lockd sunrpc lp parport ixgbevf floppy [last unloaded: btrfs]
> [ 5123.831906] CPU 0
> [ 5123.832291] Pid: 27508, comm: btrfs-endio-wri Tainted: GF
> O 3.8.0-030800rc5-generic #201301251535 Bochs Bochs
> [ 5123.834339] RIP: 0010:[<ffffffffa055f7f7>]  [<ffffffffa055f7f7>]
> btrfs_clone_extent_buffer+0xc7/0xe0 [btrfs]
> [ 5123.836223] RSP: 0018:ffff880018ceb858  EFLAGS: 00010246
> [ 5123.837229] RAX: 0000000000000000 RBX: ffff880000fee408 RCX: ffffffff81e2f4c0
> [ 5123.838549] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000246
> [ 5123.839869] RBP: ffff880018ceb888 R08: 000000000000000a R09: 0000000000000000
> [ 5123.841234] R10: 0000000000000000 R11: 00000000000002e7 R12: ffff8800079dc408
> [ 5123.842558] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> [ 5123.843879] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000)
> knlGS:0000000000000000
> [ 5123.845414] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 5123.846482] CR2: 0000000000df0c68 CR3: 0000000025189000 CR4: 00000000000006f0
> [ 5123.847806] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5123.849171] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 5123.850509] Process btrfs-endio-wri (pid: 27508, threadinfo
> ffff880018cea000, task ffff88003b915d00)
> [ 5123.852221] Stack:
> [ 5123.852615]  ffff880018ceb888 ffff880023223800 ffff88003b7b2680
> ffff880017ee06c0
> [ 5123.854093]  ffff8800079dc408 ffff88003b7b2680 ffff880018ceb928
> ffffffffa051fb33
> [ 5123.855563]  ffff880018ceb8a8 ffffffff810f78f7 ffff880018ceb8d8
> ffffffffa055849e
> [ 5123.857069] Call Trace:
> [ 5123.857554]  [<ffffffffa051fb33>] btrfs_search_old_slot+0xb3/0x940 [btrfs]
> [ 5123.858842]  [<ffffffff810f78f7>] ? call_rcu_sched+0x17/0x20
> [ 5123.859911]  [<ffffffffa055849e>] ?
> release_extent_buffer.isra.26+0x5e/0xf0 [btrfs]
> [ 5123.861388]  [<ffffffffa055da17>] ? free_extent_buffer+0x37/0x90 [btrfs]
> [ 5123.862646]  [<ffffffffa0522d5d>] btrfs_next_old_leaf+0xed/0x450 [btrfs]
> [ 5123.863910]  [<ffffffffa05955b4>] __resolve_indirect_refs+0x334/0x620 [btrfs]
> [ 5123.865299]  [<ffffffffa059616a>] find_parent_nodes+0x7da/0xf90 [btrfs]
> [ 5123.866542]  [<ffffffffa05969b9>] btrfs_find_all_roots+0x99/0x100 [btrfs]
> [ 5123.867807]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
> [ 5123.868792]  [<ffffffffa059991b>] btrfs_qgroup_account_ref+0xfb/0x550 [btrfs]
> [ 5123.870121]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
> [ 5123.871058]  [<ffffffffa05290d3>]
> btrfs_delayed_refs_qgroup_accounting+0xa3/0x100 [btrfs]
> [ 5123.873030]  [<ffffffffa0540941>] __btrfs_end_transaction+0x81/0x410 [btrfs]
> [ 5123.874370]  [<ffffffffa052b646>] ?
> btrfs_delalloc_release_metadata+0x106/0x180 [btrfs]
> [ 5123.875874]  [<ffffffffa0540d20>] btrfs_end_transaction+0x10/0x20 [btrfs]
> [ 5123.877200]  [<ffffffffa054965d>] btrfs_finish_ordered_io+0x10d/0x3d0 [btrfs]
> [ 5123.878484]  [<ffffffff8106a3a0>] ? cascade+0xa0/0xa0
> [ 5123.879405]  [<ffffffffa0549935>] finish_ordered_fn+0x15/0x20 [btrfs]
> [ 5123.880602]  [<ffffffffa056ac2f>] worker_loop+0x16f/0x5d0 [btrfs]
> [ 5123.881713]  [<ffffffff810888a8>] ? __wake_up_common+0x58/0x90
> [ 5123.882771]  [<ffffffffa056aac0>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
> [ 5123.883995]  [<ffffffff8107f080>] kthread+0xc0/0xd0
> [ 5123.884913]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
> [ 5123.886018]  [<ffffffff816f452c>] ret_from_fork+0x7c/0xb0
> [ 5123.886986]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
> [ 5123.888108] Code: 31 c9 31 d2 4c 89 e6 48 89 df e8 25 fe ff ff 3e
> 80 4b 20 01 3e 80 4b 21 02 48 83 c4 08 48 89 d8 5b 41 5c 41 5d 41 5e
> 41 5f 5d c3 <0f> 0b be e8 0f 00 00 48 c7 c7 10 f3 5a a0 e8 e6 a1 af e0
> eb a2
> [ 5123.893000] RIP  [<ffffffffa055f7f7>]
> btrfs_clone_extent_buffer+0xc7/0xe0 [btrfs]
> [ 5123.894379]  RSP <ffff880018ceb858>
> [ 5123.906866] ---[ end trace b96bd164e48cd6de ]---
> [ 5123.911681] Kernel panic - not syncing: Fatal exception
> [ 5123.932069]
> [ 5123.933520] SysRq : Show Memory
> [ 5123.934156] Mem-Info:
> [ 5123.934607] Node 0 DMA per-cpu:
> [ 5123.935240] CPU    0: hi:    0, btch:   1 usd:   0
> [ 5123.936021] Node 0 DMA32 per-cpu:
> [ 5123.936021] CPU    0: hi:  186, btch:  31 usd: 167
> [ 5123.936021] active_anon:24384 inactive_anon:89 isolated_anon:0
> [ 5123.936021]  active_file:30846 inactive_file:30865 isolated_file:0
> [ 5123.936021]  unevictable:4053 dirty:553 writeback:0 unstable:0
> [ 5123.936021]  free:17219 slab_reclaimable:8648 slab_unreclaimable:4167
> [ 5123.936021]  mapped:10630 shmem:148 pagetables:1921 bounce:0
> [ 5123.936021]  free_cma:0
> [ 5123.936021] Node 0 DMA free:4268kB min:680kB low:848kB high:1020kB
> active_anon:8kB inactive_anon:0kB active_file:1152kB
> inactive_file:1228kB unevictable:0kB isolated(anon):0kB
> isolated(file):0kB present:15636kB managed:15892kB mlocked:0kB
> dirty:8kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:260kB
> slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
> bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
> all_unreclaimable? no
> [ 5123.936021] lowmem_reserve[]: 0 992 992 992
> [ 5123.936021] Node 0 DMA32 free:64608kB min:44372kB low:55464kB
> high:66556kB active_anon:97528kB inactive_anon:356kB
> active_file:122232kB inactive_file:122232kB unevictable:16212kB
> isolated(anon):0kB isolated(file):0kB present:1016052kB
> managed:991296kB mlocked:16212kB dirty:2204kB writeback:0kB
> mapped:42520kB shmem:592kB slab_reclaimable:34332kB
> slab_unreclaimable:16668kB kernel_stack:2704kB pagetables:7684kB
> unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
> pages_scanned:14 all_unreclaimable? no
> [ 5123.936021] lowmem_reserve[]: 0 0 0 0
> [ 5123.936021] Node 0 DMA: 1*4kB (E) 5*8kB (UE) 2*16kB (UE) 5*32kB
> (UE) 13*64kB (UE) 9*128kB (UE) 0*256kB 0*512kB 0*1024kB 1*2048kB (R)
> 0*4096kB = 4268kB
> [ 5123.936021] Node 0 DMA32: 4194*4kB (UEM) 1927*8kB (UEM) 245*16kB
> (UEM) 139*32kB (UEM) 74*64kB (UEM) 41*128kB (UEM) 25*256kB (UM)
> 5*512kB (M) 1*1024kB (M) 0*2048kB 1*4096kB (R) = 64624kB
> [ 5123.936021] 62932 total pagecache pages
> [ 5123.936021] 0 pages in swap cache
> [ 5123.936021] Swap cache stats: add 0, delete 0, find 0/0
> [ 5123.936021] Free swap  = 0kB
> [ 5123.936021] Total swap = 0kB
> [ 5123.936021] 262125 pages RAM
> [ 5123.936021] 7460 pages reserved
> [ 5123.936021] 340761 pages shared
> [ 5123.936021] 193374 pages non-shared
> [ 5123.978133]

