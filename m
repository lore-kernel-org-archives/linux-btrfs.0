From: Troy Ablan <tablan@gmail.com>
Subject: consistent oops after power fail during btrfs-vol -r
Date: Sun, 14 Mar 2010 11:09:46 -0700
Message-ID: <4B9D266A.3000105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys,

In the middle of a long btrfs-vol -r on a 15-device raid1 the machine
lost power.  I don't know if that's the cause, but I now have access to
the filesystem for only a minute or two, and am now consistently getting
this oops shortly after mount:

[ 1151.367849] btrfs memmove bogus dst_offset 536872944 move len 1110
len 4096
[ 1151.367856] ------------[ cut here ]------------
[ 1151.367908] kernel BUG at fs/btrfs/extent_io.c:3798!
[ 1151.367959] invalid opcode: 0000 [#1] SMP
[ 1151.368013] last sysfs file:
/sys/devices/virtual/block/md1/md/metadata_version
[ 1151.368108] CPU 0
[ 1151.368157] Pid: 5876, comm: btrfs-cleaner Tainted: G        W 
2.6.33-gentoo #1 P55M-GD45 (MS-7588) /MS-7588
[ 1151.368256] RIP: 0010:[<ffffffff812c7372>]  [<ffffffff812c7372>]
memmove_extent_buffer+0x262/0x290
[ 1151.368360] RSP: 0018:ffff8800a8f599b0  EFLAGS: 00010282
[ 1151.368412] RAX: 0000000000000055 RBX: 0000000000000001 RCX:
000000000003ffff
[ 1151.368467] RDX: ffff880028200000 RSI: 0000000000000086 RDI:
0000000000000000
[ 1151.368521] RBP: ffff8800a8f59a20 R08: 0000000000000000 R09:
ffffffff816b54ef
[ 1151.368575] R10: 0000000000000000 R11: 0000000000000003 R12:
0000000000000456
[ 1151.368629] R13: 0000000000000456 R14: 0000000020000033 R15:
ffff88009a8df9a0
[ 1151.368684] FS:  0000000000000000(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
[ 1151.368780] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1151.368832] CR2: 00000000020c4cd0 CR3: 00000000018df000 CR4:
00000000000006f0
[ 1151.368886] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 1151.368939] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 1151.368994] Process btrfs-cleaner (pid: 5876, threadinfo
ffff8800a8f58000, task ffff8800ad09d0c0)
[ 1151.369091] Stack:
[ 1151.369137]  ffff8800a8f59a20 ffffffff812bbba1 ffff8800a8f599d8
ffffffff00000004
[ 1151.369198] <0> ffff8800a8f59fd8 0000000000001000 0000000000000000
ffff88009ce58000
[ 1151.369305] <0> 0000000000000000 0000000000000001 0000000000000456
ffff88009a8df9a0
[ 1151.369455] Call Trace:
[ 1151.369685]  [<ffffffff812bbba1>] ? btrfs_item_offset+0xe1/0xf0
[ 1151.369742]  [<ffffffff81293311>] btrfs_del_items+0x141/0x580
[ 1151.369794]  [<ffffffff8129a20c>] ? btrfs_pin_extent+0xac/0xd0
[ 1151.369847]  [<ffffffff8129c5df>] ? pin_down_bytes+0x5f/0x190
[ 1151.369900]  [<ffffffff8129e4be>] __btrfs_free_extent+0x50e/0x7f0
[ 1151.369955]  [<ffffffff812e17d9>] ? tree_insert+0x99/0x190
[ 1151.370007]  [<ffffffff8129ec67>] run_one_delayed_ref+0x4c7/0x540
[ 1151.370060]  [<ffffffff812e230f>] ? btrfs_delayed_ref_lock+0x3f/0x120
[ 1151.370114]  [<ffffffff812a12cd>] run_clustered_refs+0xbd/0x330
[ 1151.370167]  [<ffffffff812e2878>] ? btrfs_find_ref_cluster+0xe8/0x190
[ 1151.370221]  [<ffffffff812a1606>] btrfs_run_delayed_refs+0xc6/0x1f0
[ 1151.370274]  [<ffffffff812a19bc>] btrfs_drop_snapshot+0x28c/0x600
[ 1151.370327]  [<ffffffff812ab2d2>] btrfs_clean_old_snapshots+0x122/0x150
[ 1151.370382]  [<ffffffff812a7ae0>] cleaner_kthread+0x160/0x180
[ 1151.370435]  [<ffffffff812a7980>] ? cleaner_kthread+0x0/0x180
[ 1151.370488]  [<ffffffff812a7980>] ? cleaner_kthread+0x0/0x180
[ 1151.370540]  [<ffffffff812a7980>] ? cleaner_kthread+0x0/0x180
[ 1151.370593]  [<ffffffff81096a16>] kthread+0x96/0xa0
[ 1151.370646]  [<ffffffff81034c14>] kernel_thread_helper+0x4/0x10
[ 1151.370700]  [<ffffffff816b58a9>] ? restore_args+0x0/0x30
[ 1151.370752]  [<ffffffff81096980>] ? kthread+0x0/0xa0
[ 1151.370803]  [<ffffffff81034c10>] ? kernel_thread_helper+0x0/0x10
[ 1151.370856] Code: c3 48 8b 45 b0 48 89 da 48 8d 34 07 48 03 7d b8 e8
34 ac 06 00 e9 73 ff ff ff 4c 89 ea 48 c7 c7 88 1e 82 81 31 c0 e8 4a b1
3e 00 <0f> 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 48 89 fe 4c 89 ea 48
[ 1151.371152] RIP  [<ffffffff812c7372>] memmove_extent_buffer+0x262/0x290
[ 1151.371208]  RSP <ffff8800a8f599b0>
[ 1151.371517] ---[ end trace e22acb8dc89df5cc ]---


Only once, before this, but still after the power failure, I had this
oops (older kernel):


[ 6962.309973] leaf free space ret -536870861, leaf data size 3995, used
536874856 nritems 50
[ 6962.310068] leaf free space ret -536870861, leaf data size 3995, used
536874856 nritems 50
[ 6962.310082] ------------[ cut here ]------------
[ 6962.310088] WARNING: at fs/btrfs/extent_io.c:3475
read_extent_buffer+0x178/0x1a0()
[ 6962.310089] Hardware name: MS-7588
[ 6962.310090] Modules linked in:
[ 6962.310093] Pid: 6085, comm: rsync Tainted: G        W  2.6.33-rc6 #2
[ 6962.310094] Call Trace:
[ 6962.310098]  [<ffffffff812c7408>] ? read_extent_buffer+0x178/0x1a0
[ 6962.310102]  [<ffffffff81078838>] warn_slowpath_common+0x78/0xd0
[ 6962.310104]  [<ffffffff8107889f>] warn_slowpath_null+0xf/0x20
[ 6962.310106]  [<ffffffff812c7408>] read_extent_buffer+0x178/0x1a0
[ 6962.310108]  [<ffffffff812c7512>] copy_extent_buffer+0xe2/0x190
[ 6962.310111]  [<ffffffff8128f724>] __push_leaf_right+0x404/0x8a0
[ 6962.310113]  [<ffffffff81292c09>] push_leaf_right+0x1a9/0x1b0
[ 6962.310115]  [<ffffffff812936a9>] split_leaf+0x519/0x760
[ 6962.310117]  [<ffffffff8128dca6>] ? leaf_space_used+0xd6/0x110
[ 6962.310119]  [<ffffffff8129567b>] btrfs_search_slot+0x83b/0x880
[ 6962.310121]  [<ffffffff81295d29>] btrfs_insert_empty_items+0x69/0xd0
[ 6962.310124]  [<ffffffff81120ae7>] ? kmem_cache_alloc+0xc7/0x1e0
[ 6962.310127]  [<ffffffff8129e3b8>] run_one_delayed_ref+0x1d8/0x540
[ 6962.310129]  [<ffffffff812a0d40>] ? run_clustered_refs+0xf0/0x330
[ 6962.310132]  [<ffffffff812a0d0d>] run_clustered_refs+0xbd/0x330
[ 6962.310135]  [<ffffffff812e2488>] ? btrfs_find_ref_cluster+0xe8/0x190
[ 6962.310138]  [<ffffffff812a1046>] btrfs_run_delayed_refs+0xc6/0x1f0
[ 6962.310140]  [<ffffffff812ab724>] __btrfs_end_transaction+0x64/0x170
[ 6962.310142]  [<ffffffff812ab84b>] btrfs_end_transaction+0xb/0x10
[ 6962.310145]  [<ffffffff812b3140>] btrfs_dirty_inode+0x50/0x60
[ 6962.310148]  [<ffffffff81146435>] __mark_inode_dirty+0x35/0x180
[ 6962.310151]  [<ffffffff8113b66e>] touch_atime+0x11e/0x160
[ 6962.310154]  [<ffffffff810ebdeb>] generic_file_aio_read+0x2cb/0x630
[ 6962.310157]  [<ffffffff811265b1>] do_sync_read+0xd1/0x120
[ 6962.310159]  [<ffffffff811272c8>] vfs_read+0xc8/0x1a0
[ 6962.310161]  [<ffffffff81127490>] sys_read+0x50/0x90
[ 6962.310164]  [<ffffffff81033e2b>] system_call_fastpath+0x16/0x1b
[ 6962.310166] ---[ end trace 4a71552e8b9479de ]---

One other time, it panicked (still the older kernel), and it didn't log.

Let me know if you need more information or how I can help debug.

Thanks

--Troy
