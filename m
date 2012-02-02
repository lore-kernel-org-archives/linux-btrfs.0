From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: tool to visualize fragmentation
Date: Thu, 2 Feb 2012 22:38:58 +0300
Message-ID: <20120202223858.1c1f52a4@sf.home>
References: <1322496750-24281-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bMdyz=bsMc8L5VMi4goAzLc"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322496750-24281-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/bMdyz=bsMc8L5VMi4goAzLc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Nov 2011 17:12:30 +0100
Arne Jansen <sensille@gmx.net> wrote:

> This tool draws per-chunk pngs representing the allocation map. A black
> or colored dot means the block is allocated.
> The output is written to a subdirectory, together with an index.html to be
> viewed in a browser.
> There are options to control whether color should be used and which block
> group types should be printed.
> To build, you need to have libpng and libgd installed. It is not part of
> the 'all' target, so please build it explicitely with make btrfs-fragment=
s.

Real-world FS on which 400GB of 600 is filled (~600 images all taking ~1.1M=
B).

    https://slyfox.ath.cx/btrfs/2012-02-02-html-fragments/index.html

Nice tool!

--=20

  Sergei

--Sig_/bMdyz=bsMc8L5VMi4goAzLc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk8q5lMACgkQcaHudmEf86oEjACfb/Ow/zYCoYr8yGalLH/qBqAi
V3AAn1jIkhDOHZ2SsfsONjPeoBm8/7sd
=Xfh3
-----END PGP SIGNATURE-----

--Sig_/bMdyz=bsMc8L5VMi4goAzLc--
