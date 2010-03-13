From: Phillip Michael <oopsicrappe@gmail.com>
Subject: [BUG] scheduling while atomic: init/1/0x00000002
Date: Sat, 13 Mar 2010 15:49:23 -0800
Message-ID: <45e1b66a1003131549k28173905r85ab74cd870db36e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem with three subvolumes. One of them (named
arch64) has 64 bit linux, one (arch32)  has 32 bit linux, and the
third (files) has various files. After an unsuccessful tuxonice
resume, the arch64 subvolume will no longer boot. It shows this bug:

VFS: Mounted root (btrfs filesystem) readonly on device 0:13.
Freeing unused kernel memory: 480k freed
BFS CPU scheduler v0.315 by Con Kolivas.
BUG: scheduling while atomic: init/1/0x00000002
Modules linked in:
Pid: 1, comm: init Not tainted 2.6.33-zen2-20100307-stable #6
Call Trace:
 [<ffffffff81514828>] ? schedule+0x768/0xa10
 [<ffffffff810ca560>] ? sync_page+0x0/0x50
 [<ffffffff81514b3b>] ? io_schedule+0x6b/0xb0
 [<ffffffff810ca59d>] ? sync_page+0x3d/0x50
 [<ffffffff810ca560>] ? sync_page+0x0/0x50
 [<ffffffff815152a1>] ? __wait_on_bit+0x51/0x80
 [<ffffffff810ca79b>] ? wait_on_page_bit+0x6b/0x80
 [<ffffffff8105c110>] ? wake_bit_function+0x0/0x40
 [<ffffffff811b4857>] ? read_extent_buffer_pages+0x477/0x4d0
 [<ffffffff8118cb80>] ? btree_get_extent+0x0/0x1c0
 [<ffffffff8118ca85>] ? btree_read_extent_buffer_pages+0x55/0xb0
 [<ffffffff8118d535>] ? read_tree_block+0x35/0x60
 [<ffffffff81170d78>] ? read_block_for_search+0x118/0x3f0
 [<ffffffff811c06b0>] ? btrfs_wake_function+0x0/0x20
 [<ffffffff8117a6aa>] ? btrfs_serch_slot+0x4ca/0xaf0
 [<ffffffff81193d20>] ? btrfs_find_actor+0x0/0x30
 [<ffffffff8118bed5>] ? btrfs_lookup_inode+0x25/0xa0
 [<ffffffff8119a4fb>] ? btrfs_iget+0x10b/0x460
 [<ffffffff8119d36e>] ? btrfs_lookup_dentry+0x43e/0x480
 [<ffffffff8119d3b9>] ? btrfs_lookup+0x9/0x20
 [<ffffffff8110e198>] ? do_lookup+0x1e8/0x280
 [<ffffffff81110894>] ? link_path_walk+0x6c4/0xf10
 [<ffffffff8111127a>] ? path_walk+0x5a/0xd0
 [<ffffffff81111353>] ? do_path_lookup+0x63/0xb0
 [<ffffffff81112a73>] ? do_flip_open+0x763/0xd00
 [<ffffffff810e3a5a>] ? __do_fault+0x3aa/0x4a0
 [<ffffffff8111d44a>] ? alloc_fd+0xfa/0x140
 [<ffffffff8110129c>] ? do_sys_open+0x6c/0x1b0
 [<ffffffff81002f6b>] ? system_call_fastpath+0x16/0x1b

I can mount the filesystem from a different kernel, but when I try to
ls the arch64 subvolume, dmesg fills up with this:
[ 8135.577195] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8135.577407] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8135.577630] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8135.577643] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.577176] __ratelimit: 28458 callbacks suppressed
[ 8140.577182] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.577197] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.577425] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.577647] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.577855] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.577869] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.578167] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.578390] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.578605] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8140.578618] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.578053] __ratelimit: 28552 callbacks suppressed
[ 8145.578060] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.578275] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.578488] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.578502] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.578733] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.578962] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.579189] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.579203] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.579418] parent transid verify failed on 511141027840 wanted
58983 found 58977
[ 8145.579647] parent transid verify failed on 511141027840 wanted
58983 found 58977

I also got this bug once:
device label btrfs devid 1 transid 59380 /dev/sda7
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1229!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/md0/md/array_state
CPU 0
Modules linked in: video output arc4 ecb iwl3945 iwlcore mac80211
cfg80211 e1000e btusb bluetooth rfkill i2c_i801 i2c_core shpchp raid10
raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx raid1 raid0 sbp2 ohci1394 ieee1394 sl811_hcd usb_storage
pmcraid be2iscsi virtio_blk bnx2i cnic uio ipv6 fcoe libfcoe libfc
osst sym53c8xx atp870u hptiop ses enclosure aic79xx aic7xxx aic94xx
ppa raid_class sym53c500_cs qlogic_cs qlogicfas408 aacraid imm parport
mvsas 3w_xxxx initio gdth arcmsr stex tmscsim dc395x iscsi_tcp
libiscsi_tcp 3w_9xxx a100u2w BusLogic libsrp libiscsi st ch
scsi_transport_srp scsi_transport_spi qla4xxx scsi_transport_iscsi
qla2xxx lpfc scsi_transport_fc scsi_tgt qla1280 megaraid_sas
megaraid_mbox megaraid_mm megaraid pdc_adma sata_vsc sata_via sata_uli
sata_sx4 sata_svw sata_sis sata_sil sata_sil24 sata_qstor sata_promise
sata_nv sata_mv sata_inic162x pata_via pata_triflex pata_sl82c105
pata_sis pata_sil680 pata_serverworks pata_sch pata_pdc202xx_old
pata_pdc2027x pata_pcmcia pata_opti pata_optidma pata_oldpiix
pata_ns87415 pata_ns87410 pata_ninja32 pata_netcell pata_marvell
pata_jmicron pata_it821x pata_it8213 pata_hpt3x3 pata_hpt3x2n
pata_hpt37x pata_hpt366 pata_efar pata_cypress pata_cs5530 pata_cs5520
pata_cmd64x pata_cmd640 pata_atiixp pata_artop pata_amd pata_ali
pata_acpi scsi_wait_scan ata_generic
Pid: 6614, comm: btrfsctl Not tainted 2.6.32.09-std140-amd64 #1 200793U
RIP: 0010:[<ffffffff8131b7d3>]  [<ffffffff8131b7d3>]
lookup_inline_extent_backref+0xe3/0x3a9
RSP: 0018:ffff8800b893f908  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff8800ac571090 RCX: 0000000000000002
RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff8800ac516240
RBP: ffff8800b893f9a8 R08: ffff8800b893f7a0 R09: ffff8800b893f798
R10: ffff8800b893f868 R11: 0000000000000000 R12: 00000000000000b0
R13: ffff8800ac577000 R14: 0000000000000001 R15: 0000000000000009
FS:  0000000000000000(0000) GS:ffff880001e00000(0063) knlGS:00000000f761f6f0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f759b344 CR3: 00000000ba08b000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfsctl (pid: 6614, threadinfo ffff8800b893e000, task ffff8800badf2e80)
Stack:
 ffff8800b893f938 ffffffff81323baa ffff8800ac5701b0 ffff8800b893fa00
<0> 00000000000000b0 0000007702612000 ffff8800b893f9a8 ffff88007f1a5000
<0> 00000009b8d07000 ffff8800b8ab2020 0000007702612000 00000000001000a8
Call Trace:
 [<ffffffff81323baa>] ? btrfs_mark_buffer_dirty+0x8c/0xcf
 [<ffffffff810efd26>] ? add_partial+0x3b/0x51
 [<ffffffff8131c244>] insert_inline_extent_backref+0x62/0xd9
 [<ffffffff8131c358>] __btrfs_inc_extent_ref+0x9d/0x1b4
 [<ffffffff8133f446>] ? map_extent_buffer+0x6a/0xa4
 [<ffffffff8131d166>] run_one_delayed_ref+0x45c/0x4b5
 [<ffffffff81318d62>] ? btrfs_put_delayed_ref+0x53/0x57
 [<ffffffff8131eefd>] run_clustered_refs+0x255/0x2a7
 [<ffffffff8131754b>] ? btrfs_get_alloc_profile+0x5a/0x5c
 [<ffffffff8131f01d>] btrfs_run_delayed_refs+0xce/0x18e
 [<ffffffff81328cba>] btrfs_commit_transaction+0x315/0x5ef
 [<ffffffff8106747b>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81328498>] ? start_transaction+0x122/0x12e
 [<ffffffff8134a3f3>] btrfs_mksubvol+0x1fb/0x2c9
 [<ffffffff8134a5cf>] btrfs_ioctl_snap_create+0x10e/0x140
 [<ffffffff8134b99b>] btrfs_ioctl+0x3f8/0x935
 [<ffffffff810d7a3d>] ? handle_mm_fault+0x35a/0x7bd
 [<ffffffff81113e49>] ? mntput_no_expire+0x29/0xec
 [<ffffffff813cbdc6>] ? might_fault+0x21/0x23
 [<ffffffff813cbec5>] ? __strncpy_from_user+0x1e/0x49
 [<ffffffff81136d4b>] compat_sys_ioctl+0x1ed/0x4a2
 [<ffffffff8106a976>] ? up_read+0xe/0x10
 [<ffffffff816464bd>] ? do_page_fault+0x270/0x2a0
 [<ffffffff810342e2>] ia32_sysret+0x0/0x5
Code: 44 8b 45 a4 48 8b 75 98 48 8d 55 b0 41 b9 01 00 00 00 48 89 d9
4c 89 ef e8 39 a1 ff ff 83 f8 00 41 89 c6 0f 8c 94 02 00 00 74 04 <0f>
0b eb fe 4c 8b 33 8b 73 40 4c 89 f7 e8 1e fc ff ff 41 89 c7
RIP  [<ffffffff8131b7d3>] lookup_inline_extent_backref+0xe3/0x3a9
 RSP <ffff8800b893f908>
---[ end trace b67345c9a26987af ]---


btrfsck output:
leaf 512089214976 items 35 free space 1335 generation 59072 owner 2
fs uuid 9be2a35f-4055-4a64-a616-df6b25219706
chunk uuid 3d833aa2-ca21-4ac3-984e-507631167503
	item 0 key (511140827136 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
		extent refs 1 gen 57459 flags 2
		tree block key (467119030272 a8 20480) level 0
		tree block backref root 2
	item 1 key (511140831232 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
		extent refs 1 gen 58943 flags 2
		tree block key (461561892864 a8 53248) level 0
		tree block backref root 2
	item 2 key (511140839424 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
		extent refs 1 gen 58840 flags 2
		tree block key (716907 6c 7036928) level 0
		tree block backref root 256
	item 3 key (511140843520 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
		extent refs 1 gen 58288 flags 2
		tree block key (511501508608 a8 4096) level 0
		tree block backref root 2
	item 4 key (511140847616 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
		extent refs 1 gen 58342 flags 2
		tree block key (716904 60 18110) level 0
		tree block backref root 256
	item 5 key (511140851712 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
		extent refs 1 gen 58334 flags 2
		tree block key (1972665 6c 0) level 0
		tree block backref root 256
	item 6 key (511140855808 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
		extent refs 1 gen 58785 flags 2
		tree block key (18446744073709551606 80 418156916736) level 0
		tree block backref root 7
	item 7 key (511140859904 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
		extent refs 1 gen 57658 flags 2
		tree block key (716909 6c 32690176) level 0
		tree block backref root 256
	item 8 key (511140864000 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
		extent refs 1 gen 58826 flags 2
		tree block key (716904 54 685635811) level 0
		tree block backref root 256
	item 9 key (511140868096 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
		extent refs 1 gen 58334 flags 2
		tree block key (716904 60 16063) level 0
		tree block backref root 256
	item 10 key (511140880384 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
		extent refs 1 gen 58789 flags 2
		tree block key (973501 6c 2875392) level 0
		tree block backref root 256
	item 11 key (511140884480 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
		extent refs 1 gen 58342 flags 2
		tree block key (716904 54 2871211414) level 0
		tree block backref root 256
	item 12 key (511140892672 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (2245316 6c 0) level 0
		tree block backref root 256
	item 13 key (511140896768 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
		extent refs 1 gen 58970 flags 2
		tree block key (716904 54 828584097) level 0
		tree block backref root 256
	item 14 key (511140900864 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
		extent refs 1 gen 58275 flags 2
		tree block key (511557660672 a8 4096) level 0
		tree block backref root 2
	item 15 key (511140904960 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (2240869 c 20678) level 0
		tree block backref root 256
	item 16 key (511140913152 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
		extent refs 1 gen 58939 flags 2
		tree block key (18446744073709551606 80 469139288064) level 0
		tree block backref root 7
	item 17 key (511140921344 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (714054 1 0) level 0
		tree block backref root 256
	item 18 key (511140925440 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
		extent refs 1 gen 58366 flags 2
		tree block key (461611687936 a8 12288) level 0
		tree block backref root 2
	item 19 key (511140929536 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (714051 6c 0) level 0
		tree block backref root 256
	item 20 key (511140933632 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (2245495 1 0) level 0
		tree block backref root 256
	item 21 key (511140941824 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
		extent refs 1 gen 58789 flags 2
		tree block key (973501 6c 8962048) level 0
		tree block backref root 256
	item 22 key (511140945920 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
		extent refs 1 gen 58807 flags 2
		tree block key (716890 6c 581632) level 0
		tree block backref root 256
	item 23 key (511140950016 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (716907 6c 417792) level 1
		tree block backref root 256
	item 24 key (511140954112 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
		extent refs 1 gen 57639 flags 2
		tree block key (716920 1 0) level 0
		tree block backref root 256
	item 25 key (511140962304 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
		extent refs 1 gen 58575 flags 2
		tree block key (716904 54 2556595700) level 0
		tree block backref root 256
	item 26 key (511140966400 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
		extent refs 1 gen 57639 flags 2
		tree block key (2023391 6c 0) level 0
		tree block backref root 256
	item 27 key (511140970496 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
		extent refs 1 gen 58971 flags 2
		tree block key (716697 1 0) level 0
		tree block backref root 256
	item 28 key (511140974592 EXTENT_ITEM 4096) itemoff 2516 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (716907 6c 3416064) level 0
		tree block backref root 256
	item 29 key (511140978688 EXTENT_ITEM 4096) itemoff 2465 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (18446744073709551606 80 469012008960) level 0
		tree block backref root 7
	item 30 key (511140986880 EXTENT_ITEM 4096) itemoff 2414 itemsize 51
		extent refs 1 gen 58575 flags 2
		tree block key (716904 60 18173) level 0
		tree block backref root 256
	item 31 key (511140990976 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
		extent refs 1 gen 58977 flags 2
		tree block key (716907 1 0) level 0
		tree block backref root 256
	item 32 key (511141007360 EXTENT_ITEM 4096) itemoff 2312 itemsize 51
		extent refs 1 gen 58789 flags 2
		tree block key (973501 6c 12595200) level 0
		tree block backref root 256
	item 33 key (511141011456 EXTENT_ITEM 4096) itemoff 2261 itemsize 51
		extent refs 1 gen 58948 flags 2
		tree block key (594454 54 762147513) level 2
		tree block backref root 256
	item 34 key (511141015552 EXTENT_ITEM 4096) itemoff 2210 itemsize 51
		extent refs 1 gen 58803 flags 2
		tree block key (973501 6c 14749696) level 0
		tree block backref root 256
failed to find block number 511141027840

Thanks,
Phil
