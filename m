Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:59494 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbaCDOr4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Mar 2014 09:47:56 -0500
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1WKqCE-0002hn-2w
	for linux-btrfs@vger.kernel.org; Tue, 04 Mar 2014 09:19:50 -0500
Message-ID: <5315E105.3000003@intellasoft.net>
Date: Tue, 04 Mar 2014 09:19:49 -0500
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Task Hang
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have btrfs as the fs for a backuppc box.  updatedb was running at the 
same time as a massive rsync.

Mar  4 08:31:00 office-backup kernel: INFO: task updatedb.mlocat:903 
blocked for more than 120 seconds.
Mar  4 08:31:00 office-backup kernel:      Not tainted 3.13.2 #3
Mar  4 08:31:00 office-backup kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 08:31:00 office-backup kernel: updatedb.mlocat D 0000000000000000 
     0   903    899 0x00000000
Mar  4 08:31:00 office-backup kernel: ffff88007cad6270 0000000000000086 
ffff88007c0ee900 0000000000004000
Mar  4 08:31:00 office-backup kernel: ffff88005a705fd8 ffff88007cad6270 
000000541a6be000 ffff88007b9ac000
Mar  4 08:31:00 office-backup kernel: ffff88001ad2ef68 ffff880001f97000 
ffff8800452d4480 ffffffff812c3e5c
Mar  4 08:31:00 office-backup kernel: Call Trace:
Mar  4 08:31:00 office-backup kernel: [<ffffffff812c3e5c>] ? 
btrfs_map_bio+0x4ac/0x5a0
Mar  4 08:31:00 office-backup kernel: [<ffffffff812b79c0>] ? 
repair_io_failure+0x210/0x210
Mar  4 08:31:00 office-backup kernel: [<ffffffff810d9a40>] ? 
__lock_page+0x70/0x70
Mar  4 08:31:00 office-backup kernel: [<ffffffff817b8177>] ? 
io_schedule+0x87/0xd0
Mar  4 08:31:00 office-backup kernel: [<ffffffff810d9a49>] ? 
sleep_on_page+0x9/0x10
Mar  4 08:31:00 office-backup kernel: [<ffffffff817b8742>] ? 
__wait_on_bit+0x52/0x80
Mar  4 08:31:00 office-backup kernel: [<ffffffff81294d21>] ? 
btree_submit_bio_hook+0xe1/0x110
Mar  4 08:31:00 office-backup kernel: [<ffffffff810d9cc3>] ? 
wait_on_page_bit+0x73/0x80
Mar  4 08:31:00 office-backup kernel: [<ffffffff8109bdc0>] ? 
wake_atomic_t_function+0x30/0x30
Mar  4 08:31:00 office-backup kernel: [<ffffffff812bb2ba>] ? 
read_extent_buffer_pages+0x2aa/0x2e0
Mar  4 08:31:00 office-backup kernel: [<ffffffff810da355>] ? 
add_to_page_cache_lru+0x25/0x40
Mar  4 08:31:00 office-backup kernel: [<ffffffff81344b21>] ? 
radix_tree_insert+0x91/0x250
Mar  4 08:31:00 office-backup kernel: [<ffffffff81292a10>] ? 
verify_parent_transid+0x170/0x170
Mar  4 08:31:00 office-backup kernel: [<ffffffff812949a9>] ? 
btree_read_extent_buffer_pages.constprop.126+0xa9/0x110
Mar  4 08:31:00 office-backup kernel: [<ffffffff81294f23>] ? 
read_tree_block+0x33/0x60
Mar  4 08:31:00 office-backup kernel: [<ffffffff812775dc>] ? 
read_block_for_search.isra.45+0x18c/0x3b0
Mar  4 08:31:00 office-backup kernel: [<ffffffff81276d47>] ? 
comp_keys+0x27/0x30
Mar  4 08:31:00 office-backup kernel: [<ffffffff81279c8c>] ? 
btrfs_search_slot+0x41c/0x920
Mar  4 08:31:00 office-backup kernel: [<ffffffff812b1641>] ? 
btrfs_get_token_16+0x61/0xf0
Mar  4 08:31:00 office-backup kernel: [<ffffffff812919f5>] ? 
btrfs_lookup_inode+0x25/0xa0
Mar  4 08:31:00 office-backup kernel: [<ffffffff81113ef0>] ? 
kmem_cache_alloc+0xc0/0xe0
Mar  4 08:31:00 office-backup kernel: [<ffffffff812a6313>] ? 
btrfs_iget+0x103/0x520
Mar  4 08:31:00 office-backup kernel: [<ffffffff8128eb1f>] ? 
btrfs_lookup_dir_item+0x9f/0xd0
Mar  4 08:31:00 office-backup kernel: [<ffffffff812a843b>] ? 
btrfs_lookup_dentry+0x3db/0x4c0
Mar  4 08:31:00 office-backup kernel: [<ffffffff812a8529>] ? 
btrfs_lookup+0x9/0x20
Mar  4 08:31:00 office-backup kernel: [<ffffffff81120624>] ? 
lookup_real+0x14/0x50
Mar  4 08:31:00 office-backup kernel: [<ffffffff811211f2>] ? 
__lookup_hash+0x32/0x50
Mar  4 08:31:00 office-backup kernel: [<ffffffff81121b38>] ? 
lookup_slow+0x48/0xc0
Mar  4 08:31:00 office-backup kernel: [<ffffffff81123a91>] ? 
path_lookupat+0x711/0x760
Mar  4 08:31:00 office-backup kernel: [<ffffffff81123b0f>] ? 
filename_lookup+0x2f/0xd0
Mar  4 08:31:00 office-backup kernel: [<ffffffff81121d77>] ? 
getname_flags+0xb7/0x190
Mar  4 08:31:00 office-backup kernel: [<ffffffff811269ee>] ? 
user_path_at_empty+0x5e/0xb0
Mar  4 08:31:00 office-backup kernel: [<ffffffff8111bd6d>] ? 
cp_new_stat+0x10d/0x120
Mar  4 08:31:00 office-backup kernel: [<ffffffff8111bef1>] ? 
vfs_fstatat+0x41/0x90
Mar  4 08:31:00 office-backup kernel: [<ffffffff8111c0c2>] ? 
SyS_newlstat+0x12/0x30
Mar  4 08:31:00 office-backup kernel: [<ffffffff817bb7a2>] ? 
system_call_fastpath+0x16/0x1b
Mar  4 08:55:01 office-backup kernel: INFO: task updatedb.mlocat:903 
blocked for more than 120 seconds.
Mar  4 08:55:01 office-backup kernel:      Not tainted 3.13.2 #3
Mar  4 08:55:01 office-backup kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 08:55:01 office-backup kernel: updatedb.mlocat D 0000000000000000 
     0   903    899 0x00000000
Mar  4 08:55:01 office-backup kernel: ffff88007cad6270 0000000000000086 
ffff88007bb020d0 0000000000004000
Mar  4 08:55:01 office-backup kernel: ffff88005a705fd8 ffff88007cad6270 
00000055b6aee000 ffff88007b9ac000
Mar  4 08:55:01 office-backup kernel: ffff8800048282e8 ffff880076f80000 
ffff8800272a09c0 ffffffff812c3e5c
Mar  4 08:55:01 office-backup kernel: Call Trace:
Mar  4 08:55:01 office-backup kernel: [<ffffffff812c3e5c>] ? 
btrfs_map_bio+0x4ac/0x5a0
Mar  4 08:55:01 office-backup kernel: [<ffffffff812b79c0>] ? 
repair_io_failure+0x210/0x210
Mar  4 08:55:01 office-backup kernel: [<ffffffff810d9a40>] ? 
__lock_page+0x70/0x70
Mar  4 08:55:01 office-backup kernel: [<ffffffff817b8177>] ? 
io_schedule+0x87/0xd0
Mar  4 08:55:01 office-backup kernel: [<ffffffff810d9a49>] ? 
sleep_on_page+0x9/0x10
Mar  4 08:55:01 office-backup kernel: [<ffffffff817b8742>] ? 
__wait_on_bit+0x52/0x80
Mar  4 08:55:01 office-backup kernel: [<ffffffff81294d21>] ? 
btree_submit_bio_hook+0xe1/0x110
Mar  4 08:55:01 office-backup kernel: [<ffffffff810d9cc3>] ? 
wait_on_page_bit+0x73/0x80
Mar  4 08:55:01 office-backup kernel: [<ffffffff8109bdc0>] ? 
wake_atomic_t_function+0x30/0x30
Mar  4 08:55:01 office-backup kernel: [<ffffffff812bb2ba>] ? 
read_extent_buffer_pages+0x2aa/0x2e0
Mar  4 08:55:01 office-backup kernel: [<ffffffff810da355>] ? 
add_to_page_cache_lru+0x25/0x40
Mar  4 08:55:01 office-backup kernel: [<ffffffff81292a10>] ? 
verify_parent_transid+0x170/0x170
Mar  4 08:55:01 office-backup kernel: [<ffffffff812949a9>] ? 
btree_read_extent_buffer_pages.constprop.126+0xa9/0x110
Mar  4 08:55:01 office-backup kernel: [<ffffffff81294f23>] ? 
read_tree_block+0x33/0x60
Mar  4 08:55:01 office-backup kernel: [<ffffffff812775dc>] ? 
read_block_for_search.isra.45+0x18c/0x3b0
Mar  4 08:55:01 office-backup kernel: [<ffffffff81276d47>] ? 
comp_keys+0x27/0x30
Mar  4 08:55:01 office-backup kernel: [<ffffffff81279c8c>] ? 
btrfs_search_slot+0x41c/0x920
Mar  4 08:55:01 office-backup kernel: [<ffffffff812b1641>] ? 
btrfs_get_token_16+0x61/0xf0
Mar  4 08:55:01 office-backup kernel: [<ffffffff812919f5>] ? 
btrfs_lookup_inode+0x25/0xa0
Mar  4 08:55:01 office-backup kernel: [<ffffffff81113ef0>] ? 
kmem_cache_alloc+0xc0/0xe0
Mar  4 08:55:01 office-backup kernel: [<ffffffff812a6313>] ? 
btrfs_iget+0x103/0x520
Mar  4 08:55:01 office-backup kernel: [<ffffffff8128eb1f>] ? 
btrfs_lookup_dir_item+0x9f/0xd0
Mar  4 08:55:01 office-backup kernel: [<ffffffff812a843b>] ? 
btrfs_lookup_dentry+0x3db/0x4c0
Mar  4 08:55:01 office-backup kernel: [<ffffffff812a8529>] ? 
btrfs_lookup+0x9/0x20
Mar  4 08:55:01 office-backup kernel: [<ffffffff81120624>] ? 
lookup_real+0x14/0x50
Mar  4 08:55:01 office-backup kernel: [<ffffffff811211f2>] ? 
__lookup_hash+0x32/0x50
Mar  4 08:55:01 office-backup kernel: [<ffffffff81121b38>] ? 
lookup_slow+0x48/0xc0
Mar  4 08:55:01 office-backup kernel: [<ffffffff81123a91>] ? 
path_lookupat+0x711/0x760
Mar  4 08:55:01 office-backup kernel: [<ffffffff81123b0f>] ? 
filename_lookup+0x2f/0xd0
Mar  4 08:55:01 office-backup kernel: [<ffffffff81121d77>] ? 
getname_flags+0xb7/0x190
Mar  4 08:55:01 office-backup kernel: [<ffffffff811269ee>] ? 
user_path_at_empty+0x5e/0xb0
Mar  4 08:55:01 office-backup kernel: [<ffffffff8111bd6d>] ? 
cp_new_stat+0x10d/0x120
Mar  4 08:55:01 office-backup kernel: [<ffffffff8111bef1>] ? 
vfs_fstatat+0x41/0x90
Mar  4 08:55:01 office-backup kernel: [<ffffffff8111c0c2>] ? 
SyS_newlstat+0x12/0x30
Mar  4 08:55:01 office-backup kernel: [<ffffffff817bb7a2>] ? 
system_call_fastpath+0x16/0x1b

