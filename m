Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:26509 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2HHQS0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2012 12:18:26 -0400
Received: from 67.155.79.188.dynamic.jazztel.es ([188.79.155.67] helo=mail.viric.name)
	by mho-01-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1Sz8xk-000Fo0-Vy
	for linux-btrfs@vger.kernel.org; Wed, 08 Aug 2012 16:18:25 +0000
Date: Wed, 8 Aug 2012 18:18:19 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: linux-btrfs@vger.kernel.org
Subject: BUG on 3.5.0
Message-ID: <20120808161819.GO25996@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I was running "btrfs fi balance start -dusage=3D5 -musage=3D5 -v /" on 3.=
5.0, and
soon these BUG happened. Then some fs syscalls started to block (in mutt,=
 find,
...), and after a while the computer (remote) stopped responding by ssh. =
After
rebooting, the balance continued fine.

I attach dmesg.txt, and the disasm of insert_inline_extent_backref. That =
disasm
was a bit tricky; my objdump does not seem to understand the btrfs.ko.

binutils 2.21.1a objdump fails: file format not known
binutils 2.22 objdump fails: bad value
elfutils objdump works, but does not understand symbols. Full text disasm=
.
binutils readelf works.

I took the address reported by binutils readelf, and seeked using the elf=
utils
objdump.

If anyone wants to test, here is the module: http://viric.name/tmp/btrfs.=
ko.bz2

The module is built with "-gdwarf-4". Maybe that breaks objdump.

(I'm not subscribed, please keep me in Cc)

Regards,
Llu=EDs.

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[ 6028.939987] btrfs: relocating block group 1865234710528 flags 1
[ 6029.884302] btrfs: relocating block group 1858758705152 flags 34
[ 6030.795552] btrfs: relocating block group 1858188279808 flags 34
[ 6031.739371] btrfs: found 19 extents
[ 6036.330016] btrfs: relocating block group 1846913990656 flags 1
[ 6037.569550] btrfs: relocating block group 1845840248832 flags 1
[ 6038.408472] btrfs: relocating block group 1844766507008 flags 1
[ 6039.104224] btrfs: relocating block group 1843692765184 flags 1
[ 6039.766903] btrfs: relocating block group 1842619023360 flags 1
[ 6040.378908] btrfs: relocating block group 1841545281536 flags 1
[ 6041.016713] btrfs: relocating block group 1840471539712 flags 1
[ 6041.579970] btrfs: relocating block group 1839397797888 flags 1
[ 6042.160679] btrfs: relocating block group 1838324056064 flags 1
[ 6042.681609] btrfs: relocating block group 1837250314240 flags 1
[ 6043.195152] btrfs: relocating block group 1836176572416 flags 1
[ 6043.700403] btrfs: relocating block group 1835102830592 flags 1
[ 6044.155997] btrfs: relocating block group 1834029088768 flags 1
[ 6044.628112] btrfs: relocating block group 1832955346944 flags 1
[ 6045.083705] btrfs: relocating block group 1831881605120 flags 1
[ 6045.523621] btrfs: relocating block group 1830807863296 flags 1
[ 6045.978303] btrfs: relocating block group 1829734121472 flags 1
[ 6046.418165] btrfs: relocating block group 1828660379648 flags 1
[ 6046.872849] btrfs: relocating block group 1827586637824 flags 1
[ 6047.321025] btrfs: relocating block group 1826512896000 flags 1
[ 6047.767425] btrfs: relocating block group 1825439154176 flags 1
[ 6048.189837] btrfs: relocating block group 1824365412352 flags 1
[ 6048.629767] btrfs: relocating block group 1823291670528 flags 1
[ 6049.093674] btrfs: relocating block group 1822217928704 flags 1
[ 6049.706610] btrfs: relocating block group 1821144186880 flags 1
[ 6050.260649] btrfs: relocating block group 1820070445056 flags 1
[ 6050.808242] btrfs: relocating block group 1818996703232 flags 1
[ 6051.390665] btrfs: relocating block group 1817922961408 flags 1
[ 6051.992743] btrfs: relocating block group 1816849219584 flags 1
[ 6052.521956] btrfs: relocating block group 1815775477760 flags 1
[ 6053.027229] btrfs: relocating block group 1814701735936 flags 1
[ 6053.491043] btrfs: relocating block group 1813627994112 flags 1
[ 6053.954917] btrfs: relocating block group 1812554252288 flags 1
[ 6054.403221] btrfs: relocating block group 1811480510464 flags 1
[ 6054.849504] btrfs: relocating block group 1810406768640 flags 1
[ 6055.305949] btrfs: relocating block group 1809333026816 flags 1
[ 6055.760619] btrfs: relocating block group 1808259284992 flags 1
[ 6056.217121] btrfs: relocating block group 1807185543168 flags 1
[ 6056.638654] btrfs: relocating block group 1806111801344 flags 1
[ 6057.061087] btrfs: relocating block group 1805038059520 flags 1
[ 6057.451277] btrfs: relocating block group 1803964317696 flags 1
[ 6057.882001] btrfs: relocating block group 1802890575872 flags 1
[ 6058.337578] btrfs: relocating block group 1801816834048 flags 1
[ 6059.622095] btrfs: relocating block group 1800743092224 flags 1
[ 6060.168191] btrfs: relocating block group 1799669350400 flags 1
[ 6060.763637] btrfs: relocating block group 1798595608576 flags 1
[ 6061.326879] btrfs: relocating block group 1797521866752 flags 1
[ 6061.841349] btrfs: relocating block group 1796448124928 flags 1
[ 6062.378827] btrfs: relocating block group 1795374383104 flags 1
[ 6062.908965] btrfs: relocating block group 1794300641280 flags 1
[ 6063.439117] btrfs: relocating block group 1793226899456 flags 1
[ 6063.911174] btrfs: relocating block group 1792153157632 flags 1
[ 6064.384224] btrfs: relocating block group 1791079415808 flags 1
[ 6064.831564] btrfs: relocating block group 1790005673984 flags 1
[ 6067.322718] btrfs: relocating block group 1788931932160 flags 1
[ 6068.160475] btrfs: relocating block group 1787858190336 flags 1
[ 6068.790126] btrfs: relocating block group 1786784448512 flags 1
[ 6069.245515] btrfs: relocating block group 1785710706688 flags 1
[ 6069.709412] btrfs: relocating block group 1784636964864 flags 1
[ 6070.131847] btrfs: relocating block group 1783563223040 flags 1
[ 6070.529418] btrfs: relocating block group 1782489481216 flags 1
[ 6070.902138] btrfs: relocating block group 1781415739392 flags 1
[ 6071.259242] btrfs: relocating block group 1780341997568 flags 1
[ 6071.573979] btrfs: relocating block group 1779268255744 flags 1
[ 6071.938429] btrfs: relocating block group 1778194513920 flags 1
[ 6072.318528] btrfs: relocating block group 1777120772096 flags 1
[ 6072.708719] btrfs: relocating block group 1776047030272 flags 1
[ 6073.097141] btrfs: relocating block group 1774973288448 flags 1
[ 6073.469868] btrfs: relocating block group 1773899546624 flags 1
[ 6073.851030] btrfs: relocating block group 1772825804800 flags 1
[ 6074.198811] btrfs: relocating block group 1771752062976 flags 1
[ 6074.588148] btrfs: relocating block group 1770678321152 flags 1
[ 6074.936884] btrfs: relocating block group 1769604579328 flags 1
[ 6075.425844] btrfs: relocating block group 1768530837504 flags 1
[ 6075.896877] btrfs: relocating block group 1767457095680 flags 1
[ 6076.287084] btrfs: relocating block group 1766383353856 flags 1
[ 6076.643235] btrfs: relocating block group 1765309612032 flags 1
[ 6077.023349] btrfs: relocating block group 1764235870208 flags 1
[ 6077.488119] btrfs: relocating block group 1763162128384 flags 1
[ 6077.884886] btrfs: relocating block group 1762088386560 flags 1
[ 6078.763529] btrfs: found 56 extents
[ 6081.795363] btrfs: found 56 extents
[ 6082.958384] btrfs: relocating block group 1759940902912 flags 1
[ 6085.273142] btrfs: found 130 extents
[ 6090.509051] btrfs: found 130 extents
[ 6091.543439] btrfs: relocating block group 1754572193792 flags 1
[ 6093.117189] btrfs: found 121 extents
[ 6095.255745] ------------[ cut here ]------------
[ 6095.255757] kernel BUG at fs/btrfs/extent-tree.c:1769!
[ 6095.255762] invalid opcode: 0000 [#1] SMP 
[ 6095.255769] CPU 1 
[ 6095.255772] Modules linked in:<4>[ 6095.255897]  jbd ext2 mbcache
[ 6095.255904] 
[ 6095.255910] Pid: 30286, comm: btrfs Tainted: P           O 3.5.0 #1 System manufacturer System Product Name/M4A79 Deluxe
[ 6095.255920] RIP: 0010:[<ffffffffa0191c9f>]  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
[ 6095.255965] RSP: 0018:ffff880028723788  EFLAGS: 00010293
[ 6095.255970] RAX: 0000000000000000 RBX: ffff8801275b3510 RCX: ffff8800287237d0
[ 6095.255974] RDX: ffff8801275b3510 RSI: 0000000000000001 RDI: 0000000000000000
[ 6095.255978] RBP: ffff880028723808 R08: 0000000000000bf2 R09: ffff880028723698
[ 6095.255981] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880126918800
[ 6095.255985] R13: ffff88012afdd280 R14: 0000000000000000 R15: 0000000000000001
[ 6095.255990] FS:  00007fbdb0dbc740(0000) GS:ffff88012fc40000(0000) knlGS:0000000000000000
[ 6095.255994] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6095.255998] CR2: 00000000006b3c60 CR3: 000000005e5df000 CR4: 00000000000007e0
[ 6095.256002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6095.256006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6095.256011] Process btrfs (pid: 30286, threadinfo ffff880028722000, task ffff880080194440)
[ 6095.256013] Stack:
[ 6095.256016]  0000000000000000 0000000000000005 0000000000000001 0000000000000000
[ 6095.256025]  0000000000000001 ffff880122fb37e0 ffff880028723858 0000000000000090
[ 6095.256032]  ffff880126918400 0000000000000be9 ffff880126918400 ffff8801275b3510
[ 6095.256040] Call Trace:
[ 6095.256079]  [<ffffffffa0191d4f>] __btrfs_inc_extent_ref+0x9f/0x1f0 [btrfs]
[ 6095.256117]  [<ffffffffa0194cdd>] ? btrfs_reduce_alloc_profile+0x5d/0x120 [btrfs]
[ 6095.256154]  [<ffffffffa019874f>] run_clustered_refs+0x93f/0xa00 [btrfs]
[ 6095.256190]  [<ffffffffa01989b2>] btrfs_run_delayed_refs+0x1a2/0x460 [btrfs]
[ 6095.256234]  [<ffffffffa01f0875>] ? drop_backref_node+0xa5/0xb0 [btrfs]
[ 6095.256243]  [<ffffffff8114a5cf>] ? kmem_cache_free+0x2f/0x110
[ 6095.256286]  [<ffffffffa01f559d>] ? relocate_tree_blocks+0x5ad/0x650 [btrfs]
[ 6095.256327]  [<ffffffffa01aa561>] __btrfs_end_transaction+0xd1/0x360 [btrfs]
[ 6095.256368]  [<ffffffffa01aa848>] btrfs_end_transaction_throttle+0x18/0x20 [btrfs]
[ 6095.256410]  [<ffffffffa01f66ec>] relocate_block_group+0x51c/0x650 [btrfs]
[ 6095.256452]  [<ffffffffa01f69df>] btrfs_relocate_block_group+0x1bf/0x2f0 [btrfs]
[ 6095.256495]  [<ffffffffa01d31b5>] btrfs_relocate_chunk.isra.53+0x75/0x730 [btrfs]
[ 6095.256505]  [<ffffffff8107a673>] ? __wake_up+0x53/0x70
[ 6095.256548]  [<ffffffffa01cfb17>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 6095.256590]  [<ffffffffa01d7527>] btrfs_balance+0x857/0xd10 [btrfs]
[ 6095.256633]  [<ffffffffa01de8e4>] btrfs_ioctl_balance+0x134/0x440 [btrfs]
[ 6095.256676]  [<ffffffffa01e0d9f>] btrfs_ioctl+0xb8f/0x1380 [btrfs]
[ 6095.256686]  [<ffffffff810419d8>] ? do_page_fault+0x1c8/0x460
[ 6095.256694]  [<ffffffff811694e8>] do_vfs_ioctl+0x98/0x550
[ 6095.256701]  [<ffffffff8114a5cf>] ? kmem_cache_free+0x2f/0x110
[ 6095.256708]  [<ffffffff81169a31>] sys_ioctl+0x91/0xa0
[ 6095.256717]  [<ffffffff813e0d69>] system_call_fastpath+0x16/0x1b
[ 6095.256720] Code: 48 89 da 4c 89 e6 4c 89 ef 4c 89 3c 24 48 89 44 24 18 8b 45 28 89 44 24 10 48 8b 45 20 48 89 44 24 08 e8 b5 eb ff ff 31 c0 eb a1 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
[ 6095.256792] RIP  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
[ 6095.256824]  RSP <ffff880028723788>
[ 6095.256859] ---[ end trace 4f7bea0b41eaec44 ]---
[ 6095.256873] ------------[ cut here ]------------
[ 6095.256894] kernel BUG at fs/btrfs/extent-tree.c:1769!
[ 6095.256901] invalid opcode: 0000 [#2] SMP 
[ 6095.256907] CPU 3 
[ 6095.256911] Modules linked in:<4>[ 6095.257038]  jbd ext2 mbcache
[ 6095.257046] 
[ 6095.257053] Pid: 30307, comm: btrfs-endio-wri Tainted: P      D    O 3.5.0 #1 System manufacturer System Product Name/M4A79 Deluxe
[ 6095.257093] RIP: 0010:[<ffffffffa0191c9f>]  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
[ 6095.257155] RSP: 0018:ffff88002599da40  EFLAGS: 00010293
[ 6095.257160] RAX: 0000000000000000 RBX: ffff8801275db630 RCX: ffff88002599da88
[ 6095.257164] RDX: ffff8801275db630 RSI: 0000000000000001 RDI: 0000000000000000
[ 6095.257169] RBP: ffff88002599dac0 R08: 0000000000000eef R09: ffff88002599d950
[ 6095.257173] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880126918800
[ 6095.257177] R13: ffff880127618b40 R14: 0000000000000000 R15: 0000000000000000
[ 6095.257183] FS:  00007f9350d7c700(0000) GS:ffff88012fcc0000(0000) knlGS:0000000000000000
[ 6095.257188] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6095.257192] CR2: 0000000000f38008 CR3: 000000011f67b000 CR4: 00000000000007e0
[ 6095.257197] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6095.257201] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6095.257207] Process btrfs-endio-wri (pid: 30307, threadinfo ffff88002599c000, task ffff88009ee12d80)
[ 6095.257210] Stack:
[ 6095.257214]  0000000000000000 0000000000000005 0000000000000000 0000000000000000
[ 6095.257231]  ffff880000000001 ffff88012b002200 ffff88002599db10 0000000000000090
[ 6095.257248]  ffff880126ccb400 0000000000000ee6 ffff880126ccb400 ffff8801275db630
[ 6095.257265] Call Trace:
[ 6095.257275]  [<ffffffffa0191d4f>] __btrfs_inc_extent_ref+0x9f/0x1f0 [btrfs]
[ 6095.257314]  [<ffffffffa0194cdd>] ? btrfs_reduce_alloc_profile+0x5d/0x120 [btrfs]
[ 6095.257351]  [<ffffffffa019874f>] run_clustered_refs+0x93f/0xa00 [btrfs]
[ 6095.257419]  [<ffffffffa01989b2>] btrfs_run_delayed_refs+0x1a2/0x460 [btrfs]
[ 6095.257466]  [<ffffffffa01cadd8>] ? free_extent_state+0x58/0xd0 [btrfs]
[ 6095.257502]  [<ffffffffa01925e8>] ? block_rsv_release_bytes+0x78/0x190 [btrfs]
[ 6095.257542]  [<ffffffffa01aa537>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
[ 6095.257583]  [<ffffffffa01aa865>] btrfs_end_transaction+0x15/0x20 [btrfs]
[ 6095.257626]  [<ffffffffa01b0645>] btrfs_finish_ordered_io+0x195/0x3c0 [btrfs]
[ 6095.257668]  [<ffffffffa01b0885>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 6095.257722]  [<ffffffffa01db49f>] worker_loop+0x14f/0x570 [btrfs]
[ 6095.257764]  [<ffffffffa01db350>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 6095.257772]  [<ffffffff810701c3>] kthread+0x93/0xa0
[ 6095.257780]  [<ffffffff813e2064>] kernel_thread_helper+0x4/0x10
[ 6095.257787]  [<ffffffff81070130>] ? kthread_freezable_should_stop+0x70/0x70
[ 6095.257791]  [<ffffffff813e2060>] ? gs_change+0x13/0x13
[ 6095.257793] Code: 48 89 da 4c 89 e6 4c 89 ef 4c 89 3c 24 48 89 44 24 18 8b 45 28 89 44 24 10 48 8b 45 20 48 89 44 24 08 e8 b5 eb ff ff 31 c0 eb a1 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
[ 6095.257891] RIP  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
[ 6095.257930]  RSP <ffff88002599da40>
[ 6095.257950] ---[ end trace 4f7bea0b41eaec45 ]---
[ 6127.304475] ------------[ cut here ]------------
[ 6127.304485] kernel BUG at fs/btrfs/extent-tree.c:1769!
[ 6127.304490] invalid opcode: 0000 [#3] SMP 
[ 6127.304496] CPU 0 
[ 6127.304499] Modules linked in:<4>[ 6127.304623]  jbd ext2 mbcache
[ 6127.304630] 
[ 6127.304635] Pid: 1126, comm: btrfs-transacti Tainted: P      D    O 3.5.0 #1 System manufacturer System Product Name/M4A79 Deluxe
[ 6127.304644] RIP: 0010:[<ffffffffa0191c9f>]  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
[ 6127.304685] RSP: 0018:ffff880126bfbac0  EFLAGS: 00010293
[ 6127.304689] RAX: 0000000000000000 RBX: ffff880127486630 RCX: ffff880126bfbb08
[ 6127.304694] RDX: ffff880127486630 RSI: 0000000000000001 RDI: 0000000000000000
[ 6127.304698] RBP: ffff880126bfbb40 R08: 0000000000000e56 R09: ffff880126bfb9d0
[ 6127.304701] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880126918800
[ 6127.304705] R13: ffff88012afdd370 R14: 0000000000000000 R15: 0000000000000001
[ 6127.304710] FS:  00007f9350d7c700(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[ 6127.304714] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6127.304718] CR2: 00007fcd544f7b40 CR3: 000000011f67b000 CR4: 00000000000007f0
[ 6127.304722] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6127.304726] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6127.304731] Process btrfs-transacti (pid: 1126, threadinfo ffff880126bfa000, task ffff8801268d2d80)
[ 6127.304733] Stack:
[ 6127.304736]  0000000000000000 0000000000000005 0000000000000001 0000000000000000
[ 6127.304745]  ffff880100000001 ffff88012b002200 ffff880126bfbb90 0000000000000090
[ 6127.304753]  ffff880126918400 0000000000000e4d ffff880126918400 ffff880127486630
[ 6127.304760] Call Trace:
[ 6127.304800]  [<ffffffffa0191d4f>] __btrfs_inc_extent_ref+0x9f/0x1f0 [btrfs]
[ 6127.304837]  [<ffffffffa0194cdd>] ? btrfs_reduce_alloc_profile+0x5d/0x120 [btrfs]
[ 6127.304874]  [<ffffffffa019874f>] run_clustered_refs+0x93f/0xa00 [btrfs]
[ 6127.304910]  [<ffffffffa01989b2>] btrfs_run_delayed_refs+0x1a2/0x460 [btrfs]
[ 6127.304920]  [<ffffffff813ddb8d>] ? mutex_lock+0x1d/0x50
[ 6127.304966]  [<ffffffffa01c98a7>] ? btrfs_run_ordered_operations+0x1c7/0x1e0 [btrfs]
[ 6127.305007]  [<ffffffffa01a9a6b>] btrfs_commit_transaction+0xab/0xaa0 [btrfs]
[ 6127.305016]  [<ffffffff81070c40>] ? add_wait_queue+0x60/0x60
[ 6127.305055]  [<ffffffffa01a3b3d>] transaction_kthread+0x23d/0x2b0 [btrfs]
[ 6127.305095]  [<ffffffffa01a3900>] ? btrfs_destroy_marked_extents.isra.99.constprop.113+0x1a0/0x1a0 [btrfs]
[ 6127.305103]  [<ffffffff810701c3>] kthread+0x93/0xa0
[ 6127.305111]  [<ffffffff813e2064>] kernel_thread_helper+0x4/0x10
[ 6127.305119]  [<ffffffff81070130>] ? kthread_freezable_should_stop+0x70/0x70
[ 6127.305126]  [<ffffffff813e2060>] ? gs_change+0x13/0x13
[ 6127.305128] Code: 48 89 da 4c 89 e6 4c 89 ef 4c 89 3c 24 48 89 44 24 18 8b 45 28 89 44 24 10 48 8b 45 20 48 89 44 24 08 e8 b5 eb ff ff 31 c0 eb a1 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
[ 6127.305200] RIP  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
[ 6127.305231]  RSP <ffff880126bfbac0>
[ 6127.305287] ---[ end trace 4f7bea0b41eaec46 ]---


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="disasm-insert_inline_extent_backref.txt"

   15bb0:    55                       push    %rbp
   15bb1:    48 89 e5                 mov     %rsp,%rbp
   15bb4:    48 83 c4 80              add     $0xffffffffffffff80,%rsp
   15bb8:    48 89 5d d8              mov     %rbx,-0x28(%rbp)
   15bbc:    4c 89 65 e0              mov     %r12,-0x20(%rbp)
   15bc0:    4c 89 6d e8              mov     %r13,-0x18(%rbp)
   15bc4:    4c 89 75 f0              mov     %r14,-0x10(%rbp)
   15bc8:    4c 89 7d f8              mov     %r15,-0x8(%rbp)
   15bcc:    e8 00 00 00 00           callq   0x15bd1
   15bd1:    48 8b 45 20              mov     0x20(%rbp),%rax
   15bd5:    4c 8b 7d 18              mov     0x18(%rbp),%r15
   15bd9:    4c 89 0c 24              mov     %r9,(%rsp)
   15bdd:    4d 89 ce                 mov     %r9,%r14
   15be0:    4d 89 c1                 mov     %r8,%r9
   15be3:    49 89 c8                 mov     %rcx,%r8
   15be6:    48 8d 4d c8              lea     -0x38(%rbp),%rcx
   15bea:    49 89 fd                 mov     %rdi,%r13
   15bed:    48 89 44 24 18           mov     %rax,0x18(%rsp)
   15bf2:    48 8b 45 10              mov     0x10(%rbp),%rax
   15bf6:    49 89 f4                 mov     %rsi,%r12
   15bf9:    48 89 d3                 mov     %rdx,%rbx
   15bfc:    c7 44 24 20 01 00 00 00  movl    $0x1,0x20(%rsp)
   15c04:    4c 89 7c 24 10           mov     %r15,0x10(%rsp)
   15c09:    48 89 44 24 08           mov     %rax,0x8(%rsp)
   15c0e:    e8 1d fb ff ff           callq   0x15730
   15c13:    85 c0                    test    %eax,%eax
   15c15:    75 49                    jne     0x15c60
   15c17:    49 81 ff ff 00 00 00     cmp     $0xff,%r15
   15c1e:    76 7f                    jbe     0x15c9f
   15c20:    4c 8b 4d 30              mov     0x30(%rbp),%r9
   15c24:    44 8b 45 28              mov     0x28(%rbp),%r8d
   15c28:    48 89 da                 mov     %rbx,%rdx
   15c2b:    48 8b 4d c8              mov     -0x38(%rbp),%rcx
   15c2f:    4c 89 e6                 mov     %r12,%rsi
   15c32:    4c 89 ef                 mov     %r13,%rdi
   15c35:    89 45 b8                 mov     %eax,-0x48(%rbp)
   15c38:    e8 63 ee ff ff           callq   0x14aa0
   15c3d:    8b 45 b8                 mov     -0x48(%rbp),%eax
   15c40:    48 8b 5d d8              mov     -0x28(%rbp),%rbx
   15c44:    4c 8b 65 e0              mov     -0x20(%rbp),%r12
   15c48:    4c 8b 6d e8              mov     -0x18(%rbp),%r13
   15c4c:    4c 8b 75 f0              mov     -0x10(%rbp),%r14
   15c50:    4c 8b 7d f8              mov     -0x8(%rbp),%r15
   15c54:    c9                       leaveq
   15c55:    c3                       retq


--xHFwDpU9dbj6ez1V--
