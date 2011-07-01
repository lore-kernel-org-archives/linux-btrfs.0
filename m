From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-progs: integration branch updated
Date: Fri, 1 Jul 2011 10:06:45 +0100
Message-ID: <20110701090645.GC4067@carfax.org.uk>
References: <20110630211902.GC4352@carfax.org.uk>
 <4E0D27E5.4060807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0D27E5.4060807@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 01, 2011 at 09:50:29AM +0800, Li Zefan wrote:
> > Jan Schmidt (5):
> >       commands added
> >       scrub ioctls
> >       added check_mounted_where
> >       scrub userland implementation
> >       scrub added to manpage
> > 
> > WuBo (1):
> >       Btrfs-progs: Add chunk tree recover tool
> > 
> 
> I think we should wait for the kernel patch to be accepted before
> adding this to btrfs-progs ?

   Yes, the same applies to the balance-management series. Most of
this set of patches won't be going in immediately (there's also a
couple that still need revisions).

   In fact, the only patches in this collection that I'm expecting to
push to Chris as soon as I can are the five scrub ones. The remaining
13 (in my current stack) are either waiting on kernel features to be
added, or need a little more maturity/review. Some are known to be
wrong and are waiting on a new version of the patch.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You know,  the British have always been nice to mad people." ---  

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODY4lIKyzvlFcI40RAuJ/AJwIhkelnRyxM5NtoK0rxNRHhCFTNwCeKxO8
ujEtjbIUHnt8GGBGS03/o0E=
=OE+c
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
