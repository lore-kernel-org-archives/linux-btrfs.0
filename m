Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53459 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564Ab3BISCo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 13:02:44 -0500
Received: by mail-ee0-f50.google.com with SMTP id e51so2552637eek.23
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2013 10:02:41 -0800 (PST)
Date: Sat, 9 Feb 2013 21:02:06 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: -U_FORTIFY_SOURCE before -D
Message-ID: <20130209210206.66e2b886@sf>
In-Reply-To: <1360366221-22703-1-git-send-email-pomac@demius.net>
References: <1360366221-22703-1-git-send-email-pomac@demius.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Cvk03Yahv90xPYA3lhPS_6X"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Cvk03Yahv90xPYA3lhPS_6X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  9 Feb 2013 00:30:21 +0100
Ian Kumlien <pomac@demius.net> wrote:

> My builds are cluttered with:
> <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by
> default]
>=20
> Which makes it hard to tell if something breaks or not.

> I don't know about you, but bilding with=20
> GCC 4.7.2 on gentoo, this is a issue.

Unfortunately it's a gentoo specific gcc bug. I'd suggest reporting
it to bugs.gentoo.org. That -D by default breaks linux's perf as well
(due to -D_FOTIFY_SOURCE=3D2 -Werror in perf sources).

Current workaround is to pass AM_CFLAGS to make:
    make AM_CFLAGS=3Dstuff_w/o_fortify_source
It's what gentoo's live ebuild does.

--=20

  Sergei

--Sig_/Cvk03Yahv90xPYA3lhPS_6X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEWjx4ACgkQcaHudmEf86oZRQCeMSEOSA+Xp5McvmeiIs+j9YIQ
vogAn3TPIYyJ088mOwTKcwsTNNJLxh1a
=Sgvo
-----END PGP SIGNATURE-----

--Sig_/Cvk03Yahv90xPYA3lhPS_6X--
