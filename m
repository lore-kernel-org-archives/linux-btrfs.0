From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: 2.6.37 kernel BUG at fs/btrfs/inode.c:6752!
Date: Mon, 14 Feb 2011 17:59:47 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB68630BEBB31@shsmsx502.ccr.corp.intel.com>
References: <8534C054-C9D6-470F-BB5A-45493462A17C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8534C054-C9D6-470F-BB5A-45493462A17C@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

We build packages in a kvm-qemu chroot environment. And the root fs is btrfs. It hang during installing packages. And we found error message in dmesg:

[   84.320466] btrfs: use compression
[  288.711396] ------------[ cut here ]------------
[  288.711569] kernel BUG at fs/btrfs/inode.c:6752!
[  288.711730] invalid opcode: 0000 [#1] PREEMPT SMP 
[  288.712014] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
[  288.712014] Modules linked in: dm_snapshot dm_mod
[  288.712014] 
[  288.712014] Pid: 869, comm: ldconfig Not tainted 2.6.37-14.3 #1 /Bochs
[  288.712014] EIP: 0060:[<c1191f0a>] EFLAGS: 00010286 CPU: 0
[  288.712014] EIP is at btrfs_rename+0x2d6/0x41c
[  288.712014] EAX: ffffffe4 EBX: 4d584e22 ECX: 00000007 EDX: c3a88838
[  288.712014] ESI: 2a60ff2b EDI: db43fcdc EBP: c3acfe5c ESP: c3acfe18
[  288.712014]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  288.712014] Process ldconfig (pid: 869, ti=c3ace000 task=c3a883b0 task.ti=c3ace000)
[  288.712014] Stack:
[  288.712014]  00000246 00acfe2c f4114900 01bfb428 f3f02988 f4114b1c db7a7358 f4114b1c
[  288.712014]  f3f02988 00000000 debfb38c f247a4a0 00000336 00000000 c155ee98 f4fcd9d0
[  288.712014]  debfb38c c3acfe80 c10fe222 f4fcd9d0 f4114b1c db7a7358 f4114b1c ffffffff
[  288.712014] Call Trace:
[  288.712014]  [<c10fe222>] ? vfs_rename_other+0x62/0xc7
[  288.712014]  [<c10fec68>] ? vfs_rename+0xda/0x1a4
[  288.712014]  [<c1100d20>] ? sys_renameat+0x16d/0x1ce
[  288.712014]  [<c104a93b>] ? do_page_fault+0x330/0x35d
[  288.712014]  [<c104a60b>] ? do_page_fault+0x0/0x35d
[  288.712014]  [<c1100d93>] ? sys_rename+0x12/0x17
[  288.712014]  [<c154065d>] ? syscall_call+0x7/0xb
[  288.712014] Code: c4 10 eb 23 8b 55 d4 8b 4d d0 8b 42 2c ff 40 30 8b 45 e8 ff 72 40 ff 72 44 ff 72 2c 8b 55 dc e8 ce dc ff ff 83 c4 0c 85 c0 74 02 <0f> 0b 80 7d cb 00 0f 84 85 00 00 00 e8 ea 1e ef ff 8b 4d e4 83 
[  288.712014] EIP: [<c1191f0a>] btrfs_rename+0x2d6/0x41c SS:ESP 0068:c3acfe18
[  288.730501] ---[ end trace f18bb6381110715f ]---

We also got the output of sysrq+w as below:

[15976.024048] SysRq : Show Blocked State
[15976.025023]   task                PC stack   pid father
[15976.025023] mic-image-cre D 00000043     0   273    271 0x00000000
[15976.025023]  f452bee0 00000046 4e94762e 00000043 c18920c0 00207c5b 00000000 c18920c0
[15976.025023]  f45988b8 4e73f9d3 00000043 f4598630 00000001 f3f02c20 c107c3a6 f3f02c30
[15976.025023]  00000001 f3f02bd8 c153f063 f3f02c10 f452bec4 00000046 00000046 f3f02bd8
[15976.025023] Call Trace:
[15976.025023]  [<c107c3a6>] ? prepare_to_wait+0x4f/0x56
[15976.025023]  [<c153f063>] ? mutex_unlock+0x8/0xa
[15976.025023]  [<c108e368>] ? trace_hardirqs_on+0xb/0xd
[15976.025023]  [<c11b3955>] wait_for_writer.clone.17+0x89/0xaf
[15976.025023]  [<c107c1a7>] ? autoremove_wake_function+0x0/0x2f
[15976.025023]  [<c11b3aa9>] btrfs_sync_log+0xc2/0x43b
[15976.025023]  [<c108e368>] ? trace_hardirqs_on+0xb/0xd
[15976.025023]  [<c1193c22>] btrfs_sync_file+0x116/0x156
[15976.025023]  [<c1113e2c>] vfs_fsync_range+0x48/0x65
[15976.025023]  [<c1113ec5>] vfs_fsync+0x14/0x16
[15976.025023]  [<c1113eeb>] do_fsync+0x24/0x34
[15976.025023]  [<c1114167>] sys_fdatasync+0x10/0x12
[15976.025023]  [<c154065d>] syscall_call+0x7/0xb
[15976.025023] btrfs-transac D 0000004a     0   337      2 0x00000000
[15976.025023]  f3f71ecc 00000046 913eb54f 0000004a c18920c0 000004c2 00000000 c18920c0
[15976.025023]  f47f1038 913eb08d 0000004a f47f0db0 00000000 f4561e70 c153dddf 00000000
[15976.025023]  00000000 c119fa68 f3f71ec4 00000002 00000000 f4561ffc 00000002 00000000
[15976.025023] Call Trace:
[15976.025023]  [<c153dddf>] ? schedule+0x6c0/0x774
[15976.025023]  [<c119fa68>] ? btrfs_run_ordered_operations+0x2a/0x195
[15976.025023]  [<c119fa78>] ? btrfs_run_ordered_operations+0x3a/0x195
[15976.025023]  [<c107c36f>] ? prepare_to_wait+0x18/0x56
[15976.025023]  [<c153e11f>] schedule_timeout+0x18/0x2c8
[15976.025023]  [<c107c3a6>] ? prepare_to_wait+0x4f/0x56
[15976.025023]  [<c108e368>] ? trace_hardirqs_on+0xb/0xd
[15976.025023]  [<c107c3a6>] ? prepare_to_wait+0x4f/0x56
[15976.025023]  [<c1188089>] btrfs_commit_transaction+0x252/0x5c4
[15976.025023]  [<c107c1a7>] ? autoremove_wake_function+0x0/0x2f
[15976.025023]  [<c11833f3>] transaction_kthread+0x141/0x1dd
[15976.025023]  [<c1051a2d>] ? complete+0x34/0x3e
[15976.025023]  [<c11832b2>] ? transaction_kthread+0x0/0x1dd
[15976.025023]  [<c107bd84>] kthread+0x63/0x68
[15976.025023]  [<c107bd21>] ? kthread+0x0/0x68
[15976.025023]  [<c102eaba>] kernel_thread_helper+0x6/0x10
[15976.025023] Sched Debug Version: v0.09, 2.6.37-14.3 #1
[15976.025023] now at 15976066.938938 msecs
[15976.025023]   .jiffies                                 : 15676024
[15976.025023]   .sysctl_sched_latency                    : 6.000000
[15976.025023]   .sysctl_sched_min_granularity            : 0.750000
[15976.025023]   .sysctl_sched_wakeup_granularity         : 1.000000
[15976.025023]   .sysctl_sched_child_runs_first           : 0
[15976.025023]   .sysctl_sched_features                   : 31855
[15976.025023]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[15976.025023] 
[15976.025023] cpu#0, 3323.907 MHz
[15976.025023]   .nr_running                    : 2
[15976.025023]   .load                          : 2048
[15976.025023]   .nr_switches                   : 1096534
[15976.025023]   .nr_load_updates               : 189903
[15976.025023]   .nr_uninterruptible            : 2
[15976.025023]   .next_balance                  : 15.677021
[15976.025023]   .curr->pid                     : 880
[15976.025023]   .clock                         : 15976024.024329
[15976.025023]   .cpu_load[0]                   : 2048
[15976.025023]   .cpu_load[1]                   : 1280
[15976.025023]   .cpu_load[2]                   : 704
[15976.025023]   .cpu_load[3]                   : 368
[15976.025023]   .cpu_load[4]                   : 188
[15976.025023]   .yld_count                     : 0
[15976.025023]   .sched_switch                  : 0
[15976.025023]   .sched_count                   : 1178729
[15976.025023]   .sched_goidle                  : 115865
[15976.025023]   .avg_idle                      : 929176
[15976.025023]   .ttwu_count                    : 604286
[15976.025023]   .ttwu_local                    : 604286
[15976.025023]   .bkl_count                     : 0
[15976.025023] 
[15976.025023] cfs_rq[0]:/
[15976.025023]   .exec_clock                    : 147695.057962
[15976.025023]   .MIN_vruntime                  : 115505.817780
[15976.025023]   .min_vruntime                  : 115505.817780
[15976.025023]   .max_vruntime                  : 115505.817780
[15976.025023]   .spread                        : 0.000000
[15976.025023]   .spread0                       : 0.000000
[15976.025023]   .nr_running                    : 2
[15976.025023]   .load                          : 2048
[15976.025023]   .nr_spread_over                : 144
[15976.025023]   .shares                        : 0
[15976.025023] 
[15976.025023] rt_rq[0]:/
[15976.025023]   .rt_nr_running                 : 0
[15976.025023]   .rt_throttled                  : 0
[15976.025023]   .rt_time                       : 0.000000
[15976.025023]   .rt_runtime                    : 950.000000
[15976.025023] 
[15976.025023] runnable tasks:
[15976.025023]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[15976.025023] ----------------------------------------------------------------------------------------------------------
[15976.025023] R           bash   880    115502.939384       239   120    115502.939384        39.907413    251822.808664 /
[15976.025023]

The BUG_ON is here:
        if (unlikely(old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
                root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
                ret = btrfs_unlink_subvol(trans, root, old_dir, root_objectid,
                                        old_dentry->d_name.name,
                                        old_dentry->d_name.len);
        } else {
                btrfs_inc_nlink(old_dentry->d_inode);
                ret = btrfs_unlink_inode(trans, root, old_dir,
                                         old_dentry->d_inode,
                                         old_dentry->d_name.name,
                                         old_dentry->d_name.len);
        }
        BUG_ON(ret);

I suspect the later hang is related to the previous bug_on. Since it bug_on in btrfs_rename and do not call btrfs_end_log_trans to decrease root->log_writers. And later call to btrfs_sync_log will wait for ever for root->log_writers.

And I am wondering if we really need to bug_on for every invalid return value of btrfs_unlink_inode. Should we loosen it to something else?
