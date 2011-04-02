From: Sergei Trofimovich <slyich@gmail.com>
Subject: 2.6.39-rc1: kernel BUG at fs/btrfs/extent-tree.c:5479!
Date: Sat, 2 Apr 2011 12:19:46 +0300
Message-ID: <20110402121946.6bf27f80@sf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gtS6p9H=livA9lRT7AfzyQz"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/gtS6p9H=livA9lRT7AfzyQz
Content-Type: multipart/mixed; boundary="MP_/ujbihMFs5kh8athhXSlwcjB"

--MP_/ujbihMFs5kh8athhXSlwcjB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The partition is a physical ~5GB --mixed lzo compressed partition.

The kernel 2.6.39-rc1 + reverted commit c59021f846881a957ac5afe456d0f59d6a5=
17b61.
(see http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09083.html)

This time I've really filled whole partition and kernel OOpsed.
Note, the blow came right after INFO about hung write task (see full dmesg),
so it could be bad guy.

Apr  1 11:59:54 st kernel: [168399.199337] ------------[ cut here ]--------=
----
Apr  1 11:59:54 st kernel: [168399.199368] kernel BUG at fs/btrfs/extent-tr=
ee.c:5479!
Apr  1 11:59:54 st kernel: [168399.199380] invalid opcode: 0000 [#1] PREEMP=
T SMP=20
Apr  1 11:59:54 st kernel: [168399.199397] last sysfs file: /sys/devices/vi=
rtual/vtconsole/vtcon1/uevent
Apr  1 11:59:54 st kernel: [168399.199409] CPU 0=20
Apr  1 11:59:54 st kernel: [168399.199416] Modules linked in: btrfs bridge =
stp llc zlib_deflate lzo_decompress lzo_compress crc3c libcrc32c tun kvm_am=
d kvm fuse nouveau ttm drm_kms_helper drm i2c_algo_bit forcedeth i2c_core 8=
139cp 8139too cfbcopyarea cfbimblt cfbfillrect [last unloaded: btrfs]
Apr  1 11:59:54 st kernel: [168399.199508]=20
Apr  1 11:59:54 st kernel: [168399.199516] Pid: 18178, comm: btrfs-endio-wr=
i Not tainted 2.6.39-rc1+ #2 To Be Filled By O.E.M. T Be Filled By O.E.M./A=
LiveNF6G-VSTA
Apr  1 11:59:54 st kernel: [168399.199540] RIP: 0010:[<ffffffffa04c1123>]  =
[<ffffffffa04c1123>] alloc_reserved_file_extent.clone66+0x213/0x220 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199589] RSP: 0018:ffff88000de7ba80  EFLA=
GS: 00010286
Apr  1 11:59:54 st kernel: [168399.199600] RAX: 00000000ffffffe4 RBX: ffff8=
80077f17bd0 RCX: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199612] RDX: 0000000000000000 RSI: ffff8=
80077f17bd0 RDI: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199623] RBP: ffff88000de7bb00 R08: 00000=
00000000000 R09: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199635] R10: ffffffffffffffe4 R11: 00000=
00000000002 R12: 00000000000000b2
Apr  1 11:59:54 st kernel: [168399.199647] R13: 0000000000000000 R14: ffff8=
8000de7bbb0 R15: ffff88001e16ee00
Apr  1 11:59:54 st kernel: [168399.199659] FS:  00007fcc3e5f2700(0000) GS:f=
fff88007bc00000(0000) knlGS:00000000f68deb20
Apr  1 11:59:54 st kernel: [168399.199673] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Apr  1 11:59:54 st kernel: [168399.199683] CR2: 00007f87634fab00 CR3: 00000=
00033310000 CR4: 00000000000006f0
Apr  1 11:59:54 st kernel: [168399.199694] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199705] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Apr  1 11:59:54 st kernel: [168399.199718] Process btrfs-endio-wri (pid: 18=
178, threadinfo ffff88000de7a000, task ffff88007083d80)
Apr  1 11:59:54 st kernel: [168399.199731] Stack:
Apr  1 11:59:54 st kernel: [168399.199736]  ffff880000000035 00000000002c9a=
4e 0000000000000005 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199755]  ffff880036370928 ffffffffa04f98=
4e ffff88000de7bad0 ffff8800166dc000
Apr  1 11:59:54 st kernel: [168399.199773]  ffff88000de7bb10 00000035000000=
01 ffff88000de7baf0 ffff88000616aa20
Apr  1 11:59:54 st kernel: [168399.199790] Call Trace:
Apr  1 11:59:54 st kernel: [168399.199814]  [<ffffffffa04f984e>] ? unmap_ex=
tent_buffer+0xe/0x40 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199831]  [<ffffffffa04c414c>] run_cluste=
red_refs+0x2ec/0x860 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199850]  [<ffffffffa04f9755>] ? map_priv=
ate_extent_buffer+0xd5/0x1c0 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199871]  [<ffffffffa0514b01>] ? btrfs_fi=
nd_ref_cluster+0xe1/0x180 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199889]  [<ffffffffa04c4780>] btrfs_run_=
delayed_refs+0xc0/0x210 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199909]  [<ffffffffa04d5ca8>] __btrfs_en=
d_transaction+0x68/0x220 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199928]  [<ffffffffa04d5ea0>] btrfs_end_=
transaction+0x10/0x20 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199946]  [<ffffffffa04dba0c>] btrfs_fini=
sh_ordered_io+0x28c/0x330 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199965]  [<ffffffff810a2e32>] ? test_cle=
ar_page_writeback+0xf2/0x130
Apr  1 11:59:54 st kernel: [168399.199984]  [<ffffffffa04dbac5>] btrfs_writ=
epage_end_io_hook+0x15/0x20 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200004]  [<ffffffffa04f4adb>] end_bio_ex=
tent_writepage+0x13b/0x180 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8110f528>] bio_endio+=
0x18/0x30
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa04cf1ac>] end_workqu=
eue_fn+0xec/0x120 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa0501dfc>] worker_loo=
p+0xac/0x510 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa0501d50>] ? btrfs_qu=
eue_worker+0x300/0x300 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8105c0e6>] kthread+0x=
96/0xa0
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff815758d4>] kernel_thr=
ead_helper+0x4/0x10
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8105c050>] ? kthread_=
worker_fn+0x190/0x190
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff815758d0>] ? gs_chang=
e+0xb/0xb
Apr  1 11:59:54 st kernel: [168399.200010] Code: 48 83 c4 58 b8 f4 ff ff ff=
 5b 41 5c 41 5d 41 5e 41 5f c9 c3 49 8b 56 09 49 8b 3 48 c7 c7 50 19 52 a0 =
31 c0 e8 de fb 0a e1 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8=
9 e5 41 57 41 56=20
Apr  1 11:59:54 st kernel: [168399.200010] RIP  [<ffffffffa04c1123>] alloc_=
reserved_file_extent.clone.66+0x213/0x220 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  RSP <ffff88000de7ba80>
Apr  1 11:59:54 st kernel: [168399.203852] ---[ end trace c4a85bad852f7be8 =
]---

--=20

  Sergei

--MP_/ujbihMFs5kh8athhXSlwcjB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=oops-2011-04-01.txt

Mar 31 18:11:22 st kernel: [104289.758564] Btrfs loaded
Mar 31 18:11:22 st kernel: [104289.760067] device label PORTAGE devid 1 tra=
nsid 16079 /dev/sda9
Mar 31 18:11:22 st kernel: [104289.760351] btrfs: use lzo compression

Apr  1 11:59:15 st kernel: [168360.753064] INFO: task flush-btrfs-5:21898 b=
locked for more than 120 seconds.
Apr  1 11:59:15 st kernel: [168360.753068] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
Apr  1 11:59:15 st kernel: [168360.753071] flush-btrfs-5   D ffffffff81099a=
a0     0 21898      2 0x00000000
Apr  1 11:59:15 st kernel: [168360.753077]  ffff8800623db9b0 00000000000000=
46 ffff8800623db8c0 ffffffffa0501c03
Apr  1 11:59:15 st kernel: [168360.753082]  ffff880076022c20 00000000000116=
80 ffff8800623dbfd8 ffff8800623da000
Apr  1 11:59:15 st kernel: [168360.753086]  0000000000011680 00000000000040=
00 ffff8800623dbfd8 0000000000011680
Apr  1 11:59:15 st kernel: [168360.753090] Call Trace:
Apr  1 11:59:15 st kernel: [168360.753122]  [<ffffffffa0501c03>] ? btrfs_qu=
eue_worker+0x1b3/0x300 [btrfs]
Apr  1 11:59:15 st kernel: [168360.753129]  [<ffffffff8103b351>] ? get_pare=
nt_ip+0x11/0x50
Apr  1 11:59:15 st kernel: [168360.753133]  [<ffffffff8103b351>] ? get_pare=
nt_ip+0x11/0x50
Apr  1 11:59:15 st kernel: [168360.753137]  [<ffffffff8103b425>] ? sub_pree=
mpt_count+0x95/0xd0
Apr  1 11:59:15 st kernel: [168360.753142]  [<ffffffff81099aa0>] ? __lock_p=
age+0x70/0x70
Apr  1 11:59:15 st kernel: [168360.753147]  [<ffffffff81571d54>] io_schedul=
e+0x54/0x80
Apr  1 11:59:15 st kernel: [168360.753150]  [<ffffffff81099aa9>] sleep_on_p=
age+0x9/0x10
Apr  1 11:59:15 st kernel: [168360.753154]  [<ffffffff815723c2>] __wait_on_=
bit_lock+0x52/0xb0
Apr  1 11:59:15 st kernel: [168360.753157]  [<ffffffff81099a92>] __lock_pag=
e+0x62/0x70
Apr  1 11:59:15 st kernel: [168360.753162]  [<ffffffff8105c600>] ? autoremo=
ve_wake_function+0x40/0x40
Apr  1 11:59:15 st kernel: [168360.753173]  [<ffffffffa04f72f3>] extent_wri=
te_cache_pages.clone.19.clone.29+0x1c3/0x310 [btrfs]
Apr  1 11:59:15 st kernel: [168360.753186]  [<ffffffffa04f76f3>] extent_wri=
tepages+0x43/0x60 [btrfs]
Apr  1 11:59:15 st kernel: [168360.753196]  [<ffffffffa04d98d0>] ? uncompre=
ss_inline.clone.45+0x1d0/0x1d0 [btrfs]
Apr  1 11:59:15 st kernel: [168360.753207]  [<ffffffffa04d9252>] btrfs_writ=
epages+0x22/0x30 [btrfs]
Apr  1 11:59:15 st kernel: [168360.753211]  [<ffffffff810a2d0c>] do_writepa=
ges+0x1c/0x30
Apr  1 11:59:15 st kernel: [168360.753217]  [<ffffffff81104b29>] writeback_=
single_inode+0xf9/0x250
Apr  1 11:59:15 st kernel: [168360.753220]  [<ffffffff8103b4f5>] ? add_pree=
mpt_count+0x95/0xd0
Apr  1 11:59:15 st kernel: [168360.753224]  [<ffffffff81104ef5>] writeback_=
sb_inodes+0xe5/0x1c0
Apr  1 11:59:15 st kernel: [168360.753228]  [<ffffffff81105b53>] writeback_=
inodes_wb+0x83/0x170
Apr  1 11:59:15 st kernel: [168360.753232]  [<ffffffff81105efb>] wb_writeba=
ck+0x2bb/0x330
Apr  1 11:59:15 st kernel: [168360.753236]  [<ffffffff810a2315>] ? determin=
e_dirtyable_memory+0x15/0x30
Apr  1 11:59:15 st kernel: [168360.753240]  [<ffffffff81106110>] wb_do_writ=
eback+0x1a0/0x250
Apr  1 11:59:15 st kernel: [168360.753245]  [<ffffffff81106252>] bdi_writeb=
ack_thread+0x92/0x180
Apr  1 11:59:15 st kernel: [168360.753248]  [<ffffffff811061c0>] ? wb_do_wr=
iteback+0x250/0x250
Apr  1 11:59:15 st kernel: [168360.753252]  [<ffffffff811061c0>] ? wb_do_wr=
iteback+0x250/0x250
Apr  1 11:59:15 st kernel: [168360.753255]  [<ffffffff8105c0e6>] kthread+0x=
96/0xa0
Apr  1 11:59:15 st kernel: [168360.753259]  [<ffffffff815758d4>] kernel_thr=
ead_helper+0x4/0x10
Apr  1 11:59:15 st kernel: [168360.753263]  [<ffffffff8105c050>] ? kthread_=
worker_fn+0x190/0x190
Apr  1 11:59:15 st kernel: [168360.753266]  [<ffffffff815758d0>] ? gs_chang=
e+0xb/0xb
Apr  1 11:59:54 st kernel: [168399.199337] ------------[ cut here ]--------=
----
Apr  1 11:59:54 st kernel: [168399.199368] kernel BUG at fs/btrfs/extent-tr=
ee.c:5479!
Apr  1 11:59:54 st kernel: [168399.199380] invalid opcode: 0000 [#1] PREEMP=
T SMP=20
Apr  1 11:59:54 st kernel: [168399.199397] last sysfs file: /sys/devices/vi=
rtual/vtconsole/vtcon1/uevent
Apr  1 11:59:54 st kernel: [168399.199409] CPU 0=20
Apr  1 11:59:54 st kernel: [168399.199416] Modules linked in: btrfs bridge =
stp llc zlib_deflate lzo_decompress lzo_compress crc32c libcrc32c tun kvm_a=
md kvm fuse nouveau ttm drm_kms_helper drm i2c_algo_bit forcedeth i2c_core =
8139cp 8139too cfbcopyarea cfbimgblt cfbfillrect [last unloaded: btrfs]
Apr  1 11:59:54 st kernel: [168399.199508]=20
Apr  1 11:59:54 st kernel: [168399.199516] Pid: 18178, comm: btrfs-endio-wr=
i Not tainted 2.6.39-rc1+ #2 To Be Filled By O.E.M. To Be Filled By O.E.M./=
ALiveNF6G-VSTA
Apr  1 11:59:54 st kernel: [168399.199540] RIP: 0010:[<ffffffffa04c1123>]  =
[<ffffffffa04c1123>] alloc_reserved_file_extent.clone.66+0x213/0x220 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199589] RSP: 0018:ffff88000de7ba80  EFLA=
GS: 00010286
Apr  1 11:59:54 st kernel: [168399.199600] RAX: 00000000ffffffe4 RBX: ffff8=
80077f17bd0 RCX: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199612] RDX: 0000000000000000 RSI: ffff8=
80077f17bd0 RDI: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199623] RBP: ffff88000de7bb00 R08: 00000=
00000000000 R09: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199635] R10: ffffffffffffffe4 R11: 00000=
00000000002 R12: 00000000000000b2
Apr  1 11:59:54 st kernel: [168399.199647] R13: 0000000000000000 R14: ffff8=
8000de7bbb0 R15: ffff88001e16ee00
Apr  1 11:59:54 st kernel: [168399.199659] FS:  00007fcc3e5f2700(0000) GS:f=
fff88007bc00000(0000) knlGS:00000000f68deb20
Apr  1 11:59:54 st kernel: [168399.199673] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Apr  1 11:59:54 st kernel: [168399.199683] CR2: 00007f87634fab00 CR3: 00000=
00033310000 CR4: 00000000000006f0
Apr  1 11:59:54 st kernel: [168399.199694] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199705] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Apr  1 11:59:54 st kernel: [168399.199718] Process btrfs-endio-wri (pid: 18=
178, threadinfo ffff88000de7a000, task ffff88007083d840)
Apr  1 11:59:54 st kernel: [168399.199731] Stack:
Apr  1 11:59:54 st kernel: [168399.199736]  ffff880000000035 00000000002c9a=
4e 0000000000000005 0000000000000000
Apr  1 11:59:54 st kernel: [168399.199755]  ffff880036370928 ffffffffa04f98=
4e ffff88000de7bad0 ffff8800166dc000
Apr  1 11:59:54 st kernel: [168399.199773]  ffff88000de7bb10 00000035000000=
01 ffff88000de7baf0 ffff88000616aa20
Apr  1 11:59:54 st kernel: [168399.199790] Call Trace:
Apr  1 11:59:54 st kernel: [168399.199814]  [<ffffffffa04f984e>] ? unmap_ex=
tent_buffer+0xe/0x40 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199831]  [<ffffffffa04c414c>] run_cluste=
red_refs+0x2ec/0x860 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199850]  [<ffffffffa04f9755>] ? map_priv=
ate_extent_buffer+0xd5/0x1c0 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199871]  [<ffffffffa0514b01>] ? btrfs_fi=
nd_ref_cluster+0xe1/0x180 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199889]  [<ffffffffa04c4780>] btrfs_run_=
delayed_refs+0xc0/0x210 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199909]  [<ffffffffa04d5ca8>] __btrfs_en=
d_transaction+0x68/0x220 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199928]  [<ffffffffa04d5ea0>] btrfs_end_=
transaction+0x10/0x20 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199946]  [<ffffffffa04dba0c>] btrfs_fini=
sh_ordered_io+0x28c/0x330 [btrfs]
Apr  1 11:59:54 st kernel: [168399.199965]  [<ffffffff810a2e32>] ? test_cle=
ar_page_writeback+0xf2/0x130
Apr  1 11:59:54 st kernel: [168399.199984]  [<ffffffffa04dbac5>] btrfs_writ=
epage_end_io_hook+0x15/0x20 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200004]  [<ffffffffa04f4adb>] end_bio_ex=
tent_writepage+0x13b/0x180 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8110f528>] bio_endio+=
0x18/0x30
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa04cf1ac>] end_workqu=
eue_fn+0xec/0x120 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa0501dfc>] worker_loo=
p+0xac/0x510 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa0501d50>] ? btrfs_qu=
eue_worker+0x300/0x300 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8105c0e6>] kthread+0x=
96/0xa0
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff815758d4>] kernel_thr=
ead_helper+0x4/0x10
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8105c050>] ? kthread_=
worker_fn+0x190/0x190
Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff815758d0>] ? gs_chang=
e+0xb/0xb
Apr  1 11:59:54 st kernel: [168399.200010] Code: 48 83 c4 58 b8 f4 ff ff ff=
 5b 41 5c 41 5d 41 5e 41 5f c9 c3 49 8b 56 09 49 8b 36 48 c7 c7 50 19 52 a0=
 31 c0 e8 de fb 0a e1 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 =
89 e5 41 57 41 56=20
Apr  1 11:59:54 st kernel: [168399.200010] RIP  [<ffffffffa04c1123>] alloc_=
reserved_file_extent.clone.66+0x213/0x220 [btrfs]
Apr  1 11:59:54 st kernel: [168399.200010]  RSP <ffff88000de7ba80>
Apr  1 11:59:54 st kernel: [168399.203852] ---[ end trace c4a85bad852f7be8 =
]---

--MP_/ujbihMFs5kh8athhXSlwcjB--

--Sig_/gtS6p9H=livA9lRT7AfzyQz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2W6jgACgkQcaHudmEf86rgjACdGKl/RxaleIcQBnILG4zpLVvR
Jk4Ani8ARlrRK+2p1VZ+L6Cth13DQ28F
=2s9+
-----END PGP SIGNATURE-----

--Sig_/gtS6p9H=livA9lRT7AfzyQz--
