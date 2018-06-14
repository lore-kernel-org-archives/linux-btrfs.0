Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8613 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935633AbeFNBhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Jun 2018 21:37:52 -0400
From: "Huang\, Ying" <ying.huang@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        "lkp\@01.org" <lkp@01.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: [LKP] [lkp-robot] [mm] 9092c71bb7: blogbench.write_score -12.3% regression
References: <20180408015739.GN3845@yexl-desktop>
        <876036apgx.fsf@yhuang-dev.intel.com>
        <878t7t3k3s.fsf@yhuang-dev.intel.com>
Date: Thu, 14 Jun 2018 09:37:50 +0800
In-Reply-To: <878t7t3k3s.fsf@yhuang-dev.intel.com> (Ying Huang's message of
        "Tue, 05 Jun 2018 12:58:31 +0800")
Message-ID: <87h8m6m9ld.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping again ...

"Huang, Ying" <ying.huang@intel.com> writes:

> Ping...
>
> "Huang, Ying" <ying.huang@intel.com> writes:
>
>> Hi, Josef,
>>
>> Do you have time to take a look at the regression?
>>
>> kernel test robot <xiaolong.ye@intel.com> writes:
>>
>>> Greeting,
>>>
>>> FYI, we noticed a -12.3% regression of blogbench.write_score and a +9.6% improvement
>>> of blogbench.read_score due to commit:
>>>
>>>
>>> commit: 9092c71bb724dba2ecba849eae69e5c9d39bd3d2 ("mm: use sc->priority for slab shrink targets")
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>>
>>> in testcase: blogbench
>>> on test machine: 16 threads Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz with 8G memory
>>> with following parameters:
>>>
>>> 	disk: 1SSD
>>> 	fs: btrfs
>>> 	cpufreq_governor: performance
>>>
>>> test-description: Blogbench is a portable filesystem benchmark that tries to reproduce the load of a real-world busy file server.
>>> test-url: https://www.pureftpd.org/project/blogbench
>>>
>>>
>>>
>>> Details are as below:
>>> -------------------------------------------------------------------------------------------------->
>>>
>>>
>>> To reproduce:
>>>
>>>         git clone https://github.com/intel/lkp-tests.git
>>>         cd lkp-tests
>>>         bin/lkp install job.yaml  # job file is attached in this email
>>>         bin/lkp run     job.yaml
>>>
>>> =========================================================================================
>>> compiler/cpufreq_governor/disk/fs/kconfig/rootfs/tbox_group/testcase:
>>>   gcc-7/performance/1SSD/btrfs/x86_64-rhel-7.2/debian-x86_64-2016-08-31.cgz/lkp-bdw-de1/blogbench
>>>
>>> commit: 
>>>   fcb2b0c577 ("mm: show total hugetlb memory consumption in /proc/meminfo")
>>>   9092c71bb7 ("mm: use sc->priority for slab shrink targets")
>>>
>>> fcb2b0c577f145c7 9092c71bb724dba2ecba849eae 
>>> ---------------- -------------------------- 
>>>          %stddev     %change         %stddev
>>>              \          |                \  
>>>       3256           -12.3%       2854        blogbench.write_score
>>>    1235237   2%      +9.6%    1354163        blogbench.read_score
>>>   28050912           -10.1%   25212230        blogbench.time.file_system_outputs
>>>    6481995   3%     +25.0%    8105320   2%  blogbench.time.involuntary_context_switches
>>>     906.00           +13.7%       1030        blogbench.time.percent_of_cpu_this_job_got
>>>       2552           +14.0%       2908        blogbench.time.system_time
>>>     173.80            +8.4%     188.32        blogbench.time.user_time
>>>   19353936            +3.6%   20045728        blogbench.time.voluntary_context_switches
>>>    8719514           +13.0%    9850451        softirqs.RCU
>>>       2.97   5%      -0.7        2.30   3%  mpstat.cpu.idle%
>>>      24.92            -6.5       18.46        mpstat.cpu.iowait%
>>>       0.65   2%      +0.1        0.75        mpstat.cpu.soft%
>>>      67.76            +6.7       74.45        mpstat.cpu.sys%
>>>      50206           -10.7%      44858        vmstat.io.bo
>>>      49.25            -9.1%      44.75   2%  vmstat.procs.b
>>>     224125            -1.8%     220135        vmstat.system.cs
>>>      48903           +10.7%      54134        vmstat.system.in
>>>    3460654           +10.8%    3834883        meminfo.Active
>>>    3380666           +11.0%    3752872        meminfo.Active(file)
>>>    1853849           -17.4%    1530415        meminfo.Inactive
>>>    1836507           -17.6%    1513054        meminfo.Inactive(file)
>>>     551311           -10.3%     494265        meminfo.SReclaimable
>>>     196525           -12.6%     171775        meminfo.SUnreclaim
>>>     747837           -10.9%     666040        meminfo.Slab
>>>  8.904e+08           -24.9%  6.683e+08        cpuidle.C1.time
>>>   22971020           -12.8%   20035820        cpuidle.C1.usage
>>>  2.518e+08   3%     -31.7%   1.72e+08        cpuidle.C1E.time
>>>     821393   2%     -33.3%     548003        cpuidle.C1E.usage
>>>   75460078   2%     -23.3%   57903768   2%  cpuidle.C3.time
>>>     136506   3%     -25.3%     101956   3%  cpuidle.C3.usage
>>>   56892498   4%     -23.3%   43608427   4%  cpuidle.C6.time
>>>      85034   3%     -33.9%      56184   3%  cpuidle.C6.usage
>>>   24373567           -24.5%   18395538        cpuidle.POLL.time
>>>     449033   2%     -10.8%     400493        cpuidle.POLL.usage
>>>       1832            +9.3%       2002        turbostat.Avg_MHz
>>>   22967645           -12.8%   20032521        turbostat.C1
>>>      18.43            -4.6       13.85        turbostat.C1%
>>>     821328   2%     -33.3%     547948        turbostat.C1E
>>>       5.21   3%      -1.6        3.56        turbostat.C1E%
>>>     136377   3%     -25.3%     101823   3%  turbostat.C3
>>>       1.56   2%      -0.4        1.20   3%  turbostat.C3%
>>>      84404   3%     -34.0%      55743   3%  turbostat.C6
>>>       1.17   4%      -0.3        0.90   4%  turbostat.C6%
>>>      25.93           -26.2%      19.14        turbostat.CPU%c1
>>>       0.12   3%     -19.1%       0.10   9%  turbostat.CPU%c3
>>>   14813304           +10.7%   16398388        turbostat.IRQ
>>>      38.19            +3.6%      39.56        turbostat.PkgWatt
>>>       4.51            +4.5%       4.71        turbostat.RAMWatt
>>>    8111200  13%     -63.2%    2986242  48%  proc-vmstat.compact_daemon_free_scanned
>>>    1026719  30%     -81.2%     193485  30%  proc-vmstat.compact_daemon_migrate_scanned
>>>       2444  21%     -63.3%     897.50  20%  proc-vmstat.compact_daemon_wake
>>>    8111200  13%     -63.2%    2986242  48%  proc-vmstat.compact_free_scanned
>>>     755491  32%     -81.6%     138856  28%  proc-vmstat.compact_isolated
>>>    1026719  30%     -81.2%     193485  30%  proc-vmstat.compact_migrate_scanned
>>>     137.75  34%  +2.8e+06%    3801062   2%  proc-vmstat.kswapd_inodesteal
>>>       6749  20%     -53.6%       3131  12%  proc-vmstat.kswapd_low_wmark_hit_quickly
>>>     844991           +11.2%     939487        proc-vmstat.nr_active_file
>>>    3900576           -10.5%    3490567        proc-vmstat.nr_dirtied
>>>     459789           -17.8%     377930        proc-vmstat.nr_inactive_file
>>>     137947           -10.3%     123720        proc-vmstat.nr_slab_reclaimable
>>>      49165           -12.6%      42989        proc-vmstat.nr_slab_unreclaimable
>>>       1382  11%     -26.2%       1020  20%  proc-vmstat.nr_writeback
>>>    3809266           -10.7%    3403350        proc-vmstat.nr_written
>>>     844489           +11.2%     938974        proc-vmstat.nr_zone_active_file
>>>     459855           -17.8%     378121        proc-vmstat.nr_zone_inactive_file
>>>       7055  18%     -52.0%       3389  11%  proc-vmstat.pageoutrun
>>>   33764911   2%     +21.3%   40946445        proc-vmstat.pgactivate
>>>   42044161   2%     +12.1%   47139065        proc-vmstat.pgdeactivate
>>>      92153  20%     -69.1%      28514  24%  proc-vmstat.pgmigrate_success
>>>   15212270           -10.7%   13591573        proc-vmstat.pgpgout
>>>   42053817   2%     +12.1%   47151755        proc-vmstat.pgrefill
>>>      11297 107%   +1025.4%     127138  21%  proc-vmstat.pgscan_direct
>>>   19930162           -24.0%   15141439        proc-vmstat.pgscan_kswapd
>>>   19423629           -24.0%   14758807        proc-vmstat.pgsteal_kswapd
>>>   10868768          +184.8%   30950752        proc-vmstat.slabs_scanned
>>
>> The slab scan number increased a lot.
>>
>>>    3361780   3%     -22.9%    2593327   3%  proc-vmstat.workingset_activate
>>>    4994722   2%     -43.2%    2835020   2%  proc-vmstat.workingset_refault
>>>     316427            -9.3%     286844        slabinfo.Acpi-Namespace.active_objs
>>>       3123            -9.4%       2829        slabinfo.Acpi-Namespace.active_slabs
>>>     318605            -9.4%     288623        slabinfo.Acpi-Namespace.num_objs
>>>       3123            -9.4%       2829        slabinfo.Acpi-Namespace.num_slabs
>>>     220514           -40.7%     130747        slabinfo.btrfs_delayed_node.active_objs
>>>       9751           -25.3%       7283        slabinfo.btrfs_delayed_node.active_slabs
>>>     263293           -25.3%     196669        slabinfo.btrfs_delayed_node.num_objs
>>>       9751           -25.3%       7283        slabinfo.btrfs_delayed_node.num_slabs
>>>       6383   8%     -12.0%       5615   2%  slabinfo.btrfs_delayed_ref_head.num_objs
>>>       9496           +15.5%      10969        slabinfo.btrfs_extent_buffer.active_objs
>>>       9980           +20.5%      12022        slabinfo.btrfs_extent_buffer.num_objs
>>>     260933           -10.7%     233136        slabinfo.btrfs_extent_map.active_objs
>>>       9392           -10.6%       8396        slabinfo.btrfs_extent_map.active_slabs
>>>     263009           -10.6%     235107        slabinfo.btrfs_extent_map.num_objs
>>>       9392           -10.6%       8396        slabinfo.btrfs_extent_map.num_slabs
>>>     271938           -10.3%     243802        slabinfo.btrfs_inode.active_objs
>>>       9804           -10.6%       8768        slabinfo.btrfs_inode.active_slabs
>>>     273856           -10.4%     245359        slabinfo.btrfs_inode.num_objs
>>>       9804           -10.6%       8768        slabinfo.btrfs_inode.num_slabs
>>>       7085   5%      -5.5%       6692   2%  slabinfo.btrfs_path.num_objs
>>>     311936           -16.4%     260797        slabinfo.dentry.active_objs
>>>       7803            -9.6%       7058        slabinfo.dentry.active_slabs
>>>     327759            -9.6%     296439        slabinfo.dentry.num_objs
>>>       7803            -9.6%       7058        slabinfo.dentry.num_slabs
>>>       2289           -23.3%       1755   6%  slabinfo.proc_inode_cache.active_objs
>>>       2292           -19.0%       1856   6%  slabinfo.proc_inode_cache.num_objs
>>>     261546           -12.3%     229485        slabinfo.radix_tree_node.active_objs
>>>       9404           -11.9%       8288        slabinfo.radix_tree_node.active_slabs
>>>     263347           -11.9%     232089        slabinfo.radix_tree_node.num_objs
>>>       9404           -11.9%       8288        slabinfo.radix_tree_node.num_slabs
>>
>> The slab size decreased with the new commit.
>>
>> From perf-profile result,
>>
>>      26.81 ±  2%      -6.5       20.35 ±  2%  perf-profile.calltrace.cycles-pp.secondary_startup_64
>>      24.48 ±  2%      -5.8       18.73        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
>>      24.48 ±  2%      -5.8       18.73        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.secondary_startup_64
>>      24.48 ±  2%      -5.8       18.73        perf-profile.calltrace.cycles-pp.start_secondary.secondary_startup_64
>>      22.80 ±  2%      -5.5       17.30 ±  2%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
>>      20.20 ±  2%      -4.3       15.85        perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.do_idle.cpu_startup_entry.start_secondary
>>      23.03 ±  2%      -2.6       20.42        perf-profile.calltrace.cycles-pp.sys_rename.entry_SYSCALL_64_fastpath
>>      17.02 ±  2%      -1.8       15.17 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_rename.vfs_rename.sys_rename.entry_SYSCALL_64_fastpath
>>      17.03 ±  2%      -1.8       15.19 ±  2%  perf-profile.calltrace.cycles-pp.vfs_rename.sys_rename.entry_SYSCALL_64_fastpath
>>      13.70 ±  2%      -1.2       12.47 ±  3%  perf-profile.calltrace.cycles-pp.__btrfs_unlink_inode.btrfs_rename.vfs_rename.sys_rename.entry_SYSCALL_64_fastpath
>>       5.06 ±  3%      -1.1        3.96 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_async_run_delayed_root.normal_work_helper.process_one_work.worker_thread.kthread
>>       7.37 ±  4%      -0.9        6.49 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.finish_wait.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot
>>       7.32 ±  4%      -0.9        6.45 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.finish_wait.btrfs_tree_lock.btrfs_lock_root_node
>>       1.54 ±  4%      -0.7        0.81 ±  7%  perf-profile.calltrace.cycles-pp.poll_idle.cpuidle_enter_state.do_idle.cpu_startup_entry.start_secondary
>>       2.33 ±  2%      -0.7        1.62 ±  4%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64
>>       2.33 ±  2%      -0.7        1.62 ±  4%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_kernel.secondary_startup_64
>>       2.33 ±  2%      -0.7        1.62 ±  4%  perf-profile.calltrace.cycles-pp.start_kernel.secondary_startup_64
>>       2.23 ±  3%      -0.7        1.53 ±  4%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64
>>       2.13 ±  2%      -0.7        1.46 ±  4%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.do_idle.cpu_startup_entry.start_kernel
>>       5.59            -0.7        4.94 ±  3%  perf-profile.calltrace.cycles-pp.__dentry_kill.dput.sys_rename.entry_SYSCALL_64_fastpath
>>       5.60            -0.7        4.94 ±  3%  perf-profile.calltrace.cycles-pp.dput.sys_rename.entry_SYSCALL_64_fastpath
>>       6.96            -0.7        6.31 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_del_inode_ref.__btrfs_unlink_inode.btrfs_rename.vfs_rename.sys_rename
>>       5.59            -0.7        4.94 ±  3%  perf-profile.calltrace.cycles-pp.evict.__dentry_kill.dput.sys_rename.entry_SYSCALL_64_fastpath
>>       5.58            -0.6        4.94 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_evict_inode.evict.__dentry_kill.dput.sys_rename
>>       6.94 ±  2%      -0.6        6.30 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_del_inode_ref.__btrfs_unlink_inode.btrfs_rename.vfs_rename
>>       6.66 ±  4%      -0.6        6.10 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_dir_item.__btrfs_unlink_inode.btrfs_rename.vfs_rename
>>       6.66 ±  4%      -0.6        6.10 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_lookup_dir_item.__btrfs_unlink_inode.btrfs_rename.vfs_rename.sys_rename
>> 3.38 ± 3% -0.5 2.84 ± 3%
> perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_delete_delayed_items.btrfs_async_run_delayed_root.normal_work_helper.process_one_work
>>       3.40 ±  3%      -0.5        2.86 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_delete_delayed_items.btrfs_async_run_delayed_root.normal_work_helper.process_one_work.worker_thread
>>       7.30 ±  4%      -0.4        6.86 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item.__btrfs_unlink_inode
>>       1.18 ±  4%      -0.4        0.76 ±  2%  perf-profile.calltrace.cycles-pp.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root.normal_work_helper.process_one_work.worker_thread
>> 1.16 ± 4% -0.4 0.74 ± 2%
> perf-profile.calltrace.cycles-pp.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root.normal_work_helper.process_one_work
>>       5.96 ±  2%      -0.4        5.54 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_del_inode_ref.__btrfs_unlink_inode
>>       5.96 ±  2%      -0.4        5.54 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_lock_root_node.btrfs_search_slot.btrfs_del_inode_ref.__btrfs_unlink_inode.btrfs_rename
>> 1.16 ± 4% -0.4 0.74 ± 2%
> perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_async_run_delayed_root.normal_work_helper
>> 2.95 ± 3% -0.4 2.54 ± 3%
> perf-profile.calltrace.cycles-pp.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items.btrfs_async_run_delayed_root
>> 2.95 ± 3% -0.4 2.54 ± 3%
> perf-profile.calltrace.cycles-pp.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items.btrfs_async_run_delayed_root.normal_work_helper
>>       0.94 ±  2%      -0.3        0.59 ±  4%  perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd.kthread
>>       1.25            -0.3        0.91 ±  2%  perf-profile.calltrace.cycles-pp.shrink_node_memcg.shrink_node.kswapd.kthread.ret_from_fork
>>       0.84 ±  2%      -0.3        0.52 ±  3%  perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node.kswapd
>>       1.01            -0.3        0.71 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_create.path_openat.do_filp_open.do_sys_open.entry_SYSCALL_64_fastpath
>>       0.58 ±  4%      -0.2        0.34 ± 70%  perf-profile.calltrace.cycles-pp.queued_write_lock_slowpath.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items
>>       1.73 ±  2%      -0.2        1.50 ±  2%  perf-profile.calltrace.cycles-pp.finish_wait.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_del_inode_ref
>>       1.67 ±  4%      -0.2        1.44 ±  3%  perf-profile.calltrace.cycles-pp.finish_wait.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item
>>       1.89            -0.2        1.67 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_commit_inode_delayed_inode.btrfs_evict_inode.evict.__dentry_kill.dput
>>       1.88            -0.2        1.66 ±  2%  perf-profile.calltrace.cycles-pp.__btrfs_update_delayed_inode.btrfs_commit_inode_delayed_inode.btrfs_evict_inode.evict.__dentry_kill
>>       1.90            -0.2        1.68 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_truncate_inode_items.btrfs_evict_inode.evict.__dentry_kill.dput
>>       1.78            -0.2        1.57 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_del_orphan_item.btrfs_orphan_del.btrfs_evict_inode.evict
>>       1.88            -0.2        1.67 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_truncate_inode_items.btrfs_evict_inode.evict.__dentry_kill
>>       1.78            -0.2        1.57 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_orphan_del.btrfs_evict_inode.evict.__dentry_kill.dput
>>       1.78            -0.2        1.57 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_del_orphan_item.btrfs_orphan_del.btrfs_evict_inode.evict.__dentry_kill
>> 1.87 -0.2 1.66 ± 2%
> perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_commit_inode_delayed_inode.btrfs_evict_inode
>>       1.87            -0.2        1.66 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_commit_inode_delayed_inode.btrfs_evict_inode.evict
>> 0.75 ± 11% -0.2 0.57 ± 7%
> perf-profile.calltrace.cycles-pp.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_file_extent.__btrfs_drop_extents
>> 0.75 ± 11% -0.2 0.57 ± 7%
> perf-profile.calltrace.cycles-pp.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_file_extent.__btrfs_drop_extents.insert_reserved_file_extent
>>       1.39 ±  3%      -0.2        1.23 ±  4%  perf-profile.calltrace.cycles-pp.prepare_to_wait_event.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items
>>       1.84            -0.2        1.68 ±  3%  perf-profile.calltrace.cycles-pp.__btrfs_unlink_inode.btrfs_unlink_inode.btrfs_rename.vfs_rename.sys_rename
>>       1.84            -0.2        1.68 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_unlink_inode.btrfs_rename.vfs_rename.sys_rename.entry_SYSCALL_64_fastpath
>>       1.62            -0.2        1.46 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_lock_root_node.btrfs_search_slot.btrfs_truncate_inode_items.btrfs_evict_inode.evict
>>       0.87 ±  5%      -0.2        0.72 ±  5%  perf-profile.calltrace.cycles-pp.finish_wait.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_delete_delayed_items
>>       1.81            -0.2        1.66 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_dir_item.__btrfs_unlink_inode.btrfs_unlink_inode.btrfs_rename
>>       1.81            -0.2        1.66 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_lookup_dir_item.__btrfs_unlink_inode.btrfs_unlink_inode.btrfs_rename.vfs_rename
>>       1.62            -0.2        1.46 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_truncate_inode_items.btrfs_evict_inode
>>       1.69 ±  2%      -0.1        1.55 ±  2%  perf-profile.calltrace.cycles-pp.end_bio_extent_readpage.normal_work_helper.process_one_work.worker_thread.kthread
>>       1.58            -0.1        1.44 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_lookup_inode.__btrfs_update_delayed_inode
>> 1.58 -0.1 1.44 ± 2%
> perf-profile.calltrace.cycles-pp.btrfs_lock_root_node.btrfs_search_slot.btrfs_lookup_inode.__btrfs_update_delayed_inode.btrfs_commit_inode_delayed_inode
>> 2.89 ± 3% -0.1 2.77 ± 2%
> perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath.queued_write_lock_slowpath.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot
>>       1.51            -0.1        1.39 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_del_orphan_item.btrfs_orphan_del
>>       1.51            -0.1        1.39 ±  5%  perf-profile.calltrace.cycles-pp.btrfs_lock_root_node.btrfs_search_slot.btrfs_del_orphan_item.btrfs_orphan_del.btrfs_evict_inode
>>       0.94            -0.1        0.82        perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
>>       0.93            -0.1        0.81        perf-profile.calltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_secondary
>>       1.52            -0.1        1.44 ±  3%  perf-profile.calltrace.cycles-pp.btrfs_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item.__btrfs_unlink_inode.btrfs_unlink_inode
>>       0.71 ±  3%      -0.1        0.66 ±  2%  perf-profile.calltrace.cycles-pp.prepare_to_wait_event.btrfs_tree_lock.btrfs_lock_root_node.btrfs_search_slot.btrfs_truncate_inode_items
>>       0.60 ±  2%      -0.0        0.56 ±  2%  perf-profile.calltrace.cycles-pp.ttwu_do_activate.try_to_wake_up.autoremove_wake_function.__wake_up_common.wake_up_page_bit
>>       1.61 ±  2%      +0.1        1.67 ±  2%  perf-profile.calltrace.cycles-pp.kswapd.kthread.ret_from_fork
>>       1.61 ±  2%      +0.1        1.67 ±  2%  perf-profile.calltrace.cycles-pp.shrink_node.kswapd.kthread.ret_from_fork
>>       0.55            +0.1        0.68 ±  4%  perf-profile.calltrace.cycles-pp.find_get_entry.pagecache_get_page.generic_file_read_iter.__vfs_read.vfs_read
>>       0.57            +0.1        0.70 ±  4%  perf-profile.calltrace.cycles-pp.pagecache_get_page.generic_file_read_iter.__vfs_read.vfs_read.sys_read
>>       0.59 ±  3%      +0.3        0.87        perf-profile.calltrace.cycles-pp.__account_scheduler_latency.enqueue_entity.enqueue_task_fair.ttwu_do_activate.try_to_wake_up
>>       1.29 ±  3%      +0.3        1.58        perf-profile.calltrace.cycles-pp.enqueue_task_fair.ttwu_do_activate.try_to_wake_up.autoremove_wake_function.__wake_up_common
>> 0.54 +0.3 0.83 ± 2%
> perf-profile.calltrace.cycles-pp.queued_read_lock_slowpath.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_file_extent
>> 0.84 +0.3 1.18 ± 3%
> perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.prepare_to_wait_event.btrfs_tree_read_lock.btrfs_read_lock_root_node
>>       0.71 ±  4%      +0.3        1.05        perf-profile.calltrace.cycles-pp.ttwu_do_activate.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock
>> 0.86 +0.4 1.21 ± 3%
> perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.prepare_to_wait_event.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot
>>       0.90            +0.4        1.28 ±  3%  perf-profile.calltrace.cycles-pp.prepare_to_wait_event.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item
>> 0.35 ± 71% +0.4 0.79 ± 3%
> perf-profile.calltrace.cycles-pp.queued_read_lock_slowpath.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_inode
>>       0.98 ±  4%      +0.4        1.41 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_inode.btrfs_iget
>>       0.98 ±  5%      +0.4        1.43 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_inode.btrfs_iget.btrfs_lookup_dentry
>>       0.94 ±  3%      +0.4        1.39        perf-profile.calltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.btrfs_clear_path_blocking
>>       0.96 ±  3%      +0.5        1.42        perf-profile.calltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot
>>       1.05 ±  2%      +0.5        1.52 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_file_extent.btrfs_get_extent
>>       1.06 ±  3%      +0.5        1.53 ±  4%  perf-profile.calltrace.cycles-pp.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_file_extent.btrfs_get_extent.__do_readpage
>>       0.97 ±  3%      +0.5        1.45        perf-profile.calltrace.cycles-pp.__wake_up_common.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_dir_item
>> 0.62 ± 4% +0.5 1.13
> perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath.queued_read_lock_slowpath.btrfs_clear_lock_blocking_rw.btrfs_clear_path_blocking.btrfs_search_slot
>> 0.65 ± 4% +0.5 1.19
> perf-profile.calltrace.cycles-pp.queued_read_lock_slowpath.btrfs_clear_lock_blocking_rw.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_dir_item
>>       0.17 ±141%      +0.6        0.73        perf-profile.calltrace.cycles-pp.save_stack_trace_tsk.__account_scheduler_latency.enqueue_entity.enqueue_task_fair.ttwu_do_activate
>>       0.00            +0.6        0.57 ±  2%  perf-profile.calltrace.cycles-pp.task_work_run.exit_to_usermode_loop.syscall_return_slowpath.entry_SYSCALL_64_fastpath
>>       0.00            +0.6        0.59 ±  2%  perf-profile.calltrace.cycles-pp.exit_to_usermode_loop.syscall_return_slowpath.entry_SYSCALL_64_fastpath
>>       0.00            +0.6        0.60 ±  2%  perf-profile.calltrace.cycles-pp.syscall_return_slowpath.entry_SYSCALL_64_fastpath
>> 0.56 ± 4% +0.6 1.17
> perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_file_extent
>>       1.17            +0.6        1.78 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.finish_wait.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot
>> 1.16 +0.6 1.77 ± 2%
> perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.finish_wait.btrfs_tree_read_lock.btrfs_read_lock_root_node
>>       1.18            +0.6        1.80 ±  2%  perf-profile.calltrace.cycles-pp.finish_wait.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item
>>       0.57 ±  7%      +0.6        1.21 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_inode
>> 0.75 ± 4% +0.6 1.38
> perf-profile.calltrace.cycles-pp.btrfs_clear_lock_blocking_rw.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_dir_item.btrfs_lookup_dentry
>>       1.95            +0.7        2.61        perf-profile.calltrace.cycles-pp.copy_user_enhanced_fast_string.copyout.copy_page_to_iter.generic_file_read_iter.__vfs_read
>>       1.96            +0.7        2.62        perf-profile.calltrace.cycles-pp.copyout.copy_page_to_iter.generic_file_read_iter.__vfs_read.vfs_read
>>       0.00            +0.7        0.70        perf-profile.calltrace.cycles-pp.__save_stack_trace.save_stack_trace_tsk.__account_scheduler_latency.enqueue_entity.enqueue_task_fair
>>       2.10            +0.7        2.80        perf-profile.calltrace.cycles-pp.copy_page_to_iter.generic_file_read_iter.__vfs_read.vfs_read.sys_read
>>       0.85 ±  5%      +0.7        1.58        perf-profile.calltrace.cycles-pp.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_file_extent.btrfs_get_extent
>>       0.84 ±  6%      +0.7        1.57        perf-profile.calltrace.cycles-pp.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_inode.btrfs_iget
>>       0.00            +0.8        0.75 ±  4%  perf-profile.calltrace.cycles-pp.super_cache_scan.shrink_slab.shrink_node.kswapd.kthread
>>       0.00            +0.8        0.75 ±  5%  perf-profile.calltrace.cycles-pp.shrink_slab.shrink_node.kswapd.kthread.ret_from_fork
>>       1.07 ±  5%      +0.9        1.98 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_file_extent.btrfs_get_extent.__do_readpage
>>       1.09 ±  7%      +0.9        2.01 ±  2%  perf-profile.calltrace.cycles-pp.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_inode.btrfs_iget.btrfs_lookup_dentry
>>       4.90 ±  2%      +1.3        6.19        perf-profile.calltrace.cycles-pp.__do_page_cache_readahead.ondemand_readahead.generic_file_read_iter.__vfs_read.vfs_read
>>       4.90 ±  2%      +1.3        6.20        perf-profile.calltrace.cycles-pp.ondemand_readahead.generic_file_read_iter.__vfs_read.vfs_read.sys_read
>>       4.44 ±  2%      +1.3        5.74        perf-profile.calltrace.cycles-pp.extent_readpages.__do_page_cache_readahead.ondemand_readahead.generic_file_read_iter.__vfs_read
>>       2.87 ±  3%      +1.4        4.29        perf-profile.calltrace.cycles-pp.__extent_readpages.extent_readpages.__do_page_cache_readahead.ondemand_readahead.generic_file_read_iter
>>       2.22 ±  4%      +1.4        3.65        perf-profile.calltrace.cycles-pp.btrfs_lookup_file_extent.btrfs_get_extent.__do_readpage.__extent_readpages.extent_readpages
>>       2.22 ±  4%      +1.4        3.65        perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_file_extent.btrfs_get_extent.__do_readpage.__extent_readpages
>>       2.27 ±  6%      +1.4        3.72        perf-profile.calltrace.cycles-pp.btrfs_lookup_inode.btrfs_iget.btrfs_lookup_dentry.btrfs_lookup.path_openat
>>       2.27 ±  6%      +1.4        3.72        perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_inode.btrfs_iget.btrfs_lookup_dentry.btrfs_lookup
>>       2.72 ±  3%      +1.4        4.17        perf-profile.calltrace.cycles-pp.__do_readpage.__extent_readpages.extent_readpages.__do_page_cache_readahead.ondemand_readahead
>>       2.33 ±  4%      +1.5        3.79        perf-profile.calltrace.cycles-pp.btrfs_get_extent.__do_readpage.__extent_readpages.extent_readpages.__do_page_cache_readahead
>> 2.38 +1.6 3.95
> perf-profile.calltrace.cycles-pp.queued_read_lock_slowpath.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item
>>       2.63 ±  6%      +1.7        4.33        perf-profile.calltrace.cycles-pp.btrfs_iget.btrfs_lookup_dentry.btrfs_lookup.path_openat.do_filp_open
>> 1.68 ± 4% +2.1 3.79
> perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_dir_item
>>       8.66            +2.2       10.90        perf-profile.calltrace.cycles-pp.generic_file_read_iter.__vfs_read.vfs_read.sys_read.entry_SYSCALL_64_fastpath
>>       8.71            +2.3       10.97        perf-profile.calltrace.cycles-pp.__vfs_read.vfs_read.sys_read.entry_SYSCALL_64_fastpath
>>       8.85            +2.3       11.15        perf-profile.calltrace.cycles-pp.vfs_read.sys_read.entry_SYSCALL_64_fastpath
>>       9.02            +2.3       11.33        perf-profile.calltrace.cycles-pp.sys_read.entry_SYSCALL_64_fastpath
>>       2.71 ±  3%      +2.6        5.35        perf-profile.calltrace.cycles-pp.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_dir_item.btrfs_lookup_dentry
>>       4.63            +2.7        7.29        perf-profile.calltrace.cycles-pp.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item.btrfs_lookup_dentry
>>       4.65            +2.7        7.32        perf-profile.calltrace.cycles-pp.btrfs_read_lock_root_node.btrfs_search_slot.btrfs_lookup_dir_item.btrfs_lookup_dentry.btrfs_lookup
>> 1.94 ± 2% +2.8 4.77
> perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath.queued_read_lock_slowpath.btrfs_tree_read_lock.btrfs_read_lock_root_node.btrfs_search_slot
>> 2.81 ± 4% +3.3 6.15
> perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__wake_up_common_lock.btrfs_clear_path_blocking.btrfs_search_slot
>>       3.58 ±  2%      +3.4        6.98        perf-profile.calltrace.cycles-pp.btrfs_clear_path_blocking.btrfs_search_slot.btrfs_lookup_dir_item.btrfs_lookup_dentry.btrfs_lookup
>>       8.69            +6.3       15.03        perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_dir_item.btrfs_lookup_dentry.btrfs_lookup.path_openat
>>       8.75            +6.4       15.12        perf-profile.calltrace.cycles-pp.btrfs_lookup_dir_item.btrfs_lookup_dentry.btrfs_lookup.path_openat.do_filp_open
>>      47.34            +8.1       55.46        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_fastpath
>>      11.47            +8.1       19.60        perf-profile.calltrace.cycles-pp.btrfs_lookup.path_openat.do_filp_open.do_sys_open.entry_SYSCALL_64_fastpath
>>      11.46            +8.1       19.59        perf-profile.calltrace.cycles-pp.btrfs_lookup_dentry.btrfs_lookup.path_openat.do_filp_open.do_sys_open
>>      13.90            +8.3       22.20        perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_open.entry_SYSCALL_64_fastpath
>>      13.91            +8.3       22.22        perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_open.entry_SYSCALL_64_fastpath
>>      14.13            +8.4       22.52        perf-profile.calltrace.cycles-pp.do_sys_open.entry_SYSCALL_64_fastpath
>>
>> The cycles for dentry lookup increased much too.  Is this the reason why
>> write score decreased?
>>
>> If you need more information, please let me know.
>>
>> Best Regards,
>> Huang, Ying
>>
>>>    1140424  12%     +40.2%    1598980  14%  sched_debug.cfs_rq:/.MIN_vruntime.max
>>>     790.55           +13.0%     893.20   3%  sched_debug.cfs_rq:/.exec_clock.stddev
>>>    1140425  12%     +40.2%    1598982  14%  sched_debug.cfs_rq:/.max_vruntime.max
>>>       0.83  10%     +21.5%       1.00   8%  sched_debug.cfs_rq:/.nr_running.avg
>>>       3.30  99%    +266.3%      12.09  13%  sched_debug.cfs_rq:/.removed.load_avg.avg
>>>     153.02  97%    +266.6%     560.96  13%  sched_debug.cfs_rq:/.removed.runnable_sum.avg
>>>     569.93 102%    +173.2%       1556  14%  sched_debug.cfs_rq:/.removed.runnable_sum.stddev
>>>       1.42  60%    +501.5%       8.52  34%  sched_debug.cfs_rq:/.removed.util_avg.avg
>>>      19.88  59%    +288.9%      77.29  16%  sched_debug.cfs_rq:/.removed.util_avg.max
>>>       5.05  58%    +342.3%      22.32  22%  sched_debug.cfs_rq:/.removed.util_avg.stddev
>>>     791.44   3%     +47.7%       1168   8%  sched_debug.cfs_rq:/.util_avg.avg
>>>       1305   6%     +33.2%       1738   5%  sched_debug.cfs_rq:/.util_avg.max
>>>     450.25  11%     +66.2%     748.17  14%  sched_debug.cfs_rq:/.util_avg.min
>>>     220.82   8%     +21.1%     267.46   5%  sched_debug.cfs_rq:/.util_avg.stddev
>>>     363118  11%     -23.8%     276520  11%  sched_debug.cpu.avg_idle.avg
>>>     726003   8%     -30.8%     502313   4%  sched_debug.cpu.avg_idle.max
>>>     202629   3%     -32.2%     137429  18%  sched_debug.cpu.avg_idle.stddev
>>>      31.96  28%     +54.6%      49.42  14%  sched_debug.cpu.cpu_load[3].min
>>>      36.21  25%     +64.0%      59.38   6%  sched_debug.cpu.cpu_load[4].min
>>>       1007   5%     +20.7%       1216   7%  sched_debug.cpu.curr->pid.avg
>>>       4.50   5%     +14.8%       5.17   5%  sched_debug.cpu.nr_running.max
>>>    2476195           -11.8%    2185022        sched_debug.cpu.nr_switches.max
>>>     212888           -26.6%     156172   3%  sched_debug.cpu.nr_switches.stddev
>>>       3570   2%     -58.7%       1474   2%  sched_debug.cpu.nr_uninterruptible.max
>>>    -803.67           -28.7%    -573.38        sched_debug.cpu.nr_uninterruptible.min
>>>       1004   2%     -50.4%     498.55   3%  sched_debug.cpu.nr_uninterruptible.stddev
>>>    2478809           -11.7%    2189310        sched_debug.cpu.sched_count.max
>>>     214130           -26.5%     157298   3%  sched_debug.cpu.sched_count.stddev
>>>     489430   2%     -16.6%     408309   2%  sched_debug.cpu.sched_goidle.avg
>>>     724333   2%     -28.2%     520263   2%  sched_debug.cpu.sched_goidle.max
>>>     457611           -18.1%     374746   3%  sched_debug.cpu.sched_goidle.min
>>>      62957   2%     -47.4%      33138   3%  sched_debug.cpu.sched_goidle.stddev
>>>     676053   2%     -15.4%     571816   2%  sched_debug.cpu.ttwu_local.max
>>>      42669   3%     +22.3%      52198        sched_debug.cpu.ttwu_local.min
>>>     151873   2%     -18.3%     124118   2%  sched_debug.cpu.ttwu_local.stddev
>>>
>>>
>>>                                                                                 
>>>                                blogbench.write_score                            
>>>                                                                                 
>>>   3300 +-+------------------------------------------------------------------+   
>>>   3250 +-+          +.       .+   +. .+  :      : :        +.   .+ .+.+.+. .|   
>>>        |:    +.   .+  +.+.+.+  + +  +    :   +. : :    +. +  +.+  +       + |   
>>>   3200 +-+  +  +.+              +         : +  +   :  +  +                  |   
>>>   3150 +-+.+                              ++       +.+                      |   
>>>   3100 +-+                                                                  |   
>>>   3050 +-+                                                                  |   
>>>        |                                                                    |   
>>>   3000 +-+                                                                  |   
>>>   2950 +-+                    O   O                                         |   
>>>   2900 +-O     O   O                  O                                     |   
>>>   2850 +-+       O  O   O O O   O       O OO O   O   O                      |   
>>>        |   O                        O          O   O                        |   
>>>   2800 O-+   O        O                                                     |   
>>>   2750 +-+------------------------------------------------------------------+   
>>>                                                                                 
>>>                                                                                                                                                                 
>>> [*] bisect-good sample
>>> [O] bisect-bad  sample
>>>
>>>
>>>
>>> Disclaimer:
>>> Results have been estimated based on internal Intel analysis and are provided
>>> for informational purposes only. Any difference in system hardware or software
>>> design or configuration may affect actual performance.
>>>
>>>
>>> Thanks,
>>> Xiaolong
>> _______________________________________________
>> LKP mailing list
>> LKP@lists.01.org
>> https://lists.01.org/mailman/listinfo/lkp
