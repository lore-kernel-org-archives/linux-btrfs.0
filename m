Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55691 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaJYSpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Oct 2014 14:45:06 -0400
Received: from marcec ([93.181.45.225]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MSdz2-1XaPAX0ema-00RVLP for
 <linux-btrfs@vger.kernel.org>; Sat, 25 Oct 2014 14:25:09 +0200
Date: Sat, 25 Oct 2014 14:24:58 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141025142458.5d96970b@marcec>
In-Reply-To: <20141020163403.GW22943@twin.jikos.cz>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nPd8Q0Q8OZXVqsD_IaW9Jvx"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/nPd8Q0Q8OZXVqsD_IaW9Jvx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Mon, 20 Oct 2014 18:34:03 +0200
schrieb David Sterba <dsterba@suse.cz>:

> On Thu, Oct 16, 2014 at 01:33:37PM +0200, David Sterba wrote:
> > I'd like to make it default with the 3.17 release of btrfs-progs.
> > Please let me know if you have objections.
>=20
> For the record, 3.17 will not change the defaults. The timing of the
> poll was very bad to get enough feedback before the release. Let's keep
> it open for now.

Two points:

First of all: does grub2 support booting from a btrfs file system with
skinny-metadata, or is it irrelevant?

And secondly, I've gotten a BUG after trying to convert my external backup
partition to skinny-metadata (the same one from the bug report mentioned
previously in this thread, I believe). Below is a more detailed account.

First of all, my setup (as of *now*, not before the BUG):

  # btrfs filesystem show
  Label: none  uuid: 0267d8b3-a074-460a-832d-5d5fd36bae64
  	Total devices 1 FS bytes used 41.42GiB
  	devid    1 size 107.79GiB used 53.06GiB path /dev/sdf1
 =20
  Label: 'MARCEC_STORAGE'  uuid: 472c9290-3ff2-4096-9c47-0612d3a52cef
  	Total devices 4 FS bytes used 514.54GiB
  	devid    1 size 298.09GiB used 259.03GiB path /dev/sda
  	devid    2 size 298.09GiB used 259.03GiB path /dev/sdb
  	devid    3 size 298.09GiB used 259.03GiB path /dev/sdc
  	devid    4 size 298.09GiB used 259.03GiB path /dev/sdd
 =20
  Label: 'MARCEC_BACKUP'  uuid: f97b3cda-15e8-418b-bb9b-235391ef2a38
  	Total devices 1 FS bytes used 169.31GiB
  	devid    1 size 976.56GiB used 175.06GiB path /dev/sdg2
 =20
  Btrfs v3.17

  # btrfs filesystem df /
  Data, single: total=3D48.00GiB, used=3D39.94GiB
  System, DUP: total=3D32.00MiB, used=3D12.00KiB
  Metadata, DUP: total=3D2.50GiB, used=3D1.48GiB
  GlobalReserve, single: total=3D508.00MiB, used=3D0.00B

  # btrfs filesystem df /home
  Data, RAID10: total=3D516.00GiB, used=3D513.38GiB
  System, RAID10: total=3D64.00MiB, used=3D96.00KiB
  Metadata, RAID10: total=3D2.00GiB, used=3D1.16GiB
  GlobalReserve, single: total=3D400.00MiB, used=3D0.00B

  # btrfs filesystem df /media/MARCEC_BACKUP
  Data, single: total=3D167.00GiB, used=3D166.53GiB
  System, DUP: total=3D32.00MiB, used=3D28.00KiB
  Metadata, DUP: total=3D4.00GiB, used=3D2.79GiB
  GlobalReserve, single: total=3D512.00MiB, used=3D1.33MiB

  # uname -a
  Linux marcec 3.16.6-gentoo #1 SMP PREEMPT Fri Oct 24 01:06:49 CEST 2014 x=
86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux

  # btrfs --version
  Btrfs v3.17

Now, what I was trying to do - motivated by this thread - was convert /home
and /media/MARCEC_BACKUP to skinny-metadata, using "btrfstune -x".  That in
itself worked fine, and the MARCEC_BACKUP has since seen filesystem activity
(running rsync, creating and deleting snapshots). *Then* I started a "btrfs
balance -m" on /home (which completed without errors) and then
on /media/MARCEC_BACKUP, which is when the BUG happened (dmesg output see
below).

The result in user-space was that "btrfs balance" SEGFAULTed.  "btrfs balan=
ce
status" showed the balance still running, so I tried to cancel it, which en=
ded
up hanging (the btrfs program has yet to return back to the shell).  For so=
me
reason I tried running "sync" (as root), which has also hung in the same wa=
y.

I can still access files on MARCEC_BACKUP just fine, and the snapshots are
still there ("btrfs subvolume list" succeeds).

Is there anything else I can do, or any other information you might need?

------------ dmesg output (starting with the start of the balance) --------=
----

  [ 4651.448883] BTRFS info (device sdb): relocating block group 1492765376=
512 flags 66
  [ 4652.259501] BTRFS info (device sdb): found 2 extents
  [ 4652.987753] BTRFS info (device sdb): relocating block group 1491691634=
688 flags 68
  [ 4688.655390] BTRFS info (device sdb): found 13744 extents
  [ 4689.382109] BTRFS info (device sdb): relocating block group 1485249183=
744 flags 68
  [ 4753.879520] BTRFS info (device sdb): found 62519 extents
  [ 4791.123268] BTRFS info (device sdg2): relocating block group 249967096=
6272 flags 36
  [ 4830.811665] BTRFS info (device sdg2): found 1793 extents
  [ 4831.240909] BTRFS info (device sdg2): relocating block group 249913409=
5360 flags 36
  [ 5407.582370] BTRFS info (device sdg2): found 51182 extents
  [ 5407.959115] BTRFS info (device sdg2): relocating block group 249859722=
4448 flags 36
  [ 5724.487824] BTRFS info (device sdg2): found 51435 extents
  [ 5725.006401] BTRFS info (device sdg2): relocating block group 247386760=
8064 flags 34
  [ 5725.817513] BTRFS info (device sdg2): found 7 extents
  [ 5726.328413] BTRFS info (device sdg2): relocating block group 246900221=
5424 flags 36
  [ 5844.148295] ------------[ cut here ]------------
  [ 5844.148307] WARNING: CPU: 1 PID: 7270 at fs/btrfs/extent-tree.c:876 bt=
rfs_lookup_extent_info+0x48c/0x4c0()
  [ 5844.148308] Modules linked in: uas usb_storage joydev hid_logitech_dj =
bridge stp llc ipt_REJECT xt_tcpudp iptable_filter iptable_nat nf_conntrack=
_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable=
_raw ip_tables x_tables snd_hda_codec_analog snd_hda_codec_generic dummy sg=
 snd_hda_codec_hdmi sr_mod cdrom kvm_amd kvm radeon evdev i2c_algo_bit drm_=
kms_helper k8temp ttm drm backlight snd_ice1724 snd_ak4113 snd_pt2258 snd_i=
2c snd_ak4114 snd_ac97_codec snd_hda_intel ac97_bus snd_ice17xx_ak4xxx snd_=
hda_controller snd_ak4xxx_adda forcedeth snd_rawmidi xhci_hcd snd_hda_codec=
 snd_seq_device snd_pcm snd_timer r8169 snd mii rtc_cmos ohci_pci asus_atk0=
110 i2c_nforce2 i2c_core ata_generic ehci_pci ohci_hcd ehci_hcd pata_amd pa=
ta_acpi
  [ 5844.148357] CPU: 1 PID: 7270 Comm: btrfs Not tainted 3.16.6-gentoo #1
  [ 5844.148359] Hardware name: System manufacturer System Product Name/M2N=
-E, BIOS ASUS M2N-E ACPI BIOS Revision 1701 10/30/2008
  [ 5844.148361]  0000000000000000 0000000000000009 ffffffff815675bc 000000=
0000000000
  [ 5844.148364]  ffffffff810460a6 ffff880052559ea0 ffff8800048a5800 000002=
46752f5000
  [ 5844.148366]  ffff880109252000 0000000000000001 ffffffff81237e3c 000000=
0000001000
  [ 5844.148369] Call Trace:
  [ 5844.148375]  [<ffffffff815675bc>] ? dump_stack+0x49/0x6a
  [ 5844.148378]  [<ffffffff810460a6>] ? warn_slowpath_common+0x86/0xb0
  [ 5844.148382]  [<ffffffff81237e3c>] ? btrfs_lookup_extent_info+0x48c/0x4=
c0
  [ 5844.148385]  [<ffffffff8123afde>] ? do_walk_down+0x13e/0x560
  [ 5844.148388]  [<ffffffff812387ea>] ? walk_down_proc+0x1da/0x2c0
  [ 5844.148391]  [<ffffffff8123b4b3>] ? walk_down_tree+0xb3/0xe0
  [ 5844.148394]  [<ffffffff8123f235>] ? btrfs_drop_subtree+0x195/0x210
  [ 5844.148397]  [<ffffffff8129fa2f>] ? do_relocation+0x36f/0x500
  [ 5844.148401]  [<ffffffff8129d985>] ? calcu_metadata_size.isra.43.constp=
rop.57+0x95/0xb0
  [ 5844.148405]  [<ffffffff8127284f>] ? read_extent_buffer+0xaf/0x110
  [ 5844.148407]  [<ffffffff8129f50d>] ? remove_backref_node+0xad/0x140
  [ 5844.148410]  [<ffffffff812a007d>] ? relocate_tree_blocks+0x4bd/0x610
  [ 5844.148413]  [<ffffffff812a159b>] ? relocate_block_group+0x3cb/0x660
  [ 5844.148416]  [<ffffffff812a19e8>] ? btrfs_relocate_block_group+0x1b8/0=
x2e0
  [ 5844.148418]  [<ffffffff81276a46>] ? btrfs_relocate_chunk.isra.62+0x56/=
0x740
  [ 5844.148422]  [<ffffffff81288e50>] ? btrfs_set_lock_blocking_rw+0x60/0x=
a0
  [ 5844.148425]  [<ffffffff8127284f>] ? read_extent_buffer+0xaf/0x110
  [ 5844.148428]  [<ffffffff81230d65>] ? btrfs_previous_item+0x95/0x120
  [ 5844.148431]  [<ffffffff81268961>] ? btrfs_get_token_64+0x61/0xf0
  [ 5844.148433]  [<ffffffff8127182f>] ? release_extent_buffer+0x2f/0xd0
  [ 5844.148436]  [<ffffffff81279b68>] ? btrfs_balance+0x858/0xf20
  [ 5844.148440]  [<ffffffff81148585>] ? __sb_start_write+0x65/0x110
  [ 5844.148443]  [<ffffffff8128093e>] ? btrfs_ioctl_balance+0x19e/0x500
  [ 5844.148446]  [<ffffffff8128688f>] ? btrfs_ioctl+0xa8f/0x2940
  [ 5844.148450]  [<ffffffff8111d1e3>] ? handle_mm_fault+0x873/0xba0
  [ 5844.148453]  [<ffffffff8103889a>] ? __do_page_fault+0x2ba/0x570
  [ 5844.148457]  [<ffffffff81120359>] ? vma_link+0xd9/0xe0
  [ 5844.148460]  [<ffffffff8113bb9a>] ? kmem_cache_alloc+0x16a/0x170
  [ 5844.148463]  [<ffffffff81157c9e>] ? do_vfs_ioctl+0x7e/0x500
  [ 5844.148466]  [<ffffffff811581b9>] ? SyS_ioctl+0x99/0xb0
  [ 5844.148469]  [<ffffffff8156df82>] ? page_fault+0x22/0x30
  [ 5844.148473]  [<ffffffff8156c612>] ? system_call_fastpath+0x16/0x1b
  [ 5844.148475] ---[ end trace bf07dd9e2f7fb342 ]---
  [ 5844.148478] BTRFS error (device sdg2): Missing references.
  [ 5844.148496] ------------[ cut here ]------------
  [ 5844.148532] kernel BUG at fs/btrfs/extent-tree.c:7624!
  [ 5844.148565] invalid opcode: 0000 [#1] PREEMPT SMP=20
  [ 5844.148600] Modules linked in: uas usb_storage joydev hid_logitech_dj =
bridge stp llc ipt_REJECT xt_tcpudp iptable_filter iptable_nat nf_conntrack=
_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable=
_raw ip_tables x_tables snd_hda_codec_analog snd_hda_codec_generic dummy sg=
 snd_hda_codec_hdmi sr_mod cdrom kvm_amd kvm radeon evdev i2c_algo_bit drm_=
kms_helper k8temp ttm drm backlight snd_ice1724 snd_ak4113 snd_pt2258 snd_i=
2c snd_ak4114 snd_ac97_codec snd_hda_intel ac97_bus snd_ice17xx_ak4xxx snd_=
hda_controller snd_ak4xxx_adda forcedeth snd_rawmidi xhci_hcd snd_hda_codec=
 snd_seq_device snd_pcm snd_timer r8169 snd mii rtc_cmos ohci_pci asus_atk0=
110 i2c_nforce2 i2c_core ata_generic ehci_pci ohci_hcd ehci_hcd pata_amd pa=
ta_acpi
  [ 5844.149007] CPU: 1 PID: 7270 Comm: btrfs Tainted: G        W     3.16.=
6-gentoo #1
  [ 5844.149007] Hardware name: System manufacturer System Product Name/M2N=
-E, BIOS ASUS M2N-E ACPI BIOS Revision 1701 10/30/2008
  [ 5844.149007] task: ffff88003324f000 ti: ffff8800156d0000 task.ti: ffff8=
800156d0000
  [ 5844.149007] RIP: 0010:[<ffffffff8123b3ec>]  [<ffffffff8123b3ec>] do_wa=
lk_down+0x54c/0x560
  [ 5844.149007] RSP: 0018:ffff8800156d3778  EFLAGS: 00010292
  [ 5844.149007] RAX: 000000000000002e RBX: ffff88010c4ba0c0 RCX: 000000000=
0000006
  [ 5844.149007] RDX: 0000000000000007 RSI: 0000000000000046 RDI: ffff88011=
fc8d140
  [ 5844.149007] RBP: ffff880052559bd0 R08: 0000000000000400 R09: 000000000=
00003a5
  [ 5844.149007] R10: 0000000000000006 R11: 00000000000003a4 R12: ffff88003=
7378a68
  [ 5844.149007] R13: 0000000000000002 R14: ffff8800048a5800 R15: 000000000=
0000002
  [ 5844.149007] FS:  00007f6eda85c8c0(0000) GS:ffff88011fc80000(0000) knlG=
S:0000000000000000
  [ 5844.149007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  [ 5844.149007] CR2: 000000000262ddf0 CR3: 0000000018ce4000 CR4: 000000000=
00007e0
  [ 5844.149007] Stack:
  [ 5844.149007]  ffff88010c4ba108 0000000000000000 02a9000000000000 ff0000=
0000000000
  [ 5844.149007]  0000000000000001 0000000000000009 00000001178e5528 000002=
46752f5000
  [ 5844.149007]  ffff8800156d3854 000000000000b38a ffff880109252000 000000=
0000001000
  [ 5844.149007] Call Trace:
  [ 5844.149007]  [<ffffffff812387ea>] ? walk_down_proc+0x1da/0x2c0
  [ 5844.149007]  [<ffffffff8123b4b3>] ? walk_down_tree+0xb3/0xe0
  [ 5844.149007]  [<ffffffff8123f235>] ? btrfs_drop_subtree+0x195/0x210
  [ 5844.149007]  [<ffffffff8129fa2f>] ? do_relocation+0x36f/0x500
  [ 5844.149007]  [<ffffffff8129d985>] ? calcu_metadata_size.isra.43.constp=
rop.57+0x95/0xb0
  [ 5844.149007]  [<ffffffff8127284f>] ? read_extent_buffer+0xaf/0x110
  [ 5844.149007]  [<ffffffff8129f50d>] ? remove_backref_node+0xad/0x140
  [ 5844.149007]  [<ffffffff812a007d>] ? relocate_tree_blocks+0x4bd/0x610
  [ 5844.149007]  [<ffffffff812a159b>] ? relocate_block_group+0x3cb/0x660
  [ 5844.149007]  [<ffffffff812a19e8>] ? btrfs_relocate_block_group+0x1b8/0=
x2e0
  [ 5844.149007]  [<ffffffff81276a46>] ? btrfs_relocate_chunk.isra.62+0x56/=
0x740
  [ 5844.149007]  [<ffffffff81288e50>] ? btrfs_set_lock_blocking_rw+0x60/0x=
a0
  [ 5844.149007]  [<ffffffff8127284f>] ? read_extent_buffer+0xaf/0x110
  [ 5844.149007]  [<ffffffff81230d65>] ? btrfs_previous_item+0x95/0x120
  [ 5844.149007]  [<ffffffff81268961>] ? btrfs_get_token_64+0x61/0xf0
  [ 5844.149007]  [<ffffffff8127182f>] ? release_extent_buffer+0x2f/0xd0
  [ 5844.149007]  [<ffffffff81279b68>] ? btrfs_balance+0x858/0xf20
  [ 5844.149007]  [<ffffffff81148585>] ? __sb_start_write+0x65/0x110
  [ 5844.149007]  [<ffffffff8128093e>] ? btrfs_ioctl_balance+0x19e/0x500
  [ 5844.149007]  [<ffffffff8128688f>] ? btrfs_ioctl+0xa8f/0x2940
  [ 5844.149007]  [<ffffffff8111d1e3>] ? handle_mm_fault+0x873/0xba0
  [ 5844.149007]  [<ffffffff8103889a>] ? __do_page_fault+0x2ba/0x570
  [ 5844.149007]  [<ffffffff81120359>] ? vma_link+0xd9/0xe0
  [ 5844.149007]  [<ffffffff8113bb9a>] ? kmem_cache_alloc+0x16a/0x170
  [ 5844.149007]  [<ffffffff81157c9e>] ? do_vfs_ioctl+0x7e/0x500
  [ 5844.149007]  [<ffffffff811581b9>] ? SyS_ioctl+0x99/0xb0
  [ 5844.149007]  [<ffffffff8156df82>] ? page_fault+0x22/0x30
  [ 5844.149007]  [<ffffffff8156c612>] ? system_call_fastpath+0x16/0x1b
  [ 5844.149007] Code: c8 0f 85 62 fe ff ff e9 75 fd ff ff b8 f4 ff ff ff e=
9 c1 fc ff ff 49 8b be f0 01 00 00 48 c7 c6 1b 90 74 81 31 c0 e8 84 7f fe f=
f <0f> 0b 0f 0b 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 41=20
  [ 5844.151353] RIP  [<ffffffff8123b3ec>] do_walk_down+0x54c/0x560
  [ 5844.151353]  RSP <ffff8800156d3778>
  [ 5844.172535] ---[ end trace bf07dd9e2f7fb343 ]---

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/nPd8Q0Q8OZXVqsD_IaW9Jvx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUS5aiAAoJEL/Q5oYsiHj0T6YP/iHYQdHhx/pnSJmgLJDgzbFk
suSC3skNNHcDLG8ws68ul2aM0HVAxM0aXq0P52J9mkW7L3NMSil8pDe7wCjPo4Lh
8NWpvPheuAAhhQpHgz1JdfTDPWFcJNPleh9UG6wHmVyx1hhRC8MoI6i6rU4/rOjq
/4lEoGZDtasdnqcyN8brtI62QC5hB8Rak+3ZjfNlBLpkiYJIpgJWEHMQoPCoNXu/
JYwOp2Nv1KB17MSPBiY8qtLfXNuC9G2T2QWaxBmWeV1Tn/508N2K9pL2yPgqmmN0
CQhXAyp2lvac7XI8o/oh2G3xIIsUrZcxDWP7FEZLrGhWLjImI+aB1USBodILA/7B
KKoGti801OS8IQV4l0570UQGMUfK6sgYjMzxYjc9O2CajFfXpEN7u96rLzMRW5r0
QJNbvUfdl+g76+/EqJFnFg2zfDXEOsS9k4X2IDmFwpfYnEZGP8xZaEUBAQg+gnxf
x+C4jpdce982B+I072bG6tYmpBUe7+lIO1l1ZYHajSL8LiAA+Nk7i9iFPi0p7UrN
U376cpqpr9HuPvW5JsyQteRGvqnzplasn7H7RbIgqcHmgiXXRe2dy3s7WNLxPLzV
cvQRDMLxCC2XSaI3nVIf/F0Ie3WFArvAvvRf2ceQchpCdAgAZExyEICNl3IHTb6Q
gTupmv/ngvnYrPgl1Ft4
=d/Ke
-----END PGP SIGNATURE-----

--Sig_/nPd8Q0Q8OZXVqsD_IaW9Jvx--
