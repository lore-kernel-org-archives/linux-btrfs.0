From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Integration branch updated
Date: Mon, 27 Jun 2011 15:45:23 +0100
Message-ID: <20110627144523.GA13379@carfax.org.uk>
References: <20110626211022.GA24675@carfax.org.uk>
 <20110627124300.GR12709@twin.jikos.cz>
 <4E087FA2.8040105@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E087FA2.8040105@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 27, 2011 at 03:03:30PM +0200, Andreas Philipp wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> On 27.06.2011 14:43, David Sterba wrote:
> > On Sun, Jun 26, 2011 at 10:10:22PM +0100, Hugo Mills wrote:
> >> I've just updated the btrfs-progs integration branch I've been
> >> keeping. Not a huge amount new since last time:
> >>
> >> Andreas Philipp (1):
> >> print parent ID in btrfs subvolume list
> >
> > dunno if this has been mentioned already, but this change breaks
> > xfstests/254 and needs a patch once merged.
> Sorry, I was not aware of the problem with xfstests/254. But as far as

   I've not seen anything to that effect reported. I haven't been
running xfstests regularly, though...

> I see, xfstests/254 tests explicitly for subvolume/snapshot features
> in btrfs and uses a specific filter to parse the output of btrfs
> subvolume list. If this output changes (without introducing another
> error), then "only" the test is broken.
> Any suggestions on how to change the patch? Maybe adding a flag (-p ?)
> to add the parent ID in the output and leave the standard output
> untouched?

   That has the benefit of not breaking existing code that attempts to
parse it. Anything else is going to need xfstests/254 (and any other
users of the interface) to work out which version it's trying to parse
and dealing with it appropriately.

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
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOCJeDIKyzvlFcI40RAsomAJ9okDpEuTuC0Jv3O4NbQxPz3Sy7KwCgoq/K
n5CxWh4aqBjW1z8vpLbmo9A=
=G93x
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
