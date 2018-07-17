Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:32788 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729713AbeGQSY0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 14:24:26 -0400
Date: Tue, 17 Jul 2018 10:50:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <Damenly_Su@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, quwenruo.btrfs@gmx.com,
        linux-btrfs@vger.kernel.org
Message-ID: <20180717175032.ri3n53rftepxqxqd@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7706c2db-fce8-f24c-4294-a312a987b58c@gmx.com>
Subject: task btrfs-transacti:921 blocked for more than 120 seconds during
 check repair
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got the following on 4.17.6 while running btrfs check --repair on an
unmounted filesystem (not the lowmem version)

I understand that btrfs check is userland only, although it seems that
it caused these FS hangs on a different filesystem (the trace of course
does not provide info on which FS)

Any idea what happened here?
I'm going to wait a few hours without running btrfs check to see if it
happens again and then if running btrfs check will re-create this issue,
but other suggestions (if any), are welcome:

[ 2538.566952] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 2538.616484] Call Trace:
[ 2538.623828]  ? __schedule+0x53e/0x59b
[ 2538.634802]  schedule+0x7f/0x98
[ 2538.644214]  wait_current_trans+0x9b/0xd8
[ 2538.656229]  ? add_wait_queue+0x3a/0x3a
[ 2538.668239]  start_transaction+0x1ce/0x325
[ 2538.680556]  btrfs_finish_ordered_io+0x240/0x5d3
[ 2538.694414]  normal_work_helper+0x118/0x277
[ 2538.706984]  process_one_work+0x19c/0x281
[ 2538.719036]  ? rescuer_thread+0x279/0x279
[ 2538.731064]  worker_thread+0x197/0x246
[ 2538.742322]  kthread+0xeb/0xf0
[ 2538.751492]  ? kthread_create_worker_on_cpu+0x66/0x66
[ 2538.766666]  ret_from_fork+0x35/0x40
[ 2538.777403] INFO: task kworker/u16:11:369 blocked for more than 120 seconds.
[ 2538.799025]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 2538.818109] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2538.841640] kworker/u16:11  D    0   369      2 0x80000000
[ 2538.858112] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 2538.876401] Call Trace:
[ 2538.883770]  ? __schedule+0x53e/0x59b
[ 2538.894760]  schedule+0x7f/0x98
[ 2538.904192]  wait_current_trans+0x9b/0xd8
[ 2538.916242]  ? add_wait_queue+0x3a/0x3a
[ 2538.927772]  start_transaction+0x1ce/0x325
[ 2538.940081]  btrfs_finish_ordered_io+0x240/0x5d3
[ 2538.953973]  normal_work_helper+0x118/0x277
[ 2538.966523]  process_one_work+0x19c/0x281
[ 2538.978546]  ? rescuer_thread+0x279/0x279
[ 2538.990560]  worker_thread+0x197/0x246
[ 2539.001797]  kthread+0xeb/0xf0
[ 2539.010986]  ? kthread_create_worker_on_cpu+0x66/0x66
[ 2539.026137]  ret_from_fork+0x35/0x40
[ 2539.037666] INFO: task btrfs-transacti:921 blocked for more than 120 seconds.
[ 2539.059851]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 2539.079733] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2539.104007] btrfs-transacti D    0   921      2 0x80000000
[ 2539.121257] Call Trace:
[ 2539.129377]  ? __schedule+0x53e/0x59b
[ 2539.141171]  schedule+0x7f/0x98
[ 2539.151370]  btrfs_tree_lock+0xa6/0x19d
[ 2539.163621]  ? add_wait_queue+0x3a/0x3a
[ 2539.175876]  btrfs_search_slot+0x5aa/0x756
[ 2539.188899]  lookup_inline_extent_backref+0x11a/0x485
[ 2539.204781]  ? fixup_slab_list.isra.43+0x1b/0x72
[ 2539.219360]  __btrfs_free_extent+0xf1/0xa72
[ 2539.232597]  ? btrfs_merge_delayed_refs+0x18b/0x1a7
[ 2539.247922]  ? __mutex_trylock_or_owner+0x43/0x54
[ 2539.262708]  __btrfs_run_delayed_refs+0xad8/0xc40
[ 2539.277504]  btrfs_run_delayed_refs+0x6e/0x16a
[ 2539.291519]  btrfs_commit_transaction+0x42/0x710
[ 2539.306043]  ? start_transaction+0x295/0x325
[ 2539.319516]  transaction_kthread+0xc9/0x135
[ 2539.332757]  ? btrfs_cleanup_transaction+0x3ee/0x3ee
[ 2539.348327]  kthread+0xeb/0xf0
[ 2539.358155]  ? kthread_create_worker_on_cpu+0x66/0x66
[ 2539.373977]  ret_from_fork+0x35/0x40
[ 2539.385394] INFO: task vnstatd:6338 blocked for more than 120 seconds.
[ 2539.405667]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
