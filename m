Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54552 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751696AbeAZFcw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 00:32:52 -0500
Subject: Re: [PATCH 6/6] btrfs-progs: remove no longer be used
 btrfs_alloc_extent
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-6-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a8cd0b6e-bb91-1fa0-d8eb-707e395c46e3@gmx.com>
Date: Fri, 26 Jan 2018 13:32:45 +0800
MIME-Version: 1.0
In-Reply-To: <1516936926-18707-6-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IxGgEKTn3uVIvDmxawRUX7SLizUIv8hOD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IxGgEKTn3uVIvDmxawRUX7SLizUIv8hOD
Content-Type: multipart/mixed; boundary="uvb5EkslHwHQR6i6nOQkUZF8krGkZ7DS7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <a8cd0b6e-bb91-1fa0-d8eb-707e395c46e3@gmx.com>
Subject: Re: [PATCH 6/6] btrfs-progs: remove no longer be used
 btrfs_alloc_extent
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-6-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-6-git-send-email-gujx@cn.fujitsu.com>

--uvb5EkslHwHQR6i6nOQkUZF8krGkZ7DS7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 11:22, Gu Jinxiang wrote:
> Do a cleanup.
> Function btrfs_alloc_extent is no longer be used.
> So let's remove it.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  ctree.h | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/ctree.h b/ctree.h
> index c82e7547..34d2505e 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -2487,12 +2487,6 @@ struct extent_buffer *btrfs_alloc_free_block(str=
uct btrfs_trans_handle *trans,
>  					u32 blocksize, u64 root_objectid,
>  					struct btrfs_disk_key *key, int level,
>  					u64 hint, u64 empty_size);
> -int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
> -		       struct btrfs_root *root,
> -		       u64 num_bytes, u64 parent,
> -		       u64 root_objectid, u64 ref_generation,
> -		       u64 owner, u64 empty_size, u64 hint_byte,
> -		       u64 search_end, struct btrfs_key *ins, int data);
>  int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root, u64 bytenr,
>  			     u64 offset, int metadata, u64 *refs, u64 *flags);
>=20


--uvb5EkslHwHQR6i6nOQkUZF8krGkZ7DS7--

--IxGgEKTn3uVIvDmxawRUX7SLizUIv8hOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpqvX0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgm+gf9GEh++Dta0DMWug1BApmaNufQ
Q4KB7847GlN/qpk0RI8iFtUc84tRCY8FOQhm22b6YbyNThAPrMQX4JOAdnzM2Lhp
syz9FKecwpXBDqPusVb8RPnIB7bwWN+FIBTaQ36vxkyRdwXovSWgB9qPqqX0FmsW
ItYiAmpCgF+pPrwiibzSQRLh4NqpalxBCxO93AhAKwV2wyelETRkpif3HBt3/rlA
31JJ6+TvNllL7nLctl7g9wMEi1Q0j5ni3AWjd3H3n9h8/HlSkEOo3fViaXpP8CY8
EknQAQHmKq8IMglWXcqXPed3QMtBpRAq59hVLMjLMRzIC2pNK0du3BH8+r0F6g==
=45F2
-----END PGP SIGNATURE-----

--IxGgEKTn3uVIvDmxawRUX7SLizUIv8hOD--
