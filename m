Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33501 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753989AbcIZUO7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 16:14:59 -0400
Received: by mail-it0-f68.google.com with SMTP id x192so5500629itb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 13:14:58 -0700 (PDT)
Date: Mon, 26 Sep 2016 16:14:50 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix user-facing typos (affects 4.7.3 and
 devel)
Message-ID: <20160926201450.GA29587@DigitalMercury.dynalias.net>
References: <20160925012641.24339-1-nsteeves@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
In-Reply-To: <20160925012641.24339-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 24, 2016 at 09:26:40PM -0400, Nicholas D Steeves wrote:
> Hi,
>=20
> I found these with lintian (analysis tool for Debian packages) this
> evening, and hope this patch is well received :-)  The only bit I'm
> unsure about is the deletion of what looks like extra whitespace on
> the last changed line of the patch.
>=20
> Cheers,
> Nicholas
>=20
> Nicholas D Steeves (1):
>   Fix user-facing typos
>=20
>  Documentation/btrfs-check.asciidoc  | 2 +-
>  Documentation/btrfs-device.asciidoc | 2 +-
>  Documentation/btrfs-man5.asciidoc   | 2 +-
>  Documentation/btrfs-scrub.asciidoc  | 2 +-
>  Documentation/btrfstune.asciidoc    | 2 +-
>  btrfs-convert.c                     | 2 +-
>  cmds-check.c                        | 6 +++---
>  7 files changed, 9 insertions(+), 9 deletions(-)
>=20
> --=20
> 2.9.3
>=20

P.S. The typos were found in btrfs-progs-v4.7.3, and this patch is
against David Sterba's github copy of the devel branch.

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJX6YG6AAoJEFqIMEdffRBhULcQAIiqxU56dEVRTM4mLfNeF12x
ljXJ0Tv16lfXHe5u7yI4Y8LyQ/TERcQVndCoLCwXRvRW3y11nz7ipnCs9O2szLs3
I5xGvT7kcNytxDAdytGUddF3el2PfxM1TzpRcwFUw2sfCLUC8tEVygg1/NgAVOIk
XxVujY/sZLOM1fJwiPKBSrk9XDMe20B7MzCuIw+TN4htWJY/c6d9fvUxLrhehhIC
YeD0v6Y4Dw4LtECyD/fgAucVFq2x2A4drI/QUEgzOuctWyO6EKuKMWGQZ9mjHqTQ
fYGDemiHaa/FBt72ScKmgZOvYwLtm9iSPkXS1sUVXRbSh+0ijuMiIDL3ScPA2o03
OdZF90r/EGj1dKEnk2cQA0ZimiBTbpJylP7V5TzeLF9899T2WjoIzv4vzlkqYoH9
AhS+FFqJWFBVAtNYqOTH/wEXjmWbFo+Np2e74CARhigo+AdQaHBIldsThStDXkoc
K1O+7OLdAmXansB89QnjwivCRcAVMdEawYtzCmueOb0GUms+o/OtSxyZV7mxqvvv
mo9zBSwEVIAs2yPP9c7Bz5zIhhARjh4+StEE3Uc8xF++YDNdF25BmdwejBk/KlUr
wn/sQp3CkSBXvXgFqhkerTfwWGvHIKLxfH0oETNAZsWqwaAJPACszjWEpbMLlr4A
u5GkK0e6aZBSXIF8z32I
=AyUi
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
