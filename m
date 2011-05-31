From: Sascha Biermanns <saschakb@gmail.com>
Subject: WARNING: at fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0x22c/0x370
 [btrfs]()
Date: Tue, 31 May 2011 10:12:58 +0200
Message-ID: <4DE4A30A.9010207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Yesterday, I compiled the new kernel 3.0rc1 from git, but I never
successed to go over the point: "Removing old temporary files".
Pressing control-c let me boot on, but the pc was the complete time on
very high load. It took me minutes, just to reach the tty login - and
again minutes after login in, that I had my shell and a prompt to enter
something. The load was at that time beyond 10.

Now in my /var/log/messages, I found the following warning - and because
it happens when "removing" temporary/old files, that might be why the
computer has so much trouble:

May 30 23:25:17 localhost kernel: [17117.213589] Call Trace:



May 30 23:25:17 localhost kernel: [17117.213598]  [<ffffffff8104daeb>] ?
warn_slowpath_common+0x7b/0xc0


May 30 23:25:17 localhost kernel: [17117.213625]  [<ffffffffa01b650c>] ?
btrfs_alloc_free_block+0x22c/0x370 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213636]  [<ffffffff8139cc4c>] ?
schedule+0x53c/0xd70


May 30 23:25:17 localhost kernel: [17117.213643]  [<ffffffff8139ccbc>] ?
schedule+0x5ac/0xd70


May 30 23:25:17 localhost kernel: [17117.213672]  [<ffffffffa01e8a1f>] ?
read_extent_buffer+0xcf/0x1e0 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213698]  [<ffffffffa01a2853>] ?
__btrfs_cow_block+0x163/0x8d0 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213727]  [<ffffffffa01bfc69>] ?
btrfs_buffer_uptodate+0x49/0x70 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213753]  [<ffffffffa01a30d9>] ?
btrfs_cow_block+0x119/0x2b0 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213778]  [<ffffffffa01a8b5c>] ?
btrfs_search_slot+0x1dc/0x9b0 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213807]  [<ffffffffa01bb493>] ?
btrfs_lookup_file_extent+0x33/0x40 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213837]  [<ffffffffa01d32b0>] ?
btrfs_drop_extents+0xc0/0x960 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213847]  [<ffffffff810096a5>] ?
__switch_to+0xc5/0x300


May 30 23:25:17 localhost kernel: [17117.213854]  [<ffffffff811f2861>] ?
rb_insert_color+0x101/0x140


May 30 23:25:17 localhost kernel: [17117.213863]  [<ffffffff8111ffdc>] ?
kmem_cache_alloc+0x15c/0x180


May 30 23:25:17 localhost kernel: [17117.213894]  [<ffffffffa01c93a9>] ?
insert_reserved_file_extent.constprop.48+0x69/0x230 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213926]  [<ffffffffa01ca272>] ?
btrfs_finish_ordered_io+0x2f2/0x330 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213935]  [<ffffffff8105d93a>] ?
del_timer_sync+0x2a/0x50


May 30 23:25:17 localhost kernel: [17117.213965]  [<ffffffffa01e4372>] ?
end_bio_extent_writepage+0x122/0x160 [btrfs]


May 30 23:25:17 localhost kernel: [17117.213994]  [<ffffffffa01be2c9>] ?
end_workqueue_fn+0x39/0x120 [btrfs]


May 30 23:25:17 localhost kernel: [17117.214020]  [<ffffffffa01f118e>] ?
worker_loop+0x14e/0x4e0 [btrfs]


May 30 23:25:17 localhost kernel: [17117.214047]  [<ffffffffa01f1040>] ?
worker_loop+0x0/0x4e0 [btrfs]


May 30 23:25:17 localhost kernel: [17117.214054]  [<ffffffff8106eb3e>] ?
kthread+0x7e/0x90


May 30 23:25:17 localhost kernel: [17117.214061]  [<ffffffff8100bc24>] ?
kernel_thread_helper+0x4/0x10


May 30 23:25:17 localhost kernel: [17117.214068]  [<ffffffff8106eac0>] ?
kthread+0x0/0x90


May 30 23:25:17 localhost kernel: [17117.214075]  [<ffffffff8100bc20>] ?
kernel_thread_helper+0x0/0x10


May 30 23:25:17 localhost kernel: [17117.214080] ---[ end trace
6e2121230335769a ]---


May 30 23:25:17 localhost kernel: [17117.214109] ------------[ cut here
]------------


May 30 23:25:17 localhost kernel: [17117.214135] WARNING: at
fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0x22c/0x370 [btrfs]()


May 30 23:25:17 localhost kernel: [17117.214140] Hardware name: Presario
CQ56 Notebook PC

