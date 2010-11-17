From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Wed, 17 Nov 2010 20:56:46 +1100
Message-ID: <20101117095646.GB12974@brong.net>
References: <1289618724.28645.1405062363@webmail.messagingengine.com>
 <20101116125445.GA3229@brong.net>
 <1289914577-sup-8535@think>
 <20101117041148.GA10048@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101117041148.GA10048@brong.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 03:11:48PM +1100, Bron Gondwana wrote:
> > Could you sysrq-w while the performance is bad?  That would narrow it
> > down.
> 
> Here's one:
> 
> http://pastebin.com/Tg7agv42

And here's another one, inline this time.  The iostat for 10 seconds
just before said: (iostat -x 10 10)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          32.43    0.00   31.63   21.84    0.00   14.09

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.70    1.30    0.20    25.60     7.20    21.87     0.15  348.27  33.07   4.96
sda1              0.00     0.70    1.30    0.20    25.60     7.20    21.87     0.15  348.27  33.07   4.96
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda8              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00     6.00    0.10   75.20     0.80   860.80    11.44     0.01    0.15   0.06   0.48
sdb1              0.00     5.20    0.10    3.80     0.80    72.00    18.67     0.00    0.41   0.31   0.12
sdb2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb8              0.00     0.80    0.00   71.40     0.00   788.80    11.05     0.01    0.13   0.05   0.36
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd               0.00     2.40  121.80  252.40 43012.00 10223.20   142.26     2.61    6.76   1.24  46.56
sdd1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd4              0.00     2.40  121.80  252.40 43012.00 10223.20   142.26     2.61    6.76   1.24  46.56

(sdb8 and sdd4 are the meta and data partitions respectively - sdd4 is where
all the interesting stuff is happening)

By the way - we're running with the deadline scheduler, I'm pretty sure.
Let me know if that's silly...

[533206.344314] SysRq : Show Blocked State
[533206.344376]   task                        PC stack   pid father
[533206.344500] sync_server   D 0000000107f0e028     0 17027  10416 0x00020000
[533206.344564]  ffff88016c6898a8 0000000000200046 ffff88016c688010 ffff88022a153d00
[533206.344671]  ffff88016c689fd8 ffff88016c689fd8 0000000000013300 0000000000013300
[533206.344779]  0000000000013300 0000000000013300 0000000000013300 0000000000013300
[533206.344886] Call Trace:
[533206.344948]  [<ffffffff817c17dd>] io_schedule+0x4d/0x70
[533206.345005]  [<ffffffff81093e4d>] sync_page+0x3d/0x70
[533206.345061]  [<ffffffff817c1cfa>] __wait_on_bit+0x5a/0x90
[533206.345116]  [<ffffffff81093e10>] ? sync_page+0x0/0x70
[533206.345170]  [<ffffffff810940af>] wait_on_page_bit+0x6f/0x80
[533206.345227]  [<ffffffff8105dbd0>] ? wake_bit_function+0x0/0x40
[533206.345287]  [<ffffffff81278878>] ? submit_one_bio+0x88/0xa0
[533206.345341]  [<ffffffff8127cd2d>] read_extent_buffer_pages+0x4ed/0x530
[533206.345401]  [<ffffffff81254a30>] ? btree_get_extent+0x0/0x1a0
[533206.345456]  [<ffffffff8125490e>] btree_read_extent_buffer_pages+0x5e/0xc0
[533206.345512]  [<ffffffff81255406>] read_tree_block+0x56/0x80
[533206.345569]  [<ffffffff8123a235>] read_block_for_search+0x105/0x3d0
[533206.345626]  [<ffffffff81289869>] ? btrfs_tree_unlock+0x59/0x60
[533206.345680]  [<ffffffff81239ec5>] ? unlock_up+0x145/0x160
[533206.345735]  [<ffffffff81242602>] btrfs_search_slot+0x412/0x880
[533206.345792]  [<ffffffff8124351a>] btrfs_insert_empty_items+0x6a/0xd0
[533206.345850]  [<ffffffff810cc462>] ? kmem_cache_alloc+0x92/0xf0
[533206.345905]  [<ffffffff81254039>] btrfs_insert_inode_ref+0x79/0x190
[533206.345962]  [<ffffffff812627e1>] btrfs_add_link+0x121/0x1a0
[533206.346017]  [<ffffffff817c1f39>] ? mutex_unlock+0x9/0x10
[533206.346071]  [<ffffffff8126289e>] btrfs_add_nondir+0x3e/0x70
[533206.346126]  [<ffffffff81262fe2>] btrfs_link+0xe2/0x180
[533206.346182]  [<ffffffff810dead1>] vfs_link+0x101/0x160
[533206.346237]  [<ffffffff810e1f51>] sys_linkat+0x131/0x150
[533206.346293]  [<ffffffff810e1f89>] sys_link+0x19/0x20
[533206.346349]  [<ffffffff8102cc83>] ia32_sysret+0x0/0x5
[533206.346408] sync_server   D 0000000107f0e03c     0  5431  10416 0x00020000
[533206.346470]  ffff8800ca13bc58 0000000000200046 ffff8800ca13a010 ffff8801ea888000
[533206.346577]  ffff8800ca13bfd8 ffff8800ca13bfd8 0000000000013300 0000000000013300
[533206.347724]  0000000000013300 0000000000013300 0000000000013300 0000000000013300
[533206.347830] Call Trace:
[533206.347883]  [<ffffffff817c17dd>] io_schedule+0x4d/0x70
[533206.347937]  [<ffffffff810fdbb5>] sync_buffer+0x45/0x50
[533206.347992]  [<ffffffff817c1cfa>] __wait_on_bit+0x5a/0x90
[533206.348004]  [<ffffffff810fdb70>] ? sync_buffer+0x0/0x50
[533206.348004]  [<ffffffff810fdb70>] ? sync_buffer+0x0/0x50
[533206.348004]  [<ffffffff817c1da4>] out_of_line_wait_on_bit+0x74/0x90
[533206.348004]  [<ffffffff8105dbd0>] ? wake_bit_function+0x0/0x40
[533206.348004]  [<ffffffff810fdae6>] __wait_on_buffer+0x26/0x30
[533206.348004]  [<ffffffff81256e78>] write_dev_supers+0x238/0x310
[533206.348004]  [<ffffffff81257152>] write_all_supers+0x202/0x280
[533206.348004]  [<ffffffff812571de>] write_ctree_super+0xe/0x10
[533206.348004]  [<ffffffff8128f687>] btrfs_sync_log+0x3a7/0x5c0
[533206.348004]  [<ffffffff81267e27>] btrfs_sync_file+0x187/0x1b0
[533206.348004]  [<ffffffff810fa6e1>] vfs_fsync_range+0x81/0xa0
[533206.348004]  [<ffffffff810fa767>] vfs_fsync+0x17/0x20
[533206.348004]  [<ffffffff810fa7a5>] do_fsync+0x35/0x60
[533206.348004]  [<ffffffff810fa7fb>] sys_fsync+0xb/0x10
[533206.348004]  [<ffffffff8102cc83>] ia32_sysret+0x0/0x5
[533206.348004] Sched Debug Version: v0.09, 2.6.36-dev64 #1
[533206.348004] now at 533206348.885250 msecs
[533206.348004]   .jiffies                                 : 4428193883
[533206.348004]   .sysctl_sched_latency                    : 12.000000
[533206.348004]   .sysctl_sched_min_granularity            : 1.500000
[533206.348004]   .sysctl_sched_wakeup_granularity         : 2.000000
[533206.348004]   .sysctl_sched_child_runs_first           : 0
[533206.348004]   .sysctl_sched_features                   : 15471
[533206.348004]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[533206.348004] 
[533206.348004] cpu#0, 3000.402 MHz
[533206.348004]   .nr_running                    : 0
[533206.348004]   .load                          : 0
[533206.348004]   .nr_switches                   : 22546403
[533206.348004]   .nr_load_updates               : 133301585
[533206.348004]   .nr_uninterruptible            : 2
[533206.348004]   .next_balance                  : 4428.193884
[533206.348004]   .curr->pid                     : 0
[533206.348004]   .clock                         : 533206348.006654
[533206.348004]   .cpu_load[0]                   : 0
[533206.348004]   .cpu_load[1]                   : 0
[533206.348004]   .cpu_load[2]                   : 32
[533206.348004]   .cpu_load[3]                   : 147
[533206.348004]   .cpu_load[4]                   : 225
[533206.348004]   .yld_count                     : 0
[533206.348004]   .sched_switch                  : 0
[533206.348004]   .sched_count                   : 25635109
[533206.348004]   .sched_goidle                  : 8442206
[533206.348004]   .avg_idle                      : 891600
[533206.348004]   .ttwu_count                    : 11929488
[533206.348004]   .ttwu_local                    : 7108567
[533206.348004]   .bkl_count                     : 2862
[533206.348004] 
[533206.348004] cfs_rq[0]:
[533206.348004]   .exec_clock                    : 4785380.650156
[533206.348004]   .MIN_vruntime                  : 0.000001
[533206.348004]   .min_vruntime                  : 4266012.055723
[533206.348004]   .max_vruntime                  : 0.000001
[533206.348004]   .spread                        : 0.000000
[533206.348004]   .spread0                       : 0.000000
[533206.348004]   .nr_running                    : 0
[533206.348004]   .load                          : 0
[533206.348004]   .nr_spread_over                : 525
[533206.348004] 
[533206.348004] rt_rq[0]:
[533206.348004]   .rt_nr_running                 : 0
[533206.348004]   .rt_throttled                  : 0
[533206.348004]   .rt_time                       : 0.000000
[533206.348004]   .rt_runtime                    : 950.000000
[533206.348004] 
[533206.348004] runnable tasks:
[533206.348004]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[533206.348004] ----------------------------------------------------------------------------------------------------------
[533206.348004] 
[533206.348004] cpu#1, 3000.402 MHz
[533206.348004]   .nr_running                    : 1
[533206.348004]   .load                          : 1024
[533206.348004]   .nr_switches                   : 20052917
[533206.348004]   .nr_load_updates               : 133301525
[533206.348004]   .nr_uninterruptible            : 0
[533206.348004]   .next_balance                  : 4428.193883
[533206.348004]   .curr->pid                     : 6175
[533206.348004]   .clock                         : 533206344.023423
[533206.348004]   .cpu_load[0]                   : 0
[533206.348004]   .cpu_load[1]                   : 0
[533206.348004]   .cpu_load[2]                   : 15
[533206.348004]   .cpu_load[3]                   : 133
[533206.348004]   .cpu_load[4]                   : 330
[533206.348004]   .yld_count                     : 0
[533206.348004]   .sched_switch                  : 0
[533206.348004]   .sched_count                   : 24068035
[533206.348004]   .sched_goidle                  : 6629197
[533206.348004]   .avg_idle                      : 881626
[533206.348004]   .ttwu_count                    : 10794852
[533206.348004]   .ttwu_local                    : 8391194
[533206.348004]   .bkl_count                     : 2823
[533206.348004] 
[533206.348004] cfs_rq[1]:
[533206.348004]   .exec_clock                    : 4041404.226026
[533206.348004]   .MIN_vruntime                  : 0.000001
[533206.348004]   .min_vruntime                  : 4070860.187615
[533206.348004]   .max_vruntime                  : 0.000001
[533206.348004]   .spread                        : 0.000000
[533206.348004]   .spread0                       : -195151.868108
[533206.348004]   .nr_running                    : 1
[533206.348004]   .load                          : 1024
[533206.348004]   .nr_spread_over                : 615
[533206.348004] 
[533206.348004] rt_rq[1]:
[533206.348004]   .rt_nr_running                 : 0
[533206.348004]   .rt_throttled                  : 0
[533206.348004]   .rt_time                       : 0.000000
[533206.348004]   .rt_runtime                    : 950.000000
[533206.348004] 
[533206.348004] runnable tasks:
[533206.348004]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[533206.348004] ----------------------------------------------------------------------------------------------------------
[533206.348004] R           bash  6175   4070854.187615        73   120   4070854.187615        32.744445     49348.100455
[533206.348004] 

