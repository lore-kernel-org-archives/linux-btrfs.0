From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Fri, 09 Sep 2011 02:13:38 +0100
Message-ID: <1315530824.1957.4.camel@picard>
References: <1314582311.2724.4.camel@picard>
	 <4E5C82E8.9090400@cn.fujitsu.com>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-QGBGyjH3d+n+g3fbaYak"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5C82E8.9090400@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-QGBGyjH3d+n+g3fbaYak
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-08-30 at 14:27 +0800, Miao Xie wrote:
> On mon, 29 Aug 2011 02:45:07 +0100, Maciej Marcin Piechotka wrote:
> > I receive the bug when I try to snapshot from fcron:
> >=20
> > 2011-08-29T02:00:46.529238+01:00 picard kernel: [ 4155.444476]
> > ------------[ cut here ]------------
> > 2011-08-29T02:00:46.529253+01:00 picard kernel: [ 4155.444490] kernel
> > BUG at fs/btrfs/inode.c:2299!
> > 2011-08-29T02:00:46.529256+01:00 picard kernel: [ 4155.444498] invalid
> > opcode: 0000 [#1] PREEMPT SMP=20
> > 2011-08-29T02:00:46.529259+01:00 picard kernel: [ 4155.444506] CPU 1=
=20
> > 2011-08-29T02:00:46.529264+01:00 picard kernel: [ 4155.444508] Modules
> > linked in: microcode reiserfs btrfs zlib_deflate libcrc32c arc4
> > snd_hda_codec_conexant iwlagn mac80211 uvcvideo videodev
> > v4l2_compat_ioctl32 cfg80211 snd_hda_intel snd_hda_codec snd_hwdep
> > snd_pcm snd_timer snd thinkpad_acpi soundcore snd_page_alloc hwmon
> > rfkill nvram e1000e zram(C) rtc_cmos tp_smapi thinkpad_ec psmouse
> > fscache kvm_intel kvm configs ipv6 autofs4 usbhid uhci_hcd firewire_ohc=
i
> > firewire_core sdhci_pci ehci_hcd crc_itu_t sdhci mmc_core sd_mod usbcor=
e
> > sr_mod cdrom
> > 2011-08-29T02:00:46.529267+01:00 picard kernel: [ 4155.444569]=20
> > 2011-08-29T02:00:46.529270+01:00 picard kernel: [ 4155.444576] Pid:
> > 3167, comm: btrfs Tainted: P         C  3.0.3-gentoo #1 LENOVO
> > 2242CTO/2242CTO
> > 2011-08-29T02:00:46.529274+01:00 picard kernel: [ 4155.444586] RIP:
> > 0010:[<ffffffffa031339b>]  [<ffffffffa031339b>] btrfs_orphan_del
> > +0x8d/0xa9 [btrfs]
> > 2011-08-29T02:00:46.529276+01:00 picard kernel: [ 4155.444611] RSP:
> > 0000:ffff880111c21b58  EFLAGS: 00010282
> > 2011-08-29T02:00:46.529279+01:00 picard kernel: [ 4155.444619] RAX:
> > 00000000fffffffe RBX: ffff88011141bd60 RCX: 0000000000001000
> > 2011-08-29T02:00:46.529289+01:00 picard kernel: [ 4155.444626] RDX:
> > 000000000000000f RSI: ffff880110c8d250 RDI: ffff880134092d80
> > 2011-08-29T02:00:46.529292+01:00 picard kernel: [ 4155.444634] RBP:
> > 0000000000000000 R08: ffff880111c21a30 R09: 0000000000000011
> > 2011-08-29T02:00:46.529297+01:00 picard kernel: [ 4155.444642] R10:
> > 00000000000001dc R11: 0000000000000286 R12: ffff880136866300
> > 2011-08-29T02:00:46.529299+01:00 picard kernel: [ 4155.444650] R13:
> > ffff880130cac800 R14: 0000000000000001 R15: ffff880130cacb88
> > 2011-08-29T02:00:46.529302+01:00 picard kernel: [ 4155.444658] FS:
> > 00007f126715a740(0000) GS:ffff88013bc80000(0000) knlGS:0000000000000000
> > 2011-08-29T02:00:46.529304+01:00 picard kernel: [ 4155.444666] CS:  001=
0
> > DS: 0000 ES: 0000 CR0: 000000008005003b
> > 2011-08-29T02:00:46.529307+01:00 picard kernel: [ 4155.444673] CR2:
> > 00007f5149eb7008 CR3: 000000009caca000 CR4: 00000000000406e0
> > 2011-08-29T02:00:46.529309+01:00 picard kernel: [ 4155.444681] DR0:
> > 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > 2011-08-29T02:00:46.529311+01:00 picard kernel: [ 4155.444689] DR3:
> > 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > 2011-08-29T02:00:46.529314+01:00 picard kernel: [ 4155.444697] Process
> > btrfs (pid: 3167, threadinfo ffff880111c20000, task ffff88010b35a140)
> > 2011-08-29T02:00:46.529316+01:00 picard kernel: [ 4155.444705] Stack:
> > 2011-08-29T02:00:46.529318+01:00 picard kernel: [ 4155.444711]
> > 0000000000c369c5 ffff880130cac800 ffff880110c8dbe0 0000000000c369c5
> > 2011-08-29T02:00:46.529321+01:00 picard kernel: [ 4155.444720]
> > 0000000000000000 ffff880130cacb88 ffff880130cacb90 ffffffffa03173c4
> > 2011-08-29T02:00:46.562822+01:00 picard kernel: [ 4155.444730]
> > ffff880136866300 ffff88011141bd60 ffff880110c8dbe0 fffb000000000000
> > 2011-08-29T02:00:46.562959+01:00 picard kernel: [ 4155.444739] Call
> > Trace:
> > 2011-08-29T02:00:46.562964+01:00 picard kernel: [ 4155.444756]
> > [<ffffffffa03173c4>] ? btrfs_orphan_cleanup+0x196/0x2d9 [btrfs]
> > 2011-08-29T02:00:46.562966+01:00 picard kernel: [ 4155.444773]
> > [<ffffffffa0317862>] ? btrfs_lookup_dentry+0x35b/0x392 [btrfs]
> > 2011-08-29T02:00:46.562969+01:00 picard kernel: [ 4155.444790]
> > [<ffffffffa03178a2>] ? btrfs_lookup+0x9/0x1f [btrfs]
> > 2011-08-29T02:00:46.562971+01:00 picard kernel: [ 4155.444801]
> > [<ffffffff810ccf63>] ? d_alloc_and_lookup+0x3a/0x60
> > 2011-08-29T02:00:46.562973+01:00 picard kernel: [ 4155.444810]
> > [<ffffffff810ce356>] ? walk_component+0x210/0x3b7
> > 2011-08-29T02:00:46.562975+01:00 picard kernel: [ 4155.444818]
> > [<ffffffff810cea4a>] ? path_lookupat+0x7c/0x29e
> > 2011-08-29T02:00:46.562979+01:00 picard kernel: [ 4155.444827]
> > [<ffffffff810cfc34>] ? do_path_lookup+0x1c/0x87
> > 2011-08-29T02:00:46.562981+01:00 picard kernel: [ 4155.444835]
> > [<ffffffff810cffe2>] ? user_path_at+0x49/0x7b
> > 2011-08-29T02:00:46.562983+01:00 picard kernel: [ 4155.444843]
> > [<ffffffff810c8781>] ? vfs_fstatat+0x3c/0x6a
> > 2011-08-29T02:00:46.562986+01:00 picard kernel: [ 4155.444853]
> > [<ffffffff8102d38e>] ? sub_preempt_count+0x83/0x94
> > 2011-08-29T02:00:46.562988+01:00 picard kernel: [ 4155.444861]
> > [<ffffffff810c88ab>] ? sys_newstat+0x12/0x2b
> > 2011-08-29T02:00:46.562990+01:00 picard kernel: [ 4155.444870]
> > [<ffffffff81346d4f>] ? page_fault+0x1f/0x30
> > 2011-08-29T02:00:46.562992+01:00 picard kernel: [ 4155.444878]
> > [<ffffffff8134713b>] ? system_call_fastpath+0x16/0x1b
> > 2011-08-29T02:00:46.562995+01:00 picard kernel: [ 4155.444885] Code: 4d
> > 85 e4 74 28 48 8b 93 70 fe ff ff 48 81 fa 00 01 00 00 77 07 48 8b 93 b0
> > 00 00 00 4c 89 ee 4c 89 e7 e8 af 28 02 00 85 c0 74 02 <0f> 0b 85 ed 74
> > 08 48 89 df e8 e0 ca fe ff 5d 31 c0 5b 5d 41 5c=20
> > 2011-08-29T02:00:46.563001+01:00 picard kernel: [ 4155.444926] RIP
> > [<ffffffffa031339b>] btrfs_orphan_del+0x8d/0xa9 [btrfs]
> > 2011-08-29T02:00:46.563004+01:00 picard kernel: [ 4155.444943]  RSP
> > <ffff880111c21b58>
> > 2011-08-29T02:00:46.563014+01:00 picard kernel: [ 4155.464057] ---[ end
> > trace 276655044a13c7af ]---
> >=20
> > Unfortunately it results in freeze of system and I cannot give more
> > details. Sometimes it happens not from fcron but then it does not resul=
t
> > in freeze (???).
>=20
> Could you give me the method to reproduce it?
>=20
> Thanks
> Miao


I still have no idea how to reproduce it but:
a) It happens on both clean 3.1 kernels as on 3.0 with various patches
b) The snapshotting is not a cause (it was coincident)
c) It usually happens a few minutes past 3 UTC. I have no idea what is
casuing this but it is consistent.
d) Compression is not a cause

Best regards

--=-QGBGyjH3d+n+g3fbaYak
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOaWhIAAoJEJIdee2Vr4aPAxAP/iZNXa0F9wsGmLmr4KwhlMCY
49jIlc7QNsEzx/LPn+mFDkGUTFVcjSIMd2Yz2+k1fYM07duQH3II1iVn+Bpef92+
ZwTVcLLKMeu4hawOBpXYDFce5aFk42/LAnaFJOZ/1mg9YGdSnwdOE01rmNTqb2iq
QKOZCQb+I/AfDHD7PSHI7fz5O6+IhdNChagbDOCGLJfD+mmFzlnSl64JAGxd/UbM
JX4KTXJ8zCld/s2bayVwdPDUfQ/QROTeIJM2mNVrjNTnt1UIQQX/LdO4fYq4Dbgw
4KXdQUmAzxl0/3N6qw8ISR2KDDdFCZgmE+XBCvJkg28nqV/+tp+y3pPL/aYMcM5b
gssMy9UEuFGJwtCnV21olChOJXm5mbzc1YEAOACOQTmVnfK1AMTyD6k7yGtf7n+x
+lgDBNrfnaP/n6HwPedfEG1GtUWciS6/xdt18xUa5G8+cpRjQZuINGob6UIhOjn7
PvUmmDPm7X3Yg6//GNbLaU2vJDbeHOP6VxoBBYDk9PBTSbMp39MKgqjD4SBa9n68
0xjRLUGS+u7S2SJj4dzVCcNgvip6LdWPp6LfjVbkpzY2no8walXohOgst2O/js2n
Go9ak3v3WLNEzsljZQjljajkK26v3/Xc2bHygCpnS4HNMyzlRFxQ5JNV6ZjzLssQ
JrxAnrRC65sZLoUriVDQ
=XsKD
-----END PGP SIGNATURE-----

--=-QGBGyjH3d+n+g3fbaYak--


