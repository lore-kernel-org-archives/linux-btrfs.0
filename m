Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:39466 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaF1KN7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 06:13:59 -0400
Date: Sat, 28 Jun 2014 16:13:47 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 3+ drives
Message-ID: <20140628161347.2097d308@natsu>
In-Reply-To: <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com>
	<10572318.CAuhDIAMDU@xev>
	<pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fOD8gEmvktAyLQJysyHs9O0"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fOD8gEmvktAyLQJysyHs9O0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jun 2014 04:26:43 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Russell Coker posted on Sat, 28 Jun 2014 10:51:00 +1000 as excerpted:
>=20
> > On Fri, 27 Jun 2014 20:30:32 Zack Coffey wrote:
> >> Can I get more protection by using more than 2 drives?
> >>=20
> >> I had an onboard RAID a few years back that would let me use RAID1
> >> across up to 4 drives.
> >>=20
> > Currently the only RAID level that fully works in BTRFS is RAID-1 with
> > data on 2 disks.
>=20
> Not /quite/ correct.  Raid0 works, but of course that isn't exactly=20
> "RAID" as it's not "redundant".  And raid10 works.  But that's simply=20
> raid0 over raid1.  So depending on whether you consider raid0 actually=20
> "RAID" or not, which in turn depends on how strict you are with the=20
> "redundant" part, there is or is not more than btrfs raid1 working.

Also depending on what you consider "fully works", RAID1 may not qualify to=
o,
as neither the read-balancing, nor write-submission algorithms are ready for
production use, performance-wise.

(RAID1 writes to two disks sequentially, not at the same time; and reads are
satisfied from in effect a random device, not from the least-busy device).

--=20
With respect,
Roman

--Sig_/fOD8gEmvktAyLQJysyHs9O0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOulVsACgkQTLKSvz+PZwh3/gCaAkvqrCaZMgyoqiOVF7aRr0xj
ZA8Ani/NeUPukO98T8vHvZxnwNcFLzD6
=45JM
-----END PGP SIGNATURE-----

--Sig_/fOD8gEmvktAyLQJysyHs9O0--
