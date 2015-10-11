Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37088 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbbJKLQe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 07:16:34 -0400
Received: by wijq8 with SMTP id q8so21027319wij.0
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 04:16:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r0mGLUS5HPfxeu5ip57iLk3SeJ04nJsr9CTchXu2mMMkw@mail.gmail.com>
References: <CAEtw4r3r-E1deboGDCfNkUL-ZKUdn4+B++oeu9M4H_7hHDj0TA@mail.gmail.com>
	<BLU436-SMTP5651E81A1B27D60895E652A9340@phx.gbl>
	<CAEtw4r3Qg-5cian-GjAuCmjaTnzea0OrHgxZO_VM1OwjoF2oxQ@mail.gmail.com>
	<CAEtw4r2HMrJciX4tgC9d9qSVucCJng-tyJxWPFX7h-5oqePV_w@mail.gmail.com>
	<CAEtw4r0mGLUS5HPfxeu5ip57iLk3SeJ04nJsr9CTchXu2mMMkw@mail.gmail.com>
Date: Sun, 11 Oct 2015 13:16:31 +0200
Message-ID: <CAEtw4r27FonYkrgdm8sdu1vLYP8KTdjWuu8=tOEatqJ8esRvgg@mail.gmail.com>
Subject: Re: kernel BUG at /linux/fs/btrfs/extent-tree.c:1833!
From: Peter Becker <floyd.net@gmail.com>
To: Henk Slager <hslager@hotmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dmesg:

[ 3000.613310] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3000.613314]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3000.613314] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3000.613315] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3000.613318]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3000.613319]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3000.613321]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3000.613322] Call Trace:
[ 3000.613327]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3000.613341]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3000.613344]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3000.613349]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3000.613351]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3000.613356]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3000.613364]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3000.613370]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3000.613376]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3000.613382]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3000.613388]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3000.613395]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3000.613400]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3000.613406]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3000.613411]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3000.613412]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3000.613414]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3000.613415]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3000.613416]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3120.613665] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3120.613669]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3120.613669] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3120.613670] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3120.613672]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3120.613674]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3120.613675]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3120.613676] Call Trace:
[ 3120.613682]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3120.613695]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3120.613698]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3120.613702]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3120.613704]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3120.613709]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3120.613716]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3120.613721]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3120.613727]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3120.613732]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3120.613744]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3120.613749]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3120.613754]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3120.613759]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3120.613764]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3120.613766]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3120.613767]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3120.613768]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3120.613769]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3240.614145] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3240.614148]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3240.614149] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3240.614150] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3240.614152]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3240.614154]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3240.614155]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3240.614156] Call Trace:
[ 3240.614161]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3240.614174]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3240.614177]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3240.614181]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3240.614183]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3240.614188]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3240.614194]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3240.614200]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3240.614206]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3240.614211]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3240.614217]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3240.614222]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3240.614227]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3240.614232]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3240.614236]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3240.614238]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3240.614239]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3240.614240]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3240.614241]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3360.614630] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3360.614634]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3360.614635] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3360.614636] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3360.614638]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3360.614640]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3360.614641]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3360.614642] Call Trace:
[ 3360.614647]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3360.614660]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3360.614663]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3360.614667]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3360.614669]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3360.614674]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3360.614681]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3360.614687]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3360.614692]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3360.614698]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3360.614703]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3360.614709]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3360.614713]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3360.614718]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3360.614723]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3360.614724]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3360.614725]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3360.614727]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3360.614728]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3480.615115] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3480.615118]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3480.615118] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3480.615119] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3480.615122]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3480.615124]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3480.615125]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3480.615126] Call Trace:
[ 3480.615131]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3480.615145]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3480.615148]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3480.615152]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3480.615154]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3480.615159]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3480.615166]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3480.615171]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3480.615177]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3480.615182]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3480.615187]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3480.615193]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3480.615198]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3480.615203]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3480.615207]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3480.615209]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3480.615210]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3480.615211]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3480.615212]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3600.615585] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3600.615589]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3600.615589] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3600.615590] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3600.615593]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3600.615594]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3600.615596]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3600.615597] Call Trace:
[ 3600.615602]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3600.615616]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3600.615619]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3600.615623]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3600.615625]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3600.615630]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3600.615637]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3600.615642]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3600.615647]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3600.615653]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3600.615658]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3600.615664]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3600.615669]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3600.615673]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3600.615678]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3600.615680]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3600.615681]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3600.615682]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3600.615683]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3720.616073] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3720.616076]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3720.616077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3720.616078] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3720.616080]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3720.616082]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3720.616083]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3720.616084] Call Trace:
[ 3720.616089]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3720.616103]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3720.616106]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3720.616111]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3720.616113]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3720.616119]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3720.616127]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3720.616133]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3720.616138]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3720.616144]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3720.616150]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3720.616155]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3720.616161]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3720.616166]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3720.616170]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3720.616172]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3720.616173]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3720.616175]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3720.616176]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3840.616538] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3840.616541]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3840.616542] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3840.616543] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3840.616545]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3840.616547]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3840.616548]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3840.616549] Call Trace:
[ 3840.616555]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3840.616569]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3840.616572]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3840.616576]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3840.616579]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3840.616584]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3840.616592]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3840.616598]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3840.616604]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3840.616609]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3840.616615]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3840.616621]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3840.616626]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3840.616631]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3840.616636]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3840.616637]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3840.616638]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3840.616640]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3840.616641]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3960.617033] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 3960.617037]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 3960.617037] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3960.617038] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 3960.617041]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 3960.617042]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 3960.617043]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 3960.617045] Call Trace:
[ 3960.617050]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 3960.617064]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 3960.617067]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 3960.617072]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 3960.617075]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 3960.617081]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 3960.617088]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 3960.617095]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 3960.617101]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 3960.617106]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 3960.617112]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3960.617118]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 3960.617123]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 3960.617128]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 3960.617133]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 3960.617134]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 3960.617136]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 3960.617137]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 3960.617138]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 4080.617509] INFO: task btrfs-transacti:11423 blocked for more than
120 seconds.
[ 4080.617512]       Tainted: G     U          4.2.3-040203-generic
#201510030832
[ 4080.617513] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4080.617514] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
[ 4080.617516]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
ffff8802121d2640
[ 4080.617518]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
ffff8801aa607940
[ 4080.617519]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
ffffffff817a6357
[ 4080.617520] Call Trace:
[ 4080.617525]  [<ffffffff817a6357>] schedule+0x37/0x80
[ 4080.617539]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
[ 4080.617542]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
[ 4080.617546]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
[ 4080.617548]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
[ 4080.617553]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 4080.617560]  [<ffffffffc034db13>] ?
btrfs_delete_delayed_items+0x313/0x330 [btrfs]
[ 4080.617566]  [<ffffffffc034d484>] ?
btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
[ 4080.617571]  [<ffffffffc034dd3a>]
__btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
[ 4080.617576]  [<ffffffffc034e03c>]
__btrfs_run_delayed_items+0x17c/0x210 [btrfs]
[ 4080.617582]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 4080.617587]  [<ffffffffc02f85c8>]
btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
[ 4080.617592]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
[ 4080.617597]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
[ 4080.617601]  [<ffffffffc02f37a0>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[ 4080.617603]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[ 4080.617604]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[ 4080.617605]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[ 4080.617606]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[44929.058013] ------------[ cut here ]------------
[44929.058035] WARNING: CPU: 0 PID: 39 at
/home/kernel/COD/linux/drivers/gpu/drm/i915/intel_uncore.c:70
assert_device_not_suspended.isra.11+0x53/0x60 [i915]()
[44929.058036] Device suspended
[44929.058037] Modules linked in: xt_nat veth xt_conntrack xt_addrtype
br_netfilter nvram msr dm_thin_pool dm_persistent_data dm_bio_prison
dm_bufio libcrc32c ir_lirc_codec lirc_dev ir_xmp_decoder
ir_sony_decoder ir_sharp_decoder ir_mce_kbd_decoder ir_sanyo_decoder
ir_rc6_decoder ir_nec_decoder ir_jvc_decoder ir_rc5_decoder rc_rc6_mce
xt_CHECKSUM iptable_mangle mceusb ipt_MASQUERADE
nf_nat_masquerade_ipv4 rc_core input_leds iptable_nat
nf_conntrack_ipv4 joydev nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack xt_tcpudp bridge stp llc iptable_filter ip_tables
x_tables autofs4 eeepc_wmi asus_wmi sparse_keymap snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
snd_hda_codec snd_hda_core dm_multipath snd_hwdep scsi_dh snd_pcm
intel_rapl iosf_mbi x86_pkg_temp_thermal snd_seq_midi
snd_seq_midi_event intel_powerclamp kvm snd_rawmidi crct10dif_pclmul
crc32_pclmul snd_seq rfcomm bnep ghash_clmulni_intel bluetooth
snd_seq_device cryptd snd_timer serio_raw snd lpc_ich mei_me mei
soundcore shpchp mac_hid parport_pc ppdev nct6775 hwmon_vid coretemp
lp parport nfsd auth_rpcgss nfs_acl nfs binfmt_misc lockd grace sunrpc
fscache btrfs xor raid6_pq nls_iso8859_1 dm_mirror dm_region_hash
dm_log hid_generic usbhid hid uas usb_storage psmouse ahci libahci wmi
i915 video i2c_algo_bit drm_kms_helper drm e1000e ptp pps_core
[44929.058088] CPU: 0 PID: 39 Comm: kswapd0 Tainted: G     U
4.2.3-040203-generic #201510030832
[44929.058089] Hardware name: ASUS All Series/H87I-PLUS, BIOS 2003 11/05/2014
[44929.058090]  ffffffffc01e5c78 ffff8800d5edb988 ffffffff817a2803
0000000000000000
[44929.058092]  ffff8800d5edb9d8 ffff8800d5edb9c8 ffffffff810771da
ffff88020a942d28
[44929.058093]  ffff8802120b0000 0000000000100010 0000000000100010
ffff8802120b0080
[44929.058094] Call Trace:
[44929.058098]  [<ffffffff817a2803>] dump_stack+0x45/0x57
[44929.058100]  [<ffffffff810771da>] warn_slowpath_common+0x8a/0xc0
[44929.058102]  [<ffffffff81077256>] warn_slowpath_fmt+0x46/0x50
[44929.058110]  [<ffffffffc0169cc3>]
assert_device_not_suspended.isra.11+0x53/0x60 [i915]
[44929.058116]  [<ffffffffc016b61a>] hsw_write32+0x3a/0x130 [i915]
[44929.058123]  [<ffffffffc0149eb0>] i915_gem_write_fence+0x210/0x520 [i915]
[44929.058125]  [<ffffffff813a5ea1>] ? __sg_free_table+0x71/0x90
[44929.058131]  [<ffffffffc014a266>]
i915_gem_object_update_fence+0xa6/0xd0 [i915]
[44929.058137]  [<ffffffffc014a31a>] i915_gem_object_put_fence+0x8a/0xd0 [i915]
[44929.058142]  [<ffffffffc014a4e7>] i915_vma_unbind+0x187/0x230 [i915]
[44929.058148]  [<ffffffffc014d2d6>] i915_gem_shrink+0x156/0x230 [i915]
[44929.058153]  [<ffffffffc014d43d>] i915_gem_shrinker_scan+0x8d/0xa0 [i915]
[44929.058156]  [<ffffffff81186b37>] shrink_slab+0x207/0x380
[44929.058157]  [<ffffffff8118b1f1>] shrink_zone+0x291/0x2b0
[44929.058158]  [<ffffffff8118c160>] kswapd+0x500/0x9b0
[44929.058159]  [<ffffffff8118bc60>] ? mem_cgroup_shrink_node_zone+0x130/0x130
[44929.058160]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[44929.058161]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[44929.058163]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[44929.058164]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[44929.058165] ---[ end trace 975c39f656782ad7 ]---
[44929.058171] ------------[ cut here ]------------
[44929.058179] WARNING: CPU: 0 PID: 39 at
/home/kernel/COD/linux/drivers/gpu/drm/i915/intel_uncore.c:620
hsw_unclaimed_reg_debug.isra.14+0x78/0xa0 [i915]()
[44929.058179] Unclaimed register detected before reading register 0x100010
[44929.058180] Modules linked in: xt_nat veth xt_conntrack xt_addrtype
br_netfilter nvram msr dm_thin_pool dm_persistent_data dm_bio_prison
dm_bufio libcrc32c ir_lirc_codec lirc_dev ir_xmp_decoder
ir_sony_decoder ir_sharp_decoder ir_mce_kbd_decoder ir_sanyo_decoder
ir_rc6_decoder ir_nec_decoder ir_jvc_decoder ir_rc5_decoder rc_rc6_mce
xt_CHECKSUM iptable_mangle mceusb ipt_MASQUERADE
nf_nat_masquerade_ipv4 rc_core input_leds iptable_nat
nf_conntrack_ipv4 joydev nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack xt_tcpudp bridge stp llc iptable_filter ip_tables
x_tables autofs4 eeepc_wmi asus_wmi sparse_keymap snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
snd_hda_codec snd_hda_core dm_multipath snd_hwdep scsi_dh snd_pcm
intel_rapl iosf_mbi x86_pkg_temp_thermal snd_seq_midi
snd_seq_midi_event intel_powerclamp kvm snd_rawmidi crct10dif_pclmul
crc32_pclmul snd_seq rfcomm bnep ghash_clmulni_intel bluetooth
snd_seq_device cryptd snd_timer serio_raw snd lpc_ich mei_me mei
soundcore shpchp mac_hid parport_pc ppdev nct6775 hwmon_vid coretemp
lp parport nfsd auth_rpcgss nfs_acl nfs binfmt_misc lockd grace sunrpc
fscache btrfs xor raid6_pq nls_iso8859_1 dm_mirror dm_region_hash
dm_log hid_generic usbhid hid uas usb_storage psmouse ahci libahci wmi
i915 video i2c_algo_bit drm_kms_helper drm e1000e ptp pps_core
[44929.058204] CPU: 0 PID: 39 Comm: kswapd0 Tainted: G     U  W
4.2.3-040203-generic #201510030832
[44929.058205] Hardware name: ASUS All Series/H87I-PLUS, BIOS 2003 11/05/2014
[44929.058205]  ffffffffc01e5c78 ffff8800d5edb968 ffffffff817a2803
0000000000000000
[44929.058206]  ffff8800d5edb9b8 ffff8800d5edb9a8 ffffffff810771da
ffff8800d5edb988
[44929.058207]  ffff8802120b0078 ffff8802120b0000 ffff8802120b0080
ffff8802120b0078
[44929.058208] Call Trace:
[44929.058210]  [<ffffffff817a2803>] dump_stack+0x45/0x57
[44929.058211]  [<ffffffff810771da>] warn_slowpath_common+0x8a/0xc0
[44929.058212]  [<ffffffff81077256>] warn_slowpath_fmt+0x46/0x50
[44929.058219]  [<ffffffffc0169e58>]
hsw_unclaimed_reg_debug.isra.14+0x78/0xa0 [i915]
[44929.058225]  [<ffffffffc016bd9f>] gen6_read32+0x5f/0x1a0 [i915]
[44929.058231]  [<ffffffffc016b686>] ? hsw_write32+0xa6/0x130 [i915]
[44929.058237]  [<ffffffffc0149ec0>] i915_gem_write_fence+0x220/0x520 [i915]
[44929.058238]  [<ffffffff813a5ea1>] ? __sg_free_table+0x71/0x90
[44929.058244]  [<ffffffffc014a266>]
i915_gem_object_update_fence+0xa6/0xd0 [i915]
[44929.058249]  [<ffffffffc014a31a>] i915_gem_object_put_fence+0x8a/0xd0 [i915]
[44929.058254]  [<ffffffffc014a4e7>] i915_vma_unbind+0x187/0x230 [i915]
[44929.058259]  [<ffffffffc014d2d6>] i915_gem_shrink+0x156/0x230 [i915]
[44929.058264]  [<ffffffffc014d43d>] i915_gem_shrinker_scan+0x8d/0xa0 [i915]
[44929.058266]  [<ffffffff81186b37>] shrink_slab+0x207/0x380
[44929.058267]  [<ffffffff8118b1f1>] shrink_zone+0x291/0x2b0
[44929.058268]  [<ffffffff8118c160>] kswapd+0x500/0x9b0
[44929.058269]  [<ffffffff8118bc60>] ? mem_cgroup_shrink_node_zone+0x130/0x130
[44929.058270]  [<ffffffff81094e69>] kthread+0xc9/0xe0
[44929.058271]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[44929.058272]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
[44929.058273]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
[44929.058274] ---[ end trace 975c39f656782ad8 ]---

2015-10-11 13:10 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
> I also get some of this syslog entrys:
>
> [ 3840.616538] INFO: task btrfs-transacti:11423 blocked for more than
> 120 seconds.
> [ 3840.616541]       Tainted: G     U          4.2.3-040203-generic
> #201510030832
> [ 3840.616542] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3840.616543] btrfs-transacti D 0000000000000000     0 11423      2 0x00000000
> [ 3840.616545]  ffff88007bd2bb58 0000000000000046 ffff880215d7e600
> ffff8802121d2640
> [ 3840.616547]  0000000000000246 ffff88007bd2c000 ffff8801aa607928
> ffff8801aa607940
> [ 3840.616548]  ffff88007bd2bba8 ffff8801aa607920 ffff88007bd2bb78
> ffffffff817a6357
> [ 3840.616549] Call Trace:
> [ 3840.616555]  [<ffffffff817a6357>] schedule+0x37/0x80
> [ 3840.616569]  [<ffffffffc0332038>] btrfs_tree_lock+0x98/0x1c0 [btrfs]
> [ 3840.616572]  [<ffffffff810b6fd0>] ? prepare_to_wait_event+0xf0/0xf0
> [ 3840.616576]  [<ffffffffc02d4095>] btrfs_search_slot+0x6e5/0x9c0 [btrfs]
> [ 3840.616579]  [<ffffffff81180ef7>] ? __set_page_dirty_nobuffers+0xe7/0x140
> [ 3840.616584]  [<ffffffffc02ed8cf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> [ 3840.616592]  [<ffffffffc034db13>] ?
> btrfs_delete_delayed_items+0x313/0x330 [btrfs]
> [ 3840.616598]  [<ffffffffc034d484>] ?
> btrfs_insert_delayed_items+0xa4/0x420 [btrfs]
> [ 3840.616604]  [<ffffffffc034dd3a>]
> __btrfs_update_delayed_inode+0x5a/0x1e0 [btrfs]
> [ 3840.616609]  [<ffffffffc034e03c>]
> __btrfs_run_delayed_items+0x17c/0x210 [btrfs]
> [ 3840.616615]  [<ffffffffc034e2e3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
> [ 3840.616621]  [<ffffffffc02f85c8>]
> btrfs_commit_transaction+0x2c8/0xb10 [btrfs]
> [ 3840.616626]  [<ffffffffc02f8ea3>] ? start_transaction+0x93/0x580 [btrfs]
> [ 3840.616631]  [<ffffffffc02f395a>] transaction_kthread+0x1ba/0x240 [btrfs]
> [ 3840.616636]  [<ffffffffc02f37a0>] ?
> btrfs_cleanup_transaction+0x540/0x540 [btrfs]
> [ 3840.616637]  [<ffffffff81094e69>] kthread+0xc9/0xe0
> [ 3840.616638]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
> [ 3840.616640]  [<ffffffff817a9f9f>] ret_from_fork+0x3f/0x70
> [ 3840.616641]  [<ffffffff81094da0>] ? kthread_create_on_node+0x180/0x180
>
> Is this helpfull? The filesystem is usable but i need the new space.
>
> 2015-10-10 21:48 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
>> btrfs balance start -m /media/RAID
>>
>> complete with out any error but the resulte of device usage is confusing me.
>> Metadata on sdb and sdc are 2 GiB, but on sdd (the new added device)
>> is 4 GiB. And the 2. one that's confusing me, is that sdd has a
>> "System" entry but sdb and sdc dosn't
>>
>> floyd@nas ~ $ sudo btrfs dev us /media/RAID/
>> /dev/sdb, ID: 1
>>    Device size:             2.73TiB
>>    Data,RAID1:              2.11TiB
>>    Metadata,RAID1:          2.00GiB
>>    System,RAID1:           32.00MiB
>>    Unallocated:           628.49GiB
>>
>> /dev/sdc, ID: 2
>>    Device size:             2.73TiB
>>    Data,RAID1:              2.11TiB
>>    Metadata,RAID1:          2.00GiB
>>    Unallocated:           628.52GiB
>>
>> /dev/sdd, ID: 3
>>    Device size:             2.73TiB
>>    Data,RAID1:            792.00GiB
>>    Metadata,RAID1:          4.00GiB
>>    System,RAID1:           32.00MiB
>>    Unallocated:             1.95TiB
>>
>> 2015-10-10 21:23 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
>>> Hi Henk,
>>>
>>> i have try it with kernel 4.1.6 and 4.2.3; btrfs progs 4.2.1 and 4.2.2
>>> .. the same error.
>>> System freeze after 70% of balancing.
>>>
>>> Scrub complete without error.
>>>
>>> has someone a hint what i can do now?
>>>
>>> 2015-10-09 15:52 GMT+02:00 Henk Slager <hslager@hotmail.com>:
>>>> Hi Peter,
>>>>
>>>> I would try to add the mount option   skip_balance   for your raid1
>>>> pool first, then see if you can use your system as you normally would.
>>>> I assume you can live without explicit (re-)balance for some time,
>>>> i.e. that the original disks are not too full.
>>>>
>>>> I recently did also some disks add/remove and also raid profile
>>>> convert and found out that kernel 4.2.x did crash my system with
>>>> various kernel bugs. So I switched back to 4.1.6 and although other
>>>> bugs hit me (see https://bugzilla.kernel.org/show_bug.cgi?id=104371 )
>>>> the actions I wanted did complete.
>>>>
>>>> Using "btrfs check --repair" has never resulted in succes for me (for
>>>> some root filesystems (single profiles for s m d) on real and virual
>>>> machines), so I would only use that once you have your files backed up
>>>> on some other (cloned) filesystem.
>>>>
>>>> /Henk
>>>>
>>>> On Fri, Oct 9, 2015 at 9:41 AM, Peter Becker <floyd.net@gmail.com> wrote:
>>>>>
>>>>> At first i add a new device to my btrfs raid1 pool and start balance.
>>>>> After ~5 hours, balanace hangs and cpu-usage goes to 100% (kworker/u4
>>>>> use all cpu-power).
>>>>>
>>>>> What should i do now? Run "btrfs check --repair" on all devices?
>>>>>
>>>>> Kernel: 4.2.3-040203-generic
>>>>> Btrfs progs v4.2.1
>>>>>
>>>>> Full Syslog: https://bugzilla.kernel.org/show_bug.cgi?id=105681
>>>>>
>>>>> From Syslog:
>>>>>
>>>>> [16880.495586] kernel BUG at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:1833!
>>>>> [16880.495603] invalid opcode: 0000 [#1] SMP
>>>>> [16880.495614] Modules linked in: xt_nat veth xt_conntrack xt_addrtype
>>>>> br_netfilter nvram dm_thin_pool dm_persistent_data msr dm_bio_prison
>>>>> dm_bufio libcrc32c ir_lirc_codec ir_xmp_decoder lirc_dev
>>>>> ir_mce_kbd_decoder ir_sharp_decoder ir_sony_decoder ir_sanyo_decoder
>>>>> ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_rc6_mce
>>>>> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
>>>>> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 mceusb nf_nat_ipv4
>>>>> rc_core nf_nat nf_conntrack input_leds joydev xt_tcpudp bridge stp llc
>>>>> iptable_filter ip_tables x_tables autofs4 eeepc_wmi asus_wmi
>>>>> sparse_keymap dm_multipath scsi_dh intel_rapl iosf_mbi
>>>>> x86_pkg_temp_thermal intel_powerclamp kvm crct10dif_pclmul
>>>>> crc32_pclmul snd_seq_midi snd_seq_midi_event snd_rawmidi
>>>>> ghash_clmulni_intel cryptd snd_hda_codec_hdmi rfcomm snd_seq serio_raw
>>>>> bnep snd_hda_codec_realtek snd_hda_codec_generic bluetooth
>>>>> snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm
>>>>> snd_seq_device lpc_ich snd_timer mei_me mei snd shpchp mac_hid
>>>>> soundcore parport_pc ppdev nfsd nct6775 hwmon_vid coretemp auth_rpcgss
>>>>> nfs_acl nfs lockd grace binfmt_misc sunrpc lp parport fscache
>>>>> nls_iso8859_1 btrfs xor raid6_pq dm_mirror dm_region_hash dm_log
>>>>> hid_generic usbhid hid uas usb_storage psmouse ahci libahci wmi i915
>>>>> video i2c_algo_bit drm_kms_helper drm e1000e ptp pps_core
>>>>> [16880.495944] CPU: 0 PID: 5967 Comm: btrfs Tainted: G     U
>>>>> 4.2.3-040203-generic #201510030832
>>>>> [16880.495964] Hardware name: ASUS All Series/H87I-PLUS, BIOS 2003 11/05/2014
>>>>> [16880.495979] task: ffff8800a918b300 ti: ffff8800a9f00000 task.ti:
>>>>> ffff8800a9f00000
>>>>> [16880.495995] RIP: 0010:[<ffffffffc02db016>]  [<ffffffffc02db016>]
>>>>> insert_inline_extent_backref+0xc6/0xd0 [btrfs]
>>>>> [16880.496028] RSP: 0018:ffff8800a9f03718  EFLAGS: 00010293
>>>>> [16880.496042] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8800a9f03750
>>>>> [16880.496060] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
>>>>> [16880.496077] RBP: ffff8800a9f03788 R08: 0000000000004000 R09: ffff8800a9f03608
>>>>> [16880.496093] R10: 0000000000000000 R11: 0000000000000002 R12: ffff880214b11000
>>>>> [16880.496109] R13: 000006a203798000 R14: 0000000000000000 R15: ffff8800d80c7990
>>>>> [16880.496125] FS:  00007fd9f02fa900(0000) GS:ffff88021fa00000(0000)
>>>>> knlGS:0000000000000000
>>>>> [16880.496146] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> [16880.496159] CR2: 00007f438fbc2000 CR3: 00000000a90ae000 CR4: 00000000000406f0
>>>>> [16880.496175] Stack:
>>>>> [16880.496180]  000006a203798000 0000000000000414 0000000000000000
>>>>> 0000000000000000
>>>>> [16880.496200]  0000000000000001 ffffffffc02cef1a ffff8800a9f037f8
>>>>> 0000000000002bbd
>>>>> [16880.496220]  ffff88016f19f2e0 ffff880214b10000 ffff88016f19f2e0
>>>>> ffff8800d80c7990
>>>>> [16880.496239] Call Trace:
>>>>> [16880.496251]  [<ffffffffc02cef1a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
>>>>> [16880.496271]  [<ffffffffc02db0b8>]
>>>>> __btrfs_inc_extent_ref.isra.51+0x98/0x250 [btrfs]
>>>>> [16880.496295]  [<ffffffffc02e0d0a>]
>>>>> __btrfs_run_delayed_refs+0xcfa/0x1070 [btrfs]
>>>>> [16880.496316]  [<ffffffff813bda85>] ? __percpu_counter_add+0x55/0x70
>>>>> [16880.496337]  [<ffffffffc02e3c3e>]
>>>>> btrfs_run_delayed_refs.part.73+0x6e/0x280 [btrfs]
>>>>> [16880.496360]  [<ffffffffc02e3e67>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
>>>>> [16880.496383]  [<ffffffffc02f7dc9>]
>>>>> btrfs_should_end_transaction+0x49/0x60 [btrfs]
>>>>> [16880.496407]  [<ffffffffc02e2439>] btrfs_drop_snapshot+0x439/0x830 [btrfs]
>>>>> [16880.496431]  [<ffffffffc0346200>] ?
>>>>> invalidate_extent_cache+0x160/0x1a0 [btrfs]
>>>>> [16880.496455]  [<ffffffffc034b2e2>] merge_reloc_roots+0xd2/0x230 [btrfs]
>>>>> [16880.496475]  [<ffffffffc034b696>] relocate_block_group+0x256/0x600 [btrfs]
>>>>> [16880.496495]  [<ffffffffc034bc03>]
>>>>> btrfs_relocate_block_group+0x1c3/0x2d0 [btrfs]
>>>>> [16880.496517]  [<ffffffffc031f9be>]
>>>>> btrfs_relocate_chunk.isra.39+0x3e/0xc0 [btrfs]
>>>>> [16880.496537]  [<ffffffffc0320e3f>] __btrfs_balance+0x48f/0x8c0 [btrfs]
>>>>> [16880.496556]  [<ffffffffc03215ed>] btrfs_balance+0x37d/0x650 [btrfs]
>>>>> [16880.496575]  [<ffffffffc032d7b4>] ? btrfs_ioctl_balance+0x284/0x510 [btrfs]
>>>>> [16880.496594]  [<ffffffffc032d694>] btrfs_ioctl_balance+0x164/0x510 [btrfs]
>>>>> [16880.496613]  [<ffffffffc032fb8f>] btrfs_ioctl+0x56f/0x2470 [btrfs]
>>>>> [16880.496628]  [<ffffffff8118490b>] ?
>>>>> lru_cache_add_active_or_unevictable+0x2b/0xa0
>>>>> [16880.496645]  [<ffffffff811a4d9a>] ? handle_mm_fault+0xb8a/0x1810
>>>>> [16880.496658]  [<ffffffff811a8f39>] ? vma_link+0xb9/0xc0
>>>>> [16880.496670]  [<ffffffff811fc6fd>] do_vfs_ioctl+0x2cd/0x4b0
>>>>> [16880.496684]  [<ffffffff81063cc7>] ? __do_page_fault+0x1b7/0x430
>>>>> [16880.496697]  [<ffffffff811fc959>] SyS_ioctl+0x79/0x90
>>>>> [16880.496709]  [<ffffffff817a9b72>] entry_SYSCALL_64_fastpath+0x16/0x75
>>>>> [16880.496723] Code: 45 10 49 89 d9 48 8b 55 c8 4c 89 34 24 4c 89 e9
>>>>> 4c 89 fe 4c 89 e7 48 89 44 24 10 8b 45 28 89 44 24 08 e8 4e e4 ff ff
>>>>> 31 c0 eb bb <0f> 0b 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5
>>>>> 41 57
>>>>> [16880.496802] RIP  [<ffffffffc02db016>]
>>>>> insert_inline_extent_backref+0xc6/0xd0 [btrfs]
>>>>> [16880.496823]  RSP <ffff8800a9f03718>
>>>>> [16880.502316] ---[ end trace bcd7d52a2c7cfdc7 ]---
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
