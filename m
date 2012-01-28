From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Setting options permanently?
Date: Sat, 28 Jan 2012 14:23:44 +0600
Message-ID: <20120128142344.6f18c989@natsu>
References: <4F22BCCC.5090800@danisch.de>
	<CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
	<4F234616.6020407@danisch.de>
	<pan.2012.01.28.03.32.23@cox.net>
	<CAJboL97CGufkN=QEtr=ysU83nrq+UuUoEFuL+wJu85Hx+xBEuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LmWNF3W+U9D+rElP+1qP.q4"; protocol="application/pgp-signature"
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
To: Ben Klein <shacklein@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJboL97CGufkN=QEtr=ysU83nrq+UuUoEFuL+wJu85Hx+xBEuA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LmWNF3W+U9D+rElP+1qP.q4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jan 2012 17:05:41 +1100
Ben Klein <shacklein@gmail.com> wrote:

> If the compression routine changes in a later kernel/filesystem revision,

There are already two different algorithms, zlib and lzo, and a third one -
snappy - planned for inclusion.

> then you could end up with some files using one routine and others using =
another.

Which is absolutely not a problem even right now.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/LmWNF3W+U9D+rElP+1qP.q4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8jsJAACgkQTLKSvz+PZwiocwCeN0sJxu7+Fx4S/TNDq69mEnWk
c1cAoIl1Z1B9GBVd/woqPKQ2VKjy4LeP
=ZSTH
-----END PGP SIGNATURE-----

--Sig_/LmWNF3W+U9D+rElP+1qP.q4--
