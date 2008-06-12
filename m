From: "Thomas Lindroth" <thomas.lindroth@gmail.com>
Subject: kernel BUG at volumes.c:1705
Date: Thu, 12 Jun 2008 18:07:18 +0200
Message-ID: <3d08dbff0806120907r3bfc9701g24710b56da3e10b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I'm using a recently pulled stable checkout on Gentoo i386 with kernel
2.6.24 and I get this message:

16:30:23 multivac [warning] btrfs csum failed ino 267 off 495616 csum
1766296807 private 3283918985
16:30:23 multivac [warning] btrfs csum failed ino 267 off 491520 csum
1623523565 private 3537565334
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 491520 csum
1623523565 private 3537565334
16:30:23 multivac [warning] btrfs csum failed ino 267 off 495616 csum
1766296807 private 3283918985
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:30:23 multivac [warning] btrfs csum failed ino 267 off 487424 csum
3058677931 private 870723426
16:31:27 multivac [emerg] ------------[ cut here ]------------
16:31:27 multivac [crit] kernel BUG at
/home/cocobo/btrfs_dev/kernel/volumes.c:1705!
16:31:27 multivac [emerg] invalid opcode: 0000 [#1] PREEMPT SMP
16:31:27 multivac [warning] Modules linked in: btrfs crc32c libcrc32c
aes_i586 aes_generic nvidia(P) fan k8temp gspca snd_intel8x0 button
16:31:27 multivac [warning]
16:31:27 multivac [warning] Pid: 19052, comm: ctorrent Tainted: P
  (2.6.24-dirty #9)
16:31:27 multivac [warning] EIP: 0060:[<f966bfc9>] EFLAGS: 00010246 CPU: 0
16:31:27 multivac [warning] EIP is at btrfs_num_copies+0xc9/0xd0 [btrfs]
16:31:27 multivac [warning] EAX: 00000000 EBX: f522c140 ECX: 00000000
EDX: 00000001
16:31:27 multivac [warning] ESI: f522c148 EDI: ac5e4881 EBP: 3dba8102
ESP: f20a5abc
16:31:27 multivac [warning] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
16:31:27 multivac [emerg] Process ctorrent (pid: 19052, ti=f20a4000
task=f2bb4000 task.ti=f20a4000)
16:31:27 multivac [emerg] Stack: 00001000 00000000 00000000 f1ac4bd0
00000000 fffffffb c625202c f964c325
16:31:27 multivac [emerg] 00001000 00000000 00000001 f964da70 00000000
f50b9600 f1ac4bd0 f50b9600
16:31:27 multivac [emerg] f50b9600 f1ac48c0 f964c999 00000000 00000000
29301005 1032a0a7 00001000
16:31:27 multivac [emerg] Call Trace:
16:31:27 multivac [emerg] [<f964c325>]
btree_read_extent_buffer_pages+0x95/0xb0 [btrfs]
16:31:27 multivac [emerg] [<f964da70>] btree_get_extent+0x0/0x250 [btrfs]
16:31:27 multivac [emerg] [<f964c999>] read_tree_block+0x49/0x60 [btrfs]
16:31:27 multivac [emerg] [<f963bf8f>] read_node_slot+0xdf/0xf0 [btrfs]
16:31:27 multivac [emerg] [<f9640c2f>] btrfs_search_slot+0x13f/0xec0 [btrfs]
16:31:27 multivac [emerg] [<f966ab50>] alloc_extent_buffer+0x210/0x2e0 [btrfs]
16:31:27 multivac [emerg] [<f9657945>] btrfs_get_extent+0x485/0xf30 [btrfs]
16:31:27 multivac [emerg] [<f9666521>] insert_state+0x101/0x190 [btrfs]
16:31:27 multivac [emerg] [<f964ad8e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
16:31:27 multivac [emerg] [<f9655ca2>] btrfs_readpage_io_hook+0xa2/0x150 [btrfs]
16:31:27 multivac [emerg] [<f9655c00>] btrfs_readpage_io_hook+0x0/0x150 [btrfs]
16:31:27 multivac [emerg] [<f9667829>]
__extent_read_full_page+0x439/0x7e0 [btrfs]
16:31:27 multivac [emerg] [<c012ee85>] __do_softirq+0x75/0xf0
16:31:27 multivac [emerg] [<f96574c0>] btrfs_get_extent+0x0/0xf30 [btrfs]
16:31:27 multivac [emerg] [<c04b81ca>] _write_unlock_irq+0xa/0x20
16:31:27 multivac [emerg] [<f966a8cf>] extent_readpages+0xcf/0x140 [btrfs]
16:31:27 multivac [emerg] [<c015ffa3>] __alloc_pages+0x63/0x370
16:31:27 multivac [emerg] [<f965493d>] btrfs_readpages+0x1d/0x30 [btrfs]
16:31:27 multivac [emerg] [<f96574c0>] btrfs_get_extent+0x0/0xf30 [btrfs]
16:31:27 multivac [emerg] [<f9654920>] btrfs_readpages+0x0/0x30 [btrfs]
16:31:27 multivac [emerg] [<c016237c>] __do_page_cache_readahead+0x18c/0x250
16:31:27 multivac [emerg] [<c01627bb>] page_cache_sync_readahead+0x2b/0x30
16:31:27 multivac [emerg] [<c015b0d3>] do_generic_mapping_read+0x2b3/0x460
16:31:27 multivac [emerg] [<c015a540>] file_read_actor+0x0/0x100
16:31:27 multivac [emerg] [<c015cbbe>] generic_file_aio_read+0xce/0x1c0
16:31:27 multivac [emerg] [<c015a540>] file_read_actor+0x0/0x100
16:31:27 multivac [emerg] [<c017d6e5>] do_sync_read+0xd5/0x120
16:31:27 multivac [emerg] [<c013de50>] autoremove_wake_function+0x0/0x50
16:31:27 multivac [emerg] [<c017dfe5>] vfs_read+0xb5/0x160
16:31:27 multivac [emerg] [<c017d1ec>] vfs_llseek+0x3c/0x50
16:31:27 multivac [emerg] [<c017d610>] do_sync_read+0x0/0x120
16:31:27 multivac [emerg] [<c017e521>] sys_read+0x41/0x70
16:31:27 multivac [emerg] [<c01042ee>] sysenter_past_esp+0x5f/0x85
16:31:27 multivac [emerg] =======================
16:31:27 multivac [emerg] Code: 08 e8 ac fd fe ff 89 d8 83 c4 0c 5b 5e
5f 5d c3 31 c9 eb c9 89 c8 31 d2 bb 01 00 00 00 83 e0 40 89 d1 09 c1
74 d7 8b 5e 1c eb d2 <0f> 0b eb fe 8d 76 00 55 89 c5 57 56 53 83 ec 0c
89 54 24 04 89
16:31:27 multivac [emerg] EIP: [<f966bfc9>] btrfs_num_copies+0xc9/0xd0
[btrfs] SS:ESP 0068:f20a5abc
16:31:27 multivac [warning] ---[ end trace d88035f76ac38fa5 ]---


Steps I took leading up to this message was:
Create a new FS on an ordinary block device: mkfs.btrfs /dev/sdb5
Mount it without any options: mount /dev/sdb5 /mnt/temp-test
Place a .torrent file on the FS and start download using the ctorrent
bittorrent client.
The message occurred soon after and there was plenty of space left on the FS.

The FS now appears to be in an inconsistent state.
# uname -a
Linux multivac 2.6.24-dirty #9 SMP PREEMPT Tue Jun 10 12:12:45 CEST
2008 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD
GNU/Linux
# btrfs-show
failed to read /dev/sr1
failed to read /dev/sr0
Label: none  uuid: e9558f43-b22a-4318-90d2-ed3d8454378e
        Total devices 1 FS bytes used 3.02GB
        devid    1 size 27.94GB used 8.04GB path /dev/sdb5

# btrfsck /dev/sdb5
Segmentation fault

# debug-tree /dev/sdb5
<lots of output>
leaf 60243968 ptrs 2 free space 2425 generation 217 owner 5
fs uuid e9558f43-b22a-4318-90d2-ed3d8454378e
chunk uuid 4ab6cb38-0c05-418a-83a2-65368c0e1428
        item 0 key (262 13 4034560) itemoff 3847 itemsize 148
                csum item
        item 1 key (262 13 8376320) itemoff 2475 itemsize 1372
                csum item
Segmentation fault


I got a similar message yesterday using plain 0.15 without any
hotfixes. The message occurred when I was unrar:ing files on the FS.
Both messages show crc errors but I don't think there is anything
wrong with the disk.

22:04:08 multivac [warning] btrfs csum failed ino 126244 off 14999552
csum 372251014 private 2566472073
22:04:08 multivac [warning] btrfs csum failed ino 126244 off 14999552
csum 372251014 private 2566472073
22:04:58 multivac [crit] kernel BUG at
/var/tmp/portage/sys-fs/btrfs-0.15-r1/work/btrfs-0.15/volumes.c:1705!
22:04:58 multivac [emerg] invalid opcode: 0000 [#1] PREEMPT SMP
22:04:58 multivac [warning] Modules linked in: btrfs libcrc32c
aes_i586 aes_generic nvidia(P) k8temp fan gspca button snd_intel8x0
22:04:58 multivac [warning]
22:04:58 multivac [warning] Pid: 9026, comm: unrar Tainted: P
(2.6.24-dirty #9)
22:04:58 multivac [warning] EIP: 0060:[<f962cfa9>] EFLAGS: 00210246 CPU: 1
22:04:58 multivac [warning] EIP is at btrfs_num_copies+0xc9/0x140 [btrfs]
22:04:58 multivac [warning] EAX: 00000000 EBX: ee530140 ECX: 00000000
EDX: 00000001
22:04:58 multivac [warning] ESI: ee530148 EDI: 0f1e3080 EBP: 26e012ff
ESP: f71cbad0
22:04:58 multivac [warning] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
22:04:58 multivac [emerg] Process unrar (pid: 9026, ti=f71ca000
task=c5485a90 task.ti=f71ca000)
22:04:58 multivac [emerg] Stack: 00001000 00000000 00000000 f43235b0
00000000 fffffffb f4cae02c f960d325
22:04:58 multivac [emerg] 00001000 00000000 00000001 f960ea70 00000000
f7005e00 f43235b0 f7005e00
22:04:58 multivac [emerg] f7005e00 f4323380 f960d999 00000000 00000000
6620050e 4f9f4410 00001000
22:04:58 multivac [emerg] Call Trace:
22:04:58 multivac [emerg] [<f960d325>] btrfs_csum_final+0x245/0x260 [btrfs]
22:04:58 multivac [emerg] [<f960ea70>] btree_get_extent+0x0/0x270 [btrfs]
22:04:58 multivac [emerg] [<f960d999>] read_tree_block+0x49/0x130 [btrfs]
22:04:58 multivac [emerg] [<f95fcf8f>] btrfs_release_path+0x3ef/0x400 [btrfs]
22:04:58 multivac [emerg] [<f9601c2f>] btrfs_search_slot+0x13f/0xec0 [btrfs]
22:04:58 multivac [emerg] [<c0462009>] ip_route_input+0x39/0xda0
22:04:58 multivac [emerg] [<c047e9fb>] tcp_v4_do_rcv+0xab/0x360
22:04:58 multivac [emerg] [<f9618925>] btrfs_get_extent+0x485/0x1590 [btrfs]
22:04:58 multivac [emerg] [<f9627501>]
wait_on_extent_buffer_writeback+0x2a1/0x330 [btrfs]
22:04:58 multivac [emerg] [<c0464c84>] ip_local_deliver_finish+0xc4/0x170
22:04:58 multivac [emerg] [<f960bd8e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
22:04:58 multivac [emerg] [<f9616c82>] btrfs_readpage_io_hook+0xa2/0xb90 [btrfs]
22:04:58 multivac [emerg] [<f9616be0>] btrfs_readpage_io_hook+0x0/0xb90 [btrfs]
22:04:58 multivac [emerg] [<f9628809>] unlock_extent+0x489/0x830 [btrfs]
22:04:58 multivac [emerg] [<f96184a0>] btrfs_get_extent+0x0/0x1590 [btrfs]
22:04:58 multivac [emerg] [<f962b8af>] extent_readpages+0xcf/0x140 [btrfs]
22:04:58 multivac [emerg] [<c015ffa3>] __alloc_pages+0x63/0x370
22:04:58 multivac [emerg] [<c0479edb>] tcp_send_ack+0x2b/0x100
22:04:58 multivac [emerg] [<c0426948>] __kfree_skb+0x8/0x80
22:04:58 multivac [emerg] [<f961591d>]
btrfs_readpage_end_io_hook+0x77d/0x810 [btrfs]
22:04:58 multivac [emerg] [<f96184a0>] btrfs_get_extent+0x0/0x1590 [btrfs]
22:04:58 multivac [emerg] [<f9615900>]
btrfs_readpage_end_io_hook+0x760/0x810 [btrfs]
22:04:58 multivac [emerg] [<c016237c>] __do_page_cache_readahead+0x18c/0x250
22:04:58 multivac [emerg] [<c015af86>] do_generic_mapping_read+0x166/0x460
22:04:58 multivac [emerg] [<c015a540>] file_read_actor+0x0/0x100
22:04:58 multivac [emerg] [<c015cbbe>] generic_file_aio_read+0xce/0x1c0
22:04:58 multivac [emerg] [<c015a540>] file_read_actor+0x0/0x100
22:04:58 multivac [emerg] [<c017d6e5>] do_sync_read+0xd5/0x120
22:04:58 multivac [emerg] [<c013de50>] autoremove_wake_function+0x0/0x50
22:04:58 multivac [emerg] [<c042e089>] net_tx_action+0x49/0xf0
22:04:58 multivac [emerg] [<f9a11111>] nv_kern_isr+0x51/0xb0 [nvidia]
22:04:58 multivac [emerg] [<c017dfe5>] vfs_read+0xb5/0x160
22:04:58 multivac [emerg] [<c017d610>] do_sync_read+0x0/0x120
22:04:58 multivac [emerg] [<c017e521>] sys_read+0x41/0x70
22:04:58 multivac [emerg] [<c01042ee>] sysenter_past_esp+0x5f/0x85
22:04:58 multivac [emerg] =======================
22:04:58 multivac [emerg] Code: 08 e8 ac fd fe ff 89 d8 83 c4 0c 5b 5e
5f 5d c3 31 c9 eb c9 89 c8 31 d2 bb 01 00 00 00 83 e0 40 89 d1 09 c1
74 d7 8b 5e 1c eb d2 <0f> 0b eb fe 8d 76 00 55 89 c5 57 56 53 83 ec 0c
89 54 24 04 89
22:04:58 multivac [emerg] EIP: [<f962cfa9>]
btrfs_num_copies+0xc9/0x140 [btrfs] SS:ESP 0068:f71cbad0
22:04:58 multivac [warning] ---[ end trace 8259e45f08f9ee51 ]---
