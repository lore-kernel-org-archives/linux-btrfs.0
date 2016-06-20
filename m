Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:41346 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbcFTSba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 14:31:30 -0400
Date: Mon, 20 Jun 2016 23:13:51 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160620231351.1833a341@natsu>
In-Reply-To: <20160620034427.GK15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/bJ5iP7PJqMhrBUDbnSm81X7"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/bJ5iP7PJqMhrBUDbnSm81X7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Jun 2016 23:44:27 -0400
Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:

> It's not going well so far.  Pay attention, there are at least four
> separate problems in here and we're not even half done yet.
>=20
> I'm currently using kernel 4.6.2 with btrfs fixes forward-ported from
> 4.5.7, because 4.5.7 has a number of fixes that 4.6.2 doesn't.  I have
> also pulled in some patches from the 4.7-rc series.
>=20
> This fixed a few problems I encountered early on, and I'm still making
> forward progress, but I've only replaced 50% of the failed disk so far,
> and this is week four of this particular project.

=46rom a practical standpoint, [aside from not using Btrfs RAID5], you'd be
better off shutting down the system, booting a rescue OS, copying the conte=
nt
of the failing disk to the replacement one using 'ddrescue', then removing =
the
bad disk, and after boot up your main system wouldn't notice anything has e=
ver
happened, aside from a few recoverable CRC errors in the "holes" on the are=
as
which ddrescue failed to copy.

But in general it's commendable that you're experimenting with doing things
"the native way", as this is provides feedback to the developers and could =
help
make the RAID implementation better. I guess that's the whole point of the
exercise and the report, and hope this ends up being useful for everyone.

--=20
With respect,
Roman

--Sig_/bJ5iP7PJqMhrBUDbnSm81X7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldoMmIACgkQTLKSvz+PZwjubACeNTelAet9yk15TYlajw8HCOsV
hzkAnRtFUk7jzZ4MBx1fmAJ7L6fc6vP2
=JzVI
-----END PGP SIGNATURE-----

--Sig_/bJ5iP7PJqMhrBUDbnSm81X7--
