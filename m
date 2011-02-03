From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Stuck in a big loop
Date: Thu, 3 Feb 2011 16:25:20 -0500
Message-ID: <AANLkTik89Fr2y733sne0b38+usR-KCF2eEqG4BubJaaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've got a filesystem I use to compile OpenWRT, it is ordered like:
Original firmware, updated once in a while:
sources/original-sources/backfire
sources/original-sources/trunk

Downloads and some other stuff:
dl/
stuff/

Test compiles:
sources/<compiles>
sources/old-<date>/<old compiles>


The filesystem was created with kernel 2.6.35, and I was able to have
about 6 compiles from original-sources and 4 others snapshotted from
already compiled stuff.
Filesystem has always been mounted with -o compress

I upgraded to 2.6.37 recently, decided to mount with -o space_cache to
see if it improves performance a bit,
I updated my sources in original-sources, then made a snapshot of one
of the original tree.
I had open files in a older compile directory and deleted that
subvolume while files were open, it disappeared but files were still
open.
I then decided to make menuconfig in the newly created snapshot, it
hung with 'awk' and 'flush-btrfs' using 100% CPU.
Then I found out about those open files, killed everything using those
old file and the new subvolume, it de-froze after about 5 minutes.
I umounted the btrfs filesystem and remounted it again, all fine, I
was able to compile the new snapshot. Some events about hung tasks
appeared in the dmesg log, I will attach them at the end of the
message.

Today, 2 days later, I made a new snapshot of the original sources and
started make menuconfig right away, now 'perl' and 'flush-btrfs' use
100% CPU again and now 30 minutes later, they are still stuck so I
dumped process using SysRq+T, i guess this could be a bug in 2.6.37 or
space_cache ? 2.6.37 is vanilla and btrfs-progs is
v0.19-16-g075587c-dirty.

Here follow the stack dump of 'perl' and 'flush-btrfs', the 2
processes are mostly in 'R' state and use around 40-60% CPU each and
complete themselve to 100%:

=== Perl ===
[334438.931233] perl          W ffffffff8151ea5a  4848 32252      1 0x00000004
[334438.931245]  ffff8800612bf9b8 ffffffff8151eae5 ffff8800df48d680
ffff88011b676740
[334438.931256]  0000000000000000 0000000000000000 ffff8800612bffd8
0000000000011a80
[334438.931267]  ffff880049365880 ffff880049365c18 ffff880049365c10
ffff8800612be000
[334438.931277] Call Trace:
[334438.931284]  [<ffffffff8102f274>] ? enqueue_entity+0x218/0x221
[334438.931291]  [<ffffffff8151ed06>] schedule_timeout+0x22/0xbb
[334438.931298]  [<ffffffff8102ff83>] pick_next_task+0x25/0x4b
[334438.931305]  [<ffffffff81520059>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
[334438.931312]  [<ffffffff81035cab>] try_to_wake_up+0x235/0x250
[334438.931321]  [<ffffffff81520083>] ? _raw_spin_unlock_irq+0x1f/0x2a
[334438.931327]  [<ffffffff8151e2ca>] ? wait_for_common+0x9e/0x10b
[334438.931335]  [<ffffffff8103ed23>] ? local_bh_enable_ip+0x9/0xb
[334438.931341]  [<ffffffff8151e3d1>] ? wait_for_completion+0x18/0x1a
[334438.931349]  [<ffffffff810e560d>] ? writeback_inodes_sb_nr+0x71/0x78
[334438.931356]  [<ffffffff8151ed83>] ? schedule_timeout+0x9f/0xbb
[334438.931363]  [<ffffffff810e5a35>] ? writeback_inodes_sb_nr_if_idle+0x3c/0x52
[334438.931382]  [<ffffffffa0dd2c94>] ? shrink_delalloc+0xac/0x140 [btrfs]
[334438.931401]  [<ffffffffa0dd3437>] ?
btrfs_delalloc_reserve_metadata+0x134/0x146 [btrfs]
[334438.931420]  [<ffffffffa0dd6f52>] ?
btrfs_delalloc_reserve_space+0x25/0x42 [btrfs]
[334438.931447]  [<ffffffffa0df046e>] ? btrfs_file_aio_write+0x55a/0x918 [btrfs]
[334438.931455]  [<ffffffff810dc387>] ? touch_atime+0x82/0x13a
[334438.931463]  [<ffffffff8109adc7>] ? lru_cache_add_lru+0x3c/0x3e
[334438.931469]  [<ffffffff810b1489>] ? page_add_new_anon_rmap+0x75/0x87
[334438.931476]  [<ffffffff810c9d58>] ? do_sync_write+0xc6/0x103
[334438.931483]  [<ffffffff811fdf05>] ? security_file_permission+0x29/0x2e
[334438.931490]  [<ffffffff810ca2b1>] ? vfs_write+0xa9/0x105
[334438.931496]  [<ffffffff810ca3c3>] ? sys_write+0x45/0x69
[334438.931503]  [<ffffffff810029fb>] ? system_call_fastpath+0x16/0x1b


=== Flush-BTRFS ===
[334438.932351] flush-btrfs-5 R  running task     6696   366      2 0x00000000
[334438.932361]  ffff88003d9a3e60 0000000000000046 ffff88003d9a3db0
ffffffff81a0b020
[334438.932374]  ffff88003d9a3dc0 ffffffff8103ed23 ffff88003d9a3fd8
0000000000011a80
[334438.932385]  ffff88003d9a3e60 ffff880075672878 ffff880075672870
ffff88003d9a2000
[334438.932398] Call Trace:
[334438.932404]  [<ffffffff8103ed23>] ? local_bh_enable_ip+0x9/0xb
[334438.932412]  [<ffffffff810e625b>] ? wb_do_writeback+0x62/0x14c
[334438.932420]  [<ffffffff810e646a>] bdi_writeback_thread+0x125/0x16f
[334438.932427]  [<ffffffff810e6345>] ? bdi_writeback_thread+0x0/0x16f
[334438.932433]  [<ffffffff8104fda6>] kthread+0x7d/0x85
[334438.932439]  [<ffffffff810037d4>] kernel_thread_helper+0x4/0x10
[334438.932446]  [<ffffffff8104fd29>] ? kthread+0x0/0x85
[334438.932452]  [<ffffffff810037d0>] ? kernel_thread_helper+0x0/0x10



Those appeared in the log after the subvolume deletion:
[ 9089.280923] btrfs: use compression
[ 9117.763662] device label p4-openwrt devid 1 transid 2002
/dev/mapper/vgP4RAID5-openwrt
[ 9117.764087] btrfs: use compression
[ 9134.591635] device label p4-openwrt devid 1 transid 2005
/dev/mapper/vgP4RAID5-openwrt
[ 9134.592054] btrfs: use compression
[ 9134.592059] btrfs: enabling disk space caching
[61001.018865] input input4: event field not found
[61001.018881] input input4: event field not found
[153879.344296] REISERFS (device dm-18): found reiserfs format "3.6"
with standard journal
[153879.344325] REISERFS (device dm-18): using ordered data mode
[153879.348909] REISERFS (device dm-18): journal params: device dm-18,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 30, max trans age 30
[153879.349366] REISERFS (device dm-18): checking transaction log (dm-18)
[153879.385282] REISERFS (device dm-18): Using r5 hash to sort names
[154331.216266] viewvc.cgi used greatest stack depth: 3000 bytes left
[177265.922971] ------------[ cut here ]------------
[177265.923006] WARNING: at fs/btrfs/extent-tree.c:3871
btrfs_free_block_groups+0x16d/0x27e [btrfs]()
[177265.923012] Hardware name: P55-USB3
[177265.923016] Modules linked in: netconsole configfs sch_sfq cls_fw
sch_htb nfsd xt_length ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner
xt_NFQUEUE xt_multiport xt_iprange xt_hashlimit xt_connmark
nf_nat_proto_udplite nf_nat_pptp nf_conntrack_pptp
nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_h323 nf_conntrack_h323
nf_nat_sip nf_conntrack_sip nf_nat_tftp nf_conntrack_tftp btrfs
squashfs xfs exportfs vboxnetadp vboxnetflt vboxdrv ip_gre gre ipip
bridge stp llc fuse tun usblp nvidia(P) usb_storage ehci_hcd xhci_hcd
uhci_hcd
[177265.923176] Pid: 8844, comm: umount Tainted: P            2.6.37 #3
[177265.923183] Call Trace:
[177265.923196]  [<ffffffff81039b95>] warn_slowpath_common+0x80/0x98
[177265.923203]  [<ffffffff81039bc2>] warn_slowpath_null+0x15/0x17
[177265.923226]  [<ffffffffa0dd25f6>]
btrfs_free_block_groups+0x16d/0x27e [btrfs]
[177265.923251]  [<ffffffffa0ddff6b>] close_ctree+0x183/0x344 [btrfs]
[177265.923261]  [<ffffffff810dc7e2>] ? destroy_inode+0x38/0x4e
[177265.923268]  [<ffffffff810dcce1>] ? dispose_list+0xb0/0xc5
[177265.923275]  [<ffffffff810dce81>] ? evict_inodes+0x65/0x12d
[177265.923295]  [<ffffffffa0dc9217>] btrfs_put_super+0x18/0x27 [btrfs]
[177265.923305]  [<ffffffff810cc53b>] generic_shutdown_super+0x66/0xe8
[177265.923314]  [<ffffffff810cc608>] kill_anon_super+0x11/0x4f
[177265.923321]  [<ffffffff810cc024>] deactivate_locked_super+0x21/0x41
[177265.923328]  [<ffffffff810cc4d0>] deactivate_super+0x40/0x45
[177265.923335]  [<ffffffff810e088a>] mntput_no_expire+0xdd/0x10b
[177265.923342]  [<ffffffff810e0f28>] sys_umount+0x2d2/0x2fd
[177265.923351]  [<ffffffff810029fb>] system_call_fastpath+0x16/0x1b
[177265.923362] ---[ end trace a767748affd6d5fa ]---
[177265.923367] ------------[ cut here ]------------
[177265.923386] WARNING: at fs/btrfs/extent-tree.c:3872
btrfs_free_block_groups+0x188/0x27e [btrfs]()
[177265.923391] Hardware name: P55-USB3
[177265.923394] Modules linked in: netconsole configfs sch_sfq cls_fw
sch_htb nfsd xt_length ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner
xt_NFQUEUE xt_multiport xt_iprange xt_hashlimit xt_connmark
nf_nat_proto_udplite nf_nat_pptp nf_conntrack_pptp
nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_h323 nf_conntrack_h323
nf_nat_sip nf_conntrack_sip nf_nat_tftp nf_conntrack_tftp btrfs
squashfs xfs exportfs vboxnetadp vboxnetflt vboxdrv ip_gre gre ipip
bridge stp llc fuse tun usblp nvidia(P) usb_storage ehci_hcd xhci_hcd
uhci_hcd
[177265.923545] Pid: 8844, comm: umount Tainted: P        W   2.6.37 #3
[177265.923551] Call Trace:
[177265.923560]  [<ffffffff81039b95>] warn_slowpath_common+0x80/0x98
[177265.923571]  [<ffffffff81039bc2>] warn_slowpath_null+0x15/0x17
[177265.923590]  [<ffffffffa0dd2611>]
btrfs_free_block_groups+0x188/0x27e [btrfs]
[177265.923613]  [<ffffffffa0ddff6b>] close_ctree+0x183/0x344 [btrfs]
[177265.923620]  [<ffffffff810dc7e2>] ? destroy_inode+0x38/0x4e
[177265.923633]  [<ffffffff810dcce1>] ? dispose_list+0xb0/0xc5
[177265.923639]  [<ffffffff810dce81>] ? evict_inodes+0x65/0x12d
[177265.923657]  [<ffffffffa0dc9217>] btrfs_put_super+0x18/0x27 [btrfs]
[177265.923665]  [<ffffffff810cc53b>] generic_shutdown_super+0x66/0xe8
[177265.923678]  [<ffffffff810cc608>] kill_anon_super+0x11/0x4f
[177265.923684]  [<ffffffff810cc024>] deactivate_locked_super+0x21/0x41
[177265.923693]  [<ffffffff810cc4d0>] deactivate_super+0x40/0x45
[177265.923701]  [<ffffffff810e088a>] mntput_no_expire+0xdd/0x10b
[177265.923713]  [<ffffffff810e0f28>] sys_umount+0x2d2/0x2fd
[177265.923721]  [<ffffffff810029fb>] system_call_fastpath+0x16/0x1b
[177265.923728] ---[ end trace a767748affd6d5fb ]---
[177265.923734] ------------[ cut here ]------------
[177265.923755] WARNING: at fs/btrfs/extent-tree.c:8239
btrfs_free_block_groups+0x220/0x27e [btrfs]()
[177265.923760] Hardware name: P55-USB3
[177265.923764] Modules linked in: netconsole configfs sch_sfq cls_fw
sch_htb nfsd xt_length ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner
xt_NFQUEUE xt_multiport xt_iprange xt_hashlimit xt_connmark
nf_nat_proto_udplite nf_nat_pptp nf_conntrack_pptp
nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_h323 nf_conntrack_h323
nf_nat_sip nf_conntrack_sip nf_nat_tftp nf_conntrack_tftp btrfs
squashfs xfs exportfs vboxnetadp vboxnetflt vboxdrv ip_gre gre ipip
bridge stp llc fuse tun usblp nvidia(P) usb_storage ehci_hcd xhci_hcd
uhci_hcd
[177265.923919] Pid: 8844, comm: umount Tainted: P        W   2.6.37 #3
[177265.923925] Call Trace:
[177265.923951]  [<ffffffff81039b95>] warn_slowpath_common+0x80/0x98
[177265.923960]  [<ffffffff81039bc2>] warn_slowpath_null+0x15/0x17
[177265.923982]  [<ffffffffa0dd26a9>]
btrfs_free_block_groups+0x220/0x27e [btrfs]
[177265.924010]  [<ffffffffa0ddff6b>] close_ctree+0x183/0x344 [btrfs]
[177265.924020]  [<ffffffff810dc7e2>] ? destroy_inode+0x38/0x4e
[177265.924035]  [<ffffffff810dcce1>] ? dispose_list+0xb0/0xc5
[177265.924044]  [<ffffffff810dce81>] ? evict_inodes+0x65/0x12d
[177265.924063]  [<ffffffffa0dc9217>] btrfs_put_super+0x18/0x27 [btrfs]
[177265.924074]  [<ffffffff810cc53b>] generic_shutdown_super+0x66/0xe8
[177265.924083]  [<ffffffff810cc608>] kill_anon_super+0x11/0x4f
[177265.924101]  [<ffffffff810cc024>] deactivate_locked_super+0x21/0x41
[177265.924110]  [<ffffffff810cc4d0>] deactivate_super+0x40/0x45
[177265.924119]  [<ffffffff810e088a>] mntput_no_expire+0xdd/0x10b
[177265.924128]  [<ffffffff810e0f28>] sys_umount+0x2d2/0x2fd
[177265.924139]  [<ffffffff810029fb>] system_call_fastpath+0x16/0x1b
[177265.924153] ---[ end trace a767748affd6d5fc ]---
[177265.924160] space_info has 1351209984 free, is not full
[177265.924168] space_info total=3229614080, used=1877426176,
pinned=0, reserved=977920, may_use=0, readonly=0
[177271.133710] device label p4-openwrt devid 1 transid 2152
/dev/mapper/vgP4RAID5-openwrt
[177271.134764] btrfs: use compression
[177271.134776] btrfs: enabling disk space caching

Then no more event until today.


If I can help debug this in any other way, it will be a pleasure!
Thank you!
