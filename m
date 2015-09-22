Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44358 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbbIVPNb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 11:13:31 -0400
Date: Tue, 22 Sep 2015 15:13:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: problem with long running btrfs mount operation
Message-ID: <20150922151330.GJ5918@carfax.org.uk>
References: <20150922133813.GA14395@sfserver>
 <56015D3F.8020406@googlemail.com>
 <CABR0jERXQ9ydE+KAeQBrW5F0DzraePnAyz8m-uVStUCbeFt4WQ@mail.gmail.com>
 <20150922144312.GB14395@sfserver>
 <56016C5F.6010406@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6J7GEvtanOfV9oXA"
In-Reply-To: <56016C5F.6010406@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6J7GEvtanOfV9oXA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2015 at 04:57:35PM +0200, Holger Hoffst=E4tte wrote:
> On 09/22/15 16:43, S. Fricke wrote:
> >> On Tue, Sep 22, 2015 at 9:53 AM, Holger Hoffst=E4tte
> >> <holger.hoffstaette@googlemail.com> wrote:
> >>> On 09/22/15 15:38, S. Fricke wrote:
> >>>> I have a problem with one of my btrfs hdds. If I mount it, it needs =
more than
> >>>> 135 minutes for this operation. After the mounting it works normaly.=
 This is
> >>>> reproducible only with this hdd.
> >>>>
> >>>> Maybe someone has a clue what is going wrong here.
> >>>
> >>> On remount it tries to continue a previously started balance, which f=
ails with
> >>> an error (as can be seen at the end of your log). You should:
> >>>
> >>> a) immediately stop what you're doing on that fs and unmount it
> >>> b) get btrfs-progs-4.2.1 (not 4.2) and see what it says
> >=20
> > What should it say to me? I have to send a command? Should I try to mou=
nt the
> > device after I have unmount it? BTW: Is btrfs-progs needed for mounting?
>=20
> I should have been more clear and say "run btrfs check", which I original=
ly
> intended to write but then somehow didn't. Sorry. :-)
>=20
> btrfs-progs is not needed for mounting, only for administrative commands.

   Well, technically, it's useful (but not absolutely essential) to
have btrfs dev scan for setting up multi-device filesystems before
mount.

   Hugo.

--=20
Hugo Mills             | What's a Nazg=FBl like you doing in a place like t=
his?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Ill=
iad

--6J7GEvtanOfV9oXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAXAZAAoJEFheFHXiqx3kQS8P/jf3e8lhj6OLQ9xSgme3uYr0
WrckOGSJbM/U9deHNd8DNdjbTrGKQP4UORZi/oPa8MNnnOrF+Ig4ZTKjutzgzDNC
XW5I6uUmwvmauW7mLnpi8Rht0zU8dZADenkdKxKLlzpIVyeaLDMzrXFCnXZvAdkP
xWZr15Woq3XTRpvMbxfQpzPRrJKDOhGVb9HX0u3BXCI1qfwOOjtQZ9ABb7V3iCCr
zcof8kHdef4FMdz7JNKv6eSR2G36ZgfGFE4cIwBCrpoDvOqLXXrhSfYbd+B8IXOU
DVDSL4HUTbgSu21OObUSjRZe7Q/T6SidceXS7QiAOby794Eb7PatWeRaN329UYFQ
4fdeQ7iPiUTULKmP1nti5pkhnuCks7ukE+cAMURVXeUm5j9fmb7QY4I9r7s5Lkj/
nS/gkQzdbTTV+NlCVPn69mFsG2ImF1L+X/o1bBhuoy1PBqK/sCtxYkqzQgz4ep1W
Ke27wtyG3T0Tw9L8Xn/lEsIaM2PVh6DrYYZUgkMHKfcbJ9WWm98RVC3MCDzel0c/
EfOQI0TOmWehkudQs3HT2JDqJAPu4fCtNayqOYUpW/ME1s/nPV3UNSE+ph1lhbAQ
ZureeGDGC6ocePB876uf2jsVdnQYRJ5kKeuznNJKpASl8Q8h8u/2H5jvPvRm3gfi
SZnm9VafGWBynmaqa7Bw
=NiNN
-----END PGP SIGNATURE-----

--6J7GEvtanOfV9oXA--
