From: Proskurin Kirill <k.proskurin@corp.mail.ru>
Subject: Re: [btrfs-transacti] & btrfs-endio-wri] - WAS: Re: [btrfs-delalloc-]
Date: Fri, 01 Jul 2011 11:11:31 +0400
Message-ID: <4E0D7323.9010202@corp.mail.ru>
Reply-To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020500070309060109070400"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020500070309060109070400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/30/2011 09:13 PM, Josef Bacik wrote:
 > On 06/30/2011 10:12 AM, Proskurin Kirill wrote:
 >> On 06/29/2011 08:14 PM, Josef Bacik wrote:
 >>>> Ok - I upgrade to 2.6.39-2 but it is seems to all things get worse.
 >>>> Now I see [btrfs-transacti]&   btrfs-endio-wri] 80-100% all the 
time and
 >>>> io performance looks like lower then before.
 >>>>
 >>>> Our scribe daemon in state D most of the time with half of a normal
 >>>> load. Only kernel was changed.
 >>>>
 >>>> Any performance tune recommendation?
 >>>>
 >>>
 >>> Can you get sysrq+w while this problem is happening so we can see whats
 >>> going on?  Thanks,
 >>
 >> I attached sysrq+w. Hope it helps.
 >>
 >
 > Heh so it just looks like you are writing a bunch of stuff, that's not
 > particularly helpful.  What does this program do generically?  How full
 > is your fs?  Do you have snapshots/subvolumes?  If so how many?  Thanks,

I found what my btrfs partition now is really slow. Something wrong 
happend. I try on 2.6.32 and 2.6.39 - same result. It is because 
partition is almost full?

I run a simple cycle to clean some old files:
for i in `cat /tmp/delit`; do rm -f $i ; done

And it is takes about 5-10 second per file to delete.
I get sysrq+w while rm is work - it is attached.

-- 
Best regards,
Proskurin Kirill

--------------020500070309060109070400
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

SysRq : Show Blocked State
  task                        PC stack   pid father
rm            D 0000000000000002     0  5662   4515 0x00000080
 ffff880110d916d8 0000000000000082 0000000000000000 ffffffffa024d97b
 ffff880067324e40 0000000045e1ab10 0000000000003000 000000010015dcde
 ffff88013b6145f8 ffff880110d91fd8 000000000000f598 ffff88013b6145f8
Call Trace:
 [<ffffffffa024d97b>] ? md_raid5_unplug_device+0x7b/0x100 [raid456]
 [<ffffffff8110d310>] ? sync_page+0x0/0x50
 [<ffffffff814db013>] io_schedule+0x73/0xc0
 [<ffffffff8110d34d>] sync_page+0x3d/0x50
 [<ffffffff814db87f>] __wait_on_bit+0x5f/0x90
 [<ffffffff8110d503>] wait_on_page_bit+0x73/0x80
 [<ffffffff8108e140>] ? wake_bit_function+0x0/0x50
 [<ffffffffa0203512>] ? submit_one_bio+0x82/0xa0 [btrfs]
 [<ffffffffa020a30a>] read_extent_buffer_pages+0x39a/0x430 [btrfs]
 [<ffffffffa01dd0d0>] ? btree_get_extent+0x0/0x1b0 [btrfs]
 [<ffffffffa01e069d>] btree_read_extent_buffer_pages+0x5d/0xc0 [btrfs]
 [<ffffffffa01e077c>] read_tree_block+0x3c/0x60 [btrfs]
 [<ffffffffa01c2251>] read_block_for_search+0xf1/0x3b0 [btrfs]
 [<ffffffffa01ca079>] btrfs_search_slot+0x309/0x8a0 [btrfs]
 [<ffffffffa0204002>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa01d5d0c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa01d6406>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa01d6f3e>] run_clustered_refs+0x4de/0x7f0 [btrfs]
 [<ffffffffa0223f00>] ? btrfs_find_ref_cluster+0x70/0x180 [btrfs]
 [<ffffffffa01d7318>] btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
 [<ffffffffa01e4c0f>] __btrfs_end_transaction+0x6f/0x240 [btrfs]
 [<ffffffffa01e4e35>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa01ec077>] btrfs_delete_inode+0x197/0x200 [btrfs]
 [<ffffffffa01ebee0>] ? btrfs_delete_inode+0x0/0x200 [btrfs]
 [<ffffffff8118cfbe>] generic_delete_inode+0xde/0x1d0
 [<ffffffff8118d115>] generic_drop_inode+0x65/0x80
 [<ffffffffa01e593d>] btrfs_drop_inode+0x3d/0x50 [btrfs]
 [<ffffffff8118bf82>] iput+0x62/0x70
 [<ffffffff81183332>] do_unlinkat+0x112/0x1c0
 [<ffffffff810d1ac2>] ? audit_syscall_entry+0x272/0x2a0
 [<ffffffff8100c635>] ? math_state_restore+0x45/0x60
 [<ffffffff81183542>] sys_unlinkat+0x22/0x40
 [<ffffffff8100b172>] system_call_fastpath+0x16/0x1b
Sched Debug Version: v0.09, 2.6.32-131.2.1.el6.x86_64 #1
now at 1733266.774675 msecs
  .jiffies                                 : 4296400562
  .sysctl_sched_latency                    : 20.000000
  .sysctl_sched_min_granularity            : 4.000000
  .sysctl_sched_wakeup_granularity         : 4.000000
  .sysctl_sched_child_runs_first           : 0.000000
  .sysctl_sched_features                   : 15471
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2133.291 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 372148
  .nr_load_updates               : 89485
  .nr_uninterruptible            : 0
  .next_balance                  : 4296.400777
  .curr->pid                     : 0
  .clock                         : 1733558.607055
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 6
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 457866
  .sched_goidle                  : 145476
  .avg_idle                      : 994900
  .ttwu_count                    : 224174
  .ttwu_local                    : 204302
  .bkl_count                     : 4650

cfs_rq[0]:/
  .exec_clock                    : 13532.801929
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 10873.718018
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 3
  .shares                        : 0

rt_rq[0]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 2133.291 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 125069
  .nr_load_updates               : 96598
  .nr_uninterruptible            : 0
  .next_balance                  : 4296.400301
  .curr->pid                     : 1580
  .clock                         : 1733558.605958
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 127082
  .sched_goidle                  : 60684
  .avg_idle                      : 1000000
  .ttwu_count                    : 60266
  .ttwu_local                    : 10064
  .bkl_count                     : 6630

cfs_rq[1]:/
  .exec_clock                    : 25013.360831
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 45289.962797
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 34416.244779
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 2
  .shares                        : 0

rt_rq[1]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R           bash  1580     45279.962797      1489   120     45279.962797       352.482840   1659257.828784 /

cpu#2, 2133.291 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 122920
  .nr_load_updates               : 26649
  .nr_uninterruptible            : 1
  .next_balance                  : 4296.400621
  .curr->pid                     : 0
  .clock                         : 1733533.652875
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 6
  .cpu_load[2]                   : 78
  .cpu_load[3]                   : 149
  .cpu_load[4]                   : 143
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 124483
  .sched_goidle                  : 61382
  .avg_idle                      : 603803
  .ttwu_count                    : 61297
  .ttwu_local                    : 3260
  .bkl_count                     : 33912

cfs_rq[2]:/
  .exec_clock                    : 7903.680459
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 9314.025022
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1559.692996
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0

rt_rq[2]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#3, 2133.291 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 70500
  .nr_load_updates               : 12786
  .nr_uninterruptible            : 0
  .next_balance                  : 4296.399833
  .curr->pid                     : 0
  .clock                         : 1731987.822051
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 72721
  .sched_goidle                  : 35349
  .avg_idle                      : 1000000
  .ttwu_count                    : 35222
  .ttwu_local                    : 1478
  .bkl_count                     : 25

cfs_rq[3]:/
  .exec_clock                    : 2883.239869
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 6055.083725
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -4818.634293
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 1
  .shares                        : 0

rt_rq[3]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#4, 2133.291 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 108836
  .nr_load_updates               : 45082
  .nr_uninterruptible            : 0
  .next_balance                  : 4296.400474
  .curr->pid                     : 0
  .clock                         : 1733466.669415
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 122823
  .sched_goidle                  : 44935
  .avg_idle                      : 1000000
  .ttwu_count                    : 63644
  .ttwu_local                    : 52851
  .bkl_count                     : 37

cfs_rq[4]:/
  .exec_clock                    : 5605.062606
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 5881.068010
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -4992.650008
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 1
  .shares                        : 0

rt_rq[4]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#5, 2133.291 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 60362
  .nr_load_updates               : 66095
  .nr_uninterruptible            : 0
  .next_balance                  : 4296.399833
  .curr->pid                     : 0
  .clock                         : 1731981.794590
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 62541
  .sched_goidle                  : 28815
  .avg_idle                      : 1000000
  .ttwu_count                    : 27051
  .ttwu_local                    : 11026
  .bkl_count                     : 29

cfs_rq[5]:/
  .exec_clock                    : 17577.306616
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 38511.776850
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 27638.058832
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0

rt_rq[5]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#6, 2133.291 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 29931
  .nr_load_updates               : 26485
  .nr_uninterruptible            : 0
  .next_balance                  : 4296.399833
  .curr->pid                     : 0
  .clock                         : 1731978.719987
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 32109
  .sched_goidle                  : 15046
  .avg_idle                      : 1000000
  .ttwu_count                    : 14658
  .ttwu_local                    : 2860
  .bkl_count                     : 35

cfs_rq[6]:/
  .exec_clock                    : 2533.935401
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4641.229946
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -6232.488072
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0

rt_rq[6]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#7, 2133.291 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 7303
  .nr_load_updates               : 11627
  .nr_uninterruptible            : 0
  .next_balance                  : 4296.399833
  .curr->pid                     : 0
  .clock                         : 1732293.736790
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 9107
  .sched_goidle                  : 3850
  .avg_idle                      : 1000000
  .ttwu_count                    : 3437
  .ttwu_local                    : 1519
  .bkl_count                     : 17

cfs_rq[7]:/
  .exec_clock                    : 766.603798
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 998.119827
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -9875.598191
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0
  .shares                        : 0

rt_rq[7]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------


--------------020500070309060109070400--
