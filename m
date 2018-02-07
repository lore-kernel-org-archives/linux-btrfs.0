Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62853 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753147AbeBGJYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 04:24:04 -0500
Subject: Re: [PATCH] btrfs: Don't hardcode the csum size in
 btrfs_ordered_sum_size
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1517995150-28081-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cd9452f1-3218-6ac7-3d79-57398f7eff2f@gmx.com>
Date: Wed, 7 Feb 2018 17:23:52 +0800
MIME-Version: 1.0
In-Reply-To: <1517995150-28081-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sUdP7bLci121BeJGpa3ovwsK1wpz9nLAf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sUdP7bLci121BeJGpa3ovwsK1wpz9nLAf
Content-Type: multipart/mixed; boundary="Qhu2Tk9xQDgbkkY6DohRlTuSFDeEDnckB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <cd9452f1-3218-6ac7-3d79-57398f7eff2f@gmx.com>
Subject: Re: [PATCH] btrfs: Don't hardcode the csum size in
 btrfs_ordered_sum_size
References: <1517995150-28081-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1517995150-28081-1-git-send-email-nborisov@suse.com>

--Qhu2Tk9xQDgbkkY6DohRlTuSFDeEDnckB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8807=E6=97=A5 17:19, Nikolay Borisov wrote:
> Currently the function uses a hardcoded value for the checksum size of
> a sector. This is fine, given that we currently support only a single
> algorithm, whose checksum is 4 bytes =3D=3D sizeof(u32). Despite not
> having other algorithms, btrfs' design supports using a different
> algorithm whith different space requirements. To future-proof the code
> query the size of the currently used algorithm from the in-memory copy
> of the super block. No functional changes.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ordered-data.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 56c4c0ee6381..c53e2cfb72d9 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -151,7 +151,9 @@ static inline int btrfs_ordered_sum_size(struct btr=
fs_fs_info *fs_info,
>  					 unsigned long bytes)
>  {
>  	int num_sectors =3D (int)DIV_ROUND_UP(bytes, fs_info->sectorsize);
> -	return sizeof(struct btrfs_ordered_sum) + num_sectors * sizeof(u32);
> +	int csum_size =3D btrfs_super_csum_size(fs_info->super_copy);
> +
> +	return sizeof(struct btrfs_ordered_sum) + num_sectors * csum_size;
>  }
> =20
>  static inline void
>=20


--Qhu2Tk9xQDgbkkY6DohRlTuSFDeEDnckB--

--sUdP7bLci121BeJGpa3ovwsK1wpz9nLAf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp6xagXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiaeggApJcSCNIVDrrq33/nIFlO7G1e
VOFMbgGFEAFBp2Mm7WfyCnx/+oI1X5JQgpzJBKacibPMILKa8m6zxh79V0xN3Kpo
d6WJFirxPLdAc7MhIJkB4FR2FNyj3+LQMwqjk6iHL2JHhick9/kwooYBUKCFKgbf
cqiS79VZLsJCRR10JiXuZ3Y+4OPK5OEIja9SgsaRxyXaK+wHVGLSNfFY2sdywb55
Grj36EoPKTA5yNq0o073qjHX46WK2jg0AWfZN1UWtC/rDpyt8dVlg70EDzbVmfMW
YlIO3Y3U3ASXNLahtRi95na1GBzlvXBwvqG/yIDFks6mmofZ1/eMqAUYx/8mWw==
=GnqW
-----END PGP SIGNATURE-----

--sUdP7bLci121BeJGpa3ovwsK1wpz9nLAf--
