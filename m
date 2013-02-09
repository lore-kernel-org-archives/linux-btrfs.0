Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:35234 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab3BITte (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 14:49:34 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so2047016eaa.7
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2013 11:49:33 -0800 (PST)
Date: Sat, 9 Feb 2013 22:48:51 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Ian Kumlien <pomac@vapor.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add static compile target
Message-ID: <20130209224851.4560edf9@sf>
In-Reply-To: <20130209185144.GQ15780@pomac.netswarm.net>
References: <1360365569-18996-1-git-send-email-pomac@demius.net>
	<20130209205742.00907573@sf>
	<20130209185144.GQ15780@pomac.netswarm.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//1syMzyzFvRJlio3NJfIrfL"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//1syMzyzFvRJlio3NJfIrfL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Feb 2013 19:51:44 +0100
Ian Kumlien <pomac@vapor.com> wrote:

> On Sat, Feb 09, 2013 at 08:57:42PM +0300, Sergei Trofimovich wrote:
> > On Sat,  9 Feb 2013 00:19:29 +0100
> > Ian Kumlien <pomac@demius.net> wrote:
> >=20
> > > Sometimes, when you least expect it, a static binary is what you need=
 to
> > > rescue your data... Or just get a good enough handle on things to make
> > > it work again ;)
> > >=20
> > > "make static" is a gift to you, dear user with filesystem problems!
> >=20
> > What's wrong with conventional LDFLAGS=3D-static make?
>=20
> That doesn't work for me, does it actually work for you?
>=20
> I'd say it wouldn't without adding LDFLAGS so that the compiler gets it
> for all object compilations.

-static is link-only flag.
Mostly yes, it works.
    LDFLAGS=3D"-static -pthread" make

make all binaries static.

It needs
 sys-apps/util-linux
 sys-libs/e2fsprogs-libs
 sys-fs/e2fsprogs
 sys-libs/zlib
to be built with USE=3Dstatic-libs .

    $ ldd btrfs
        not a dynamic executable
    $ ldd mkfs.btrfs=20
        not a dynamic executable

None of built binaries is dynamic.

--=20

  Sergei

--Sig_//1syMzyzFvRJlio3NJfIrfL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEWqCMACgkQcaHudmEf86oMggCeKC7vIxs3yp5mi0TnTb75Jd5S
+GUAnRc/m/7LkHPXv9Y8kpb6EF3IP/i+
=81uY
-----END PGP SIGNATURE-----

--Sig_//1syMzyzFvRJlio3NJfIrfL--
