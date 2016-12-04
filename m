Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49273 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751894AbcLDCDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Dec 2016 21:03:52 -0500
Subject: Re: [PATCH 01/18] btrfs: call functions that overwrite their root
 parameter with fs_info
To: Omar Sandoval <osandov@osandov.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
 <1480655258-15400-2-git-send-email-jeffm@suse.com>
 <20161202223236.GA17540@vader.DHCP.thefacebook.com>
Cc: linux-btrfs@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <4e897c20-52a6-0422-0eb0-a0953470ba1b@suse.com>
Date: Sat, 3 Dec 2016 21:03:34 -0500
MIME-Version: 1.0
In-Reply-To: <20161202223236.GA17540@vader.DHCP.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B4vRG1CjxeMsNAuvOpunJo3EN7iI1F8uF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B4vRG1CjxeMsNAuvOpunJo3EN7iI1F8uF
Content-Type: multipart/mixed; boundary="E0UAiFw2s5j1XGENCdkxUfll0aQajr76M";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <4e897c20-52a6-0422-0eb0-a0953470ba1b@suse.com>
Subject: Re: [PATCH 01/18] btrfs: call functions that overwrite their root
 parameter with fs_info
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
 <1480655258-15400-2-git-send-email-jeffm@suse.com>
 <20161202223236.GA17540@vader.DHCP.thefacebook.com>
In-Reply-To: <20161202223236.GA17540@vader.DHCP.thefacebook.com>

--E0UAiFw2s5j1XGENCdkxUfll0aQajr76M
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/2/16 5:32 PM, Omar Sandoval wrote:
> On Fri, Dec 02, 2016 at 12:07:21AM -0500, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> There are 11 functions that accept a root parameter and immediately
>> overwrite it.  We can pass those an fs_info pointer instead.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/ctree.h            |  4 ++--
>>  fs/btrfs/disk-io.c          |  4 ++--
>>  fs/btrfs/extent-tree.c      | 17 +++++++-------
>>  fs/btrfs/file-item.c        |  5 ++---
>>  fs/btrfs/free-space-cache.c |  5 ++---
>>  fs/btrfs/free-space-cache.h |  2 +-
>>  fs/btrfs/transaction.c      |  9 ++++----
>>  fs/btrfs/tree-log.c         |  6 ++---
>>  fs/btrfs/volumes.c          | 55 +++++++++++++++++++++---------------=
---------
>>  fs/btrfs/volumes.h          |  4 ++--
>>  10 files changed, 52 insertions(+), 59 deletions(-)
>>
>=20
> [snip]
>=20
>>  int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
>> -		       struct btrfs_root *root, u64 chunk_offset)
>> +		       struct btrfs_fs_info *fs_info, u64 chunk_offset)
>>  {
>> +	struct btrfs_root *root =3D fs_info->chunk_root;
>>  	struct extent_map_tree *em_tree;
>>  	struct extent_map *em;
>>  	struct btrfs_root *extent_root =3D root->fs_info->extent_root;
>> @@ -2812,8 +2811,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle=
 *trans,
>>  	struct btrfs_fs_devices *fs_devices =3D root->fs_info->fs_devices;
>> =20
>>  	/* Just in case */
>> -	root =3D root->fs_info->chunk_root;
>> -	em_tree =3D &root->fs_info->mapping_tree.map_tree;
>> +	em_tree =3D &fs_info->mapping_tree.map_tree;
>=20
> I think this "Just in case" comment was referring to the reassignment o=
f
> the root, so it's just confusing now.

Agreed.  Thanks for the review.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--E0UAiFw2s5j1XGENCdkxUfll0aQajr76M--

--B4vRG1CjxeMsNAuvOpunJo3EN7iI1F8uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJYQ3l5AAoJEB57S2MheeWyZpEP/igTVte9M56C2U4vPlyNfOzV
Dk1NeX9Z0yKfQpCv31GDcpfRjyH6LDPQce0BV5q98sF3yVAMYeaJY4iC87M2s3lk
71tmp2ob+KDpOpDo4j1LrSEANFF77zffJk3pLJn1oFpzBQJMUnOl6gOa4cg/n2SI
tDeYh0kGGI1Edk9lWIvSHtdMzzlXn5KBMjAK0mk6LJuG7bgRuuQftO8ZDqXD+6Z7
vDlsumWb6kdhOVNC4Jhn5sTzSKIEtaNRd1I2oj6+5xRcc01R/WV/aoKdrunMuImd
NvrD4jt9t7r5Rgm7eYsppuCdDHWrgxLrbMHbTYOMdSS2ysEIZeEunMQk/yMx+Hij
Fp7yyG/ZpAMA8bFwy6WZumq6y3QpEQ14DRmUkThl6mO9gMLqF7jddSeXkvDBPy5Y
dAaF8URwJie0gUUHLjpdC+hIa2Gu5T7J0LbBEP/0AW11qy01REljqbE8F08G4iVc
kWraUF00FnNfU3RTOgCYmWtGptZPBuOdH1Z9zuPEjDXc8sdWP22sJ2G9bZsEEWZd
cge0pr1Xwe3THTkE9u7mYD0qHqJ9oj5RMZr9aht2MpjveDcV9fTjVYVHsAV4a1MD
0eGBAJG0Q80ipi6tgHQMhq6tU9hdwDiCMlZKlNmvZ7MzcRfN7cS9KJ8MZ5lwADuT
TwBaSXidy8E42N1Ckuhs
=Yzox
-----END PGP SIGNATURE-----

--B4vRG1CjxeMsNAuvOpunJo3EN7iI1F8uF--
