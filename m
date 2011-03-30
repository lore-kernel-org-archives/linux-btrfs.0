From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.39-rc1] extent reference leaking...
Date: Wed, 30 Mar 2011 18:37:57 +0800
Message-ID: <AANLkTimdjZXmbAmxEEQQ2_DA9DG1HMnvQhOcMP176BTV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When running the Linux Test Project against a BTRFS RAID 1 array,
after some time I see BTRFS trying to free an extent that still has
state [1].

Let me know if anyone is interested in a more specific reproducer and
I'll take a look.

Daniel

--- [1]

WARNING: at fs/btrfs/extent_io.c:3371 free_extent_buffer+0x31/0x40()
Hardware name: X8STi
Modules linked in: tun microcode loop raid10 raid456 async_memcpy
async_pq async_xor xor async_raid6_recov raid6_pq async_tx raid1 raid0
multipath linear md_mod
Pid: 14202, comm: ftest08 Tainted: G        W   2.6.39-rc1-350cd #1
Call Trace:
 [<ffffffff8105f81a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8105f865>] warn_slowpath_null+0x15/0x20
 [<ffffffff812b6711>] free_extent_buffer+0x31/0x40
 [<ffffffff8127ad40>] btrfs_lock_root_node+0x20/0x50
 [<ffffffff8127b530>] btrfs_search_slot+0x400/0x790
 [<ffffffff81275eb5>] ? btrfs_alloc_path+0x15/0x30
 [<ffffffff81275eb5>] ? btrfs_alloc_path+0x15/0x30
 [<ffffffff8128e053>] btrfs_lookup_csums_range+0x83/0x4b0
 [<ffffffff812b56be>] ? unmap_extent_buffer+0xe/0x40
 [<ffffffff812a8744>] ? btrfs_file_extent_compression+0xe4/0xf0
 [<ffffffff812cd325>] copy_items+0x315/0x3f0
 [<ffffffff812cf03a>] btrfs_log_inode+0x3ea/0x520
 [<ffffffff812ce3bb>] ? start_log_trans+0x6b/0x150
 [<ffffffff812cf463>] btrfs_log_inode_parent+0x193/0x2e0
 [<ffffffff81156424>] ? dget_parent+0x94/0x100
 [<ffffffff811563a7>] ? dget_parent+0x17/0x100
 [<ffffffff812cf664>] btrfs_log_dentry_safe+0x44/0x70
 [<ffffffff812a5afb>] btrfs_sync_file+0xeb/0x190
 [<ffffffff8116bb43>] vfs_fsync_range+0x73/0x90
 [<ffffffff81141470>] ? fget_raw+0x260/0x260
 [<ffffffff8116bbb7>] vfs_fsync+0x17/0x20
 [<ffffffff8116bbf5>] do_fsync+0x35/0x60
 [<ffffffff8116bc4b>] sys_fsync+0xb/0x10
 [<ffffffff816edf3b>] system_call_fastpath+0x16/0x1b
---[ end trace a7919e7f17c0a728 ]---
-- 
Daniel J Blueman
