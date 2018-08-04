Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42560 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbeHDFCN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 01:02:13 -0400
From: SeongJae Park <sj38.park@gmail.com>
Date: Sat, 4 Aug 2018 12:03:06 +0900 (KST)
To: Jens Axboe <axboe@kernel.dk>
cc: kernel test robot <xiaolong.ye@intel.com>,
        SeongJae Park <sj38.park@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kemi.wang@intel.com,
        OOChris Mason <clm@fb.com>
Subject: Re: [lkp-robot] [brd] 316ba5736c: aim7.jobs-per-min -11.2%
 regression
In-Reply-To: <852cf8d0-b1ca-b6aa-0721-488083443f2e@kernel.dk>
Message-ID: <alpine.DEB.2.20.1808040921210.1230@hxeon>
References: <20180604055259.GF16472@yexl-desktop> <852cf8d0-b1ca-b6aa-0721-488083443f2e@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="781441777-2109143274-1533351790=:1230"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--781441777-2109143274-1533351790=:1230
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT

Hello,

On Mon, 4 Jun 2018, Jens Axboe wrote:

> On 6/3/18 11:52 PM, kernel test robot wrote:
> >
> > Greeting,
> >
> > FYI, we noticed a -11.2% regression of aim7.jobs-per-min due to commit:
> >
> >
> > commit: 316ba5736c9caa5dbcd84085989862d2df57431d ("brd: Mark as non-rotational")
> > https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git for-4.18/block
> >
> > in testcase: aim7
> > on test machine: 40 threads Intel(R) Xeon(R) CPU E5-2690 v2 @ 3.00GHz with 384G memory
> > with following parameters:
> >
> > 	disk: 1BRD_48G
> > 	fs: btrfs
> > 	test: disk_rw
> > 	load: 1500
> > 	cpufreq_governor: performance
>
> Does this also happen on eg ext4 or xfs? If not, it might point to something in
> btrfs that ends up being worse for a device that isn't rotational.

Sorry for late response.

The regression is not reproducible with ext4.  Similar test using ext4
didn't showed such performance degradation (61483.81 jobs/min for
original, 60967.35 jobs/min for the patch applied version).  So the
cause of the regression would be in the btrfs.

The btrfs has optimizations for SSD; it enables the optimization if the
user gives 'ssd' mount option or the block device is marked as
'non-rotational', which I have set with the commit that incurred this
regression.

The profile result from the LKP roboy says that lock contention has
severely increased with the commit.  AFAIK, the optimizations are 1)
using 2 MiB size cluster rather than 64 KiB, and 2) busy-wait log
syncing.   The first optimization could increase critical section size,
and second one can increase locking contention because it doesn't
voluntarily unlock mutex.

So, I measured the jobs/min performance for 4.17.0 Linux kernel (orig),
4.17.0 Linux kernel with btrfs SSD optimization enabled (used 'ssd'
mount option) version (orig-opt), the patch applied version (brd-mod),
and the patch applied but btrfs SSD optimization disabled version
(brd-btrfs-mod).  If the SSD optimizations of btrfs was the reason, orig
and brd-btrfs-mod should have similar performance while orig-opt and
brd-mod have similar performance.  The results are as below:

orig	orig-opt	brd-mod		brd-btrfs-mod
22358	21403		18164		18856


The results say that the SSD optimization of the btrfs can degrade the
performance if it uses a brd as its disk.  However, it doesn't
completely explain the regression.

I will look about that more and report again, soon.


Thanks,
SeongJae Park

>
> CC'ing the btrfs guys, and leaving the rest of the email below.
>
> > test-description: AIM7 is a traditional UNIX system level benchmark suite which is used to test and measure the performance of multiuser system.
> > test-url: https://urldefense.proofpoint.com/v2/url?u=https-3A__sourceforge.net_projects_aimbench_files_aim-2Dsuite7_&d=DwIDAw&c=5VD0RTtNlTh3ycd41b3MUw&r=cK1a7KivzZRh1fKQMjSm2A&m=IKNYvfXb5tRluNV45DgoqZaSiffR8xKQObhRn_lf1zo&s=12WA2xKDvsfwuUtTCsanhmFyD3le2LUKfG5u-O5sChk&e=
> >
> >
> >
> > Details are as below:
> > -------------------------------------------------------------------------------------------------->
> >
> > =========================================================================================
> > compiler/cpufreq_governor/disk/fs/kconfig/load/rootfs/tbox_group/test/testcase:
> >   gcc-7/performance/1BRD_48G/btrfs/x86_64-rhel-7.2/1500/debian-x86_64-2016-08-31.cgz/lkp-ivb-ep01/disk_rw/aim7
> >
> > commit:
> >   522a777566 ("block: consolidate struct request timestamp fields")
> >   316ba5736c ("brd: Mark as non-rotational")
> >
> > 522a777566f56696 316ba5736c9caa5dbcd8408598
> > ---------------- --------------------------
> >          %stddev     %change         %stddev
> >              \          |                \
> >      28321           -11.2%      25147        aim7.jobs-per-min
> >     318.19           +12.6%     358.23        aim7.time.elapsed_time
> >     318.19           +12.6%     358.23        aim7.time.elapsed_time.max
> >    1437526 ±  2%     +14.6%    1646849 ±  2%  aim7.time.involuntary_context_switches
> >      11986           +14.2%      13691        aim7.time.system_time
> >      73.06 ±  2%      -3.6%      70.43        aim7.time.user_time
> >    2449470 ±  2%     -25.0%    1837521 ±  4%  aim7.time.voluntary_context_switches
> >      20.25 ± 58%   +1681.5%     360.75 ±109%  numa-meminfo.node1.Mlocked
> >     456062           -16.3%     381859        softirqs.SCHED
> >       9015 ±  7%     -21.3%       7098 ± 22%  meminfo.CmaFree
> >      47.50 ± 58%   +1355.8%     691.50 ± 92%  meminfo.Mlocked
> >       5.24 ±  3%      -1.2        3.99 ±  2%  mpstat.cpu.idle%
> >       0.61 ±  2%      -0.1        0.52 ±  2%  mpstat.cpu.usr%
> >      16627           +12.8%      18762 ±  4%  slabinfo.Acpi-State.active_objs
> >      16627           +12.9%      18775 ±  4%  slabinfo.Acpi-State.num_objs
> >      57.00 ±  2%     +17.5%      67.00        vmstat.procs.r
> >      20936           -24.8%      15752 ±  2%  vmstat.system.cs
> >      45474            -1.7%      44681        vmstat.system.in
> >       6.50 ± 59%   +1157.7%      81.75 ± 75%  numa-vmstat.node0.nr_mlock
> >     242870 ±  3%     +13.2%     274913 ±  7%  numa-vmstat.node0.nr_written
> >       2278 ±  7%     -22.6%       1763 ± 21%  numa-vmstat.node1.nr_free_cma
> >       4.75 ± 58%   +1789.5%      89.75 ±109%  numa-vmstat.node1.nr_mlock
> >   88018135 ±  3%     -48.9%   44980457 ±  7%  cpuidle.C1.time
> >    1398288 ±  3%     -51.1%     683493 ±  9%  cpuidle.C1.usage
> >    3499814 ±  2%     -38.5%    2153158 ±  5%  cpuidle.C1E.time
> >      52722 ±  4%     -45.6%      28692 ±  6%  cpuidle.C1E.usage
> >    9865857 ±  3%     -40.1%    5905155 ±  5%  cpuidle.C3.time
> >      69656 ±  2%     -42.6%      39990 ±  5%  cpuidle.C3.usage
> >     590856 ±  2%     -12.3%     517910        cpuidle.C6.usage
> >      46160 ±  7%     -53.7%      21372 ± 11%  cpuidle.POLL.time
> >       1716 ±  7%     -46.6%     916.25 ± 14%  cpuidle.POLL.usage
> >     197656            +4.1%     205732        proc-vmstat.nr_active_file
> >     191867            +4.1%     199647        proc-vmstat.nr_dirty
> >     509282            +1.6%     517318        proc-vmstat.nr_file_pages
> >       2282 ±  8%     -24.4%       1725 ± 22%  proc-vmstat.nr_free_cma
> >     357.50           +10.6%     395.25 ±  2%  proc-vmstat.nr_inactive_file
> >      11.50 ± 58%   +1397.8%     172.25 ± 93%  proc-vmstat.nr_mlock
> >     970355 ±  4%     +14.6%    1111549 ±  8%  proc-vmstat.nr_written
> >     197984            +4.1%     206034        proc-vmstat.nr_zone_active_file
> >     357.50           +10.6%     395.25 ±  2%  proc-vmstat.nr_zone_inactive_file
> >     192282            +4.1%     200126        proc-vmstat.nr_zone_write_pending
> >    7901465 ±  3%     -14.0%    6795016 ± 16%  proc-vmstat.pgalloc_movable
> >     886101           +10.2%     976329        proc-vmstat.pgfault
> >  2.169e+12           +15.2%  2.497e+12        perf-stat.branch-instructions
> >       0.41            -0.1        0.35        perf-stat.branch-miss-rate%
> >      31.19 ±  2%      +1.6       32.82        perf-stat.cache-miss-rate%
> >  9.116e+09            +8.3%  9.869e+09        perf-stat.cache-misses
> >  2.924e+10            +2.9%  3.008e+10 ±  2%  perf-stat.cache-references
> >    6712739 ±  2%     -15.4%    5678643 ±  2%  perf-stat.context-switches
> >       4.02            +2.7%       4.13        perf-stat.cpi
> >  3.761e+13           +17.3%  4.413e+13        perf-stat.cpu-cycles
> >     606958           -13.7%     523758 ±  2%  perf-stat.cpu-migrations
> >  2.476e+12           +13.4%  2.809e+12        perf-stat.dTLB-loads
> >       0.18 ±  2%      -0.0        0.16 ±  9%  perf-stat.dTLB-store-miss-rate%
> >  1.079e+09 ±  2%      -9.6%  9.755e+08 ±  9%  perf-stat.dTLB-store-misses
> >  5.933e+11            +1.6%  6.029e+11        perf-stat.dTLB-stores
> >  9.349e+12           +14.2%  1.068e+13        perf-stat.instructions
> >      11247 ± 11%     +19.8%      13477 ±  9%  perf-stat.instructions-per-iTLB-miss
> >       0.25            -2.6%       0.24        perf-stat.ipc
> >     865561           +10.3%     954350        perf-stat.minor-faults
> >  2.901e+09 ±  3%      +9.8%  3.186e+09 ±  3%  perf-stat.node-load-misses
> >  3.682e+09 ±  3%     +11.0%  4.088e+09 ±  3%  perf-stat.node-loads
> >  3.778e+09            +4.8%  3.959e+09 ±  2%  perf-stat.node-store-misses
> >  5.079e+09            +6.4%  5.402e+09        perf-stat.node-stores
> >     865565           +10.3%     954352        perf-stat.page-faults
> >      51.75 ±  5%     -12.5%      45.30 ± 10%  sched_debug.cfs_rq:/.load_avg.avg
> >     316.35 ±  3%     +17.2%     370.81 ±  8%  sched_debug.cfs_rq:/.util_est_enqueued.stddev
> >      15294 ± 30%    +234.9%      51219 ± 76%  sched_debug.cpu.avg_idle.min
> >     299443 ±  3%      -7.3%     277566 ±  5%  sched_debug.cpu.avg_idle.stddev
> >       1182 ± 19%     -26.3%     872.02 ± 13%  sched_debug.cpu.nr_load_updates.stddev
> >       1.22 ±  8%     +21.7%       1.48 ±  6%  sched_debug.cpu.nr_running.avg
> >       2.75 ± 10%     +26.2%       3.47 ±  6%  sched_debug.cpu.nr_running.max
> >       0.58 ±  7%     +24.2%       0.73 ±  6%  sched_debug.cpu.nr_running.stddev
> >      77148           -20.0%      61702 ±  7%  sched_debug.cpu.nr_switches.avg
> >      70024           -24.8%      52647 ±  8%  sched_debug.cpu.nr_switches.min
> >       6662 ±  6%     +61.9%      10789 ± 24%  sched_debug.cpu.nr_switches.stddev
> >      80.45 ± 18%     -19.1%      65.05 ±  6%  sched_debug.cpu.nr_uninterruptible.stddev
> >      76819           -19.3%      62008 ±  8%  sched_debug.cpu.sched_count.avg
> >      70616           -23.5%      53996 ±  8%  sched_debug.cpu.sched_count.min
> >       5494 ±  9%     +85.3%      10179 ± 26%  sched_debug.cpu.sched_count.stddev
> >      16936           -52.9%       7975 ±  9%  sched_debug.cpu.sched_goidle.avg
> >      19281           -49.9%       9666 ±  7%  sched_debug.cpu.sched_goidle.max
> >      15417           -54.8%       6962 ± 10%  sched_debug.cpu.sched_goidle.min
> >     875.00 ±  6%     -35.0%     569.09 ± 13%  sched_debug.cpu.sched_goidle.stddev
> >      40332           -23.5%      30851 ±  7%  sched_debug.cpu.ttwu_count.avg
> >      35074           -26.3%      25833 ±  6%  sched_debug.cpu.ttwu_count.min
> >       3239 ±  8%     +67.4%       5422 ± 28%  sched_debug.cpu.ttwu_count.stddev
> >       5232           +27.4%       6665 ± 13%  sched_debug.cpu.ttwu_local.avg
> >      15877 ± 12%     +77.5%      28184 ± 27%  sched_debug.cpu.ttwu_local.max
> >       2530 ± 10%     +95.9%       4956 ± 27%  sched_debug.cpu.ttwu_local.stddev
> >       2.52 ±  7%      -0.6        1.95 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_dirty_pages.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write.vfs_write
> >       1.48 ± 12%      -0.5        1.01 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_get_extent.btrfs_dirty_pages.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write
> >       1.18 ± 16%      -0.4        0.76 ±  7%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_file_extent.btrfs_get_extent.btrfs_dirty_pages.__btrfs_buffered_write
> >       1.18 ± 16%      -0.4        0.76 ±  7%  perf-profile.calltrace.cycles-pp.btrfs_lookup_file_extent.btrfs_get_extent.btrfs_dirty_pages.__btrfs_buffered_write.btrfs_file_write_iter
> >       0.90 ± 17%      -0.3        0.56 ±  4%  perf-profile.calltrace.cycles-pp.__dentry_kill.dentry_kill.dput.__fput.task_work_run
> >       0.90 ± 17%      -0.3        0.56 ±  4%  perf-profile.calltrace.cycles-pp.evict.__dentry_kill.dentry_kill.dput.__fput
> >       0.90 ± 17%      -0.3        0.56 ±  4%  perf-profile.calltrace.cycles-pp.dentry_kill.dput.__fput.task_work_run.exit_to_usermode_loop
> >       0.90 ± 18%      -0.3        0.56 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_evict_inode.evict.__dentry_kill.dentry_kill.dput
> >       0.90 ± 17%      -0.3        0.57 ±  5%  perf-profile.calltrace.cycles-pp.exit_to_usermode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >       0.90 ± 17%      -0.3        0.57 ±  5%  perf-profile.calltrace.cycles-pp.task_work_run.exit_to_usermode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >       0.90 ± 17%      -0.3        0.57 ±  5%  perf-profile.calltrace.cycles-pp.__fput.task_work_run.exit_to_usermode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >       0.90 ± 17%      -0.3        0.57 ±  5%  perf-profile.calltrace.cycles-pp.dput.__fput.task_work_run.exit_to_usermode_loop.do_syscall_64
> >       1.69            -0.1        1.54 ±  2%  perf-profile.calltrace.cycles-pp.lock_and_cleanup_extent_if_need.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write.vfs_write
> >       0.87 ±  4%      -0.1        0.76 ±  2%  perf-profile.calltrace.cycles-pp.__clear_extent_bit.clear_extent_bit.lock_and_cleanup_extent_if_need.__btrfs_buffered_write.btrfs_file_write_iter
> >       0.87 ±  4%      -0.1        0.76 ±  2%  perf-profile.calltrace.cycles-pp.clear_extent_bit.lock_and_cleanup_extent_if_need.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write
> >       0.71 ±  6%      -0.1        0.61 ±  2%  perf-profile.calltrace.cycles-pp.clear_state_bit.__clear_extent_bit.clear_extent_bit.lock_and_cleanup_extent_if_need.__btrfs_buffered_write
> >       0.69 ±  6%      -0.1        0.60 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_clear_bit_hook.clear_state_bit.__clear_extent_bit.clear_extent_bit.lock_and_cleanup_extent_if_need
> >      96.77            +0.6       97.33        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
> >       0.00            +0.6        0.56 ±  3%  perf-profile.calltrace.cycles-pp.can_overcommit.reserve_metadata_bytes.btrfs_delalloc_reserve_metadata.__btrfs_buffered_write.btrfs_file_write_iter
> >      96.72            +0.6       97.29        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >      43.13            +0.8       43.91        perf-profile.calltrace.cycles-pp.btrfs_inode_rsv_release.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write.vfs_write
> >      42.37            +0.8       43.16        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.block_rsv_release_bytes.btrfs_inode_rsv_release.__btrfs_buffered_write
> >      43.11            +0.8       43.89        perf-profile.calltrace.cycles-pp.block_rsv_release_bytes.btrfs_inode_rsv_release.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write
> >      42.96            +0.8       43.77        perf-profile.calltrace.cycles-pp._raw_spin_lock.block_rsv_release_bytes.btrfs_inode_rsv_release.__btrfs_buffered_write.btrfs_file_write_iter
> >      95.28            +0.9       96.23        perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >      95.22            +1.0       96.18        perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >      94.88            +1.0       95.85        perf-profile.calltrace.cycles-pp.__vfs_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >      94.83            +1.0       95.80        perf-profile.calltrace.cycles-pp.btrfs_file_write_iter.__vfs_write.vfs_write.ksys_write.do_syscall_64
> >      94.51            +1.0       95.50        perf-profile.calltrace.cycles-pp.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write.vfs_write.ksys_write
> >      42.44            +1.1       43.52        perf-profile.calltrace.cycles-pp._raw_spin_lock.reserve_metadata_bytes.btrfs_delalloc_reserve_metadata.__btrfs_buffered_write.btrfs_file_write_iter
> >      42.09            +1.1       43.18        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.reserve_metadata_bytes.btrfs_delalloc_reserve_metadata.__btrfs_buffered_write
> >      44.07            +1.2       45.29        perf-profile.calltrace.cycles-pp.btrfs_delalloc_reserve_metadata.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write.vfs_write
> >      43.42            +1.3       44.69        perf-profile.calltrace.cycles-pp.reserve_metadata_bytes.btrfs_delalloc_reserve_metadata.__btrfs_buffered_write.btrfs_file_write_iter.__vfs_write
> >       2.06 ± 18%      -0.9        1.21 ±  6%  perf-profile.children.cycles-pp.btrfs_search_slot
> >       2.54 ±  7%      -0.6        1.96 ±  3%  perf-profile.children.cycles-pp.btrfs_dirty_pages
> >       1.05 ± 24%      -0.5        0.52 ±  9%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
> >       1.50 ± 12%      -0.5        1.03 ±  4%  perf-profile.children.cycles-pp.btrfs_get_extent
> >       1.22 ± 15%      -0.4        0.79 ±  8%  perf-profile.children.cycles-pp.btrfs_lookup_file_extent
> >       0.81 ±  5%      -0.4        0.41 ±  6%  perf-profile.children.cycles-pp.btrfs_calc_reclaim_metadata_size
> >       0.74 ± 24%      -0.4        0.35 ±  9%  perf-profile.children.cycles-pp.btrfs_lock_root_node
> >       0.74 ± 24%      -0.4        0.35 ±  9%  perf-profile.children.cycles-pp.btrfs_tree_lock
> >       0.90 ± 17%      -0.3        0.56 ±  4%  perf-profile.children.cycles-pp.__dentry_kill
> >       0.90 ± 17%      -0.3        0.56 ±  4%  perf-profile.children.cycles-pp.evict
> >       0.90 ± 17%      -0.3        0.56 ±  4%  perf-profile.children.cycles-pp.dentry_kill
> >       0.90 ± 18%      -0.3        0.56 ±  4%  perf-profile.children.cycles-pp.btrfs_evict_inode
> >       0.91 ± 18%      -0.3        0.57 ±  4%  perf-profile.children.cycles-pp.exit_to_usermode_loop
> >       0.52 ± 20%      -0.3        0.18 ± 14%  perf-profile.children.cycles-pp.do_idle
> >       0.90 ± 17%      -0.3        0.57 ±  5%  perf-profile.children.cycles-pp.task_work_run
> >       0.90 ± 17%      -0.3        0.57 ±  5%  perf-profile.children.cycles-pp.__fput
> >       0.90 ± 18%      -0.3        0.57 ±  4%  perf-profile.children.cycles-pp.dput
> >       0.51 ± 20%      -0.3        0.18 ± 14%  perf-profile.children.cycles-pp.secondary_startup_64
> >       0.51 ± 20%      -0.3        0.18 ± 14%  perf-profile.children.cycles-pp.cpu_startup_entry
> >       0.50 ± 21%      -0.3        0.17 ± 16%  perf-profile.children.cycles-pp.start_secondary
> >       0.47 ± 20%      -0.3        0.16 ± 13%  perf-profile.children.cycles-pp.cpuidle_enter_state
> >       0.47 ± 19%      -0.3        0.16 ± 13%  perf-profile.children.cycles-pp.intel_idle
> >       0.61 ± 20%      -0.3        0.36 ± 11%  perf-profile.children.cycles-pp.btrfs_tree_read_lock
> >       0.47 ± 26%      -0.3        0.21 ± 10%  perf-profile.children.cycles-pp.prepare_to_wait_event
> >       0.64 ± 18%      -0.2        0.39 ±  9%  perf-profile.children.cycles-pp.btrfs_read_lock_root_node
> >       0.40 ± 22%      -0.2        0.21 ±  5%  perf-profile.children.cycles-pp.btrfs_clear_path_blocking
> >       0.38 ± 23%      -0.2        0.19 ± 13%  perf-profile.children.cycles-pp.finish_wait
> >       1.51 ±  3%      -0.2        1.35 ±  2%  perf-profile.children.cycles-pp.__clear_extent_bit
> >       1.71            -0.1        1.56 ±  2%  perf-profile.children.cycles-pp.lock_and_cleanup_extent_if_need
> >       0.29 ± 25%      -0.1        0.15 ± 10%  perf-profile.children.cycles-pp.btrfs_orphan_del
> >       0.27 ± 27%      -0.1        0.12 ±  8%  perf-profile.children.cycles-pp.btrfs_del_orphan_item
> >       0.33 ± 18%      -0.1        0.19 ±  9%  perf-profile.children.cycles-pp.queued_read_lock_slowpath
> >       0.33 ± 19%      -0.1        0.20 ±  4%  perf-profile.children.cycles-pp.__wake_up_common_lock
> >       0.45 ± 15%      -0.1        0.34 ±  2%  perf-profile.children.cycles-pp.btrfs_alloc_data_chunk_ondemand
> >       0.47 ± 16%      -0.1        0.36 ±  4%  perf-profile.children.cycles-pp.btrfs_check_data_free_space
> >       0.91 ±  4%      -0.1        0.81 ±  3%  perf-profile.children.cycles-pp.clear_extent_bit
> >       1.07 ±  5%      -0.1        0.97        perf-profile.children.cycles-pp.__set_extent_bit
> >       0.77 ±  6%      -0.1        0.69 ±  3%  perf-profile.children.cycles-pp.btrfs_clear_bit_hook
> >       0.17 ± 20%      -0.1        0.08 ± 10%  perf-profile.children.cycles-pp.queued_write_lock_slowpath
> >       0.16 ± 22%      -0.1        0.08 ± 24%  perf-profile.children.cycles-pp.btrfs_lookup_inode
> >       0.21 ± 17%      -0.1        0.14 ± 19%  perf-profile.children.cycles-pp.__btrfs_update_delayed_inode
> >       0.26 ± 12%      -0.1        0.18 ± 13%  perf-profile.children.cycles-pp.btrfs_async_run_delayed_root
> >       0.52 ±  5%      -0.1        0.45        perf-profile.children.cycles-pp.set_extent_bit
> >       0.45 ±  5%      -0.1        0.40 ±  3%  perf-profile.children.cycles-pp.alloc_extent_state
> >       0.11 ± 17%      -0.1        0.06 ± 11%  perf-profile.children.cycles-pp.btrfs_clear_lock_blocking_rw
> >       0.28 ±  9%      -0.0        0.23 ±  3%  perf-profile.children.cycles-pp.btrfs_drop_pages
> >       0.07            -0.0        0.03 ±100%  perf-profile.children.cycles-pp.btrfs_set_lock_blocking_rw
> >       0.39 ±  3%      -0.0        0.34 ±  3%  perf-profile.children.cycles-pp.get_alloc_profile
> >       0.33 ±  7%      -0.0        0.29        perf-profile.children.cycles-pp.btrfs_set_extent_delalloc
> >       0.38 ±  2%      -0.0        0.35 ±  4%  perf-profile.children.cycles-pp.__set_page_dirty_nobuffers
> >       0.49 ±  3%      -0.0        0.46 ±  3%  perf-profile.children.cycles-pp.pagecache_get_page
> >       0.18 ±  4%      -0.0        0.15 ±  2%  perf-profile.children.cycles-pp.truncate_inode_pages_range
> >       0.08 ±  5%      -0.0        0.05 ±  9%  perf-profile.children.cycles-pp.btrfs_set_path_blocking
> >       0.08 ±  6%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.truncate_cleanup_page
> >       0.80 ±  4%      +0.2        0.95 ±  2%  perf-profile.children.cycles-pp.can_overcommit
> >      96.84            +0.5       97.37        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
> >      96.80            +0.5       97.35        perf-profile.children.cycles-pp.do_syscall_64
> >      43.34            +0.8       44.17        perf-profile.children.cycles-pp.btrfs_inode_rsv_release
> >      43.49            +0.8       44.32        perf-profile.children.cycles-pp.block_rsv_release_bytes
> >      95.32            +0.9       96.26        perf-profile.children.cycles-pp.ksys_write
> >      95.26            +0.9       96.20        perf-profile.children.cycles-pp.vfs_write
> >      94.91            +1.0       95.88        perf-profile.children.cycles-pp.__vfs_write
> >      94.84            +1.0       95.81        perf-profile.children.cycles-pp.btrfs_file_write_iter
> >      94.55            +1.0       95.55        perf-profile.children.cycles-pp.__btrfs_buffered_write
> >      86.68            +1.0       87.70        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
> >      44.08            +1.2       45.31        perf-profile.children.cycles-pp.btrfs_delalloc_reserve_metadata
> >      43.49            +1.3       44.77        perf-profile.children.cycles-pp.reserve_metadata_bytes
> >      87.59            +1.8       89.38        perf-profile.children.cycles-pp._raw_spin_lock
> >       0.47 ± 19%      -0.3        0.16 ± 13%  perf-profile.self.cycles-pp.intel_idle
> >       0.33 ±  6%      -0.1        0.18 ±  6%  perf-profile.self.cycles-pp.get_alloc_profile
> >       0.27 ±  8%      -0.0        0.22 ±  4%  perf-profile.self.cycles-pp.btrfs_drop_pages
> >       0.07            -0.0        0.03 ±100%  perf-profile.self.cycles-pp.btrfs_set_lock_blocking_rw
> >       0.14 ±  5%      -0.0        0.12 ±  6%  perf-profile.self.cycles-pp.clear_page_dirty_for_io
> >       0.09 ±  5%      -0.0        0.07 ± 10%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
> >       0.17 ±  4%      +0.1        0.23 ±  3%  perf-profile.self.cycles-pp.reserve_metadata_bytes
> >       0.31 ±  7%      +0.1        0.45 ±  2%  perf-profile.self.cycles-pp.can_overcommit
> >      86.35            +1.0       87.39        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
> >
> >
> >
> >                                   aim7.jobs-per-min
> >
> >   29000 +-+-----------------------------------------------------------------+
> >   28500 +-+               +..   +                           +..+..  +..     |
> >         |..+    +.+..+.. :    .. +  .+.+..+..+.+.. .+..+.. +       +   +    |
> >   28000 +-+ + ..         :   +    +.              +       +       +         |
> >   27500 +-+  +          +                                                   |
> >         |                                                                   |
> >   27000 +-+                                                                 |
> >   26500 +-+                                                                 |
> >   26000 +-+                                                                 |
> >         |                                                                   |
> >   25500 +-+               O       O                               O O  O    |
> >   25000 +-+                     O    O         O  O O  O  O O               O
> >         |    O  O O     O    O         O                       O         O  |
> >   24500 O-+O         O                    O  O                              |
> >   24000 +-+-----------------------------------------------------------------+
> >
> >
> > [*] bisect-good sample
> > [O] bisect-bad  sample
> >
> >
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are provided
> > for informational purposes only. Any difference in system hardware or software
> > design or configuration may affect actual performance.
> >
> >
> > Thanks,
> > Xiaolong
> >
>
>
> --
> Jens Axboe
>
>
--781441777-2109143274-1533351790=:1230--
