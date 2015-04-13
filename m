Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:39422 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbbDMO2k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:28:40 -0400
Date: Mon, 13 Apr 2015 19:28:38 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Chris Mason <clm@fb.com>
Cc: stable <stable@vger.kernel.org>, Btrfs <linux-btrfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Please add 9c4f61f01d269815bb7c37be3ede59c5587747c6 to stable
Message-ID: <20150413192838.3d5a0a69@natsu>
In-Reply-To: <1427984267.10670.0@mail.thefacebook.com>
References: <1427984267.10670.0@mail.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x03WlfL7BxURB3gOhFQ3La2"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/x03WlfL7BxURB3gOhFQ3La2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Apr 2015 10:17:47 -0400
Chris Mason <clm@fb.com> wrote:

> Hi stable friends,
>=20
> Can you please backport this one to 3.19.y.  It fixes a bug introduced=20
> by:
>=20
> 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756, which was tagged for stable=20
> 3.14+
>=20
> The symptoms of the bug are deadlocks during log reply after a crash. =20
> The patch wasn't intentionally fixing the deadlock, which is why we=20
> missed it when tagging fixes.

Unfortunately still not fixed (no btrfs-related changes) in 3.14.38 and
3.18.11 released today.

>=20
> Please put this commit everywhere you've cherry-picked=20
> 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756
>=20
> commit 9c4f61f01d269815bb7c37be3ede59c5587747c6
> Author: David Sterba <dsterba@suse.cz>
> Date:   Fri Jan 2 19:12:57 2015 +0100
>=20
>     btrfs: simplify insert_orphan_item
>=20
>     We can search and add the orphan item in one go,
>     btrfs_insert_orphan_item will find out if the item already exists.
>=20
>     Signed-off-by: David Sterba <dsterba@suse.cz>
>=20
> -chris
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
With respect,
Roman

--Sig_/x03WlfL7BxURB3gOhFQ3La2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUr0pYACgkQTLKSvz+PZwgjdgCeINq3tp81y3BWNm9pQjCaTplh
sl0An1KY8OE9xMbrF9WuxBGSfnvx7AsE
=Q88L
-----END PGP SIGNATURE-----

--Sig_/x03WlfL7BxURB3gOhFQ3La2--
