Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43982 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757183AbdEUVru (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 17:47:50 -0400
Date: Sun, 21 May 2017 14:47:33 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170521214733.c62v7el4g66jf63x@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gargamel:~# btrfs check --repair /dev/mapper/dshelf1
enabling repair mode
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking extents

This causes a bunch of these:
btrfs-transacti: page allocation stalls for 23508ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
btrfs-transacti cpuset=/ mems_allowed=0

What's the recommended way out of this and which code is at fault? I can't tell if btrfs is doing memory allocations wrong, or if it's just being undermined by the block layer dying underneath.

And sadly, I'm also getting workqueues stalls like these:
[ 3996.047531] BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=0 stuck for 45s!
[ 3996.073512] BUG: workqueue lockup - pool cpus=3 node=0 flags=0x0 nice=0 stuck for 52s!
[ 3996.099466] Showing busy workqueues and worker pools:
[ 3996.116824] workqueue events: flags=0x0
[ 3996.130409]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=3/256
[ 3996.150268]     in-flight: 9661:do_sync_work
[ 3996.165186]     pending: wait_rcu_exp_gp, cache_reap
[ 3996.182139]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=8/256
[ 3996.202099]     in-flight: 9725:do_emergency_remount, 9738:do_poweroff
[ 3996.223543]     pending: drm_fb_helper_dirty_work, cache_reap, do_sync_work, vmstat_shepherd, update_writeback_rate [bcache], do_poweroff
[ 3996.263991] workqueue writeback: flags=0x4e
[ 3996.278116]   pwq 16: cpus=0-7 flags=0x4 nice=0 active=2/256
[ 3996.296586]     in-flight: 149:wb_workfn wb_workfn
[ 3996.312387] workqueue btrfs-endio-write: flags=0xe
[ 3996.328090]   pwq 16: cpus=0-7 flags=0x4 nice=0 active=2/8
[ 3996.345794]     in-flight: 20326:btrfs_endio_write_helper, 2927:btrfs_endio_write_helper
[ 3996.371981] workqueue kcryptd: flags=0x2a
[ 3996.386019]   pwq 16: cpus=0-7 flags=0x4 nice=0 active=8/8
[ 3996.404325]     in-flight: 9950:kcryptd_crypt [dm_crypt], 8859:kcryptd_crypt [dm_crypt], 31087:kcryptd_crypt [dm_crypt], 2929:kcryptd_crypt [dm_crypt], 20328:kcryptd_crypt [dm_crypt], 5951:kcryptd_crypt [dm_crypt], 31084:kcryptd_crypt [dm_crypt], 7553:kcryptd_crypt [dm_crypt]
[ 3996.484333]     delayed: kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt]
[ 3996.719697] , kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt], kcryptd_crypt [dm_crypt]

Problems started here:
[ 3624.349624] php5: page allocation stalls for 15028ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
[ 3624.382270] php5 cpuset=/ mems_allowed=0
[ 3624.395474] CPU: 1 PID: 9949 Comm: php5 Tainted: G     U          4.11.1-amd64-preempt-sysrq-20170406 #4
[ 3624.424907] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 3624.453233] Call Trace:
[ 3624.461292]  dump_stack+0x61/0x7d
[ 3624.472098]  warn_alloc+0xfc/0x18c
[ 3624.483150]  __alloc_pages_slowpath+0x3bc/0xb31
[ 3624.497528]  ? finish_wait+0x5a/0x63
[ 3624.509018]  __alloc_pages_nodemask+0x12c/0x1e0
[ 3624.523343]  alloc_pages_current+0x9b/0xbd
[ 3624.536346]  __page_cache_alloc+0x8e/0xa4
[ 3624.549067]  pagecache_get_page+0xc9/0x16b
[ 3624.562067]  alloc_extent_buffer+0xdf/0x305
[ 3624.575342]  read_tree_block+0x19/0x4e
[ 3624.587295]  read_block_for_search.isra.21+0x211/0x264
[ 3624.603420]  btrfs_search_slot+0x52b/0x72e
[ 3624.616387]  btrfs_lookup_csum+0x52/0xf7
[ 3624.628835]  __btrfs_lookup_bio_sums+0x23b/0x448
[ 3624.643396]  btrfs_lookup_bio_sums+0x16/0x18
[ 3624.656886]  btrfs_submit_bio_hook+0xcb/0x14a
[ 3624.670639]  submit_one_bio+0x60/0x7e
[ 3624.682308]  extent_readpages+0x1c8/0x1eb
[ 3624.695018]  ? insert_reserved_file_extent.constprop.41+0x28e/0x28e
[ 3624.714473]  btrfs_readpages+0x1f/0x21
[ 3624.726384]  __do_page_cache_readahead+0x1af/0x27b
[ 3624.741410]  ? pagecache_get_page+0x2b/0x16b
[ 3624.754869]  filemap_fault+0x17f/0x3a7
[ 3624.766775]  ? filemap_fault+0x17f/0x3a7
[ 3624.779193]  __do_fault+0x1b/0x67
[ 3624.789778]  __handle_mm_fault+0x67f/0xa6f
[ 3624.802699]  handle_mm_fault+0x126/0x1d9
[ 3624.815096]  __do_page_fault+0x31a/0x43c
[ 3624.827510]  do_page_fault+0x25/0x27
[ 3624.838865]  page_fault+0x28/0x30
[ 3624.849436] RIP: 0023:0x80a6d74
[ 3624.859479] RSP: 002b:00000000ffaae318 EFLAGS: 00210246
[ 3624.875761] RAX: 0000000008972dc0 RBX: 0000000008955000 RCX: 0000000000000341
[ 3624.897769] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000896f15c
[ 3624.919779] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 3624.941768] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 3624.963784] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 3624.985785] Mem-Info:
[ 3624.994026] active_anon:5274699 inactive_anon:378530 isolated_anon:3232
[ 3624.994026]  active_file:3711 inactive_file:3809 isolated_file:0
[ 3624.994026]  unevictable:1467 dirty:5068 writeback:49122 unstable:0
[ 3624.994026]  slab_reclaimable:8800 slab_unreclaimable:67134
[ 3624.994026]  mapped:558735 shmem:801466 pagetables:15777 bounce:0
[ 3624.994026]  free:89592 free_pcp:31 free_cma:0
[ 3625.104705] Node 0 active_anon:21098796kB inactive_anon:1513736kB active_file:14844kB inactive_file:15236kB unevictable:5868kB isolated(anon):13312kB isolated(file):0kB mapped:2234940kB dirty:20272kB writeback:196488kB shmem:3205864kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:43 all_unreclaimable? no
[ 3625.202085] Node 0 DMA free:15880kB min:168kB low:208kB high:248kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15972kB managed:15888kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 3625.295661] lowmem_reserve[]: 0 3201 23768 23768 23768
[ 3625.312447] Node 0 DMA32 free:116696kB min:35424kB low:44280kB high:53136kB active_anon:3161376kB inactive_anon:8kB active_file:320kB inactive_file:332kB unevictable:0kB writepending:612kB present:3362068kB managed:3296500kB mlocked:0kB slab_reclaimable:472kB slab_unreclaimable:680kB kernel_stack:16kB pagetables:7292kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 3625.415160] lowmem_reserve[]: 0 0 20567 20567 20567
[ 3625.431182] Node 0 Normal free:225612kB min:226544kB low:283180kB high:339816kB active_anon:17937416kB inactive_anon:1513964kB active_file:14524kB inactive_file:14904kB unevictable:5868kB writepending:216424kB present:21485568kB managed:21080208kB mlocked:5868kB slab_reclaimable:34524kB slab_unreclaimable:268752kB kernel_stack:12480kB pagetables:55816kB bounce:0kB free_pcp:392kB local_pcp:124kB free_cma:0kB
[ 3625.546415] lowmem_reserve[]: 0 0 0 0 0
[ 3625.559648] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 3625.601566] Node 0 DMA32: 768*4kB (UME) 743*8kB (UME) 686*16kB (UME) 446*32kB (UME) 426*64kB (UME) 233*128kB (UME) 79*256kB (UME) 10*512kB (UME) 0*1024kB 0*2048kB 0*4096kB = 116696kB
[ 3625.652772] Node 0 Normal: 26419*4kB (UME) 11249*8kB (UME) 918*16kB (UME) 252*32kB (UME) 74*64kB (UM) 15*128kB (UM) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 225332kB
[ 3625.703427] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 3625.729772] 858805 total pagecache pages
[ 3625.742561] 49207 pages in swap cache
[ 3625.754535] Swap cache stats: add 62005, delete 12831, find 75/76
[ 3625.773719] Free swap  = 15367668kB
[ 3625.785093] Total swap = 15616764kB
[ 3625.796457] 6215902 pages RAM
[ 3625.806278] 0 pages HighMem/MovableOnly
[ 3625.818722] 117753 pages reserved
[ 3625.829550] 4096 pages cma reserved
[ 3625.840989] 0 pages hwpoisoned
[ 3629.587421] btrfs-transacti: page allocation stalls for 23508ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
[ 3629.624070] btrfs-transacti cpuset=/ mems_allowed=0
[ 3629.639649] CPU: 3 PID: 957 Comm: btrfs-transacti Tainted: G     U          4.11.1-amd64-preempt-sysrq-20170406 #4
[ 3629.671670] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 3629.700024] Call Trace:
[ 3629.708371]  dump_stack+0x61/0x7d
[ 3629.719341]  warn_alloc+0xfc/0x18c
[ 3629.730544]  __alloc_pages_slowpath+0x3bc/0xb31
[ 3629.745094]  ? elv_set_request+0x41/0x54
[ 3629.757829]  ? search_bitmap+0x7e/0x12b
[ 3629.770305]  __alloc_pages_nodemask+0x12c/0x1e0
[ 3629.784862]  alloc_pages_current+0x9b/0xbd
[ 3629.798113]  __page_cache_alloc+0x8e/0xa4
[ 3629.811112]  pagecache_get_page+0xc9/0x16b
[ 3629.824343]  alloc_extent_buffer+0xdf/0x305
[ 3629.837796]  btrfs_find_create_tree_block+0xe/0x10
[ 3629.853062]  btrfs_alloc_tree_block+0x1c4/0x3ea
[ 3629.853062]  btrfs_alloc_tree_block+0x1c4/0x3ea
[ 3629.867523]  __btrfs_cow_block+0x109/0x4a9
[ 3629.880658]  btrfs_cow_block+0xe4/0x15b
[ 3629.893008]  btrfs_search_slot+0x2a2/0x72e
[ 3629.906129]  btrfs_insert_empty_items+0x5d/0xa6
[ 3629.920515]  alloc_reserved_file_extent+0x94/0x238
[ 3629.935697]  __btrfs_run_delayed_refs+0xae4/0xd15
[ 3629.950581]  btrfs_run_delayed_refs+0x7a/0x1cc
[ 3629.964653]  ? slab_pre_alloc_hook+0x1a/0x44
[ 3629.978178]  btrfs_commit_transaction+0x50/0x79a
[ 3629.992743]  ? start_transaction+0x2c2/0x3b4
[ 3630.006241]  transaction_kthread+0xe2/0x178
[ 3630.019459]  ? btrfs_cleanup_transaction+0x3e8/0x3e8
[ 3630.035005]  kthread+0xfb/0x100
[ 3630.045072]  ? init_completion+0x24/0x24
[ 3630.057482]  ret_from_fork+0x2c/0x40
[ 3630.068848] Mem-Info:
[ 3630.076319] active_anon:5274313 inactive_anon:378373 isolated_anon:3590
[ 3630.076319]  active_file:3711 inactive_file:3809 isolated_file:0
[ 3630.076319]  unevictable:1467 dirty:5068 writeback:49189 unstable:0
[ 3630.076319]  slab_reclaimable:8721 slab_unreclaimable:67310
[ 3630.076319]  mapped:556943 shmem:801313 pagetables:15777 bounce:0
[ 3630.076319]  free:89741 free_pcp:6 free_cma:0
[ 3630.188769] Node 0 active_anon:21097252kB inactive_anon:1513492kB active_file:14844kB inactive_file:15236kB unevictable:5868kB isolated(anon):14360kB isolated(file):0kB mapped:2227772kB dirty:20272kB writeback:196756kB shmem:3205252kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:215184 all_unreclaimable? no
[ 3630.286396] Node 0 DMA free:15880kB min:168kB low:208kB high:248kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15972kB managed:15888kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 3630.378363] lowmem_reserve[]: 0 3201 23768 23768 23768
[ 3630.394566] Node 0 DMA32 free:116720kB min:35424kB low:44280kB high:53136kB active_anon:3161376kB inactive_anon:8kB active_file:320kB inactive_file:332kB unevictable:0kB writepending:612kB present:3362068kB managed:3296500kB mlocked:0kB slab_reclaimable:460kB slab_unreclaimable:668kB kernel_stack:16kB pagetables:7292kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 3630.494548] lowmem_reserve[]: 0 0 20567 20567 20567
[ 3630.510089] Node 0 Normal free:226664kB min:226544kB low:283180kB high:339816kB active_anon:17935552kB inactive_anon:1513564kB active_file:14524kB inactive_file:14904kB unevictable:5868kB writepending:216372kB present:21485568kB managed:21080208kB mlocked:5868kB slab_reclaimable:34412kB slab_unreclaimable:268520kB kernel_stack:12480kB pagetables:55816kB bounce:0kB free_pcp:148kB local_pcp:0kB free_cma:0kB
[ 3630.620626] lowmem_reserve[]: 0 0 0 0 0
[ 3630.632905] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 3630.674463] Node 0 DMA32: 768*4kB (UME) 740*8kB (UME) 685*16kB (UME) 446*32kB (UME) 427*64kB (UME) 233*128kB (UME) 79*256kB (UME) 10*512kB (UME) 0*1024kB 0*2048kB 0*4096kB = 116720kB
[ 3630.725314] Node 0 Normal: 25803*4kB (UME) 11297*8kB (UME) 947*16kB (UME) 260*32kB (ME) 72*64kB (UM) 15*128kB (UM) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 223844kB
[ 3630.773343] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 3630.799583] 858720 total pagecache pages
[ 3630.812261] 49221 pages in swap cache
[ 3630.824146] Swap cache stats: add 62319, delete 13131, find 75/76
[ 3630.843322] Free swap  = 15366388kB
[ 3630.854712] Total swap = 15616764kB
[ 3630.866101] 6215902 pages RAM
[ 3630.875919] 0 pages HighMem/MovableOnly
[ 3630.888342] 117753 pages reserved
[ 3630.899212] 4096 pages cma reserved
[ 3630.910604] 0 pages hwpoisoned
[ 3637.300184] bash: page allocation stalls for 28224ms, order:0, mode:0x14201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), nodemask=(null)
[ 3637.336505] bash cpuset=/ mems_allowed=0
[ 3637.349512] CPU: 2 PID: 9958 Comm: bash Tainted: G     U          4.11.1-amd64-preempt-sysrq-20170406 #4
[ 3637.378892] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 3637.407240] Call Trace:
[ 3637.415564]  dump_stack+0x61/0x7d
[ 3637.426501]  warn_alloc+0xfc/0x18c
[ 3637.437688]  __alloc_pages_slowpath+0x3bc/0xb31
[ 3637.452244]  ? __page_cache_alloc+0x8e/0xa4
[ 3637.465756]  __alloc_pages_nodemask+0x12c/0x1e0
[ 3637.480553]  alloc_pages_current+0x9b/0xbd
[ 3637.494051]  __page_cache_alloc+0x8e/0xa4
[ 3637.507288]  filemap_fault+0x298/0x3a7
[ 3637.519718]  __do_fault+0x1b/0x67
[ 3637.530838]  __handle_mm_fault+0x67f/0xa6f
[ 3637.544289]  handle_mm_fault+0x126/0x1d9
[ 3637.557153]  __do_page_fault+0x31a/0x43c
[ 3637.569996]  do_page_fault+0x25/0x27
[ 3637.581780]  page_fault+0x28/0x30
[ 3637.592746] RIP: 0023:0x8075060
[ 3637.603193] RSP: 002b:00000000ffcea1ac EFLAGS: 00010296
[ 3637.619854] RAX: 000000000923ee68 RBX: 000000000923ee68 RCX: 0000000000000000
[ 3637.642242] RDX: 000000000923eb48 RSI: 00000000000026f5 RDI: 0000000000000000
[ 3637.664599] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
[ 3637.686949] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[ 3637.709252] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 3637.731566] Mem-Info:
[ 3637.739527] active_anon:5273186 inactive_anon:378405 isolated_anon:3721
[ 3637.739527]  active_file:3713 inactive_file:3807 isolated_file:0
[ 3637.739527]  unevictable:1467 dirty:5068 writeback:49193 unstable:0
[ 3637.739527]  slab_reclaimable:8704 slab_unreclaimable:67298
[ 3637.739527]  mapped:556047 shmem:800887 pagetables:15777 bounce:0
[ 3637.739527]  free:89862 free_pcp:14 free_cma:0
[ 3637.850642] Node 0 active_anon:21092744kB inactive_anon:1513620kB active_file:14852kB inactive_file:15228kB unevictable:5868kB isolated(anon):14884kB isolated(file):0kB mapped:2224188kB dirty:20272kB writeback:196772kB shmem:3203548kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:39497 all_unreclaimable? no
[ 3637.947503] Node 0 DMA free:15880kB min:168kB low:208kB high:248kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15972kB managed:15888kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 3638.041435] lowmem_reserve[]: 0 3201 23768 23768 23768
[ 3638.058182] Node 0 DMA32 free:116768kB min:35424kB low:44280kB high:53136kB active_anon:3161376kB inactive_anon:8kB active_file:500kB inactive_file:152kB unevictable:0kB writepending:612kB present:3362068kB managed:3296500kB mlocked:0kB slab_reclaimable:460kB slab_unreclaimable:652kB kernel_stack:16kB pagetables:7292kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 3638.159998] lowmem_reserve[]: 0 0 20567 20567 20567
[ 3638.175886] Node 0 Normal free:226800kB min:226544kB low:283180kB high:339816kB active_anon:17931660kB inactive_anon:1513324kB active_file:14352kB inactive_file:15076kB unevictable:5868kB writepending:216868kB present:21485568kB managed:21080208kB mlocked:5868kB slab_reclaimable:34356kB slab_unreclaimable:268532kB kernel_stack:12480kB pagetables:55816kB bounce:0kB free_pcp:56kB local_pcp:0kB free_cma:0kB
[ 3638.286889] lowmem_reserve[]: 0 0 0 0 0
[ 3638.299205] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 3638.339959] Node 0 DMA32: 773*4kB (UME) 739*8kB (UME) 684*16kB (UME) 446*32kB (UME) 426*64kB (UME) 234*128k
[ 3638.390376] Node 0 Normal: 26236*4kB (UME) 11398*8kB (UME) 993*16kB (UME) 286*32kB (UME) 70*64kB (M) 14*128kB (UM) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 227696kB
[ 3638.438245] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 3638.464862] 858349 total pagecache pages
[ 3638.477801] 49221 pages in swap cache
[ 3638.489711] Swap cache stats: add 65079, delete 14676, find 75/76
[ 3638.489926] named: page allocation stalls for 31440ms, order:0, mode:0x14201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), nodemask=(null)
[ 3638.489929] named cpuset=/ mems_allowed=0
[ 3638.489932] CPU: 1 PID: 6298 Comm: named Tainted: G     U          4.11.1-amd64-preempt-sysrq-20170406 #4
[ 3638.489932] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 3638.489933] Call Trace:
[ 3638.489938]  dump_stack+0x61/0x7d
[ 3638.489940]  warn_alloc+0xfc/0x18c
[ 3638.489942]  __alloc_pages_slowpath+0x3bc/0xb31
[ 3638.489944]  __alloc_pages_nodemask+0x12c/0x1e0
[ 3638.489946]  alloc_pages_current+0x9b/0xbd
[ 3638.489948]  __page_cache_alloc+0x8e/0xa4
[ 3638.489949]  filemap_fault+0x298/0x3a7
[ 3638.489952]  __do_fault+0x1b/0x67
[ 3638.489953]  __handle_mm_fault+0x67f/0xa6f
[ 3638.489955]  handle_mm_fault+0x126/0x1d9
[ 3638.489957]  __do_page_fault+0x31a/0x43c
[ 3638.489958]  do_page_fault+0x25/0x27
[ 3638.489960]  page_fault+0x28/0x30
[ 3638.489961] RIP: 0033:0x7fa929835b50
[ 3638.489962] RSP: 002b:00007fa920ee0de8 EFLAGS: 00010202
[ 3638.489963] RAX: 0000000000000208 RBX: 0000000000000208 RCX: 00007fa928c85fd3
[ 3638.489963] RDX: 0000000000000000 RSI: 00007fa92bc84010 RDI: 000055c467ef6580
[ 3638.489964] RBP: 0000000000000001 R08: 00007fa929eb47f8 R09: 00000000fffffffe
[ 3638.489964] R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000005140
[ 3638.489964] R13: 0000000000000000 R14: 0000000000000001 R15: 00007fa92bc83010
[ 3638.616669] rfx-xpl-static: page allocation stalls for 30476ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
[ 3638.616672] rfx-xpl-static cpuset=/ mems_allowed=0
[ 3638.616676] CPU: 2 PID: 2296 Comm: rfx-xpl-static Tainted: G     U          4.11.1-amd64-preempt-sysrq-20170406 #4
[ 3638.616676] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 3638.616677] Call Trace:
[ 3638.616684]  dump_stack+0x61/0x7d
[ 3638.616686]  warn_alloc+0xfc/0x18c
[ 3638.616687] php5:
[ 3638.616688]  __alloc_pages_slowpath+0x3bc/0xb31
[ 3638.616689] page allocation stalls for 29296ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=
[ 3638.616693]  ? alloc_request_size+0x55/0x6d
[ 3638.616693] (null)
[ 3638.616694]  __alloc_pages_nodemask+0x12c/0x1e0
[ 3638.616695] php5 cpuset=/
[ 3638.616697]  alloc_pages_current+0x9b/0xbd
[ 3638.616698]  mems_allowed=0
[ 3638.616700]  __page_cache_alloc+0x8e/0xa4
[ 3638.616701]  pagecache_get_page+0xc9/0x16b
[ 3638.616704]  alloc_extent_buffer+0xdf/0x305
[ 3638.616708]  read_tree_block+0x19/0x4e
[ 3638.616709]  read_block_for_search.isra.21+0x211/0x264
[ 3638.616711]  btrfs_search_slot+0x52b/0x72e
[ 3638.616713]  btrfs_lookup_file_extent+0x49/0x5f
[ 3638.616715]  btrfs_get_extent+0x17d/0x77d
[ 3638.616717]  ? submit_extent_page+0x14b/0x1c8
[ 3638.616719]  ? __do_readpage+0x4fb/0x58d
[ 3638.616720]  __do_readpage+0x259/0x58d
[ 3638.616722]  ? insert_reserved_file_extent.constprop.41+0x28e/0x28e
[ 3638.616724]  __do_contiguous_readpages.constprop.33+0xc8/0xec
[ 3638.616725]  ? insert_reserved_file_extent.constprop.41+0x28e/0x28e
[ 3638.616727]  __extent_readpages.constprop.32+0xea/0xfd
[ 3638.616729]  ? lru_cache_add+0xe/0x10
[ 3638.616731]  extent_readpages+0x139/0x1eb
[ 3638.616732]  ? insert_reserved_file_extent.constprop.41+0x28e/0x28e
[ 3638.616734]  btrfs_readpages+0x1f/0x21
[ 3638.616736]  __do_page_cache_readahead+0x1af/0x27b
[ 3638.616737]  ? pagecache_get_page+0x2b/0x16b
[ 3638.616739]  filemap_fault+0x17f/0x3a7
[ 3638.616740]  ? filemap_fault+0x17f/0x3a7
[ 3638.616742]  ? balance_dirty_pages_ratelimited+0x251/0x29b
[ 3638.616744]  __do_fault+0x1b/0x67
[ 3638.616746]  __handle_mm_fault+0x90b/0xa6f
[ 3638.616748]  handle_mm_fault+0x126/0x1d9
[ 3638.616751]  __do_page_fault+0x31a/0x43c
[ 3638.616752]  do_page_fault+0x25/0x27
[ 3638.616755]  page_fault+0x28/0x30
[ 3638.616756] RIP: 0023:0x812bbe8
[ 3638.616757] RSP: 002b:00000000ffe16f10 EFLAGS: 00010246
[ 3638.616758] RAX: 0000000000000012 RBX: 0000000008208170 RCX: 0000000009fdd4f8
[ 3638.616758] RDX: 0000000000000000 RSI: 00000000000037e0 RDI: 00000000f6cb3000
[ 3638.616759] RBP: 00000000ffe16f38 R08: 0000000000000000 R09: 0000000000000000
[ 3638.616759] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 3638.616760] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
