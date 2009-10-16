From: paran@lysator.liu.se (=?utf-8?Q?P=C3=A4r?= Andersson)
Subject: Re: Mass-Hardlinking Oops
Date: Sat, 17 Oct 2009 00:17:28 +0200
Message-ID: <87fx9jugp3.fsf@faran.nsc.liu.se>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>
	<87my3y3r8u.fsf@faran.nsc.liu.se>
	<3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
	<4AD2E3CF.6080701@wpkg.org> <20091012124726.GL2632@think>
	<87my3urf75.fsf@fftw.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Matteo Frigo <athena@fftw.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87my3urf75.fsf@fftw.org> (Matteo Frigo's message of "Tue, 13 Oct
	2009 20:29:02 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Matteo Frigo <athena@fftw.org> writes:

> For the record, the nnmaildir mail backend in Gnus (an Emacs package
> for reading news and email) creates multiple hardlinks to the same
> file in the same directory.  I had several thousands hardlinks at one
> time.

Gnus with nnmaildir is what I use. I wanted to test how much performance
and disk space that would be gained with my Maildirs on btrfs, but I hit
this bug instead.

> I am not saying that what Gnus does is particularly smart, but this is
> an example of a real world application that may break under btrfs.

Not smart at all, and the amount of hard links is not the only problem
with nnmaildir. But on other file systems at least it works.

Regards,
P=C3=A4r Andersson

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrY8PoACgkQyi5LJcueYEvqtgCfW8BG7ShrcNEjO5f63V2IgLZD
83oAnisDCfTBecYNzPeDpXU0v4K45ctC
=pBzM
-----END PGP SIGNATURE-----
--=-=-=--
