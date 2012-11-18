Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eagle.jhcloos.com ([207.210.242.212]:43786 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2KRAjQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Nov 2012 19:39:16 -0500
From: James Cloos <cloos@jhcloos.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Likely mem leak in 3.7
In-Reply-To: <alpine.DEB.2.00.1211161115001.2788@chino.kir.corp.google.com>
	(David Rientjes's message of "Fri, 16 Nov 2012 11:17:07 -0800 (PST)")
References: <m3r4nuwipl.fsf@carbon.jhcloos.org>
	<alpine.DEB.2.00.1211161115001.2788@chino.kir.corp.google.com>
Date: Sat, 17 Nov 2012 19:29:18 -0500
Message-ID: <m31ufrg3d4.fsf@carbon.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "DR" == David Rientjes <rientjes@google.com> writes:

I had to reboot to get some work done.

In order to re-create the missing ram I had to use a btrfs fs for the
temp files for a few emerge(1) runs.  It seems that the ram which was
used for the cache of those temp files is not recovered when the files
are deleted?

Right now cached is about 4G smaller than typical on previous kernels.

I also notice that there are ten 1G maps (end of /proc/meminfo); I
wonder whether those end up used inefficiently?

I compared the output below to a capture on 3.6 about 1¾ hours after
boot; the numbers do not seem much different, although the btrfs slabs
have different names.

DR> 	echo m > /proc/sysrq-trigger

[95432.729187] SysRq : Show Memory
[95432.729192] Mem-Info:
[95432.729194] Node 0 DMA per-cpu:
[95432.729196] CPU    0: hi:    0, btch:   1 usd:   0
[95432.729198] CPU    1: hi:    0, btch:   1 usd:   0
[95432.729199] CPU    2: hi:    0, btch:   1 usd:   0
[95432.729200] CPU    3: hi:    0, btch:   1 usd:   0
[95432.729201] Node 0 DMA32 per-cpu:
[95432.729203] CPU    0: hi:  186, btch:  31 usd: 157
[95432.729205] CPU    1: hi:  186, btch:  31 usd: 184
[95432.729206] CPU    2: hi:  186, btch:  31 usd: 173
[95432.729207] CPU    3: hi:  186, btch:  31 usd: 181
[95432.729208] Node 0 Normal per-cpu:
[95432.729210] CPU    0: hi:  186, btch:  31 usd: 158
[95432.729211] CPU    1: hi:  186, btch:  31 usd: 157
[95432.729212] CPU    2: hi:  186, btch:  31 usd:  89
[95432.729214] CPU    3: hi:  186, btch:  31 usd: 122
[95432.729218] active_anon:965802 inactive_anon:174825 isolated_anon:0
 active_file:162783 inactive_file:223765 isolated_file:0
 unevictable:0 dirty:4486 writeback:315 unstable:0
 free:178576 slab_reclaimable:113370 slab_unreclaimable:8715
 mapped:949576 shmem:940282 pagetables:21020 bounce:0
 free_cma:0
[95432.729221] Node 0 DMA free:15864kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15880kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[95432.729226] lowmem_reserve[]: 0 3168 11682 11682
[95432.729229] Node 0 DMA32 free:376380kB min:18300kB low:22872kB high:27448kB active_anon:1551176kB inactive_anon:345756kB active_file:486140kB inactive_file:361936kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3244136kB mlocked:0kB dirty:1368kB writeback:88kB mapped:1883492kB shmem:1880344kB slab_reclaimable:157768kB slab_unreclaimable:3944kB kernel_stack:496kB pagetables:23592kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[95432.729235] lowmem_reserve[]: 0 0 8514 8514
[95432.729237] Node 0 Normal free:322060kB min:49188kB low:61484kB high:73780kB active_anon:2312032kB inactive_anon:353544kB active_file:164992kB inactive_file:533124kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:8718776kB mlocked:0kB dirty:16576kB writeback:1172kB mapped:1914812kB shmem:1880784kB slab_reclaimable:295712kB slab_unreclaimable:30900kB kernel_stack:3552kB pagetables:60488kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[95432.729242] lowmem_reserve[]: 0 0 0 0
[95432.729245] Node 0 DMA: 0*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15864kB
[95432.729252] Node 0 DMA32: 36923*4kB 15958*8kB 4599*16kB 741*32kB 27*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 376428kB
[95432.729258] Node 0 Normal: 35337*4kB 93927*8kB 46306*16kB 19127*32kB 6764*64kB 2788*128kB 1236*256kB 539*512kB 273*1024kB 84*2048kB 201*4096kB = 4902748kB
[95432.729265] 1329636 total pagecache pages
[95432.729267] 2823 pages in swap cache
[95432.729268] Swap cache stats: add 46261, delete 43438, find 709513/710665
[95432.729269] Free swap  = 3540840kB
[95432.729270] Total swap = 3670008kB
[95432.780343] 3080176 pages RAM
[95432.780345] 68408 pages reserved
[95432.780346] 7950465 pages shared
[95432.780347] 418322 pages non-shared

DR> 	zgrep CONFIG_SL[AU]B /proc/config.gz

CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLABINFO=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set

DR> 	cat /proc/slabinfo

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <object_size> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
ext4_groupinfo_1k     64     64    128   32    1 : tunables    0    0    0 : slabdata      2      2      0
fat_inode_cache       48     48    680   24    4 : tunables    0    0    0 : slabdata      2      2      0
fat_cache              0      0     40  102    1 : tunables    0    0    0 : slabdata      0      0      0
UDPLITEv6              0      0   1088   30    8 : tunables    0    0    0 : slabdata      0      0      0
UDPv6                120    120   1088   30    8 : tunables    0    0    0 : slabdata      4      4      0
tw_sock_TCPv6        128    128    256   32    2 : tunables    0    0    0 : slabdata      4      4      0
TCPv6                 80     80   1984   16    8 : tunables    0    0    0 : slabdata      5      5      0
nf_conntrack_ffffffff81cb7100    650    650    312   26    2 : tunables    0    0    0 : slabdata     25     25      0
dm_raid1_read_record      0      0   1064   30    8 : tunables    0    0    0 : slabdata      0      0      0
dm_snap_pending_exception      0      0    104   39    1 : tunables    0    0    0 : slabdata      0      0      0
kcopyd_job             0      0   3240   10    8 : tunables    0    0    0 : slabdata      0      0      0
dm_uevent              0      0   2608   12    8 : tunables    0    0    0 : slabdata      0      0      0
dm_rq_target_io        0      0    416   39    4 : tunables    0    0    0 : slabdata      0      0      0
bsg_cmd                0      0    312   26    2 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache     36     36    896   36    8 : tunables    0    0    0 : slabdata      1      1      0
btrfs_delayed_node   1913   5012    288   28    2 : tunables    0    0    0 : slabdata    179    179      0
btrfs_ordered_extent   2520   2520    224   36    2 : tunables    0    0    0 : slabdata     70     70      0
btrfs_extent_buffer   8103  10189    344   23    2 : tunables    0    0    0 : slabdata    443    443      0
btrfs_path           112    112    144   28    1 : tunables    0    0    0 : slabdata      4      4      0
btrfs_transaction    132    132    248   33    2 : tunables    0    0    0 : slabdata      4      4      0
btrfs_trans_handle    104    104    152   26    1 : tunables    0    0    0 : slabdata      4      4      0
btrfs_inode        22685  33915    992   33    8 : tunables    0    0    0 : slabdata   1091   1091      0
xfs_dquot              0      0    456   35    4 : tunables    0    0    0 : slabdata      0      0      0
xfs_ili              396    396    224   36    2 : tunables    0    0    0 : slabdata     11     11      0
xfs_inode           2500   3240    896   36    8 : tunables    0    0    0 : slabdata     90     90      0
xfs_efd_item         140    140    400   20    2 : tunables    0    0    0 : slabdata      7      7      0
xfs_trans            145    145    280   29    2 : tunables    0    0    0 : slabdata      5      5      0
xfs_da_state         132    132    488   33    4 : tunables    0    0    0 : slabdata      4      4      0
xfs_btree_cur        156    156    208   39    2 : tunables    0    0    0 : slabdata      4      4      0
xfs_log_ticket       132    132    184   22    1 : tunables    0    0    0 : slabdata      6      6      0
udf_inode_cache        0      0    656   24    4 : tunables    0    0    0 : slabdata      0      0      0
nfsd4_delegations      0      0    368   22    2 : tunables    0    0    0 : slabdata      0      0      0
nfsd4_openowners       0      0    392   20    2 : tunables    0    0    0 : slabdata      0      0      0
nfs_direct_cache       0      0    208   39    2 : tunables    0    0    0 : slabdata      0      0      0
nfs_write_data        68     68    960   34    8 : tunables    0    0    0 : slabdata      2      2      0
nfs_read_data          0      0    896   36    8 : tunables    0    0    0 : slabdata      0      0      0
nfs_inode_cache        0      0   1008   32    8 : tunables    0    0    0 : slabdata      0      0      0
isofs_inode_cache      0      0    600   27    4 : tunables    0    0    0 : slabdata      0      0      0
hugetlbfs_inode_cache    108    108    592   27    4 : tunables    0    0    0 : slabdata      4      4      0
jbd2_journal_handle    680    680     24  170    1 : tunables    0    0    0 : slabdata      4      4      0
jbd2_journal_head   3268   5040    112   36    1 : tunables    0    0    0 : slabdata    140    140      0
jbd2_revoke_record_s   2048   2048     32  128    1 : tunables    0    0    0 : slabdata     16     16      0
ext4_inode_cache  127369 282386    872   37    8 : tunables    0    0    0 : slabdata   8540   8540      0
ext4_xattr             0      0     88   46    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_free_data      8356   9216     64   64    1 : tunables    0    0    0 : slabdata    144    144      0
ext4_allocation_context  33967  36900    136   30    1 : tunables    0    0    0 : slabdata   1230   1230      0
ext4_io_end          186    331   1128   29    8 : tunables    0    0    0 : slabdata     15     15      0
ext4_io_page        6912   6912     16  256    1 : tunables    0    0    0 : slabdata     27     27      0
dquot                448    448    256   32    2 : tunables    0    0    0 : slabdata     14     14      0
dio                    0      0    640   25    4 : tunables    0    0    0 : slabdata      0      0      0
pid_namespace          0      0   2128   15    8 : tunables    0    0    0 : slabdata      0      0      0
posix_timers_cache    805    805    232   35    2 : tunables    0    0    0 : slabdata     23     23      0
kvm_async_pf           0      0    144   28    1 : tunables    0    0    0 : slabdata      0      0      0
kvm_vcpu               0      0  15168    2    8 : tunables    0    0    0 : slabdata      0      0      0
kvm_mmu_page_header      0      0    168   24    1 : tunables    0    0    0 : slabdata      0      0      0
rpc_inode_cache        0      0    640   25    4 : tunables    0    0    0 : slabdata      0      0      0
UDP-Lite               0      0    896   36    8 : tunables    0    0    0 : slabdata      0      0      0
ip_fib_trie          146    146     56   73    1 : tunables    0    0    0 : slabdata      2      2      0
UDP                  144    144    896   36    8 : tunables    0    0    0 : slabdata      4      4      0
tw_sock_TCP          315    315    192   21    1 : tunables    0    0    0 : slabdata     15     15      0
TCP                  126    126   1792   18    8 : tunables    0    0    0 : slabdata      7      7      0
blkdev_queue          48     48   1984   16    8 : tunables    0    0    0 : slabdata      3      3      0
blkdev_requests      151    252    376   21    2 : tunables    0    0    0 : slabdata     12     12      0
fsnotify_event_holder    680    680     24  170    1 : tunables    0    0    0 : slabdata      4      4      0
fsnotify_event       775   1360    120   34    1 : tunables    0    0    0 : slabdata     40     40      0
bip-256                7      7   4224    7    8 : tunables    0    0    0 : slabdata      1      1      0
bip-128                0      0   2176   15    8 : tunables    0    0    0 : slabdata      0      0      0
bip-64                 0      0   1152   28    8 : tunables    0    0    0 : slabdata      0      0      0
bip-16              1444   1743    384   21    2 : tunables    0    0    0 : slabdata     83     83      0
sock_inode_cache     750    750    640   25    4 : tunables    0    0    0 : slabdata     30     30      0
net_namespace          0      0   3392    9    8 : tunables    0    0    0 : slabdata      0      0      0
shmem_inode_cache   2327   3192    664   24    4 : tunables    0    0    0 : slabdata    133    133      0
Acpi-ParseExt       2968   2968     72   56    1 : tunables    0    0    0 : slabdata     53     53      0
Acpi-State           153    153     80   51    1 : tunables    0    0    0 : slabdata      3      3      0
Acpi-Namespace      1326   1326     40  102    1 : tunables    0    0    0 : slabdata     13     13      0
taskstats             96     96    328   24    2 : tunables    0    0    0 : slabdata      4      4      0
proc_inode_cache   17060  24180    616   26    4 : tunables    0    0    0 : slabdata    930    930      0
sigqueue             150    150    160   25    1 : tunables    0    0    0 : slabdata      6      6      0
bdev_cache           156    156    832   39    8 : tunables    0    0    0 : slabdata      4      4      0
sysfs_dir_cache    20736  20736    112   36    1 : tunables    0    0    0 : slabdata    576    576      0
inode_cache         9424  10034    552   29    4 : tunables    0    0    0 : slabdata    346    346      0
dentry            122342 133938    192   21    1 : tunables    0    0    0 : slabdata   6378   6378      0
buffer_head       329503 487851    104   39    1 : tunables    0    0    0 : slabdata  12509  12509      0
vm_area_struct     16636  17549    176   23    1 : tunables    0    0    0 : slabdata    763    763      0
mm_struct           1053   1053    832   39    8 : tunables    0    0    0 : slabdata     27     27      0
files_cache          575    575    704   23    4 : tunables    0    0    0 : slabdata     25     25      0
signal_cache         471    630   1088   30    8 : tunables    0    0    0 : slabdata     21     21      0
sighand_cache        377    435   2112   15    8 : tunables    0    0    0 : slabdata     29     29      0
task_struct          516    555   5904    5    8 : tunables    0    0    0 : slabdata    111    111      0
anon_vma            6890   6976     64   64    1 : tunables    0    0    0 : slabdata    109    109      0
shared_policy_node  36771  43520     48   85    1 : tunables    0    0    0 : slabdata    512    512      0
numa_policy          150    150    136   30    1 : tunables    0    0    0 : slabdata      5      5      0
radix_tree_node    52622 108612    568   28    4 : tunables    0    0    0 : slabdata   3879   3879      0
idr_layer_cache      600    600    544   30    4 : tunables    0    0    0 : slabdata     20     20      0
dma-kmalloc-8192       0      0   8192    4    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-4096       0      0   4096    8    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-2048       0      0   2048   16    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-1024       0      0   1024   32    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-512       32     32    512   32    4 : tunables    0    0    0 : slabdata      1      1      0
dma-kmalloc-256        0      0    256   32    2 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-128        0      0    128   32    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-64         0      0     64   64    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-32         0      0     32  128    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-16         0      0     16  256    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-8          0      0      8  512    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-192        0      0    192   21    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-96         0      0     96   42    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-8192          67     84   8192    4    8 : tunables    0    0    0 : slabdata     21     21      0
kmalloc-4096         399    520   4096    8    8 : tunables    0    0    0 : slabdata     65     65      0
kmalloc-2048         526    592   2048   16    8 : tunables    0    0    0 : slabdata     37     37      0
kmalloc-1024        2012   2560   1024   32    8 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-512         1815   1920    512   32    4 : tunables    0    0    0 : slabdata     60     60      0
kmalloc-256         7960   9280    256   32    2 : tunables    0    0    0 : slabdata    290    290      0
kmalloc-128         4383   5216    128   32    1 : tunables    0    0    0 : slabdata    163    163      0
kmalloc-64         20326  40576     64   64    1 : tunables    0    0    0 : slabdata    634    634      0
kmalloc-32          5760   5760     32  128    1 : tunables    0    0    0 : slabdata     45     45      0
kmalloc-16          5888   5888     16  256    1 : tunables    0    0    0 : slabdata     23     23      0
kmalloc-8          10752  10752      8  512    1 : tunables    0    0    0 : slabdata     21     21      0
kmalloc-192         4108   4935    192   21    1 : tunables    0    0    0 : slabdata    235    235      0
kmalloc-96          4701   6762     96   42    1 : tunables    0    0    0 : slabdata    161    161      0
kmem_cache           224    224    256   32    2 : tunables    0    0    0 : slabdata      7      7      0
kmem_cache_node      320    320     64   64    1 : tunables    0    0    0 : slabdata      5      5      0

free(1) reports:

             total       used       free     shared    buffers     cached
Mem:      12047072   11705824     341248          0     174252    5542092
-/+ buffers/cache:    5989480    6057592
Swap:      3670008     129832    3540176

So the missing ram is un used (2nd row totals 12047072).

I tried creating and deleting a large (1G) file on an ext4 and the xfs
partition; the ram moved from cached to free in top(1).  Doing the same
thing on a btrfs partition lost about 200M of ram.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
