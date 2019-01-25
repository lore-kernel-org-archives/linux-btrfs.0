Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAB0C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 08:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD0220820
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 08:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfAYIBq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:01:46 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:37400 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfAYIBq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 03:01:46 -0500
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id 527225463; Fri, 25 Jan 2019 09:01:37 +0100 (CET)
Date:   Fri, 25 Jan 2019 09:01:37 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: New hang (Re: Kernel traces), sysreq+w output
Message-ID: <20190125080137.GA27316@cuci.nl>
References: <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
 <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
 <20181228150016.GB13717@cuci.nl>
 <20190123155046.GA8995@cuci.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123155046.GA8995@cuci.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Stephen R. van den Berg wrote:
>Stephen R. van den Berg wrote:
>>Qu Wenruo wrote:
>>>>> It's caused by qgroup, and a dead lock on btrfs_drop_snapshot().

>>>>> Please either disable qgroup or apply this patch to solve it:
>>>>> https://patchwork.kernel.org/patch/10725371/

>>Ok, booting the system in v4.20 with this patch.  I'll report back if
>>it does not resolve the problem.

Ok, I now have a sysreq+w output again (attached at the bottom).
In userspace I see the following (ps xfa):

 1282 ?        D      5:57  \_ [btrfs-cleaner]
 1283 ?        D     26:09  \_ [btrfs-transacti]

18526 ?        D      0:09  |       \_ btrfs receive --max-errors 1 -vv /data/lxc/somecontainer/rootfs

The btrfs receive hangs and does not proceed.

The dmesg output prior to running the sysreq+w:
[11651.269729] perf: interrupt took too long (3154 > 3136), lowering kernel.perf_event_max_sample_rate to 63400
[14867.617253] INFO: task btrfs:24867 blocked for more than 120 seconds.
[14867.622513]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[14867.628202] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[14867.634845] btrfs           D    0 24867  24862 0x00000000
[14867.639173] Call Trace:
[14867.640436]  ? __schedule+0x4db/0x524
[14867.642904]  ? schedule+0x60/0x71
[14867.645029]  ? btrfs_start_ordered_extent+0xd3/0x105
[14867.648818]  ? finish_wait+0x60/0x60
[14867.651198]  ? btrfs_wait_ordered_range+0xa4/0x100
[14867.654795]  ? unmap_mapping_pages+0x64/0x113
[14867.657979]  ? btrfs_setattr+0x20b/0x499
[14867.660707]  ? notify_change+0x268/0x347
[14867.663435]  ? do_truncate+0x82/0xb6
[14867.665810]  ? kmem_cache_alloc+0x9a/0x100
[14867.668726]  ? vfs_truncate+0xbc/0xda
[14867.671194]  ? do_sys_truncate+0x60/0xa9
[14867.673926]  ? do_syscall_64+0x4e/0x5b
[14867.676479]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[20498.479174] perf: interrupt took too long (3952 > 3942), lowering kernel.perf_event_max_sample_rate to 50600
[53253.444439] perf: interrupt took too long (4953 > 4940), lowering kernel.perf_event_max_sample_rate to 40300
[64758.167022] INFO: task btrfs:21633 blocked for more than 120 seconds.
[64758.172267]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[64758.177906] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64758.184541] btrfs           D    0 21633  21626 0x00000000
[64758.188854] Call Trace:
[64758.190114]  ? __schedule+0x4db/0x524
[64758.192582]  ? schedule+0x60/0x71
[64758.194698]  ? btrfs_commit_transaction+0x21c/0x711
[64758.198401]  ? finish_wait+0x60/0x60
[64758.200791]  ? _btrfs_ioctl_set_received_subvol+0x27e/0x2ab
[64758.205167]  ? btrfs_ioctl+0x1572/0x2a51
[64758.207902]  ? current_time+0x67/0x88
[64758.210369]  ? pipe_write+0x356/0x369
[64758.212830]  ? vfs_ioctl+0x1e/0x2b
[64758.215030]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64758.219422]  ? vfs_ioctl+0x1e/0x2b
[64758.221626]  ? do_vfs_ioctl+0x523/0x54c
[64758.224261]  ? ksys_ioctl+0x3e/0x5d
[64758.226548]  ? __x64_sys_ioctl+0x16/0x19
[64758.229281]  ? do_syscall_64+0x4e/0x5b
[64758.231837]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[87012.380856] conftest[12985]: segfault at 7ffe28de8aa0 ip 0000557f11bc31c4 sp 00007ffe28de8aa0 error 6 in conftest[557f11bc3000+1000]
[87012.391632] Code: 1f 80 00 00 00 00 e9 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 48 81 ec f8 ff 00 00 8b 05 8f 2e 00 00 48 8d 35 40 0e 00 00 <48> 89 3c 24 48 8b 3d 81 2e 00 00 8d 90 00 00 01 00 31 c0 89 15 6f
[89521.271437] perf: interrupt took too long (6193 > 6191), lowering kernel.perf_event_max_sample_rate to 32200
[139102.477242] INFO: task btrfs-cleaner:1282 blocked for more than 120 seconds.
[139102.483103]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139102.488730] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139102.495364] btrfs-cleaner   D    0  1282      2 0x80000000
[139102.499687] Call Trace:
[139102.500957]  ? __schedule+0x4db/0x524
[139102.503418]  ? __wait_for_common+0xda/0x160
[139102.506399]  ? schedule+0x60/0x71
[139102.508536]  ? wait_current_trans+0xa1/0xdf
[139102.511522]  ? finish_wait+0x60/0x60
[139102.513896]  ? start_transaction+0x1b2/0x329
[139102.516964]  ? btrfs_drop_snapshot+0x3d2/0x5de
[139102.520239]  ? btrfs_kill_all_delayed_nodes+0x5a/0xd1
[139102.524097]  ? btrfs_delete_unused_bgs+0x39/0x39e
[139102.527619]  ? btrfs_need_cleaner_sleep+0x27/0x27
[139102.531127]  ? btrfs_clean_one_deleted_snapshot+0xa8/0xb2
[139102.535329]  ? cleaner_kthread+0x80/0xf6
[139102.538066]  ? kthread+0xeb/0xf0
[139102.540097]  ? kthread_associate_blkcg+0x86/0x86
[139102.543520]  ? ret_from_fork+0x35/0x40
[139102.546070] INFO: task btrfs-transacti:1283 blocked for more than 120 seconds.
[139102.552115]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139102.557713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139102.564344] btrfs-transacti D    0  1283      2 0x80000000
[139102.568659] Call Trace:
[139102.569917]  ? __schedule+0x4db/0x524
[139102.572383]  ? schedule+0x60/0x71
[139102.574495]  ? btrfs_start_ordered_extent+0xd3/0x105
[139102.578283]  ? finish_wait+0x60/0x60
[139102.580660]  ? btrfs_wait_ordered_range+0xa4/0x100
[139102.584254]  ? btrfs_get_token_32+0x8e/0xf4
[139102.587258]  ? __btrfs_wait_cache_io+0x47/0x16d
[139102.590594]  ? btrfs_write_dirty_block_groups+0xc7/0x2d3
[139102.594707]  ? btrfs_run_delayed_refs+0xdf/0x12d
[139102.598149]  ? commit_cowonly_roots+0x1f3/0x2a8
[139102.601493]  ? btrfs_commit_transaction+0x397/0x711
[139102.605178]  ? finish_wait+0x60/0x60
[139102.607568]  ? transaction_kthread+0xc6/0x132
[139102.610732]  ? btrfs_cleanup_transaction+0x3ca/0x3ca
[139102.614495]  ? kthread+0xeb/0xf0
[139102.616522]  ? kthread_associate_blkcg+0x86/0x86
[139102.619961]  ? ret_from_fork+0x35/0x40
[139471.126602] INFO: task btrfs-cleaner:1282 blocked for more than 120 seconds.
[139471.132462]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139471.138099] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139471.144733] btrfs-cleaner   D    0  1282      2 0x80000000
[139471.149046] Call Trace:
[139471.150306]  ? __schedule+0x4db/0x524
[139471.152775]  ? __wait_for_common+0xda/0x160
[139471.155758]  ? schedule+0x60/0x71
[139471.157896]  ? wait_current_trans+0xa1/0xdf
[139471.160885]  ? finish_wait+0x60/0x60
[139471.163265]  ? start_transaction+0x1b2/0x329
[139471.166334]  ? btrfs_drop_snapshot+0x3d2/0x5de
[139471.169609]  ? btrfs_kill_all_delayed_nodes+0x5a/0xd1
[139471.173467]  ? btrfs_delete_unused_bgs+0x39/0x39e
[139471.176996]  ? btrfs_need_cleaner_sleep+0x27/0x27
[139471.180504]  ? btrfs_clean_one_deleted_snapshot+0xa8/0xb2
[139471.184707]  ? cleaner_kthread+0x80/0xf6
[139471.187453]  ? kthread+0xeb/0xf0
[139471.189483]  ? kthread_associate_blkcg+0x86/0x86
[139471.192907]  ? ret_from_fork+0x35/0x40
[139471.195456] INFO: task btrfs-transacti:1283 blocked for more than 120 seconds.
[139471.201495]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139471.207088] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139471.213723] btrfs-transacti D    0  1283      2 0x80000000
[139471.218033] Call Trace:
[139471.219282]  ? __schedule+0x4db/0x524
[139471.221748]  ? schedule+0x60/0x71
[139471.223862]  ? btrfs_start_ordered_extent+0xd3/0x105
[139471.227660]  ? finish_wait+0x60/0x60
[139471.230035]  ? btrfs_wait_ordered_range+0xa4/0x100
[139471.233629]  ? btrfs_get_token_32+0x8e/0xf4
[139471.236636]  ? __btrfs_wait_cache_io+0x47/0x16d
[139471.249343]  ? btrfs_start_dirty_block_groups+0x111/0x390
[139471.253542]  ? btrfs_commit_transaction+0xc9/0x711
[139471.257164]  ? start_transaction+0x2b8/0x329
[139471.260241]  ? transaction_kthread+0xc6/0x132
[139471.263402]  ? btrfs_cleanup_transaction+0x3ca/0x3ca
[139471.267184]  ? kthread+0xeb/0xf0
[139471.269219]  ? kthread_associate_blkcg+0x86/0x86
[139471.272640]  ? ret_from_fork+0x35/0x40
[139594.009727] INFO: task btrfs-cleaner:1282 blocked for more than 120 seconds.
[139594.015604]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139594.021226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139594.027860] btrfs-cleaner   D    0  1282      2 0x80000000
[139594.032188] Call Trace:
[139594.033450]  ? __schedule+0x4db/0x524
[139594.035913]  ? __wait_for_common+0xda/0x160
[139594.038914]  ? schedule+0x60/0x71
[139594.041057]  ? wait_current_trans+0xa1/0xdf
[139594.044046]  ? finish_wait+0x60/0x60
[139594.046426]  ? start_transaction+0x1b2/0x329
[139594.049503]  ? btrfs_drop_snapshot+0x3d2/0x5de
[139594.052772]  ? btrfs_kill_all_delayed_nodes+0x5a/0xd1
[139594.056627]  ? btrfs_delete_unused_bgs+0x39/0x39e
[139594.060162]  ? btrfs_need_cleaner_sleep+0x27/0x27
[139594.063672]  ? btrfs_clean_one_deleted_snapshot+0xa8/0xb2
[139594.067875]  ? cleaner_kthread+0x80/0xf6
[139594.070620]  ? kthread+0xeb/0xf0
[139594.072650]  ? kthread_associate_blkcg+0x86/0x86
[139594.076075]  ? ret_from_fork+0x35/0x40
[139594.078622] INFO: task btrfs-transacti:1283 blocked for more than 120 seconds.
[139594.084668]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139594.090271] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139594.096908] btrfs-transacti D    0  1283      2 0x80000000
[139594.101225] Call Trace:
[139594.102481]  ? __schedule+0x4db/0x524
[139594.104942]  ? schedule+0x60/0x71
[139594.107059]  ? btrfs_start_ordered_extent+0xd3/0x105
[139594.110853]  ? finish_wait+0x60/0x60
[139594.113238]  ? btrfs_wait_ordered_range+0xa4/0x100
[139594.116832]  ? btrfs_get_token_32+0x8e/0xf4
[139594.119840]  ? __btrfs_wait_cache_io+0x47/0x16d
[139594.123181]  ? btrfs_start_dirty_block_groups+0x111/0x390
[139594.127382]  ? btrfs_commit_transaction+0xc9/0x711
[139594.131004]  ? start_transaction+0x2b8/0x329
[139594.134083]  ? transaction_kthread+0xc6/0x132
[139594.137244]  ? btrfs_cleanup_transaction+0x3ca/0x3ca
[139594.141032]  ? kthread+0xeb/0xf0
[139594.143060]  ? kthread_associate_blkcg+0x86/0x86
[139594.146475]  ? ret_from_fork+0x35/0x40
[139716.892803] INFO: task btrfs-cleaner:1282 blocked for more than 120 seconds.
[139716.898664]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139716.904287] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139716.910955] btrfs-cleaner   D    0  1282      2 0x80000000
[139716.915275] Call Trace:
[139716.916532]  ? __schedule+0x4db/0x524
[139716.918993]  ? __wait_for_common+0xda/0x160
[139716.921974]  ? schedule+0x60/0x71
[139716.924126]  ? wait_current_trans+0xa1/0xdf
[139716.927115]  ? finish_wait+0x60/0x60
[139716.929488]  ? start_transaction+0x1b2/0x329
[139716.932558]  ? btrfs_drop_snapshot+0x3d2/0x5de
[139716.935834]  ? btrfs_kill_all_delayed_nodes+0x5a/0xd1
[139716.939689]  ? btrfs_delete_unused_bgs+0x39/0x39e
[139716.943216]  ? btrfs_need_cleaner_sleep+0x27/0x27
[139716.946729]  ? btrfs_clean_one_deleted_snapshot+0xa8/0xb2
[139716.950931]  ? cleaner_kthread+0x80/0xf6
[139716.953679]  ? kthread+0xeb/0xf0
[139716.955706]  ? kthread_associate_blkcg+0x86/0x86
[139716.959120]  ? ret_from_fork+0x35/0x40
[139716.961672] INFO: task btrfs-transacti:1283 blocked for more than 120 seconds.
[139716.967715]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[139716.973313] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[139716.979946] btrfs-transacti D    0  1283      2 0x80000000
[139716.984257] Call Trace:
[139716.985506]  ? __schedule+0x4db/0x524
[139716.987975]  ? schedule+0x60/0x71
[139716.990088]  ? btrfs_start_ordered_extent+0xd3/0x105
[139716.993872]  ? finish_wait+0x60/0x60
[139716.996251]  ? btrfs_wait_ordered_range+0xa4/0x100
[139716.999848]  ? btrfs_get_token_32+0x8e/0xf4
[139717.002853]  ? __btrfs_wait_cache_io+0x47/0x16d
[139717.006192]  ? btrfs_start_dirty_block_groups+0x111/0x390
[139717.010397]  ? btrfs_commit_transaction+0xc9/0x711
[139717.014016]  ? start_transaction+0x2b8/0x329
[139717.017094]  ? transaction_kthread+0xc6/0x132
[139717.020248]  ? btrfs_cleanup_transaction+0x3ca/0x3ca
[139717.024033]  ? kthread+0xeb/0xf0
[139717.026065]  ? kthread_associate_blkcg+0x86/0x86
[139717.029489]  ? ret_from_fork+0x35/0x40


The latest sysreq+w output:

sysrq: SysRq : Show Blocked State
  task                        PC stack   pid father
btrfs-cleaner   D    0  1282      2 0x80000000
Call Trace:
 ? __schedule+0x4db/0x524
 ? __wait_for_common+0xda/0x160
 ? schedule+0x60/0x71
 ? wait_current_trans+0xa1/0xdf
 ? finish_wait+0x60/0x60
 ? start_transaction+0x1b2/0x329
 ? btrfs_drop_snapshot+0x3d2/0x5de
 ? btrfs_kill_all_delayed_nodes+0x5a/0xd1
 ? btrfs_delete_unused_bgs+0x39/0x39e
 ? btrfs_need_cleaner_sleep+0x27/0x27
 ? btrfs_clean_one_deleted_snapshot+0xa8/0xb2
 ? cleaner_kthread+0x80/0xf6
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
btrfs-transacti D    0  1283      2 0x80000000
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? btrfs_start_ordered_extent+0xd3/0x105
 ? finish_wait+0x60/0x60
 ? btrfs_wait_ordered_range+0xa4/0x100
 ? btrfs_get_token_32+0x8e/0xf4
 ? __btrfs_wait_cache_io+0x47/0x16d
 ? btrfs_start_dirty_block_groups+0x111/0x390
 ? btrfs_commit_transaction+0xc9/0x711
 ? start_transaction+0x2b8/0x329
 ? transaction_kthread+0xc6/0x132
 ? btrfs_cleanup_transaction+0x3ca/0x3ca
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
kworker/u16:1   D    0 19178      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? schedule+0x60/0x71
 ? schedule_timeout+0x32/0xec
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
kworker/u16:3   D    0  3778      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? schedule+0x60/0x71
 ? schedule_timeout+0x32/0xec
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
kworker/u16:14  D    0  4078      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? schedule+0x60/0x71
 ? schedule_timeout+0x32/0xec
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
kworker/u16:17  D    0  4084      2 0x80000000
Workqueue: btrfs-freespace-write btrfs_freespace_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? sched_clock_cpu+0x10/0x9c
 ? try_to_wake_up+0x202/0x229
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
btrfs           D    0 18526  18521 0x00000000
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? __set_extent_bit+0xff/0x3f8
 ? __set_extent_bit+0x3c0/0x3f8
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_buffered_write+0x4fd/0x5cf
 ? btrfs_file_write_iter+0x3a8/0x485
 ? __vfs_write+0x9b/0xd9
 ? vfs_write+0xa2/0xdf
 ? ksys_pwrite64+0x63/0x7f
 ? do_syscall_64+0x4e/0x5b
 ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
kworker/u16:12  D    0 24060      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? __slab_free.isra.72+0x89/0x1ba
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
kworker/u16:8   D    0 19152      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? schedule+0x60/0x71
 ? schedule_timeout+0x32/0xec
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
kworker/u16:7   D    0 27825      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? schedule+0x60/0x71
 ? schedule_timeout+0x32/0xec
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40
kworker/u16:11  D    0 31266      2 0x80000000
Workqueue: btrfs-endio-write btrfs_endio_write_helper
Call Trace:
 ? __schedule+0x4db/0x524
 ? schedule+0x60/0x71
 ? schedule_timeout+0xb2/0xec
 ? __next_timer_interrupt+0xae/0xae
 ? io_schedule_timeout+0x1b/0x3d
 ? balance_dirty_pages+0x7a7/0x861
 ? usleep_range+0x7e/0x7e
 ? schedule+0x60/0x71
 ? schedule_timeout+0x32/0xec
 ? balance_dirty_pages_ratelimited+0x204/0x225
 ? btrfs_finish_ordered_io+0x584/0x5ac
 ? normal_work_helper+0xfe/0x243
 ? process_one_work+0x18d/0x271
 ? rescuer_thread+0x278/0x278
 ? worker_thread+0x194/0x23f
 ? kthread+0xeb/0xf0
 ? kthread_associate_blkcg+0x86/0x86
 ? ret_from_fork+0x35/0x40


-- 
Stephen.
