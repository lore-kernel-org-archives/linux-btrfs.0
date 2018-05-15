Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:36397 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752031AbeEOB3n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 21:29:43 -0400
Subject: Re: verify key failure
To: bo.liu@linux.alibaba.com
Cc: linux-btrfs@vger.kernel.org
References: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <38fa12a6-79bf-51f7-2d27-97429f5b3fa2@gmx.com>
Date: Tue, 15 May 2018 09:29:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2Ba18Mxyw3boEVnpBapCGs7E1XEhRqVOo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Ba18Mxyw3boEVnpBapCGs7E1XEhRqVOo
Content-Type: multipart/mixed; boundary="F4bZqXIkV5rHz2CTJmbZuExxw3aZ5peLM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: bo.liu@linux.alibaba.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <38fa12a6-79bf-51f7-2d27-97429f5b3fa2@gmx.com>
Subject: Re: verify key failure
References: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local>
In-Reply-To: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local>

--F4bZqXIkV5rHz2CTJmbZuExxw3aZ5peLM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8814=E6=97=A5 22:35, Liu Bo wrote:
> Hi,
>=20
> I got another warning of verify_level_key by running btrfs/124 in a loo=
p, I'm testing against 4.17-rc3.
>=20
> Not sure if it's false positive.
>=20
> [101414.336691] WARNING: CPU: 3 PID: 30194 at fs/btrfs/disk-io.c:455 bt=
ree_read_extent_buffer_pages+0x183/0x220 [btrfs]
> [101414.340372] Modules linked in: btrfs(O) xor zstd_decompress zstd_co=
mpress xxhash zlib_inflate lzo_compress lzo_decompress zlib_deflate raid6=
_pq dm_flakey [last unloaded: xor]
> [101414.345713] CPU: 3 PID: 30194 Comm: btrfs Tainted: G        W  O   =
   4.17.0-rc3-liubo+ #35
> [101414.348501] RIP: 0010:btree_read_extent_buffer_pages+0x183/0x220 [b=
trfs]
> ...
> [101414.369713] Call Trace:
> [101414.370477]  read_tree_block+0x3d/0x60 [btrfs]
> [101414.371946]  read_block_for_search.isra.11+0x19c/0x350 [btrfs]
> [101414.373915]  btrfs_search_slot+0x4a0/0xa60 [btrfs]
> [101414.375489]  ? trace_hardirqs_on_caller+0x12/0x1c0
> [101414.377080]  ? btrfs_lookup_ordered_extent+0x8b/0xd0 [btrfs]
> [101414.379007]  btrfs_lookup_csum+0x42/0x130 [btrfs]
> [101414.380456]  __btrfs_lookup_bio_sums+0x2fb/0x6a0 [btrfs]
> [101414.381554]  btrfs_submit_bio_hook+0xbb/0x180 [btrfs]
> [101414.382598]  submit_one_bio+0x57/0x80 [btrfs]
> [101414.383509]  submit_extent_page+0xd5/0x1f0 [btrfs]
> [101414.384507]  __do_readpage+0x2a6/0x770 [btrfs]
> [101414.385449]  ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
> [101414.386576]  ? btrfs_direct_IO+0x3a0/0x3a0 [btrfs]
> [101414.387569]  ? btrfs_direct_IO+0x3a0/0x3a0 [btrfs]
> [101414.388562]  __extent_readpages+0x2e2/0x330 [btrfs]
> [101414.389584]  extent_readpages+0x10e/0x1a0 [btrfs]
> [101414.390565]  __do_page_cache_readahead+0x283/0x340
> [101414.391550]  ? ondemand_readahead+0x207/0x460
> [101414.392451]  ondemand_readahead+0x207/0x460
> [101414.393353]  relocate_file_extent_cluster+0x364/0x4c0 [btrfs]
> [101414.394546]  relocate_block_group+0x5d4/0x6e0 [btrfs]
> ...
> [101414.432616] BTRFS error (device sdb): tree first key mismatch detec=
ted, bytenr=3D30523392 key expected=3D(18446744073709551606, 128, 1120665=
600) has=3D(1, 204, 22020096)

The expected key is completely fine, while the found one obviously
belongs to extent tree.

Maybe that's the bug which I'm always chasing.

Can you reproduce it again with btrfs_print_tree() added to provide more
info?

Thanks,
Qu

>=20
> thanks,
> -liubo
>=20


--F4bZqXIkV5rHz2CTJmbZuExxw3aZ5peLM--

--2Ba18Mxyw3boEVnpBapCGs7E1XEhRqVOo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr6N/4ACgkQwj2R86El
/qh37Af9GXdLCLPQSj1izrOHYeO0fAwLtb8ISb/OgudH4zI2fdiVbkOKQacRB7mU
Lb/9tozXiSEWx+LKnCuGlMjxdGyLUM3bKttIwRkyIjU1rXLl4eIbALpyQx7r/7b0
74nCQW6/E4UYFjO1SzWow0fZeBRsx5ecDju8A7q/VRsd5wlczBSnDSByneH7JgnP
tXMkpQVX+eO7IslZCOdJAJaWvA3608P8COjCOhxn2D6KpHBGQcIhnVIylF66+PoP
AF1oQZoonPIwejwFRqqJteqSq0QcOCU+CKdDulu0n+I2QvB95flRfER9YOO2lzov
TphZgAfwmyshwmj3KBVOeXksXNtxfw==
=dVWu
-----END PGP SIGNATURE-----

--2Ba18Mxyw3boEVnpBapCGs7E1XEhRqVOo--
