From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [BUG] sleeping function called from atomic context
Date: Fri, 04 May 2012 12:18:51 +0200
Message-ID: <4FA3AD0B.7040500@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Looks like after "btrfs read error corrected" of chunk tree block while
reading the chunk tree in open_ctree(), we stay in atomic state (in
3.4-rc5).

The steps:
# mkfs.btrfs -d raid1 -m raid1 /dev/sdv /dev/sdw /dev/sdi
# mount /dev/sdv /mnt
fill /mnt to 25% full
# umount /mnt
disconnect /dev/sdw
# mount /dev/sdv /mnt -o degraded
fill /mnt to 50% full
# umount /mnt
reconnect /dev/sdw
# mount /dev/sdv /mnt

Block 20971520 is the chunk tree node on /dev/sdw. Here's the kernel
log, and the short btrfs-debug-tree output of the chunk tree is located
at the end of the mail:

sd 6:0:27:0: [sdw] Attached SCSI disk
device fsid 7e1ea62e-7d32-4c11-bc02-1bc197be8f54 devid 1 transid 41 /dev/sdv
btrfs: disk space caching is enabled
parent transid verify failed on 20971520 wanted 38 found 12
btrfs read error corrected: ino 1 off 20971520 (dev /dev/sdw sector 2048)
BUG: sleeping function called from invalid context at mm/slub.c:937
in_atomic(): 1, irqs_disabled(): 0, pid: 5955, name: mount
INFO: lockdep is turned off.
Pid: 5955, comm: mount Tainted: G        W    3.3.0+ #57
Call Trace:
 [<ffffffff810af591>] __might_sleep+0xe1/0x110
 [<ffffffff81188bbd>] kmem_cache_alloc+0x4d/0x160
 [<ffffffff81140270>] ? __lock_page+0x70/0x70
 [<ffffffffa00f86bb>] alloc_extent_state+0x2b/0xf0 [btrfs]
 [<ffffffffa00fa8d7>] __set_extent_bit+0x357/0x590 [btrfs]
 [<ffffffffa00fab7c>] lock_extent_bits+0x6c/0xa0 [btrfs]
 [<ffffffffa00ce964>] verify_parent_transid+0x84/0x160 [btrfs]
 [<ffffffffa00cea86>] btrfs_buffer_uptodate+0x46/0x60 [btrfs]
 [<ffffffffa00b42ad>] read_block_for_search+0x14d/0x3b0 [btrfs]
 [<ffffffffa00b243d>] ? generic_bin_search+0xfd/0x180 [btrfs]
 [<ffffffffa00b9404>] btrfs_search_slot+0x2f4/0x8c0 [btrfs]
 [<ffffffffa0104425>] btrfs_read_chunk_tree+0xd5/0x700 [btrfs]
 [<ffffffffa00b2ec8>] ? btrfs_root_node+0x28/0xf0 [btrfs]
 [<ffffffffa00f7533>] ? read_extent_buffer+0xb3/0x110 [btrfs]
 [<ffffffffa00b2f2a>] ? btrfs_root_node+0x8a/0xf0 [btrfs]
 [<ffffffffa00b2ec8>] ? btrfs_root_node+0x28/0xf0 [btrfs]
 [<ffffffffa00d4ac5>] open_ctree+0x1185/0x1c00 [btrfs]
 [<ffffffffa00b215f>] btrfs_mount+0x45f/0x530 [btrfs]
 [<ffffffff8190ac69>] ? mutex_unlock+0x9/0x10
 [<ffffffff81160119>] ? pcpu_alloc+0x399/0xa00
 [<ffffffff811aa8fa>] ? alloc_vfsmnt+0x9a/0x1b0
 [<ffffffff8118fc1e>] mount_fs+0x3e/0x1a0
 [<ffffffff811aa916>] ? alloc_vfsmnt+0xb6/0x1b0
 [<ffffffff811ab6db>] vfs_kern_mount+0x5b/0xe0
 [<ffffffff811abf6d>] do_kern_mount+0x4d/0x110
 [<ffffffff813db663>] ? security_capable+0x13/0x20
 [<ffffffff811ad8fd>] do_mount+0x24d/0x7c0
 [<ffffffff8115b4e6>] ? memdup_user+0x46/0x90
 [<ffffffff8115b583>] ? strndup_user+0x53/0x70
 [<ffffffff811adefb>] sys_mount+0x8b/0xe0
 [<ffffffff81915862>] system_call_fastpath+0x16/0x1b
parent transid verify failed on 20975616 wanted 38 found 13
BUG: sleeping function called from invalid context at mm/slub.c:937
in_atomic(): 1, irqs_disabled(): 0, pid: 5955, name: mount
INFO: lockdep is turned off.
Pid: 5955, comm: mount Tainted: G        W    3.3.0+ #57
Call Trace:
 [<ffffffff810af591>] __might_sleep+0xe1/0x110
 [<ffffffff81081469>] ? vprintk+0x309/0x4d0
 [<ffffffff81188bbd>] kmem_cache_alloc+0x4d/0x160
 [<ffffffffa00f86bb>] alloc_extent_state+0x2b/0xf0 [btrfs]
 [<ffffffffa00fb3e5>] clear_extent_bit+0x255/0x430 [btrfs]
 [<ffffffffa00fbad4>] unlock_extent_cached+0x24/0x30 [btrfs]
 [<ffffffffa00ce9d3>] verify_parent_transid+0xf3/0x160 [btrfs]
 [<ffffffffa00cea86>] btrfs_buffer_uptodate+0x46/0x60 [btrfs]
 [<ffffffffa00b42ad>] read_block_for_search+0x14d/0x3b0 [btrfs]
 [<ffffffffa00b243d>] ? generic_bin_search+0xfd/0x180 [btrfs]
 [<ffffffffa00b9404>] btrfs_search_slot+0x2f4/0x8c0 [btrfs]
 [<ffffffffa0104425>] btrfs_read_chunk_tree+0xd5/0x700 [btrfs]
 [<ffffffffa00b2ec8>] ? btrfs_root_node+0x28/0xf0 [btrfs]
 [<ffffffffa00f7533>] ? read_extent_buffer+0xb3/0x110 [btrfs]
 [<ffffffffa00b2f2a>] ? btrfs_root_node+0x8a/0xf0 [btrfs]
 [<ffffffffa00b2ec8>] ? btrfs_root_node+0x28/0xf0 [btrfs]
 [<ffffffffa00d4ac5>] open_ctree+0x1185/0x1c00 [btrfs]
 [<ffffffffa00b215f>] btrfs_mount+0x45f/0x530 [btrfs]
 [<ffffffff8190ac69>] ? mutex_unlock+0x9/0x10
 [<ffffffff81160119>] ? pcpu_alloc+0x399/0xa00
 [<ffffffff811aa8fa>] ? alloc_vfsmnt+0x9a/0x1b0
 [<ffffffff8118fc1e>] mount_fs+0x3e/0x1a0
 [<ffffffff811aa916>] ? alloc_vfsmnt+0xb6/0x1b0
 [<ffffffff811ab6db>] vfs_kern_mount+0x5b/0xe0
 [<ffffffff811abf6d>] do_kern_mount+0x4d/0x110
 [<ffffffff813db663>] ? security_capable+0x13/0x20
 [<ffffffff811ad8fd>] do_mount+0x24d/0x7c0
 [<ffffffff8115b4e6>] ? memdup_user+0x46/0x90
 [<ffffffff8115b583>] ? strndup_user+0x53/0x70
 [<ffffffff811adefb>] sys_mount+0x8b/0xe0
 [<ffffffff81915862>] system_call_fastpath+0x16/0x1b
parent transid verify failed on 20975616 wanted 38 found 13
btrfs read error corrected: ino 1 off 20975616 (dev /dev/sdw sector 2056)
BUG: sleeping function called from invalid context at mm/slub.c:937
in_atomic(): 1, irqs_disabled(): 0, pid: 5955, name: mount
INFO: lockdep is turned off.
Pid: 5955, comm: mount Tainted: G        W    3.3.0+ #57
Call Trace:
 [<ffffffff810af591>] __might_sleep+0xe1/0x110
 [<ffffffff81188bbd>] kmem_cache_alloc+0x4d/0x160
 [<ffffffff81140270>] ? __lock_page+0x70/0x70
 [<ffffffffa00f86bb>] alloc_extent_state+0x2b/0xf0 [btrfs]
 [<ffffffffa00fa8d7>] __set_extent_bit+0x357/0x590 [btrfs]
 [<ffffffffa00fab7c>] lock_extent_bits+0x6c/0xa0 [btrfs]
 [<ffffffffa00ce964>] verify_parent_transid+0x84/0x160 [btrfs]
 [<ffffffffa00cea86>] btrfs_buffer_uptodate+0x46/0x60 [btrfs]
 [<ffffffffa00b42ad>] read_block_for_search+0x14d/0x3b0 [btrfs]
 [<ffffffffa00b9933>] ? btrfs_search_slot+0x823/0x8c0 [btrfs]
 [<ffffffff8190dd16>] ? _raw_spin_unlock+0x26/0x40
 [<ffffffffa00bb489>] btrfs_next_leaf+0x229/0x3e0 [btrfs]
 [<ffffffffa010432e>] ? read_one_chunk+0x2ae/0x2d0 [btrfs]
 [<ffffffffa01043e3>] btrfs_read_chunk_tree+0x93/0x700 [btrfs]
 [<ffffffffa00f7533>] ? read_extent_buffer+0xb3/0x110 [btrfs]
 [<ffffffffa00b2ec8>] ? btrfs_root_node+0x28/0xf0 [btrfs]
 [<ffffffffa00d4ac5>] open_ctree+0x1185/0x1c00 [btrfs]
 [<ffffffffa00b215f>] btrfs_mount+0x45f/0x530 [btrfs]
 [<ffffffff8190ac69>] ? mutex_unlock+0x9/0x10
 [<ffffffff81160119>] ? pcpu_alloc+0x399/0xa00
 [<ffffffff811aa8fa>] ? alloc_vfsmnt+0x9a/0x1b0
 [<ffffffff8118fc1e>] mount_fs+0x3e/0x1a0
 [<ffffffff811aa916>] ? alloc_vfsmnt+0xb6/0x1b0
 [<ffffffff811ab6db>] vfs_kern_mount+0x5b/0xe0
 [<ffffffff811abf6d>] do_kern_mount+0x4d/0x110
 [<ffffffff813db663>] ? security_capable+0x13/0x20
 [<ffffffff811ad8fd>] do_mount+0x24d/0x7c0
 [<ffffffff8115b4e6>] ? memdup_user+0x46/0x90
 [<ffffffff8115b583>] ? strndup_user+0x53/0x70
 [<ffffffff811adefb>] sys_mount+0x8b/0xe0
 [<ffffffff81915862>] system_call_fastpath+0x16/0x1b
parent transid verify failed on 20979712 wanted 38 found 10
BUG: sleeping function called from invalid context at mm/slub.c:937
in_atomic(): 1, irqs_disabled(): 0, pid: 5955, name: mount
INFO: lockdep is turned off.
Pid: 5955, comm: mount Tainted: G        W    3.3.0+ #57
Call Trace:
 [<ffffffff810af591>] __might_sleep+0xe1/0x110
 [<ffffffff81081469>] ? vprintk+0x309/0x4d0
 [<ffffffff81188bbd>] kmem_cache_alloc+0x4d/0x160
 [<ffffffffa00f86bb>] alloc_extent_state+0x2b/0xf0 [btrfs]
 [<ffffffffa00fb3e5>] clear_extent_bit+0x255/0x430 [btrfs]
 [<ffffffffa00fbad4>] unlock_extent_cached+0x24/0x30 [btrfs]
 [<ffffffffa00ce9d3>] verify_parent_transid+0xf3/0x160 [btrfs]
 [<ffffffffa00cea86>] btrfs_buffer_uptodate+0x46/0x60 [btrfs]
 [<ffffffffa00b42ad>] read_block_for_search+0x14d/0x3b0 [btrfs]
 [<ffffffffa00b9933>] ? btrfs_search_slot+0x823/0x8c0 [btrfs]
 [<ffffffff8190dd16>] ? _raw_spin_unlock+0x26/0x40
 [<ffffffffa00bb489>] btrfs_next_leaf+0x229/0x3e0 [btrfs]
 [<ffffffffa010432e>] ? read_one_chunk+0x2ae/0x2d0 [btrfs]
 [<ffffffffa01043e3>] btrfs_read_chunk_tree+0x93/0x700 [btrfs]
 [<ffffffffa00f7533>] ? read_extent_buffer+0xb3/0x110 [btrfs]
 [<ffffffffa00b2ec8>] ? btrfs_root_node+0x28/0xf0 [btrfs]
 [<ffffffffa00d4ac5>] open_ctree+0x1185/0x1c00 [btrfs]
 [<ffffffffa00b215f>] btrfs_mount+0x45f/0x530 [btrfs]
 [<ffffffff8190ac69>] ? mutex_unlock+0x9/0x10
 [<ffffffff81160119>] ? pcpu_alloc+0x399/0xa00
 [<ffffffff811aa8fa>] ? alloc_vfsmnt+0x9a/0x1b0
 [<ffffffff8118fc1e>] mount_fs+0x3e/0x1a0
 [<ffffffff811aa916>] ? alloc_vfsmnt+0xb6/0x1b0
 [<ffffffff811ab6db>] vfs_kern_mount+0x5b/0xe0
 [<ffffffff811abf6d>] do_kern_mount+0x4d/0x110
 [<ffffffff813db663>] ? security_capable+0x13/0x20
 [<ffffffff811ad8fd>] do_mount+0x24d/0x7c0
 [<ffffffff8115b4e6>] ? memdup_user+0x46/0x90
 [<ffffffff8115b583>] ? strndup_user+0x53/0x70
 [<ffffffff811adefb>] sys_mount+0x8b/0xe0
 [<ffffffff81915862>] system_call_fastpath+0x16/0x1b
parent transid verify failed on 20979712 wanted 38 found 10
btrfs read error corrected: ino 1 off 20979712 (dev /dev/sdw sector 2064)
Btrfs detected SSD devices, enabling SSD mode


chunk tree
node 20971520 level 1 items 2 free 119 generation 38 owner 3
fs uuid 7e1ea62e-7d32-4c11-bc02-1bc197be8f54
chunk uuid f59ccfe4-7257-4430-8556-f5e578464a38
        key (DEV_ITEMS DEV_ITEM 1) block 20975616 (5121) gen 38
        key (FIRST_CHUNK_TREE CHUNK_ITEM 24725422080) block 20979712
(5122) gen 38
