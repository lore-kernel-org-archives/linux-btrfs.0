Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58870 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3CJVgK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 17:36:10 -0400
Date: Sun, 10 Mar 2013 21:36:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130310213606.GE30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <201303101223.56805.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PGNNI9BzQDUtgA2J"
In-Reply-To: <201303101223.56805.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 10, 2013 at 12:23:56PM +0100, Martin Steigerwald wrote:
> Hi Hugo,
>=20
> Am Samstag, 9. M=E4rz 2013 schrieb Hugo Mills:
> >    Some time ago, and occasionally since, we've discussed altering the
> > "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> > number of copies, m is the number of (data) devices in a stripe per cop=
y,
> > and p is the number of parity devices in a stripe.
> >=20
> >    The current kernel implementation uses as many devices as it can in
> > the striped modes (RAID-0, -10, -5, -6), and in this implementation,
> > that is written as "mS" (with a literal "m"). The mS and pP sections are
> > omitted if the value is 1S or 0P.
> >=20
> >    The magic look-up table for old-style / new-style is:
> >=20
> > single           1C (or omitted, in btrfs fi df output)
> > RAID-0           1CmS
> > RAID-1           2C
> > DUP                      2CD
>=20
> What does the "D" in "2CD" mean? Its not explained above, unless I miss=
=20
> something.

   Oh, sorry. It's "reduced redundancy", aka DUP -- i.e. you get that
number of copies, but not guarantee that the copies all live on
different devices. I'm not devoted to showing it this way. Other
suggestions for making this distinction are welcomed. :)

> > RAID-10          2CmS
> > RAID-5           1CmS1P
> > RAID-6           1CmS2P
>=20
> I think its great to clarify the RAID-level terminology, but I find the n=
ew=20
> notation a bit, hmmm, cryptic.
>=20
> Maybe for displaying it would be nice to show a more verbose format like
>=20
> 2 copies, many stripes, 1 parity (1CmS1P)
>=20
> by default and the abbreviated one in parentheses?

   The only place it gets output right now is btrfs fi df, and
something that verbose would probably get in the way.

> Any other idea to make it less cryptic?

   Not necessarily less cryptic, but using lower-case c/s/p would
probably improve readability: 1c2s1p. Possibly also using * instead of
m for the "s" setting: 2c*s. That will change the heights of the
characters, so you only really need to look at the tall ones.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- There's many a slip 'twixt wicket-keeper and gully. ---      =20

--PGNNI9BzQDUtgA2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUTz8xr9z9OVl50rAAQJudg//R8gTQst1udvmUqe9y7l49BZ40pfsXEbv
hUnFVmkI812QiOMoetYCoKOk6Mx7+PTbqXTlQLl8sBMGzPr7zCInu9akiNhWgo57
htEvtHL1FSw6/B5ysoRXN7dYiTF1oL18FLgdIzYDng+v3sRJ6gLmlm8DfNdcyl31
Cq/cZSl1UZcLMRJ/5pUILFtabAxiOwtnXX2OWWUlcKDWds+s33a08zMQL52RMzo3
yDyDTHe3VoyrAJTubxqlUrIErUNBX+x54HvjqYAt4QmdrU8kPAYU5FfSss4kjj1J
K+mpf+10k49Bapyt0ZP12xHDG+XzWj44qmMk+nRT943hEerH9xMTQMaWQCET/MCh
rf1neiMLAa6H9m2VXtQD0DlIDimPuQxduga6N7m/SVDssCGRirXSZHbFlymmZY6T
u1bY3kBnizJIhdgM5NHiNfJNcEjFnc+GR7flRi5DiZlqpCnSva3h2bYiuYV8lqUs
g9DNWSRHiUWJxVsh6T1o9m9dBKXlilR/nZfKFPR63DHaQdwP2FhED60DYgb71DDD
lofqOMUuk5JXf1TxjGzCzC8v98QhInvf/h7vhUpaqWeeJJtLpsVF0IJYofgxT9kv
bUFYW26XuIIZqwJXmp6ngL7SNIaVO6Ga/JsE2mzuws9l1Wlg7W3qqp0Pc3w8KEig
JrLjJoPoCrY=
=10xL
-----END PGP SIGNATURE-----

--PGNNI9BzQDUtgA2J--
