From: cwillu <cwillu@cwillu.com>
Subject: Re: 2.6.37 kernel BUG at fs/btrfs/inode.c:6752!
Date: Mon, 14 Feb 2011 04:06:08 -0600
Message-ID: <AANLkTi=TtOHG23=AFrU9Lax5MCkq8o+fuVyJ_a7kz3t1@mail.gmail.com>
References: <8534C054-C9D6-470F-BB5A-45493462A17C@gmail.com>
	<1865303E0DED764181A9D882DEF65FB68630BEBB31@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB68630BEBB31@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 14, 2011 at 3:59 AM, Zhong, Xin <xin.zhong@intel.com> wrote=
:
> We build packages in a kvm-qemu chroot environment. And the root fs i=
s btrfs. It hang during installing packages. And we found error message=
 in dmesg:
>
> [ =A0 84.320466] btrfs: use compression
> [ =A0288.711396] ------------[ cut here ]------------
> [ =A0288.711569] kernel BUG at fs/btrfs/inode.c:6752!
> [ =A0288.711730] invalid opcode: 0000 [#1] PREEMPT SMP
> [ =A0288.712014] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/ue=
vent
> [ =A0288.712014] Modules linked in: dm_snapshot dm_mod
> [ =A0288.712014]
> [ =A0288.712014] Pid: 869, comm: ldconfig Not tainted 2.6.37-14.3 #1 =
/Bochs
> [ =A0288.712014] EIP: 0060:[<c1191f0a>] EFLAGS: 00010286 CPU: 0
> [ =A0288.712014] EIP is at btrfs_rename+0x2d6/0x41c
> [ =A0288.712014] EAX: ffffffe4 EBX: 4d584e22 ECX: 00000007 EDX: c3a88=
838
> [ =A0288.712014] ESI: 2a60ff2b EDI: db43fcdc EBP: c3acfe5c ESP: c3acf=
e18
> [ =A0288.712014] =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ =A0288.712014] Process ldconfig (pid: 869, ti=3Dc3ace000 task=3Dc3a=
883b0 task.ti=3Dc3ace000)
> [ =A0288.712014] Stack:
> [ =A0288.712014] =A000000246 00acfe2c f4114900 01bfb428 f3f02988 f411=
4b1c db7a7358 f4114b1c
> [ =A0288.712014] =A0f3f02988 00000000 debfb38c f247a4a0 00000336 0000=
0000 c155ee98 f4fcd9d0
> [ =A0288.712014] =A0debfb38c c3acfe80 c10fe222 f4fcd9d0 f4114b1c db7a=
7358 f4114b1c ffffffff
> [ =A0288.712014] Call Trace:
> [ =A0288.712014] =A0[<c10fe222>] ? vfs_rename_other+0x62/0xc7
> [ =A0288.712014] =A0[<c10fec68>] ? vfs_rename+0xda/0x1a4
> [ =A0288.712014] =A0[<c1100d20>] ? sys_renameat+0x16d/0x1ce
> [ =A0288.712014] =A0[<c104a93b>] ? do_page_fault+0x330/0x35d
> [ =A0288.712014] =A0[<c104a60b>] ? do_page_fault+0x0/0x35d
> [ =A0288.712014] =A0[<c1100d93>] ? sys_rename+0x12/0x17
> [ =A0288.712014] =A0[<c154065d>] ? syscall_call+0x7/0xb
> [ =A0288.712014] Code: c4 10 eb 23 8b 55 d4 8b 4d d0 8b 42 2c ff 40 3=
0 8b 45 e8 ff 72 40 ff 72 44 ff 72 2c 8b 55 dc e8 ce dc ff ff 83 c4 0c =
85 c0 74 02 <0f> 0b 80 7d cb 00 0f 84 85 00 00 00 e8 ea 1e ef ff 8b 4d =
e4 83
> [ =A0288.712014] EIP: [<c1191f0a>] btrfs_rename+0x2d6/0x41c SS:ESP 00=
68:c3acfe18
> [ =A0288.730501] ---[ end trace f18bb6381110715f ]---
>
> We also got the output of sysrq+w as below:
>
> [15976.024048] SysRq : Show Blocked State
> [15976.025023] =A0 task =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PC stack =A0 p=
id father
> [15976.025023] mic-image-cre D 00000043 =A0 =A0 0 =A0 273 =A0 =A0271 =
0x00000000
> [15976.025023] =A0f452bee0 00000046 4e94762e 00000043 c18920c0 00207c=
5b 00000000 c18920c0
> [15976.025023] =A0f45988b8 4e73f9d3 00000043 f4598630 00000001 f3f02c=
20 c107c3a6 f3f02c30
> [15976.025023] =A000000001 f3f02bd8 c153f063 f3f02c10 f452bec4 000000=
46 00000046 f3f02bd8
> [15976.025023] Call Trace:
> [15976.025023] =A0[<c107c3a6>] ? prepare_to_wait+0x4f/0x56
> [15976.025023] =A0[<c153f063>] ? mutex_unlock+0x8/0xa
> [15976.025023] =A0[<c108e368>] ? trace_hardirqs_on+0xb/0xd
> [15976.025023] =A0[<c11b3955>] wait_for_writer.clone.17+0x89/0xaf
> [15976.025023] =A0[<c107c1a7>] ? autoremove_wake_function+0x0/0x2f
> [15976.025023] =A0[<c11b3aa9>] btrfs_sync_log+0xc2/0x43b
> [15976.025023] =A0[<c108e368>] ? trace_hardirqs_on+0xb/0xd
> [15976.025023] =A0[<c1193c22>] btrfs_sync_file+0x116/0x156
> [15976.025023] =A0[<c1113e2c>] vfs_fsync_range+0x48/0x65
> [15976.025023] =A0[<c1113ec5>] vfs_fsync+0x14/0x16
> [15976.025023] =A0[<c1113eeb>] do_fsync+0x24/0x34
> [15976.025023] =A0[<c1114167>] sys_fdatasync+0x10/0x12
> [15976.025023] =A0[<c154065d>] syscall_call+0x7/0xb
> [15976.025023] btrfs-transac D 0000004a =A0 =A0 0 =A0 337 =A0 =A0 =A0=
2 0x00000000
> [15976.025023] =A0f3f71ecc 00000046 913eb54f 0000004a c18920c0 000004=
c2 00000000 c18920c0
> [15976.025023] =A0f47f1038 913eb08d 0000004a f47f0db0 00000000 f4561e=
70 c153dddf 00000000
> [15976.025023] =A000000000 c119fa68 f3f71ec4 00000002 00000000 f4561f=
fc 00000002 00000000
> [15976.025023] Call Trace:
> [15976.025023] =A0[<c153dddf>] ? schedule+0x6c0/0x774
> [15976.025023] =A0[<c119fa68>] ? btrfs_run_ordered_operations+0x2a/0x=
195
> [15976.025023] =A0[<c119fa78>] ? btrfs_run_ordered_operations+0x3a/0x=
195
> [15976.025023] =A0[<c107c36f>] ? prepare_to_wait+0x18/0x56
> [15976.025023] =A0[<c153e11f>] schedule_timeout+0x18/0x2c8
> [15976.025023] =A0[<c107c3a6>] ? prepare_to_wait+0x4f/0x56
> [15976.025023] =A0[<c108e368>] ? trace_hardirqs_on+0xb/0xd
> [15976.025023] =A0[<c107c3a6>] ? prepare_to_wait+0x4f/0x56
> [15976.025023] =A0[<c1188089>] btrfs_commit_transaction+0x252/0x5c4
> [15976.025023] =A0[<c107c1a7>] ? autoremove_wake_function+0x0/0x2f
> [15976.025023] =A0[<c11833f3>] transaction_kthread+0x141/0x1dd
> [15976.025023] =A0[<c1051a2d>] ? complete+0x34/0x3e
> [15976.025023] =A0[<c11832b2>] ? transaction_kthread+0x0/0x1dd
> [15976.025023] =A0[<c107bd84>] kthread+0x63/0x68
> [15976.025023] =A0[<c107bd21>] ? kthread+0x0/0x68
> [15976.025023] =A0[<c102eaba>] kernel_thread_helper+0x6/0x10
> [15976.025023] Sched Debug Version: v0.09, 2.6.37-14.3 #1
> [15976.025023] now at 15976066.938938 msecs
> [15976.025023] =A0 .jiffies =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 : 15676024
> [15976.025023] =A0 .sysctl_sched_latency =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0: 6.000000
> [15976.025023] =A0 .sysctl_sched_min_granularity =A0 =A0 =A0 =A0 =A0 =
=A0: 0.750000
> [15976.025023] =A0 .sysctl_sched_wakeup_granularity =A0 =A0 =A0 =A0 :=
 1.000000
> [15976.025023] =A0 .sysctl_sched_child_runs_first =A0 =A0 =A0 =A0 =A0=
 : 0
> [15976.025023] =A0 .sysctl_sched_features =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 : 31855
> [15976.025023] =A0 .sysctl_sched_tunable_scaling =A0 =A0 =A0 =A0 =A0 =
=A0: 1 (logaritmic)
> [15976.025023]
> [15976.025023] cpu#0, 3323.907 MHz
> [15976.025023] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 2
> [15976.025023] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 2048
> [15976.025023] =A0 .nr_switches =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 1096534
> [15976.025023] =A0 .nr_load_updates =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 189=
903
> [15976.025023] =A0 .nr_uninterruptible =A0 =A0 =A0 =A0 =A0 =A0: 2
> [15976.025023] =A0 .next_balance =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 15.677021
> [15976.025023] =A0 .curr->pid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 880
> [15976.025023] =A0 .clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 15976024.024329
> [15976.025023] =A0 .cpu_load[0] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 2048
> [15976.025023] =A0 .cpu_load[1] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 1280
> [15976.025023] =A0 .cpu_load[2] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 704
> [15976.025023] =A0 .cpu_load[3] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 368
> [15976.025023] =A0 .cpu_load[4] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 188
> [15976.025023] =A0 .yld_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0
> [15976.025023] =A0 .sched_switch =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [15976.025023] =A0 .sched_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 1178729
> [15976.025023] =A0 .sched_goidle =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 115865
> [15976.025023] =A0 .avg_idle =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 929176
> [15976.025023] =A0 .ttwu_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 604286
> [15976.025023] =A0 .ttwu_local =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 604286
> [15976.025023] =A0 .bkl_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0
> [15976.025023]
> [15976.025023] cfs_rq[0]:/
> [15976.025023] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 147695.057962
> [15976.025023] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 115505.817780
> [15976.025023] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 115505.817780
> [15976.025023] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 115505.817780
> [15976.025023] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 0.000000
> [15976.025023] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.000000
> [15976.025023] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 2
> [15976.025023] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 2048
> [15976.025023] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0: 1=
44
> [15976.025023] =A0 .shares =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 0
> [15976.025023]
> [15976.025023] rt_rq[0]:/
> [15976.025023] =A0 .rt_nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 0
> [15976.025023] =A0 .rt_throttled =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [15976.025023] =A0 .rt_time =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.000000
> [15976.025023] =A0 .rt_runtime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 950.000000
> [15976.025023]
> [15976.025023] runnable tasks:
> [15976.025023] =A0 =A0 =A0 =A0 =A0 =A0 task =A0 PID =A0 =A0 =A0 =A0 t=
ree-key =A0switches =A0prio =A0 =A0 exec-runtime =A0 =A0 =A0 =A0 sum-ex=
ec =A0 =A0 =A0 =A0sum-sleep
> [15976.025023] ------------------------------------------------------=
----------------------------------------------------
> [15976.025023] R =A0 =A0 =A0 =A0 =A0 bash =A0 880 =A0 =A0115502.93938=
4 =A0 =A0 =A0 239 =A0 120 =A0 =A0115502.939384 =A0 =A0 =A0 =A039.907413=
 =A0 =A0251822.808664 /
> [15976.025023]
>
> The BUG_ON is here:
> =A0 =A0 =A0 =A0if (unlikely(old_inode->i_ino =3D=3D BTRFS_FIRST_FREE_=
OBJECTID)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root_objectid =3D BTRFS_I(old_inode)->=
root->root_key.objectid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_unlink_subvol(trans, roo=
t, old_dir, root_objectid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0old_dentry->d_name.name,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0old_dentry->d_name.len);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_inc_nlink(old_dentry->d_inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_unlink_inode(trans, root=
, old_dir,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 old_dentry->d_inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 old_dentry->d_name.name,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 old_dentry->d_name.len);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0BUG_ON(ret);
>
> I suspect the later hang is related to the previous bug_on. Since it =
bug_on in btrfs_rename and do not call btrfs_end_log_trans to decrease =
root->log_writers. And later call to btrfs_sync_log will wait for ever =
for root->log_writers.

2.6.38 has a bunch of enospc fixes, of which this is an example (EAX:
ffffffe4 =3D=3D -28 =3D=3D ENOSPC).  Probably worth seeing if you can
reproduce it there.


> And I am wondering if we really need to bug_on for every invalid retu=
rn value of btrfs_unlink_inode. Should we loosen it to something else?

The alternative is silently failing, and thereafter potentially
corrupting data.  There's been a good push of properly handling errors
though; it's not really a matter of loosening though.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
