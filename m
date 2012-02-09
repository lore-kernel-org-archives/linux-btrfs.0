From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Freeing space over reboot question
Date: Fri, 10 Feb 2012 00:20:55 +0600
Message-ID: <20120210002055.6819f76c@natsu>
References: <20120209174232.318280@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o+c_RXYRgc2Bb=7X_manpbR"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: "Norbert Scheibner" <scno@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120209174232.318280@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/o+c_RXYRgc2Bb=7X_manpbR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Feb 2012 18:42:32 +0100
"Norbert Scheibner" <scno@gmx.net> wrote:

> So the used space of subvolume I deleted, was not freed.

AFAIK the only reliable way currently to ensure the space after a subvolume
deletion is freed, is to remount the FS.=20

In my opinion this is very inconvenient in many aspects, and I think "btrfs=
 fi
sync" absolutely should sync all ongoing cleanerd operations too. Which it
currently doesn't, and in fact this makes me wonder, does "btrfs fi sync"
even do anything more than the standard "sync" program at all.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/o+c_RXYRgc2Bb=7X_manpbR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk80DocACgkQTLKSvz+PZwgzXwCeJ0MiX82UEom5Lm+x/Uk5OveL
3KUAoJVCv+Os7LH75GoKNAPPnm/J/VXX
=gIyQ
-----END PGP SIGNATURE-----

--Sig_/o+c_RXYRgc2Bb=7X_manpbR--
