From: maria@ponstudios.se
Subject: Kernel BUG at fs/btrfs/inode.c:2281 & 4665
Date: Tue, 12 Apr 2011 17:11:49 +0200 (CEST)
Message-ID: <4931fe2bc7e70ddc21f0240f9b65bb29.squirrel@squirrel-webmail.surftown.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


The computer was idle when the first bug happened and after the reboot
btrfs can't be mounted. It can't delete orphans and replay the log.
It would be nice if I can get the data out, there is nothing important
there but it would be nice. I was actually fixing typos in the backup
scripts when the bug attacked :)

I have written this by hand so there may be typos. I skipped the parts
that I don't think is necessary, the rest is on paper if I missed
something important.

kernel 2.6.39-rc2

Kernel BUG at fs/btrfs/inode.c:2281
EIP is at btrfs_orphan_del+0xa8/0xc1
Call Trace:
btrfs_orphan_cleanup+0x18b/0x2a5
btrfs_lookup_dentry+0x32f/0357
btrfs_lookup+0xb/0x22
d_albc_and_lookup+0x38/0x4f
walk_component+0x131/0x2b0
? btrfs_getxattr+0x2f/0x5b
path_lookupat+0x9a/0x2af
do_path_lookup+0x33/0x8b
user_path_at+0x3b/0x61
? putname+0x25/0x2e
? putname+0x25/0x2e
? user_path_at+0x44/0x61
vfs_fstatat+0x51/0x78
vfs_lstat+0x16/0x18
sys_lstat64+0x14/0x28
? vfs_mount_lock_local_unlock+0x20/0x2b
? mntput_no_expire+0x53/0x110
? mntput+0x19/0x1b
? path_put+0x15/0x18
? sys_getxattr+0x3f/0x4c
sysenter_do_call+0x12/0x22

Kernel BUG at fs/btrfs/inode.c:4665
EIP is at btrfs_add_link+0x11f/0x188
Call Trace:
add_inode_ref+0x226/0x29d
? __kmap_atomic+0xe/0x10
replay_one_buffer+0x165/0x1db
walk_down_log_tree+0x155/0x2ac
walk_log_tree+0x63/0x162
? _raw_spin_unlock+0x14/0x1f
btrfs_recover_log_trees+0x15c/0x23e
? replay_one_extent+0x518/0x518
open_ctree+0xe77/0x1102
? strcpy+0x13/0x2e
btrfs_mount+0x2ab/0x622
? ida_get_new_above+0x14c/0x166
mount_fs+0xe/0x95
vfs_kern_mount+0x4c/0x79
do_kern_mount+0x2f/0xae
? notify_page_fault+0x5f/0x5f
? copy_mount_options+0x73/0xd2
sys_mount+0x61/0x8f
sysenter_do_call+0x12/0x22

// Maria


