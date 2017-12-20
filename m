Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:39819 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdLTQY2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 11:24:28 -0500
Received: by mail-it0-f54.google.com with SMTP id 68so7461241ite.4
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:24:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
 <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
 <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com> <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Wed, 20 Dec 2017 08:24:25 -0800
Message-ID: <CAG+QAKWN1X9jVWZeZ8q4DNNxSCXLbYFtM-t=LjpFqeGLE8QgGg@mail.gmail.com>
Subject: Re: kernel hangs during balance
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, caught the hung tasks last night.  I don't *think* this is
related, because I pretty sure this isn't happening on the same
filesystem, but I do have a loopback swap on one btrfs drive.

The hang might have occurred after the btrfs balance was finished ....
which is confusing.  I'm adding timestamps to my next btrfs job.


Dec 20 01:14:50 tendo [64680.942928] INFO: task systemd:1 blocked for
more than 120 seconds.
Dec 20 01:14:50 tendo [64680.945844]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:50 tendo [64680.948900] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:50 tendo [64680.951987]  ffff88040d6730d8
Dec 20 01:14:50 tendo ffffffff81a81500
Dec 20 01:14:50 tendo ffff88040d5f8000
Dec 20 01:14:50 tendo ffff88040d674000
Dec 20 01:14:50 tendo
Dec 20 01:14:50 tendo [64680.955107]  0000000000000000
Dec 20 01:14:50 tendo 7fffffffffffffff
Dec 20 01:14:50 tendo ffff8800bd19a648
Dec 20 01:14:50 tendo ffffe8ffffc03980
Dec 20 01:14:50 tendo
Dec 20 01:14:50 tendo [64680.957871]  ffff88040d6730f0
Dec 20 01:14:50 tendo ffffffff81700435
Dec 20 01:14:50 tendo ffff88041fa16cc0
Dec 20 01:14:50 tendo ffff88040d6731a0
Dec 20 01:14:50 tendo
Dec 20 01:14:50 tendo [64680.960618] Call Trace:
Dec 20 01:14:50 tendo [64680.963342]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:50 tendo [64680.966052]  [<ffffffff81703147>]
schedule_timeout+0x237/0x2d0
Dec 20 01:14:50 tendo [64680.968490]  [<ffffffff816ffa36>]
io_schedule_timeout+0xa6/0x110
Dec 20 01:14:50 tendo [64680.970900]  [<ffffffff8131a4dc>] bt_get+0x14c/0x1d0
Dec 20 01:14:50 tendo [64680.973211]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:50 tendo [64680.975383]  [<ffffffff8131a9e0>]
blk_mq_get_tag+0xb0/0xe0
Dec 20 01:14:50 tendo [64680.977540]  [<ffffffff813161bb>]
__blk_mq_alloc_request+0x1b/0x1f0
Dec 20 01:14:50 tendo [64680.979708]  [<ffffffff81317f7e>]
blk_mq_map_request+0x19e/0x210
Dec 20 01:14:50 tendo [64680.981871]  [<ffffffff8131901b>]
blk_sq_make_request+0xab/0x3d0
Dec 20 01:14:50 tendo [64680.984004]  [<ffffffff813091df>] ?
generic_make_request_checks+0x29f/0x4f0
Dec 20 01:14:50 tendo [64680.986122]  [<ffffffff8118cc4e>] ?
mempool_alloc+0x6e/0x170
Dec 20 01:14:50 tendo [64680.988207]  [<ffffffff8130d143>]
generic_make_request+0x113/0x2c0
Dec 20 01:14:50 tendo [64680.990137]  [<ffffffff8130d367>] submit_bio+0x77/0x150
Dec 20 01:14:50 tendo [64680.992041]  [<ffffffff81194799>] ?
__test_set_page_writeback+0x149/0x1c0
Dec 20 01:14:50 tendo [64680.993949]  [<ffffffff811cbf9d>]
__swap_writepage+0x20d/0x250
Dec 20 01:14:50 tendo [64680.995853]  [<ffffffff811d155c>] ?
__frontswap_store+0x8c/0x120
Dec 20 01:14:50 tendo [64680.997720]  [<ffffffff811cc019>]
swap_writepage+0x39/0x70
Dec 20 01:14:50 tendo [64680.999595]  [<ffffffff8119b550>]
pageout.isra.43+0x170/0x290
Dec 20 01:14:50 tendo [64681.001291]  [<ffffffff8119d843>]
shrink_page_list+0x353/0x780
Dec 20 01:14:50 tendo [64681.002975]  [<ffffffff8119e2b7>]
shrink_inactive_list+0x217/0x530
Dec 20 01:14:50 tendo [64681.004652]  [<ffffffff8119eed8>]
shrink_lruvec+0x588/0x740
Dec 20 01:14:50 tendo [64681.006311]  [<ffffffff8119f17b>]
shrink_zone+0xeb/0x2e0
Dec 20 01:14:50 tendo [64681.007967]  [<ffffffff8119f6e4>]
do_try_to_free_pages+0x164/0x430
Dec 20 01:14:50 tendo [64681.009617]  [<ffffffff8119aace>] ?
throttle_direct_reclaim+0x14e/0x240
Dec 20 01:14:50 tendo [64681.011141]  [<ffffffff8119fa85>]
try_to_free_pages+0xd5/0x190
Dec 20 01:14:51 tendo [64681.012659]  [<ffffffff81202310>]
__alloc_pages_slowpath.constprop.89+0x3a0/0x6e8
Dec 20 01:14:51 tendo [64681.014191]  [<ffffffff810afc22>] ?
sched_clock_cpu+0x72/0xa0
Dec 20 01:14:51 tendo [64681.015701]  [<ffffffff81192fc3>]
__alloc_pages_nodemask+0x253/0x260
Dec 20 01:14:51 tendo [64681.017215]  [<ffffffff811e8ff9>] ?
__kmalloc_node_track_caller+0x249/0x2b0
Dec 20 01:14:51 tendo [64681.018392]  [<ffffffff811dc445>]
alloc_pages_vma+0xa5/0x220
Dec 20 01:14:51 tendo [64681.019296]  [<ffffffff811b9951>]
handle_pte_fault+0xd21/0x1490
Dec 20 01:14:51 tendo [64681.020195]  [<ffffffff81211a5e>] ?
legitimize_path.isra.23+0x2e/0x60
Dec 20 01:14:51 tendo [64681.021100]  [<ffffffff813419ba>] ? put_dec+0x1a/0x80
Dec 20 01:14:51 tendo [64681.021992]  [<ffffffff8134384d>] ?
number.isra.13+0x2dd/0x310
Dec 20 01:14:51 tendo [64681.022883]  [<ffffffff811bafa0>]
handle_mm_fault+0x250/0x540
Dec 20 01:14:51 tendo [64681.023757]  [<ffffffff810688e8>]
__do_page_fault+0x188/0x3f0
Dec 20 01:14:51 tendo [64681.024626]  [<ffffffff81068b80>]
do_page_fault+0x30/0x80
Dec 20 01:14:51 tendo [64681.025486]  [<ffffffff812829c7>] ?
kernfs_path_locked+0x37/0x80
Dec 20 01:14:51 tendo [64681.026350]  [<ffffffff817061c8>] page_fault+0x28/0x30
Dec 20 01:14:51 tendo [64681.027201]  [<ffffffff813455be>] ?
copy_user_enhanced_fast_string+0xe/0x20
Dec 20 01:14:51 tendo [64681.028034]  [<ffffffff8122ae45>] ?
seq_read+0x295/0x390
Dec 20 01:14:51 tendo [64681.028832]  [<ffffffff81206997>] __vfs_read+0x37/0x100
Dec 20 01:14:51 tendo [64681.029618]  [<ffffffff812b3383>] ?
security_file_permission+0xa3/0xc0
Dec 20 01:14:51 tendo [64681.030342]  [<ffffffff81206f22>] ?
rw_verify_area+0x52/0xd0
Dec 20 01:14:51 tendo [64681.031055]  [<ffffffff8120701f>] vfs_read+0x7f/0x130
Dec 20 01:14:51 tendo [64681.031761]  [<ffffffff81207e75>] SyS_read+0x55/0xc0
Dec 20 01:14:51 tendo [64681.032441]  [<ffffffff81703fee>]
entry_SYSCALL_64_fastpath+0x12/0x71
Dec 20 01:14:51 tendo [64681.033119] INFO: task khugepaged:68 blocked
for more than 120 seconds.
Dec 20 01:14:51 tendo [64681.033815]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.034518] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.035238]  ffff88040cf4f318
Dec 20 01:14:51 tendo ffff88040d6c2c80
Dec 20 01:14:51 tendo ffff88040cf50000
Dec 20 01:14:51 tendo ffff88040cf50000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.035971]  0000000000000000
Dec 20 01:14:51 tendo 7fffffffffffffff
Dec 20 01:14:51 tendo ffff8800bd19a7c8
Dec 20 01:14:51 tendo ffffe8ffffc43980
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.036711]  ffff88040cf4f330
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88041fa56cc0
Dec 20 01:14:51 tendo ffff88040cf4f3e0
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.037454] Call Trace:
Dec 20 01:14:51 tendo [64681.038184]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.038925]  [<ffffffff81703147>]
schedule_timeout+0x237/0x2d0
Dec 20 01:14:51 tendo [64681.039651]  [<ffffffff811e4c2f>] ?
get_partial_node.isra.61+0x8f/0x1d0
Dec 20 01:14:51 tendo [64681.040367]  [<ffffffff816ffa36>]
io_schedule_timeout+0xa6/0x110
Dec 20 01:14:51 tendo [64681.041081]  [<ffffffff8131a4dc>] bt_get+0x14c/0x1d0
Dec 20 01:14:51 tendo [64681.041783]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.042495]  [<ffffffff8131a9e0>]
blk_mq_get_tag+0xb0/0xe0
Dec 20 01:14:51 tendo [64681.043204]  [<ffffffff813161bb>]
__blk_mq_alloc_request+0x1b/0x1f0
Dec 20 01:14:51 tendo [64681.043914]  [<ffffffff81317f7e>]
blk_mq_map_request+0x19e/0x210
Dec 20 01:14:51 tendo [64681.044624]  [<ffffffff8131901b>]
blk_sq_make_request+0xab/0x3d0
Dec 20 01:14:51 tendo [64681.045331]  [<ffffffff813091df>] ?
generic_make_request_checks+0x29f/0x4f0
Dec 20 01:14:51 tendo [64681.046046]  [<ffffffff8118cc4e>] ?
mempool_alloc+0x6e/0x170
Dec 20 01:14:51 tendo [64681.046758]  [<ffffffff8130d143>]
generic_make_request+0x113/0x2c0
Dec 20 01:14:51 tendo [64681.047471]  [<ffffffff8130d367>] submit_bio+0x77/0x150
Dec 20 01:14:51 tendo [64681.048187]  [<ffffffff81194799>] ?
__test_set_page_writeback+0x149/0x1c0
Dec 20 01:14:51 tendo [64681.048917]  [<ffffffff811cbf9d>]
__swap_writepage+0x20d/0x250
Dec 20 01:14:51 tendo [64681.049627]  [<ffffffff811d155c>] ?
__frontswap_store+0x8c/0x120
Dec 20 01:14:51 tendo [64681.050330]  [<ffffffff811cc019>]
swap_writepage+0x39/0x70
Dec 20 01:14:51 tendo [64681.051022]  [<ffffffff8119b550>]
pageout.isra.43+0x170/0x290
Dec 20 01:14:51 tendo [64681.051710]  [<ffffffff8119d843>]
shrink_page_list+0x353/0x780
Dec 20 01:14:51 tendo [64681.052387]  [<ffffffff8119e2b7>]
shrink_inactive_list+0x217/0x530
Dec 20 01:14:51 tendo [64681.053069]  [<ffffffff8119eed8>]
shrink_lruvec+0x588/0x740
Dec 20 01:14:51 tendo [64681.053745]  [<ffffffff8119f17b>]
shrink_zone+0xeb/0x2e0
Dec 20 01:14:51 tendo [64681.054417]  [<ffffffff8119f6e4>]
do_try_to_free_pages+0x164/0x430
Dec 20 01:14:51 tendo [64681.055086]  [<ffffffff8119fa85>]
try_to_free_pages+0xd5/0x190
Dec 20 01:14:51 tendo [64681.055751]  [<ffffffff81202310>]
__alloc_pages_slowpath.constprop.89+0x3a0/0x6e8
Dec 20 01:14:51 tendo [64681.056427]  [<ffffffff810b7445>] ?
put_prev_entity+0x35/0x670
Dec 20 01:14:51 tendo [64681.057105]  [<ffffffff81192fc3>]
__alloc_pages_nodemask+0x253/0x260
Dec 20 01:14:51 tendo [64681.057784]  [<ffffffff811eec60>]
khugepaged_scan_mm_slot+0x580/0xfe0
Dec 20 01:14:51 tendo [64681.058476]  [<ffffffff8135607d>] ? list_del+0xd/0x30
Dec 20 01:14:51 tendo [64681.059163]  [<ffffffff811ef7eb>]
khugepaged+0x12b/0x430
Dec 20 01:14:51 tendo [64681.059833]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.060494]  [<ffffffff811ef6c0>] ?
khugepaged_scan_mm_slot+0xfe0/0xfe0
Dec 20 01:14:51 tendo [64681.061157]  [<ffffffff8109d8e5>] kthread+0xe5/0x100
Dec 20 01:14:51 tendo [64681.061816]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.062476]  [<ffffffff8170434f>]
ret_from_fork+0x3f/0x70
Dec 20 01:14:51 tendo [64681.063129]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.063781] INFO: task kswapd0:77 blocked for
more than 120 seconds.
Dec 20 01:14:51 tendo [64681.064436]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.065105] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.065791]  ffff880408d435c8
Dec 20 01:14:51 tendo ffff88003f7c9640
Dec 20 01:14:51 tendo ffff88040c8b5900
Dec 20 01:14:51 tendo ffff880408d44000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.066485]  0000000000000000
Dec 20 01:14:51 tendo 7fffffffffffffff
Dec 20 01:14:51 tendo ffff8800bd19a688
Dec 20 01:14:51 tendo ffffe8ffffc83980
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.067178]  ffff880408d435e0
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88041fa96cc0
Dec 20 01:14:51 tendo ffff880408d43690
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.067860] Call Trace:
Dec 20 01:14:51 tendo [64681.068518]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.069191]  [<ffffffff81703147>]
schedule_timeout+0x237/0x2d0
Dec 20 01:14:51 tendo [64681.069838]  [<ffffffff8130eb06>] ?
blk_flush_plug_list+0xb6/0x200
Dec 20 01:14:51 tendo [64681.070475]  [<ffffffff816ffa36>]
io_schedule_timeout+0xa6/0x110
Dec 20 01:14:51 tendo [64681.071117]  [<ffffffff8131a4dc>] bt_get+0x14c/0x1d0
Dec 20 01:14:51 tendo [64681.071752]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.072391]  [<ffffffff8131a9e0>]
blk_mq_get_tag+0xb0/0xe0
Dec 20 01:14:51 tendo [64681.073026]  [<ffffffff813161bb>]
__blk_mq_alloc_request+0x1b/0x1f0
Dec 20 01:14:51 tendo [64681.073662]  [<ffffffff81317f7e>]
blk_mq_map_request+0x19e/0x210
Dec 20 01:14:51 tendo [64681.074298]  [<ffffffff8131901b>]
blk_sq_make_request+0xab/0x3d0
Dec 20 01:14:51 tendo [64681.074930]  [<ffffffff813091df>] ?
generic_make_request_checks+0x29f/0x4f0
Dec 20 01:14:51 tendo [64681.075564]  [<ffffffff8118cc4e>] ?
mempool_alloc+0x6e/0x170
Dec 20 01:14:51 tendo [64681.076200]  [<ffffffff8130d143>]
generic_make_request+0x113/0x2c0
Dec 20 01:14:51 tendo [64681.076840]  [<ffffffff8130d367>] submit_bio+0x77/0x150
Dec 20 01:14:51 tendo [64681.077473]  [<ffffffff81194799>] ?
__test_set_page_writeback+0x149/0x1c0
Dec 20 01:14:51 tendo [64681.078114]  [<ffffffff811cbf9d>]
__swap_writepage+0x20d/0x250
Dec 20 01:14:51 tendo [64681.078752]  [<ffffffff811d155c>] ?
__frontswap_store+0x8c/0x120
Dec 20 01:14:51 tendo [64681.079384]  [<ffffffff811cc019>]
swap_writepage+0x39/0x70
Dec 20 01:14:51 tendo [64681.080007]  [<ffffffff8119b550>]
pageout.isra.43+0x170/0x290
Dec 20 01:14:51 tendo [64681.080616]  [<ffffffff8119d843>]
shrink_page_list+0x353/0x780
Dec 20 01:14:51 tendo [64681.081229]  [<ffffffff8119e2b7>]
shrink_inactive_list+0x217/0x530
Dec 20 01:14:51 tendo [64681.081837]  [<ffffffff8119eed8>]
shrink_lruvec+0x588/0x740
Dec 20 01:14:51 tendo [64681.082443]  [<ffffffff811f682b>] ?
mem_cgroup_iter+0x12b/0x310
Dec 20 01:14:51 tendo [64681.083052]  [<ffffffff8119f17b>]
shrink_zone+0xeb/0x2e0
Dec 20 01:14:51 tendo [64681.083661]  [<ffffffff811a043a>] kswapd+0x4ea/0x9d0
Dec 20 01:14:51 tendo [64681.084269]  [<ffffffff8119ff50>] ?
mem_cgroup_shrink_node_zone+0x1c0/0x1c0
Dec 20 01:14:51 tendo [64681.084888]  [<ffffffff8109d8e5>] kthread+0xe5/0x100
Dec 20 01:14:51 tendo [64681.085505]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.086119]  [<ffffffff8170434f>]
ret_from_fork+0x3f/0x70
Dec 20 01:14:51 tendo [64681.086726]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.087338] INFO: task btrfs-transacti:423
blocked for more than 120 seconds.
Dec 20 01:14:51 tendo [64681.087953]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.088568] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.089205]  ffff88040745b990
Dec 20 01:14:51 tendo ffff88040d6c42c0
Dec 20 01:14:51 tendo ffff880406970000
Dec 20 01:14:51 tendo ffff88040745c000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.089840]  00000000ffffff00
Dec 20 01:14:51 tendo ffff880406970000
Dec 20 01:14:51 tendo ffff88040745b9d8
Dec 20 01:14:51 tendo ffff88030abc5a40
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.090470]  ffff88040745b9a8
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88030abc5aa8
Dec 20 01:14:51 tendo ffff88040745ba18
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.091096] Call Trace:
Dec 20 01:14:51 tendo [64681.091715]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.092361]  [<ffffffffa0519167>]
btrfs_tree_read_lock+0xd7/0x140 [btrfs]
Dec 20 01:14:51 tendo [64681.092995]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.093637]  [<ffffffffa04b2594>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
Dec 20 01:14:51 tendo [64681.094285]  [<ffffffffa04b75b2>]
btrfs_search_slot+0x532/0xa10 [btrfs]
Dec 20 01:14:51 tendo [64681.094925]  [<ffffffffa04bd6ee>]
lookup_inline_extent_backref+0xee/0x5b0 [btrfs]
Dec 20 01:14:51 tendo [64681.095559]  [<ffffffffa04b22fa>] ?
btrfs_alloc_path+0x1a/0x20 [btrfs]
Dec 20 01:14:51 tendo [64681.096192]  [<ffffffffa04c0700>]
__btrfs_free_extent.isra.67+0x110/0xc90 [btrfs]
Dec 20 01:14:51 tendo [64681.096824]  [<ffffffffa0529627>] ?
btrfs_merge_delayed_refs+0x67/0x5e0 [btrfs]
Dec 20 01:14:51 tendo [64681.097448]  [<ffffffff81021b19>] ?
sched_clock+0x9/0x10
Dec 20 01:14:51 tendo [64681.098074]  [<ffffffffa04c4c85>]
__btrfs_run_delayed_refs.constprop.72+0xa25/0x1250 [btrfs]
Dec 20 01:14:51 tendo [64681.098704]  [<ffffffff81021b19>] ?
sched_clock+0x9/0x10
Dec 20 01:14:51 tendo [64681.099337]  [<ffffffff810b7445>] ?
put_prev_entity+0x35/0x670
Dec 20 01:14:51 tendo [64681.099967]  [<ffffffff810ea174>] ?
lock_timer_base.isra.33+0x54/0x70
Dec 20 01:14:51 tendo [64681.100587]  [<ffffffffa04c81cd>]
btrfs_run_delayed_refs+0x7d/0x2b0 [btrfs]
Dec 20 01:14:51 tendo [64681.101216]  [<ffffffffa04dd596>]
btrfs_commit_transaction+0x56/0xa70 [btrfs]
Dec 20 01:14:51 tendo [64681.101839]  [<ffffffffa04d8959>]
transaction_kthread+0x1a9/0x230 [btrfs]
Dec 20 01:14:51 tendo [64681.102466]  [<ffffffffa04d87b0>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec 20 01:14:51 tendo [64681.103093]  [<ffffffff8109d8e5>] kthread+0xe5/0x100
Dec 20 01:14:51 tendo [64681.103719]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.104343]  [<ffffffff8170434f>]
ret_from_fork+0x3f/0x70
Dec 20 01:14:51 tendo [64681.104968]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.105586] INFO: task systemd-journal:505
blocked for more than 120 seconds.
Dec 20 01:14:51 tendo [64681.106218]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.106851] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.107500]  ffff88040c16bbd0
Dec 20 01:14:51 tendo ffff88040d6c2c80
Dec 20 01:14:51 tendo ffff8804089542c0
Dec 20 01:14:51 tendo ffff88040c16c000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.108160]  ffff88014d0dac60
Dec 20 01:14:51 tendo 0000000000000001
Dec 20 01:14:51 tendo 0000000003b42000
Dec 20 01:14:51 tendo 0000000004000000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.108818]  ffff88040c16bbe8
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88014d0dabe0
Dec 20 01:14:51 tendo ffff88040c16bc58
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.109488] Call Trace:
Dec 20 01:14:51 tendo [64681.110137]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.110792]  [<ffffffffa04f901f>]
btrfs_start_ordered_extent+0x10f/0x140 [btrfs]
Dec 20 01:14:51 tendo [64681.111453]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.112125]  [<ffffffffa04ee0dc>]
btrfs_page_mkwrite+0x17c/0x320 [btrfs]
Dec 20 01:14:51 tendo [64681.112781]  [<ffffffff811b6174>]
do_page_mkwrite+0x54/0xa0
Dec 20 01:14:51 tendo [64681.113447]  [<ffffffff811b873f>]
do_wp_page+0x3cf/0x590
Dec 20 01:14:51 tendo [64681.114112]  [<ffffffff8118a918>] ?
filemap_map_pages+0x1f8/0x240
Dec 20 01:14:51 tendo [64681.114775]  [<ffffffff811b96d8>]
handle_pte_fault+0xaa8/0x1490
Dec 20 01:14:51 tendo [64681.115435]  [<ffffffff810d673b>] ?
devkmsg_read+0x16b/0x2d0
Dec 20 01:14:51 tendo [64681.116096]  [<ffffffff811bafa0>]
handle_mm_fault+0x250/0x540
Dec 20 01:14:51 tendo [64681.116751]  [<ffffffff810688e8>]
__do_page_fault+0x188/0x3f0
Dec 20 01:14:51 tendo [64681.117412]  [<ffffffff81068b80>]
do_page_fault+0x30/0x80
Dec 20 01:14:51 tendo [64681.118055]  [<ffffffff817061c8>] page_fault+0x28/0x30
Dec 20 01:14:51 tendo [64681.118698] INFO: task btrfs-transacti:756
blocked for more than 120 seconds.
Dec 20 01:14:51 tendo [64681.119336]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.119965] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.120598]  ffff8803eec139a8
Dec 20 01:14:51 tendo ffff88040d6c42c0
Dec 20 01:14:51 tendo ffff8804068c0000
Dec 20 01:14:51 tendo ffff8803eec14000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.121243]  00000000ffffff00
Dec 20 01:14:51 tendo ffff8804068c0000
Dec 20 01:14:51 tendo ffff8803eec139f0
Dec 20 01:14:51 tendo ffff88015afc0460
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.121879]  ffff8803eec139c0
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88015afc04c8
Dec 20 01:14:51 tendo ffff8803eec13a30
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.122514] Call Trace:
Dec 20 01:14:51 tendo [64681.123143]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.123785]  [<ffffffffa0519167>]
btrfs_tree_read_lock+0xd7/0x140 [btrfs]
Dec 20 01:14:51 tendo [64681.124425]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.125070]  [<ffffffffa04b2594>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
Dec 20 01:14:51 tendo [64681.125716]  [<ffffffffa04b75b2>]
btrfs_search_slot+0x532/0xa10 [btrfs]
Dec 20 01:14:51 tendo [64681.126358]  [<ffffffffa04d45ce>] ?
btree_set_page_dirty+0xe/0x10 [btrfs]
Dec 20 01:14:51 tendo [64681.127003]  [<ffffffffa05015cd>] ?
set_extent_buffer_dirty+0x6d/0xb0 [btrfs]
Dec 20 01:14:51 tendo [64681.127640]  [<ffffffffa04d113b>]
btrfs_del_csums+0xeb/0x2e0 [btrfs]
Dec 20 01:14:51 tendo [64681.128278]  [<ffffffffa0500efb>] ?
free_extent_buffer+0x4b/0x90 [btrfs]
Dec 20 01:14:51 tendo [64681.128916]  [<ffffffffa04c0cb3>]
__btrfs_free_extent.isra.67+0x6c3/0xc90 [btrfs]
Dec 20 01:14:51 tendo [64681.129521]  [<ffffffffa04c46a1>]
__btrfs_run_delayed_refs.constprop.72+0x441/0x1250 [btrfs]
Dec 20 01:14:51 tendo [64681.130134]  [<ffffffff810b7445>] ?
put_prev_entity+0x35/0x670
Dec 20 01:14:51 tendo [64681.130747]  [<ffffffff81017695>] ?
__switch_to+0x1e5/0x490
Dec 20 01:14:51 tendo [64681.131357]  [<ffffffff810ea174>] ?
lock_timer_base.isra.33+0x54/0x70
Dec 20 01:14:51 tendo [64681.131973]  [<ffffffffa04c81cd>]
btrfs_run_delayed_refs+0x7d/0x2b0 [btrfs]
Dec 20 01:14:51 tendo [64681.132590]  [<ffffffffa04dd596>]
btrfs_commit_transaction+0x56/0xa70 [btrfs]
Dec 20 01:14:51 tendo [64681.133207]  [<ffffffffa04d8959>]
transaction_kthread+0x1a9/0x230 [btrfs]
Dec 20 01:14:51 tendo [64681.133820]  [<ffffffffa04d87b0>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec 20 01:14:51 tendo [64681.134436]  [<ffffffff8109d8e5>] kthread+0xe5/0x100
Dec 20 01:14:51 tendo [64681.135053]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.135668]  [<ffffffff8170434f>]
ret_from_fork+0x3f/0x70
Dec 20 01:14:51 tendo [64681.136276]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.136881] INFO: task btrfs-transacti:820
blocked for more than 120 seconds.
Dec 20 01:14:51 tendo [64681.137478]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.138073] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.138680]  ffff8800bc7af118
Dec 20 01:14:51 tendo ffffffff81a81500
Dec 20 01:14:51 tendo ffff8804070d0000
Dec 20 01:14:51 tendo ffff8800bc7b0000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.139292]  0000000000000000
Dec 20 01:14:51 tendo 7fffffffffffffff
Dec 20 01:14:51 tendo ffff8800bd19a648
Dec 20 01:14:51 tendo ffffe8ffffc03980
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.139890]  ffff8800bc7af130
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88041fa16cc0
Dec 20 01:14:51 tendo ffff8800bc7af1e0
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.140480] Call Trace:
Dec 20 01:14:51 tendo [64681.141060]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.141641]  [<ffffffff81703147>]
schedule_timeout+0x237/0x2d0
Dec 20 01:14:51 tendo [64681.142221]  [<ffffffff816ffa36>]
io_schedule_timeout+0xa6/0x110
Dec 20 01:14:51 tendo [64681.142799]  [<ffffffff8131a4dc>] bt_get+0x14c/0x1d0
Dec 20 01:14:51 tendo [64681.143375]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.143954]  [<ffffffff8131a9e0>]
blk_mq_get_tag+0xb0/0xe0
Dec 20 01:14:51 tendo [64681.144535]  [<ffffffff813161bb>]
__blk_mq_alloc_request+0x1b/0x1f0
Dec 20 01:14:51 tendo [64681.145119]  [<ffffffff81317f7e>]
blk_mq_map_request+0x19e/0x210
Dec 20 01:14:51 tendo [64681.145704]  [<ffffffff8131901b>]
blk_sq_make_request+0xab/0x3d0
Dec 20 01:14:51 tendo [64681.146291]  [<ffffffff813091df>] ?
generic_make_request_checks+0x29f/0x4f0
Dec 20 01:14:51 tendo [64681.146880]  [<ffffffff8118cc4e>] ?
mempool_alloc+0x6e/0x170
Dec 20 01:14:51 tendo [64681.147469]  [<ffffffff8130d143>]
generic_make_request+0x113/0x2c0
Dec 20 01:14:51 tendo [64681.148055]  [<ffffffff8130d367>] submit_bio+0x77/0x150
Dec 20 01:14:51 tendo [64681.148620]  [<ffffffff81194799>] ?
__test_set_page_writeback+0x149/0x1c0
Dec 20 01:14:51 tendo [64681.149194]  [<ffffffff811cbf9d>]
__swap_writepage+0x20d/0x250
Dec 20 01:14:51 tendo [64681.149753]  [<ffffffff811d155c>] ?
__frontswap_store+0x8c/0x120
Dec 20 01:14:51 tendo [64681.150304]  [<ffffffff811cc019>]
swap_writepage+0x39/0x70
Dec 20 01:14:51 tendo [64681.150852]  [<ffffffff8119b550>]
pageout.isra.43+0x170/0x290
Dec 20 01:14:51 tendo [64681.151392]  [<ffffffff8119d843>]
shrink_page_list+0x353/0x780
Dec 20 01:14:51 tendo [64681.151929]  [<ffffffff8119e2b7>]
shrink_inactive_list+0x217/0x530
Dec 20 01:14:51 tendo [64681.152462]  [<ffffffff8119eed8>]
shrink_lruvec+0x588/0x740
Dec 20 01:14:51 tendo [64681.152991]  [<ffffffff8119f17b>]
shrink_zone+0xeb/0x2e0
Dec 20 01:14:51 tendo [64681.153512]  [<ffffffff8119f6e4>]
do_try_to_free_pages+0x164/0x430
Dec 20 01:14:51 tendo [64681.154035]  [<ffffffff8119fa85>]
try_to_free_pages+0xd5/0x190
Dec 20 01:14:51 tendo [64681.154555]  [<ffffffff81202310>]
__alloc_pages_slowpath.constprop.89+0x3a0/0x6e8
Dec 20 01:14:51 tendo [64681.155079]  [<ffffffff81192fc3>]
__alloc_pages_nodemask+0x253/0x260
Dec 20 01:14:51 tendo [64681.155600]  [<ffffffff811da4b8>]
alloc_pages_current+0x88/0x120
Dec 20 01:14:51 tendo [64681.156119]  [<ffffffff8118a1e4>]
__page_cache_alloc+0xb4/0xc0
Dec 20 01:14:51 tendo [64681.156633]  [<ffffffff8118ac59>]
pagecache_get_page+0x59/0x1c0
Dec 20 01:14:51 tendo [64681.157146]  [<ffffffffa05226cd>] ?
io_ctl_init+0xdd/0x190 [btrfs]
Dec 20 01:14:51 tendo [64681.157654]  [<ffffffffa05227d0>]
io_ctl_prepare_pages+0x50/0x140 [btrfs]
Dec 20 01:14:51 tendo [64681.158168]  [<ffffffffa0522ec3>]
__btrfs_write_out_cache.isra.24+0xa3/0x430 [btrfs]
Dec 20 01:14:51 tendo [64681.158683]  [<ffffffffa052381d>]
btrfs_write_out_cache+0x8d/0x110 [btrfs]
Dec 20 01:14:51 tendo [64681.159214]  [<ffffffffa04c91ae>]
btrfs_write_dirty_block_groups+0x1de/0x270 [btrfs]
Dec 20 01:14:51 tendo [64681.159718]  [<ffffffffa0555f6f>]
commit_cowonly_roots+0x215/0x2bd [btrfs]
Dec 20 01:14:51 tendo [64681.160222]  [<ffffffffa04dda56>]
btrfs_commit_transaction+0x516/0xa70 [btrfs]
Dec 20 01:14:51 tendo [64681.160726]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.161249]  [<ffffffffa04d8959>]
transaction_kthread+0x1a9/0x230 [btrfs]
Dec 20 01:14:51 tendo [64681.161770]  [<ffffffffa04d87b0>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec 20 01:14:51 tendo [64681.162296]  [<ffffffff8109d8e5>] kthread+0xe5/0x100
Dec 20 01:14:51 tendo [64681.162819]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.163337]  [<ffffffff8170434f>]
ret_from_fork+0x3f/0x70
Dec 20 01:14:51 tendo [64681.163849]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.164339] INFO: task ksmtuned:1052 blocked
for more than 120 seconds.
Dec 20 01:14:51 tendo [64681.164825]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.165312] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.165804]  ffff880396daf368
Dec 20 01:14:51 tendo ffff88040d6c2c80
Dec 20 01:14:51 tendo ffff8800b5cec2c0
Dec 20 01:14:51 tendo ffff880396db0000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.166306]  0000000000000000
Dec 20 01:14:51 tendo 7fffffffffffffff
Dec 20 01:14:51 tendo ffff8800bd19a748
Dec 20 01:14:51 tendo ffffe8ffffc43980
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.166809]  ffff880396daf380
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88041fa56cc0
Dec 20 01:14:51 tendo ffff880396daf430
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.167317] Call Trace:
Dec 20 01:14:51 tendo [64681.167816]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.168322]  [<ffffffff81703147>]
schedule_timeout+0x237/0x2d0
Dec 20 01:14:51 tendo [64681.168825]  [<ffffffff816ffa36>]
io_schedule_timeout+0xa6/0x110
Dec 20 01:14:51 tendo [64681.169332]  [<ffffffff8131a4dc>] bt_get+0x14c/0x1d0
Dec 20 01:14:51 tendo [64681.169834]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.170359]  [<ffffffff8131a9e0>]
blk_mq_get_tag+0xb0/0xe0
Dec 20 01:14:51 tendo [64681.170869]  [<ffffffff813161bb>]
__blk_mq_alloc_request+0x1b/0x1f0
Dec 20 01:14:51 tendo [64681.171378]  [<ffffffff81317f7e>]
blk_mq_map_request+0x19e/0x210
Dec 20 01:14:51 tendo [64681.171885]  [<ffffffff8131901b>]
blk_sq_make_request+0xab/0x3d0
Dec 20 01:14:51 tendo [64681.172379]  [<ffffffff813091df>] ?
generic_make_request_checks+0x29f/0x4f0
Dec 20 01:14:51 tendo [64681.172892]  [<ffffffff8118cc4e>] ?
mempool_alloc+0x6e/0x170
Dec 20 01:14:51 tendo [64681.173403]  [<ffffffff8130d143>]
generic_make_request+0x113/0x2c0
Dec 20 01:14:51 tendo [64681.173905]  [<ffffffff8130d367>] submit_bio+0x77/0x150
Dec 20 01:14:51 tendo [64681.174406]  [<ffffffff81194799>] ?
__test_set_page_writeback+0x149/0x1c0
Dec 20 01:14:51 tendo [64681.174913]  [<ffffffff811cbf9d>]
__swap_writepage+0x20d/0x250
Dec 20 01:14:51 tendo [64681.175421]  [<ffffffff811d155c>] ?
__frontswap_store+0x8c/0x120
Dec 20 01:14:51 tendo [64681.175933]  [<ffffffff811cc019>]
swap_writepage+0x39/0x70
Dec 20 01:14:51 tendo [64681.176437]  [<ffffffff8119b550>]
pageout.isra.43+0x170/0x290
Dec 20 01:14:51 tendo [64681.176949]  [<ffffffff8119d843>]
shrink_page_list+0x353/0x780
Dec 20 01:14:51 tendo [64681.177461]  [<ffffffff8119e2b7>]
shrink_inactive_list+0x217/0x530
Dec 20 01:14:51 tendo [64681.177973]  [<ffffffff8119eed8>]
shrink_lruvec+0x588/0x740
Dec 20 01:14:51 tendo [64681.178480]  [<ffffffff8119f17b>]
shrink_zone+0xeb/0x2e0
Dec 20 01:14:51 tendo [64681.178998]  [<ffffffff8119f6e4>]
do_try_to_free_pages+0x164/0x430
Dec 20 01:14:51 tendo [64681.179500]  [<ffffffff8119aace>] ?
throttle_direct_reclaim+0x14e/0x240
Dec 20 01:14:51 tendo [64681.180004]  [<ffffffff8119fa85>]
try_to_free_pages+0xd5/0x190
Dec 20 01:14:51 tendo [64681.180507]  [<ffffffff81202310>]
__alloc_pages_slowpath.constprop.89+0x3a0/0x6e8
Dec 20 01:14:51 tendo [64681.181019]  [<ffffffff81192fc3>]
__alloc_pages_nodemask+0x253/0x260
Dec 20 01:14:51 tendo [64681.181523]  [<ffffffff81193191>]
alloc_kmem_pages_node+0x51/0xd0
Dec 20 01:14:51 tendo [64681.182046]  [<ffffffff8107c3d0>]
copy_process+0x180/0x1d20
Dec 20 01:14:51 tendo [64681.182548]  [<ffffffff811e53d2>] ?
kmem_cache_alloc+0x1e2/0x200
Dec 20 01:14:51 tendo [64681.183050]  [<ffffffff81208e2c>] ?
get_empty_filp+0x5c/0x1a0
Dec 20 01:14:51 tendo [64681.183542]  [<ffffffff8107e116>] _do_fork+0x96/0x330
Dec 20 01:14:51 tendo [64681.184018]  [<ffffffff810038e9>] ?
syscall_trace_enter_phase1+0x139/0x150
Dec 20 01:14:51 tendo [64681.184499]  [<ffffffff810796ce>] ?
syscall_slow_exit_work+0x3f/0xbd
Dec 20 01:14:51 tendo [64681.184984]  [<ffffffff8107e459>] SyS_clone+0x19/0x20
Dec 20 01:14:51 tendo [64681.185487]  [<ffffffff81703fee>]
entry_SYSCALL_64_fastpath+0x12/0x71
Dec 20 01:14:51 tendo [64681.185990] INFO: task pyfan:1158 blocked for
more than 120 seconds.
Dec 20 01:14:51 tendo [64681.186486]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.186987] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.187498]  ffff8803353ab368
Dec 20 01:14:51 tendo ffff88040d6c5900
Dec 20 01:14:51 tendo ffff880396520000
Dec 20 01:14:51 tendo ffff8803353ac000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.188023]  0000000000000000
Dec 20 01:14:51 tendo 7fffffffffffffff
Dec 20 01:14:51 tendo ffff8800bd19a748
Dec 20 01:14:51 tendo ffffe8ffffcc3980
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.188550]  ffff8803353ab380
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo ffff88041fad6cc0
Dec 20 01:14:51 tendo ffff8803353ab430
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.189075] Call Trace:
Dec 20 01:14:51 tendo [64681.189584]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.190093]  [<ffffffff81703147>]
schedule_timeout+0x237/0x2d0
Dec 20 01:14:51 tendo [64681.190598]  [<ffffffff816ffa36>]
io_schedule_timeout+0xa6/0x110
Dec 20 01:14:51 tendo [64681.191100]  [<ffffffff8131a4dc>] bt_get+0x14c/0x1d0
Dec 20 01:14:51 tendo [64681.191578]  [<ffffffff810c2940>] ?
prepare_to_wait_event+0xf0/0xf0
Dec 20 01:14:51 tendo [64681.192062]  [<ffffffff8131a9e0>]
blk_mq_get_tag+0xb0/0xe0
Dec 20 01:14:51 tendo [64681.192547]  [<ffffffff813161bb>]
__blk_mq_alloc_request+0x1b/0x1f0
Dec 20 01:14:51 tendo [64681.193036]  [<ffffffff81317f7e>]
blk_mq_map_request+0x19e/0x210
Dec 20 01:14:51 tendo [64681.193522]  [<ffffffff8131901b>]
blk_sq_make_request+0xab/0x3d0
Dec 20 01:14:51 tendo [64681.194020]  [<ffffffff813091df>] ?
generic_make_request_checks+0x29f/0x4f0
Dec 20 01:14:51 tendo [64681.194503]  [<ffffffff8118cc4e>] ?
mempool_alloc+0x6e/0x170
Dec 20 01:14:51 tendo [64681.194988]  [<ffffffff8130d143>]
generic_make_request+0x113/0x2c0
Dec 20 01:14:51 tendo [64681.195475]  [<ffffffff8130d367>] submit_bio+0x77/0x150
Dec 20 01:14:51 tendo [64681.195961]  [<ffffffff81194799>] ?
__test_set_page_writeback+0x149/0x1c0
Dec 20 01:14:51 tendo [64681.196458]  [<ffffffff811cbf9d>]
__swap_writepage+0x20d/0x250
Dec 20 01:14:51 tendo [64681.196948]  [<ffffffff811d155c>] ?
__frontswap_store+0x8c/0x120
Dec 20 01:14:51 tendo [64681.197454]  [<ffffffff811cc019>]
swap_writepage+0x39/0x70
Dec 20 01:14:51 tendo [64681.197941]  [<ffffffff8119b550>]
pageout.isra.43+0x170/0x290
Dec 20 01:14:51 tendo [64681.198426]  [<ffffffff8119d843>]
shrink_page_list+0x353/0x780
Dec 20 01:14:51 tendo [64681.198922]  [<ffffffff8119e2b7>]
shrink_inactive_list+0x217/0x530
Dec 20 01:14:51 tendo [64681.199417]  [<ffffffff8119eed8>]
shrink_lruvec+0x588/0x740
Dec 20 01:14:51 tendo [64681.199911]  [<ffffffff8119f17b>]
shrink_zone+0xeb/0x2e0
Dec 20 01:14:51 tendo [64681.200400]  [<ffffffff8119f6e4>]
do_try_to_free_pages+0x164/0x430
Dec 20 01:14:51 tendo [64681.200892]  [<ffffffff8119aace>] ?
throttle_direct_reclaim+0x14e/0x240
Dec 20 01:14:51 tendo [64681.201383]  [<ffffffff8119fa85>]
try_to_free_pages+0xd5/0x190
Dec 20 01:14:51 tendo [64681.201881]  [<ffffffff81202310>]
__alloc_pages_slowpath.constprop.89+0x3a0/0x6e8
Dec 20 01:14:51 tendo [64681.202386]  [<ffffffff81192fc3>]
__alloc_pages_nodemask+0x253/0x260
Dec 20 01:14:51 tendo [64681.202897]  [<ffffffff81193191>]
alloc_kmem_pages_node+0x51/0xd0
Dec 20 01:14:51 tendo [64681.203389]  [<ffffffff8107c3d0>]
copy_process+0x180/0x1d20
Dec 20 01:14:51 tendo [64681.203878]  [<ffffffff811e53d2>] ?
kmem_cache_alloc+0x1e2/0x200
Dec 20 01:14:51 tendo [64681.204376]  [<ffffffff81208e2c>] ?
get_empty_filp+0x5c/0x1a0
Dec 20 01:14:51 tendo [64681.204849]  [<ffffffff8107e116>] _do_fork+0x96/0x330
Dec 20 01:14:51 tendo [64681.205313]  [<ffffffff810038e9>] ?
syscall_trace_enter_phase1+0x139/0x150
Dec 20 01:14:51 tendo [64681.205810]  [<ffffffff8107e459>] SyS_clone+0x19/0x20
Dec 20 01:14:51 tendo [64681.206309]  [<ffffffff81703fee>]
entry_SYSCALL_64_fastpath+0x12/0x71
Dec 20 01:14:51 tendo [64681.206809] INFO: task loop0:1183 blocked for
more than 120 seconds.
Dec 20 01:14:51 tendo [64681.207302]       Not tainted
4.4.106-1.el7.elrepo.x86_64 #1
Dec 20 01:14:51 tendo [64681.207796] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 20 01:14:51 tendo [64681.208302]  ffff8800a1d2f998
Dec 20 01:14:51 tendo ffff88040d6c42c0
Dec 20 01:14:51 tendo ffff880337ae42c0
Dec 20 01:14:51 tendo ffff8800a1d30000
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.208815]  ffff8801f3af59e0
Dec 20 01:14:51 tendo ffff8801f3af59d8
Dec 20 01:14:51 tendo ffff880337ae42c0
Dec 20 01:14:51 tendo ffff8803eaf1d290
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.209342]  ffff8800a1d2f9b0
Dec 20 01:14:51 tendo ffffffff81700435
Dec 20 01:14:51 tendo 7fffffffffffffff
Dec 20 01:14:51 tendo ffff8800a1d2fa58
Dec 20 01:14:51 tendo
Dec 20 01:14:51 tendo [64681.209848] Call Trace:
Dec 20 01:14:51 tendo [64681.210364]  [<ffffffff81700435>] schedule+0x35/0x80
Dec 20 01:14:51 tendo [64681.210874]  [<ffffffff81703147>]
schedule_timeout+0x237/0x2d0
Dec 20 01:14:51 tendo [64681.211376]  [<ffffffff810aa3d5>] ?
wake_up_process+0x15/0x20
Dec 20 01:14:51 tendo [64681.211875]  [<ffffffff810946a4>] ?
wake_up_worker+0x24/0x30
Dec 20 01:14:51 tendo [64681.212366]  [<ffffffff81095482>] ?
insert_work+0x62/0xa0
Dec 20 01:14:51 tendo [64681.212834]  [<ffffffff81700f31>]
wait_for_completion+0xf1/0x130
Dec 20 01:14:51 tendo [64681.213325]  [<ffffffff810aa460>] ? wake_up_q+0x80/0x80
Dec 20 01:14:51 tendo [64681.213803]  [<ffffffffa04c26e7>]
btrfs_async_run_delayed_refs+0x127/0x150 [btrfs]
Dec 20 01:14:51 tendo [64681.214272]  [<ffffffffa04de786>]
__btrfs_end_transaction+0x1f6/0x340 [btrfs]
Dec 20 01:14:51 tendo [64681.214745]  [<ffffffffa04de8e0>]
btrfs_end_transaction+0x10/0x20 [btrfs]
Dec 20 01:14:51 tendo [64681.215241]  [<ffffffffa04e3b6d>]
btrfs_dirty_inode+0x6d/0xe0 [btrfs]
Dec 20 01:14:51 tendo [64681.215739]  [<ffffffffa04e3c44>]
btrfs_update_time+0x64/0xc0 [btrfs]
Dec 20 01:14:51 tendo [64681.216223]  [<ffffffff81223638>] touch_atime+0xa8/0xd0
Dec 20 01:14:51 tendo [64681.216700]  [<ffffffff8118bc51>]
generic_file_read_iter+0x581/0x660
Dec 20 01:14:51 tendo [64681.217189]  [<ffffffff8118cb37>] ?
mempool_free_slab+0x17/0x20
Dec 20 01:14:51 tendo [64681.217694]  [<ffffffff8118cf7b>] ?
mempool_free+0x2b/0x80
Dec 20 01:14:51 tendo [64681.218182]  [<ffffffff81206874>]
vfs_iter_read+0x74/0xb0
Dec 20 01:14:51 tendo [64681.218657]  [<ffffffffa097719e>]
lo_read_simple.isra.27+0xbe/0x200 [loop]
Dec 20 01:14:51 tendo [64681.219138]  [<ffffffffa0977850>]
loop_queue_work+0x570/0x72c [loop]
Dec 20 01:14:51 tendo [64681.219615]  [<ffffffff81017695>] ?
__switch_to+0x1e5/0x490
Dec 20 01:14:51 tendo [64681.220091]  [<ffffffff816ffde9>] ?
__schedule+0x349/0x960
Dec 20 01:14:51 tendo [64681.220565]  [<ffffffff8109deeb>]
kthread_worker_fn+0x7b/0x170
Dec 20 01:14:51 tendo [64681.221056]  [<ffffffff8109de70>] ?
kthread_create_on_node+0x1a0/0x1a0
Dec 20 01:14:51 tendo [64681.221533]  [<ffffffff8109d8e5>] kthread+0xe5/0x100
Dec 20 01:14:51 tendo [64681.222009]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60
Dec 20 01:14:51 tendo [64681.222485]  [<ffffffff8170434f>]
ret_from_fork+0x3f/0x70
Dec 20 01:14:51 tendo [64681.222961]  [<ffffffff8109d800>] ?
kthread_park+0x60/0x60

On Tue, Dec 19, 2017 at 9:48 AM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
> On Tue, Dec 19, 2017 at 9:14 AM, Hans van Kranenburg
> <hans.van.kranenburg@mendix.com> wrote:
>> Just wild first guess... are you also using btrfs send/receive
>> functionality where the system having problems is the sending part?
>
> No.
>
>>>> Every night I'm getting a kernel hang, sometimes caught by my
>>>> watchdog, sometimes not.  Last night's hang was on the balance of DATA
>>>> on / at 70.
>>>>
>>>> I'm not sure how to further trace this down to help you -- the console
>>>> by the time I notice just has lots of messages on it without the
>>>> initial ones.
>>
>> Capturing more logs is definitely the first thing to do.
>>
>> Look if the output of `dmesg` still shows the btrfs errors. Otherwise,
>
> But I can't ...  I have to hit the reset button (or the watchdog does)
> before I can get into the system again.
>
>> if something is spamming there, turn that off, or if you don't have the
>> errors in a log file because the log files are on the same btrfs, then
>> you have to find out another way to capture them. E.g. make the kernel
>> buffer for messages bigger, use netconsole or just pragmatic things like
>> ssh from another server and `dmesg -w` and store it on the other machine.
>
> Ah... yes, a permanent connection from another might work.
>
> I also have a pfsense box -- I think it can take a syslogd daemon.
> Maybe I can netconsole to it?
>
> Will investigate.
