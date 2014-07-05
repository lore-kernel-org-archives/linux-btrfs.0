Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52097 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604AbaGEOnd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jul 2014 10:43:33 -0400
Date: Sat, 5 Jul 2014 07:43:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Andrew E. Mileski" <andrewm@isoar.ca>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140705144318.GT26932@merlins.org>
References: <20140704011938.GO11539@merlins.org>
 <53B801DD.5040704@isoar.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NMuMz9nt05w80d4+"
In-Reply-To: <53B801DD.5040704@isoar.ca>
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 05, 2014 at 09:47:09AM -0400, Andrew E. Mileski wrote:
> On 2014-07-03 9:19 PM, Marc MERLIN wrote:
> >I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
> >running out of memory and deadlocking (panic= doesn't even work).
> >I downgraded back to 3.14, but I already had the problem once since then.
> 
> I didn't see any mention of the btrfs utility version in this thread
> (I may be blind though).
> 
> My server was suffering from frequent panics upon scrub / defrag /
> balance, until I updated the btrfs utility.  That resolved all my
> issues.

Really? The userland tool should only send ioctls to the kernel, I
really can't see how it would cause the kernel code to panic or not.

gargamel:~# btrfs --version
Btrfs v3.14.1
which is the latest in debian unstable.

As an update, after 1.7 days of scrubbing, the system has started
getting sluggish, I'm getting synchronization problems/crashes in some of
my tools that talk to serial ports (likely due to mini deadlocks in the
kernel), and I'm now getting a few btrfs hangs.

A lot of my RAM seems gone now (1GB free but only 500MB actually used by
user space), but the system is still up for now, just somewhat sluggish.
I've been told meminfo, slabinfo and zoneinfo may be useful to debug
that, so I'll attach them.
I see an interesting line about nf_conntrack and vmalloc in there. When
my scrub is done, I'll reboot and disable nf_conntrack just to see what
happens, and I'll also wait a bit to see how stable the RAM is before I
start more scrubs to see if scrubs do create memmory leaks.

slabinfo (attached) doesn't seem to show that btrfs owns a lot of
memory, but maybe I'm not sure how to read it.

gargamel:~# free
             total       used       free     shared    buffers     cached
Mem:       7894792    7370872     523920          0         28     564272
-/+ buffers/cache:    6806572    1088220
Swap:     15616764     483792   15132972


That one could be interesting, although just a a symptom of the memory
pressure:
[144323.739212] nf_conntrack: falling back to vmalloc.
[144323.757139] nf_conntrack: falling back to vmalloc.
[144323.778092] nf_conntrack: falling back to vmalloc.
[144323.797785] nf_conntrack: falling back to vmalloc.

Is it possible for btrfs to be hung on getting memory allocations?
Is a 2mn wait even possible for the right memory block to become
available?

[149171.560084] INFO: task btrfs:17366 blocked for more than 120 seconds.
[149171.582499]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[149171.604251] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[149171.630523] btrfs           D ffff88006897c980     0 17366  18362 0x00000080
[149171.654267]  ffff880083a51720 0000000000000086 ffff880083a51fd8 ffff88006897c450
[149171.679265]  00000000000141c0 ffff88006897c450 ffff88021f3941c0 ffff88006897c450
[149171.704141]  ffff880083a517c0 ffffffff810fe7a2 0000000000000002 ffff880083a51730
[149171.729093] Call Trace:
[149171.738754]  [<ffffffff810fe7a2>] ? wait_on_page_read+0x3c/0x3c
[149171.759582]  [<ffffffff8160d2a1>] schedule+0x73/0x75
[149171.776663]  [<ffffffff8160d446>] io_schedule+0x60/0x7a
[149171.794400]  [<ffffffff810fe7b0>] sleep_on_page+0xe/0x12
[149171.812292]  [<ffffffff8160d6d8>] __wait_on_bit+0x48/0x7a
[149171.830401]  [<ffffffff810fe750>] wait_on_page_bit+0x7a/0x7c
[149171.849307]  [<ffffffff8108514a>] ? autoremove_wake_function+0x34/0x34
[149171.871229]  [<ffffffff81246320>] read_extent_buffer_pages+0x1bf/0x204
[149171.892813]  [<ffffffff81223dc0>] ? free_root_pointers+0x5b/0x5b
[149171.912642]  [<ffffffff81224ac2>] btree_read_extent_buffer_pages.constprop.45+0x66/0x100
[149171.938737]  [<ffffffff81225a17>] read_tree_block+0x2f/0x47
[149171.957308]  [<ffffffff8120eb66>] read_block_for_search.isra.26+0x24a/0x287
[149171.980128]  [<ffffffff812103a7>] btrfs_search_slot+0x4f4/0x6bb
[149171.999679]  [<ffffffff8127174d>] scrub_stripe+0x43d/0xc9e
[149172.017930]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[149172.035901]  [<ffffffff81272084>] scrub_chunk.isra.9+0xd6/0x10d
[149172.055614]  [<ffffffff8127232f>] scrub_enumerate_chunks+0x274/0x418
[149172.076546]  [<ffffffff81085100>] ? finish_wait+0x4f/0x65
[149172.094506]  [<ffffffff81272a73>] btrfs_scrub_dev+0x254/0x3cb
[149172.113493]  [<ffffffff8116e31e>] ? __mnt_want_write+0x62/0x78
[149172.132714]  [<ffffffff81256314>] btrfs_ioctl+0x1114/0x24bd
[149172.151111]  [<ffffffff81015f07>] ? paravirt_sched_clock+0x9/0xd
[149172.170794]  [<ffffffff810164ad>] ? sched_clock+0x9/0xb
[149172.188107]  [<ffffffff8107b2fe>] ? sched_clock_cpu+0x1a/0xc5
[149172.207380]  [<ffffffff811409bd>] ? ____cache_alloc+0x1c/0x29b
[149172.226446]  [<ffffffff81140d2b>] ? kmem_cache_alloc_node+0xef/0x179
[149172.247033]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[149172.266018]  [<ffffffff81163ffe>] do_vfs_ioctl+0x3d2/0x41d
[149172.283939]  [<ffffffff8116c1f0>] ? __fget+0x6f/0x79
[149172.300268]  [<ffffffff81164099>] SyS_ioctl+0x50/0x7b
[149172.316818]  [<ffffffff8161642d>] system_call_fastpath+0x1a/0x1f


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=all-memory

Sat Jul  5 07:30:09 PDT 2014
MemTotal:        7894792 kB
MemFree:          489800 kB
MemAvailable:     929864 kB
Buffers:              28 kB
Cached:           581012 kB
SwapCached:        33024 kB
Active:           368028 kB
Inactive:         388080 kB
Active(anon):      81496 kB
Inactive(anon):    97180 kB
Active(file):     286532 kB
Inactive(file):   290900 kB
Unevictable:        5352 kB
Mlocked:            5352 kB
SwapTotal:      15616764 kB
SwapFree:       15136100 kB
Dirty:              1672 kB
Writeback:          3396 kB
AnonPages:        171784 kB
Mapped:            29572 kB
Shmem:               660 kB
Slab:             186660 kB
SReclaimable:      63132 kB
SUnreclaim:       123528 kB
KernelStack:        5184 kB
PageTables:        10040 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    19564160 kB
Committed_AS:    1717256 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      358996 kB
VmallocChunk:   34359281468 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      144920 kB
DirectMap2M:     7942144 kB




slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
pid_2                  0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
nfsd_drc               0      0    112   35    1 : tunables  120   60    8 : slabdata      0      0      0
nfsd4_delegations      0      0    368   11    1 : tunables   54   27    8 : slabdata      0      0      0
nfsd4_stateids         1     33    120   33    1 : tunables  120   60    8 : slabdata      1      1      0
nfsd4_files            1     31    128   31    1 : tunables  120   60    8 : slabdata      1      1      0
nfsd4_lockowners       0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
nfsd4_openowners       1     10    392   10    1 : tunables   54   27    8 : slabdata      1      1      0
nfs_direct_cache       0      0    208   19    1 : tunables  120   60    8 : slabdata      0      0      0
nfs_commit_data        4     11    704   11    2 : tunables   54   27    8 : slabdata      1      1      0
nfs_write_data        32     32    960    4    1 : tunables   54   27    8 : slabdata      8      8      0
nfs_read_data          0      0    896    4    1 : tunables   54   27    8 : slabdata      0      0      0
nfs_inode_cache        0      0   1016    4    1 : tunables   54   27    8 : slabdata      0      0      0
nfs_page               0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
fscache_cookie_jar      1     48     80   48    1 : tunables  120   60    8 : slabdata      1      1      0
rpc_inode_cache       15     18    640    6    1 : tunables   54   27    8 : slabdata      3      3      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    8 : slabdata      4      4      0
rpc_tasks              8     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
ext4_groupinfo_1k     61     62    128   31    1 : tunables  120   60    8 : slabdata      2      2      0
jbd2_1k                0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
dm_snap_pending_exception      0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
dm_exception           0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
raid5-md8          16384  16384   1936    2    1 : tunables   24   12    8 : slabdata   8192   8192      0
nf_conntrack_ffffffff81cc7380    269    507    304   13    1 : tunables   54   27    8 : slabdata     39     39      0
nf_conntrack_expect      0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fuse_request           9      9    408    9    1 : tunables   54   27    8 : slabdata      1      1      0
fuse_inode            94    100    768    5    1 : tunables   54   27    8 : slabdata     20     20      0
kvm_async_pf           0      0    136   29    1 : tunables  120   60    8 : slabdata      0      0      0
kvm_vcpu               0      0  16128    1    4 : tunables    8    4    0 : slabdata      0      0      0
kvm_mmu_page_header      0      0    168   23    1 : tunables  120   60    8 : slabdata      0      0      0
pte_list_desc          0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
bio-2                690   1530    256   15    1 : tunables  120   60    8 : slabdata    101    102    360
dm_crypt_io          708   1743    184   21    1 : tunables  120   60    8 : slabdata     82     83    300
kcopyd_job             0      0   3312    2    2 : tunables   24   12    8 : slabdata      0      0      0
io                     0      0     64   60    1 : tunables  120   60    8 : slabdata      0      0      0
dm_uevent              0      0   2608    3    2 : tunables   24   12    8 : slabdata      0      0      0
dm_rq_target_io        0      0    424    9    1 : tunables   54   27    8 : slabdata      0      0      0
dm_io                711   2511     40   93    1 : tunables  120   60    8 : slabdata     27     27    420
raid5-md5          16384  16384   1936    2    1 : tunables   24   12    8 : slabdata   8192   8192      0
btrfs_prelim_ref       4     48     80   48    1 : tunables  120   60    8 : slabdata      1      1      0
btrfs_delayed_extent_op    279    279     40   93    1 : tunables  120   60    8 : slabdata      3      3      0
btrfs_delayed_data_ref     96    200     96   40    1 : tunables  120   60    8 : slabdata      5      5      0
btrfs_delayed_tree_ref    264    264     88   44    1 : tunables  120   60    8 : slabdata      6      6      0
btrfs_delayed_ref_head    312    312    160   24    1 : tunables  120   60    8 : slabdata     13     13     60
btrfs_inode_defrag      0      0     64   60    1 : tunables  120   60    8 : slabdata      0      0      0
btrfs_delayed_node    447    871    304   13    1 : tunables   54   27    8 : slabdata     67     67      0
btrfs_ordered_extent      8     60    376   10    1 : tunables   54   27    8 : slabdata      4      6      0
btrfs_extent_map   46900  61854    152   26    1 : tunables  120   60    8 : slabdata   2379   2379    420
bio-1                333    912    320   12    1 : tunables   54   27    8 : slabdata     75     76    189
btrfs_extent_buffer  14930  16536    320   12    1 : tunables   54   27    8 : slabdata   1378   1378    162
btrfs_extent_state   3716  10400     96   40    1 : tunables  120   60    8 : slabdata    260    260    300
btrfs_delalloc_work      1     29    136   29    1 : tunables  120   60    8 : slabdata      1      1      0
btrfs_free_space   50084  54780     64   60    1 : tunables  120   60    8 : slabdata    913    913      0
btrfs_path           238    297    144   27    1 : tunables  120   60    8 : slabdata     11     11      0
btrfs_transaction     24     48    240   16    1 : tunables  120   60    8 : slabdata      3      3      0
btrfs_trans_handle     48     48    160   24    1 : tunables  120   60    8 : slabdata      2      2      0
btrfs_inode        12932  12932   1008    4    1 : tunables   54   27    8 : slabdata   3233   3233      0
fib6_nodes            13     60     64   60    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache         12     30    384   10    1 : tunables   54   27    8 : slabdata      3      3      0
ip6_mrt_cache          0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
PINGv6                 0      0   1088    7    2 : tunables   24   12    8 : slabdata      0      0      0
RAWv6                  7      7   1088    7    2 : tunables   24   12    8 : slabdata      1      1      0
UDPLITEv6              0      0   1088    7    2 : tunables   24   12    8 : slabdata      0      0      0
UDPv6                 12     35   1088    7    2 : tunables   24   12    8 : slabdata      5      5      0
tw_sock_TCPv6          0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                 30     30   1920    2    1 : tunables   24   12    8 : slabdata     15     15      0
flow_cache             0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_sense_cache     341    341    128   31    1 : tunables  120   60    8 : slabdata     11     11    180
scsi_cmd_cache       190    190    384   10    1 : tunables   54   27    8 : slabdata     19     19    108
sd_ext_cdb             2    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
i915_gem_object        9     10    384   10    1 : tunables   54   27    8 : slabdata      1      1      0
btree_node             0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_io_cq            828    924    120   33    1 : tunables  120   60    8 : slabdata     28     28      0
cfq_queue            859    884    232   17    1 : tunables  120   60    8 : slabdata     52     52      0
bsg_cmd                0      0    312   12    1 : tunables   54   27    8 : slabdata      0      0      0
mqueue_inode_cache      1      4    896    4    1 : tunables   54   27    8 : slabdata      1      1      0
hugetlbfs_inode_cache      1      7    584    7    1 : tunables   54   27    8 : slabdata      1      1      0
jbd2_transaction_s      0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_inode             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_journal_handle      0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_journal_head      0      0    112   35    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_revoke_table_s      2    204     16  204    1 : tunables  120   60    8 : slabdata      1      1      0
jbd2_revoke_record_s      0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_inode_cache     349    352    968    4    1 : tunables   54   27    8 : slabdata     88     88      0
ext4_xattr             0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_free_data         0      0     64   60    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_allocation_context      0      0    136   29    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_prealloc_space      0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_system_zone       0      0     40   93    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_io_end            0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_extent_status      8     93     40   93    1 : tunables  120   60    8 : slabdata      1      1      0
configfs_dir_cache      1     44     88   44    1 : tunables  120   60    8 : slabdata      1      1      0
dquot                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
kioctx                12     12    640    6    1 : tunables   54   27    8 : slabdata      2      2      0
kiocb                  0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
fanotify_event_info      0      0     64   60    1 : tunables  120   60    8 : slabdata      0      0      0
fanotify_response_event      0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_mark          0      0    112   35    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_inode_mark    122    165    120   33    1 : tunables  120   60    8 : slabdata      5      5      0
dnotify_mark           1     33    120   33    1 : tunables  120   60    8 : slabdata      1      1      0
dnotify_struct         1    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
dio                    0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
fasync_cache           0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
pid_namespace          0      0   2192    3    2 : tunables   24   12    8 : slabdata      0      0      0
user_namespace         0      0    264   15    1 : tunables   54   27    8 : slabdata      0      0      0
posix_timers_cache      0      0    248   16    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache             28     31    128   31    1 : tunables  120   60    8 : slabdata      1      1      0
UNIX                 204    204    896    4    1 : tunables   54   27    8 : slabdata     51     51      0
ip_mrt_cache           0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    896    4    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket      170    300     64   60    1 : tunables  120   60    8 : slabdata      5      5      0
inet_peer_cache      248    740    192   20    1 : tunables  120   60    8 : slabdata     37     37      0
secpath_cache          0      0     64   60    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_trie           22     68     56   68    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_alias          25     78     48   78    1 : tunables  120   60    8 : slabdata      1      1      0
ip_dst_cache          73    140    192   20    1 : tunables  120   60    8 : slabdata      7      7      0
PING                   0      0    896    4    1 : tunables   54   27    8 : slabdata      0      0      0
RAW                    6      8    896    4    1 : tunables   54   27    8 : slabdata      2      2      0
UDP                   75     76    896    4    1 : tunables   54   27    8 : slabdata     19     19      0
tw_sock_TCP           38    120    192   20    1 : tunables  120   60    8 : slabdata      6      6      0
request_sock_TCP      30     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
TCP                  108    108   1792    2    1 : tunables   24   12    8 : slabdata     54     54      0
eventpoll_pwq        265    265     72   53    1 : tunables  120   60    8 : slabdata      5      5      0
eventpoll_epi        120    248    128   31    1 : tunables  120   60    8 : slabdata      8      8      0
sgpool-128            49     49   4096    1    1 : tunables   24   12    8 : slabdata     49     49     12
sgpool-64             64     64   2048    2    1 : tunables   24   12    8 : slabdata     32     32     24
sgpool-32            112    112   1024    4    1 : tunables   54   27    8 : slabdata     28     28      0
sgpool-16             96     96    512    8    1 : tunables   54   27    8 : slabdata     12     12     27
sgpool-8             300    300    256   15    1 : tunables  120   60    8 : slabdata     20     20    120
scsi_data_buffer       0      0     24  146    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_integrity       0      0    112   35    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_queue          22     24   1896    2    1 : tunables   24   12    8 : slabdata     12     12      0
blkdev_requests      334    490    384   10    1 : tunables   54   27    8 : slabdata     49     49    189
blkdev_ioc           472    518    104   37    1 : tunables  120   60    8 : slabdata     14     14      0
bio-0               2430   3480    256   15    1 : tunables  120   60    8 : slabdata    232    232    420
biovec-256           315    376   4096    1    1 : tunables   24   12    8 : slabdata    315    376     96
biovec-128           109    160   2048    2    1 : tunables   24   12    8 : slabdata     80     80     60
biovec-64            341    352   1024    4    1 : tunables   54   27    8 : slabdata     88     88    189
biovec-16            210    210    256   15    1 : tunables  120   60    8 : slabdata     14     14     60
bio_integrity_payload      4     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
khugepaged_mm_slot      0      0     40   93    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_mm_slot            0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_stable_node        0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_rmap_item          0      0     64   60    1 : tunables  120   60    8 : slabdata      0      0      0
dmaengine-unmap-256      1      3   2112    3    2 : tunables   24   12    8 : slabdata      1      1      0
dmaengine-unmap-128      1      7   1088    7    2 : tunables   24   12    8 : slabdata      1      1      0
dmaengine-unmap-16      1     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
dmaengine-unmap-2      1     60     64   60    1 : tunables  120   60    8 : slabdata      1      1      0
sock_inode_cache     444    444    640    6    1 : tunables   54   27    8 : slabdata     74     74      0
skbuff_fclone_cache     56     56    512    7    1 : tunables   54   27    8 : slabdata      8      8      0
skbuff_head_cache    465    555    256   15    1 : tunables  120   60    8 : slabdata     37     37    180
file_lock_cache      120    120    192   20    1 : tunables  120   60    8 : slabdata      6      6      0
net_namespace          0      0   4352    1    2 : tunables    8    4    0 : slabdata      0      0      0
shmem_inode_cache   1745   1800    656    6    1 : tunables   54   27    8 : slabdata    300    300      0
ftrace_event_file   1197   1232     88   44    1 : tunables  120   60    8 : slabdata     28     28      0
ftrace_event_field   2781   2808     48   78    1 : tunables  120   60    8 : slabdata     36     36      0
pool_workqueue        39     75    256   15    1 : tunables  120   60    8 : slabdata      5      5      0
task_delay_info      880    910    112   35    1 : tunables  120   60    8 : slabdata     26     26      0
taskstats             36     36    328   12    1 : tunables   54   27    8 : slabdata      3      3      0
proc_inode_cache    4038   4038    632    6    1 : tunables   54   27    8 : slabdata    673    673      0
sigqueue             235    288    160   24    1 : tunables  120   60    8 : slabdata     12     12      7
bdev_cache            41     48    832    4    1 : tunables   54   27    8 : slabdata     12     12      0
kernfs_node_cache  29369  29535    120   33    1 : tunables  120   60    8 : slabdata    895    895      0
mnt_cache             58     72    320   12    1 : tunables   54   27    8 : slabdata      6      6      0
filp                5715   6000    256   15    1 : tunables  120   60    8 : slabdata    400    400    480
inode_cache         9527  10283    568    7    1 : tunables   54   27    8 : slabdata   1469   1469      0
dentry             46720  46720    192   20    1 : tunables  120   60    8 : slabdata   2336   2336      0
names_cache           77     77   4096    1    1 : tunables   24   12    8 : slabdata     77     77     24
key_jar                4     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
buffer_head           13    333    104   37    1 : tunables  120   60    8 : slabdata      9      9      0
nsproxy                1     78     48   78    1 : tunables  120   60    8 : slabdata      1      1      0
vm_area_struct     16239  17073    184   21    1 : tunables  120   60    8 : slabdata    813    813    360
mm_struct            364    364    960    4    1 : tunables   54   27    8 : slabdata     91     91      0
fs_cache             505    540     64   60    1 : tunables  120   60    8 : slabdata      9      9      0
files_cache          360    360    640    6    1 : tunables   54   27    8 : slabdata     60     60      0
signal_cache         602    602   1088    7    2 : tunables   24   12    8 : slabdata     86     86      0
sighand_cache        576    576   2112    3    2 : tunables   24   12    8 : slabdata    192    192      0
task_xstate          729    729    832    9    2 : tunables   54   27    8 : slabdata     81     81      0
task_struct          658    674   6304    1    2 : tunables    8    4    0 : slabdata    658    674      0
cred_jar            1408   1580    192   20    1 : tunables  120   60    8 : slabdata     79     79     60
Acpi-Operand        3606   3657     72   53    1 : tunables  120   60    8 : slabdata     69     69      0
Acpi-ParseExt         16     53     72   53    1 : tunables  120   60    8 : slabdata      1      1      0
Acpi-Parse            16     78     48   78    1 : tunables  120   60    8 : slabdata      1      1      0
Acpi-State            16     48     80   48    1 : tunables  120   60    8 : slabdata      1      1      0
Acpi-Namespace      1870   1953     40   93    1 : tunables  120   60    8 : slabdata     21     21      0
anon_vma_chain     17601  20220     64   60    1 : tunables  120   60    8 : slabdata    337    337    360
anon_vma           10261  11016     56   68    1 : tunables  120   60    8 : slabdata    162    162    180
pid                  851    961    128   31    1 : tunables  120   60    8 : slabdata     31     31      0
shared_policy_node      0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
numa_policy            3    146     24  146    1 : tunables  120   60    8 : slabdata      1      1      0
radix_tree_node    19286  20566    560    7    1 : tunables   54   27    8 : slabdata   2938   2938    135
idr_layer_cache      184    195   2112    3    2 : tunables   24   12    8 : slabdata     65     65      0
dma-kmalloc-4194304      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
dma-kmalloc-2097152      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
dma-kmalloc-1048576      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
dma-kmalloc-524288      0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
dma-kmalloc-262144      0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
dma-kmalloc-131072      0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
dma-kmalloc-65536      0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
dma-kmalloc-32768      0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
dma-kmalloc-16384      0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
dma-kmalloc-8192       0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
dma-kmalloc-4096       0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
dma-kmalloc-2048       0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
dma-kmalloc-1024       0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
dma-kmalloc-512        0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
dma-kmalloc-256        0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
dma-kmalloc-128        0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
dma-kmalloc-64         0      0     64   60    1 : tunables  120   60    8 : slabdata      0      0      0
dma-kmalloc-32         0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
dma-kmalloc-192        0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
dma-kmalloc-96         0      0    128   31    1 : tunables  120   60    8 : slabdata      0      0      0
kmalloc-4194304        0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
kmalloc-2097152        0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
kmalloc-1048576        0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
kmalloc-524288         0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
kmalloc-262144         0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
kmalloc-131072         4      4 131072    1   32 : tunables    8    4    0 : slabdata      4      4      0
kmalloc-65536          7      7  65536    1   16 : tunables    8    4    0 : slabdata      7      7      0
kmalloc-32768          2      2  32768    1    8 : tunables    8    4    0 : slabdata      2      2      0
kmalloc-16384        287    287  16384    1    4 : tunables    8    4    0 : slabdata    287    287      0
kmalloc-8192          37     37   8192    1    2 : tunables    8    4    0 : slabdata     37     37      0
kmalloc-4096        1355   1357   4096    1    1 : tunables   24   12    8 : slabdata   1355   1357     36
kmalloc-2048         947    956   2048    2    1 : tunables   24   12    8 : slabdata    478    478     12
kmalloc-1024        2864   2864   1024    4    1 : tunables   54   27    8 : slabdata    716    716      0
kmalloc-512         2439   2632    512    8    1 : tunables   54   27    8 : slabdata    329    329     27
kmalloc-256        11945  12105    256   15    1 : tunables  120   60    8 : slabdata    807    807      0
kmalloc-192         6880   6940    192   20    1 : tunables  120   60    8 : slabdata    347    347    120
kmalloc-96          3410   5208    128   31    1 : tunables  120   60    8 : slabdata    168    168    480
kmalloc-64         28688  34080     64   60    1 : tunables  120   60    8 : slabdata    568    568    180
kmalloc-128        12130  13795    128   31    1 : tunables  120   60    8 : slabdata    445    445    120
kmalloc-32         20274  25764     32  113    1 : tunables  120   60    8 : slabdata    228    228    480
kmem_cache           233    260    192   20    1 : tunables  120   60    8 : slabdata     13     13      0



Node 0, zone      DMA
  pages free     3840
        min      32
        low      40
        high     48
        scanned  0
        spanned  4095
        present  3995
        managed  3840
    nr_free_pages 3840
    nr_alloc_batch 8
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_vmscan_immediate_reclaim 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
    nr_dirtied   0
    nr_written   0
    numa_hit     16
    numa_miss    0
    numa_foreign 0
    numa_interleave 0
    numa_local   16
    numa_other   0
    nr_anon_transparent_hugepages 0
    nr_free_cma  0
        protection: (0, 3204, 7691, 7691)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 2
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 2
    cpu: 2
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 2
    cpu: 3
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 2
  all_unreclaimable: 1
  start_pfn:         1
  inactive_ratio:    1
Node 0, zone    DMA32
  pages free     106302
        min      7025
        low      8781
        high     10537
        scanned  0
        spanned  1044480
        present  840582
        managed  821238
    nr_free_pages 106302
    nr_alloc_batch 460
    nr_inactive_anon 23190
    nr_active_anon 19470
    nr_inactive_file 71852
    nr_active_file 70899
    nr_unevictable 569
    nr_mlock     569
    nr_anon_pages 41807
    nr_mapped    6552
    nr_file_pages 150284
    nr_dirty     328
    nr_writeback 0
    nr_slab_reclaimable 2314
    nr_slab_unreclaimable 2274
    nr_page_table_pages 1068
    nr_kernel_stack 376
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 138697
    nr_vmscan_immediate_reclaim 29869
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     62
    nr_dirtied   22352669
    nr_written   22020249
    numa_hit     1744799762
    numa_miss    0
    numa_foreign 0
    numa_interleave 0
    numa_local   1744799762
    numa_other   0
    nr_anon_transparent_hugepages 0
    nr_free_cma  0
        protection: (0, 0, 4486, 4486)
  pagesets
    cpu: 0
              count: 76
              high:  186
              batch: 31
  vm stats threshold: 36
    cpu: 1
              count: 92
              high:  186
              batch: 31
  vm stats threshold: 36
    cpu: 2
              count: 180
              high:  186
              batch: 31
  vm stats threshold: 36
    cpu: 3
              count: 60
              high:  186
              batch: 31
  vm stats threshold: 36
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    5
Node 0, zone   Normal
  pages free     12279
        min      9837
        low      12296
        high     14755
        scanned  0
        spanned  1177088
        present  1177088
        managed  1148620
    nr_free_pages 12279
    nr_alloc_batch 2448
    nr_inactive_anon 1105
    nr_active_anon 904
    nr_inactive_file 873
    nr_active_file 734
    nr_unevictable 769
    nr_mlock     769
    nr_anon_pages 1139
    nr_mapped    841
    nr_file_pages 3232
    nr_dirty     90
    nr_writeback 849
    nr_slab_reclaimable 13469
    nr_slab_unreclaimable 28608
    nr_page_table_pages 1442
    nr_kernel_stack 272
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 36540130
    nr_vmscan_immediate_reclaim 430109
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     103
    nr_dirtied   14670364
    nr_written   45400987
    numa_hit     2124679820
    numa_miss    0
    numa_foreign 0
    numa_interleave 11035
    numa_local   2124679820
    numa_other   0
    nr_anon_transparent_hugepages 0
    nr_free_cma  0
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 69
              high:  186
              batch: 31
  vm stats threshold: 42
    cpu: 1
              count: 166
              high:  186
              batch: 31
  vm stats threshold: 42
    cpu: 2
              count: 122
              high:  186
              batch: 31
  vm stats threshold: 42
    cpu: 3
              count: 157
              high:  186
              batch: 31
  vm stats threshold: 42
  all_unreclaimable: 0
  start_pfn:         1048576
  inactive_ratio:    6

--NMuMz9nt05w80d4+--
