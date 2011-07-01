From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH] Re: [btrfs-progs integration] incorrect argument
 checking for "btrfs sub snap -r"
Date: Fri, 1 Jul 2011 11:42:23 +0100
Message-ID: <20110701104223.GA7606@carfax.org.uk>
References: <chaz20110629150041.GB28702@seebyte.com>
 <4E0BC7AA.7000709@cn.fujitsu.com>
 <chaz20110630084046.GC28702@seebyte.com>
 <4E0C3F72.5040508@gmail.com>
 <chaz20110630104340.GD28702@seebyte.com>
 <20110630105813.GD11170@carfax.org.uk>
 <chaz20110630123438.GE28702@seebyte.com>
 <4E0CE2B3.1080600@gmail.com>
 <chaz20110701082652.GF28702@seebyte.com>
 <4E0D9DCA.1090204@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Cc: Stephane Chazelas <stephane.chazelas@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0D9DCA.1090204@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 01, 2011 at 12:13:30PM +0200, Andreas Philipp wrote:
> On 01.07.2011 10:26, Stephane Chazelas wrote:
> > 2011-06-30 22:55:15 +0200, Andreas Philipp:
> >> -----BEGIN PGP SIGNED MESSAGE-----
> >> Hash: SHA1
> >> =20
> >> On 30.06.2011 14:34, Stephane Chazelas wrote:
> >>> Looks like this was missing in integration-20110626 for the
> >>> readonly snapshot patch:
> >>>
> >>> diff --git a/btrfs.c b/btrfs.c
> >>> index e117172..be6ece5 100644
> >>> --- a/btrfs.c
> >>> +++ b/btrfs.c
> >>> @@ -49,7 +49,7 @@ static struct Command commands[] =3D {
> >>> /*
> >>> avoid short commands different for the case only
> >>> */
> >>> - { do_clone, 2,
> >>> + { do_clone, -1,
> >>> "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
> >>> "Create a writable/readonly snapshot of the subvolume <source> with\n"
> >>> "the name <name> in the <dest> directory.",
> >>>
> >>> Without that, "btrfs sub snap -r x y" would fail as it's not *2*
> >>> arguments.
> >> Unfortunately, this is not correct either. "-1" means that the minimum
> >> number of arguments is 1 and since we need at least <source> and
> >> <name> this is 2. So the correct version should be -2.
> > [...]
> >
> > Sorry, without looking closely at the source, I assumed -1 meant
> > defer the checking to the subcommand handler.
> >
> > do_clone will indeed return an error if the number of arguments
> > is less than expected (so with -2, you'll get a different error
> > message if you do "btrfs sub snap -r foo" or "btrfs sub snap
> > foo") , but will not if it's more than expected by the way.
> >
> > So the patch should probably be:
> >
> > diff --git a/btrfs.c b/btrfs.c
> > index e117172..b50c58a 100644
> > --- a/btrfs.c
> > +++ b/btrfs.c
> > @@ -49,7 +49,7 @@ static struct Command commands[] =3D {
> >  	/*
> >  		avoid short commands different for the case only
> >  	*/
> > -	{ do_clone, 2,
> > +	{ do_clone, -2,
> >  	  "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
> >  		"Create a writable/readonly snapshot of the subvolume <source> with\=
n"
> >  		"the name <name> in the <dest> directory.",
> > diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> > index 1d18c59..3415afc 100644
> > --- a/btrfs_cmds.c
> > +++ b/btrfs_cmds.c
> > @@ -355,7 +355,7 @@ int do_clone(int argc, char **argv)
> >  			return 1;
> >  		}
> >  	}
> > -	if (argc - optind < 2) {
> > +	if (argc - optind !=3D 2) {
> >  		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
> >  		free(argv);
> >  		return 1;
> >
> Thanks for having another look at this. You are perfectly right. Should
> we patch my patch or should I rework a corrected version? What do you
> think Hugo?

   Could you send a follow-up patch with just the second hunk, please?
I screwed up the process with this (processing patches too quickly to
catch the review), and I've already published the patch with the first
hunk, above, into the for-chris branch.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- It's not so much an afterlife, more a sort of apr=E8s vie. ---   =
=20

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODaSOIKyzvlFcI40RAjMhAKCXlfr4ECL8ytnQzB2cv9M0D5OtMACaAsWJ
6et+zBNXoFQl5di0JzQ0+Fw=
=qtcM
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
