From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs: warn_slowpath in clean_tree_block and others
Date: Wed, 25 Feb 2009 21:41:38 +0000
Message-ID: <20090225214138.GA6455@vlad.carfax.org.uk>
References: <20090224230249.GA6859@vlad.carfax.org.uk> <1235586986.32346.48.camel@think.oraclecorp.com> <89ed0c690902251050g1e6dd23ay5d5426adb7086018@mail.gmail.com> <1235590003.32346.61.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Cc: "Mitch Harder (aka DontPanic)" <mmharder@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235590003.32346.61.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 25, 2009 at 02:26:43PM -0500, Chris Mason wrote:
> [ resend with the list cc'd ]
> 
> On Wed, 2009-02-25 at 12:50 -0600, Mitch Harder (aka DontPanic) wrote:
> > I'll try to test that out.
> > 
> > I had just noticed that some of my kernel configuration settings (not
> > sure which ones) seem to affect the clean_tree_block warnings I've
> > been getting, and one of my customizations is usually to configure the
> > kernel for a single processor.
> > 
> 
> I'll push out a patch tonight that fixes things, the code to test for a
> locked buffer is just broken on UP.  For now, the patch below will do:

   Yup, that shuts it up quite effectively. :)

   Thanks,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- If it's December 1941 in Casablanca,  what time is it ---      
                              in New York?                               

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJpbsSIKyzvlFcI40RAq+SAKC1BW4h8Mtm9OxV+n3mAoRO8FlO1QCcCom0
T5RcKo39TvaOtQFYe5gzJmw=
=tDgl
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
