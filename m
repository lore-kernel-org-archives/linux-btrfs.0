Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:59749 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaAZPLK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jan 2014 10:11:10 -0500
Received: by mail-la0-f43.google.com with SMTP id pv20so3814883lab.16
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 07:11:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 26 Jan 2014 10:11:08 -0500
Message-ID: <CANjusZfFXaNZcMew+6tWfKVdoKuVv+cSCWefvzCr0nMMJJk2sg@mail.gmail.com>
Subject: bad block and io errors
From: "G. Michael Carter" <mikey@carterfamily.ca>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When it rains it pours.   My other array is having some issues.  I
think I have two problems, and wondering if someone can help me make
sense of this:

I've basically got four questions:

1.  How do I repair, or drop block 35435896033280?

2.  How do I identify which drive out of 5 this block is on?

3.  How do I detect which drive is causing the errno=-5 IO failure

4.  How do I identify what files I'm going to loose by this block problem?

----------------------------

[  398.189454] btrfs: corrupt leaf, bad key order:
block=35435896033280,root=1, slot=23
[  398.189616] btrfs: corrupt leaf, bad key order:
block=35435896033280,root=1, slot=23
[  819.115270] btrfs: corrupt leaf, bad key order:
block=35435896033280,root=1, slot=23
[  819.115311] ------------[ cut here ]------------
[  819.115325] WARNING: CPU: 6 PID: 530 at fs/btrfs/super.c:255
__btrfs_abort_transaction+0x11d/0x130 [btrfs]()
[  819.115326] btrfs: Transaction aborted (error -5)
[  819.115326] Modules linked in: ebtable_nat ebtables xt_CHECKSUM tun
bridge stp llc xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ipt_MASQUERADE xt_conntrack iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 ip6table_filter nf_nat
nf_conntrack ip6_tables iptable_mangle hwmon_vid snd_hda_codec_hdmi
snd_hda_codec_realtek iTCO_wdt iTCO_vendor_support btrfs eeepc_wmi
asus_wmi sparse_keymap rfkill mxm_wmi x86_pkg_temp_thermal coretemp
kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel raid6_pq libcrc32c microcode serio_raw xor
i2c_i801 joydev hid_logitech_dj snd_hda_intel snd_seq lpc_ich
snd_hda_codec snd_seq_device mfd_core snd_hwdep snd_pcm e1000e mei_me
ptp snd_page_alloc mei pps_core snd_timer snd soundcore video shpchp
wmi nfsd auth_rpcgss nfs_acl lockd
[  819.115349]  sunrpc uinput binfmt_misc ata_generic pata_acpi radeon
i2c_algo_bit drm_kms_helper ttm drm i2c_core pata_jmicron usb_storage
[  819.115355] CPU: 6 PID: 530 Comm: btrfs-transacti Not tainted
3.12.6-200.fc19.x86_64 #1
[  819.115356] Hardware name: System manufacturer System Product
Name/SABERTOOTH Z77, BIOS 0801 02/24/2012
[  819.115357]  0000000000000009 ffff8803f325dad0 ffffffff81662651
ffff8803f325db18
[  819.115359]  ffff8803f325db08 ffffffff810691dd 00000000fffffffb
ffff88040584b800
[  819.115360]  ffff8803f43f0000 ffffffffa06e2b80 0000000000001661
ffff8803f325db68
[  819.115361] Call Trace:
[  819.115366]  [<ffffffff81662651>] dump_stack+0x45/0x56
[  819.115369]  [<ffffffff810691dd>] warn_slowpath_common+0x7d/0xa0
[  819.115370]  [<ffffffff8106924c>] warn_slowpath_fmt+0x4c/0x50
[  819.115374]  [<ffffffffa0647bbd>]
__btrfs_abort_transaction+0x11d/0x130 [btrfs]
[  819.115379]  [<ffffffffa0658890>] __btrfs_free_extent+0x520/0xa60 [btrfs]
[  819.115386]  [<ffffffffa06b5e14>] ?
btrfs_merge_delayed_refs+0x1f4/0x3d0 [btrfs]
[  819.115390]  [<ffffffffa065ccee>] run_clustered_refs+0x83e/0xeb0 [btrfs]
[  819.115395]  [<ffffffffa065c9cf>] ? run_clustered_refs+0x51f/0xeb0 [btrfs]
[  819.115399]  [<ffffffffa06617a0>] btrfs_run_delayed_refs+0xe0/0x540 [btrfs]
[  819.115405]  [<ffffffffa06718ee>] btrfs_commit_transaction+0x4e/0x970 [btrfs]
[  819.115409]  [<ffffffffa0669005>] transaction_kthread+0x1a5/0x230 [btrfs]
[  819.115414]  [<ffffffffa0668e60>] ? verify_parent_transid+0x150/0x150 [btrfs]
[  819.115416]  [<ffffffff8108b0d0>] kthread+0xc0/0xd0
[  819.115417]  [<ffffffff8108b010>] ? insert_kthread_work+0x40/0x40
[  819.115419]  [<ffffffff816715fc>] ret_from_fork+0x7c/0xb0
[  819.115421]  [<ffffffff8108b010>] ? insert_kthread_work+0x40/0x40
[  819.115422] ---[ end trace 2faf5e88680fa1e9 ]---
[  819.115423] BTRFS error (device sdg1) in __btrfs_free_extent:5729:
errno=-5 IO failure
[  819.115440] BTRFS info (device sdg1): forced readonly
[  819.115442] BTRFS debug (device sdg1): run_one_delayed_ref returned -5
[  819.115443] BTRFS error (device sdg1) in
btrfs_run_delayed_refs:2715: errno=-5 IO failure

-----

Btrfs v3.12
[root@andromeda ~]# btrfs-debug-tree -b 35435896033280
usage: btrfs-debug-tree [-e] [-d] [-r] [-R] [-u]
                        [-b block_num ] device
    -e : print detailed extents info
    -d : print info of btrfs device and root tree dirs only
    -r : print info of roots only
    -R : print info of roots and root backups
    -u : print info of uuid tree only
    -b block_num : print info of the specified block only
Btrfs v3.12
[root@andromeda ~]# btrfs-debug-tree -b 35435896033280 /dev/sdg1
ERROR: device scan failed '/dev/sdg' - Device or resource busy
leaf 35435896033280 items 50 free space 195 generation 967625 owner 2
fs uuid 7bdca818-fa22-4a90-8fb8-9a2e756f0002
chunk uuid 5fb3ebe3-ea00-4f59-92cc-79b3d4a4cfa3
    item 0 key (35453976346624 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615530287104) level 0
        tree block backref root 7
    item 1 key (35453976350720 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
        extent refs 1 gen 967222 flags 2
        tree block key (9122 DIR_INDEX 7) level 0
        tree block backref root 269
    item 2 key (35453976354816 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640570 DIR_INDEX 2704) level 0
        tree block backref root 264
    item 3 key (35453976358912 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615534321664) level 0
        tree block backref root 7
    item 4 key (35453976363008 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
        extent refs 1 gen 967222 flags 2
        tree block key (9645 INODE_ITEM 0) level 0
        tree block backref root 269
    item 5 key (35453976367104 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615538356224) level 0
        tree block backref root 7
    item 6 key (35453976371200 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640572 EXTENT_DATA 0) level 0
        tree block backref root 264
    item 7 key (35453976375296 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
        extent refs 1 gen 967222 flags 2
        tree block key (21118 INODE_ITEM 0) level 0
        tree block backref root 269
    item 8 key (35453976379392 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640575 INODE_ITEM 0) level 0
        tree block backref root 264
    item 9 key (35453976383488 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615542390784) level 0
        tree block backref root 7
    item 10 key (35453976387584 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
        extent refs 1 gen 966094 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 39257195364352) level 0
        tree block backref root 7
    item 11 key (35453976391680 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640582 INODE_ITEM 0) level 0
        tree block backref root 264
    item 12 key (35453976395776 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
        extent refs 1 gen 960302 flags 2
        tree block key (887734 DIR_INDEX 864) level 0
        tree block backref root 276
    item 13 key (35453976399872 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640594 INODE_ITEM 0) level 0
        tree block backref root 264
    item 14 key (35453976403968 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615546425344) level 0
        tree block backref root 7
    item 15 key (35453976408064 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
        extent refs 1 gen 966094 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 39257199398912) level 0
        tree block backref root 7
    item 16 key (35453976412160 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
        extent refs 1 gen 959744 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38122935197696) level 0
        tree block backref root 7
    item 17 key (35453976416256 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615550459904) level 0
        tree block backref root 7
    item 18 key (35453976420352 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386503053312) level 0
        tree block backref root 7
    item 19 key (35453976424448 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
        extent refs 1 gen 966094 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 39257203433472) level 0
        tree block backref root 7
    item 20 key (35453976428544 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
        extent refs 1 gen 966094 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 39257207468032) level 0
        tree block backref root 7
    item 21 key (35453976432640 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615554494464) level 0
        tree block backref root 7
    item 22 key (35453976436736 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386507087872) level 0
        tree block backref root 7
    item 23 key (36003732254720 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615558529024) level 0
        tree block backref root 7
    item 24 key (35453976444928 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615562563584) level 0
        tree block backref root 7
    item 25 key (35453976449024 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615566598144) level 0
        tree block backref root 7
    item 26 key (35453976453120 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615570632704) level 0
        tree block backref root 7
    item 27 key (35453976457216 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386511122432) level 0
        tree block backref root 7
    item 28 key (35453976461312 EXTENT_ITEM 4096) itemoff 2516 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386515156992) level 0
        tree block backref root 7
    item 29 key (35453976465408 EXTENT_ITEM 4096) itemoff 2465 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615574667264) level 0
        tree block backref root 7
    item 30 key (35453976469504 EXTENT_ITEM 4096) itemoff 2414 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386519191552) level 0
        tree block backref root 7
    item 31 key (35453976473600 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386523226112) level 0
        tree block backref root 7
    item 32 key (35453976477696 EXTENT_ITEM 4096) itemoff 2312 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615578701824) level 0
        tree block backref root 7
    item 33 key (35453976481792 EXTENT_ITEM 4096) itemoff 2261 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615582736384) level 0
        tree block backref root 7
    item 34 key (35453976485888 EXTENT_ITEM 4096) itemoff 2210 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615586770944) level 0
        tree block backref root 7
    item 35 key (35453976489984 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386527260672) level 0
        tree block backref root 7
    item 36 key (35453976494080 EXTENT_ITEM 4096) itemoff 2108 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615590805504) level 0
        tree block backref root 7
    item 37 key (35453976498176 EXTENT_ITEM 4096) itemoff 2057 itemsize 51
        extent refs 1 gen 966094 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 39257211502592) level 0
        tree block backref root 7
    item 38 key (35453976502272 EXTENT_ITEM 4096) itemoff 2006 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615594840064) level 0
        tree block backref root 7
    item 39 key (35453976506368 EXTENT_ITEM 4096) itemoff 1955 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615598874624) level 0
        tree block backref root 7
    item 40 key (35453976510464 EXTENT_ITEM 4096) itemoff 1904 itemsize 51
        extent refs 1 gen 966094 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 39257215537152) level 0
        tree block backref root 7
    item 41 key (35453976514560 EXTENT_ITEM 4096) itemoff 1853 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640606 INODE_ITEM 0) level 0
        tree block backref root 264
    item 42 key (35453976518656 EXTENT_ITEM 4096) itemoff 1802 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640613 INODE_ITEM 0) level 0
        tree block backref root 264
    item 43 key (35453976522752 EXTENT_ITEM 4096) itemoff 1751 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386531295232) level 0
        tree block backref root 7
    item 44 key (35453976526848 EXTENT_ITEM 4096) itemoff 1700 itemsize 51
        extent refs 1 gen 958302 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 37615602909184) level 0
        tree block backref root 7
    item 45 key (35453976530944 EXTENT_ITEM 4096) itemoff 1649 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386535329792) level 0
        tree block backref root 7
    item 46 key (35453976535040 EXTENT_ITEM 4096) itemoff 1598 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386539364352) level 0
        tree block backref root 7
    item 47 key (35453976539136 EXTENT_ITEM 4096) itemoff 1547 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386543398912) level 0
        tree block backref root 7
    item 48 key (35453976543232 EXTENT_ITEM 4096) itemoff 1496 itemsize 51
        extent refs 1 gen 960307 flags 2
        tree block key (EXTENT_CSUM EXTENT_CSUM 38386547433472) level 0
        tree block backref root 7
    item 49 key (35453976551424 EXTENT_ITEM 4096) itemoff 1445 itemsize 51
        extent refs 1 gen 967250 flags 2
        tree block key (640625 INODE_ITEM 0) level 0
        tree block backref root 264
extent buffer leak: start 35435896033280 len 4096

----

[root@andromeda mnt]# btrfsck --repair /dev/sda
enabling repair mode
ERROR: device scan failed '/dev/sdg' - Device or resource busy
Checking filesystem on /dev/sda
UUID: 7bdca818-fa22-4a90-8fb8-9a2e756f0002
checking extents
bad key ordering 23 24
bad block 35435896033280
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
bad key ordering 23 24
deleting pointer to block 35435896033280
owner ref check failed [35435896033280 4096]
repair deleting extent record: key 35435896033280 168 4096
ref mismatch on [35453976346624 4096] extent item 0, found 1
btrfsck: extent-tree.c:2717: alloc_reserved_tree_block: Assertion
`!(ret)' failed.
Aborted

---

[root@andromeda ~]# btrfs fi show /mnt/bt_store
Label: bt_store  uuid: 7bdca818-fa22-4a90-8fb8-9a2e756f0002
    Total devices 5 FS bytes used 8.92TiB
    devid    1 size 2.73TiB used 1.55TiB path /dev/sdg1
    devid    2 size 3.64TiB used 2.00TiB path /dev/sda
    devid    3 size 2.73TiB used 2.07TiB path /dev/sdf
    devid    4 size 2.73TiB used 1.36TiB path /dev/sdd
    devid    5 size 3.64TiB used 2.08TiB path /dev/sdh
