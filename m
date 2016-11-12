Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34458 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbcKLWOw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Nov 2016 17:14:52 -0500
Received: by mail-wm0-f68.google.com with SMTP id g23so5395001wme.1
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Nov 2016 14:14:52 -0800 (PST)
Date: Sat, 12 Nov 2016 22:14:49 +0000
From: Sergei Trofimovich <slyich@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] ioctl.h: add missing kernel compatibility header for
 BUILD_ASSERT
Message-ID: <20161112221449.0cd3d16b@sf>
In-Reply-To: <20161024125205.GB11398@twin.jikos.cz>
References: <20161024082912.20253-1-slyich@gmail.com>
        <20161024125205.GB11398@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8qbanWxHQC3l6gmx/44yng="; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/8qbanWxHQC3l6gmx/44yng=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Oct 2016 14:52:05 +0200
David Sterba <dsterba@suse.cz> wrote:

> Hi,
>=20
> On Mon, Oct 24, 2016 at 09:29:12AM +0100, slyich@gmail.com wrote:
> > From: Sergei Trofimovich <slyfox@gentoo.org>
> >=20
> > Header breakage noticed by cynede. Reproducible as:
> >=20
> >     $ gcc -c /usr/include/btrfs/ioctl.h -o /tmp/a.o
> >         /usr/include/btrfs/ioctl.h:42:14: error: expected declaration s=
pecifiers or '...' before 'sizeof'
> >      BUILD_ASSERT(sizeof(struct btrfs_ioctl_vol_args) =3D=3D 4096);
> >                   ^~~~~~
> >=20
> > Basically gcc tries to say us BUILD_ASSERT is not visible.
> >=20
> > BUILD_ASSERT lives in kerncompat.h which this change adds. =20
>=20
> I think including the kerncompat.h is too intrusive here, I've fixed by
> providing an empty macro if it's not defined. I'll release 4.8.2 soon.

Apologies. I did not test your fix right afterwards. Seems now header is in=
complete
due to missing NULL (gcc-6):

btrfs-progs-v4.8.3 $ gcc -c ioctl.h -o /tmp/a.o
ioctl.h: In function 'btrfs_err_str':
ioctl.h:711:11: error: 'NULL' undeclared (first use in this function)
    return NULL;
           ^~~~
ioctl.h:711:11: note: each undeclared identifier is reported only once for =
each function it appears in

--=20

  Sergei

--Sig_/8qbanWxHQC3l6gmx/44yng=
Content-Type: application/pgp-signature
Content-Description: Ци��ова� подпи�� OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlgnlFkACgkQcaHudmEf86o4jACgh+BFPSjH1NW8zz09jQwidb6g
XXAAoIHJWxvuoj9QM+QrcS1dX859o+8Z
=KWpx
-----END PGP SIGNATURE-----

--Sig_/8qbanWxHQC3l6gmx/44yng=--
