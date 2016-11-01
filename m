Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34204 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1169078AbcKANZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 09:25:25 -0400
Received: by mail-vk0-f53.google.com with SMTP id x186so70475512vkd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Nov 2016 06:25:25 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Tue, 1 Nov 2016 09:25:23 -0400
Message-ID: <CAJtFHUT-eW0S1kPs26aVKCu=TX4yTU6mvioc7r3mtJ90J8F6Cg@mail.gmail.com>
Subject: dmesg traces from enospc_debug & kernel 4.9-r3
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Testing 4.9-rc3 on my big backup system running rsync. Saw 10 traces
over the last day, I broke them down into groups for were they differ
with a full trace at the bottom for reference. Hopefully useful to
somebody. Everything is running fine so far. Can send all the full
traces if someone is interested.

2 of these:
trace6:[14843.507199]  [<ffffffffa019b38c>] ?
btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
trace6-[14843.507254]  [<ffffffffa0181e38>] ?
__btrfs_cow_block+0x148/0x5d0 [btrfs]
trace6-[14843.507294]  [<ffffffffa0182464>] ?
btrfs_cow_block+0x114/0x1d0 [btrfs]
trace6-[14843.507334]  [<ffffffffa01861d6>] ?
btrfs_search_slot+0x206/0xa40 [btrfs]
trace6-[14843.507376]  [<ffffffffa0216708>] ?
__btrfs_qgroup_release_data+0x88/0x120 [btrfs]

4 of these:
trace8:[15611.350323]  [<ffffffffa019b38c>] ?
btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
trace8-[15611.350378]  [<ffffffffa017ec82>] ? leaf_space_used+0xd2/0x110 [btrfs]
trace8-[15611.350417]  [<ffffffffa0181e38>] ?
__btrfs_cow_block+0x148/0x5d0 [btrfs]
trace8-[15611.350458]  [<ffffffffa0182464>] ?
btrfs_cow_block+0x114/0x1d0 [btrfs]
trace8-[15611.350498]  [<ffffffffa01861d6>] ?
btrfs_search_slot+0x206/0xa40 [btrfs]

1 each of the following 4
trace1:[14494.245397]  [<ffffffffa019b38c>] ?
btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
trace1-[14494.245457]  [<ffffffffa01d0f56>] ?
read_extent_buffer_pages+0x1c6/0x2a0 [btrfs]
trace1-[14494.245513]  [<ffffffffa0181e38>] ?
__btrfs_cow_block+0x148/0x5d0 [btrfs]
trace1-[14494.245553]  [<ffffffffa0182464>] ?
btrfs_cow_block+0x114/0x1d0 [btrfs]
trace1-[14494.245593]  [<ffffffffa01861d6>] ?
btrfs_search_slot+0x206/0xa40 [btrfs]
--
trace10:[83879.470211]  [<ffffffffa019b38c>] ?
btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
trace10-[83879.470259]  [<ffffffff81094620>] ?
autoremove_wake_function+0x30/0x30
trace10-[83879.470299]  [<ffffffffa0181e38>] ?
__btrfs_cow_block+0x148/0x5d0 [btrfs]
trace10-[83879.470339]  [<ffffffffa0182464>] ?
btrfs_cow_block+0x114/0x1d0 [btrfs]
trace10-[83879.470378]  [<ffffffffa0185710>] ? push_leaf_left+0xf0/0x170 [btrfs]
--
trace7:[15069.248346]  [<ffffffffa019b38c>] ?
btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
trace7-[15069.248394]  [<ffffffff81139ff5>] ? __activate_page+0x1b5/0x250
trace7-[15069.248423]  [<ffffffff81139e40>] ? put_pages_list+0x70/0x70
trace7-[15069.248452]  [<ffffffff81139cb8>] ? pagevec_lru_move_fn+0xb8/0xd0
trace7-[15069.248490]  [<ffffffffa0181e38>] ?
__btrfs_cow_block+0x148/0x5d0 [btrfs]
--
trace9:[21545.901275]  [<ffffffffa019b38c>] ?
btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
trace9-[21545.901323]  [<ffffffff81087d8e>] ? update_curr+0x7e/0x100
trace9-[21545.901361]  [<ffffffffa0181e38>] ?
__btrfs_cow_block+0x148/0x5d0 [btrfs]
trace9-[21545.901401]  [<ffffffffa0182464>] ?
btrfs_cow_block+0x114/0x1d0 [btrfs]
trace9-[21545.901443]  [<ffffffffa01861d6>] ?
btrfs_search_slot+0x206/0xa40 [btrfs]

A full one for reference
$ cat trace10
[83879.469227] use_block_rsv: 214 callbacks suppressed
[83879.469257] ------------[ cut here ]------------
[83879.469309] WARNING: CPU: 1 PID: 14025 at
fs/btrfs/extent-tree.c:8325 btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
[83879.469360] BTRFS: block rsv returned -28
[83879.469787] CPU: 1 PID: 14025 Comm: kworker/u34:4 Tainted: G
W I     4.9.0-rc3 #1
[83879.469893] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[83879.469926]  0000000000000000 ffffffff812946c9 ffffc9000e5ab968
0000000000000000
[83879.469979]  ffffffff8105a27f ffff8808198d8158 ffffc9000e5ab9b8
0000000000004000
[83879.470033]  ffff8808198d8000 ffff88039e154f00 0000000000000000
ffffffff8105a2ea
[83879.470087] Call Trace:
[83879.470113]  [<ffffffff812946c9>] ? dump_stack+0x46/0x5d
[83879.470143]  [<ffffffff8105a27f>] ? __warn+0xbf/0xe0
[83879.470170]  [<ffffffff8105a2ea>] ? warn_slowpath_fmt+0x4a/0x50
[83879.470211]  [<ffffffffa019b38c>] ?
btrfs_alloc_tree_block+0x3bc/0x4d0 [btrfs]
[83879.470259]  [<ffffffff81094620>] ? autoremove_wake_function+0x30/0x30
[83879.470299]  [<ffffffffa0181e38>] ? __btrfs_cow_block+0x148/0x5d0 [btrfs]
[83879.470339]  [<ffffffffa0182464>] ? btrfs_cow_block+0x114/0x1d0 [btrfs]
[83879.470378]  [<ffffffffa0185710>] ? push_leaf_left+0xf0/0x170 [btrfs]
[83879.470418]  [<ffffffffa0185e3a>] ? split_leaf+0x57a/0x710 [btrfs]
[83879.470456]  [<ffffffffa017ec82>] ? leaf_space_used+0xd2/0x110 [btrfs]
[83879.470495]  [<ffffffffa01868f6>] ? btrfs_search_slot+0x926/0xa40 [btrfs]
[83879.470540]  [<ffffffffa01c709e>] ? btrfs_get_token_32+0xee/0x110 [btrfs]
[83879.470584]  [<ffffffffa01a1118>] ?
btrfs_csum_file_blocks+0x3f8/0x610 [btrfs]
[83879.470643]  [<ffffffffa01aefc1>] ?
add_pending_csums.isra.48+0x41/0x60 [btrfs]
[83879.470702]  [<ffffffffa01b6a5b>] ?
btrfs_finish_ordered_io+0x31b/0x640 [btrfs]
[83879.470761]  [<ffffffffa01ded63>] ? normal_work_helper+0xc3/0x2f0 [btrfs]
[83879.470794]  [<ffffffff81071c3b>] ? process_one_work+0x14b/0x400
[83879.470824]  [<ffffffff8107225d>] ? worker_thread+0x5d/0x470
[83879.470853]  [<ffffffff81072200>] ? rescuer_thread+0x310/0x310
[83879.470882]  [<ffffffff81076ffb>] ? kthread+0xcb/0xf0
[83879.470909]  [<ffffffff81076f30>] ? kthread_park+0x50/0x50
[83879.470939]  [<ffffffff815053d2>] ? ret_from_fork+0x22/0x30
