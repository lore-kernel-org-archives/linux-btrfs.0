From: Andrew Lutomirski <luto@mit.edu>
Subject: 2.6.37: bash is looping unkillably in btrfs
Date: Sat, 12 Feb 2011 14:53:31 -0500
Message-ID: <AANLkTinSuRoiaTcPOV7_X=Zs+4-ad-Gx-oKWuhyHpjsO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have two processes that are unkillable and taking about 50% of a CPU
each.  There is no actual I/O happening (disk light is off and the
disk even spun down after awhile).  This may or may not be related to
unmounting a filesystem.  (I'm not sure -- I have two btrfs
failesystems and I unmounted one before I noticed the problem).

bash is in:

 [<ffffffff81423344>] schedule_timeout+0x36/0xe3
 [<ffffffff810348df>] ? ttwu_post_activation+0x60/0xf9
 [<ffffffff81030ee2>] ? need_resched+0x23/0x2d
 [<ffffffff8142312c>] wait_for_common+0xa8/0xf8
 [<ffffffff8103af01>] ? default_wake_function+0x0/0x14
 [<ffffffff81047c5f>] ? local_bh_enable_ip+0xe/0x10
 [<ffffffff81423234>] wait_for_completion+0x1d/0x1f
 [<ffffffff81114fa5>] writeback_inodes_sb_nr+0x76/0x7d
 [<ffffffff81115378>] writeback_inodes_sb_nr_if_idle+0x41/0x56
 [<ffffffffa01562b8>] shrink_delalloc.clone.43+0xa4/0x13c [btrfs]
 [<ffffffff814245c6>] ? _raw_spin_lock+0xe/0x10
 [<ffffffffa0159aae>] btrfs_delalloc_reserve_metadata+0x12e/0x140 [btrfs]
 [<ffffffffa0159b94>] btrfs_delalloc_reserve_space+0x2a/0x47 [btrfs]
 [<ffffffff810b5db0>] ? unlock_page+0x2a/0x2f
 [<ffffffffa0172885>] btrfs_file_aio_write+0x503/0x8b3 [btrfs]
 [<ffffffff811c302e>] ? security_dentry_open+0x2f/0x33
 [<ffffffff8110dcef>] ? mnt_want_write+0x2e/0x4a
 [<ffffffff810f78fe>] do_sync_write+0xcb/0x108
 [<ffffffff81030efa>] ? should_resched+0xe/0x2e
 [<ffffffff811ca3a2>] ? selinux_file_permission+0x5a/0xb9
 [<ffffffff811c2f0a>] ? security_file_permission+0x2e/0x33
 [<ffffffff810f7fed>] vfs_write+0xac/0xff
 [<ffffffff810f81f4>] sys_write+0x4a/0x6e
 [<ffffffff81002beb>] system_call_fastpath+0x16/0x1b

flush-btrfs-6 is in:

 [<ffffffff81115f50>] bdi_writeback_thread+0x151/0x20b
 [<ffffffff81115dff>] ? bdi_writeback_thread+0x0/0x20b
 [<ffffffff81115dff>] ? bdi_writeback_thread+0x0/0x20b
 [<ffffffff8105c550>] kthread+0x82/0x8a
 [<ffffffff81003994>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105c4ce>] ? kthread+0x0/0x8a
 [<ffffffff81003990>] ? kernel_thread_helper+0x0/0x10

perf top says:

              870.00 23.2% clockevents_program_event
/lib/modules/2.6.37+/build/vmlinux
              541.00 14.4% update_ts_time_stats
/lib/modules/2.6.37+/build/vmlinux
              465.00 12.4% sched_clock
/lib/modules/2.6.37+/build/vmlinux
              133.00  3.5% get_next_timer_interrupt
/lib/modules/2.6.37+/build/vmlinux
              116.00  3.1% schedule
/lib/modules/2.6.37+/build/vmlinux
               57.00  1.5% pick_next_task_fair
/lib/modules/2.6.37+/build/vmlinux
               55.00  1.5% select_task_rq_fair
/lib/modules/2.6.37+/build/vmlinux
               50.00  1.3% __switch_to
/lib/modules/2.6.37+/build/vmlinux
               46.00  1.2% enqueue_hrtimer
/lib/modules/2.6.37+/build/vmlinux
               45.00  1.2% ktime_get
/lib/modules/2.6.37+/build/vmlinux
               44.00  1.2% read_hpet
/lib/modules/2.6.37+/build/vmlinux
               37.00  1.0% try_to_wake_up
/lib/modules/2.6.37+/build/vmlinux
               36.00  1.0% task_rq_lock
/lib/modules/2.6.37+/build/vmlinux
               36.00  1.0% update_rq_clock
/lib/modules/2.6.37+/build/vmlinux
               34.00  0.9% sched_clock_cpu
/lib/modules/2.6.37+/build/vmlinux
               33.00  0.9% tick_nohz_restart_sched_tick
/lib/modules/2.6.37+/build/vmlinux
               32.00  0.9% resched_task
/lib/modules/2.6.37+/build/vmlinux
               31.00  0.8% enqueue_entity
/lib/modules/2.6.37+/build/vmlinux
               31.00  0.8% _raw_spin_unlock_irqrestore
/lib/modules/2.6.37+/build/vmlinux
               31.00  0.8% reschedule_interrupt
/lib/modules/2.6.37+/build/vmlinux
               30.00  0.8% c1e_idle
/lib/modules/2.6.37+/build/vmlinux
               30.00  0.8% _raw_spin_lock
/lib/modules/2.6.37+/build/vmlinux
               29.00  0.8% tick_nohz_stop_sched_tick
/lib/modules/2.6.37+/build/vmlinux
               27.00  0.7% place_entity
/lib/modules/2.6.37+/build/vmlinux
               25.00  0.7% wb_do_writeback
/lib/modules/2.6.37+/build/vmlinux
               25.00  0.7% sched_clock_local
/lib/modules/2.6.37+/build/vmlinux
               24.00  0.6% do_raw_spin_lock
/lib/modules/2.6.37+/build/vmlinux
               22.00  0.6% local_bh_disable
/lib/modules/2.6.37+/build/vmlinux
               22.00  0.6% rb_insert_color
/lib/modules/2.6.37+/build/vmlinux
               22.00  0.6% _raw_spin_lock_bh
/lib/modules/2.6.37+/build/vmlinux
               21.00  0.6% __hrtimer_start_range_ns
/lib/modules/2.6.37+/build/vmlinux
               21.00  0.6% rb_erase
/lib/modules/2.6.37+/build/vmlinux
               20.00  0.5% hrtick_update
/lib/modules/2.6.37+/build/vmlinux
               19.00  0.5% dec128
/lib/modules/2.6.37+/kernel/arch/x86/crypto/aes-x86_64.ko
               19.00  0.5% select_nohz_load_balancer
/lib/modules/2.6.37+/build/vmlinux
               18.00  0.5% select_idle_sibling
/lib/modules/2.6.37+/build/vmlinux
               17.00  0.5% update_curr
/lib/modules/2.6.37+/build/vmlinux

powertop shows 47k IPI per seconds ("rescheduling interrupts").

perf record -p 14726 [btrfs] caused bash to die and *perf* started
spinning with btrfs.  Then, about ten seconds later (after a few
SIGKILLs to perf), flush-btrfs-6 went idle and perf died.

In my system's current state, everything is idle. If I attach perf to
flush-btrfs-6, everything stays idle.  But if I ctrl-C perf, then perf
and btrfs both start spinning for awhile.  Hitting ctrl-C again will
make them spin a bit more.  Sending SIGTERM will make them spin and
then, after awhile, perf dies and flush-btrfs-6 becomes idle again.

If I ssh in and log out, bash takes a long time to exit (but remains
idle in the D state).  Some fiddling with strace makes it look like
writing to .bash_history is getting stuck, and the kernel says it got
stuck here:

bash          S 0000000110a56004     0 15296  15295 0x00000000
 ffff880002a65af8 0000000000000086 0000000000000286 ffffffff8180b020
 ffffffff00000000 0000000000011740 0000000000011740 0000000000011740
 ffff880001cbdac0 0000000000011740 ffff880002a65fd8 0000000000011740
Call Trace:
 [<ffffffff814233b9>] schedule_timeout+0xab/0xe3
 [<ffffffff8104eea2>] ? process_timeout+0x0/0x10
 [<ffffffffa015630d>] shrink_delalloc.clone.43+0xf9/0x13c [btrfs]
 [<ffffffff814245c6>] ? _raw_spin_lock+0xe/0x10
 [<ffffffffa0159aae>] btrfs_delalloc_reserve_metadata+0x12e/0x140 [btrfs]
 [<ffffffffa0159b94>] btrfs_delalloc_reserve_space+0x2a/0x47 [btrfs]
 [<ffffffff810b5db0>] ? unlock_page+0x2a/0x2f
 [<ffffffffa0172885>] btrfs_file_aio_write+0x503/0x8b3 [btrfs]
 [<ffffffff811c302e>] ? security_dentry_open+0x2f/0x33
 [<ffffffff8110dcef>] ? mnt_want_write+0x2e/0x4a
 [<ffffffff810f78fe>] do_sync_write+0xcb/0x108
 [<ffffffff81030efa>] ? should_resched+0xe/0x2e
 [<ffffffff811ca3a2>] ? selinux_file_permission+0x5a/0xb9
 [<ffffffff811c2f0a>] ? security_file_permission+0x2e/0x33
 [<ffffffff810f7fed>] vfs_write+0xac/0xff
 [<ffffffff810f81f4>] sys_write+0x4a/0x6e
 [<ffffffff81002beb>] system_call_fastpath+0x16/0x1b

/ is ext4, but /home is btrfs (over LVM over dm-crypt).

If I do echo 'foo >>.bash_history', the echo command takes a long
time.  I can delete .bash_history quickly, but creating a new file
with the same name and writing to it takes forever.

Since my last reboot, I've copied about 750GB onto /home from another
btrfs partition.  Both were mounted -o space_cache,compress.  I've
since unmounted the source partition.

I'll leave the system running for awhile in case any of you have any
ideas of things to try.
