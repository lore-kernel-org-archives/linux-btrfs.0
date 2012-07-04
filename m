Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:36278 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab2GDQDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 12:03:52 -0400
Date: Wed, 4 Jul 2012 19:03:40 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120704160340.GA9770@sli.dy.fi>
References: <20120702230121.GD12755@sli.dy.fi>
 <4FF2EF68.6090401@jan-o-sch.net>
 <20120703135824.GA8908@sli.dy.fi>
 <4FF3032D.1010007@jan-o-sch.net>
 <20120703224756.GA21647@sli.dy.fi>
 <20120704001713.GA8986@sli.dy.fi>
 <4FF42876.8010309@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
In-Reply-To: <4FF42876.8010309@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 04, 2012 at 01:26:46PM +0200, Jan Schmidt wrote:
> On 04.07.2012 02:17, Sami Liedes wrote:
> > On Wed, Jul 04, 2012 at 01:47:56AM +0300, Sami Liedes wrote:
> >> I've seen this before: An overly long "Modules linked in:" line causes
> >> a large gap in netconsole output.
> >=20
> > I managed to capture the entire output using netconsole by modifying
> > the kernel to not output the list of modules.
>=20
> Okay, thanks for the output. Can you please apply the patch below and cap=
ture
> especially the line printed before the "cut here" line?

Here you go.

	Sami

------------------------------------------------------------
[  121.524803] netpoll: netconsole: local port 4444
[  121.524831] netpoll: netconsole: local IP 192.168.1.2
[  121.524853] netpoll: netconsole: interface 'eth0'
[  121.524874] netpoll: netconsole: remote port 1194
[  121.524894] netpoll: netconsole: remote IP 192.168.1.73
[  121.524917] netpoll: netconsole: remote ethernet address 00:1c:10:44:47:=
2c
[  121.525055] console [netcon0] enabled
[  121.525074] netconsole: network logging started
[  200.980496] btrfs: invalid parameters for read_extent_buffer: start (327=
71) > eb->len (32768). eb start is 2243489562624, level 26, generation 3144=
240307695375391, nritems 620178657. len param 17. debug 2/989/620178657/314=
4240307695375391
[  200.980594] ------------[ cut here ]------------
[  200.980644] WARNING: at fs/btrfs/extent_io.c:4528 read_extent_buffer+0x1=
67/0x1a0 [btrfs]()
[  200.980681] Hardware name: System Product Name
[  200.980701] Modules linked in: <omitted>  [last unloaded: scsi_wait_scan]
[  200.980739] Pid: 1145, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #2
[  200.980774] Call Trace:
[  200.980792]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
[  200.980821]  [<ffffffff810390a5>] warn_slowpath_null+0x15/0x20
[  200.980860]  [<ffffffffa01d6e07>] read_extent_buffer+0x167/0x1a0 [btrfs]
[  200.980902]  [<ffffffffa01ce03d>] btrfs_node_key+0x1d/0x20 [btrfs]
[  200.980941]  [<ffffffffa020459f>] __readahead_hook.isra.5+0x3ff/0x460 [b=
trfs]
[  200.980982]  [<ffffffffa020492f>] btree_readahead_hook+0x1f/0x40 [btrfs]
[  200.981022]  [<ffffffffa01aa841>] btree_readpage_end_io_hook+0x111/0x260=
 [btrfs]
[  200.981065]  [<ffffffffa01d2442>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  200.981109]  [<ffffffffa01d308b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  200.981150]  [<ffffffffa01a9e61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  200.981182]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  200.981214]  [<ffffffffa01a9e6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  200.981253]  [<ffffffffa01e08d7>] worker_loop+0x157/0x560 [btrfs]
[  200.981291]  [<ffffffffa01e0780>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  200.981323]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  200.981348]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  200.981377]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  200.981406]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  200.981430] ---[ end trace e93713a9d40cd06e ]---
[  200.981459] general protection fault: 0000 [#1] SMP=20
[  200.981487] CPU 2=20
[  200.981498] Modules linked in: <omitted>  [last unloaded: scsi_wait_scan]
[  200.981540]=20
[  200.981550] Pid: 1145, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #2 System manufacturer System Product Name/P8P67 EVO
[  200.981612] RIP: 0010:[<ffffffff811e83ed>]  [<ffffffff811e83ed>] memcpy+=
0xd/0x110
[  200.981650] RSP: 0000:ffff8801f4bf7b68  EFLAGS: 00010202
[  200.981675] RAX: ffff8801f4bf7c8f RBX: 0000000000000011 RCX: 00000000000=
00002
[  200.981707] RDX: 0000000000000001 RSI: 0005080000000003 RDI: ffff8801f4b=
f7c8f
[  200.981738] RBP: ffff8801f4bf7be0 R08: 0000000000000000 R09: 00000000000=
00000
[  200.981769] R10: ffff8801f4bf7c8f R11: ffff8801f3930780 R12: ffff8801f4b=
f7ca0
[  200.981800] R13: ffff8801f7286178 R14: 0000000000000048 R15: 00000000000=
00011
[  200.981832] FS:  0000000000000000(0000) GS:ffff88021ec80000(0000) knlGS:=
0000000000000000
[  200.981868] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  200.981894] CR2: 00000000f773a000 CR3: 000000020d0de000 CR4: 00000000000=
407e0
[  200.981925] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  200.981956] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  200.981988] Process btrfs-endio-met (pid: 1145, threadinfo ffff8801f4bf6=
000, task ffff8801f4ff42f0)
[  200.982026] Stack:
[  200.982038]  ffffffffa01d6d5b ffff880124f72ce1 0000000000000011 00000000=
00000002
[  200.982084]  00000000000003dd 0000000024f72ce1 2ba295e6a4a5d41f ffff8802=
0dc65000
[  200.982130]  ffff8801f4bf7c8f 0000000000001000 ffff8801f4bf7c58 00000000=
000003dd
[  200.982175] Call Trace:
[  200.982201]  [<ffffffffa01d6d5b>] ? read_extent_buffer+0xbb/0x1a0 [btrfs]
[  200.982243]  [<ffffffffa01ce03d>] btrfs_node_key+0x1d/0x20 [btrfs]
[  200.982281]  [<ffffffffa020459f>] __readahead_hook.isra.5+0x3ff/0x460 [b=
trfs]
[  200.982322]  [<ffffffffa020492f>] btree_readahead_hook+0x1f/0x40 [btrfs]
[  200.982362]  [<ffffffffa01aa841>] btree_readpage_end_io_hook+0x111/0x260=
 [btrfs]
[  200.982405]  [<ffffffffa01d2442>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  200.982448]  [<ffffffffa01d308b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  200.982489]  [<ffffffffa01a9e61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  200.982519]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  200.982552]  [<ffffffffa01a9e6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  200.982591]  [<ffffffffa01e08d7>] worker_loop+0x157/0x560 [btrfs]
[  200.982628]  [<ffffffffa01e0780>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  200.982660]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  200.982684]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  200.982713]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  200.982742]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  200.982766] Code: 4e 48 83 c4 08 5b 5d c3 66 0f 1f 44 00 00 e8 eb fb ff =
ff eb e1 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 =
<f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c=20
[  200.983037] RIP  [<ffffffff811e83ed>] memcpy+0xd/0x110
[  200.983065]  RSP <ffff8801f4bf7b68>
[  200.983087] ---[ end trace e93713a9d40cd06f ]---
[  361.453631] SysRq : Resetting
[  361.453663] ACPI MEMORY or I/O RESET_REG.

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP9GlbAAoJEKLT589SE0a0k4IQALRqthlEumdrpUf1JgS+d6Yu
m6OcGxbsafS5OnP3Ut9DljzVP11kDr7TwkFgUqp4bK7vMrr9Ey0d203kHTWt+6BF
MtxjaSnY+uCeH8VgANUPPl3vVuM8vOP2y+3xU10O3h/97T1J8M22f7LTrrBJ3N/q
cpjEBBxw5dXJ9A5EumHdx8g4e8VI+7TZURU0xGIX6+aTxC8dgSoRAf4Q1SuTpRtR
kXVEeJ2WA2IZ6+0/5565D2nmx979/0hcoxMrJNtHxZX66BrEFrDKp22myAe15d0Q
2zB05RD/6L/s9ZYGqJBMNzgUnDSR2nU8fwrsPdMD5ydROP2deM1jaijEYWYrKxsV
f4dPvZn3iLsMSLWwOG02MN+AlY549xBkGIsAvU20IUa5BvI3DYipaPf8Fsov12WI
QRQW2tGMRpGEXJoohw/oO/3JRYyGztcTHYhTw3GRWOuu1hLDmo/1pIVmemefSjb3
5TrHeNuW4JrWdgeo4HIzFB/lCB5merbtn8Wpqqwd1B6SOS0Ej7LdbmyvAfFQroJh
o8ucDiTGb0hRauyMGM0YZZ3gedgRCAiVFDn7uK10LtHj1cDyg/ww536ZxS42Uvmh
LOeDUFGgjr6Bb9KVp/B7pm1Ukz8vV1yQy4hjmzlJDZ5uAOwlXfuE9hrtom3S3q6l
V1rvXObU6mYg3jOL+0Fq
=54wu
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
