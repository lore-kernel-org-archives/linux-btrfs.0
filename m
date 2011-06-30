From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH] [btrfs-progs integration] incorrect argument checking
 for "btrfs sub snap -r"
Date: Thu, 30 Jun 2011 22:09:55 +0100
Message-ID: <20110630210955.GB4352@carfax.org.uk>
References: <chaz20110629143747.GA28702@seebyte.com>
 <chaz20110629150041.GB28702@seebyte.com>
 <4E0BC7AA.7000709@cn.fujitsu.com>
 <chaz20110630084046.GC28702@seebyte.com>
 <4E0C3F72.5040508@gmail.com>
 <chaz20110630104340.GD28702@seebyte.com>
 <20110630105813.GD11170@carfax.org.uk>
 <chaz20110630123438.GE28702@seebyte.com>
 <4E0CE2B3.1080600@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Cc: Stephane Chazelas <stephane.chazelas@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0CE2B3.1080600@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 30, 2011 at 10:55:15PM +0200, Andreas Philipp wrote:
> On 30.06.2011 14:34, Stephane Chazelas wrote:
> > Looks like this was missing in integration-20110626 for the
> > readonly snapshot patch:
> >
> > diff --git a/btrfs.c b/btrfs.c
> > index e117172..be6ece5 100644
> > --- a/btrfs.c
> > +++ b/btrfs.c
> > @@ -49,7 +49,7 @@ static struct Command commands[] = {
> > /*
> > avoid short commands different for the case only
> > */
> > - { do_clone, 2,
> > + { do_clone, -1,
> > "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
> > "Create a writable/readonly snapshot of the subvolume <source> with\n"
> > "the name <name> in the <dest> directory.",
> >
> > Without that, "btrfs sub snap -r x y" would fail as it's not *2*
> > arguments.
> Unfortunately, this is not correct either. "-1" means that the minimum
> number of arguments is 1 and since we need at least <source> and
> <name> this is 2. So the correct version should be -2.

   OK, I'll fix that here, as the patch is part of my pull request for
Chris. (I saw the [] around <dest> but missed that <name> was
mandatory... it's been a long day).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Nothing wrong with being written in Perl... Some of my best ---   
                      friends are written in Perl.                       

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODOYjIKyzvlFcI40RAu1GAJwJO4We3UeLrbYZNxb1lAktQBbCKQCglKl2
VEb8mpH9A1UT7cVgUImtrYo=
=SECW
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
