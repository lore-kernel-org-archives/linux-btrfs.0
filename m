Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:55346 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab2GEXr5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jul 2012 19:47:57 -0400
Date: Fri, 6 Jul 2012 02:47:40 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120705234739.GA9736@sli.dy.fi>
References: <4FF2EF68.6090401@jan-o-sch.net>
 <20120703135824.GA8908@sli.dy.fi>
 <4FF3032D.1010007@jan-o-sch.net>
 <20120703224756.GA21647@sli.dy.fi>
 <20120704001713.GA8986@sli.dy.fi>
 <4FF42876.8010309@jan-o-sch.net>
 <20120704160340.GA9770@sli.dy.fi>
 <4FF47168.9010405@jan-o-sch.net>
 <20120704202452.GA8996@sli.dy.fi>
 <4FF5998D.8020205@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
In-Reply-To: <4FF5998D.8020205@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 05, 2012 at 03:41:33PM +0200, Jan Schmidt wrote:
> I'd like to see if you corrupted your trees on disk in a really strange
> manner (with matching checksums?), or if data comes from the disk intact
> and becomes damaged thereafter.
>=20
> Could you store the output of
> 	btrfs-debug-tree /dev/[whatever]
> before try number 5 and afterwards? It will be quite a lot if you've got
> a lot of files in there. Don't send it anywhere right now, just store it
> away if possible.

Ok, I have it stored. I mounted the fs read-only to do that just to be
safe, because when I did it on a live fs I got some (~15) "parent
transid verify failed" messages.

> Can you double check that there's nothing about corrected errors in your
> logs? Scrub will correct errors along the way and log that. So maybe
> we've only a few tries left to find the root cause.

Nope, definitely nothing there. A few "unlinked orphans" messages at
mount time, but that's all. I'm sure I would have captured any further
messages on my netconsole. Also nothing in any earlier logs that I can
see.

Well, until now (try 6) anyway. I actually ran btrfs scrub / twice now
after running btrfs-debug-tree (tries 5 and 6), because on the first
try I ran on wrong kernel (without the debug patch). On try 5 it
crashed very quickly, probably in less than a second. I also noticed
that it doesn't actually crash the machine or even make the filesystem
unusable in any way (apart from unmount blocking at shutdown), so I
also have the same oopses in my log files stored on the same
filesystem. But no, nothing about corrected errors or checksum
failures. So:

Try 5 (without your new patch, but after running btrfs-debug-tree); no
checksum failures as before, similar crash to before:

------------------------------------------------------------
[ 2036.512656] btrfs: invalid parameters for read_extent_buffer: start (327=
71) > eb->len (32768). eb start is 2239379931136, level 102, generation 309=
534250463128, nritems 56187918. len param 17. debug 2/989/56187918/30953425=
0463128
[ 2036.512770] ------------[ cut here ]------------
[ 2036.512834] WARNING: at fs/btrfs/extent_io.c:4528 read_extent_buffer+0x1=
67/0x1a0 [btrfs]()
[ 2036.512880] Hardware name: System Product Name
[ 2036.512906] Modules linked in: <omitted>  [last unloaded: netconsole]
[ 2036.512954] Pid: 1135, comm: btrfs-endio-met Tainted: G        W    3.4.=
4-modded-oops+ #2
[...]
------------------------------------------------------------

Try 6, with your new patch - as a new thing, got checksum errors,
including one very slightly before the crash and with the same "eb
start" as in the "invalid parameters" message. Crashed in a couple of
minutes.

Now that I look at the the log below it actually has two crashes in
it, one of btrfs-endio-met pid 1212 and another one of btrfs-endio-met
pid some 72 seconds later. I didn't notice that until after the fact.

dm-6 (the device with checksum failures) is on a disk on which I don't
have anything else besides this partition, so I suppose it could be
corrupting data without me having noticed. I know it used to work at
one time, but that doesn't mean too much. Anyway, I'm sure I haven't
seen any "checksum verify failed" messages until now. None in the logs
either.

Ah, one thing I have forgotten to mention. I think I've been using
this filesystem for maybe a month now. It started as a single-device
filesystem, but I did restriping to raid-1 on June 12. dm-5 is the
original device, while dm-6 (the one with the checksum failures in try
6) is the added one. I still have logs of the restriping and
everything after that; grep reveals no unusual lines containing
"btrfs" in all the logs since then, apart from the crashes. Besides
the oopses and lines that mention btrfs just because of the kernel
version 3.4.4+btrfsdebug, this is a summary of all the lines that
mention btrfs:

  btrfs: disk space caching is enabled
  btrfs flagging fs with big metadata feature
  btrfs: new size for /dev/mapper/rootvg-scratch_crypt is 751617179648
     * this device is not on the filesystem with problems - although I
       haven't tried scrubbing this filesystem
  btrfs: unlinked 104 orphans (10 times with 4 different numbers)

And during restriping

  btrfs: found 10008 extents (and similar)
  btrfs: relocating block group 1019010351104 flags 1 (and similar)

And two different warnings in the last few days, but I think this is
only because the debug patches changed the code:

  WARNING: at fs/btrfs/extent_io.c:4522 read_extent_buffer+0xe6/0x110 [btrf=
s]()
  WARNING: at fs/btrfs/extent_io.c:4528 read_extent_buffer+0x167/0x1a0 [btr=
fs]()

Another thing that comes to mind that I might well be the only one
that uses btrfs with raid-1 on two separate dm-crypted devices
(contrary to the way suggested on Btrfs FAQ - in my experience that
can actually speed up things, especially on computers without hardware
crypto, because the kernel has only one kcryptd thread per dm-crypt
device and therefore only can use a single core per device. Plus I get
the benefits of btrfs "smart raid".).

So, try 6. The three first lines are from me starting btrfs-debug-tree
again just as a quick way to verify that my netconsole setup was
working. The first checksum failure came pretty much instantly after
starting scrub:

------------------------------------------------------------
[  168.207151] device fsid f26f08b1-89e6-4f2d-b7f9-857010dd2517 devid 1 tra=
nsid 151087 /dev/dm-5
[  168.208541] device fsid f26f08b1-89e6-4f2d-b7f9-857010dd2517 devid 2 tra=
nsid 151087 /dev/dm-6
[  168.284668] device fsid ad75beab-b52b-4f63-9d14-956cc8e95fc7 devid 1 tra=
nsid 5001 /dev/dm-9
[  188.507789] btrfs: dm-6 checksum verify failed on 2237998628864 wanted C=
3D64F found DCBF0869 level 88
[  188.507852] btrfs: node seems invalid now. checksum ok =3D 1
[  262.706585] btrfs: dm-6 checksum verify failed on 2246859587584 wanted 3=
D013CF8 found AD06874A level 77
[  262.706650] btrfs: node seems invalid now. checksum ok =3D 1
[  262.706822] btrfs: invalid parameters for read_extent_buffer: start (327=
71) > eb->len (32768). eb start is 2246859587584, level 77, generation 9306=
7543380099401, nritems 21766576. len param 17. debug 2/989/21766576/9306754=
3380099401
[  262.706929] ------------[ cut here ]------------
[  262.706992] WARNING: at fs/btrfs/extent_io.c:4529 read_extent_buffer+0x1=
67/0x1a0 [btrfs]()
[  262.707051] Hardware name: System Product Name
[  262.707078] Modules linked in: <omitted> [last unloaded: netconsole]
[  262.707126] Pid: 1212, comm: btrfs-endio-met Tainted: G        W    3.4.=
4+btrfsdebug #1
[  262.707169] Call Trace:
[  262.707193]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
[  262.707229]  [<ffffffff810390a5>] warn_slowpath_null+0x15/0x20
[  262.707282]  [<ffffffffa01d8fc7>] read_extent_buffer+0x167/0x1a0 [btrfs]
[  262.707339]  [<ffffffffa01d01fd>] btrfs_node_key+0x1d/0x20 [btrfs]
[  262.707391]  [<ffffffffa02067af>] __readahead_hook+0x44f/0x500 [btrfs]
[  262.707444]  [<ffffffffa0206b78>] btree_readahead_hook+0x18/0x40 [btrfs]
[  262.707497]  [<ffffffffa01ac9d1>] btree_readpage_end_io_hook+0x111/0x270=
 [btrfs]
[  262.707556]  [<ffffffffa01d4602>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  262.707613]  [<ffffffffa01d524b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  262.707668]  [<ffffffffa01abe61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  262.707708]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  262.707753]  [<ffffffffa01abe6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  262.707805]  [<ffffffffa01e2a97>] worker_loop+0x157/0x560 [btrfs]
[  262.707856]  [<ffffffffa01e2940>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  262.707898]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  262.707930]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  262.707966]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  262.708003]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  262.708034] ---[ end trace e93713a9d40cd06e ]---
[  262.708072] general protection fault: 0000 [#1] SMP=20
[  262.708112] CPU 1=20
[  262.708126] Modules linked in: <omitted> [last unloaded: netconsole]
[  262.708176]=20
[  262.708190] Pid: 1212, comm: btrfs-endio-met Tainted: G        W    3.4.=
4+btrfsdebug #1 System manufacturer System Product Name/P8P67 EVO
[  262.708268] RIP: 0010:[<ffffffff811e83ed>]  [<ffffffff811e83ed>] memcpy+=
0xd/0x110
[  262.708316] RSP: 0018:ffff8801fe19bb68  EFLAGS: 00010202
[  262.708347] RAX: ffff8801fe19bc8f RBX: 0000000000000011 RCX: 00000000000=
00002
[  262.708387] RDX: 0000000000000001 RSI: 0005080000000003 RDI: ffff8801fe1=
9bc8f
[  262.708426] RBP: ffff8801fe19bbe0 R08: 0000000000000000 R09: 00000000000=
00000
[  262.708466] R10: ffff8801fe19bc8f R11: ffff8801f3184780 R12: ffff8801fe1=
9bca0
[  262.708505] R13: ffff88020fc0ca48 R14: 0000000000000048 R15: 00000000000=
00011
[  262.708545] FS:  0000000000000000(0000) GS:ffff88021ec40000(0000) knlGS:=
0000000000000000
[  262.708590] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  262.708622] CR2: ffffffffff600400 CR3: 000000000180c000 CR4: 00000000000=
407e0
[  262.708661] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  262.708701] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  262.708741] Process btrfs-endio-met (pid: 1212, threadinfo ffff8801fe19a=
000, task ffff88020e07c2f0)
[  262.708790] Stack:
[  262.708804]  ffffffffa01d8f1b ffff8802014c21b0 0000000000000011 00000000=
00000002
[  262.708864]  00000000000003dd 00000000014c21b0 014aa470074a0149 ffff8802=
0f95e000
[  262.708925]  ffff8801fe19bc8f 0000000000001000 ffff8801fe19bc58 00000000=
000003dd
[  262.708984] Call Trace:
[  262.709021]  [<ffffffffa01d8f1b>] ? read_extent_buffer+0xbb/0x1a0 [btrfs]
[  262.709077]  [<ffffffffa01d01fd>] btrfs_node_key+0x1d/0x20 [btrfs]
[  262.709128]  [<ffffffffa02067af>] __readahead_hook+0x44f/0x500 [btrfs]
[  262.709179]  [<ffffffffa0206b78>] btree_readahead_hook+0x18/0x40 [btrfs]
[  262.709233]  [<ffffffffa01ac9d1>] btree_readpage_end_io_hook+0x111/0x270=
 [btrfs]
[  262.709291]  [<ffffffffa01d4602>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  262.709349]  [<ffffffffa01d524b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  262.709404]  [<ffffffffa01abe61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  262.709443]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  262.709487]  [<ffffffffa01abe6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  262.709539]  [<ffffffffa01e2a97>] worker_loop+0x157/0x560 [btrfs]
[  262.709590]  [<ffffffffa01e2940>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  262.709631]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  262.709662]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  262.709698]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  262.709735]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  262.709765] Code: 4e 48 83 c4 08 5b 5d c3 66 0f 1f 44 00 00 e8 eb fb ff =
ff eb e1 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 =
<f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c=20
[  262.710178] RIP  [<ffffffff811e83ed>] memcpy+0xd/0x110
[  262.712431]  RSP <ffff8801fe19bb68>
[  262.714672] ---[ end trace e93713a9d40cd06f ]---
[  334.817046] btrfs: dm-6 checksum verify failed on 2239529385984 wanted 2=
06D6165 found C4529DEC level 10
[  334.818677] btrfs: node seems invalid now. checksum ok =3D 1
[  334.820432] btrfs: invalid parameters for read_extent_buffer: start (327=
71) > eb->len (32768). eb start is 2239529385984, level 10, generation 7310=
033184097661728, nritems 996502889. len param 17. debug 2/989/996502889/731=
0033184097661728
[  334.823857] ------------[ cut here ]------------
[  334.825602] WARNING: at fs/btrfs/extent_io.c:4529 read_extent_buffer+0x1=
67/0x1a0 [btrfs]()
[  334.827336] Hardware name: System Product Name
[  334.829049] Modules linked in: <omitted> [last unloaded: netconsole]
[  334.830814] Pid: 1132, comm: btrfs-endio-met Tainted: G      D W    3.4.=
4+btrfsdebug #1
[  334.832571] Call Trace:
[  334.834323]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
[  334.836095]  [<ffffffff810390a5>] warn_slowpath_null+0x15/0x20
[  334.837883]  [<ffffffffa01d8fc7>] read_extent_buffer+0x167/0x1a0 [btrfs]
[  334.839658]  [<ffffffffa01d01fd>] btrfs_node_key+0x1d/0x20 [btrfs]
[  334.841427]  [<ffffffffa02067af>] __readahead_hook+0x44f/0x500 [btrfs]
[  334.843209]  [<ffffffffa0206b78>] btree_readahead_hook+0x18/0x40 [btrfs]
[  334.844996]  [<ffffffffa01ac9d1>] btree_readpage_end_io_hook+0x111/0x270=
 [btrfs]
[  334.846807]  [<ffffffffa01d4602>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  334.848618]  [<ffffffffa01d524b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  334.850448]  [<ffffffffa01abe61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  334.852246]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  334.854051]  [<ffffffffa01abe6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  334.855866]  [<ffffffffa01e2a97>] worker_loop+0x157/0x560 [btrfs]
[  334.857674]  [<ffffffffa01e2940>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  334.859471]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  334.861248]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  334.863039]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  334.864824]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  334.866604] ---[ end trace e93713a9d40cd070 ]---
[  334.868388] general protection fault: 0000 [#2] SMP=20
[  334.870179] CPU 1=20
[  334.870193] Modules linked in: <omitted> [last unloaded: netconsole]
[  334.873732]=20
[  334.875508] Pid: 1132, comm: btrfs-endio-met Tainted: G      D W    3.4.=
4+btrfsdebug #1 System manufacturer System Product Name/P8P67 EVO
[  334.877390] RIP: 0010:[<ffffffff811e83ed>]  [<ffffffff811e83ed>] memcpy+=
0xd/0x110
[  334.879272] RSP: 0018:ffff8801f2cbdb68  EFLAGS: 00010202
[  334.881147] RAX: ffff8801f2cbdc8f RBX: 0000000000000011 RCX: 00000000000=
00002
[  334.883023] RDX: 0000000000000001 RSI: 0005080000000003 RDI: ffff8801f2c=
bdc8f
[  334.884885] RBP: ffff8801f2cbdbe0 R08: 0000000000000000 R09: 00000000000=
00000
[  334.886768] R10: ffff8801f2cbdc8f R11: ffff8801f3184780 R12: ffff8801f2c=
bdca0
[  334.888636] R13: ffff88020fcca468 R14: 0000000000000048 R15: 00000000000=
00011
[  334.890521] FS:  0000000000000000(0000) GS:ffff88021ec40000(0000) knlGS:=
0000000000000000
[  334.892409] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  334.894314] CR2: 00007f784a4fd5d8 CR3: 000000000180c000 CR4: 00000000000=
407e0
[  334.896227] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  334.898169] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  334.900095] Process btrfs-endio-met (pid: 1132, threadinfo ffff8801f2cbc=
000, task ffff8801f491d940)
[  334.902067] Stack:
[  334.904011]  ffffffffa01d8f1b ffff88023b656d69 0000000000000011 00000000=
00000002
[  334.906031]  00000000000003dd 000000003b656d69 6572747362757320 ffff8802=
0d9a8000
[  334.908045]  ffff8801f2cbdc8f 0000000000001000 ffff8801f2cbdc58 00000000=
000003dd
[  334.910091] Call Trace:
[  334.912112]  [<ffffffffa01d8f1b>] ? read_extent_buffer+0xbb/0x1a0 [btrfs]
[  334.914183]  [<ffffffffa01d01fd>] btrfs_node_key+0x1d/0x20 [btrfs]
[  334.916243]  [<ffffffffa02067af>] __readahead_hook+0x44f/0x500 [btrfs]
[  334.918312]  [<ffffffffa0206b78>] btree_readahead_hook+0x18/0x40 [btrfs]
[  334.920376]  [<ffffffffa01ac9d1>] btree_readpage_end_io_hook+0x111/0x270=
 [btrfs]
[  334.922471]  [<ffffffffa01d4602>] ? find_first_extent_bit_state+0x22/0x8=
0 [btrfs]
[  334.924568]  [<ffffffffa01d524b>] end_bio_extent_readpage+0xcb/0xa30 [bt=
rfs]
[  334.926667]  [<ffffffffa01abe61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
[  334.928729]  [<ffffffff81158988>] bio_endio+0x18/0x30
[  334.930798]  [<ffffffffa01abe6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
[  334.932878]  [<ffffffffa01e2a97>] worker_loop+0x157/0x560 [btrfs]
[  334.934952]  [<ffffffffa01e2940>] ? btrfs_queue_worker+0x310/0x310 [btrf=
s]
[  334.937009]  [<ffffffff81058e5e>] kthread+0x8e/0xa0
[  334.939053]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[  334.941105]  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
[  334.943190]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[  334.945270] Code: 4e 48 83 c4 08 5b 5d c3 66 0f 1f 44 00 00 e8 eb fb ff =
ff eb e1 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 =
<f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c=20
[  334.950107] RIP  [<ffffffff811e83ed>] memcpy+0xd/0x110
[  334.952402]  RSP <ffff8801f2cbdb68>
[  334.954732] ---[ end trace e93713a9d40cd071 ]---
------------------------------------------------------------

	Sami

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP9iebAAoJEKLT589SE0a0NSYP/0R2a8G37N3vHfTMweFIpjMu
x+L4edtQWGCNco2axvmgccIcSCUhhWvwi+UH0KI6SEnC6cfud72sewYv1gEi6EFo
nw38VxgqZA/TITYbsv8VUJgdFgF+hmKW7WhT2VDG3iuGnSBAkYe4fO9Sv2o54r24
0QVMXfdm//zUfD/7lL/8TkkwIn9l74FCScJFJyU294PMqNLIGbo8XBmlwm28tZR/
ltYClHWDyGPlNTHSkGOlgX7TjmEyBm6jzc+BnvahGK9YEcX7cFdDz2yTAnGD3tEj
atjqIc1D3070jgKCawEHa+z+bjdjnCGO+iOCJOzFs6wLvoUDpGGkw1IrnyRXcG/I
QgXUjGNCZK43ZIZ7lOCWWOYEda+PdkTN4iESx3eaDvgbX1taMNE2YOp1cnzAOBFX
jbE0mO088F7oSiIm5rFJ6SK+uw++E+Kwpjm+wOUtRc4i2Ni0CQwmEJNh3u/IEwhK
H2zSa/BdKyWp3WJ3NaiMvrbB+GEjSbwcZF6haCbIbQH5+lJGuZthWrRvquFrFZ/0
B+q5ALApqrz5CSaByp/sFdTcC39zze8iFxTNd0MsRtE4pocAdUSn0jMcE1lXEJjV
FDjO8ybb6iAlxE936gn0Zns0Fk6DtoSQKBNCcxYLzqu9d0eIWlHzwnLWIKEt6cc7
sv2zgjUNHVDdHFMs0HHp
=ce4v
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
