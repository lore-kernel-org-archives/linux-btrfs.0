Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:33794 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbcFXOwW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 10:52:22 -0400
Received: from [IPv6:2407:e400:b000:201:c586:44c:f762:4f7e] (unknown [IPv6:2407:e400:b000:201:c586:44c:f762:4f7e])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 887AA3A005C
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 00:50:09 +1000 (AEST)
To: linux-btrfs@vger.kernel.org
From: Steven Haigh <netwiz@crc.id.au>
Subject: Trying to rescue my data :(
Message-ID: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
Date: Sat, 25 Jun 2016 00:52:16 +1000
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="19H8MudtVDxF85T8lL70kF6sJfPI71rGo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--19H8MudtVDxF85T8lL70kF6sJfPI71rGo
Content-Type: multipart/mixed; boundary="NDgXbNJ8rh8XJxXPB203SbS5DoVqVotX4"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
Subject: Trying to rescue my data :(

--NDgXbNJ8rh8XJxXPB203SbS5DoVqVotX4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Ok, so I figured that despite what the BTRFS wiki seems to imply, the
'multi parity' support just isn't stable enough to be used. So, I'm
trying to revert to what I had before.

My setup consist of:
	* 2 x 3Tb drives +
	* 3 x 2Tb drives.

I've got (had?) about 4.9Tb of data.

My idea was to convert the existing setup using a balance to a 'single'
setup, delete the 3 x 2Tb drives from the BTRFS system, then create a
new mdadm based RAID6 (5 drives degraded to 3), create a new filesystem
on that, then copy the data across.

So, great - first the balance:
$ btrfs balance start -dconvert=3Dsingle -mconvert=3Dsingle -f (yes, I kn=
ow
it'll reduce the metadata redundancy).

This promptly was followed by a system crash.

After a reboot, I can no longer mount the BTRFS in read-write:
[  134.768908] BTRFS info (device xvdd): disk space caching is enabled
[  134.769032] BTRFS: has skinny extents
[  134.769856] BTRFS: failed to read the system array on xvdd
[  134.776055] BTRFS: open_ctree failed
[  143.900055] BTRFS info (device xvdd): allowing degraded mounts
[  143.900152] BTRFS info (device xvdd): not using ssd allocation scheme
[  143.900243] BTRFS info (device xvdd): disk space caching is enabled
[  143.900330] BTRFS: has skinny extents
[  143.901860] BTRFS warning (device xvdd): devid 4 uuid
61ccce61-9787-453e-b793-1b86f8015ee1 is missing
[  146.539467] BTRFS: missing devices(1) exceeds the limit(0), writeable
mount is not allowed
[  146.552051] BTRFS: open_ctree failed

I can mount it read only - but then I also get crashes when it seems to
hit a read error:
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064
csum 3245290974 wanted 982056704 mirror 0
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
390821102 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
550556475 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
1279883714 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
2566472073 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
1876236691 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
3350537857 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
3319706190 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
2377458007 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
2066127208 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
657140479 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
1239359620 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
1598877324 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
1082738394 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
371906697 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
2156787247 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
3777709399 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
180814340 wanted 982056704 mirror 1
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:2401!
invalid opcode: 0000 [#1] SMP
Modules linked in: btrfs x86_pkg_temp_thermal coretemp crct10dif_pclmul
xor aesni_intel aes_x86_64 lrw gf128mul glue_helper pcspkr raid6_pq
ablk_helper cryptd nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables
xen_netfront crc32c_intel xen_gntalloc xen_evtchn ipv6 autofs4
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
2610978113 wanted 982056704 mirror 1
BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
59610051 wanted 982056704 mirror 1
CPU: 1 PID: 1273 Comm: kworker/u4:4 Not tainted 4.4.13-1.el7xen.x86_64 #1=

Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
task: ffff880079ce12c0 ti: ffff880078788000 task.ti: ffff880078788000
RIP: e030:[<ffffffffa039e0e0>]  [<ffffffffa039e0e0>]
btrfs_check_repairable+0x100/0x110 [btrfs]
RSP: e02b:ffff88007878bcc8  EFLAGS: 00010297
RAX: 0000000000000001 RBX: ffff880079db2080 RCX: 0000000000000003
RDX: 0000000000000003 RSI: 000004db13730000 RDI: ffff88007889ef38
RBP: ffff88007878bce0 R08: 000004db01c00000 R09: 000004dbc1c00000
R10: ffff88006bb0c1b8 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88007b213ea8 R14: 0000000000001000 R15: 0000000000000000
FS:  00007fbf2fdc0880(0000) GS:ffff88007f500000(0000) knlGS:0000000000000=
000
CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbf2d96702b CR3: 000000007969f000 CR4: 0000000000042660
Stack:
 ffffea00019db180 0000000000010000 ffff88007b213f30 ffff88007878bd88
 ffffffffa03a0808 ffff880002d15500 ffff88007878bd18 ffff880079ce12c0
 ffff88007b213e40 000000000000001f ffff880000000000 ffff88006bb0c048
Call Trace:
 [<ffffffffa03a0808>] end_bio_extent_readpage+0x428/0x560 [btrfs]
 [<ffffffff812f40c0>] bio_endio+0x40/0x60
 [<ffffffffa0375a6c>] end_workqueue_fn+0x3c/0x40 [btrfs]
 [<ffffffffa03af3f1>] normal_work_helper+0xc1/0x300 [btrfs]
 [<ffffffff810a1352>] ? finish_task_switch+0x82/0x280
 [<ffffffffa03af702>] btrfs_endio_helper+0x12/0x20 [btrfs]
 [<ffffffff81093844>] process_one_work+0x154/0x400
 [<ffffffff8109438a>] worker_thread+0x11a/0x460
 [<ffffffff8165a24f>] ? __schedule+0x2bf/0x880
 [<ffffffff81094270>] ? rescuer_thread+0x2f0/0x2f0
 [<ffffffff810993f9>] kthread+0xc9/0xe0
 [<ffffffff81099330>] ? kthread_park+0x60/0x60
 [<ffffffff8165e14f>] ret_from_fork+0x3f/0x70
 [<ffffffff81099330>] ? kthread_park+0x60/0x60
Code: 00 31 c0 eb d5 8d 48 02 eb d9 31 c0 45 89 e0 48 c7 c6 a0 f8 3f a0
48 c7 c7 00 05 41 a0 e8 c9 f2 fa e0 31 c0 e9 70 ff ff ff 0f 0b <0f> 0b
66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
RIP  [<ffffffffa039e0e0>] btrfs_check_repairable+0x100/0x110 [btrfs]
 RSP <ffff88007878bcc8>
------------[ cut here ]------------
<more crashes until the system hangs>

So, where to from here? Sadly, I feel there is data loss in my future,
but not sure how to minimise this :\

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--NDgXbNJ8rh8XJxXPB203SbS5DoVqVotX4--

--19H8MudtVDxF85T8lL70kF6sJfPI71rGo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXbUkgAAoJEEGvNdV6fTHcniMP/1N4zPUYAZGiQ2r+uRNoJJKY
n8VXwKJIcorcbBsYwKy3zmUKsD7WHGYS6RZDsGJsOKD8NNNkBKHLB6Ive9W5DzpB
y04QOF+NMANMtyG//lvbinZV5Srs+bHiSd7EsECp7weBfVxh6sEkMYDAiOwBhPyU
rjwQcj++2AdKwAkeeHuses+JgB4R9hjYC/qUOChyb8fuIAym/lWqT4PuWIjNOHW7
lrk/EvR3b0bNxiHKYiu0uHO/Owoo90mjy69E+Awb7C3phltL1k9BtizzwP/skdtY
z+aJwxWr4p46yuuhukfnkdwPdAUiqL4lVvaXvGk4epVQOZtlmD2ZplVFeOTCiGVN
HoMhinzAXErBEBjmWkWIeQoiE89yQ7VomvJetN/TCEUauZknKXIZDc520eRQcJZx
2CBcG3RS6cFcspbu6WNOaTV4nABIXcIiu1OL3eVtSqtG1pHRX0F1/MV6Uw8AXjTq
CJe7J2TvRydNJv/pyxQHikglGns+xGg/9eR1ZJiC+/8PTsCmb10ahDZsVF7wi81v
XXm5tjvd864u/UtSZHvxNTdswI6T2pkGaOXAJZdVtmhvWFOonIUr9+fylb3fZnhg
HmLmIpgPNTxpwsx8wzTV92KvWJQiSGkxhzYEnF/dV92RK+yzCmOfKkhw+kLtslhk
GVFDWVGkp/HoeDcm0+vq
=8fEA
-----END PGP SIGNATURE-----

--19H8MudtVDxF85T8lL70kF6sJfPI71rGo--
