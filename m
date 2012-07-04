Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:56076 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab2GDARW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 20:17:22 -0400
Date: Wed, 4 Jul 2012 03:17:14 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120704001713.GA8986@sli.dy.fi>
References: <20120702230121.GD12755@sli.dy.fi>
 <4FF2EF68.6090401@jan-o-sch.net>
 <20120703135824.GA8908@sli.dy.fi>
 <4FF3032D.1010007@jan-o-sch.net>
 <20120703224756.GA21647@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
In-Reply-To: <20120703224756.GA21647@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 04, 2012 at 01:47:56AM +0300, Sami Liedes wrote:
> I've seen this before: An overly long "Modules linked in:" line causes
> a large gap in netconsole output.

I managed to capture the entire output using netconsole by modifying
the kernel to not output the list of modules.

	Sami


------------------------------------------------------------
[  125.827919] netpoll: netconsole: local port 4444
[  125.827946] netpoll: netconsole: local IP 192.168.1.2
[  125.827969] netpoll: netconsole: interface 'eth0'
[  125.827990] netpoll: netconsole: remote port 1194
[  125.828011] netpoll: netconsole: remote IP 192.168.1.73
[  125.828034] netpoll: netconsole: remote ethernet address 00:1c:10:44:47:=
2c
[  125.828169] console [netcon0] enabled
[  125.828193] netconsole: network logging started
[  247.787472] ------------[ cut here ]------------
[  247.787536] WARNING: at fs/btrfs/extent_io.c:4522 read_extent_buffer+0xe=
6/0x110 [btrfs]()
[  247.787573] Hardware name: System Product Name
[  247.787594] Modules linked in: <omitted>  [last unloaded: scsi_wait_scan]
[  247.787632] Pid: 1146, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #1
[  247.787674] Call Trace:
[  247.787692]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
[  247.787794]  [<ffffffff810390a5>] warn_slowpath_null+0x15/0x20
[  247.787835]  [<ffffffffa01d7d86>] read_extent_buffer+0xe6/0x110 [btrfs]
[  247.787877]  [<ffffffffa01cf03d>] btrfs_node_key+0x1d/0x20 [btrfs]
[  247.787917]  [<ffffffffa02054d0>] __readahead_hook.isra.5+0x3c0/0x420 [b=
trfs]
[  247.787959]  [<ffffffffa020585f>] btree_readahead_hook+0x1f/0x40 [btrfs]
[  247.787999]  [<ffffffffa01ab841>] btree_readpage_end_io_hook+0x111/0x260=
 [btrfs]
[  247.788043]  [<ffffffffa01d3442>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  247.788087]  [<ffffffffa01d408b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  247.788129]  [<ffffffffa01aae61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  247.788161]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  247.788194]  [<ffffffffa01aae6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  247.788234]  [<ffffffffa01e1847>] worker_loop+0x157/0x560 [btrfs]
[  247.788272]  [<ffffffffa01e16f0>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  247.788306]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  247.788332]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  247.788360]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  247.788389]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  247.788413] ---[ end trace e93713a9d40cd06e ]---
[  247.788444] general protection fault: 0000 [#1] SMP=20
[  247.788473] CPU 5=20
[  247.788484] Modules linked in: <omitted>  [last unloaded: scsi_wait_scan]
[  247.788523]=20
[  247.788533] Pid: 1146, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #1 System manufacturer System Product Name/P8P67 EVO
[  247.788595] RIP: 0010:[<ffffffff811e83ed>]  [<ffffffff811e83ed>] memcpy+=
0xd/0x110
[  247.788632] RSP: 0000:ffff8802152f3ba8  EFLAGS: 00010202
[  247.788656] RAX: ffff8802152f3c8f RBX: 0000000000000011 RCX: 00000000000=
00002
[  247.788687] RDX: 0000000000000001 RSI: 0005080000000003 RDI: ffff8802152=
f3c8f
[  247.788719] RBP: ffff8802152f3bf0 R08: 0000000000000000 R09: 00000000000=
00000
[  247.788750] R10: ffff880207dd89c0 R11: ffff8801f3a90780 R12: ffff8802152=
f3ca0
[  247.788782] R13: ffff8801c1d5b830 R14: 0000000000000048 R15: 00000000000=
00011
[  247.788814] FS:  0000000000000000(0000) GS:ffff88021ed40000(0000) knlGS:=
0000000000000000
[  247.788850] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  247.788876] CR2: 00000000038942a0 CR3: 00000001c26ce000 CR4: 00000000000=
407e0
[  247.788907] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  247.788939] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  247.788971] Process btrfs-endio-met (pid: 1146, threadinfo ffff8802152f2=
000, task ffff8801f4192ca0)
[  247.789009] Stack:
[  247.789021]  ffffffffa01d7d5b ffff8802010b7000 0000000000008003 00000000=
00001000
[  247.789066]  ffff8802152f3c58 00000000000003dd ffff88021032fa20 ffff8802=
152f3c58
[  247.789112]  6669646e65230a29 ffff8802152f3c00 ffffffffa01cf03d ffff8802=
152f3cd0
[  247.789157] Call Trace:
[  247.789184]  [<ffffffffa01d7d5b>] ? read_extent_buffer+0xbb/0x110 [btrfs]
[  247.789226]  [<ffffffffa01cf03d>] btrfs_node_key+0x1d/0x20 [btrfs]
[  247.789265]  [<ffffffffa02054d0>] __readahead_hook.isra.5+0x3c0/0x420 [b=
trfs]
[  247.789308]  [<ffffffffa020585f>] btree_readahead_hook+0x1f/0x40 [btrfs]
[  247.789348]  [<ffffffffa01ab841>] btree_readpage_end_io_hook+0x111/0x260=
 [btrfs]
[  247.789391]  [<ffffffffa01d3442>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  247.789434]  [<ffffffffa01d408b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  247.789475]  [<ffffffffa01aae61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  247.789506]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  247.789539]  [<ffffffffa01aae6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  247.789578]  [<ffffffffa01e1847>] worker_loop+0x157/0x560 [btrfs]
[  247.789616]  [<ffffffffa01e16f0>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  247.789648]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  247.789672]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  247.789700]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  247.789729]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  247.789753] Code: 4e 48 83 c4 08 5b 5d c3 66 0f 1f 44 00 00 e8 eb fb ff =
ff eb e1 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 =
<f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c=20
[  247.790092] RIP  [<ffffffff811e83ed>] memcpy+0xd/0x110
[  247.790120]  RSP <ffff8802152f3ba8>
[  247.790138] ---[ end trace e93713a9d40cd06f ]---

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP84uIAAoJEKLT589SE0a0OzYP/2M3byo4ypCbyRvz509DyZa4
Ul4iL/nvbewKbg2EPmdlA3wiCNXgPjPrDcqRpidccGae65ELX+HAMedjUiZ8qZxS
lYms6J44TUfx/JTg6I62hkoi8l5JejraInU020HboR/RikMteySRKdDs8bWkJiCl
y1hksQ9L+WXpkWXh0j+ElJYIUNqLOqEfftT6CjgQkxrgcJ3SRcAAc2hQiRWFiTQB
T6078kvak4Iw4nvSWl7aNP5+OyfzfsjnwVda8pPOgKzIwo/hsZv1pwaTVh/+m2ei
JaVKqU6ZZFCpJLKyPHIUCK5u0KBaxaUSE76xtUgdOfyEpvJSPe74a8Ieo3AfB9Z7
+85jtF+QlUTFLiOQPp4toclzOJ16vJV2yF5tl+ePwhoOtXFjLfTtmdffZvPb/48G
uDrCB7k3sgiv860MrV1XUo49JyuObPBsMVaFVbBkD2nhg7LrwTzfzIN4sAih1EIK
ySVLdVQnvMG+i02FZKrQtrzYs9oM3Rq/eoAf29umeJE9i0pFLYifw2iQtEpfx4Lb
Aa6Ke+gE6JltFaAXC976XPYRAYQLbhwHK5lw71qWGdbtC1OzVme055KlOhXc7uvb
o64lOe7TvMoorEag+MELpijTz8SdZ6u3xXtzyU01gOFffFbtzJC3+fYJm8BSCL3H
2Zq5Z3VHo7gDhOa758gx
=shAM
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
