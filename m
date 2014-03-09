Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57041 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaCILdw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 07:33:52 -0400
Date: Sun, 9 Mar 2014 11:33:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Massive BTRFS performance degradation
Message-ID: <20140309113350.GH6318@carfax.org.uk>
References: <531C1CC4.701@gmail.com>
 <1553599.dDs6U900Vh@tethys>
 <3438733.p6vCjojJlH@merkaba>
 <1756989.4ep0Vdupld@tethys>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
In-Reply-To: <1756989.4ep0Vdupld@tethys>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 09, 2014 at 11:23:29AM +0100, Sw=E2mi Petaramesh wrote:
> Le dimanche 9 mars 2014 11:01:17 vous avez =E9crit :
> > This ThinkPad T520 has been with BTRFS since installation of the Debian
> > sid system on it with Kernel 2.6.39 or even 2.6.38 (where Sandybridge
> > graphics didn=B4t work so well as today yet).
> >
> > So that much to any FUD about BTRFS and SSDs.
>=20
> Wow !
>=20
> Thanks for this very interesting info. Would you tell me if you use any o=
f the=20
> SSD optimisation mount options: discard, ssd or ssd_spread ?

   I would recommend none of the three. :)

   ssd should be activated automatically on any non-rotational device.
ssd_spread is generally slower on modern SSDs than the ssd option.
discard is, except on the very latest hardware, a synchronous command
(it's a limitation of the SATA standard), and therefore results in
very very poor performance.

[snip]
> I've been used to consider for 3 years that :
>=20
> - Next kernel release will have a truly excellent and mature BTRFS suppor=
t.

   I don't think anyone's claimed that. The next version tends to fix
most of the *known* problems.

> - Current kernel release has correct BTRFS support - but most
> mainline distros don't have it yet, maybe in 6 months ?

   This is usually true -- but by the time the current kernels come
round, there's usually been another swathe of bugs uncovered, thus
falling into this problem:

> - Previous kernel release (the one that all current distros come
> with) have a completely broke BTRFS support...

   Not completely broken, but with known and identified bugs that have
been fixed in later versions.

> #LOL
>=20
> Well I hope it's quite not the case anymore for I just installed my neigh=
bour,=20
> old lady's system with a Linux Mint 16 (kernel 3.11) on BTRFS with skinny=
=20
> extents...

   There's one known and serious bug in 3.11 before 3.11.6 which
affects balances. Please make sure that you're running 3.11.6 or
later. There may be other bugs in there that have been fixed in later
kernel versions as well, but that's the "headline" one.

> But for myself running ArchLinux in kernel 3.13, I still find out that :
>=20
> - "btrfs send" causes my kernel to BUG :-/ (the wiki says it's working=20
> stuff...)

   We don't get many bug reports of kernel oopses in send. This may be
that we don't have many people trying to use it (it is, after all,
fairly deep and poorly explained magic at the moment). It may be that
you have some corruption that's gone undetected otherwise, and the
send code isn't handling it well. Or it may be an actual bug in send.
At least you've reported it. (It might also be worth putting a copy of
the report on bugzilla.kernel.org, because then it doesn't get
forgotten in the email noise here).

> - btrfs-defrag.sgh hangs because of some glitch with "filefrag".

   Is that a btrfs problem, or a filefrag problem? btrfs-defrag.sh
isn't something I've heard of before, so I'd say it's unlikely to be
maintained by any of the main btrfs developers (and hence is much more
likely to be unmaintained or just plain broken in general).

> - bedup crashes badly and looks completely unmaintained as far as I can t=
ell=20
> and nobody seems to care.

   That's because nobody here is connected to bedup in any way. It was
a third-party piece of software written by someone (I don't even
recall who) who hasn't, as far as I know, engaged with the main btrfs
developers at all.

> Soooo weeelllll... Looks like readiness for prime time is still
> ahead of us...

   I think that's fair to say. However, it is noticeably improving
over time. The timescales are just quite long.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---  =20
                    good in Speedos. -- Rusty Russell                   =20

--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUxxRnVheFHXiqx3kAQIvpw//WZtiai9GRCjNPY1wuMvFOvj20tEbCur8
nyLVKLJHyluapFBuBx7F4a4IHybfzbuRBBT0nWdt1iy3tyZJYAJwzqC8xLoIPTr0
JrjW+4bmAbqyZGWGBFMGXbKYNtMfuXP+QNm3sJC8PQp4JrHWG1hn8AEgH21znTSY
ATEO0YGLSL57kJgaFM9JD4T389P4HylvHUxYqQAhm0Bh82UiZfqvVIzNCM4icBuo
ggCw2rfras1vbFA/vYFmU7WJtjNqdiDyIytJvQv8LwmKJK79ogGAjZR5N4cEwzo2
Xz9PkjxLIlvfba3Z3qrjmJI3W8drQFR1mxfGcjz0YQcUyYk8Gu3g0b1wTarx6U/L
ZZtR5xZas3q50IMNrxXbTFYGS+2wFs4MGREHWDlxlGog8CTue/mLzKO/LC6scJkz
LZMqwDJ2ApmcRx9KYp2IF17AWznZ3cueuBKRPnsODg0dDkxS8i4sqEg6enk4teQ4
sSKhH304PjF4hHk25RqzMYsTmeQ+UIbI+8En4f3V45vO7Qjml/wvTLWimkA5ge6x
BXRXZP6B2x/lwcyQz0ZYUdrZU8OtwZtBo7b/uS1Rz1ESjF3e7rgC0WkboARrngEG
mNPCQLyohTs3p58SwPxTZMtaZO4HaPCNhRynqk7YpNCDbNUdJjUBOmDYmqs7k+g3
GKvqFEZ9nQQ=
=9Agy
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
