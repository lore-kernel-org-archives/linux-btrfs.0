Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:65247 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760833Ab3BIWHG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 17:07:06 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so2375128eek.25
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2013 14:07:04 -0800 (PST)
Date: Sun, 10 Feb 2013 01:06:26 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Ian Kumlien <pomac@vapor.com>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: -U_FORTIFY_SOURCE before -D
Message-ID: <20130210010626.487a8044@sf>
In-Reply-To: <20130209185720.GR15780@pomac.netswarm.net>
References: <1360366221-22703-1-git-send-email-pomac@demius.net>
	<20130209210206.66e2b886@sf>
	<20130209185720.GR15780@pomac.netswarm.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rko0VxPPz.WUjnZUdIJl2KX"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/rko0VxPPz.WUjnZUdIJl2KX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Feb 2013 19:57:20 +0100
Ian Kumlien <pomac@vapor.com> wrote:

> On Sat, Feb 09, 2013 at 09:02:06PM +0300, Sergei Trofimovich wrote:
> > On Sat,  9 Feb 2013 00:30:21 +0100
> > Ian Kumlien <pomac@demius.net> wrote:
> >=20
> > > My builds are cluttered with:
> > > <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by
> > > default]
> > >=20
> > > Which makes it hard to tell if something breaks or not.
> >=20
> > > I don't know about you, but bilding with=20
> > > GCC 4.7.2 on gentoo, this is a issue.
> >=20
> > Unfortunately it's a gentoo specific gcc bug. I'd suggest reporting
> > it to bugs.gentoo.org. That -D by default breaks linux's perf as well
> > (due to -D_FOTIFY_SOURCE=3D2 -Werror in perf sources).
>=20
> Is it? There is a workaround in the android build system for compilers
> on ubuntu.
>=20
> Where can i find that bug report?

I think you need to fill the new one.

> This is not a emerge, this is a normal system build.

Yeah, gentoo has patched gcc specs so you get -D_FORTIFY_SOURCE=3D2
in gcc command line by default.

http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/src/patchsets/gcc/4.6.0=
/gentoo/10_all_default-fortify-source.patch?view=3Dmarkup

> > Current workaround is to pass AM_CFLAGS to make:
> >     make AM_CFLAGS=3Dstuff_w/o_fortify_source
> > It's what gentoo's live ebuild does.
>=20
> I can't see it here in the live ebuild...=20

sys-fs/btrfs-progs/btrfs-progs-9999.ebuild:
...
src_compile() {
        emake \
                CC=3D"$(tc-getCC)" \
                AM_CFLAGS=3D-D_FILE_OFFSET_BITS=3D64 \
                ...
}

This line overrides in-Makefiles AM_CFLAGS.

--=20

  Sergei

--Sig_/rko0VxPPz.WUjnZUdIJl2KX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEWyGUACgkQcaHudmEf86oxqACffsf1esjPYznWUeBsrgPXBd4y
zgUAoIfg8LGotIiEVXHen3rCOM/P+1X3
=tF8H
-----END PGP SIGNATURE-----

--Sig_/rko0VxPPz.WUjnZUdIJl2KX--
