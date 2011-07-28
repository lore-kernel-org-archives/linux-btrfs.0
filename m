From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs hung tasks
Date: Thu, 28 Jul 2011 23:31:48 +1000
Message-ID: <201107282331.52020.chris@csamuel.org>
References: <20110728062343.GA4656@yahoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12994411.at5y9xcjEJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110728062343.GA4656@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart12994411.at5y9xcjEJ
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jul 2011 04:23:43 PM Stephane Chazelas wrote:

> Hiya, I got below those last night. That was 3 minutes after a
> bunch of rsync and ntfsclone processes started.

Similar here with an rsync to an external USB drive (SATA) from
a local ext4 partition.  This is with the Ubuntu mainline PPA
(AMD64) build of 3.0.

http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.0-oneiric/linux-image-3.0.=
0-0300-
generic_3.0.0-0300.201107220917_amd64.deb

[175681.180099] INFO: task flush-btrfs-1:26899 blocked for more than 120 se=
conds.
[175681.180104] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[175681.180106] flush-btrfs-1   D ffff88021e64df80     0 26899      2 0x000=
00000
[175681.180111]  ffff880152e597d0 0000000000000046 ffff880152e596d0 ffff880=
152e59fd8
[175681.180115]  ffff880152e597d0 0000000000012a40 0000000000012a40 ffff880=
152e59fd8
[175681.180119]  ffff880152e59fd8 0000000000012a40 ffff88021e64dbc0 ffff880=
222d28000
[175681.180124] Call Trace:
[175681.180132]  [<ffffffff812e90de>] ? radix_tree_gang_lookup_slot+0x7e/0x=
c0
[175681.180160]  [<ffffffffa0263394>] ? clear_extent_bit+0x194/0x380 [btrfs]
[175681.180166]  [<ffffffff8110e129>] ? find_get_pages_contig+0x39/0xe0
[175681.180171]  [<ffffffff81034f69>] ? default_spin_lock_flags+0x9/0x10
[175681.180175]  [<ffffffff815dfd84>] ? _raw_spin_lock_irqsave+0x34/0x50
[175681.180179]  [<ffffffff81084efc>] ? prepare_to_wait+0x7c/0x90
[175681.180192]  [<ffffffffa02430c9>] wait_current_trans+0x99/0x100 [btrfs]
[175681.180195]  [<ffffffff81084c40>] ? wake_up_bit+0x40/0x40
[175681.180198]  [<ffffffff815dfd3e>] ? _raw_spin_lock+0xe/0x20
[175681.180210]  [<ffffffffa0244ef8>] start_transaction+0x138/0x270 [btrfs]
[175681.180223]  [<ffffffffa0245085>] btrfs_join_transaction+0x15/0x20 [btr=
fs]
[175681.180236]  [<ffffffffa024a952>] cow_file_range+0x82/0x390 [btrfs]
[175681.180239]  [<ffffffff815dfd3e>] ? _raw_spin_lock+0xe/0x20
[175681.180252]  [<ffffffffa0264228>] ? test_range_bit+0x88/0x140 [btrfs]
[175681.180266]  [<ffffffffa024c6af>] run_delalloc_range+0x4f/0x80 [btrfs]
[175681.180279]  [<ffffffffa0266ac1>] __extent_writepage+0x4b1/0x650 [btrfs]
[175681.180283]  [<ffffffff812e9a40>] ? radix_tree_gang_lookup_tag_slot+0x9=
0/0xd0
[175681.180287]  [<ffffffff8110d125>] ? find_get_pages_tag+0x45/0x100
[175681.180300]  [<ffffffffa0266138>] extent_write_cache_pages+0x208/0x2d0 =
[btrfs]
[175681.180314]  [<ffffffffa0262720>] ? flush_epd_write_bio+0x50/0x50 [btrf=
s]
[175681.180327]  [<ffffffffa0266610>] ? find_lock_delalloc_range+0x1d0/0x1d=
0 [btrfs]
[175681.180342]  [<ffffffffa0266254>] extent_writepages+0x54/0x70 [btrfs]
[175681.180355]  [<ffffffffa0250520>] ? btrfs_page_mkwrite+0x2d0/0x2d0 [btr=
fs]
[175681.180369]  [<ffffffffa0246f18>] btrfs_writepages+0x28/0x30 [btrfs]
[175681.180372]  [<ffffffff81117c51>] do_writepages+0x21/0x40
[175681.180376]  [<ffffffff81191514>] writeback_single_inode+0xf4/0x210
[175681.180380]  [<ffffffff8105844e>] ? put_prev_entity+0x2e/0x70
[175681.180383]  [<ffffffff811918e0>] writeback_sb_inodes+0xe0/0x190
[175681.180386]  [<ffffffff81191aff>] writeback_inodes_wb+0xcf/0xf0
[175681.180389]  [<ffffffff81191d63>] wb_writeback+0x243/0x370
[175681.180393]  [<ffffffff8107184b>] ? lock_timer_base+0x3b/0x70
[175681.180396]  [<ffffffff81191f19>] wb_check_old_data_flush+0x89/0xa0
[175681.180398]  [<ffffffff8119204b>] wb_do_writeback+0x8b/0xe0
[175681.180401]  [<ffffffff811920a0>] ? wb_do_writeback+0xe0/0xe0
[175681.180404]  [<ffffffff81192153>] bdi_writeback_thread+0xb3/0x260
[175681.180406]  [<ffffffff811920a0>] ? wb_do_writeback+0xe0/0xe0
[175681.180409]  [<ffffffff81084577>] kthread+0x97/0xa0
[175681.180413]  [<ffffffff815e94a4>] kernel_thread_helper+0x4/0x10
[175681.180416]  [<ffffffff810844e0>] ? kthread_bind+0x80/0x80
[175681.180419]  [<ffffffff815e94a0>] ? gs_change+0x13/0x13


=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart12994411.at5y9xcjEJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATjFkxI1yjaOTJg85AQKD5AgAskavYJDiqrF1bV5t3IE4vWqcTiuoDmki
f8BuEyuLJUsaiCHnEWx62Z9QY9rrOzp714pj4qj6QL8UoWrDM1VXAsGNBMhpbWff
K4Vx+36kvsRqreKKbym5b+xcJsNmwaUL6IAWK3Glumc/Qq3Y2h33khYrlPolAm0I
9SUu39TSobhVRGMHVwRageTR0/Q/xsMLgoppvPtelMF0icAJPPE253BWfSZs1UUB
jQUU0vaps8D9cqZWYIMLByflg+mDEPyNK+5LF6Hf675Cq3XuuC8VTY0uaNkkAdjI
d3sv//H4Tmajj7tIGrtSVkZXe3qiLPnayykfuDLwcBqCSynKor16mA==
=ybz0
-----END PGP SIGNATURE-----

--nextPart12994411.at5y9xcjEJ--
