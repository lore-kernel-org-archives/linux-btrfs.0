Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58365 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbeH1D4y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:56:54 -0400
Subject: Re: btrfs-progs: btrfs-convert: unable to find block group for 0
To: Tucker Boniface <tucker@boniface.tech>, linux-btrfs@vger.kernel.org
References: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e92c69e8-1145-263f-dce1-f8a55dc15193@gmx.com>
Date: Tue, 28 Aug 2018 08:07:52 +0800
MIME-Version: 1.0
In-Reply-To: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iRFbkSN8nPxuGnKU8EKmU77E0F8yyf5CB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iRFbkSN8nPxuGnKU8EKmU77E0F8yyf5CB
Content-Type: multipart/mixed; boundary="9sslyxMz05Fvq0ccH59NskkcoP5O5WMp9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tucker Boniface <tucker@boniface.tech>, linux-btrfs@vger.kernel.org
Message-ID: <e92c69e8-1145-263f-dce1-f8a55dc15193@gmx.com>
Subject: Re: btrfs-progs: btrfs-convert: unable to find block group for 0
References: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>
In-Reply-To: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>

--9sslyxMz05Fvq0ccH59NskkcoP5O5WMp9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/28 =E4=B8=8A=E5=8D=886:33, Tucker Boniface wrote:
> Hello, I am trying to convert an ext4 partition to btrfs using
> btrfs-convert. I am running Arch Linux with kernel 4.18.5 and
> btrfs-progs 4.17.1. The full error is inline below.
>=20
> -> # btrfs-convert /dev/sda1
> create btrfs filesystem:
> =C2=A0=C2=A0=C2=A0=C2=A0blocksize: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0nodesize:=C2=A0 16384
> =C2=A0=C2=A0=C2=A0=C2=A0features:=C2=A0 extref, skinny-metadata (defaul=
t)
> creating ext2 image file
> Unable to find block group for 0
> Unable to find block group for 0
> Unable to find block group for 0
> extent-tree.c:2743: alloc_tree_block: BUG_ON `ret` triggered, value -28=


This means ENOSPC.
Your ext* doesn't have enough free space to contain btrfs' metadata.

Thanks,
Qu

> btrfs-convert(+0x1d512)[0x564d08cd3512]
> btrfs-convert(btrfs_alloc_free_block+0x1e8)[0x564d08cda188]
> btrfs-convert(+0x15bd1)[0x564d08ccbbd1]
> btrfs-convert(btrfs_search_slot+0xf27)[0x564d08ccd7d7]
> btrfs-convert(btrfs_csum_file_block+0x499)[0x564d08cdf219]
> btrfs-convert(+0xe625)[0x564d08cc4625]
> btrfs-convert(main+0x1abf)[0x564d08cc3adf]
> /usr/lib/libc.so.6(__libc_start_main+0xf3)[0x7f1822576223]
> btrfs-convert(_start+0x2e)[0x564d08cc41be]
> Aborted


--9sslyxMz05Fvq0ccH59NskkcoP5O5WMp9--

--iRFbkSN8nPxuGnKU8EKmU77E0F8yyf5CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluEklgACgkQwj2R86El
/qi8hwgAky1o7gWrXMjuibGlswpzJ3JaXhJRqSlbtZM0NzpCBNa1fPX+zbKalo1t
NvjwGR5q5zncwM8RuZB/JwpBmrzqK8pMQuOiycg18wKq9Gdb8/hcBaq9J/OHyZR2
99IrvBLiywKC68VLhRU8exkqhHUR7ExqrNyxgvf0HSI60o3A73phNXvStBvCSzDd
O/vZHFB3RK+cMhSvtvmjAqs5HexqzD3LFEroHCh9cJCS96k/dK3WDspx8Z1s9nGQ
9lq+PqseqgfSY3VqKmM/WRaMh2JdptmCF1oq+p7qKItRCefF4JCyhyTzARy2seYh
WOAlgKc5YDoYZq0IuACg0j1vvJKu2g==
=IAJc
-----END PGP SIGNATURE-----

--iRFbkSN8nPxuGnKU8EKmU77E0F8yyf5CB--
