Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab3JVOoe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 10:44:34 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B8335A585B
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 16:44:33 +0200 (CEST)
Message-ID: <52668F4E.7040503@suse.com>
Date: Tue, 22 Oct 2013 10:44:30 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: Re: [patch 02/13] kobject: export kobj_sysfs_ops
References: <20131021211940.432195222@suse.com> <20131021212006.467949781@suse.com>
In-Reply-To: <20131021212006.467949781@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="e8QLDnnxPebvSNLcUpK0EGmqNRi1h3pae"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e8QLDnnxPebvSNLcUpK0EGmqNRi1h3pae
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/21/13 5:19 PM, Jeff Mahoney wrote:
> struct kobj_attribute implements the baseline attribute functionality
> that can be used all over the place. We should export the ops associate=
d
> with it.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>=20
>  lib/kobject.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/lib/kobject.c	2013-10-21 16:09:51.868220920 -0400
> +++ b/lib/kobject.c	2013-10-21 16:10:00.216037635 -0400
> @@ -726,6 +726,7 @@ const struct sysfs_ops kobj_sysfs_ops =3D
>  	.show	=3D kobj_attr_show,
>  	.store	=3D kobj_attr_store,
>  };
> +EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
> =20
>  /**
>   * kset_register - initialize and add a kset.
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

I posted this one on LKML, CC'ing Greg, and he gave his:
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--e8QLDnnxPebvSNLcUpK0EGmqNRi1h3pae
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSZo9OAAoJEB57S2MheeWyXIYP/25qCR8t+361pD8yC5rtQ3T5
l+mzL5eUCDDObscPaAiYOpo1u3Gc1Z4Pl/LjkRQEntFnVDd2ltm+1O1XLCIT+bpq
8FqsXHyElXD++GYwwe6AGPNBTnI3g/bT+zQ6nzGMEnG34V6oS3xMlqiDJYFSbpoj
6vDQ/D/lgzWYEarHdTXJ+wcxJXtmmwpgztPQCXdBlZyEkWkAY0vkDNBCuLc1oz+W
ljhLd0BBnHzy7F0Ase8wgBUvlaVHProA3iwqq/mkJMnhhDEtBDkX0HFvaSPbrrZ7
AqZXqCK43cPyFMftb5AJ3y2aiiD7H0e/i8FscasPqG+egKUv5ctcYBBhv4ty/eis
pLjA60BkxHFip6opKt0JhmlZdCyuWhoB9nXZcY/eTtJ0Axubz7HofgaB+Z4pyj4v
O8EI+fCN3WNPePQ7huDGQkrjz0IpVVDMP3HXYV7+QXS6z/YCu+jLq5efyQwCyOJI
Opf9ab3qthXWHbnVPl7VWBPP5ITY3fihWw9KpyNr9qyCASEbyrUaN8PhQ0EtM9AQ
yYUbNPB3s3mEuxrubwWoqZf1uZYvjSAln1631Vp48KQVZDPcBy8tuvBxmg3AO8FZ
VCbA9pCTtkwtofH3wd7V0xQWxk3IAl03A9dbIhzldMm6LIGo7FxjhSQHS1pQ3h0c
90aKGHI6sy1hhu6HxWJh
=xcGD
-----END PGP SIGNATURE-----

--e8QLDnnxPebvSNLcUpK0EGmqNRi1h3pae--
