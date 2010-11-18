From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Interesting problem with write data.
Date: Thu, 18 Nov 2010 15:57:34 +0100
Message-ID: <4CE53EDE.0@wpkg.org>
References: <4CE51613.8060609@wpkg.org> <1290090160-sup-1717@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290090160-sup-1717@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 18.11.2010 15:23, Chris Mason wrote:
> Excerpts from Tomasz Chmielewski's message of 2010-11-18 07:03:31 -0500:
>>>    Recently, I made a btrfs to use. And I met slowness problem. Trying
>>> to diag it. I found this:
>>> 1. dd if=/dev/zero of=test count=1024 bs=1MB
>>> This is fast, at about 25MB/s, and reasonable iowait.
>>> 2. dd if=/dev/zero of=test count=1 bs=1GB
>>> This is pretty slow, at about 1.5MB/s, and 90%+ iowait, constantly.
>>>    May I know why it works like this? Thanks.
>>
>> Reproducible here to some extent with 2.6.37-rc2.
>>
>> Interesting is, it only happens for me when I mount the filesystem, dd a smaller file, then a bigger one, in that order.
>>
>> Any subsequent dd / sync / rm usage doesn't seem to trigger it anymore (have to umount / mount again to trigger this).
> 
> I'm going to guess this is the flushing threads, could you please run
> vmstat and see if there is a stream of reads?

I guess you meant this during the second dd run:

# vmstat -p /dev/sdb4 1

sdb4          reads   read sectors  writes    requested writes
               95130     802552      88431   76340880
               95288     803880      88431   76340880
               95439     805144      88431   76340880
               95574     806288      88431   76340880
               95671     807112      88431   76340880
               95777     807984      88431   76340880
               95925     809232      88431   76340880
               96143     811072      88431   76340880
               96293     812344      88431   76340880
(...)


>   sysrq-w during the second dd would show it as well.

[27821.905901] SysRq : Show Blocked State
[27821.905906]   task                        PC stack   pid father
[27821.905949] btrfs-transac D ffff88050cf01a58     0  7969      2 0x00000000
[27821.905954]  ffff88050f2e5ac0 0000000000000046 29ea5679c098e259 ffff88050f2e5fd8
[27821.905959]  00000000000139c0 00000000000139c0 ffff88050f2e5fd8 ffff88050f2e5fd8
[27821.905963]  00000000000139c0 ffff88050cf01a58 ffff88050cf01a60 ffff88050cf016c0
[27821.905968] Call Trace:
[27821.905977]  [<ffffffff8159fc4e>] io_schedule+0x5e/0xa0
[27821.905982]  [<ffffffff81109f15>] sync_page+0x45/0x60
[27821.905987]  [<ffffffff815a03da>] __wait_on_bit_lock+0x5a/0xb0
[27821.905990]  [<ffffffff81109ed0>] ? sync_page+0x0/0x60
[27821.905994]  [<ffffffff81109e9a>] __lock_page+0x6a/0x80
[27821.905999]  [<ffffffff81085e40>] ? wake_bit_function+0x0/0x40
[27821.906004]  [<ffffffff81115277>] ? pagevec_lookup_tag+0x27/0x40
[27821.906031]  [<ffffffffa023e8c3>] extent_write_cache_pages+0x1a3/0x2d0 [btrfs]
[27821.906047]  [<ffffffffa023e370>] ? flush_write_bio+0x0/0x10 [btrfs]
[27821.906063]  [<ffffffffa02425a0>] ? __extent_writepage+0x0/0x610 [btrfs]
[27821.906079]  [<ffffffffa023ea44>] extent_writepages+0x54/0x70 [btrfs]
[27821.906095]  [<ffffffffa022c210>] ? btrfs_get_extent+0x0/0x830 [btrfs]
[27821.906111]  [<ffffffffa0223a88>] btrfs_writepages+0x28/0x30 [btrfs]
[27821.906115]  [<ffffffff81114261>] do_writepages+0x21/0x40
[27821.906118]  [<ffffffff8110a4de>] __filemap_fdatawrite_range+0x5e/0x70
[27821.906122]  [<ffffffff8110aa2c>] filemap_flush+0x1c/0x20
[27821.906138]  [<ffffffffa023dd52>] btrfs_run_ordered_operations+0x192/0x200 [btrfs]
[27821.906154]  [<ffffffffa0221791>] btrfs_commit_transaction+0x71/0x620 [btrfs]
[27821.906158]  [<ffffffff815a067e>] ? mutex_lock+0x1e/0x50
[27821.906162]  [<ffffffff81085e00>] ? autoremove_wake_function+0x0/0x40
[27821.906177]  [<ffffffffa021c4f2>] transaction_kthread+0x242/0x250 [btrfs]
[27821.906191]  [<ffffffffa021c2b0>] ? transaction_kthread+0x0/0x250 [btrfs]
[27821.906195]  [<ffffffff81085727>] kthread+0x97/0xa0
[27821.906200]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[27821.906204]  [<ffffffff81085690>] ? kthread+0x0/0xa0
[27821.906207]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10
[27821.906210] flush-btrfs-6 D ffff8805c9bf5e98     0  8028      2 0x00000000
[27821.906215]  ffff8805b889d6c0 0000000000000046 ffff8805b889d680 ffff8805b889dfd8
[27821.906219]  00000000000139c0 00000000000139c0 ffff8805b889dfd8 ffff8805b889dfd8
[27821.906223]  00000000000139c0 ffff8805c9bf5e98 ffff8805c9bf5ea0 ffff8805c9bf5b00
[27821.906228] Call Trace:
[27821.906240]  [<ffffffffa020d31e>] wait_block_group_cache_progress+0xde/0x110 [btrfs]
[27821.906245]  [<ffffffff81085e00>] ? autoremove_wake_function+0x0/0x40
[27821.906249]  [<ffffffff81085e00>] ? autoremove_wake_function+0x0/0x40
[27821.906261]  [<ffffffffa0213608>] ? cache_block_group+0x188/0x2b0 [btrfs]
[27821.906274]  [<ffffffffa0213b13>] find_free_extent+0x3e3/0xb30 [btrfs]
[27821.906278]  [<ffffffff81054e48>] ? finish_task_switch+0x68/0xe0
[27821.906291]  [<ffffffffa0212e43>] ? do_chunk_alloc+0x153/0x1d0 [btrfs]
[27821.906304]  [<ffffffffa0214315>] btrfs_reserve_extent+0xb5/0x170 [btrfs]
[27821.906320]  [<ffffffffa022688b>] cow_file_range+0x19b/0x360 [btrfs]
[27821.906336]  [<ffffffffa022d8be>] run_delalloc_range+0x6e/0x80 [btrfs]
[27821.906351]  [<ffffffffa0242a3a>] __extent_writepage+0x49a/0x610 [btrfs]
[27821.906356]  [<ffffffff812cfe40>] ? radix_tree_gang_lookup_tag_slot+0x90/0xd0
[27821.906360]  [<ffffffff8110bde5>] ? find_get_pages_tag+0x45/0xf0
[27821.906376]  [<ffffffffa023e928>] extent_write_cache_pages+0x208/0x2d0 [btrfs]
[27821.906392]  [<ffffffffa023e370>] ? flush_write_bio+0x0/0x10 [btrfs]
[27821.906407]  [<ffffffffa02425a0>] ? __extent_writepage+0x0/0x610 [btrfs]
[27821.906424]  [<ffffffffa023ea44>] extent_writepages+0x54/0x70 [btrfs]
[27821.906440]  [<ffffffffa022c210>] ? btrfs_get_extent+0x0/0x830 [btrfs]
[27821.906455]  [<ffffffffa0223a88>] btrfs_writepages+0x28/0x30 [btrfs]
[27821.906459]  [<ffffffff81114261>] do_writepages+0x21/0x40
[27821.906464]  [<ffffffff811820ab>] writeback_single_inode+0xab/0x200
[27821.906469]  [<ffffffff8118246c>] writeback_sb_inodes+0xdc/0x150
[27821.906473]  [<ffffffff81182652>] writeback_inodes_wb+0xd2/0xf0
[27821.906478]  [<ffffffff8118286f>] wb_writeback+0x1ff/0x310
[27821.906482]  [<ffffffff81182a8d>] wb_do_writeback+0x6d/0xe0
[27821.906486]  [<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x260
[27821.906490]  [<ffffffff81182bb3>] bdi_writeback_thread+0xb3/0x260
[27821.906495]  [<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x260
[27821.906499]  [<ffffffff81085727>] kthread+0x97/0xa0
[27821.906503]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[27821.906507]  [<ffffffff81085690>] ? kthread+0x0/0xa0
[27821.906510]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10
[27821.906513] btrfs-cache-8 D ffff88050c5fde98     0  8089      2 0x00000000
[27821.906517]  ffff88051c3a9b60 0000000000000046 ffff88051c3a9b00 ffff88051c3a9fd8
[27821.906522]  00000000000139c0 00000000000139c0 ffff88051c3a9fd8 ffff88051c3a9fd8
[27821.906526]  00000000000139c0 ffff88050c5fde98 ffff88050c5fdea0 ffff88050c5fdb00
[27821.906530] Call Trace:
[27821.906534]  [<ffffffff8159fc4e>] io_schedule+0x5e/0xa0
[27821.906538]  [<ffffffff81109f15>] sync_page+0x45/0x60
[27821.906542]  [<ffffffff815a051e>] __wait_on_bit+0x5e/0x90
[27821.906545]  [<ffffffff81109ed0>] ? sync_page+0x0/0x60
[27821.906548]  [<ffffffff8110a065>] wait_on_page_bit+0x75/0x80
[27821.906553]  [<ffffffff81085e40>] ? wake_bit_function+0x0/0x40
[27821.906568]  [<ffffffffa023e308>] ? submit_one_bio+0x88/0xa0 [btrfs]
[27821.906584]  [<ffffffffa0244348>] read_extent_buffer_pages+0x2b8/0x380 [btrfs]
[27821.906598]  [<ffffffffa021c120>] ? btree_get_extent+0x0/0x190 [btrfs]
[27821.906613]  [<ffffffffa021d47e>] btree_read_extent_buffer_pages+0x5e/0xc0 [btrfs]
[27821.906630]  [<ffffffffa021d55c>] read_tree_block+0x3c/0x60 [btrfs]
[27821.906642]  [<ffffffffa0203a08>] read_block_for_search+0xe8/0x1d0 [btrfs]
[27821.906654]  [<ffffffffa0208993>] btrfs_search_slot+0x3d3/0x600 [btrfs]
[27821.906666]  [<ffffffffa0211193>] caching_kthread+0x153/0x3e0 [btrfs]
[27821.906679]  [<ffffffffa0211040>] ? caching_kthread+0x0/0x3e0 [btrfs]
[27821.906683]  [<ffffffff81085727>] kthread+0x97/0xa0
[27821.906687]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[27821.906691]  [<ffffffff81085690>] ? kthread+0x0/0xa0
[27821.906695]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10
[27821.906698] Sched Debug Version: v0.09, 2.6.37-020637rc2-generic #201011160905
[27821.906701] now at 27832930.981275 msecs
[27821.906703]   .jiffies                                 : 4297720589
[27821.906706]   .sysctl_sched_latency                    : 24.000000
[27821.906708]   .sysctl_sched_min_granularity            : 3.000000
[27821.906710]   .sysctl_sched_wakeup_granularity         : 4.000000
[27821.906712]   .sysctl_sched_child_runs_first           : 0
[27821.906714]   .sysctl_sched_features                   : 31855
[27821.906717]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[27821.906720] 
[27821.906721] cpu#0, 3073.849 MHz
[27821.906722]   .nr_running                    : 1
[27821.906725]   .load                          : 1024
[27821.906727]   .nr_switches                   : 31602424
[27821.906729]   .nr_load_updates               : 1233322
[27821.906731]   .nr_uninterruptible            : 0
[27821.906733]   .next_balance                  : 4297.720590
[27821.906735]   .curr->pid                     : 8056
[27821.906737]   .clock                         : 27821905.756718
[27821.906739]   .cpu_load[0]                   : 0
[27821.906741]   .cpu_load[1]                   : 0
[27821.906743]   .cpu_load[2]                   : 0
[27821.906744]   .cpu_load[3]                   : 4
[27821.906746]   .cpu_load[4]                   : 26
[27821.906748]   .yld_count                     : 19611
[27821.906750]   .sched_switch                  : 0
[27821.906752]   .sched_count                   : 50345565
[27821.906754]   .sched_goidle                  : 14570774
[27821.906756]   .avg_idle                      : 875098
[27821.906758]   .ttwu_count                    : 16130569
[27821.906760]   .ttwu_local                    : 4655514
[27821.906762]   .bkl_count                     : 0
[27821.906765] 
[27821.906765] cfs_rq[0]:/
[27821.906767]   .exec_clock                    : 2537027.925314
[27821.906770]   .MIN_vruntime                  : 0.000001
[27821.906772]   .min_vruntime                  : 1983458.623883
[27821.906774]   .max_vruntime                  : 0.000001
[27821.906776]   .spread                        : 0.000000
[27821.906778]   .spread0                       : 0.000000
[27821.906780]   .nr_running                    : 1
[27821.906783]   .load                          : 1024
[27821.906785]   .nr_spread_over                : 11
[27821.906786]   .shares                        : 0
[27821.906789] 
[27821.906789] rt_rq[0]:/
[27821.906791]   .rt_nr_running                 : 0
[27821.906793]   .rt_throttled                  : 0
[27821.906795]   .rt_time                       : 0.000000
[27821.906797]   .rt_runtime                    : 950.000000
[27821.906799] 
[27821.906800] runnable tasks:
[27821.906801]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.906802] ----------------------------------------------------------------------------------------------------------
[27821.906820] R           bash  8056   1983446.623883        56   120   1983446.623883        12.115923     33377.263784 /
[27821.906828] 
[27821.906829] cpu#1, 3073.849 MHz
[27821.906831]   .nr_running                    : 0
[27821.906833]   .load                          : 0
[27821.906835]   .nr_switches                   : 13412412
[27821.906837]   .nr_load_updates               : 499440
[27821.906839]   .nr_uninterruptible            : 0
[27821.906841]   .next_balance                  : 4297.720590
[27821.906843]   .curr->pid                     : 0
[27821.906845]   .clock                         : 27821905.768860
[27821.906847]   .cpu_load[0]                   : 0
[27821.906849]   .cpu_load[1]                   : 0
[27821.906850]   .cpu_load[2]                   : 0
[27821.906852]   .cpu_load[3]                   : 0
[27821.906854]   .cpu_load[4]                   : 0
[27821.906856]   .yld_count                     : 14079
[27821.906858]   .sched_switch                  : 0
[27821.906860]   .sched_count                   : 13912141
[27821.906862]   .sched_goidle                  : 6345593
[27821.906864]   .avg_idle                      : 776881
[27821.906866]   .ttwu_count                    : 6900627
[27821.906867]   .ttwu_local                    : 2420071
[27821.906869]   .bkl_count                     : 0
[27821.906871] 
[27821.906872] cfs_rq[1]:/
[27821.906874]   .exec_clock                    : 1416231.470534
[27821.906876]   .MIN_vruntime                  : 0.000001
[27821.906878]   .min_vruntime                  : 1862178.757372
[27821.906880]   .max_vruntime                  : 0.000001
[27821.906883]   .spread                        : 0.000000
[27821.906885]   .spread0                       : -121279.866511
[27821.906887]   .nr_running                    : 0
[27821.906889]   .load                          : 0
[27821.906891]   .nr_spread_over                : 7
[27821.906892]   .shares                        : 0
[27821.906894] 
[27821.906895] rt_rq[1]:/
[27821.906897]   .rt_nr_running                 : 0
[27821.906898]   .rt_throttled                  : 0
[27821.906900]   .rt_time                       : 0.000000
[27821.906903]   .rt_runtime                    : 950.000000
[27821.906905] 
[27821.906905] runnable tasks:
[27821.906906]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.906908] ----------------------------------------------------------------------------------------------------------
[27821.906925] 
[27821.906925] cpu#2, 3073.849 MHz
[27821.906927]   .nr_running                    : 0
[27821.906929]   .load                          : 0
[27821.906931]   .nr_switches                   : 5352740
[27821.906933]   .nr_load_updates               : 226631
[27821.906935]   .nr_uninterruptible            : 0
[27821.906937]   .next_balance                  : 4297.720518
[27821.906939]   .curr->pid                     : 0
[27821.906941]   .clock                         : 27821899.402595
[27821.906943]   .cpu_load[0]                   : 0
[27821.906944]   .cpu_load[1]                   : 0
[27821.906946]   .cpu_load[2]                   : 0
[27821.906948]   .cpu_load[3]                   : 0
[27821.906950]   .cpu_load[4]                   : 0
[27821.906952]   .yld_count                     : 12852
[27821.906954]   .sched_switch                  : 0
[27821.906955]   .sched_count                   : 97641962
[27821.906957]   .sched_goidle                  : 2593371
[27821.906959]   .avg_idle                      : 1000000
[27821.906961]   .ttwu_count                    : 2720117
[27821.906963]   .ttwu_local                    : 1211500
[27821.906965]   .bkl_count                     : 0
[27821.906967] 
[27821.906968] cfs_rq[2]:/
[27821.906969]   .exec_clock                    : 539665.750622
[27821.906972]   .MIN_vruntime                  : 0.000001
[27821.906974]   .min_vruntime                  : 979243.698927
[27821.906976]   .max_vruntime                  : 0.000001
[27821.906978]   .spread                        : 0.000000
[27821.906980]   .spread0                       : -1004214.924956
[27821.906982]   .nr_running                    : 0
[27821.906984]   .load                          : 0
[27821.906986]   .nr_spread_over                : 2
[27821.906988]   .shares                        : 0
[27821.906990] 
[27821.906990] rt_rq[2]:/
[27821.906992]   .rt_nr_running                 : 0
[27821.906994]   .rt_throttled                  : 0
[27821.906996]   .rt_time                       : 0.000000
[27821.906998]   .rt_runtime                    : 950.000000
[27821.907000] 
[27821.907000] runnable tasks:
[27821.907001]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.907003] ----------------------------------------------------------------------------------------------------------
[27821.907020] 
[27821.907020] cpu#3, 3073.849 MHz
[27821.907022]   .nr_running                    : 0
[27821.907024]   .load                          : 0
[27821.907026]   .nr_switches                   : 4338722
[27821.907028]   .nr_load_updates               : 185831
[27821.907030]   .nr_uninterruptible            : 1
[27821.907032]   .next_balance                  : 4297.720522
[27821.907034]   .curr->pid                     : 0
[27821.907036]   .clock                         : 27821898.870612
[27821.907038]   .cpu_load[0]                   : 0
[27821.907040]   .cpu_load[1]                   : 0
[27821.907041]   .cpu_load[2]                   : 0
[27821.907043]   .cpu_load[3]                   : 0
[27821.907045]   .cpu_load[4]                   : 0
[27821.907047]   .yld_count                     : 9927
[27821.907049]   .sched_switch                  : 0
[27821.907051]   .sched_count                   : 4384763
[27821.907053]   .sched_goidle                  : 2134236
[27821.907055]   .avg_idle                      : 1000000
[27821.907056]   .ttwu_count                    : 2186291
[27821.907058]   .ttwu_local                    : 1326886
[27821.907060]   .bkl_count                     : 0
[27821.907062] 
[27821.907063] cfs_rq[3]:/
[27821.907065]   .exec_clock                    : 390748.348572
[27821.907067]   .MIN_vruntime                  : 0.000001
[27821.907069]   .min_vruntime                  : 448271.166097
[27821.907071]   .max_vruntime                  : 0.000001
[27821.907073]   .spread                        : 0.000000
[27821.907076]   .spread0                       : -1535187.457786
[27821.907078]   .nr_running                    : 0
[27821.907079]   .load                          : 0
[27821.907081]   .nr_spread_over                : 0
[27821.907083]   .shares                        : 0
[27821.907085] 
[27821.907086] rt_rq[3]:/
[27821.907087]   .rt_nr_running                 : 0
[27821.907089]   .rt_throttled                  : 0
[27821.907091]   .rt_time                       : 0.000000
[27821.907093]   .rt_runtime                    : 950.000000
[27821.907095] 
[27821.907096] runnable tasks:
[27821.907097]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.907098] ----------------------------------------------------------------------------------------------------------
[27821.907115] 
[27821.907116] cpu#4, 3073.849 MHz
[27821.907117]   .nr_running                    : 0
[27821.907119]   .load                          : 0
[27821.907121]   .nr_switches                   : 24842999
[27821.907123]   .nr_load_updates               : 1379012
[27821.907125]   .nr_uninterruptible            : 1
[27821.907127]   .next_balance                  : 4297.720589
[27821.907129]   .curr->pid                     : 0
[27821.907131]   .clock                         : 27821905.758645
[27821.907133]   .cpu_load[0]                   : 0
[27821.907135]   .cpu_load[1]                   : 0
[27821.907137]   .cpu_load[2]                   : 0
[27821.907139]   .cpu_load[3]                   : 0
[27821.907140]   .cpu_load[4]                   : 0
[27821.907142]   .yld_count                     : 2300
[27821.907144]   .sched_switch                  : 0
[27821.907146]   .sched_count                   : 65229040
[27821.907148]   .sched_goidle                  : 11461698
[27821.907150]   .avg_idle                      : 887631
[27821.907152]   .ttwu_count                    : 12710203
[27821.907154]   .ttwu_local                    : 5179927
[27821.907156]   .bkl_count                     : 0
[27821.907158] 
[27821.907158] cfs_rq[4]:/
[27821.907160]   .exec_clock                    : 1848261.240989
[27821.907162]   .MIN_vruntime                  : 0.000001
[27821.907165]   .min_vruntime                  : 1286897.532002
[27821.907167]   .max_vruntime                  : 0.000001
[27821.907169]   .spread                        : 0.000000
[27821.907171]   .spread0                       : -696561.091881
[27821.907173]   .nr_running                    : 0
[27821.907175]   .load                          : 0
[27821.907177]   .nr_spread_over                : 18
[27821.907179]   .shares                        : 0
[27821.907181] 
[27821.907181] rt_rq[4]:/
[27821.907183]   .rt_nr_running                 : 0
[27821.907185]   .rt_throttled                  : 0
[27821.907187]   .rt_time                       : 0.000000
[27821.907189]   .rt_runtime                    : 950.000000
[27821.907191] 
[27821.907192] runnable tasks:
[27821.907192]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.907194] ----------------------------------------------------------------------------------------------------------
[27821.907211] 
[27821.907212] cpu#5, 3073.849 MHz
[27821.907213]   .nr_running                    : 0
[27821.907215]   .load                          : 0
[27821.907217]   .nr_switches                   : 7485077
[27821.907219]   .nr_load_updates               : 343812
[27821.907221]   .nr_uninterruptible            : 1
[27821.907223]   .next_balance                  : 4297.720533
[27821.907225]   .curr->pid                     : 0
[27821.907227]   .clock                         : 27821905.227220
[27821.907229]   .cpu_load[0]                   : 0
[27821.907231]   .cpu_load[1]                   : 0
[27821.907233]   .cpu_load[2]                   : 2
[27821.907235]   .cpu_load[3]                   : 14
[27821.907237]   .cpu_load[4]                   : 20
[27821.907239]   .yld_count                     : 1593
[27821.907241]   .sched_switch                  : 0
[27821.907242]   .sched_count                   : 7578803
[27821.907244]   .sched_goidle                  : 3586457
[27821.907246]   .avg_idle                      : 1000000
[27821.907248]   .ttwu_count                    : 3791131
[27821.907250]   .ttwu_local                    : 2276119
[27821.907252]   .bkl_count                     : 0
[27821.907254] 
[27821.907254] cfs_rq[5]:/
[27821.907256]   .exec_clock                    : 834916.137534
[27821.907259]   .MIN_vruntime                  : 0.000001
[27821.907261]   .min_vruntime                  : 1947261.991735
[27821.907263]   .max_vruntime                  : 0.000001
[27821.907265]   .spread                        : 0.000000
[27821.907267]   .spread0                       : -36196.632148
[27821.907269]   .nr_running                    : 0
[27821.907271]   .load                          : 0
[27821.907273]   .nr_spread_over                : 258
[27821.907275]   .shares                        : 0
[27821.907277] 
[27821.907277] rt_rq[5]:/
[27821.907279]   .rt_nr_running                 : 0
[27821.907281]   .rt_throttled                  : 0
[27821.907283]   .rt_time                       : 0.000000
[27821.907285]   .rt_runtime                    : 950.000000
[27821.907287] 
[27821.907288] runnable tasks:
[27821.907288]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.907290] ----------------------------------------------------------------------------------------------------------
[27821.907307] 
[27821.907308] cpu#6, 3073.849 MHz
[27821.907309]   .nr_running                    : 0
[27821.907311]   .load                          : 0
[27821.907313]   .nr_switches                   : 4594609
[27821.907315]   .nr_load_updates               : 195127
[27821.907317]   .nr_uninterruptible            : 0
[27821.907319]   .next_balance                  : 4297.720586
[27821.907321]   .curr->pid                     : 0
[27821.907323]   .clock                         : 27821865.850588
[27821.907325]   .cpu_load[0]                   : 0
[27821.907327]   .cpu_load[1]                   : 0
[27821.907329]   .cpu_load[2]                   : 0
[27821.907330]   .cpu_load[3]                   : 0
[27821.907332]   .cpu_load[4]                   : 0
[27821.907334]   .yld_count                     : 3353
[27821.907336]   .sched_switch                  : 0
[27821.907338]   .sched_count                   : 65086942
[27821.907340]   .sched_goidle                  : 2242685
[27821.907342]   .avg_idle                      : 1000000
[27821.907344]   .ttwu_count                    : 2306870
[27821.907346]   .ttwu_local                    : 1594375
[27821.907348]   .bkl_count                     : 0
[27821.907349] 
[27821.907350] cfs_rq[6]:/
[27821.907352]   .exec_clock                    : 460353.440029
[27821.907354]   .MIN_vruntime                  : 0.000001
[27821.907356]   .min_vruntime                  : 441798.411668
[27821.907358]   .max_vruntime                  : 0.000001
[27821.907360]   .spread                        : 0.000000
[27821.907363]   .spread0                       : -1541660.212215
[27821.907365]   .nr_running                    : 0
[27821.907367]   .load                          : 0
[27821.907368]   .nr_spread_over                : 129
[27821.907370]   .shares                        : 0
[27821.907372] 
[27821.907373] rt_rq[6]:/
[27821.907375]   .rt_nr_running                 : 0
[27821.907376]   .rt_throttled                  : 0
[27821.907379]   .rt_time                       : 0.000000
[27821.907381]   .rt_runtime                    : 950.000000
[27821.907383] 
[27821.907383] runnable tasks:
[27821.907384]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.907386] ----------------------------------------------------------------------------------------------------------
[27821.907402] 
[27821.907403] cpu#7, 3073.849 MHz
[27821.907405]   .nr_running                    : 0
[27821.907407]   .load                          : 0
[27821.907409]   .nr_switches                   : 2802446
[27821.907411]   .nr_load_updates               : 163535
[27821.907413]   .nr_uninterruptible            : 0
[27821.907415]   .next_balance                  : 4297.720561
[27821.907417]   .curr->pid                     : 0
[27821.907419]   .clock                         : 27821897.359831
[27821.907421]   .cpu_load[0]                   : 1024
[27821.907423]   .cpu_load[1]                   : 512
[27821.907425]   .cpu_load[2]                   : 256
[27821.907426]   .cpu_load[3]                   : 128
[27821.907428]   .cpu_load[4]                   : 64
[27821.907430]   .yld_count                     : 18218
[27821.907432]   .sched_switch                  : 0
[27821.907434]   .sched_count                   : 2840187
[27821.907436]   .sched_goidle                  : 1383917
[27821.907438]   .avg_idle                      : 881625
[27821.907440]   .ttwu_count                    : 1405661
[27821.907442]   .ttwu_local                    : 911128
[27821.907443]   .bkl_count                     : 0
[27821.907445] 
[27821.907446] cfs_rq[7]:/
[27821.907448]   .exec_clock                    : 485889.715855
[27821.907450]   .MIN_vruntime                  : 0.000001
[27821.907452]   .min_vruntime                  : 464448.209419
[27821.907454]   .max_vruntime                  : 0.000001
[27821.907457]   .spread                        : 0.000000
[27821.907459]   .spread0                       : -1519010.414464
[27821.907461]   .nr_running                    : 0
[27821.907462]   .load                          : 0
[27821.907464]   .nr_spread_over                : 38
[27821.907466]   .shares                        : 0
[27821.907468] 
[27821.907469] rt_rq[7]:/
[27821.907471]   .rt_nr_running                 : 0
[27821.907472]   .rt_throttled                  : 0
[27821.907474]   .rt_time                       : 0.000000
[27821.907477]   .rt_runtime                    : 950.000000
[27821.907478] 
[27821.907479] runnable tasks:
[27821.907480]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[27821.907482] ----------------------------------------------------------------------------------------------------------
[27821.907498] 



-- 
Tomasz Chmielewski
http://wpkg.org
