From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Unhelpful error message from "btrfs" tool
Date: Thu, 11 Nov 2010 22:25:33 +0000
Message-ID: <20101111222533.GA4202@vlad.carfax.org.uk>
References: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
 <201011112132.06687.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Cc: Josh Berry <des@condordes.net>, linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011112132.06687.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 11, 2010 at 09:32:06PM +0100, Goffredo Baroncelli wrote:
> On Thursday, 11 November, 2010, Josh Berry wrote:
> > Hi,
> > 
> > I have a cron script that runs periodically, taking new snapshots and
> > cleaning up old ones when space gets low on my filesystem.  This
> > morning, the script suddenly stopped being able to remove snapshots.
> > When I tried to remove one manually, I got the following:
> > 
> > # btrfs subvol del 2010-11-07-01:17:01
> > Delete subvolume '/btrfs/snapshot/2010-11-07-01:17:01'
> > ERROR: cannot delete '/btrfs/snapshot/2010-11-07-01:17:01'
> > 
> > There is nothing in dmesg or in the above output to tell me what the
> > problem is, how to fix it, etc.  I'm running kernel 2.6.36, and I
> > updated btrfs-progs-unstable to the lastest Git revision
> > (1b444cd2e6...), with the same result.
> > 
> > How do I diagnose this issue?  I'm not even sure where to start.
> 
> This error is due to a failure during the ioctl. Could you "strace" btrfs 
> subvolume delete ?
> 
> # strace btrfs subvolume delete /btrfs/snapshot/2010-11-07-01:17:01
> 
> Definetely we need a more verbose error handling, about the return of the 
> ioctl.

   I've made a good start on doing that. I'll try to finish it off
over the weekend.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- The future isn't what it used to be. ---               

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM3G1dIKyzvlFcI40RAmpaAJ9fM47eNmsyBicg2CZtIPmGiEyf+QCg1fzA
f87ygTBgetYibJ7KjwuXbPY=
=u2Cl
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
