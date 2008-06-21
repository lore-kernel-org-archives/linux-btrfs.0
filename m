From: Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: Re: kernel BUG at volumes.c:1705
Date: Sat, 21 Jun 2008 11:35:37 +0200
Message-ID: <485CCB69.8050500@gmail.com>
References: <3d08dbff0806120907r3bfc9701g24710b56da3e10b7@mail.gmail.com>	 <1213320815.10187.336.camel@think.oraclecorp.com>	 <3d08dbff0806140222w677896e3s4835524e3d796794@mail.gmail.com>	 <1213618813.10187.387.camel@think.oraclecorp.com>	 <3d08dbff0806180158o6718d3acy34ae5c48a23ad9f8@mail.gmail.com> <1213792851.10187.420.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1213792851.10187.420.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> So, is the bittorrent program run every time you see the memory
> corruption?
> 
> Could you please send along a few of the most common errors you see?


It's possible to recreate it with mv, cp and other tools without having
the torrent program running.

I've found a way to trigger the problem every time. If I copy a folder
with music videos to a freshly created FS it will always fail on the
same file when about 5.6G of data has been copied. The FS is 30G and
there is nothing special with that file. If I only copy that file to a
fresh FS everything works. I've also tried to run
dd if=/dev/zero of=test to a fresh FS and I was able to write 15G, but I
was not able to remove that file.


cocobo@multivac /mnt/temp-test $ dd if=/dev/zero of=test bs=16384
930632+0 records in
930632+0 records out
15247474688 bytes (15 GB) copied, 374.052 s, 40.8 MB/s

cocobo@multivac /mnt/temp-test $ echo sdlfkj > sdlfkj
cocobo@multivac /mnt/temp-test $ echo sdlfkj > sdlfkjdf
cocobo@multivac /mnt/temp-test $ echo sdlfkj > sdlfkjdfer
cocobo@multivac /mnt/temp-test $ d
sdlfkj  sdlfkjdf  sdlfkjdfer  test
cocobo@multivac /mnt/temp-test $ rm *
Segmentation fault

Resulting backtrace:

[crit] kernel BUG at /home/cocobo/btrfs_dev/kernel/inode.c:962!
[emerg] invalid opcode: 0000 [#1] PREEMPT SMP
[warning] Modules linked in: btrfs crc32c libcrc32c aes_i586 aes_generic nvidia(P) fan k8temp button snd_intel8x0
[warning]
[warning] Pid: 7187, comm: rm Tainted: P        (2.6.24-dirty #9)
[warning] EIP: 0060:[<f95b2b45>] EFLAGS: 00210246 CPU: 1
[warning] EIP is at btrfs_truncate_in_trans+0x725/0x7d0 [btrfs]
[warning] EAX: 00000000 EBX: 00000001 ECX: e18acd80 EDX: e18acd80
[warning] ESI: 00000001 EDI: 00000001 EBP: 00000002 ESP: f5b2be58
[warning] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[emerg] Process rm (pid: 7187, ti=f5b2a000 task=f5939540 task.ti=f5b2a000)
[emerg] Stack: e18acd80 ffffffff 00000001 f5b2becc c015cd0a 0000000e e18cd36c 00000000
[emerg] f5b2bec4 00000000 e18cd35c c0163102 f5b2becc 3be54000 00000002 e18cd2ac
[emerg] f58cd200 e1a02c80 e18acd80 00000013 f5c4bb60 00000000 00000000 00000000
[emerg] Call Trace:
[emerg] [<c015cd0a>] find_get_pages+0x5a/0x70
[emerg] [<c0163102>] pagevec_lookup+0x22/0x30
[emerg] [<f95b634f>] btrfs_delete_inode+0x7f/0x120 [btrfs]
[emerg] [<f95b62d0>] btrfs_delete_inode+0x0/0x120 [btrfs]
[emerg] [<c0191265>] generic_delete_inode+0x65/0xd0
[emerg] [<c0190a3c>] iput+0x5c/0x70
[emerg] [<c0187b4f>] do_unlinkat+0xef/0x150
[emerg] [<c01042ee>] sysenter_past_esp+0x5f/0x85
[emerg] =======================
[emerg] Code: 74 29 8b 4c 24 48 48 89 41 20 e9 16 fa ff ff 8b 7c 24 78 85 ff 0f 85 3c fb ff ff 8b 44 24 40 89 f2 e8 60 a0 fe ff e9 be f9 ff ff <0f> 0b eb fe 0f 0b eb fe 29 f8 8b 4c 24 34 8b 5c 24 38 89 84 24
[emerg] EIP: [<f95b2b45>] btrfs_truncate_in_trans+0x725/0x7d0 [btrfs] SS:ESP 0068:f5b2be58
[warning] ---[ end trace e9838122963995d9 ]---


When I copy music videos I get a backtrace like this:

[warning] bad mapping eb start 29790208 len 4096, wanted 3655755309 4
[warning] WARNING: at /home/cocobo/btrfs_dev/kernel/extent_io.c:3225 map_private_extent_buffer()
[warning] Pid: 8230, comm: cp Tainted: P        2.6.24-dirty #9
[warning] [<f95c1b16>] map_private_extent_buffer+0x126/0x170 [btrfs]
[warning] [<f95ba10d>] btrfs_item_offset+0x5d/0xe0 [btrfs]
[warning] [<f9599436>] leaf_space_used+0x96/0xe0 [btrfs]
[warning] [<f95994c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[warning] [<f959ac6a>] push_leaf_right+0x8a/0x650 [btrfs]
[warning] [<c013dea0>] wake_bit_function+0x0/0x60
[warning] [<f95c28a2>] add_lru+0x82/0x90 [btrfs]
[warning] [<f95c1a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[warning] [<f95a915d>] verify_parent_transid+0x6d/0x1a0 [btrfs]
[warning] [<f95c7b50>] alloc_extent_buffer+0x210/0x2e0 [btrfs]
[warning] [<f959b694>] split_leaf+0x84/0x940 [btrfs]
[warning] [<f9599436>] leaf_space_used+0x96/0xe0 [btrfs]
[warning] [<f95994c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[warning] [<f959e5f4>] btrfs_search_slot+0xb04/0xec0 [btrfs]
[warning] [<f95c1a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[warning] [<f95c3320>] tree_insert+0x60/0x90 [btrfs]
[warning] [<f9599436>] leaf_space_used+0x96/0xe0 [btrfs]
[warning] [<f95c2a19>] merge_state+0xb9/0x110 [btrfs]
[warning] [<f95c3a24>] set_extent_bit+0x3f4/0x460 [btrfs]
[warning] [<f959ea2d>] btrfs_insert_empty_items+0x7d/0x420 [btrfs]
[warning] [<f95c1a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[warning] [<f95c3dbf>] set_extent_dirty+0x3f/0x50 [btrfs]
[warning] [<f95a73d3>] insert_with_overflow+0x33/0x130 [btrfs]
[warning] [<f95a7982>] btrfs_insert_dir_item+0x172/0x240 [btrfs]
[warning] [<f95afb77>] btrfs_add_link+0x87/0x120 [btrfs]
[warning] [<f95afc31>] btrfs_add_nondir+0x21/0x50 [btrfs]
[warning] [<f95b57e8>] btrfs_create+0x1c8/0x2b0 [btrfs]
[warning] [<c018626a>] vfs_create+0xaa/0xf0
[warning] [<c01888f9>] open_namei+0x559/0x5d0
[warning] [<c017bdfe>] do_filp_open+0x2e/0x60
[warning] [<c017bae0>] get_unused_fd_flags+0xb0/0xd0
[warning] [<c017be7c>] do_sys_open+0x4c/0xf0
[warning] [<c017bf5c>] sys_open+0x1c/0x20
[warning] [<c01042ee>] sysenter_past_esp+0x5f/0x85
[warning] =======================
[alert] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[alert] printing eip: c0120e51 *pde = 00000000
[emerg] Oops: 0000 [#1] PREEMPT SMP
[warning] Modules linked in: btrfs crc32c libcrc32c aes_i586 aes_generic nvidia(P) k8temp fan button snd_intel8x0
[warning]
[warning] Pid: 8230, comm: cp Tainted: P        (2.6.24-dirty #9)
[warning] EIP: 0060:[<c0120e51>] EFLAGS: 00210202 CPU: 1
[warning] EIP is at kmap_atomic_prot+0x11/0xa0
[warning] EAX: f340c000 EBX: 00000000 ECX: 00000163 EDX: 00000004
[warning] ESI: 00000000 EDI: 00000163 EBP: f7822c78 ESP: f340da84
[warning] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[emerg] Process cp (pid: 8230, ti=f340c000 task=f75cc550 task.ti=f340c000)
[emerg] Stack: f3302154 00000000 f3302144 f95c1a7e f95cf135 f95ce938 00000c99 f95cdab9
[emerg] d9e6662d 00000004 00000000 00001000 d9e6661c f7822c78 d9e6662d 00000000
[emerg] f95ba10d f340daec f340dae8 f340dae4 f340dae0 00000004 92109210 00001000
[emerg] Call Trace:
[emerg] [<f95c1a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[emerg] [<f95ba10d>] btrfs_item_offset+0x5d/0xe0 [btrfs]
[emerg] [<f9599436>] leaf_space_used+0x96/0xe0 [btrfs]
[emerg] [<f95994c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[emerg] [<f959ac6a>] push_leaf_right+0x8a/0x650 [btrfs]
[emerg] [<c013dea0>] wake_bit_function+0x0/0x60
[emerg] [<f95c28a2>] add_lru+0x82/0x90 [btrfs]
[emerg] [<f95c1a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[emerg] [<f95a915d>] verify_parent_transid+0x6d/0x1a0 [btrfs]
[emerg] [<f95c7b50>] alloc_extent_buffer+0x210/0x2e0 [btrfs]
[emerg] [<f959b694>] split_leaf+0x84/0x940 [btrfs]
[emerg] [<f9599436>] leaf_space_used+0x96/0xe0 [btrfs]
[emerg] [<f95994c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[emerg] [<f959e5f4>] btrfs_search_slot+0xb04/0xec0 [btrfs]
[emerg] [<f95c1a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[emerg] [<f95c3320>] tree_insert+0x60/0x90 [btrfs]
[emerg] [<f9599436>] leaf_space_used+0x96/0xe0 [btrfs]
[emerg] [<f95c2a19>] merge_state+0xb9/0x110 [btrfs]
[emerg] [<f95c3a24>] set_extent_bit+0x3f4/0x460 [btrfs]
[emerg] [<f959ea2d>] btrfs_insert_empty_items+0x7d/0x420 [btrfs]
[emerg] [<f95c1a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[emerg] [<f95c3dbf>] set_extent_dirty+0x3f/0x50 [btrfs]
[emerg] [<f95a73d3>] insert_with_overflow+0x33/0x130 [btrfs]
[emerg] [<f95a7982>] btrfs_insert_dir_item+0x172/0x240 [btrfs]
[emerg] [<f95afb77>] btrfs_add_link+0x87/0x120 [btrfs]
[emerg] [<f95afc31>] btrfs_add_nondir+0x21/0x50 [btrfs]
[emerg] [<f95b57e8>] btrfs_create+0x1c8/0x2b0 [btrfs]
[emerg] [<c018626a>] vfs_create+0xaa/0xf0
[emerg] [<c01888f9>] open_namei+0x559/0x5d0
[emerg] [<c017bdfe>] do_filp_open+0x2e/0x60
[emerg] [<c017bae0>] get_unused_fd_flags+0xb0/0xd0
[emerg] [<c017be7c>] do_sys_open+0x4c/0xf0
[emerg] [<c017bf5c>] sys_open+0x1c/0x20
[emerg] [<c01042ee>] sysenter_past_esp+0x5f/0x85
[emerg] =======================
[emerg] Code: 0c c1 e0 05 03 05 80 6e 64 c0 c3 0f 0b eb fe 8d 74 26 00 8d bc 27 00 00 00 00 57 89 cf 56 53 89 c3 89 e0 25 00 e0 ff ff ff 40 14 <8b> 03 c1 e8 1e 69 c0 80 03 00 00 05 80 a0 5a c0 2b 80 4c 03 00
[emerg] EIP: [<c0120e51>] kmap_atomic_prot+0x11/0xa0 SS:ESP 0068:f340da84
[warning] ---[ end trace e9be59e282d09030 ]---


Some more. Don't know what triggers these.

[warning] btrfs csum failed ino 270 off 13099008 csum 2441591740 private 3195497598
[warning] btrfs csum failed ino 270 off 13099008 csum 2441591740 private 3195497598
[warning] btrfs csum failed ino 265 off 6197248 csum 2251659755 private 2851584110
[warning] btrfs csum failed ino 265 off 6197248 csum 2251659755 private 2851584110
[warning] bad mapping eb start 35897344 len 4096, wanted 2860057669 4
[warning] WARNING: at /home/cocobo/btrfs_dev/kernel/extent_io.c:3225 map_private_extent_buffer()
[warning] Pid: 7388, comm: btrfs-async-sub Tainted: P        2.6.24-dirty #9
[warning] [<f9663b16>] map_private_extent_buffer+0x126/0x170 [btrfs]
[warning] [<f965c10d>] btrfs_item_offset+0x5d/0xe0 [btrfs]
[warning] [<f963b436>] leaf_space_used+0x96/0xe0 [btrfs]
[warning] [<f963b4c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[warning] [<f963cc6a>] push_leaf_right+0x8a/0x650 [btrfs]
[warning] [<f9665dbf>] set_extent_dirty+0x3f/0x50 [btrfs]
[warning] [<f9663a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[warning] [<f964b15d>] verify_parent_transid+0x6d/0x1a0 [btrfs]
[warning] [<f9669b50>] alloc_extent_buffer+0x210/0x2e0 [btrfs]
[warning] [<f963d694>] split_leaf+0x84/0x940 [btrfs]
[warning] [<f963b436>] leaf_space_used+0x96/0xe0 [btrfs]
[warning] [<f963b4c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[warning] [<f96405f4>] btrfs_search_slot+0xb04/0xec0 [btrfs]
[warning] [<c02d663a>] cfq_insert_request+0x2a/0x380
[warning] [<f9663a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[warning] [<f965c0a0>] btrfs_item_size+0xd0/0xe0 [btrfs]
[warning] [<f9640a2d>] btrfs_insert_empty_items+0x7d/0x420 [btrfs]
[warning] [<f965c0a0>] btrfs_item_size+0xd0/0xe0 [btrfs]
[warning] [<f964a5c9>] btrfs_csum_file_blocks+0x4a9/0x750 [btrfs]
[warning] [<f966be64>] btrfs_map_bio+0x134/0x220 [btrfs]
[warning] [<f9653cca>] __btrfs_submit_bio_hook+0x7a/0xd0 [btrfs]
[warning] [<f964b8b0>] btrfs_async_submit_work+0x60/0x90 [btrfs]
[warning] [<f964b850>] btrfs_async_submit_work+0x0/0x90 [btrfs]
[warning] [<c013a039>] run_workqueue+0x79/0x100
[warning] [<c013aa60>] worker_thread+0x0/0x100
[warning] [<c013ab04>] worker_thread+0xa4/0x100
[warning] [<c013de50>] autoremove_wake_function+0x0/0x50
[warning] [<c013aa60>] worker_thread+0x0/0x100
[warning] [<c013db82>] kthread+0x42/0x70
[warning] [<c013db40>] kthread+0x0/0x70
[warning] [<c0104f0f>] kernel_thread_helper+0x7/0x18
[warning] =======================
[alert] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[alert] printing eip: c0120e51 *pde = 00000000
[emerg] Oops: 0000 [#1] PREEMPT SMP
[warning] Modules linked in: btrfs crc32c libcrc32c aes_i586 aes_generic nvidia(P) fan gspca button k8temp snd_intel8x0
[warning]
[warning] Pid: 7388, comm: btrfs-async-sub Tainted: P        (2.6.24-dirty #9)
[warning] EIP: 0060:[<c0120e51>] EFLAGS: 00010202 CPU: 0
[warning] EIP is at kmap_atomic_prot+0x11/0xa0
[warning] EAX: f512e000 EBX: 00000000 ECX: 00000163 EDX: 00000004
[warning] ESI: 00000000 EDI: 00000163 EBP: e53ad380 ESP: f512fb68
[warning] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[emerg] Process btrfs-async-sub (pid: 7388, ti=f512e000 task=f6adcff0 task.ti=f512e000)
[emerg] Stack: f3d53154 00000000 f3d53144 f9663a7e f9671135 f9670938 00000c99 f966fab9
[emerg] aa790445 00000004 00000000 00001000 aa790434 e53ad380 aa790445 00000000
[emerg] f965c10d f512fbd0 f512fbcc f512fbc8 f512fbc4 00000004 de91d27e 00001000
[emerg] Call Trace:
[emerg] [<f9663a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[emerg] [<f965c10d>] btrfs_item_offset+0x5d/0xe0 [btrfs]
[emerg] [<f963b436>] leaf_space_used+0x96/0xe0 [btrfs]
[emerg] [<f963b4c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[emerg] [<f963cc6a>] push_leaf_right+0x8a/0x650 [btrfs]
[emerg] [<f9665dbf>] set_extent_dirty+0x3f/0x50 [btrfs]
[emerg] [<f9663a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[emerg] [<f964b15d>] verify_parent_transid+0x6d/0x1a0 [btrfs]
[emerg] [<f9669b50>] alloc_extent_buffer+0x210/0x2e0 [btrfs]
[emerg] [<f963d694>] split_leaf+0x84/0x940 [btrfs]
[emerg] [<f963b436>] leaf_space_used+0x96/0xe0 [btrfs]
[emerg] [<f963b4c2>] btrfs_leaf_free_space+0x42/0xa0 [btrfs]
[emerg] [<f96405f4>] btrfs_search_slot+0xb04/0xec0 [btrfs]
[emerg] [<c02d663a>] cfq_insert_request+0x2a/0x380
[emerg] [<f9663a7e>] map_private_extent_buffer+0x8e/0x170 [btrfs]
[emerg] [<f965c0a0>] btrfs_item_size+0xd0/0xe0 [btrfs]
[emerg] [<f9640a2d>] btrfs_insert_empty_items+0x7d/0x420 [btrfs]
[emerg] [<f965c0a0>] btrfs_item_size+0xd0/0xe0 [btrfs]
[emerg] [<f964a5c9>] btrfs_csum_file_blocks+0x4a9/0x750 [btrfs]
[emerg] [<f966be64>] btrfs_map_bio+0x134/0x220 [btrfs]
[emerg] [<f9653cca>] __btrfs_submit_bio_hook+0x7a/0xd0 [btrfs]
[emerg] [<f964b8b0>] btrfs_async_submit_work+0x60/0x90 [btrfs]
[emerg] [<f964b850>] btrfs_async_submit_work+0x0/0x90 [btrfs]
[emerg] [<c013a039>] run_workqueue+0x79/0x100
[emerg] [<c013aa60>] worker_thread+0x0/0x100
[emerg] [<c013ab04>] worker_thread+0xa4/0x100
[emerg] [<c013de50>] autoremove_wake_function+0x0/0x50
[emerg] [<c013aa60>] worker_thread+0x0/0x100
[emerg] [<c013db82>] kthread+0x42/0x70
[emerg] [<c013db40>] kthread+0x0/0x70
[emerg] [<c0104f0f>] kernel_thread_helper+0x7/0x18
[emerg] =======================
[emerg] Code: 0c c1 e0 05 03 05 80 6e 64 c0 c3 0f 0b eb fe 8d 74 26 00 8d bc 27 00 00 00 00 57 89 cf 56 53 89 c3 89 e0 25 00 e0 ff ff ff 40 14 <8b> 03 c1 e8 1e 69 c0 80 03 00 00 05 80 a0 5a c0 2b 80 4c 03 00
[emerg] EIP: [<c0120e51>] kmap_atomic_prot+0x11/0xa0 SS:ESP 0068:f512fb68
[warning] ---[ end trace 3b8b8f59b04f8cf6 ]---


[warning] WARNING: at /home/cocobo/btrfs_dev/kernel/extent-tree.c:2168 walk_down_tree()
[warning] Pid: 18352, comm: btrfs-transacti Tainted: P        2.6.24-dirty #9
[warning] [<f960eda1>] walk_down_tree+0x621/0x740 [btrfs]
[warning] [<f962ad18>] read_extent_buffer+0xb8/0x190 [btrfs]
[warning] [<f9622502>] btrfs_node_key+0x62/0x90 [btrfs]
[warning] [<f960ef4e>] btrfs_drop_snapshot+0x8e/0x1c0 [btrfs]
[warning] [<f96162ca>] drop_dirty_roots+0xea/0x200 [btrfs]
[warning] [<f9929000>] _nv006851rm+0xb4c/0x2674 [nvidia]
[warning] [<f9616da0>] btrfs_transaction_cleaner+0x0/0xe0 [btrfs]
[warning] [<f9616450>] btrfs_clean_old_snapshots+0x70/0x90 [btrfs]
[warning] [<f9616de4>] btrfs_transaction_cleaner+0x44/0xe0 [btrfs]
[warning] [<c013a039>] run_workqueue+0x79/0x100
[warning] [<c013aa60>] worker_thread+0x0/0x100
[warning] [<c013ab04>] worker_thread+0xa4/0x100
[warning] [<c013de50>] autoremove_wake_function+0x0/0x50
[warning] [<c013aa60>] worker_thread+0x0/0x100
[warning] [<c013db82>] kthread+0x42/0x70
[warning] [<c013db40>] kthread+0x0/0x70
[warning] [<c0104f0f>] kernel_thread_helper+0x7/0x18
[warning] =======================
[alert] BUG: unable to handle kernel paging request at virtual address 01b3401b
[alert] printing eip: f960e9a2 *pde = 00000000
[emerg] Oops: 0000 [#1] PREEMPT SMP
[warning] Modules linked in: btrfs crc32c libcrc32c aes_i586 aes_generic nvidia(P) fan k8temp gspca button snd_intel8x0
[warning]
[warning] Pid: 18352, comm: btrfs-transacti Tainted: P        (2.6.24-dirty #9)
[warning] EIP: 0060:[<f960e9a2>] EFLAGS: 00010286 CPU: 1
[warning] EIP is at walk_down_tree+0x222/0x740 [btrfs]
[warning] EAX: 000000da EBX: 000000da ECX: f2bb7f14 EDX: 00000003
[warning] ESI: 00000003 EDI: 01b33fff EBP: c5b2a888 ESP: f2bb7e58
[warning] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[emerg] Process btrfs-transacti (pid: 18352, ti=f2bb6000 task=f4bccff0 task.ti=f2bb6000)
[emerg] Stack: f9637d7f f9636d88 00000878 f96366b4 f2bb7eb8 f591102c 00000011 c1a1c000
[emerg] 00000011 f962ad18 00000d93 c2614154 f7765720 c58eb3a8 f2b20800 f1e5b118
[emerg] 00001000 00000000 02952000 00000000 00000026 00000000 00000000 f9622502
[emerg] Call Trace:
[emerg] [<f962ad18>] read_extent_buffer+0xb8/0x190 [btrfs]
[emerg] [<f9622502>] btrfs_node_key+0x62/0x90 [btrfs]
[emerg] [<f960ef4e>] btrfs_drop_snapshot+0x8e/0x1c0 [btrfs]
[emerg] [<f96162ca>] drop_dirty_roots+0xea/0x200 [btrfs]
[emerg] [<f9929000>] _nv006851rm+0xb4c/0x2674 [nvidia]
[emerg] [<f9616da0>] btrfs_transaction_cleaner+0x0/0xe0 [btrfs]
[emerg] [<f9616450>] btrfs_clean_old_snapshots+0x70/0x90 [btrfs]
[emerg] [<f9616de4>] btrfs_transaction_cleaner+0x44/0xe0 [btrfs]
[emerg] [<c013a039>] run_workqueue+0x79/0x100
[emerg] [<c013aa60>] worker_thread+0x0/0x100
[emerg] [<c013ab04>] worker_thread+0xa4/0x100
[emerg] [<c013de50>] autoremove_wake_function+0x0/0x50
[emerg] [<c013aa60>] worker_thread+0x0/0x100
[emerg] [<c013db82>] kthread+0x42/0x70
[emerg] [<c013db40>] kthread+0x0/0x70
[emerg] [<c0104f0f>] kernel_thread_helper+0x7/0x18
[emerg] =======================
[emerg] Code: c7 44 9a 20 00 00 00 00 8b 4c 24 78 8b 01 85 c0 0f 88 71 fe ff ff 83 f8 07 0f 8f e2 03 00 00 8b 54 24 34 8b 3c 82 ba 03 00 00 00 <8b> 47 1c e8 36 25 b1 c6 ba 03 00 00 00 0f b6 58 64 e8 98 25 b1
[emerg] EIP: [<f960e9a2>] walk_down_tree+0x222/0x740 [btrfs] SS:ESP 0068:f2bb7e58
[warning] ---[ end trace ef2a94b0c406c581 ]---

