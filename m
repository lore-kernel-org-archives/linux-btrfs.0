From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-progs: integration branch updated
Date: Fri, 1 Jul 2011 09:52:31 +0100
Message-ID: <20110701085231.GA4067@carfax.org.uk>
References: <20110630211902.GC4352@carfax.org.uk>
 <4E0CE9E7.8010107@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0CE9E7.8010107@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 30, 2011 at 11:25:59PM +0200, Andreas Philipp wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> On 30.06.2011 23:19, Hugo Mills wrote:
> > After a reorganisation of patches, and sending a bunch of them to
> > Chris, I've also updated the integration branch to match that.
> > It's available from:
> >
> > http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> > integration-20110630
> >
> > The shortlog of 17 patches in this branch beyond the ones I've
> > sent to Chris is below.
> >
> > Hugo.
> >
> >
> > Andreas Philipp (1): print parent ID in btrfs subvolume list
> This is still the first version of my patch, which changes the default
> output from btrfs subvolume list and breaks xfstests/254. Please use v2.

   I don't see a v2 on the mailing list -- did it get filtered by my
spam trap? Or are you still working on it? (Either way is good: I
won't be pushing the top patches from the stack to Chris until they're
ready, but I'm keeping the latest currently-published one in the
stack).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You know,  the British have always been nice to mad people." ---  

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD4DBQFODYrPIKyzvlFcI40RAhLlAJICk6EXvdNNdhF54l5tyfvUlmyqAKCN6cfi
3Sf85GHZb+CwbdkJQYDmPQ==
=iHa/
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
