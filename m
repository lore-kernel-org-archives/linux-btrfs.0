Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:50371 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbcAJAbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 19:31:21 -0500
Date: Sun, 10 Jan 2016 05:31:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Reproduced deadlock after upgrade from 3.18 to 4.1 or 4.3 (+ more
 info)
Message-ID: <20160110053119.45e05246@natsu>
In-Reply-To: <CAJCQCtRTNgUFnjGyF6wBeiX2LzMjO8Avc8xGb9NAFLnvgGyM3Q@mail.gmail.com>
References: <20151226070004.461eebaf@natsu>
 <CAJCQCtRTNgUFnjGyF6wBeiX2LzMjO8Avc8xGb9NAFLnvgGyM3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xxSD5dvqGUq6s7GUopHC3um"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/xxSD5dvqGUq6s7GUopHC3um
Content-Type: multipart/mixed; boundary="MP_/768qrIKvm_fr=W2_MP_0Z5n"

--MP_/768qrIKvm_fr=W2_MP_0Z5n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 25 Dec 2015 21:34:43 -0700
Chris Murphy <lists@colorremedies.com> wrote:

> This could be an unintended regression, I'm not finding much related
> at all in recent history in the traces. I'd say reproduce and get a
> sysrq+w captured. Most of the traces are actually from rdiff-backup,
> but the first one is a kworker. So something happens and then due to
> the ensuing congestion it all just gets worse. Maybe it would have
> eventually recovered but once it's this congested it might have taken
> a really long time.
>=20
> I would then also try to reproduce with 4.2.8 or 4.3.3 because those
> have ~ 25% backports than made it to 4.1.15, so there's an off chance
> it's fixed there. But even better to just go straight to 4.4.rc6 if
> you can, because an unintended regression that's not known will likely
> happen in 4.4 and would need to be fixed now before it'd get
> backported anyway. *shrug*

Hello,

After this case I went back to 3.18.25, and the system worked fine for abou=
t 2
weeks more. However now I decided to try upgrading again, this time to 4.3.=
3 -
and hit the deadlock on the very first attempt to use the same script.

The script launches many rdiff-backup processes at once to prune old backup=
s,
so it's heavy concurrent load of directory listing and file deletion.

In dmesg I got the following, sysrq+w is attached (I don't think it managed=
 to fit
into dmesg from beginning, but still seems to be some useful stuff there)

[ 7676.096403] INFO: task kworker/u16:10:5653 blocked for more than 120 sec=
onds.
[ 7676.096429]       Not tainted 4.3.3-rm1+ #101
[ 7676.096438] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.096452] kworker/u16:10  D ffff88082ecd5cc0     0  5653      2 0x0000=
0000
[ 7676.096496] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 7676.096500]  ffff8807512979b8 0000000000000046 ffff88080af10000 ffff8807=
ff411d40
[ 7676.096505]  ffff880751298000 00000000ffffff00 ffff8807ff411d40 ffff8807=
ff411d40
[ 7676.096510]  ffff8800ad8e9928 ffff8807512979d0 ffffffff815ca143 ffff8800=
ad8e9990
[ 7676.096515] Call Trace:
[ 7676.096525]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.096555]  [<ffffffffa036c26c>] btrfs_tree_read_lock+0xec/0x140 [btrfs]
[ 7676.096561]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.096579]  [<ffffffffa0304644>] btrfs_read_lock_root_node+0x34/0x50 [b=
trfs]
[ 7676.096597]  [<ffffffffa03099d4>] btrfs_search_slot+0x744/0x9f0 [btrfs]
[ 7676.096602]  [<ffffffff8130900e>] ? cpumask_next_and+0x2e/0x40
[ 7676.096623]  [<ffffffffa03231e7>] btrfs_lookup_file_extent+0x47/0x70 [bt=
rfs]
[ 7676.096650]  [<ffffffffa03447bc>] __btrfs_drop_extents+0x19c/0xf10 [btrf=
s]
[ 7676.096679]  [<ffffffffa034e681>] ? __set_extent_bit+0x221/0x5a0 [btrfs]
[ 7676.096685]  [<ffffffff811cde2b>] ? kmem_cache_alloc+0x11b/0x130
[ 7676.096701]  [<ffffffffa030439a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[ 7676.096726]  [<ffffffffa03329f4>] insert_reserved_file_extent.constprop.=
63+0xb4/0x320 [btrfs]
[ 7676.096752]  [<ffffffffa03397d4>] btrfs_finish_ordered_io+0x2f4/0x650 [b=
trfs]
[ 7676.096759]  [<ffffffff81020989>] ? sched_clock+0x9/0x10
[ 7676.096783]  [<ffffffffa0339db5>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 7676.096811]  [<ffffffffa03627bf>] normal_work_helper+0xbf/0x250 [btrfs]
[ 7676.096839]  [<ffffffffa0362ae2>] btrfs_endio_write_helper+0x12/0x20 [bt=
rfs]
[ 7676.096845]  [<ffffffff81092e80>] process_one_work+0x150/0x3f0
[ 7676.096849]  [<ffffffff81093929>] worker_thread+0x69/0x470
[ 7676.096853]  [<ffffffff810938c0>] ? rescuer_thread+0x310/0x310
[ 7676.096858]  [<ffffffff8109901a>] kthread+0xea/0x100
[ 7676.096863]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.096868]  [<ffffffff815ce74f>] ret_from_fork+0x3f/0x70
[ 7676.096873]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.096927] INFO: task kworker/u16:7:10989 blocked for more than 120 sec=
onds.
[ 7676.096938]       Not tainted 4.3.3-rm1+ #101
[ 7676.096946] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.096958] kworker/u16:7   D 0000000000000004     0 10989      2 0x0000=
0000
[ 7676.096990] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 7676.096993]  ffff8804ec65b9b8 0000000000000046 ffff8807ffee57c0 ffff8806=
6ed59d40
[ 7676.096998]  ffff8804ec65c000 00000000ffffff00 ffff88066ed59d40 ffff8806=
6ed59d40
[ 7676.097002]  ffff8800ad8e9928 ffff8804ec65b9d0 ffffffff815ca143 ffff8800=
ad8e9990
[ 7676.097007] Call Trace:
[ 7676.097012]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.097040]  [<ffffffffa036c26c>] btrfs_tree_read_lock+0xec/0x140 [btrfs]
[ 7676.097045]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.097062]  [<ffffffffa0304644>] btrfs_read_lock_root_node+0x34/0x50 [b=
trfs]
[ 7676.097079]  [<ffffffffa03099d4>] btrfs_search_slot+0x744/0x9f0 [btrfs]
[ 7676.097101]  [<ffffffffa03231e7>] btrfs_lookup_file_extent+0x47/0x70 [bt=
rfs]
[ 7676.097127]  [<ffffffffa03447bc>] __btrfs_drop_extents+0x19c/0xf10 [btrf=
s]
[ 7676.097132]  [<ffffffff811ce05f>] ? __slab_free.isra.69+0x7f/0x1a0
[ 7676.097161]  [<ffffffffa034e681>] ? __set_extent_bit+0x221/0x5a0 [btrfs]
[ 7676.097166]  [<ffffffff811cde2b>] ? kmem_cache_alloc+0x11b/0x130
[ 7676.097183]  [<ffffffffa030439a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[ 7676.097207]  [<ffffffffa03329f4>] insert_reserved_file_extent.constprop.=
63+0xb4/0x320 [btrfs]
[ 7676.097232]  [<ffffffffa03397d4>] btrfs_finish_ordered_io+0x2f4/0x650 [b=
trfs]
[ 7676.097257]  [<ffffffffa0339db5>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 7676.097284]  [<ffffffffa03627bf>] normal_work_helper+0xbf/0x250 [btrfs]
[ 7676.097312]  [<ffffffffa0362ae2>] btrfs_endio_write_helper+0x12/0x20 [bt=
rfs]
[ 7676.097316]  [<ffffffff81092e80>] process_one_work+0x150/0x3f0
[ 7676.097320]  [<ffffffff81093929>] worker_thread+0x69/0x470
[ 7676.097324]  [<ffffffff810938c0>] ? rescuer_thread+0x310/0x310
[ 7676.097329]  [<ffffffff8109901a>] kthread+0xea/0x100
[ 7676.097333]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.097338]  [<ffffffff815ce74f>] ret_from_fork+0x3f/0x70
[ 7676.097343]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.097347] INFO: task kworker/u16:9:10992 blocked for more than 120 sec=
onds.
[ 7676.097357]       Not tainted 4.3.3-rm1+ #101
[ 7676.097365] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.097379] kworker/u16:9   D ffff88082ec15cc0     0 10992      2 0x0000=
0000
[ 7676.097410] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 7676.097413]  ffff8804e56039b8 0000000000000046 ffffffff81a14540 ffff8807=
055e3a80
[ 7676.097418]  ffff8804e5604000 00000000ffffff00 ffff8807055e3a80 ffff8807=
055e3a80
[ 7676.097422]  ffff8800ad8e9928 ffff8804e56039d0 ffffffff815ca143 ffff8800=
ad8e9990
[ 7676.097427] Call Trace:
[ 7676.097432]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.097459]  [<ffffffffa036c26c>] btrfs_tree_read_lock+0xec/0x140 [btrfs]
[ 7676.097464]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.097480]  [<ffffffffa0304644>] btrfs_read_lock_root_node+0x34/0x50 [b=
trfs]
[ 7676.097497]  [<ffffffffa03099d4>] btrfs_search_slot+0x744/0x9f0 [btrfs]
[ 7676.097504]  [<ffffffff810a3d35>] ? ttwu_do_activate.constprop.91+0x65/0=
x70
[ 7676.097525]  [<ffffffffa03231e7>] btrfs_lookup_file_extent+0x47/0x70 [bt=
rfs]
[ 7676.097551]  [<ffffffffa03447bc>] __btrfs_drop_extents+0x19c/0xf10 [btrf=
s]
[ 7676.097579]  [<ffffffffa034e681>] ? __set_extent_bit+0x221/0x5a0 [btrfs]
[ 7676.097585]  [<ffffffff811cde2b>] ? kmem_cache_alloc+0x11b/0x130
[ 7676.097601]  [<ffffffffa030439a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[ 7676.097625]  [<ffffffffa03329f4>] insert_reserved_file_extent.constprop.=
63+0xb4/0x320 [btrfs]
[ 7676.097650]  [<ffffffffa03397d4>] btrfs_finish_ordered_io+0x2f4/0x650 [b=
trfs]
[ 7676.097675]  [<ffffffffa0339db5>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 7676.097703]  [<ffffffffa03627bf>] normal_work_helper+0xbf/0x250 [btrfs]
[ 7676.097730]  [<ffffffffa0362ae2>] btrfs_endio_write_helper+0x12/0x20 [bt=
rfs]
[ 7676.097735]  [<ffffffff81092e80>] process_one_work+0x150/0x3f0
[ 7676.097739]  [<ffffffff81093929>] worker_thread+0x69/0x470
[ 7676.097742]  [<ffffffff810938c0>] ? rescuer_thread+0x310/0x310
[ 7676.097747]  [<ffffffff8109901a>] kthread+0xea/0x100
[ 7676.097752]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.097757]  [<ffffffff815ce74f>] ret_from_fork+0x3f/0x70
[ 7676.097762]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.097766] INFO: task kworker/u16:14:10994 blocked for more than 120 se=
conds.
[ 7676.097779]       Not tainted 4.3.3-rm1+ #101
[ 7676.097787] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.099024] kworker/u16:14  D ffff88082ec55cc0     0 10994      2 0x0000=
0000
[ 7676.099054] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 7676.099057]  ffff88076865b9b8 0000000000000046 ffff88080aefba80 ffff8807=
bfb18000
[ 7676.099062]  ffff88076865c000 00000000ffffff00 ffff8807bfb18000 ffff8807=
bfb18000
[ 7676.099066]  ffff8800ad8e9928 ffff88076865b9d0 ffffffff815ca143 ffff8800=
ad8e9990
[ 7676.099071] Call Trace:
[ 7676.099075]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.099103]  [<ffffffffa036c26c>] btrfs_tree_read_lock+0xec/0x140 [btrfs]
[ 7676.099107]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.099124]  [<ffffffffa0304644>] btrfs_read_lock_root_node+0x34/0x50 [b=
trfs]
[ 7676.099144]  [<ffffffffa03099d4>] btrfs_search_slot+0x744/0x9f0 [btrfs]
[ 7676.099165]  [<ffffffffa03231e7>] btrfs_lookup_file_extent+0x47/0x70 [bt=
rfs]
[ 7676.099190]  [<ffffffffa03447bc>] __btrfs_drop_extents+0x19c/0xf10 [btrf=
s]
[ 7676.099219]  [<ffffffffa034e681>] ? __set_extent_bit+0x221/0x5a0 [btrfs]
[ 7676.099224]  [<ffffffff811cde2b>] ? kmem_cache_alloc+0x11b/0x130
[ 7676.099240]  [<ffffffffa030439a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[ 7676.099265]  [<ffffffffa03329f4>] insert_reserved_file_extent.constprop.=
63+0xb4/0x320 [btrfs]
[ 7676.099290]  [<ffffffffa03397d4>] btrfs_finish_ordered_io+0x2f4/0x650 [b=
trfs]
[ 7676.099315]  [<ffffffffa0339db5>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 7676.099343]  [<ffffffffa03627bf>] normal_work_helper+0xbf/0x250 [btrfs]
[ 7676.099371]  [<ffffffffa0362ae2>] btrfs_endio_write_helper+0x12/0x20 [bt=
rfs]
[ 7676.099375]  [<ffffffff81092e80>] process_one_work+0x150/0x3f0
[ 7676.099380]  [<ffffffff81093929>] worker_thread+0x69/0x470
[ 7676.099384]  [<ffffffff810938c0>] ? rescuer_thread+0x310/0x310
[ 7676.099388]  [<ffffffff8109901a>] kthread+0xea/0x100
[ 7676.099393]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.099398]  [<ffffffff815ce74f>] ret_from_fork+0x3f/0x70
[ 7676.099403]  [<ffffffff81098f30>] ? kthread_park+0x60/0x60
[ 7676.099412] INFO: task rdiff-backup:17190 blocked for more than 120 seco=
nds.
[ 7676.099422]       Not tainted 4.3.3-rm1+ #101
[ 7676.099430] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.099443] rdiff-backup    D 0000000000000006     0 17190  17188 0x0000=
0000
[ 7676.099448]  ffff8804e50c7cd0 0000000000000082 ffff88047d961d40 ffff8801=
5a480000
[ 7676.099452]  ffff8804e50c8000 0000000000000012 ffff88080946aa98 ffff8808=
0946aad8
[ 7676.099457]  ffff88080946ab20 ffff8804e50c7ce8 ffffffff815ca143 ffff8808=
0946a800
[ 7676.099461] Call Trace:
[ 7676.099466]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.099493]  [<ffffffffa036d299>] wait_log_commit+0xe9/0x110 [btrfs]
[ 7676.099498]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.099526]  [<ffffffffa0372d5a>] btrfs_sync_log+0x3ea/0xac0 [btrfs]
[ 7676.099531]  [<ffffffff81200701>] ? dput+0xc1/0x240
[ 7676.099559]  [<ffffffffa0373a15>] ? btrfs_log_dentry_safe+0x75/0x90 [btr=
fs]
[ 7676.099585]  [<ffffffffa034728e>] btrfs_sync_file+0x2ee/0x350 [btrfs]
[ 7676.099591]  [<ffffffff8121ce76>] vfs_fsync_range+0x46/0xc0
[ 7676.099596]  [<ffffffff811e75ab>] ? do_sys_open+0x1bb/0x240
[ 7676.099600]  [<ffffffff8121cf54>] do_fsync+0x44/0x70
[ 7676.099604]  [<ffffffff8121d200>] SyS_fsync+0x10/0x20
[ 7676.099610]  [<ffffffff815ce3b6>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 7676.099614] INFO: task rdiff-backup:17227 blocked for more than 120 seco=
nds.
[ 7676.099624]       Not tainted 4.3.3-rm1+ #101
[ 7676.099632] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.099644] rdiff-backup    D ffff88082ecd5cc0     0 17227  17225 0x0000=
0000
[ 7676.099649]  ffff88015a73f870 0000000000000086 ffff88080af10000 ffff8801=
4d29ba80
[ 7676.099654]  ffff88015a740000 ffff88058b93cb58 ffff88058b93cb70 ffff8801=
5a73f8b0
[ 7676.099658]  ffff88058b93cb50 ffff88015a73f888 ffffffff815ca143 ffff8805=
8b93caf0
[ 7676.099663] Call Trace:
[ 7676.099667]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.099695]  [<ffffffffa036c579>] btrfs_tree_lock+0x79/0x210 [btrfs]
[ 7676.099699]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.099716]  [<ffffffffa0304694>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[ 7676.099733]  [<ffffffffa0309b76>] btrfs_search_slot+0x8e6/0x9f0 [btrfs]
[ 7676.099751]  [<ffffffffa030b738>] btrfs_insert_empty_items+0x78/0xd0 [bt=
rfs]
[ 7676.099779]  [<ffffffffa036fbe7>] overwrite_item+0xf7/0x5f0 [btrfs]
[ 7676.099805]  [<ffffffffa03ac015>] log_dir_items+0x2c5/0x4c2 [btrfs]
[ 7676.099831]  [<ffffffffa03ac27e>] log_directory_changes+0x6c/0xb4 [btrfs]
[ 7676.099857]  [<ffffffffa03ace15>] btrfs_log_inode+0xb4f/0xbcf [btrfs]
[ 7676.099862]  [<ffffffff81200701>] ? dput+0xc1/0x240
[ 7676.099890]  [<ffffffffa0371d59>] btrfs_log_inode_parent+0x2c9/0xee0 [bt=
rfs]
[ 7676.099896]  [<ffffffff811f81d3>] ? putname+0x53/0x60
[ 7676.099919]  [<ffffffffa032f221>] ? wait_current_trans.isra.21+0x31/0x12=
0 [btrfs]
[ 7676.099924]  [<ffffffff811cdd3d>] ? kmem_cache_alloc+0x2d/0x130
[ 7676.099947]  [<ffffffffa032ece5>] ? join_transaction.isra.15+0x25/0x440 =
[btrfs]
[ 7676.099975]  [<ffffffffa0373a0a>] btrfs_log_dentry_safe+0x6a/0x90 [btrfs]
[ 7676.100001]  [<ffffffffa03471dd>] btrfs_sync_file+0x23d/0x350 [btrfs]
[ 7676.100007]  [<ffffffff8121ce76>] vfs_fsync_range+0x46/0xc0
[ 7676.100011]  [<ffffffff811e75ab>] ? do_sys_open+0x1bb/0x240
[ 7676.100015]  [<ffffffff8121cf54>] do_fsync+0x44/0x70
[ 7676.100019]  [<ffffffff8121d200>] SyS_fsync+0x10/0x20
[ 7676.100025]  [<ffffffff815ce3b6>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 7676.100029] INFO: task rdiff-backup:17230 blocked for more than 120 seco=
nds.
[ 7676.100068]       Not tainted 4.3.3-rm1+ #101
[ 7676.100076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.100089] rdiff-backup    D 0000000000000001     0 17230  17228 0x0000=
0000
[ 7676.100093]  ffff880467a4f9a8 0000000000000086 ffff880806d6ba80 ffff8807=
0549ba80
[ 7676.100098]  ffff880467a50000 00000000ffffff00 ffff88070549ba80 ffff8807=
0549ba80
[ 7676.100102]  ffff8800ad8e9928 ffff880467a4f9c0 ffffffff815ca143 ffff8800=
ad8e9990
[ 7676.100107] Call Trace:
[ 7676.100111]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.100139]  [<ffffffffa036c26c>] btrfs_tree_read_lock+0xec/0x140 [btrfs]
[ 7676.100143]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.100160]  [<ffffffffa0304644>] btrfs_read_lock_root_node+0x34/0x50 [b=
trfs]
[ 7676.100177]  [<ffffffffa03099d4>] btrfs_search_slot+0x744/0x9f0 [btrfs]
[ 7676.100182]  [<ffffffff812c8c11>] ? crypto_shash_update+0x41/0x100
[ 7676.100203]  [<ffffffffa0322323>] btrfs_lookup_dir_item+0x83/0xd0 [btrfs]
[ 7676.100227]  [<ffffffffa033dc06>] btrfs_lookup_dentry+0xc6/0x560 [btrfs]
[ 7676.100232]  [<ffffffff8120209f>] ? __d_alloc+0x11f/0x170
[ 7676.100257]  [<ffffffffa033e0b2>] btrfs_lookup+0x12/0x40 [btrfs]
[ 7676.100261]  [<ffffffff811f220d>] lookup_real+0x1d/0x60
[ 7676.100266]  [<ffffffff811f25c7>] __lookup_hash+0x47/0x70
[ 7676.100270]  [<ffffffff811f4035>] walk_component+0x215/0x4d0
[ 7676.100275]  [<ffffffff811f495f>] link_path_walk+0x17f/0x580
[ 7676.100279]  [<ffffffff811f4e6c>] path_lookupat+0x7c/0x110
[ 7676.100284]  [<ffffffff811f867e>] filename_lookup+0xbe/0x1a0
[ 7676.100290]  [<ffffffff810b2bcb>] ? should_numa_migrate_memory+0x6b/0x150
[ 7676.100295]  [<ffffffff811cdd3d>] ? kmem_cache_alloc+0x2d/0x130
[ 7676.100299]  [<ffffffff811f8241>] ? getname_flags+0x61/0x210
[ 7676.100304]  [<ffffffff811f884f>] user_path_at_empty+0x3f/0x50
[ 7676.100308]  [<ffffffff811ed15b>] vfs_fstatat+0x5b/0xc0
[ 7676.100312]  [<ffffffff811ed741>] SYSC_newlstat+0x31/0x60
[ 7676.100323]  [<ffffffff8106603c>] ? __do_page_fault+0x1cc/0x410
[ 7676.100366]  [<ffffffff81209724>] ? mntput+0x24/0x40
[ 7676.100370]  [<ffffffff811eda0e>] SyS_newlstat+0xe/0x10
[ 7676.100376]  [<ffffffff815ce3b6>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 7676.100380] INFO: task rdiff-backup:17235 blocked for more than 120 seco=
nds.
[ 7676.100391]       Not tainted 4.3.3-rm1+ #101
[ 7676.100401] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.100426] rdiff-backup    D ffff88082edd5cc0     0 17235  17233 0x0000=
0000
[ 7676.100474]  ffff88014d22bcd0 0000000000000082 ffff88080af30000 ffff8801=
4d29d7c0
[ 7676.100547]  ffff88014d22c000 0000000000000012 ffff88080946aa98 ffff8808=
0946aad8
[ 7676.100621]  ffff88080946ab20 ffff88014d22bce8 ffffffff815ca143 ffff8808=
0946a800
[ 7676.100627] Call Trace:
[ 7676.100633]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.100662]  [<ffffffffa036d299>] wait_log_commit+0xe9/0x110 [btrfs]
[ 7676.100667]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.100697]  [<ffffffffa0372d5a>] btrfs_sync_log+0x3ea/0xac0 [btrfs]
[ 7676.100702]  [<ffffffff81200701>] ? dput+0xc1/0x240
[ 7676.100731]  [<ffffffffa0373a15>] ? btrfs_log_dentry_safe+0x75/0x90 [btr=
fs]
[ 7676.100759]  [<ffffffffa034728e>] btrfs_sync_file+0x2ee/0x350 [btrfs]
[ 7676.100765]  [<ffffffff8121ce76>] vfs_fsync_range+0x46/0xc0
[ 7676.100770]  [<ffffffff811e75ab>] ? do_sys_open+0x1bb/0x240
[ 7676.100774]  [<ffffffff8121cf54>] do_fsync+0x44/0x70
[ 7676.100779]  [<ffffffff8121d200>] SyS_fsync+0x10/0x20
[ 7676.100785]  [<ffffffff815ce3b6>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 7676.100790] INFO: task rdiff-backup:17238 blocked for more than 120 seco=
nds.
[ 7676.100801]       Not tainted 4.3.3-rm1+ #101
[ 7676.100809] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.100822] rdiff-backup    D ffff88082edd5cc0     0 17238  17236 0x0000=
0000
[ 7676.100828]  ffff88015a74b8c8 0000000000000082 ffff88080af30000 ffff8801=
5a630000
[ 7676.100834]  ffff88015a74c000 ffff88058b93cb58 ffff88058b93cb70 ffff8801=
5a74b908
[ 7676.100839]  ffff88058b93cb50 ffff88015a74b8e0 ffffffff815ca143 ffff8805=
8b93caf0
[ 7676.100845] Call Trace:
[ 7676.100850]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.100878]  [<ffffffffa036c579>] btrfs_tree_lock+0x79/0x210 [btrfs]
[ 7676.100884]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.100901]  [<ffffffffa0304694>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[ 7676.100919]  [<ffffffffa0309b76>] btrfs_search_slot+0x8e6/0x9f0 [btrfs]
[ 7676.100938]  [<ffffffffa030b738>] btrfs_insert_empty_items+0x78/0xd0 [bt=
rfs]
[ 7676.100965]  [<ffffffffa03aa883>] insert_dir_log_key+0x54/0xbd [btrfs]
[ 7676.100992]  [<ffffffffa03ac1ee>] log_dir_items+0x49e/0x4c2 [btrfs]
[ 7676.101020]  [<ffffffffa03ac27e>] log_directory_changes+0x6c/0xb4 [btrfs]
[ 7676.101048]  [<ffffffffa03ace15>] btrfs_log_inode+0xb4f/0xbcf [btrfs]
[ 7676.101054]  [<ffffffff81200701>] ? dput+0xc1/0x240
[ 7676.101082]  [<ffffffffa0371d59>] btrfs_log_inode_parent+0x2c9/0xee0 [bt=
rfs]
[ 7676.101088]  [<ffffffff811f81d3>] ? putname+0x53/0x60
[ 7676.101114]  [<ffffffffa032f221>] ? wait_current_trans.isra.21+0x31/0x12=
0 [btrfs]
[ 7676.101120]  [<ffffffff811cdd3d>] ? kmem_cache_alloc+0x2d/0x130
[ 7676.101145]  [<ffffffffa032ece5>] ? join_transaction.isra.15+0x25/0x440 =
[btrfs]
[ 7676.101193]  [<ffffffffa0373a0a>] btrfs_log_dentry_safe+0x6a/0x90 [btrfs]
[ 7676.101236]  [<ffffffffa03471dd>] btrfs_sync_file+0x23d/0x350 [btrfs]
[ 7676.101257]  [<ffffffff8121ce76>] vfs_fsync_range+0x46/0xc0
[ 7676.101278]  [<ffffffff811e75ab>] ? do_sys_open+0x1bb/0x240
[ 7676.101299]  [<ffffffff8121cf54>] do_fsync+0x44/0x70
[ 7676.101320]  [<ffffffff8121d200>] SyS_fsync+0x10/0x20
[ 7676.101345]  [<ffffffff815ce3b6>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 7676.101366] INFO: task rdiff-backup:17241 blocked for more than 120 seco=
nds.
[ 7676.101386]       Not tainted 4.3.3-rm1+ #101
[ 7676.101405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 7676.101417] rdiff-backup    D ffff88082ec95cc0     0 17241  17239 0x0000=
0000
[ 7676.101423]  ffff88046cc8f9b8 0000000000000082 ffff88080aefd7c0 ffff8804=
7ed41d40
[ 7676.101428]  ffff88046cc90000 ffff880665f385e0 ffff880665f385f8 ffff8804=
6cc8f9f8
[ 7676.101433]  ffff880665f385d8 ffff88046cc8f9d0 ffffffff815ca143 ffff8806=
65f38578
[ 7676.101439] Call Trace:
[ 7676.101444]  [<ffffffff815ca143>] schedule+0x33/0x80
[ 7676.101472]  [<ffffffffa036c579>] btrfs_tree_lock+0x79/0x210 [btrfs]
[ 7676.101477]  [<ffffffff810bc270>] ? wait_woken+0x90/0x90
[ 7676.101496]  [<ffffffffa030997e>] btrfs_search_slot+0x6ee/0x9f0 [btrfs]
[ 7676.101518]  [<ffffffffa0322764>] btrfs_lookup_xattr+0x84/0xd0 [btrfs]
[ 7676.101547]  [<ffffffffa034a53b>] do_setxattr+0x30b/0x440 [btrfs]
[ 7676.101572]  [<ffffffffa0330a92>] ? start_transaction+0x92/0x580 [btrfs]
[ 7676.101601]  [<ffffffffa034a90f>] __btrfs_setxattr+0x8f/0x100 [btrfs]
[ 7676.101629]  [<ffffffffa03a8f57>] __btrfs_set_acl+0xd7/0x180 [btrfs]
[ 7676.101658]  [<ffffffffa03a9138>] btrfs_set_acl+0x18/0x20 [btrfs]
[ 7676.101664]  [<ffffffff812481e7>] posix_acl_xattr_set+0xf7/0x120
[ 7676.101670]  [<ffffffff8120e429>] generic_setxattr+0x69/0x80
[ 7676.101698]  [<ffffffffa034adfd>] btrfs_setxattr+0xbd/0xe0 [btrfs]
[ 7676.101704]  [<ffffffff8120ef21>] __vfs_setxattr_noperm+0x71/0x1b0
[ 7676.101710]  [<ffffffff81286d32>] ? security_inode_setxattr+0x92/0xb0
[ 7676.101714]  [<ffffffff8120f109>] vfs_setxattr+0xa9/0xb0
[ 7676.101720]  [<ffffffff8120f290>] setxattr+0x180/0x200
[ 7676.101726]  [<ffffffff812060bf>] ? notify_change+0x2df/0x360
[ 7676.101730]  [<ffffffff811cdd3d>] ? kmem_cache_alloc+0x2d/0x130
[ 7676.101736]  [<ffffffff811f8241>] ? getname_flags+0x61/0x210
[ 7676.101742]  [<ffffffff810c249d>] ? percpu_down_read+0x1d/0x80
[ 7676.101748]  [<ffffffff8120f3ba>] path_setxattr+0xaa/0xe0
[ 7676.101754]  [<ffffffff8120f5b4>] SyS_setxattr+0x14/0x20
[ 7676.101760]  [<ffffffff815ce3b6>] entry_SYSCALL_64_fastpath+0x16/0x75

--=20
With respect,
Roman

--MP_/768qrIKvm_fr=W2_MP_0Z5n
Content-Type: application/x-bzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=sysrq_w.txt.bz2

QlpoOTFBWSZTWfKx68wAqqf/gH///wrIb//1v2996r////BghB98PqK4A73ztpfbnGKKH0NZ7OE+
Pe3vPbHvu77hHhzx61cY+wHysYwpKZ4epObCVSUe6vbJ8PXWe6m+3qd3PM+3PvcfKeuu1UZRRVAo
FSfZt4DD49luvoAaHoAD6B09NB9Pfdee3TVnMB0FAAAAAE9t6pm+xodsAVoA0Dj4WwPad9j71N9g
AA6KrooVQpHtnIvnHSgASFVQKFz7txvXLpSRUKRWtArO62fWJPe7rtDXJbABIrQp05W+7hdZV15e
7Hr2qhnuqt13dZi93O9nbufWSnpPZ9eXp6wu2k9dzaFZb2rbK19vJWAfTeFJFKkIL13oJdNAAFUA
KBSgFBSQkAkAAUooAKEgAAhqYAISIIknglT0QDQAAaAAAANAGgankGiRJI1ENR+ptUGgAAAAAAAA
AAGp6ZAlCU9JR5TelPUehAGgAAAAHqAADQAaekJoSKaU0j1DIaaAAAAAAAaAAAAQqEBCJqap5MBR
P1J+qeUekAPSA0AGQNAADTQKkiBAAQJpkNJhGowmiTZNQ09T0Rp6NIBtDU0ek98fL4fkvD7Ps9qI
MaSMqCSfSofvQiUADUqcASIQMiOJXEL+uVXAorpTCKo4kFKEQIDEJUYBBYFEJAhQScKyiAp+v6d/
05X+kB/2A4FOADj+HMsUJ6/ax/UubaqILtxRQRAAECVU4ooECAiIr39EqywWimDbfDq1Swa1h1ap
aqmDWsNFAgQERFU4ooAQlVMy5StIi7cUUEQABAlVaU2WCAAIiLtxRQIEAoiqcUUCBAQoqpmKGEIF
BES3EjoiKoZDOMObFFNDIZxsZ1ZpABQRFC1TiNfNqqcRVsqpUKqcSaBAgi1rS9dD/z8/7PxplX/+
dfs68LVr+Dfx4v8m/1aSXAQpVkgZa9EHBn+J1rWteeKMrhIYLu2Ivz1fCPKNy7UkLKSBsY6QcGfb
GgNd6oiz2XoFoeumPGFvPouscBi8IG5jwhAM/K0NADzyueeEia76U16qc9P5v0mmWKuhHgMEPRCQ
Z+s1rQ169Tsqgi8BaHEGedXPK07VQtiMFJjpCAZ9sDWtDvar0D566OBU9OXnPUVygPVb3smmwgIe
iEgz9XrWhr16XC86l6U+eid056acbwi8M8zARg4MeEIBn5WtaAHnl33fnozFvxOswj08bY4Lz0un
nECQY9EIBn61wHZJBeVIqhAidAVERJIOJ+knoUI+Qvr7L59HJdn+xNDdUEZdZYjJgV8K65Z61ZO3
S7NCAj3RsbV2Cjsxl49kHDLrnVu8s2z90vwoS2/kzyTL+Z4rX+fmDQnP98yaP/689N/8t/gye3XY
bqIFPHR1EnkQCeWjqGhEdeW/ws3HRTyrB+ku7eHDQOrfBNDa3Ra2qFzOKsOGNucTRYbhZlIF6Jxa
6gZuVU0ssknMuDuw2XFKli5blTpFrdxEwEZuNJFEpRNMaaxZj0ab2QsWbm5U1qU2subaKRaWF1qM
txmVWFTLiQsgFlORMpURTNtt85223/BH6R/igDvx4uuXIHlcfpx6mh+cc+6/qN7H0XeK4EYR2qUq
Wbv8e3rzKOmAVquBDq9ndIyO6on4t41CA9ZJqU/4N73Xg0ND8ADo5cQE/VcMwR2ev6uY7TySI22O
rNSEBFJXTuovwRLVVlzOVM6Jt0szTbqMWHZWDZ7tM5YueTip1tHvdIJnJqr1q1IhbdrMRNF2zbqq
1YGk3jtzdXOnLNvA712ts4xm49yTmXW1qZGQNio86Ly+3m7jfSUJJl3uRSlvMaioxorIu7ZmMLTM
fP+55wAceF1uKDhu0jRu++N3zyE9OQBs66q8XKtVtRAqIFPIWWyrmdDFGztLXrhFTAw83IAhmk4Q
0PW5NcJLXJiFGBrS0sJPN1HDC21R1ZuwIBll0pBDWQuOG7M4tuFa3JgYoFWnNbM7dKW0NPHcVr3K
yCKxd4B+k84BGEEXUXYA72A1HO5TQYkiX4Tq1hkKGZLsRu5cDZlTV5d0WhhEw06xlmdjGgb2LISm
0LaCbEG3WSCTyi6eKQbv6usDhvq7FBhwz0ESYaEIM2FPc2ipJJlKNuOTmAwdp7RTnFWKcU0SWsih
eecHB/zAB4NDWhmQlCjCiFEIFtG7Xlzhrwqt5hqZzaynY8Bo3K24vM1XsWFzgVZGkBEPmxMhHTwU
axc42g9nNw3l7DYsyyhUFriEtiIVZcRlMEVe7M6JIxBq7u9KuYV2XoikMy5UhK3apRtK6qRTqRHq
OymlpggcMIBnSB2ZjYYd6gyADsAZUaRwaazqFuUE3giQbK5OmVOkZdYgSNojRc6qeRFc4baSaFAK
LGQEjIIJLJDbenDC9zEolsRu5tC4WbEyEjHCXRJkik6QpiQ2jnOFpoazBxIag3jaDeHe7uK6ICAJ
klI4QEeTlQLxDe066e04gvVmpxKZsZcwWcPdiEtgA2u2FaVKtQze5MWck4VOzqqLR1bL1NyblDKq
+VTiKhhPuYn2t2byVj2xNI69dxlCNM4XCy4zZ2szM3ayhmvakqtmsW3Gypq6Tm3W3Ss0hmZAaPJD
2bdGFRvFhdOHVPIWyG4whcHTyyMTiN19qmrpJBcgpuAwVEjonhJ7mTzXuZ201zurJ6MtdvBaggOY
dFR0QRsCKVZ6Uxtlljiyzsf69g3E/qFTjUl/4C16ElUf4z/Ks6O7+LGRPkKGQqIYiwWkh6CprH+g
wD1jIRjEyZLWWWMV5cTMtSiRy1LaiGSkvxyFXPwGQ1MemqSDQGCeQLPSmkmiNG9AUMF8gMDAZCgr
XV9aQkd/h17+3wYDuQkvTgHxIs8ohIehNYipxhKh8Z4aW0I2rrTqbwPL26C0QY183EaURDjbsqK0
kyuSnNadwTIDKiMFjczbdbiF1dTo2rmcDJDpZo3OkRAItrm2kU7lpLbrjcLm2HBM1agIQScydoMK
pYqIWJ7CMOpG6i5mbgZqK2Z5R05q02IWFU3OQsTm9nHW2xT5mjaBTOmnhgJPaqljiMSiNiQasTk0
zl5uZcztK1jpXF1D3HVF5c5DdhfuXUZHQzQjBwdnZns6OTo18AfucS+N9nZDEvxfu3fqx0SECISC
T8/3f5/P0/93+4dV8fS+8n/Cfmf3Pgx6bg+4Pn13hEF8/3qr4UKsQHePIsK1tesYkuTyu10FdDd4
ct9y6isRepvG4TtK5b0C3F2QeFLIUlnq0mOmmebPVK8B4ST4pAk3cLcaf/cbbaNNnHAvS+eKaIUf
YABa1Gx8fp+nkfn9DDp+ht+n0Y2NaxiLMa7ww6YbZhjNDGMDXSGg37kLQT9mpmdUDATQA/Oh6L3/
+ZTwP50DKv7WaflvhfHEl/hvSpmHAw8gWZ+qb/9fX9u1/WcBDUmNyYNBpdD6M9a0PC4QwuD81K5a
++tnb0mnM/jltw552kyqQxaaXXqIN+WOeEknTx7vHykx9nna6hRISVKREqqRTsFSPjuFoYV/y0+1
GCQkeokeVPLd77o9tRzKPvAbG+EoOJANSe++DmvlvlzAa1hqxgAOLbnDmXmNScyCZIeo1FgecoG1
qTaECjFjbCI4kMxnPPGbjZVOZDXON4DbWFPAikggvG2/HfXfduXamb6izYaqMGuM1zlGthyRd2Rq
/joKsNzCxyjVJVh7jmzUnJlUtV8XFK5azD290uUnsLLwrsa5pjo0ZLeXu5ViXVKb4ReQO4LvsioS
kJomqZmJ7sMT3FMkVYxNYHjXeqnlhsbYzMylEG5mQ67fb70xWFuJnTVNf3sOAtZiOYu4bCekVVUO
cPllAuJeDqH7CwdnGODrTu2bGRLPbSQywyQ6RkbkQg6JQjKk3fb49G3QzM1WQR29FbUOb2Yxapix
IdGd7ciOceK0DGwscdVI8yUnUztZB5ErA93atXHTpxjbZs9dipVqGEKn3gsnmX7y7Sooqgj94OfP
O2DvO+2u9ag8F4A9xVCIYYUr29s755/L9H1/lxtb2Pb159etz7pxAQqiRFERMkxNNUAQX7rz5Ak8
AJ5wmvVJJJJJJJJJJKm2JmZmQ22w22w+cDbYYbbDDbYYbiIbBIbbYYDbYbbYfG2w5+lafgfXqB7E
ewk7j5y1LANABgAAIAJ++fwfYPYfFUhqxr5fltj5Y+jnH5f/tuY4KSkIWgogmqlKQhoYmJhWhKEo
iAiiKSP4UMGCWQhHdJpxKtDioKKKMAQwQEUQmGKoxBSrixYWpKoKoMWKqrFFiKUcREVQESUhVFFC
BQrEAfyCoKmETGcIGIYlfxVALSoihq6iyN2CfxqS9Ifw4xHfhJMCiSRNaHHr9twve90L3vcS973k
jrRKgaBpQ/38DKwkNXCJ7hImQy+RSRZSJF6hYUiklIW91E8JB9cWxMoTJGSSgSoaoQJiBAQCChyO
RyJoI+uORAmhAQMcWk0nF0lMkuPskBGtQ4/UWqlLQrVP42p0pAAEAX5IG20RBUExnsfBJLw4XAJB
AWAKolDFMhQYMYApwBBjCmEcDBiUcUBgDHkDJkyPrCYFuUpCk7KLniqkytw/u9lpPSpHj1PRNn55
e0fee5Co9eGX2GJlJrTJNV9GEjelSviaFzajC1PqNu8wjWmMI9n1psLpqkxtJvTOOGvBjhDMbZNm
OJlaNcYmeD443kUwOX1p2HfAXuoVccGHV+AaDHkYND2PoOV26pUrFVjdIttOHHj416uHu6+fy/OP
3hy/V6050fUw22Oo2+/tfAHjNap9tSSdwqbxUPUZO37lQ/HP4AbnTaH1jPGTf7uDd4efvqsuWPsn
nm6IwBl/mKff9u3QGziHpeFNwfz27swSTxoaqQ+uoxqHnUIXohlSedJmBXaRMSfbIJmNRmcw8TxD
jjBqRzbxiTXGAeYNR1zgHiV6uMYDE7wBhrGyNGFEZcymihu3MUJZbXBDawXKmS3sdtho28nVWtC3
BFgWaKs1OCsoqduNsRJSe2aEYCRVK74hknWdqClsE1dybtMhFk2kpvJk2USQzgxCSJlyrasZSW1J
UTLRaCx5TvE4yZqIgWXIAuv5YG9iq5p4aGxuqljaUdGKRbykM2sUiSL2sdyDRpRU1kbVbgQjNku0
EOgLDyjpyTiyd00qdvHak32g9qETiy9qXeFEyK2JmotowaIDpaNQsTMUDRQsiNYkbuNyKSLahRZc
u2FdbNaWJ2wze6pFyTGwHZT2r18eqf4nclqrrvOmNqxi7EPKixDQ07kmIi7JhK8yGgcIbLVtSRen
K4OCoIQPMAjtCp1KhmUeIReNsIA8wiJmVQ5lzOZA3lBKEVeoV4Twc5wDkTspYi8esUruJc46ZmJg
66uoooIY4gy00QsGwZDuXtDMkQXNMytClzaUSGgkaBeFJh7tIbN1T3MO0nGQtRZRGOyrEmsukVm1
JeTV3Qt7VOg8zNgmGsWRNYWTU7bLu5u6l0atwCGNsTspSzNoJSwRu5hM1AyLuMUEnaGJIxlGFTiC
oycx5TOyop8KW2LSeTro2osLYnML+4GozJRso65M1XaKF9yZBHTQOCRiQzbgY3oyhtDHdaRvNyr1
SmsQrG9G2DQ0bB0XbNZV3OxcLKyg4FIurw02KFgoi5uWyohClgmskWkpEOm0Lg2i4rM2aQsqkDjj
hu8niDLvKLkxqe7ZiqV1NYBQk1zHjGu1lmowbo3cBJLncyjD2xmYLdONi4UmQ71SjkXjePNeRCyY
KoWaDkCEzbvYxQMlVomXZtBKcpGMlqb2dEqOKQBt5SiARtYN6ZDI6kCMxGWIhLRdKdEpZcvuQzxH
Ht7OCsYZRDdxRZJCuEClUTXK28iqVzURjM1cGndlVy7atEoh3du501VpjjnlbG3mDkdbAe86Fgkd
uMkLCqfqlVoQaRApUaBUpUaqSCqgPf4Z+BqRwjtOlvLbNHCuzllKq8xn85gz86zubKbJnlOy+fXk
e/Ol+rXnn6dYxjGG27yI9q0P0AIAD5ekuQfSbUekvXySCtDExmttTgmrZvMSkaJnJNqWmm44G61V
VVeQPGfHt2GI4miejxGE8CHnnpE49eBDr3Ctzz1xVUB1tz7Z8ZDyHB6midvWOuF62VaqNm9u4Y6l
U2nPnl6SToYYYfnwMMMLxe9+7AwwwvF73uXve51qRNshEa77OUw58eGPLPjC18KX0759TMHlJVIH
cqbZdbn197Q7lNl3tcapPfTDOTIzHMxCnMpMoHcuthdbfe7Q7lNlepxXLNm0HdL0i6dub2l27lkN
Zdffewh7lNlAwizHLHzMJDyEGC8LMcsjLxDyEGC8KOY+5QqDw97Pe4+jvZMjpMNqWG5Lo/My8zIO
3t1ajxzd3dQ7u7M8SzXIyieZLopOzi9RkC/gb9ayakPMD4h1vhA3laAoTRr1lD0D/XaL3+lrG2ho
8wOsQ/OFbLLW4SqnugAQYtQJqL+K12AfAvDGFbqry4611ZMuwuSQJoLgG4tIGEaQOQQANLTgNLgZ
GWgcQss0IUZMyQuCsiya3VKjZCZZAKhKxK7EZ4wb24IFA0qUJNBQj1xzzm1+sQhZt7EqhYRMJPT6
UIFXHFkULUPec8WCg1OIMVAlYgHMGYaVoCgO4MSncGICkeOY6zoxk672cS8QFkasgc08EEKUOD4A
Lve5vYhRWKKSMakKrrpbUP/0KHG6LEhzqeUu+I9+cAHEeDnOD1K4hR2k1KJvKKLwZz546/DztG/Q
cwkI6BtujMpnWM5QQkaCejK2HyQ6gr48GvZVVVVVVVVYwze2DIBkMYRDb9qN+cKtxzvEK7J4uHMm
f0sszFMvLmTO4ZYJmJoiHMmeVioj1TZjZhM905kz4oVVVQqqqhV/Df06KJNq7u7FEm1d3diiTaub
tWKJNq8x+hO+UPYE+qaqmiUqbLfacmoA9lCEFhBYxnGCew1ucf7vb5K+Ioooooov74IK+0CBx4wg
OpQ6kHiX1Kfnth8XFEi+Rz6Fqq5UyqFwhWQrQosWU8LRHgjzkxjYdIwTIYuba4RpHbaWjYtl9eaN
2wlGbC7Onsos8qdQgjpCMZHAq1kypbas8vOymOqOTvIHTTcLYIcQEo5Dhoa1UyXpNDQZIcWqQiM8
7ZqstCxnWd6qoIUde5UJJKyIXCltua8viuoha/QctQ4CYt+NzF3m1rGFBE3ING2fgtynBNh1nJ9h
jz2a0Z4Q/jEdpoEF/lRPoQTbJ4QGgfMjnAY8jWtGiIBonR8eqkQCBlBDQfobAT5wDSAj1QGec5hb
yrrp7ecFEcFkIharO9tQtCgFbiZjbwfdu0u9aWyFIlHNuFeTK2oFNuECg01LcZTS2RGmsaS1NOWo
gIhdIhMS0S3HMy5qE+viBHNuMlA9CRMjCgO7i5zsYE33K6Md84ORdi8etthw8niKOirQgd4SCdBK
C4ThHYvr1hi3jBnSJMzt0rFbeCWiil3vdpLV6cHqAQPCSNPZnlvME9OBgjGtBEy57mc65rBZ5OrI
S+gJ3nOYJgxQJWp2FVR3W3zqwGCPEZg66w6yKgqYOtYyIZwHWjDjayecdIZEtDmz2ui9MU9OQBSF
KirIMTTHWLa1ySXuyIw6a7Zyp63Ihjnb3to2LEHTBAkoFZLedYMLARBVIaNxXItKyJGMjBZzjUd5
mkCNPiNCom9o5fdZBNShJDNHmFU6myot8q5mEXitiL7sjdd2QAKR7ta6Ls3pNpb6Bru9LWMG9uRs
0a6D2Qc72UzzItWm913Esh5hBG7OkYze+YtXMSrrLxysERwlvO5Mjx/TEJFlxYoQTAAq4AVvUPBF
g8GRp6RxJITlqxXhRj6OI8EzITAhB1IATd2O+JvM5ACs2gWJYrRQA6Rzld3VhIkCYcLnLD62ADPT
NMp5Aooc6ZuToAIjJKiFWamOcGVcAIo8A0bImrraoKa72lGXhFeYFsnqsd8jRgyF3e60PEvqpVBl
wCUvA5xjm8ArczH3VLBynkQxnjknlObTcKzwZYawxFVQtXjYuPBtQZ26d0epCcwixfALe1h5PbOg
nKGXwGVCdauwu3ePayuMLG5g70cDoTXb5wRtgM8AYB5d1TAwpxnSq3ldja22t4FxyMXOZbTHAVEc
O53ia13lvZD2dpoxvI7M2QLsVVO5qZtRJg4Q0kNTyMmsgyylc8vDLC7xJTF5vYi2cZEczvRyakIP
sBKOPBqdTYLCtoLFjMTzD3buje970oOnFQdmFW91XZqK4Whkh5lId4uQ8eRSuZNRwARbjdMF9XY6
ogYZrJDwXWwgcxze04wNvdLarNbdTDm8U4bN9wDuaV2by8miMjSslRsVsQBGTmdWZu6Eiu8MZ3O0
GJCui+UpE5mPtjThBN7lsbWDl6kO97wgk1SHLaghi0eNpyXs8mZDzpVxWxIuq9HE+tXMrB4OQRki
WvM8suAxZZmRSGbJYkZMjPDzhocqBTvqQdHIZo8uybyojVeVrEhp2w+xPe9MY5FhVnWl3e1x5Zlx
2i3ByCpFLBGLN3KvBJQ7VxJ4SAoqOCT19sNjOAY8EiIgZHgrx9b262VNBAeKSADJgryyHpGZVyq3
it6qc/iO5au2az8Nh4Kfnw1fscDANnsAC78lTwATrYhbFFZ2TWQbFnnaQPUs73q7wAIQenMR4q2O
6Qg8wbtjqjsVgqlhZAW6tztC9MznAdZxuiiLiMq3wsdpCzybzuLuh7u53VzemVNk7q2SurRPZujG
TlBRk9cNuqUhWEnuY9yN3L6LwI20GulQaigpilHevvaXROhvI5mScfQNPZy9czO9M7ljgV461Zuh
uE9oAPael4cChXfZhZVK6TJgqc7S2OwqFDvGgyHLrtZSmVRmRmPqdQoA5hqUksHZDpNc4L2ILmuy
6qsjZNE8S6N6akMpMtxq7xns2bNLZ6r4bb517X2HLC45wsRWaRdXK2Y1wEXA/SABlTq0nO7JUo3c
306bhVImqtPSx2RRFTT6+bnZ6KKKenag1Obeu0GQkZLxKhLOTyKvNWGud+a/OMRNkF8JzSo2Fy0h
xm7OXy3HF0nHkMpx7bnzRPoE/YsDQEKQ0CQSMkkFCEBDEJLAMCEoQsksIzCQwwQoQkUDKwyyyQhB
EqzDQEhCMAQQJUKSsISMqSxJIMiShDFMQQEEpKwBAykMISEuQz4L435+472z76LfB8tW3Wt6B8i3
B+WOvVAv5yfaw+Hw+HLSm/TWQzjhJZ7YXhhvD3FU7NTsEHMysq2Mymu2bna0A5CqQ3IRb3Nqrqzo
vXq0YLoTFahjsxsOXhO5QyXbxJXVq9MZJMFu5cS4gXChMsEREIlTeP01rQczqDQkfUlX1+4v6Bbc
4zOLaKT8z0l8ZDfGl6uDyECiil2OlY0U3pzqjIEgIMT6pVMZZaXRf41AY37esTYN7xdtyGWUniAU
gY5niu1D6cU3ysKTIcZCCJaWnlZXXzRC53riiMIdLsLIQLjO0TvVQNGkqPTe7onLSBlkrrqHjjNI
vsh11meodhw4FMcoCebznzjlgPg+xGm/oSSCSSSSSUjh4w2jxhxHwNa4v8Id9NzX/MGX9HsF8lyP
6aKCA/kD/L4vOfPUVz6wh8LsMp+gVQvBg3+X7ecfL1etdO/7Zz+n2FppSaYzJWO+z6YIPSHI5mOd
jXCAOgYws1WvH6/La7iiyEifBcdN3fq1V9L533TOe9gnr8RsFkFhptj3RcDLxniMDdHeKArENoea
3yxXXQhoztUjfa0OXWmKJ53nQrJM5J41Q5xap3jtPBlrAFsY0LTF2cacDRa9I/NnKBARDrL0uLY9
kBrX6CgGjyKqYePeU7EXzri2MMfj4NHc0I0MqLZLz79a0eHv9tj6nhR59OO/G88AU5FfEhMut1Le
7++d85uJR1vlqLyIiJ2pzcOOJTWW03c2y35G4XKug0rLIY71t9biedhuoGw6nc+Ao6uJ0uec7wcM
H13vvhBPHsUWZtFUzNkTpy4jb8V082jKcmZO30Neb8kz6gSFLYY/egoAH2AWhrRjRADWvA435Nna
j42xBAv0EIIq2yff+c3kkT94Lmz8PuDx7iqJ77aHPA0PrfjGWvo+fxjXhtWQ1M4j8oy9rasy6TJ9
roaBVv7WGsyBUOGcUoV22ixKbQy+/E5XA7oG8/Bi0ZMUr8d0nd05IS8Pvhb2sTuF84bFr1IR92gP
IIuYaoZ9E1UelrtUVmQ9Ot2kUKUpEJhPHieuYi3CcMWfYlxx+F31qXU6qiaxBffg7MHKv9L9BwAE
PqtE5P5A0M8mS+Ci/Xx8MBlTJyfx1veFSh6Ll8FwAmLDSr5R+2MbujJnnfOfPM1dpmqoEGI9rm40
3ZMiL5zxunzcJSUxxItQWG6e9Uofmt1Zpab269TaLB8ECRcCCe2bGcvtdYxEcyk0TbQsgnxVTKBw
sfKkBLyFEF9SqQyqmvWqw9aHz8/NfOZ8htA2F9wQdwJ9u9+jFKLyYUPm/EHxAe2bC/TQ0Cu8PAZt
oaEbi+H5zwePGH5Z/JLJ5vfXd8yi92nuJXnt7RagnUoUI8eLx49Shtcx7WzGNasAKMjmZTvNrMQD
MhRtbD3i95C48WYf40CLG+SgMZGPAIu2vfNoTlXsBhotDCArK9CPOD1apsu79p48c5TzxlLJl4RM
m0biWVxie42zNRcC0NxLqbcu5nbQKeiI9lmzGZGQdAKZiK5zbSWy8KC6O9JVv6q+ht3M9VfD2T2F
uNt6pFb6H9QFDVz2ZcMb2sT1SWInhYsiXme61s+PLhs5Xzvt1dk/CuuMgxIRiQ/saATfGaixENpe
nmZgJ8Ipr82RnLV+PyabcAo9baeSmV+Bm2Lp48NskY+ZzaOOF8X2y8gbXCLR0fTG8SQ9Kch64qSy
q0zO4fKnlsN975YlLIwXlNCg+l4K22hov7wA1mesJPDFtyfDV0koUNDejr409x8yT+8Im3EUGBQX
yAPBpCGep57DgvMncfLiyHzHwsglMJDT5Gy2XrtXppDqATEgeNudb9+sXD9kJzIaqXwSnSAELzDD
ktfHjHJysSW7jQCxyo8mRUVsz1BaJfG7A5jRFMLuXMC9GjXif1gSQqOEvOGZPGutR677uHShpIj2
JRR0UeaGq9eHp/CvNVKXh+INMWjzxP3QwGBM1lBYeBJn4dN9Mfnz863fx1Go2DdZ1Jfsf2AtL7nx
BfnjJTb/LcEP6XrFBahtaEApQBQ5MOvRbXOTvf0dY7Pq0PGr59Y42SfL9CcTKrLbc79cuD3Mer6I
z7PWghCCGiXx1hn7hqOZx+Lm8TB3Y4jNHE6jil4ffFlyt7BGaBuT1IJgZuxZM834vTi/yyWXrDPc
Xln0VZQhQhEn60aTcUOsbnexLhPmP6E79JWqWJ0XqqlodFkmn0xln0Pj1VnHr0nyrI/q+uU+mj6u
01Knin72j3ZC3qorq+TIJlXbncmfUnErvH6hrsV2C7KYubPyJuuEqSNg3YZPVtg+usvGx4eoGUeU
7wgBlxqDd4rPviukd4ZSWZR3X1nq/OWXpcxrwyvsw3VgzvVs+RpPA0NSbEwk4FRWpq6i126sGfM0
KJl3OK1FUYsKcSqBkejWrE1MTkTH2wBIqd1whhL6wWM702UMpFTtsy62Yh1lFFyXKoOdmg8WmG7W
bs0YMVFUZNHOxx2/Z7CbbhO6ZwMt0ebI6AORcLLt5OTYxFuhvlTyG/kciEw6IBSn6hxYcT8bc264
Rge1FwKUS7+hJI7iP56aUdbvWrqvbyv0VeeG9L1KNvP8Aq6emCbweUO2e0XtNWKTssRNYYCqyMva
nHSelU8iIybIm40VrqM0W6ymFodY+M1e4ROZlvKwOsgIZVTct7Oe84OACZil0jvbylSWBdQ5wyAO
kMCCCgQrKUozj+0fWpJM2LlBaGpXv8cWDWYYcLHPnYNZlRcCHw0c41hShz+oDu+j8wD3rX+J+ZXn
vxV8wuX2ZgISr4dOamU2HMEyUpsNkwF0djuSnStRbnFu6XmB3aF7mOdM1sqJ67jKdHUmO9TVdJJv
pU13j7M5veOUlyDweMfoE+rHjbrvQmINSAfbG0lK+pXEAYkF9pPPGENQqttgX2JUL7iykeHdZ8db
QLZaItEWiIfz/Ub5qenrm7pP1/H7+7g1MaMwB8JS/WtP6JB+n2rhfs+Lwm9/expAvh18RCmhiMe+
Kn63F+0CWQnCre4ctmdbTIgBCyl6oe4MoU8G02pEzX0gzYXvZtBMhJxOMc4YYm2+XTt0SgspKzMs
BZMXMDsaO1rNaqXlZIOl6Iy6Q0w0jwhoiLiG3YpKQiOj+TEPsBDptIeYzCCID51rzO8sNoeuv0p5
YS9ohlmO1GbFRwRqXYvwOGexCi7rtybxr6PdyHLeVWKV8HLd160aFeWZyhG9bP4IMrs+30t2XA9T
Xudxl5dWgKG+HX3Gh/HWk/RUs4e9kLPQ0CJwoKerEKwT5MxCh1BMxq7taGBk0fYn0d5edGiaH+AP
YbL9Y1CqWLAb1HJN8pfBpCU778tb1fJ9fHI43e8UkZy9Ebjx3XsdhI8QEUkU0C41b23a4NvxebQm
N6NZx4YoLL3xdMso683PZhienJP37Q3FJ6ry8I2pcD4JYOwz6NjmS51lSgJhu1RjXVKXRyyFvxcR
Xhdqzsho/olZk8PTy6S52xwgvA9naGLPFh2lGrpdOT2w1JMQMqxpDs5Ci4UyZFpiEIncXO9ExBXa
C32tnzWlOQXASdTzQYb0QCxUQXaa/QMLBT++OGJipITegBXrg6J9nXYcrQz67MyNCiJ1qY8KLMnu
LpeJKPOK7RUGkn72QSd5sGYxyWNSQDeMeWmIM2tPfszKNF9J4K48jbCQaeQSB9+A4KGvhN1/Hr1X
HhClLsb7c5foYQqmEsv6rqGX1uDVXVHX9ICJU4xmcYVpYaGHLtG+dKpxOaVfQGRJhAPSE8SELRKi
YIRLG4jaBmaHow8uH+4EqfyiPNl8BNv62dz5RiX+e2sQj73GFhcfzlvl5xncws8yo6TJtk3Q2mPF
0r8nbquWcfjTNbCaA2SWWxnqtyb0/KXZ+uHbCPDSu0dyTq87m2eJEwX6ehpgz+03LJWWDkl4QcMf
y6yzUc8izaKYS0dj0GO8JpcuSqiXU0Jz17+IyZSh1R8Xi+NJUrkw7fSHqjrwqgmrbXPni98aZogm
yyTFFULSUQRI8NErcn5kXBWST2bJK0dEpVMxGTEFsdm1UTxhhOjz4rpHuODg7MabdGE+9aBj01U8
m5PtQcLckC+Cpzhqww5xMFXG8iW+L9Ve5jwaAbuMdbNty+WXJ+GFxTZfcGBiCkRtJx14TZ8iGmbs
+PkkLINzmzjJMXnHTZ7+I1JXZVGcSwfGxTqisFTEoZmspN9sdmYESJ05mWyYm2cez1tzsr8Lliuj
lbfpSB6A/nSBn8u92xRtTxkg0ap1oXpJhaNE+EW/vXc+Wf1rwtHiJs/ZssD8s3t64u8M9m+N73lE
Hw/et1lQqNO5ekMtIW9rWF73Rs9NRubTzRpHIoz3uMhzmAPnbXY4cypP9Ntu0cUm2vZ8ainaQZzi
oCdwjMzvgZJRmyqqXJfkUGK4OXmqtDKbzYbAW9ro6X7fck17mbvkiXpZCSHtEYhxGqoN5k5JpSJP
0TjIul3npB88MQWhVRvG0FL3LCQrji90BUcvLDq7JBxBL3HU1akUtRLanFRjqJcI+3r+mUBBRmSi
g5D70p4B/QCzX9AP6DWbBOdZukNQzUyYabVFUjqHohMMlObfyAKpXXUN7uV0S9nTVNlU40KsMq8z
NKMRVmTajXObTeYM2oVbGVsXkAiFkzkVO4kkpTXN+rs1G+N8d08DWlJM6bzfDiULrFAL6v06+FFe
nQgHNrh5kMTxNVL+9U6wZ0YWVedcunRgSewsoZmvZRJhqck4hJs1kxrwxWzO3iJ1RVGDl5lOkcda
NtlKjk7SqJm5sLNmpcVoKXHbMvjOEZWglhEOou6tZOBhbCvToew2FKPyz3YU2LyWe5o+kE8wmvJV
0bmjNZ+Y9TWRgWzuUZ7OeScTOvK2adYnMmLFbbmnVyVMRIUFHDeGH+vhXHwaFAfx+f18eKSQp96F
e4MblZmJMIcAB5cziY4RsvbDNbGbLc6rePT5MkpFOXVZJU62ZLQK1RTnXJ3VT7jvu4GQSFgnajrh
DV3Bakvlbk5B3WTVK64c10WVayFC7pRij6CAUfVARAyyHma2P7COGYlNMNSrmyEwWR+Q1zssoZ4O
b3J+s/s3qSInoncGhdaY3visrIgQ9m83hHEGeQZFiwZ6mHf7uMcBtFrWifEK744aMS0razqSMmOp
b9+eQaFX3Ft+pjr1OzcY17e1v1mwtFDFO17bxs2NCJS8JlIDTEB/A9gDu6Hhv3jmj0rfLAK25f0U
3A6joeOlon7hDKWaD0jJWMN61pF9UY4w1GjUKWjQ9aP5L3vChbPSDr+P8kykDIWWVzC68EUSY+SR
lT10qPttvYO9UZ7IQc4Qe3b2MI4QQvJcJRgFI9pJV2bHc6XPzH4A5GvqynUQqDMKMmn49ow5FVss
xsP0lV+JFoFJFGwOnCh3WJbdrEMge/YAt5uK3Lo72HJL9gI7e/CLfScrffNvZA93VG6UYiaQuM1N
rUq6MJf3bAco7EUNPWyFGsxj+8zCloJLaYs2CzvOPbsamYlXqsApiO2Rm5QLJqqlCRofE2HjJFw1
o+wP22b8sIh0YA4DPOeTTnCQUyW0C+ws3Ax0BqilVMrFb170NDMcxSP0VS4wyTfbEhKiemNYdTUC
yUzq8tDKwZatqYzzLc6ya93cHG0i0dg5Ii+2C8U9mMuWE4d2ib4L3lzGcdEUVLLwgr4VIYFMpSmf
qH0OTlCDYt4U7HONqvDo3E5PXfvYkZ0dYZtRUH35zUsUNe003ewvR5NNsqPku5WI9eJ6Z8ikaitm
xGzYHqg2OqriD6d8uzKezq75POIl54J9JxnMYYu2y5hZiySUBJMRamR21Qza8BaFIwl8VlOq9zSC
HfK9m6YDeVGU9NbrQu0p1gy3rR9aBvoQ8mOMMbidOYlKikecIy8NWVK2UIzQdLaUbkdu8J5eQs0L
u4Z+b29Dd7RSWkJlaY0RPR6wyd3f5ibNeMWfJDT77ROFRGOA2Qe02hpC43lqsZKUFL2Ar07GzFLp
KuxmnsbvmeerxPGUcIkfO2TZHF+Be04m8y/i1Nt3u944D06AXacEFe0Nn5fKS7pbVeXVuslMphh3
tlo6ZoO0ZkRczZH1HeQXBIatiICvCs+Ag8q0wJmaZgHypTxmmxzgPkpzxNqPhvi+5HZidj4MQhHa
EgxhJMGzyyIbnh9G0zl7qjarYI1H8HACQfokBSQWlFjDQuvrTkIUcuhK+lqWtbug7lVdNYboMxe2
uLLFMbVEqiaY24mKSiGys1VQxmcISCChTJuCePc8rH4LRbOlXKVKC2CcQyKYNDmKIp9NCVu23jet
JLTZYdCmgpZmuzlVSmoNpyT4hb4GMH0gYtnK74CpfW9TWOhkUAntqIT92Vsp53FshKyFGiEmKJIf
zcQvWvXFNKNbahQxJj47F4Rrkk7Eoz24ViUvb8569cQtwlYtU9EUJUjZEaFJB5hMXcFx1lA6gNpS
j5XqQz3hTeQzdzznsy4lSkaDb1gHU68YfNqHUrv366MG589x4gCgOC8xmA9pRueD30o7wG8B42Os
htOfHXRtnvd8SdyHM7XEIJJAlGtOFEUKY+SXnNZxTRoU8NU5XjUXqSqlUlGHDW9sZwxOjw8X6CiB
rYYtaGgPBCZlOZBuOeMe3nXrgE5lPXeAQzAG8mSAPnLtJtby46z3jxk1sAnMvtIhmTeV1A+g8a4z
ubImZFOpUKRO+8KvN3vvkTzKvchtAPcDzD3m1vzksYNgDxKBRqEO7nfC8yYIUfHV0ZEO8YAO4Hm1
PiB4kE3l11vlV36wqbEDhPODmgMWpgQo1eO814d8c47mcjzrt0amwF/shmYH7aHv7sqGp0NB984k
O/OIQhEcGilU5wfLqXEqpUx+sAbuY0FpxZoTvJeXfeYN4szbsxNjLuJvavIuhqL16E1rF4M3LT23
viLd74h3XYyEvIy19wJQfChL2/urjmlGsNkdmGWtFkvSeEzhffKSVwO3hr293dsvnjB0uV9ER+hv
9jk56N2Jt3EfcXcjU2Y6lDVRs7N7RSrcRMJ8SlNko04y82HVbtKGoN3pbLoySNc7l1VY8N0pd5VN
bAVTcbU3OYa1tKGLVxFq1KINvDsKqF5uuMY36ODSEYLcW0A2QKSF+4PHW8KnNP3U8b4/tCjfIQ4x
OzFavPkOgtUUKStLcGmJqdraeHKluTLBbQAf0A/h/6a/yC0D+91nnX8+QZtC6V0D+mOT9UrR4shj
dxiqMs8VMULOIBFSFCpOVUZbwhVJJB7ODTrfbsGocKFJoZXe6lFPNFCFV6c7v3317hs6V+0PC/bK
d7B9kfaVGIx1gzkNYCrKjzzbeM6svn8OiMxTv+bIkaBhlnJCcMyIzMyIiLQJAMLQLNy8hN7Rnzwv
lln2W+q2/4FbnfYmC+hoTBWgT90xPj+TjhGCycluBz9jScQn1suoCArr6QbKdlvqUot9YTiOMhCW
ObCaEqitbo9uPqwbR5IME1Nupi1h8OIsG4062iqRnW50uZH2AjRMRw2bCMYq39B3UEwkjhb2b5Uu
1/YGrYRaB+g/JXBwSXplWznR1F2W6oeVNykQk0ytu1M53EBWHhWQUgrHocILJ6LCtgXtYje7CLvL
KUtyqcqIoZKs4SpDETO8kwu902p1q9Ag1lGPV1NHoCERxUFRz1jKpuUNvQZLXMxxN6VaSZiucN5y
QZyzp2nYK5LxVYHuzQYJ4hlpqVEy03bsGSSslSJRYjHktVV29KuQ5Wx5s4KsLbh99g44kp5lHQAw
o3H3KuVEDcs10iXrxAjrTavTGFTtMjiHFuakNaCQ6vKwlsXr3d+pgp9NpMC3lOdc4tOjrRepSVyg
hIxEdo6Wu/4raLNZXwUNgsqQGKQ99TXArnXOMyxu1oXVKnMoPgKBHERGV0pjJUZbAca0GtOrZFyw
aAq5yYrFkppe55Q3cM1MzSv29+cXOBT0HzZ9Z7PkORwXEcMZNp9WGyvOEICWdklZZQ1rMPiSDBSX
trsKVKS1gW82bqNrJ3CJCutHaOSlxHooiT9L8hwJlJMqynze2MxJTOtDwVtQyXGQ0vG7L9RftOmp
rSr+ErrVJw+m3RlBxKLyLf5nOLg2hHVNdozPnVCRaB3Raq6BaWs1un4aRMLc8Fas1VtxMeT5d/Ca
8jVflFSztZmG3UslGpL8u++2iYc3a2eEDkz9sy0IUCMPb+X7FurRVR1cAnqjNoIfj2JH7gD2atQZ
qf1sta6vx58e7T369YX2/rb08uu2qPHItzVb0yirZceSS/5f5acsrZzdz1oVnwhUQiHyTMaD9TCK
8xZbOy4DWhbVpymYaxWBPHW46zOo9K21gWBO7HPSn7jr0tWXTF8CAC6pv5eaJz6iKckI2iCBr0qW
cgiSn+Ea4j4GtGuvDsZbLSdU0ekM+vBtGaHGS5Sa1khzoYh9Dk6rEFshBGe8Ug6iFnKOiPImapjD
6tIayopxkFpbKm3OyXw1kKezqwrtb7dEJzFHbi7RXLa2RIVYdFzqF0/DGCPeWB5waeM6ztTlP4+2
N6uCSLOydHnw3ujhjY2TPUTlHcQaSrcQPHN06hLQ4HmTQ+E9jBfR2BF+6n5d9KvsnKWrd8pmbuYr
8LFNcNy0qLWAjQ2kM6X8ip2kBHski1ZpZk07r0Y4dccsJW2UFDWbQe9TWzODp0yXoWqUjYZVSSbA
Cyd3dtWr9LBgiHjBDu7iC47ghVq8IMHraFCtG982owjiyJqRSG3Y1Fp7fYpfLYQy0j63+nn15fL1
ARrMRqReodMzsBS3DoQbf4p+207Kn2etKYMlMfJdRiQdLUKdPQgoM+bP7As9fp8gQBvNaCa0MrWv
gDH9EbIZGX4CnovkVIfnx27ic2WMyKSY/egDe3db28COw12lKiGo3aLRG7O7ETbdipV6W8h5dSqn
XlTFubQ2AYgK1q10VV1Euto95g4bdHdVRpZZK08JvlypnwNxkm6yFt+tU3dO0qJUL5Qqa9aiVdGt
Eqxc3CVC08pVQoVGhxc7MV+nYby5TuKzcdYpzKTa64uDLiq3cUxRGtXauFj2xb2ickHMMTG/s6xj
6zOVRTLmAp06Yx1VNdq8Ru9y9r6Lzj6tyZK7jeZFxKPBm/ZEyXHT3rzwzAaSq+QtNO04bu287MGS
EDkTUypOJYVtCvzkD8/OnxT3cvSoHyfMycwaw0VKExDzKz2iFihCtok7aM5T7EKLvHUSlSGxCFyR
haUxcddpFaQYdtFrD051vYxSMwdMynvUgZmK+0jEJLqX2Umon0n9IAAbPfrZ691P1Le9Sp+9yqew
QAAAl5Lbbbbf26XzSV35nPVz4l7ylOfWkhoOqbRSk6VKd4f9ZQJ+1/uSq1ZXHqEyQNnEolXK1spJ
F4YrYct6LIkiVtSU8dxtytFU7ZZZF3PMmiMrBxdmotw5Ae4NATHnK2+PRICjqhX0P5eQ4GVfl1dT
4lIXnqnIhe1SawSojDjFeTj2jNlu8KuGaq8WQMnONhGfIUUa2DWVOQxp1mXpZLmgaDB8xVUhBIjo
5rlpcQ5BwiR12x2htREPxRSyBR40hqXcJkbPM/UaNtsJHd6JXWy3hwHwwaXD8pDZZQ3+MCRTp6ky
CE3Q9E1mIL1cylQ6bPjwRh4r14jceVOFejjTU9kRsa7ajaGldCSQi5i3vLIVF6jt+i3FcG9nW+NG
5uUhE9in7sFQqUUoTEPExKpZtlJX7jUzGVIChqckPZ3rlRRbspikG7pmyNU1VLwbibFPBt7ExN8G
HNKyVZwQRaX0SN1EuaeYtkw6pUVoxlw/I8pU4OVq+CNgqmuVQ4zCRkU2zlIJtzMEdyh+IJSDCY0o
ZnHBliO27jMcwSDIaFDh3uzdLG9tvHWSpP4o4pKKrWvLisYSyRVkUEVtLD4Dk91D13QzoNAQezwi
p7W5jnItQ5HOHu2t90yFNhdoyxKoGZaimLzC4wglLEejSntYwEZxDuxSebUUQ5cGZWusi1ewKuVN
75tFXN4NTg7+XOK465faNbdx3C59VmRIMWfnWwbeCRHYGdNtfbLeWNrawxzcVEp7WtkyrGlZ5Jmx
cOmQnYLNYaq73TYRGfMSdh7g5wJbwTQM+auap6z0Vt735WxgB+EMLzsjp2ZimvzfC5us0ldJi0im
hIVpBj7H7lLtVX6ZejbmpOsPs62oVPsa9GnmV7tgWYXuBXKJD6vd6i/rMEPcyoJyy39yzeHysrzL
7FWLVFW1IlQCz2nCjjFZqq0e9tnDm4dbErYjHTa06yxSPsw7prCqIuKvQYD93FdV+DuK06o0Jm/l
mKNezgVCExjiKMQKkseDOPDOZaoWVrYArZcNXhiVlmBrNK3FSSSmnlzIJNQKKWe3Ho6uGs7IGoFB
8JIdUZSEFlTZxbZNNRIESjpEgsL419UGoqLnOc3DMn7iRLgoVUGpqZQVRpU7dA+jeRKNv8gM7NKT
616NEe+cGuOYwWYQ0K3H3Hsbd4RhSXi3XIq6oCWmfzolErObhXzEMTuFZxbgLCQzY7yjvv6pNkbn
fQxby9pjrDoyldkdhoiZcvxNDFSyelrx3CxAz1dOzjftLAAOu1sMa/hvMZyFkXN9ofsCI6fL1yag
2URxlbAkDDslupobaAhQhawgzqq4SufHmDUkrAU2aeBIE8IHqpM62tu4BRaqHKUhuM7ccQbLJiaM
kwpthhGT3aCMV924k4NBRbpEQk/Brh5s/yBnUokObrb/j99BwYEmB+ACAhzv4x4e1P0I5XjkuPXL
j3bQ1GWFCwONoysmZRMamZGzall7WZNFWrKydkXYqo0y0Y1aI15LVtJYom1uXN1OtTov8Hn3wGA+
+lyO/2bLy5H68gjx52zWMYxmxgzhNMa0I0uu6AMBNNpc6tBug+imTjwSIpqb7VZgh8OVQmsrX197
ozIWqsyJpubgT9uarexpBWiIupwpwaqtD6XZqoFlwadzhbE7qy70V+mu7avMVydM2NFQ8yj2sjEM
bGsknXubDjWnLWXVEvcmPyczsKpb3u4KGtCRsPXX8jytzKFtQVXtrH8sNbeil0I1CW0hicrF1Tvc
MzFrl1XHpvc3RV73PL7aixBAJH2PseersknZDDDtswThgyEB44yiDarlsszDiHuTPaeCZD3ud5cP
TPTjmnJrdKuU9iorbGGZ3qBtWaKraiwBSZGdNPn1DnRwD4gLnL+YAkNAVaAj/fj7rgckiR2VGpKP
4MwXi7ACpf8XvfoIojtFZfrnzESKhSRNK+6c/OudOm7HLfVWaDU0vcfwADarqySmGWGKCfciM2cZ
vVE/8uavk46zBPsyJCHFdE3NNx4QwKnKXast7xq+dBjFnhwi3pUQ5/DNpTEaVmY5m72qXdT2CJ6a
mIG8vPmtMy8Qg2eEtRSSmNl9bMiCNDwscWvEgbOgeyR6UKbibhTa3plKauNpImRWBpVXmAZ4g9wQ
FPdGVAm83PKyDtFYEbzy/BMvezDdzVcEA9qan6t6SghNrrquKtVApEE9+Sk7RyhqOrdpeUysDKQ5
UIqIkxc1RwhxFHckiCKRHY5lmVMqabBt1eilcyXC2zKvcdLvQ3UjLDxQNsILvLw50TlWZaJERc6g
YG3wQsuq2YB2zEtLCNJ1RJ8AbZ/Dx1jmkDDxYp8dQ1LRYH8e5jDxJkzyGmMkkdMe6UpE8Ux4edy+
usrIR61cPu/Cn4d37bLddIOXhrb9nMnarPTyK5FRvca283xKbhDVCF+1Od8XPubZx5g7TULeuo+1
7jCWJJ72Km4BZ+W8juU6jZo+F7JOh96/nNSGrpjsjyapQWJrQYrXMHVWqmjQ2NiY0tZvarDSp+HT
4Vw2l78iNPlR1Oi5Udz0+Ws8KmUix7fg/UOAP5k7mUar3eqYzI3Flk5jNXn2iYEnEjf30HRL4FJF
dj2vohUaMjhJMj5wqT0w5OFd28ywSreNgS8yJidWLrdzBGZTe1WyVW3AV0c9CpTGow5u5MklNM8V
dQEOrhMa2LHVMC0cSMN1hV3FXnitiliCWG7Vrl2vqJcwVoT5rHuD5JWdbEbwK4ebiIQRixSIUuzq
qDDJliU8zNNZYccj47N0l3x3dEZT3xidk3E9XVsBzklRnQoUfJ5NXCyu2pBrLLKs5o0O5XLBjb3V
Zy1px1kQ25mLyzEXOGNTzH9EUGrFrM7VNKLujMCa8md5l4YJ10TI7YTqhR4Fd03AizWZDIkJltvd
qa6qpTWbIQzZGTs6lo22QzSlpjdIYx2ZsNpFXvN8sbK9vvd3LlL7KIP5BDSjW2ezI2urCtbOHWnY
1OghF4xtTrmTitRIeDMaXHt3Cco5j5EZ2ieUFD6A3OPae6thHvFxjY3X30QgomdT6qFyNK6IacOV
B8bKn107Bte36RTqnKOQSVBXZ91m888PTLifRpQu5DPdpFkHNmfYRc1uZWhDmlmGexclF+jWTOYZ
OWqrNfXXvwLe+rWCfHy05kUykaUpCNr0ZqE0ztgJVEHxSWasLMHnsQmA694u0dHLEOXlDF8W56NT
3z1Z6ztelp6PZ3PUYX2FE8g+eIpMgKOKvcjDFYvW9PptYPyJIhAghJ0otLPsKEnEXb9eddeUrTFf
ku+DuWMyi4RvWyEXg3brZduSaoXqNmSHcZeWal3S2qVpqZFK9BOjFC0buqdShQah7EC9nE9Yayqw
PZLi5vZQ2kbjP3nP4P34PGRLQxD2bZHaX3Vsmleelry1PbiYcHDThjxy5dJfUQFvyYUfeiHtbfXy
1EzthtiR3ubsVQ+i8oXO4VtmZXel7j2NkaZzc2nLmcogpTANFq4uSaUTr2yWVtwHetMOJUF7LStT
uBZDbuLZjTUvdRnAiYuvp5x2beu9msUxOALtmMIUyel9L2XNr9sdyycCwPzp3JHdE0NI3HDycFt1
UMjTgtylZdW4tWM5RFjUsj6n9WV3u1GJqIg11rvhalEmw6m/Vbkd7qtz1oHdQMHaWy41O8hua3qC
hm5VAqtlsiSnJJNAczUWRj19fJgcGhPyMIAi0RAEgIAakY/l7PPQyqlP3v1Z8snU5WJdQ/aA/PRh
8OhHsytgd8LEOxXtpck1SRHs2DMDiR+NpVnR2doYCmbcRjmonkg9OdtWDpuwzF/mM5B496+3kFfk
aMUsWCPLqZCS/b1fILn73eSUkZyUqqWtHzqRZrrQD8psZWdQwDYHN+Lx2nAndSBcW7ynW3m4uZsS
HM1k1a96uXaHneGYdEsVwqdXOpN1848zBIahAZXUkm42aB4T6l7bf9PZywp+kezg+QWYRk5lSIRa
tRy3lfc4MafVO0jEi0RWnHdtSFcyBGQTKJ+MQENDesi0S1IzSVLDaekUGLSmgCgG0EwjCZVR70MG
MDnz80F6D7NOOkFuMUQPr56DZbuZVDQSgMmWtqudD9liqDAUlhT5QDaRTqXHRehBPXYsxqJ4ze1r
c5CnWiIwBRRD7fHv3qiMpxnGC4SR7IeZMdMIvxtdCNABVecCQamxpgKR4hHGRsoWGK7fbS2lAdYR
VdYNoQmlcYeK1HQvSUhVKzSPISvjN2U7IUJbIDYtFc0apKcaiyFok8I0afHJv5z72uDSBp8PTp45
8QUAMZLDIPalx9uCVfmCF3E27NeyeTX1gu7RTsvcUmQVktb9tawnhQQZmNX7mfQDDseabd4hw6oz
rdx1C0EIEiyXJkij0kBrtZaLsGXw+KCuFqHd9AOk3arBuUg5lCiWYpG6HCVyssK7aRKMDO+b8Izb
8aG5HJpHZd3COOO0vCGm+z2L9j51obvkQvzs1zJw0laIQZgFKOD7wGfuZMQkVeIXbx5fDwOoYpc/
c4kuJ3PpmuG2FEDeAxlrxaIDpceIGynXOE7/sB7GgKEsc0F2mZ1ljaAj3ZpbBrkyKFwKr99JPlI7
1lBzyjTdpLUsXynpJRqUMx1mCzp5VZlrQeEtSToQmz8DFoYQkhiVBZaOz1KQCKpF1W+Y8uKklDNj
YWERQJLaaBCjHop2CQNR2T1ebfYqqNqvrnHLyryKkUCquVVZ6YLswTGWSa/RW0dDVx5y9STuPiX2
V7sRWxtLuLI3rWlBv0lcWXxvE2WmVLPeN2eCa2L8j0z0KTFezzenJEIGYxFI03bW0rRRqLq7Vzgt
EYPsnN0ELFl8Jo+gO61U8uUjmaeDD2E/ArSLy4CpwazDNwrXo7H3F9idtPtvJntHVztdVsd9Fx5P
o7TMtDzRFqCCHFKELjLvQo0uWEM7CDLvs3EidanArJSQK+ZMeIVELdNejCRjK3JUKbJi9y0rG9tN
wV1Tk5YE+UEjnTCZdscVA5lWmIF5vg3uLeSBzciTUDI0xCSKOIjplvZoow2MixRbxKockQdA1IZG
gTxnuXs0JGhzI4+gD+m563nCW/TR5ZDo7MSlVZKJlvmacWKBvkxXj1kyrQtN4QsCeleZpTI8MktF
JT9PR7dWcaFFQy2BEIGLIJ+4d6mZJqQ5iMjUxvj7F1VkjCcIxMFIdxFWmqV2IZGZiqWfGNpCsFSJ
XSraVwaYjSdTWC29FMjBIggngCTBl0ZNDQwLx7jdTb+ZVkUn25k2Lriw4Zq227q1KAQqxO0YMQtY
UTl7K7nX2/RSC8IRzebGebPQbvL3tzg1naICI9135FrL07Mw62A+pfNv4l1+PAz088Tsd49snYzB
uiUTfP5Mj/aCIgSX9jTAGWhbT4OYMHEkh05T3DmMC6r5WTgqVFYaqEc1SSNYtxkU0pWcTm6pydU3
Lq9VzTFiZmHRoG7i222OM7m9zzvtxn8XRuB2uwfN7+sgoiJbXRQkWBIDa2Nrg1gDwAkagCw+njhF
7mXfPAqxeZ5NWrcTij9p+DFV9elkHSpmTd1ORPk7wDNtMZrERpmDayqgHGTe4IvHODWiImIOyYjO
W3eU6TN1i29oYoT2TW3aUbM0cqVlFasw2oh1GrUciYuYwm1LJZSJSEX+y4dBaxDypUlnH7i0WokI
2jFCoH8qe8As8ZOXmtzFHIpij1M7NzMy40q4yKTnHKeBEK6R+oH7IWFSBv4Y9aCgUPhNcA/H53PK
jp24968xBJtv7G9P31GKntTXRfY5wAc5ZA5wc5wDu5ZyyOl7knFLvN7uTTLURGmZjo1U01kjrNEr
TSsIo/YODCr6ERp8Am/wBJYWjIyGapMwEB6gkeA0Rb6pc1IgZ5+vK92KwRhXBr8nYnkFaKu6oyVS
WZmYrE9+3ZsH69ZADVd310htpR9uNbesbDR9+MB8uXCud7aABXQr1VpGPLFqSugr3bH+7+jPj1ZO
zFZb0Apa1qAUJVNI93y70ozbiRJKtzxKlBxw0hqeuaFFevN8VqFzlylZ64hwojfU4STGl4tOTWFy
3ACLNA/QExdEh0NkE1WINAK3TecIY89OqIamKgDbSkz3D2pp1OyGNWwK889Hxakz9Cq9be+jbbz1
vlEHrrAOoHJAP4cH3jbWc1aqNNeqDwXShDcWjFtuwKzdZElUy1mhbGtaAeQXmVDb2SWWlkwQg9cw
5M5p422qry10RUWtgjIaFAFgQzbvUGh8EJJ+vJouzp6r2Lo2o5dN+GYr7Zn77nLh7R0xu812eiyr
z7Wogw0KXqTQITo6qSOSfsU7MOZu6Zl3kgWQSlHobH8RB5t9Qenxy+V8fRrXb9Zalll17rgNT8pR
4hQhRAlTFpfU/Ewu2fHsxKOIKFXePyl541s7jkECBR7QD1jUpb8rbbls99yBgPABMr0ycpXlZRal
K4rwRgyAwfxXd5vslfSomlQeiZPk0tTuddGQcIe214RHyn6POWRZFvf0Sjy/svhKUkoL4Y9+OX2b
ffb4wwshbEYcjsI4nBw8qFTo7axjC24RPYzBQi0AGeWQSMtelvJ1ULKBU5IKnXM7Vjhb8h1xHnLm
hK1DNdh5e2pqIoviQpdWXBrI8NaoQgOSKKufB5a7wOdgiHGMyBF1LXRLGGfA6wclOhqCGI6i5lBb
2qguGPfDm/S9gVGBHbksdUQaIRrkNA+Y4/LTNeqUGr0arhh4LDXvzy1bzvakMw3NR0jYuOHEqnDG
SWFQlo43ihrZDznJPa3cYy5LUOXVzE3y3W96yj4y5IQAjxtAkIRBF8zlxxkaUaRRZdF5jfgxp8FS
QTR5ZyTmOcyX1/ApEmLytdN3lvVJPR4j2KOkULezXk7fYiSDI6qgBDAejJn3W7cbBAim5dDne1cv
J+vl176r8WfCFhaHq1D2WwictrVORG7eGoOXNWgdGnuU0PkaFzViFT3IpVI8dd09Ih+RqfvF37XL
CE5EE5mPe1h0gYeDTkQ/E17l29NeVkrnGtFY+i8LIQLCFQvS9PRF24D1oDZROlHbV54o5uzzPPL8
jBid3X3QR79xG551FytmCYvO62ey0qFh7IoWjfWqjd7VeigKouF8riTnl5B0tOlM7sZTt+8QvQO6
ZHsQhrQvYPsMKHkvLcTLMkCjwexEkaT89c4OuAO4hEKurkRJKj9FJ2j7bF0LmTcTA72FHWs3XTcf
hPfZ7KKXw5iq+MxJAk9OER6iZaHJIRbVPyrrGrIFQZ324ZQS0TQoOxs49VZj3HU0UpyWvkqJ4H2c
3jsr47PoUe5DEi5kB6niBPMKm3xrXZaufKn5P5We5q4kBnl69UqtOMx11r4NCp9lcFxdgfiOL2Ol
P2ZGaiq961eFeKp2KWRPeydoYR0oSpMUxB8XLB0jeqzXV9Jdh1It9yPfc7Z8Zc7lmISDsFztWMxU
pk4cWPPcFU+u3C0sNVoAhGQMjszrJlhhN0xze0ExjEtFc8RX2izf3yPaWGF2B+wPr2Zk0etYcJBO
KrgDPauIgEiTzHeAzwfDmLg44QvftARs/Yi/g/gjwWzgyI7zBQam633FoS9OTVLCyN+ikZLuuYpm
DR7xf6gXr9B8mBZO+ysku0LH2sSW3NnHQxadBEPU0NW1WpWG5uWqyoSl3rzRTmFuQyTIJLIvMoq6
p3LGasE4mHmh41lS8enHurMYMu3SC5mbMF/jwDxc0DCaS6d6ad52pG5619w47pbZpTrw3Y78bYWq
h9N+qr/D8XnV26Se0qkzmqdpK420NUwWbCyqgoGqVWVqqqnIOJbO1stqJsVWHZae6VWJC24MaZdb
Iwv7F9XaYjunZ7VdWEtpSKxTm062qE21AqtVTQrLiQssbLUKhbo3X5UVzIqt5tq5z9YvoyqiNqA7
x0qSNx510nam6sOsaLb5tKI03NspFyJP4BYAffPU7F35K2L8yJMb5Gb0adrvet7gek0JnCTO3Tqs
JRnBfTWjd2TCmu5MnoSfSHbhsPFrvd9zjzt/H2y9RiuE/qZaX0R8hAggAAAkkkkRVnw/Xzsq7/Jz
dZ8X1oOp+c5gsgW8U0OAbNiiPD1/qio/dcj0y17KfcMBX0DBlBoYRCwShTvebZaSZQlzbiIZsghL
XqV0gFZunW3ZR5hmVXW9uOnTCOmrTnr883pX1lHoBSGtfdzDwlbtz3Tok0pUsHJGGIYWmS/Kcjkk
V8QZz1HqEkbC0LFhNeX+OJhvQxNDvWVYNEq3MXUC+uQb8fbl9VKCEecJDm3zdd77bzQdQdy93RHP
eAeoHmeZBhd9mVOQMOZ53y+mi+dPMZ7M8HSASEchoUScKIoqYgyRNQ98bfmh1vXxnmGyJbiWh40L
MfgIMQRR16uMhHhLPL8jr6+x5w+XOkGLrA1XiW20sEUFp1iKwmL/Cloe5Dqvmrpc5hEAlJCTEoYv
Yo8rXoqSNELQB4QOkVK1RmCvFcYSt7VMHTNoDpGETuXVcJtriPAu70zmZH2IibjCBdIDw43pkYQ0
iNmtCm/UoxTg829EpDC0MIy0Nyp+NVUenuKqgIz5RmX00xKnM7jD3GjU7VWW8+1xIo12Uc3WXAJR
gogIhk9cQgWhbPre2r64OdmNkcF30zy3rVq3k9ASJ7dvjZq51NIVc5vvZTNB06aIVkk61eWl0VGC
kUmruQWcfxTsCFHJGsFGXPlXxs4RGhJfAvCOMhEUeKGJ3o5ftd82wMUuAhY8t4qruP4gAHARlHYZ
zYzW58MKq1YNqnEB/B9sMOX3nquuVJ4Z2VlR4BDIy0+ve+WCwm8lnjEKzZs4bzNFffe59FNC4Qw+
EeETSjq5grRWbzPG6n1lbaANjJzaJ2bFoQbI84+FVkJZWW7QpNojDQtlBU5dpjMprACTqeOaEF6o
L+0QQSJWAY1lI2LtdHvZQytdqy6uabsQk4EQRplztTy7oj0AbnXQBznrGUOp3jzPcYk5nV85efOO
LzD1aSQtTPnfF3aD1c6R6fDs2oeDsQVELZ7C1xJ58T5NylOzkzWT1wRyiGW7FMXkWDmBs0Vn0xdL
njWkKtGEqvTM8k20ui0LwXAEtiZwS6YLDRGCV9uy+rH01vOXH0x9bEKDoxvcryaFUbdKUoo1+z5F
+9LnsKY3tYqaDAFO2PRGkDnghQQnk9BeNRcDMhryBGHqw9ekSQjy6UEHxRdWVUS78xD7kZkwTOLn
tJU4g5ardulOYvceea672inv3yFmRNRBi14lR4MIswbhDeyIw8trjPPPuu2sBfQ+rvlgYkMxeWuX
lRPVM4LW2LkkgCLyPDzgZHiqSYXiI3s98PYt09u9euKexqc2pulv2UnbXajjit3cEdv0JSkPqlxk
CTwc2YuXjslAIJfrl+ede5+ryUGzhHYbSoeb2k+ZOoXwYJAi6nkvR8ELRC1vKrR2XAr161p/LPoO
baNFQiy4RLggZ8yhhAoo8B2H2dPSEbYM55NyNLqCAHjUi2XpegFPz51hJo9U0qVaOScZS0YpfyKt
ognoh9gzwinODtJd7cJ24Nd2L3m5hc6XoWrJNx79mE3W5JGAVYDMFFMtnTBkv1tXgLNRdjaW4N9p
jmvV5HLbj0zHc61S8jpapa+bPg7tSIboUaADnppCjo7OqRet5V3iQj4XbLVZuqecBSlvAEXbxAuC
d2ZIU6lpsECYvrWgqryEvKZ67bEYe1SXqw3dMGYM8GXMBZXvcjb8exW503r3E9gwVnVkYnoaMfe/
nOB1WeTEQVartbXBGzX8prQPZDAC1n2GhAMwxgTJCuio+5m08FRHdyDTrHugZhTkuINOLWi6nUNd
aHDuRk1MhwKy9pJy6UWjKxyFlapwXEyFWSws0MOzt5+1qA8HbAgSGAVfEgXIoa7WtI17szoGZknb
9BxiPxD937VFU/b+/0H1/xfzfzn66n60vrwTl4buc4EswTl4WG0ys4My1WawpVU0aw0tavRrWYsz
WAlH2vEAAAAG0ui9faXijK6HpJtwr90qu1K/NaGMIqo5hAU6hIyB6JnkBnvImq5JDDpFOYltEEYQ
1zAfyG/AA/tm6AEVtq9PNiiHC5AQaolf10Af2eTIAAf22/WQgfwOO13R6vWAICCIn5gP2PnAH0fT
+L9P2vs/h/hBXczdW3DZk84FcqbrPDDLDHLFjUP9Pke785JImHwT5pjPg2nz+02rpvzxkunDitJk
YRojLEcc5sY6sUxzi9vr1VrMkKjrzvJvXk27jHdSb2pq26tpqN1yxnG40MMk4Joms3aiVUjAy28E
xbN9NktI1cNY37JDRN5picGs2zEyNqXZqN20wm6VpfcZG+I1F7pvTfJs3VuSj84++SB/ghb8P2v9
sxn9glRH9dH+Q/Raoqj4Utpa96/j+3+jD0/xv2joMx/oKHbw/yQ/eh+u20frF9AF98B9Ksv+Dr+U
Bv/uvgQh/2CEccBgT+vVgf3dmP6qSPP5bLyHjvE/4JISRiPp/bLCpQqUKlCiZJCQ+5ER6/Jl9nzw
v+W5lH7g/JkRFVTuYH5n3L5dGM14xKDIOaEjMrUtMSqh5NRCZL3liITKnDOgi23ZN5mS53Xc7dGn
kmdtnQZlYbs6LRQnButEwmlMVeu4RFN3FKRk1IwUhiyXie1W1rvZlWoduVIo1btBZReWd27NIwht
aXjYYbi1r0bQLmktqsdLbhHFtCNuGw4VHWkxV3F6Kmqkq7FZobEGmZW7uQNeXUVrBN7GcxLQd252
8u8ujs1mJuhF3IbwxGi62JySokLNmZ03M/jOx2rxZHNe4222Gg4IKaKCaMQyVDgz28iw91RCJBNO
ou9eUk9tSZ24fL3HbdZEu5dwcy7JzJy0yg9uYg7d1jy2ND04VCWUZBTpzAYncKSgOlDugcWzgcmt
FNJxLx4ZjYWbSqQq3kY5mMCovQRO7tA6XbwbByTQiC3NSaLh2CFVTaTNURmPmVCzJ4xGQI26Bp3O
ZuLYy09ExuUw5R0VdCZD0uHMqt2iLhBRVyQynuJi8oreGEmXUpG4Nbe1YykFhzIythAxt2HeGsTh
qHhwqdNVtZCavQpuwdOo3KTcVGwwqzKw7pBcVlGBQe3qdRmTgmN0aJ0xOw3lY9g04R20HVOTd0ys
1nZUJxPMuqRxGTGVaauMNTcsRSam0r2EjebdW43TWYLUUtxQxYUSabw3W7SzaGZT291yw6FRkm4z
HcXNNMaS7eKow4dis3S0WHbENYTT5Robt6JCihPJ2Iw5tMTu1ae1do3Mi2JTWy1cZNCcqNYhaYpZ
SahK9pUoFasV1dsyzsbM7w5KptZcLdyaZOKy3kjZ2AiVYvBtYlexGxFao2k6d2MvNtaHYxt7VScB
E4prEIYyW93iVaY1TTEVro3to0VVJ4L+7znAANs7veMVGLqht24QvujmkcAt454AKI4BzjGu3Kx3
CiFYlkTUwkghQqlwr1eWd3yhPAHCHByyAAEIHRIsYNHQ2223/r/lEkkmqqq+CFrVVV63sQrmI839
XnrxjuSpHj3GwcukP11VVVVIVRFM0B0BkP7asZp/aG5MvKs/xFv31+CWGsLjEUNZrTbN396aSaLJ
YXyNM0rGsD/2jFFhmLGJrd6GCbdtSYljnpGMlzTiVGCcJMpLSWYjP81JoNhwHUacssudZHOVF8jW
fNMijA1mHQRiLDMMhgBo8E7KYDnFVQGD4PloU2GAPAx6HzpP2J1uH7E+ErpX1fVVVVVW6Y8BMeW2
GI6Jtiw3mtOcwPPt9ntzk7spG+R13qPml5EQfUttttttttttt+0kl8qSWRG9fTSdWgaUsVfpz34a
V0p2YpcN7FrFqGUMR3YDFijeGXgi0cy4csRlrS+EAe/732VVVXLjGHGMGfW3A9iHQfAa/nbg29mN
sooUc3ce15Rh2YJ7pyr9yQj3xwj8be/aiNLtj4zLLDAwT2NmhsPbQ92G/5SzbsVKVNk2r4ara2zU
1HFeNvJwN31R37vLjGknZ6xl3LQpkdvPU5b5ccFp3y5siNk6SHGB65tFdB6gqNVSS3bYZzds3JGG
QRSQoVO+u5rtq5YmaWnLYXR3ThLcJOEn0cusmudB3k8H+APSpvh4dErI4QYYw+MRsnZImaTS8HHi
Xntb5KikltW3QuGUbtTG4423jWS8iX4IXXTVSZJSbk/zsm2HJP7+Cyo3WGhI4YDVO2GqphuTRiJP
zi3ANLHwG6d8e6Oknh417kx4PSVWRb0nstn6UTOVNMBa1jzHceiFjE0FmwKjVJ7otGrOk7qau5MM
PcDdO8fVQ+z9ifhjJwlctTjVkMHQ5R1zdTxK/hSYNJzOeBfUbHFvkJRyk1f0SQ8RyRPp+U7vxyn5
p3paUkTA/0X+NwzP8AiJD7BIKVSj8ulh90r1L1w+kmMRUlcbdZ36SPanrv7z0MvFShEMUkboGOmo
TT+Wuf3Pt4X5DsaH8Hsl103e8x3SNSGozeycehqmc47Uyu1YanBOTC1tSaKNU5MWtNu7UbZJmOe+
FFSdNrWkjc987Q6zeah5/bcmjopy4x3JeDCja7ceKuTGZhgM5XbYwQ0GRYykzxiMxuLmEnTVqfoG
b5hqnNOr7IXkOb81SEuGL1/uivf92nMgqJ40kfr9cakfaKoUOHN+bxYxiMqEboZ4CPyn0wTmRthU
nrM1ktmMdDtw9n5bfov9/vwR1qqVRUbhM6/NhZ0nq/GvScndVV4ViZsbNTVIYXstJnnYuUXlpb7/
qn1ov8o+Mnybc5LJh+OQ7vZ8CfYPp+p59xO9fqL17L/PzcWd/h+wTJ4oIoqjvSazCRqwxOe/RWk3
Mt9Rg28XS97X+lrXqqSMd5WtxRwzvH0TlMNIR7EoRpO6h5CkkukVaLBVlhQdfhLzvDQt3+b7o58k
5zLqjas8IrhJGCZ2h8+U4JST2vfp8Bw734T6/h7c8wdiRlQ2OapD5D8o9wmnLTLgKSoV8BXJV09t
jZInmPOIrvFFqqQoCAkOc/I7znJjGCvxPAcIcSfUUkbJJRWCXkthXbHSlo2jBl6I+pPXi7q88Zwq
7ypZVrPPTJNmZfD07zGMGKJWGPpNc25D90NLnISEvZgOQs59BlwhPn08inHER3G7dHLbbfopFjp1
6TuDVLjs2iw7FDNM5LpLjrF0vGcYGEirU3vPUd5h0OziwG+VIhibvkH49f4ceMwf07hhUj1SUKTY
atuytoXIte59J4pmd9WSqyJ9DUWFFWFMrC2eMfPN1YyJoLvLdHSYBpKNQ5Fp4+c7pU9X8Oz3IvOJ
ztJyDGI8g0lRsDwNSMR+SR6Q80K5JWH1pGQ8fq8rbJK5JYzKqRUcUyQqS5TcGnjjIZ18AeuvWc5r
rb0BiDT8YMIr4ZXBZPclzFhkKzq8P5ZpPDWYDWNvysOBdHXbOM+o2EMFBRWVSZFb7vS1pKutJX6a
Rzk5tk/VTMnAdw+g7sB3mEomg7JCRFxwxvyKB8van1lN3lj7E+Uo+swLH2vupVKpVD4mD4UmnlsT
5mksnzzrN7gRncMbCdhD8l33z4TJosge0PENitWrROOpv2yy5wR7EYtrtRNriqthwWm8sKU6Mq+L
GdcXKTln1mVSEiPL0Bs3GEQUT7RBH99X/2qo4RJUaFBN9e52rsBQQfnfeyzITjAfp/BQAMo0STsF
EWqqhhUHg19FfpxS9RH5hZgbdBKChQUHS686V9WcjIVJKFQ94Yfov/NUstdHgl6+fWzVibN7GTOT
KkYXYD2NtmETf5TSTVOfHqp/KoDmkUlEciYHDAQFoAwOHCf3oPA6HBLAvTCj9ZoGN8gGGZUNk5XQ
tIZzFLQnywtb9L7ft2eOV73ve976yLCw6W9cMY9Q4B5e8H6+LWYMdmyJqxDblJ/+pJxKmv1skJnI
03FQ9f4eANc5NGwf0cc5UHnRRnoOo6zE8dVyTrNkSsJCenLFVBb9WQ9bTGNg+8V0lay2sc/5WS9I
fzBxg4oVzVpJRkm/lvmPHPXR46qMxROqwuXXlLEpJVkusXOEpE/Vgt9enghmkRZ2DY4mc/n3Bvkh
r1RsHhzZjfoT9RbnaAe4A5/g4qoiIqiqvtsVRFgypVRS6PgD80v02VPpROsjbGllYh6w75MoyzO+
TOYQex297PE0/UMo2d42hULSXkiy1xiLC4wKmcYBY38xkm/dxmiySYHGySWeYa+IFhQaJJQzCpIV
DZ/TLo1iof57ZmvIMEqS5GvkGzzRxTrPHsnXTGMGiLC76LQvIw0WDqYRp+RH7Mzhw4f09oelz93p
7/8bPn1QnlzionzDdHd0TwR9++2MegrkOvsnxrcnb0stPyPGZVG342DdmloGZtNk54nSUqKUqvK2
fsKRLVUS+FUT1B5289ozTexW+Ek9tBTbBgw2XsklhYpKltXf48SdwzTFIZpKabwULRPnYJnJLwcF
uicMN2wYhQjjsNVDIZbYwBYReFgdkwGEQxaR/LC+mkjw/3+V0SgwSoWH1SSDwKILbXQHEYMhUScx
+U8EN5Ifl2GpUPrFbNtVYbAvv5+hPR0PIJgAcI/xK9K/JkN1bPKw3lihD/jJKijAyk58IscJCbNw
9skN4cpJqN8JhGILTUhvHqPh6DZ+sD7Baq8H4NkQP5qoThJGCJlUnKZa0rNrXiYpyQsdCkwhU9WI
amuRSTUZeWHD5/1jDs3sUzYSK2cBNxcnCMHHM4D0ksmtR1Qmc6pq7us7ITrXwkoDZSO349k3+uQP
xPjFAenzRNOKDB0LREfooujMY3SwLUFkUO+/YNX6IjdO2fhQyJi1KiW3B0w9X2bR0ifhIbU849Yp
upJYVZIsLC8q8nM1jcJke2fEO2TjFRrmHnuTYUa9aSJHjKFtguhrmfS3EUKBNjOrFrTM2HCHrN0k
wjqYQmuffOeQlSNw2yVG0W42w3fY+mB1FH9QsJzZ3FxsgfkEodozkbY7RKKk6ydnlihyUMT0Osly
xdkmMoRTv13TvVJNR7RhcCXpJJ7D3i0QdnUxHKTuo73YLUKLRFKPJGaNUnNNborMM+XdIbLc5Sbh
c6CPqUHkDojqQ2+tPdV+BKqpmKVVn3VJZsnMXTNMJNI7yK13dduaG2oU3DnNZHs987vj4WbqHXXO
oahzFztkPBsTbg4jlUkNOndxRXBOUjpIcYsv3dZpvhwG7puGI0Sel4WkoX6plNUTl17Ye4AZQDMI
UUfd8apc18x2yMH2OA2GCE+kGYMZHI6304Ag5VDH79owDAueBkm0yMKMbapJgLUQuVZDHTZOFqH2
inr5DBMkomy0NAtqpvXMIUKUVFX2WRlIoYb5C95xxGIzHILRI2o6pLiwoer1zoOhoGsawaDVXRpG
wdgsNWAnHbmjf7N2I3ybXlqk2HKSOEvEtsOMqLe0WD6JIkZRIw5za5CcZLxOg7VDGTVWFbUKRktJ
xHbexWuw90j75E5X9yKhFC2J4z+y2yTBPwk6fHm6usfKROico2CqGMdNGKuo6wTUCgeETzlInHGy
YyiaUYURgGQw4pOEmbgntnZDa7hrHeMNjjy1YUc+MyNoWoZ0Y3pJq5ge7m/197ETPhPrGoTBKThX
zF57Pe/SZBqR8HGZpHqo0ThEk2F8Sun7MpLi5xt0ymxrQ/YBI0kVEHbkMRQujEzpKtJJPcohiKkU
KDb9yv51O9uYM5mSbJreyk216sRZOMinYhZDqoullpLZHrHaq6WVf5AP/4u5IpwoSHlY9eYA

--MP_/768qrIKvm_fr=W2_MP_0Z5n--

--Sig_/xxSD5dvqGUq6s7GUopHC3um
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaRplcACgkQTLKSvz+PZwgftACdF5rhDwi7xbAqc5NovHOgqSdo
ANoAn3iTcDz7K0FmRancSTzYq14Yi1Lt
=4lh7
-----END PGP SIGNATURE-----

--Sig_/xxSD5dvqGUq6s7GUopHC3um--
