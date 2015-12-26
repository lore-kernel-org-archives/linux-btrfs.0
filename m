Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:35142 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbLZCAN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 21:00:13 -0500
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id CD003EF8DE
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 02:00:09 +0000 (UTC)
Date: Sat, 26 Dec 2015 07:00:04 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Deadlock after upgrade to 4.1
Message-ID: <20151226070004.461eebaf@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vg+ScRTLiOd4gyJJb04LHlD"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Vg+ScRTLiOd4gyJJb04LHlD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On the first or second night after upgrade from a 3.18.21 kernel to 4.1.15,
during concurrent heavy file operations (pruning old backups), I got into t=
his
deadlock(?).

After these messages any attempt to write to the affected filesystem would =
hang
indefinitely, system load went to ~37, and there seemed to be no HDD activi=
ty.

It did not clear up in about 40 minutes, I ended up forcibly rebooting the =
machine.

Dunno how useful this is as a "new" bugreport, but maybe this looks familia=
r to
someone, and perhaps this is something that is already fixed in 4.2/4.3?

[Sat Dec 26 04:58:14 2015] INFO: task kworker/u16:4:2786 blocked for more t=
han 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] kworker/u16:4   D ffff880002d7f968     0  2786  =
    2 0x00000000
[Sat Dec 26 04:58:14 2015] Workqueue: btrfs-endio-write btrfs_endio_write_h=
elper [btrfs]
[Sat Dec 26 04:58:14 2015]  ffff880002d7f968 ffff8807faf01930 ffff88010c76e=
4c0 ffff880002d7f988
[Sat Dec 26 04:58:14 2015]  ffff880002d80000 ffff88013ad77aa8 ffff88010c76e=
4c0 ffff88010c76e4c0
[Sat Dec 26 04:58:14 2015]  ffff880002d7f9b8 ffff880002d7f988 ffffffff8159b=
c27 ffff88013ad77aa8
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa036fc75>] btrfs_tree_read_lock+0xc5/=
0x120 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa030b2bb>] btrfs_read_lock_root_node+=
0x3b/0x50 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0310509>] btrfs_search_slot+0x749/0x=
a30 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810ac180>] ? enqueue_task_fair+0x1190=
/0x1400
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03296c7>] btrfs_lookup_file_extent+0=
x37/0x40 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0349bc7>] __btrfs_drop_extents+0x177=
/0xeb0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0353bad>] ? __set_extent_bit+0x14d/0=
x570 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff811bf2fb>] ? kmem_cache_alloc+0x12b/0=
x140
[Sat Dec 26 04:58:14 2015]  [<ffffffffa030afba>] ? btrfs_alloc_path+0x1a/0x=
20 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03391b5>] insert_reserved_file_exten=
t.constprop.63+0xa5/0x310 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033f7e9>] btrfs_finish_ordered_io+0x=
2e9/0x5f0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810acf00>] ? dequeue_task_fair+0xb10/=
0xca0
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033fdb5>] finish_ordered_fn+0x15/0x2=
0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0367bb1>] normal_work_helper+0xc1/0x=
270 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0367ef2>] btrfs_endio_write_helper+0=
x12/0x20 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff8108e881>] process_one_work+0x151/0x4=
40
[Sat Dec 26 04:58:14 2015]  [<ffffffff8108f3f3>] worker_thread+0x73/0x550
[Sat Dec 26 04:58:14 2015]  [<ffffffff8108f380>] ? rescuer_thread+0x380/0x3=
80
[Sat Dec 26 04:58:14 2015]  [<ffffffff810949ab>] kthread+0xdb/0x100
[Sat Dec 26 04:58:14 2015]  [<ffffffff810948d0>] ? kthread_create_on_node+0=
x190/0x190
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a0722>] ret_from_fork+0x42/0x70
[Sat Dec 26 04:58:14 2015]  [<ffffffff810948d0>] ? kthread_create_on_node+0=
x190/0x190
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3517 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff880101c0f808     0  3517  =
 3515 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff880101c0f808 ffff8807faf01930 ffff880101d4b=
260 ffff880101c0f828
[Sat Dec 26 04:58:14 2015]  ffff880101c10000 ffff8801390af648 ffff8801390af=
660 ffff880101c0f858
[Sat Dec 26 04:58:14 2015]  ffff8801390af640 ffff880101c0f828 ffffffff8159b=
c27 ffff8801390af648
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa036ffb5>] btrfs_tree_lock+0x55/0x1d0=
 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa030b30b>] btrfs_lock_root_node+0x3b/=
0x50 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03106e1>] btrfs_search_slot+0x921/0x=
a30 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa031222b>] btrfs_insert_empty_items+0=
x7b/0xe0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0359893>] ? free_extent_buffer+0x53/=
0xb0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0374dc7>] overwrite_item+0xe7/0x5e0 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa037709b>] log_dir_items+0x4eb/0x570 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0374755>] ? copy_items+0x605/0xb90 [=
btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0377195>] log_directory_changes+0x75=
/0xa0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa037794c>] btrfs_log_inode+0x78c/0x95=
0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0378519>] btrfs_log_inode_parent+0x9=
69/0xc90 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03797ea>] btrfs_log_dentry_safe+0x6a=
/0x90 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa034c5b7>] btrfs_sync_file+0x1b7/0x34=
0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b236>] vfs_fsync_range+0x46/0xb0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d73fc>] ? do_sys_open+0x1ac/0x230
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b304>] do_fsync+0x44/0x70
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b5b0>] SyS_fsync+0x10/0x20
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3520 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff88010398bd08     0  3520  =
 3518 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff88010398bd08 ffff8807faf03260 ffff880102efe=
4c0 ffff88010398bce8
[Sat Dec 26 04:58:14 2015]  ffff88010398c000 ffff88010398be48 7ffffffffffff=
fff ffff880102efe4c0
[Sat Dec 26 04:58:14 2015]  ffff8807f8f4e068 ffff88010398bd28 ffffffff8159b=
c27 0000000000000200
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159ee04>] schedule_timeout+0x204/0x2=
80
[Sat Dec 26 04:58:14 2015]  [<ffffffff8108ca7a>] ? __queue_delayed_work+0xb=
a/0x1b0
[Sat Dec 26 04:58:14 2015]  [<ffffffff8108ce51>] ? try_to_grab_pending+0xc1=
/0x160
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159d254>] wait_for_completion+0x104/=
0x160
[Sat Dec 26 04:58:14 2015]  [<ffffffff810a1f90>] ? wake_up_state+0x20/0x20
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b0f0>] ? SyS_tee+0x3f0/0x3f0
[Sat Dec 26 04:58:14 2015]  [<ffffffff812038a8>] sync_inodes_sb+0xa8/0x1c0
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b0f0>] ? SyS_tee+0x3f0/0x3f0
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b109>] sync_inodes_one_sb+0x19/0x=
20
[Sat Dec 26 04:58:14 2015]  [<ffffffff811dbc10>] iterate_supers+0xb0/0x110
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b455>] sys_sync+0x35/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3523 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff880784ea3cc8     0  3523  =
 3521 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff880784ea3cc8 ffff8807faf18000 ffff880102f04=
b90 ffff880784ea3ce8
[Sat Dec 26 04:58:14 2015]  ffff880784ea4000 ffff8807f8f4ea98 ffff8807f8f4e=
ac0 ffff88000365d800
[Sat Dec 26 04:58:14 2015]  ffff8807f8f4e800 ffff880784ea3ce8 ffffffff8159b=
c27 ffff8807f8f4ea98
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0371d56>] wait_for_writer.isra.15+0x=
a6/0xc0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0378938>] btrfs_sync_log+0xf8/0xa70 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03797f5>] ? btrfs_log_dentry_safe+0x=
75/0x90 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa034c6ea>] btrfs_sync_file+0x2ea/0x34=
0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b236>] vfs_fsync_range+0x46/0xb0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d73fc>] ? do_sys_open+0x1ac/0x230
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b304>] do_fsync+0x44/0x70
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b5b0>] SyS_fsync+0x10/0x20
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3526 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff880102fcb6c8     0  3526  =
 3524 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff880102fcb6c8 ffff8807faf00000 ffff88002d0d6=
4c0 ffff880102fcb6e8
[Sat Dec 26 04:58:14 2015]  ffff880102fcc000 ffff88013ad77aa8 ffff88002d0d6=
4c0 ffff88002d0d64c0
[Sat Dec 26 04:58:14 2015]  ffff880102fcb718 ffff880102fcb6e8 ffffffff8159b=
c27 ffff88013ad77aa8
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa036fc75>] btrfs_tree_read_lock+0xc5/=
0x120 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa030b2bb>] btrfs_read_lock_root_node+=
0x3b/0x50 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0310509>] btrfs_search_slot+0x749/0x=
a30 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff8130381b>] ? __sg_alloc_table+0x7b/0x=
170
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03296c7>] btrfs_lookup_file_extent+0=
x37/0x40 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b24e>] btrfs_get_extent+0x15e/0xa=
80 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa035380e>] ? insert_state+0xae/0x160 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0357438>] __do_readpage+0x188/0x7b0 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0354c3b>] ? lock_extent_bits+0x7b/0x=
230 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0351c68>] ? btrfs_lookup_ordered_ran=
ge+0x178/0x1b0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0357ddf>] __extent_readpages.constpr=
op.38+0x29f/0x2c0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff81169fce>] ? __add_to_page_cache_lock=
ed+0x19e/0x2a0
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0358edd>] extent_readpages+0x17d/0x1=
e0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0337f2f>] btrfs_readpages+0x1f/0x30 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff811766dc>] __do_page_cache_readahead+=
0x18c/0x200
[Sat Dec 26 04:58:14 2015]  [<ffffffff81176839>] ondemand_readahead+0xe9/0x=
270
[Sat Dec 26 04:58:14 2015]  [<ffffffffa032d3e1>] ? btrfs_congested_fn+0x31/=
0xa0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff81176a41>] page_cache_async_readahead=
+0x81/0xb0
[Sat Dec 26 04:58:14 2015]  [<ffffffff8116af97>] generic_file_read_iter+0x4=
07/0x5d0
[Sat Dec 26 04:58:14 2015]  [<ffffffff810a91e9>] ? set_next_entity+0xb9/0x4=
c0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d7b0e>] __vfs_read+0xae/0xe0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d8195>] vfs_read+0x95/0x140
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d907f>] SyS_read+0x4f/0xc0
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3529 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff8801038abcb8     0  3529  =
 3527 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff8801038abcb8 ffff8807faf00000 ffff880107e39=
930 ffff8801038abcd8
[Sat Dec 26 04:58:14 2015]  ffff8801038ac000 0000000000000009 ffff8807f8f4e=
a98 ffff8807f8f4eaf0
[Sat Dec 26 04:58:14 2015]  ffff8807f8f4eb24 ffff8801038abcd8 ffffffff8159b=
c27 0000000000000009
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0371c9c>] wait_log_commit.isra.14+0x=
dc/0xf0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0378c9b>] btrfs_sync_log+0x45b/0xa70=
 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03797f5>] ? btrfs_log_dentry_safe+0x=
75/0x90 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa034c6ea>] btrfs_sync_file+0x2ea/0x34=
0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b236>] vfs_fsync_range+0x46/0xb0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d73fc>] ? do_sys_open+0x1ac/0x230
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b304>] do_fsync+0x44/0x70
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b5b0>] SyS_fsync+0x10/0x20
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3534 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff88010389b9d8     0  3534  =
 3530 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff88010389b9d8 ffff8807faf00000 ffff880102f06=
4c0 ffff88010389b9f8
[Sat Dec 26 04:58:14 2015]  ffff88010389c000 ffff88013ad77aa8 ffff880102f06=
4c0 ffff880102f064c0
[Sat Dec 26 04:58:14 2015]  ffff88010389ba28 ffff88010389b9f8 ffffffff8159b=
c27 ffff88013ad77aa8
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa036fc75>] btrfs_tree_read_lock+0xc5/=
0x120 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa030b2bb>] btrfs_read_lock_root_node+=
0x3b/0x50 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0310509>] btrfs_search_slot+0x749/0x=
a30 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff811bf5d0>] ? __slab_free.isra.68+0x13=
0/0x1b0
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03287e4>] btrfs_lookup_dir_item+0x74=
/0xb0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03432f6>] btrfs_lookup_dentry+0xa6/0=
x530 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff811f2c03>] ? __d_alloc+0x123/0x180
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0343796>] btrfs_lookup+0x16/0x40 [bt=
rfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff811e1f6d>] lookup_real+0x1d/0x70
[Sat Dec 26 04:58:14 2015]  [<ffffffff811e2a98>] __lookup_hash+0x38/0x50
[Sat Dec 26 04:58:14 2015]  [<ffffffff811e874d>] path_lookupat+0x83d/0xd30
[Sat Dec 26 04:58:14 2015]  [<ffffffff811bf1fd>] ? kmem_cache_alloc+0x2d/0x=
140
[Sat Dec 26 04:58:14 2015]  [<ffffffff811e9701>] ? getname_flags+0x61/0x220
[Sat Dec 26 04:58:14 2015]  [<ffffffff811e8c70>] filename_lookup+0x30/0xc0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811eaa1e>] user_path_at_empty+0x5e/0x=
b0
[Sat Dec 26 04:58:14 2015]  [<ffffffff8110c8e2>] ? from_kgid_munged+0x12/0x=
20
[Sat Dec 26 04:58:14 2015]  [<ffffffff811dd552>] ? cp_new_stat+0x142/0x160
[Sat Dec 26 04:58:14 2015]  [<ffffffff811eaa81>] user_path_at+0x11/0x20
[Sat Dec 26 04:58:14 2015]  [<ffffffff811dd0f9>] vfs_fstatat+0x49/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffff811dd5d2>] SYSC_newlstat+0x22/0x40
[Sat Dec 26 04:58:14 2015]  [<ffffffff811dd82e>] SyS_newlstat+0xe/0x10
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3535 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff880102fcf6c8     0  3535  =
 3531 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff880102fcf6c8 ffffffff81a13540 ffff880101d4e=
4c0 ffff880102fcf6e8
[Sat Dec 26 04:58:14 2015]  ffff880102fd0000 ffff88013ad77aa8 ffff880101d4e=
4c0 ffff880101d4e4c0
[Sat Dec 26 04:58:14 2015]  ffff880102fcf718 ffff880102fcf6e8 ffffffff8159b=
c27 ffff88013ad77aa8
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa036fc75>] btrfs_tree_read_lock+0xc5/=
0x120 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa030b2bb>] btrfs_read_lock_root_node+=
0x3b/0x50 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0310509>] btrfs_search_slot+0x749/0x=
a30 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03296c7>] btrfs_lookup_file_extent+0=
x37/0x40 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b24e>] btrfs_get_extent+0x15e/0xa=
80 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa035380e>] ? insert_state+0xae/0x160 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0357438>] __do_readpage+0x188/0x7b0 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0354c3b>] ? lock_extent_bits+0x7b/0x=
230 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0351c68>] ? btrfs_lookup_ordered_ran=
ge+0x178/0x1b0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0357ddf>] __extent_readpages.constpr=
op.38+0x29f/0x2c0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff81169fce>] ? __add_to_page_cache_lock=
ed+0x19e/0x2a0
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0358edd>] extent_readpages+0x17d/0x1=
e0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0337f2f>] btrfs_readpages+0x1f/0x30 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff811766dc>] __do_page_cache_readahead+=
0x18c/0x200
[Sat Dec 26 04:58:14 2015]  [<ffffffff81176839>] ondemand_readahead+0xe9/0x=
270
[Sat Dec 26 04:58:14 2015]  [<ffffffffa032d3e1>] ? btrfs_congested_fn+0x31/=
0xa0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff81176a41>] page_cache_async_readahead=
+0x81/0xb0
[Sat Dec 26 04:58:14 2015]  [<ffffffff8116af97>] generic_file_read_iter+0x4=
07/0x5d0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d7b0e>] __vfs_read+0xae/0xe0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d8195>] vfs_read+0x95/0x140
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d907f>] SyS_read+0x4f/0xc0
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3541 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff88079b5f3cb8     0  3541  =
 3539 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff88079b5f3cb8 ffff8807faf18000 ffff8805fd1f6=
4c0 ffff88079b5f3cd8
[Sat Dec 26 04:58:14 2015]  ffff88079b5f4000 0000000000000009 ffff8807f8f4e=
a98 ffff8807f8f4eaf0
[Sat Dec 26 04:58:14 2015]  ffff8807f8f4eb24 ffff88079b5f3cd8 ffffffff8159b=
c27 0000000000000009
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0371c9c>] wait_log_commit.isra.14+0x=
dc/0xf0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0378c9b>] btrfs_sync_log+0x45b/0xa70=
 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03797f5>] ? btrfs_log_dentry_safe+0x=
75/0x90 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa034c6ea>] btrfs_sync_file+0x2ea/0x34=
0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b236>] vfs_fsync_range+0x46/0xb0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d73fc>] ? do_sys_open+0x1ac/0x230
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b304>] do_fsync+0x44/0x70
[Sat Dec 26 04:58:14 2015]  [<ffffffff8120b5b0>] SyS_fsync+0x10/0x20
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75
[Sat Dec 26 04:58:14 2015] INFO: task rdiff-backup:3544 blocked for more th=
an 120 seconds.
[Sat Dec 26 04:58:14 2015]       Not tainted 4.1.15-rm2+ #100
[Sat Dec 26 04:58:14 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
[Sat Dec 26 04:58:14 2015] rdiff-backup    D ffff88076efa36c8     0  3544  =
 3542 0x00000000
[Sat Dec 26 04:58:14 2015]  ffff88076efa36c8 ffffffff81a13540 ffff880101d48=
000 ffff88076efa36e8
[Sat Dec 26 04:58:14 2015]  ffff88076efa4000 ffff88013ad77aa8 ffff880101d48=
000 ffff880101d48000
[Sat Dec 26 04:58:14 2015]  ffff88076efa3718 ffff88076efa36e8 ffffffff8159b=
c27 ffff88013ad77aa8
[Sat Dec 26 04:58:14 2015] Call Trace:
[Sat Dec 26 04:58:14 2015]  [<ffffffff8159bc27>] schedule+0x37/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa036fc75>] btrfs_tree_read_lock+0xc5/=
0x120 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff810b6c50>] ? wait_woken+0x90/0x90
[Sat Dec 26 04:58:14 2015]  [<ffffffffa030b2bb>] btrfs_read_lock_root_node+=
0x3b/0x50 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0310509>] btrfs_search_slot+0x749/0x=
a30 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0041c24>] ? sd_init_command+0x64/0xe=
50 [sd_mod]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa03296c7>] btrfs_lookup_file_extent+0=
x37/0x40 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b24e>] btrfs_get_extent+0x15e/0xa=
80 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa035380e>] ? insert_state+0xae/0x160 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0357438>] __do_readpage+0x188/0x7b0 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0354c3b>] ? lock_extent_bits+0x7b/0x=
230 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0351c68>] ? btrfs_lookup_ordered_ran=
ge+0x178/0x1b0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0357ddf>] __extent_readpages.constpr=
op.38+0x29f/0x2c0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff81169fce>] ? __add_to_page_cache_lock=
ed+0x19e/0x2a0
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0358edd>] extent_readpages+0x17d/0x1=
e0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa033b0f0>] ? btrfs_real_readdir+0x5d0=
/0x5d0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffffa0337f2f>] btrfs_readpages+0x1f/0x30 =
[btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff811766dc>] __do_page_cache_readahead+=
0x18c/0x200
[Sat Dec 26 04:58:14 2015]  [<ffffffff81176839>] ondemand_readahead+0xe9/0x=
270
[Sat Dec 26 04:58:14 2015]  [<ffffffffa032d3e1>] ? btrfs_congested_fn+0x31/=
0xa0 [btrfs]
[Sat Dec 26 04:58:14 2015]  [<ffffffff81176a41>] page_cache_async_readahead=
+0x81/0xb0
[Sat Dec 26 04:58:14 2015]  [<ffffffff8116af97>] generic_file_read_iter+0x4=
07/0x5d0
[Sat Dec 26 04:58:14 2015]  [<ffffffff810a91e9>] ? set_next_entity+0xb9/0x4=
c0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d7b0e>] __vfs_read+0xae/0xe0
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d8195>] vfs_read+0x95/0x140
[Sat Dec 26 04:58:14 2015]  [<ffffffff811d907f>] SyS_read+0x4f/0xc0
[Sat Dec 26 04:58:14 2015]  [<ffffffff815a02f2>] system_call_fastpath+0x16/=
0x75


--=20
With respect,
Roman

--Sig_/Vg+ScRTLiOd4gyJJb04LHlD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZ99KUACgkQTLKSvz+PZwj2owCfawrPzZiAPDawC3SlWJlcEkOU
mtsAn2EzJAGUAiE0ChxxZtGK/3k7Oz00
=jsSn
-----END PGP SIGNATURE-----

--Sig_/Vg+ScRTLiOd4gyJJb04LHlD--
