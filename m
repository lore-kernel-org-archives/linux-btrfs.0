Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:34384 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab2GDUZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 16:25:08 -0400
Date: Wed, 4 Jul 2012 23:24:53 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120704202452.GA8996@sli.dy.fi>
References: <20120702230121.GD12755@sli.dy.fi>
 <4FF2EF68.6090401@jan-o-sch.net>
 <20120703135824.GA8908@sli.dy.fi>
 <4FF3032D.1010007@jan-o-sch.net>
 <20120703224756.GA21647@sli.dy.fi>
 <20120704001713.GA8986@sli.dy.fi>
 <4FF42876.8010309@jan-o-sch.net>
 <20120704160340.GA9770@sli.dy.fi>
 <4FF47168.9010405@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
In-Reply-To: <4FF47168.9010405@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 04, 2012 at 06:38:00PM +0200, Jan Schmidt wrote:
> > [  200.980496] btrfs: invalid parameters for read_extent_buffer: start =
(32771) > eb->len (32768). eb start is 2243489562624, level 26, generation =
3144240307695375391, nritems 620178657. len param 17. debug 2/989/620178657=
/3144240307695375391

Let's call this try 1. I ran it three more times, so below we have
tries 2, 3 and 4.

> Wow, that's strange. Can you repeat your test once or twice and paste tha=
t line,
> please? I'd like to get a feeling if the values are completely random.

Curiously, it clearly takes longer for it to crash after starting the
scrub each time I run it. Also on try 4 I got an entirely different
crash (backtrace below). Now it scrubs maybe the first 200G or so of
both devices of the (raid-1) 2.2T filesystem before it crashes.

start and eb->len seem to be the same (32771 and 32768) every time. eb
start varies, but there's some pattern if you view them in hex:

  Try 1  20a5a660000
  Try 2  20bb0018000
  Try 3  20a8bc28000
  Try 4  (no output, different crash)

The rest of the values seem to me to be completely different every time.

	Sami


Try 2:

------------------------------------------------------------
[12961.870107] btrfs: invalid parameters for read_extent_buffer: start (327=
71) > eb->len (32768). eb start is 2249220784128, level 14, generation 2242=
260605927040034, nritems 117835525. len param 17. debug 2/989/117835525/224=
2260605927040034
[12961.870204] ------------[ cut here ]------------
[12961.870264] WARNING: at fs/btrfs/extent_io.c:4528 read_extent_buffer+0x1=
67/0x1a0 [btrfs]()
[12961.870302] Hardware name: System Product Name
[12961.870322] Modules linked in: <omitted>  [last unloaded: scsi_wait_scan]
[12961.870367] Pid: 1144, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #2
[12961.870403] Call Trace:
[12961.870421]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
[12961.870449]  [<ffffffff810390a5>] warn_slowpath_null+0x15/0x20
[...]
------------------------------------------------------------

Try 3:

------------------------------------------------------------
[  531.770984] btrfs: invalid parameters for read_extent_buffer: start (327=
71) > eb->len (32768). eb start is 2244317708288, level 170, generation 136=
39284858109917187, nritems 6171943. len param 17. debug 2/989/6171943/13639=
284858109917187
[  531.771081] ------------[ cut here ]------------
[  531.771133] WARNING: at fs/btrfs/extent_io.c:4528 read_extent_buffer+0x1=
67/0x1a0 [btrfs]()
[  531.771169] Hardware name: System Product Name
[  531.771191] Modules linked in: <omitted>  [last unloaded: scsi_wait_scan]
[  531.771229] Pid: 1132, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #2
[  531.771265] Call Trace:
[  531.771282]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
[...]
------------------------------------------------------------

Try 4:

------------------------------------------------------------
[   95.933108] netconsole: network logging started
[  982.651987] unable to find logical 691402650139365534 len 32768
[  982.652060] ------------[ cut here ]------------
[  982.652085] kernel BUG at fs/btrfs/volumes.c:3725!
[  982.652109] invalid opcode: 0000 [#1] SMP=20
[  982.652138] CPU 4=20
[  982.652149] Modules linked in: <omitted>  [last unloaded: scsi_wait_scan]
[  982.652190]=20
[  982.652201] Pid: 1127, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #2 System manufacturer System Product Name/P8P67 EVO
[  982.652264] RIP: 0010:[<ffffffffa0257778>]  [<ffffffffa0257778>] __btrfs=
_map_block+0x668/0x680 [btrfs]
[  982.652323] RSP: 0000:ffff8801f43cfa70  EFLAGS: 00010286
[  982.652347] RAX: 0000000000000049 RBX: 09985b0c0e52109e RCX: 00000000000=
00082
[  982.652379] RDX: 00000000000000e8 RSI: 0000000000000046 RDI: 00000000000=
00246
[  982.652411] RBP: ffff8801f43cfb10 R08: 0000000000000000 R09: 00000000000=
00000
[  982.652443] R10: ffff8801f1fbf680 R11: ffff8801f3b00780 R12: ffff8801f00=
26108
[  982.652475] R13: 0000000000008000 R14: ffff8801f0026fe0 R15: ffff8801f43=
cfbb0
[  982.652507] FS:  0000000000000000(0000) GS:ffff88021ed00000(0000) knlGS:=
0000000000000000
[  982.652542] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  982.652568] CR2: 00000000f775c000 CR3: 00000002110a1000 CR4: 00000000000=
407e0
[  982.652600] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  982.652632] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  982.652664] Process btrfs-endio-met (pid: 1127, threadinfo ffff8801f43ce=
000, task ffff8801f401c2f0)
[  982.652703] Stack:
[  982.652715]  ffff8801f43cfa90 ffffffff811dc553 ffff88021ec0ce88 ffff8802=
1ed0ce80
[  982.652761]  ffff8801f43cfb00 0000000000000086 ffff8801f43cfaf0 00000000=
00000086
[  982.652807]  000000fdf43cfad0 ffff8801f43cfba8 0000002000000004 00000000=
00000004
[  982.652852] Call Trace:
[  982.652869]  [<ffffffff811dc553>] ? cpumask_next_and+0x23/0x40
[  982.652897]  [<ffffffff8111d7e2>] ? kmem_cache_alloc_trace+0xc2/0x100
[  982.652940]  [<ffffffffa025aac9>] btrfs_map_block+0x9/0x10 [btrfs]
[  982.652979]  [<ffffffffa0280ad2>] reada_add_block+0x1c2/0x890 [btrfs]
[  982.653010]  [<ffffffff8140a4a2>] ? __slab_free+0xde/0x24e
[  982.653045]  [<ffffffffa0281447>] __readahead_hook.isra.5+0x2a7/0x460 [b=
trfs]
[  982.653086]  [<ffffffffa028192f>] btree_readahead_hook+0x1f/0x40 [btrfs]
[  982.653126]  [<ffffffffa0227841>] btree_readpage_end_io_hook+0x111/0x260=
 [btrfs]
[  982.653168]  [<ffffffffa024f442>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  982.653211]  [<ffffffffa025008b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  982.653252]  [<ffffffffa0226e61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  982.653284]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  982.653317]  [<ffffffffa0226e6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  982.653355]  [<ffffffffa025d8d7>] worker_loop+0x157/0x560 [btrfs]
[  982.653393]  [<ffffffffa025d780>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  982.653427]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  982.653451]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  982.653480]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  982.653509]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  982.653533] Code: e6 89 c7 eb a4 0f 0b c7 45 c4 01 00 00 00 31 db e9 08 =
fd ff ff 0f 0b 49 8b 17 48 89 de 48 c7 c7 08 0c 29 a0 31 c0 e8 e3 09 1b e1 =
<0f> 0b 0f 0b 89 df e9 73 ff ff ff 66 66 66 66 2e 0f 1f 84 00 00=20
[  982.653807] RIP  [<ffffffffa0257778>] __btrfs_map_block+0x668/0x680 [btr=
fs]
[  982.653853]  RSP <ffff8801f43cfa70>
[  982.653877] ---[ end trace e93713a9d40cd06e ]---
------------------------------------------------------------


--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP9KaUAAoJEKLT589SE0a0hMAQAL3iXFMpvWay6Ssg7Ky0qbKP
sUmh5y2pIJtarBv1sHRcBXKjZ+NZGEDItdtOvqYbECp/a3bkAz0IfVmxMxa0V8gz
eBvosi95qNsXMesudEJS4bWgpvKZ7iFBFLf1lYcympjqJ0p8M5AdifEh/pgd3hJF
7v7vqB6cVFvb+cZtt9V7smkZgEqhXyiCywkBjfAAQvxBEVsEEw6nZnqwfRC3+vh0
TYV36t/AdFTwgjBIkFKKh9/8lC0Trjo/k2Xx698v9YzyNPjLSSDNdWkrJ7Vc+Y9+
kAoYDHpudXr7OeKXSF/sPsSE8d+IqDMOztT8DX+Zy5wu5q9VHtIwzl3JuRtPi8vs
H0dIqenmqLa5sSY57RX+hiln6Rinshe8H3zf4kXrFMpPLA4gHtn8ISjKHUlJeBt+
tMwKRkvPaUlBDMMj/01Gii+DrzOyYMipJSZ6CXuZ/ceAkBnFcy29hw/7nEcKZUCA
b8kbezfIsaHJWsM/SdmuMBoYCs57Aro4LzkDXXbQlKDpO/fTMVma+DXi1uLWR8to
CicMjKnMz2+YtRY5Qqu/h2zQSHiWqrRxZe+J9dv0vvzalqY2Xuds9tAORpC8C9M9
48qregLqjk3kv/y3a9NfsqATAtAqiMTer7VFog0aceDP2nRKKaSY827Me+tsj8S1
LOAq+lx59FlsSCwKZOx5
=UJrX
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
