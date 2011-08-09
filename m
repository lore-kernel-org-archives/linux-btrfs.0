From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: BTRFS partition won't mount
Date: Tue, 9 Aug 2011 13:54:39 +0100
Message-ID: <20110809125439.GB28858@carfax.org.uk>
References: <1F6ED4EA7957EB4FADAE461E036D456A25D75644F9@exch01lex.ceradyne.com>
 <20110803205031.GA18558@carfax.org.uk>
 <CAGAVQTE08--VM_uw2t0dDxSdqSEgZYAk52NTqgzJaXNr+OFoRA@mail.gmail.com>
 <1F6ED4EA7957EB4FADAE461E036D456A25D75E8EDB@exch01lex.ceradyne.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Cc: C Anthony Risinger <anthony@xtfx.me>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Adam Newby <anewby@ceradyne.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1F6ED4EA7957EB4FADAE461E036D456A25D75E8EDB@exch01lex.ceradyne.com>
List-ID: <linux-btrfs.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 09, 2011 at 08:29:06AM -0400, Adam Newby wrote:
> I have to say this solution saved me. I've lost a BTRFS partition
> before and this tool was not available at that time. Is this going
> to be making it into a kernel pull anytime soon? The only reason I
> mention it is because pretty much everyone I know has soured on
> BTRFS due to losing a partition at some point or another due to
> frivolous error. This seems like a fine addition to the filesystem.

   My understanding is that the btrfs-zero-log tool is something of a
blunt object, and shouldn't be applied automatically, so I think it's
unlikely to go into the kernel in its current form.

   From what Chris implied on IRC a few days ago, if we encounter
corrupt items in the log, we should drop only those items (and their
dependents?), not the entire log tree. I'd guess that as people work
on reducing the number of BUG_ONs in the code and passing the errors
back up the stack, this will become easier to do.

   Until then, we do have btrfs-zero-log. (And the new recovery tool
coming shortly, too).

   Hugo.

> -----Original Message-----
> From: C Anthony Risinger [mailto:anthony@xtfx.me]=20
> Sent: Monday, August 08, 2011 11:54 PM
> To: Hugo Mills; Adam Newby; linux-btrfs@vger.kernel.org
> Subject: Re: BTRFS partition won't mount
>=20
> On Wed, Aug 3, 2011 at 3:50 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> > =A0 Try the instructions on the wiki at [1]. (And please feed back=20
> > and/or fix any issues you have with the instructions -- they're still=
=20
> > quite new and probably have awkward corners).
> >
> > [1]=20
> > https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my
> > _filesystem.2C_and_I_get_a_kernel_oops.21
>=20
> this worked perfectly for me ... just saved my night from tedious restora=
tion :-)
>=20
> im on kernel 3.0.1 -- hard poweroff led to that problem.  i haven't had a=
ny issues for some time ... im not sure what the problem was exactly, but s=
ometimes systemd gets a little twacky and takes a year to shutdown ... gues=
s i got a little impatient :-)
>=20
> anyways, thanks for the integration work!
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- 2 + 2 =3D 5,  for sufficiently large values of 2. ---        =
=20

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOQS4PIKyzvlFcI40RAltPAKDQSMLQDWgEOPgPqsFcMyjinGKC/gCgrg4H
6r4Pq0E3yvFA+XS7VS7Bu2A=
=BKYL
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
