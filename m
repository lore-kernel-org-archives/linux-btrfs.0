Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:34046 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbcFXQ1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 12:27:01 -0400
Received: from [IPv6:2407:e400:b000:201:c8d9:fa83:ce8e:757d] (unknown [IPv6:2407:e400:b000:201:c8d9:fa83:ce8e:757d])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 7C2BD3A005C
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 02:26:54 +1000 (AEST)
Subject: Re: Trying to rescue my data :(
To: linux-btrfs@vger.kernel.org
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
Date: Sat, 25 Jun 2016 02:26:48 +1000
MIME-Version: 1.0
In-Reply-To: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1fDDDQP28fSJIMXMMH6eWxj4Q2TNovUAl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1fDDDQP28fSJIMXMMH6eWxj4Q2TNovUAl
Content-Type: multipart/mixed; boundary="UWBJem2qscalJRiuqGdFgdeBX3FkCEWrw"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
Subject: Re: Trying to rescue my data :(
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
In-Reply-To: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>

--UWBJem2qscalJRiuqGdFgdeBX3FkCEWrw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 25/06/16 00:52, Steven Haigh wrote:
> Ok, so I figured that despite what the BTRFS wiki seems to imply, the
> 'multi parity' support just isn't stable enough to be used. So, I'm
> trying to revert to what I had before.
>=20
> My setup consist of:
> 	* 2 x 3Tb drives +
> 	* 3 x 2Tb drives.
>=20
> I've got (had?) about 4.9Tb of data.
>=20
> My idea was to convert the existing setup using a balance to a 'single'=

> setup, delete the 3 x 2Tb drives from the BTRFS system, then create a
> new mdadm based RAID6 (5 drives degraded to 3), create a new filesystem=

> on that, then copy the data across.
>=20
> So, great - first the balance:
> $ btrfs balance start -dconvert=3Dsingle -mconvert=3Dsingle -f (yes, I =
know
> it'll reduce the metadata redundancy).
>=20
> This promptly was followed by a system crash.
>=20
> After a reboot, I can no longer mount the BTRFS in read-write:
> [  134.768908] BTRFS info (device xvdd): disk space caching is enabled
> [  134.769032] BTRFS: has skinny extents
> [  134.769856] BTRFS: failed to read the system array on xvdd
> [  134.776055] BTRFS: open_ctree failed
> [  143.900055] BTRFS info (device xvdd): allowing degraded mounts
> [  143.900152] BTRFS info (device xvdd): not using ssd allocation schem=
e
> [  143.900243] BTRFS info (device xvdd): disk space caching is enabled
> [  143.900330] BTRFS: has skinny extents
> [  143.901860] BTRFS warning (device xvdd): devid 4 uuid
> 61ccce61-9787-453e-b793-1b86f8015ee1 is missing
> [  146.539467] BTRFS: missing devices(1) exceeds the limit(0), writeabl=
e
> mount is not allowed
> [  146.552051] BTRFS: open_ctree failed
>=20
> I can mount it read only - but then I also get crashes when it seems to=

> hit a read error:
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064
> csum 3245290974 wanted 982056704 mirror 0
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 390821102 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 550556475 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 1279883714 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 2566472073 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 1876236691 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 3350537857 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 3319706190 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 2377458007 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 2066127208 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 657140479 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 1239359620 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 1598877324 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 1082738394 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 371906697 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 2156787247 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 3777709399 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 180814340 wanted 982056704 mirror 1
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent_io.c:2401!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: btrfs x86_pkg_temp_thermal coretemp crct10dif_pclmul=

> xor aesni_intel aes_x86_64 lrw gf128mul glue_helper pcspkr raid6_pq
> ablk_helper cryptd nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_table=
s
> xen_netfront crc32c_intel xen_gntalloc xen_evtchn ipv6 autofs4
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 2610978113 wanted 982056704 mirror 1
> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csum
> 59610051 wanted 982056704 mirror 1
> CPU: 1 PID: 1273 Comm: kworker/u4:4 Not tainted 4.4.13-1.el7xen.x86_64 =
#1
> Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
> task: ffff880079ce12c0 ti: ffff880078788000 task.ti: ffff880078788000
> RIP: e030:[<ffffffffa039e0e0>]  [<ffffffffa039e0e0>]
> btrfs_check_repairable+0x100/0x110 [btrfs]
> RSP: e02b:ffff88007878bcc8  EFLAGS: 00010297
> RAX: 0000000000000001 RBX: ffff880079db2080 RCX: 0000000000000003
> RDX: 0000000000000003 RSI: 000004db13730000 RDI: ffff88007889ef38
> RBP: ffff88007878bce0 R08: 000004db01c00000 R09: 000004dbc1c00000
> R10: ffff88006bb0c1b8 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff88007b213ea8 R14: 0000000000001000 R15: 0000000000000000
> FS:  00007fbf2fdc0880(0000) GS:ffff88007f500000(0000) knlGS:00000000000=
00000
> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fbf2d96702b CR3: 000000007969f000 CR4: 0000000000042660
> Stack:
>  ffffea00019db180 0000000000010000 ffff88007b213f30 ffff88007878bd88
>  ffffffffa03a0808 ffff880002d15500 ffff88007878bd18 ffff880079ce12c0
>  ffff88007b213e40 000000000000001f ffff880000000000 ffff88006bb0c048
> Call Trace:
>  [<ffffffffa03a0808>] end_bio_extent_readpage+0x428/0x560 [btrfs]
>  [<ffffffff812f40c0>] bio_endio+0x40/0x60
>  [<ffffffffa0375a6c>] end_workqueue_fn+0x3c/0x40 [btrfs]
>  [<ffffffffa03af3f1>] normal_work_helper+0xc1/0x300 [btrfs]
>  [<ffffffff810a1352>] ? finish_task_switch+0x82/0x280
>  [<ffffffffa03af702>] btrfs_endio_helper+0x12/0x20 [btrfs]
>  [<ffffffff81093844>] process_one_work+0x154/0x400
>  [<ffffffff8109438a>] worker_thread+0x11a/0x460
>  [<ffffffff8165a24f>] ? __schedule+0x2bf/0x880
>  [<ffffffff81094270>] ? rescuer_thread+0x2f0/0x2f0
>  [<ffffffff810993f9>] kthread+0xc9/0xe0
>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
>  [<ffffffff8165e14f>] ret_from_fork+0x3f/0x70
>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
> Code: 00 31 c0 eb d5 8d 48 02 eb d9 31 c0 45 89 e0 48 c7 c6 a0 f8 3f a0=

> 48 c7 c7 00 05 41 a0 e8 c9 f2 fa e0 31 c0 e9 70 ff ff ff 0f 0b <0f> 0b
> 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
> RIP  [<ffffffffa039e0e0>] btrfs_check_repairable+0x100/0x110 [btrfs]
>  RSP <ffff88007878bcc8>
> ------------[ cut here ]------------
> <more crashes until the system hangs>
>=20
> So, where to from here? Sadly, I feel there is data loss in my future,
> but not sure how to minimise this :\
>=20

The more I look at this, the more I'm wondering if this is a total
corruption scenario:

$ btrfs restore -D -l /dev/xvdc
warning, device 4 is missing
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
bytenr mismatch, want=3D11224137433088, have=3D11224137564160
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 2 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 3 is missing
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
bytenr mismatch, want=3D11224137433088, have=3D59973363410688
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 2 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 3 is missing
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
bytenr mismatch, want=3D11224137433088, have=3D59973363410688
Couldn't read chunk tree
Could not open root, trying backup super

$ btrfs restore -D -l /dev/xvdd
warning, device 4 is missing
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
bytenr mismatch, want=3D11224137433088, have=3D11224137564160
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 1 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 3 is missing
bytenr mismatch, want=3D11224137170944, have=3D0
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 1 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 3 is missing
bytenr mismatch, want=3D11224137170944, have=3D0
ERROR: cannot read chunk root
Could not open root, trying backup super

$ btrfs restore -D -l /dev/xvde
warning, device 4 is missing
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
bytenr mismatch, want=3D11224137433088, have=3D11224137564160
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 1 is missing
warning, device 2 is missing
warning, device 4 is missing
warning, device 5 is missing
checksum verify failed on 11224137170944 found C9115A93 wanted 14526E28
checksum verify failed on 11224137170944 found C9115A93 wanted 14526E28
bytenr mismatch, want=3D11224137170944, have=3D59973365311232
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 1 is missing
warning, device 2 is missing
warning, device 4 is missing
warning, device 5 is missing
checksum verify failed on 11224137170944 found C9115A93 wanted 14526E28
checksum verify failed on 11224137170944 found C9115A93 wanted 14526E28
bytenr mismatch, want=3D11224137170944, have=3D59973365311232
ERROR: cannot read chunk root
Could not open root, trying backup super

$ btrfs restore -D -l /dev/xvdf
warning, device 4 is missing
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
bytenr mismatch, want=3D11224137433088, have=3D11224137564160
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 1 is missing
warning, device 2 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 3 is missing
bytenr mismatch, want=3D11224137170944, have=3D0
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 1 is missing
warning, device 2 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 3 is missing
bytenr mismatch, want=3D11224137170944, have=3D0
ERROR: cannot read chunk root
Could not open root, trying backup super

$ btrfs restore -D -l /dev/xvdg
warning, device 4 is missing
checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE2322
bytenr mismatch, want=3D11224137433088, have=3D11224137564160
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 1 is missing
warning, device 2 is missing
warning, device 4 is missing
warning, device 3 is missing
bytenr mismatch, want=3D11224137170944, have=3D11224137105408
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 1 is missing
warning, device 2 is missing
warning, device 4 is missing
warning, device 3 is missing
bytenr mismatch, want=3D11224137170944, have=3D11224137105408
ERROR: cannot read chunk root
Could not open root, trying backup super

If I mount it read only:
$ mount -o nossd,degraded,ro /dev/xvdc /mnt/fileshare/

$ btrfs device usage /mnt/fileshare/

/dev/xvdc, ID: 1
   Device size:             2.73TiB
   Device slack:              0.00B
   Data,single:             5.00GiB
   Data,RAID6:              1.60TiB
   Data,RAID6:              2.75GiB
   Data,RAID6:              1.00GiB
   Metadata,RAID6:          2.06GiB
   System,RAID6:           32.00MiB
   Unallocated:             1.12TiB

/dev/xvdd, ID: 2
   Device size:             2.73TiB
   Device slack:              0.00B
   Data,single:             1.00GiB
   Data,RAID6:              1.60TiB
   Data,RAID6:              7.07GiB
   Data,RAID6:              1.00GiB
   Metadata,RAID6:          2.06GiB
   System,RAID6:           32.00MiB
   Unallocated:             1.12TiB

/dev/xvde, ID: 3
   Device size:             1.82TiB
   Device slack:              0.00B
   Data,RAID6:              1.60TiB
   Data,RAID6:              7.07GiB
   Metadata,RAID6:          2.06GiB
   System,RAID6:           32.00MiB
   Unallocated:           213.23GiB

/dev/xvdf, ID: 6
   Device size:             1.82TiB
   Device slack:              0.00B
   Data,RAID6:            882.62GiB
   Data,RAID6:              1.00GiB
   Metadata,RAID6:          2.06GiB
   Unallocated:           977.33GiB

/dev/xvdg, ID: 5
   Device size:             1.82TiB
   Device slack:              0.00B
   Data,RAID6:              1.60TiB
   Data,RAID6:              7.07GiB
   Metadata,RAID6:          2.06GiB
   System,RAID6:           32.00MiB
   Unallocated:           213.23GiB

missing, ID: 4
   Device size:               0.00B
   Device slack:           16.00EiB
   Data,RAID6:            758.00GiB
   Data,RAID6:              4.31GiB
   System,RAID6:           32.00MiB
   Unallocated:             1.07TiB

Hoping this isn't a total loss ;)

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--UWBJem2qscalJRiuqGdFgdeBX3FkCEWrw--

--1fDDDQP28fSJIMXMMH6eWxj4Q2TNovUAl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXbV9MAAoJEEGvNdV6fTHcpboP/2TDR2Zvq4o7OutQMvJSYIqq
g6h9rgpXmttFzTVomb15Iu3HOVT81pPvhB9RyEyOZB5PKAEh+d/0Bxu908rs7tFq
y5dI4vDv0QGxOkKk0wL3JKWZ3rnn45cLDCuEk9hsLEWTWngeQwVRdVypNdT7+7Z1
aVKXxduRaMKJk3Y6pg6WpFCXlQL+sQ32T08thqacnDpq4QXalUk26vLhVDEbgQDs
HnA+GbsZXlV7GPZkzxQ3drACACym8mBOUwLtkd5XOOaFEk1ktQgkcie9RXcg9h5+
RjilbePcEkerZ2U1F0Xl4OWFnMzpXuHbI3Jndd+7Y9nP6uY4jYthYj9Fg0tHNGgK
yh5KWk3/qYqUFwBSV9yPiyA1HM5Ajj80fqRg5b8iJa1Hwzel8z9qD+Rk/cTf4tsW
mFEWGkd+t0WhKm0NXemRL/swdVir38i+flf4PMcAOPBZDnEISU7d722ApEfMxWcL
zjJE9+btFtkvd3XTutpeNreBswk+YaafiFWRidFatrSjeRMy/Oa7ufB4EPsUSogp
R+uMpZ3wjBoxMGzxwXLQqGhJO3bEWbj+zBdogRWl4NqjGH+xjESGtNeoox3BRxbM
WsC66u9dbjNO+hTM2f/F7F0NFURsfrbh0iyQhRCevA0B2gcamh+6Sex6g6wXp1be
swdB+lJeOXZnrI9FGmuO
=+RSM
-----END PGP SIGNATURE-----

--1fDDDQP28fSJIMXMMH6eWxj4Q2TNovUAl--
