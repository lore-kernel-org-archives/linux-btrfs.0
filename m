Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752389AbcISSuO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 14:50:14 -0400
Subject: Re: [PATCH] Btrfs: handle quota reserve failure properly
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <1473965868-9675-1-git-send-email-jbacik@fb.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <d4cc1bae-bbfa-e29c-9eeb-75f7cc1876fe@suse.com>
Date: Mon, 19 Sep 2016 14:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <1473965868-9675-1-git-send-email-jbacik@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1cLesAExpkRd7NoXuCbFWNkGdCQCRTUDi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1cLesAExpkRd7NoXuCbFWNkGdCQCRTUDi
Content-Type: multipart/mixed; boundary="PaobVTE1b8pqmupMTN1aUAT9IgoPSVr6R";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Message-ID: <d4cc1bae-bbfa-e29c-9eeb-75f7cc1876fe@suse.com>
Subject: Re: [PATCH] Btrfs: handle quota reserve failure properly
References: <1473965868-9675-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1473965868-9675-1-git-send-email-jbacik@fb.com>

--PaobVTE1b8pqmupMTN1aUAT9IgoPSVr6R
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/15/16 2:57 PM, Josef Bacik wrote:
> btrfs/022 was spitting a warning for the case that we exceed the quota.=
  If we
> fail to make our quota reservation we need to clean up our data space
> reservation.  Thanks,
>=20
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 03da2f6..d72eaae 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4286,13 +4286,10 @@ int btrfs_check_data_free_space(struct inode *i=
node, u64 start, u64 len)
>  	if (ret < 0)
>  		return ret;
> =20
> -	/*
> -	 * Use new btrfs_qgroup_reserve_data to reserve precious data space
> -	 *
> -	 * TODO: Find a good method to avoid reserve data space for NOCOW
> -	 * range, but don't impact performance on quota disable case.
> -	 */
> +	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. =
*/
>  	ret =3D btrfs_qgroup_reserve_data(inode, start, len);
> +	if (ret)
> +		btrfs_free_reserved_data_space_noquota(inode, start, len);
>  	return ret;
>  }
> =20
>=20

Tested-by: Jeff Mahoney <jeffm@suse.com>

btrfs/022 passes now.

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--PaobVTE1b8pqmupMTN1aUAT9IgoPSVr6R--

--1cLesAExpkRd7NoXuCbFWNkGdCQCRTUDi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX4DNhAAoJEB57S2MheeWynDMP/12ZWO8JBui0xPorrEe8tZgw
NekREqFHtEw+cj2MC38v8vXqk18KV4zqHQl8oT9KXxcpjd7jYxz7VjYDEg4Poi5p
dFHnMYU2LIibTXgKCAf7NeDr859z1XpIWR6kdjnzgM6Or5ZPf7Nwp2znymoNio5/
nNAbxfee0+LV8EQ2L5tIjmtbjQ6ZZ2hpo9BDMZiZxr9YcqunxDzKNtTfHa2+1ojd
FGJx2aa9aFDpc4RGXeUQb6jGQIx/VUrTyw58bnz/Yeh/DihOO2Bnig7HQqAsICVk
wn4zpvdOvkS9t6WzmU1emRRzAmFSHj4N2cuC7+Qgs2QksyccQwJbNvXirbkkzTrf
3HquACrjFBuViCF4nA3zhxS6Ayy7kY+2bwxYzvXKoCnPRR5GvwwOpihq+xNIMmzT
gGXYCguFRsPOVJrdKGOI9aUxGpvaq04Slnw0d0/tVL4yul8d9ua22ec0oZ3ljr1R
fDtJYfaSZAGUfUN1l/64o8wQ8uIyk+bs0NonbrLZSO6De5betrUwdL4dxKCsg+l7
HR/F0W79SFxrIcLODpJOA5Y68c+P6BEQp3/QpjXI2F+EK0EjSjGsx+yvfsngnb7v
a8vq/q6CaakCtKeUbg/G5T41iFyT0j5tQrxQ4draDu7l3rECOD1vLPI/GfRvVKVb
3MSWxJV1wvFUG3fCG4hE
=tmk/
-----END PGP SIGNATURE-----

--1cLesAExpkRd7NoXuCbFWNkGdCQCRTUDi--
