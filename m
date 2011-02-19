From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: raid5 - again
Date: Sat, 19 Feb 2011 23:56:00 +0000
Message-ID: <20110219235600.GG5484@carfax.org.uk>
References: <10135916.88.1298149890595.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2NLGdgz3UMHa/lqP"
Cc: linux-btrfs@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <10135916.88.1298149890595.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>


--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 19, 2011 at 10:11:30PM +0100, Roy Sigurd Karlsbakk wrote:
> It's been some two years since I read about the becoming of raid5
> etc in btrfs. Since the code is available in linux, why isn't this
> already in btrfs? Is Oracle holding back?

   It's about resourcing and stability. Oracle only employ one person
(AFAIK) on btrfs -- Chris Mason. He does a sterling job of maintaining
and developing the filesystem, but there is only one of him.

   Since well before December, he's been working on a functional fsck,
trying to get it to a state where it won't demolish your filesystem
even more than it already is. This has left the work to integrate the
RAID-5/6 patches behind. He's also been working hard on fixing a great
many other stability issues as they're reported, and integrating
patches from other developers.

   I believe that RAID-5/6 is the next major piece of work that Chris
is intending to integrate, once fsck is ready. However, stability is
better than features at this point. I don't see any commercial benefit
in preventing the integration and deployment of the RAID-5/6 patches,
but simply that there's other things that are more important. Please
be patient.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Startle, startle, little twink.  How I wonder what you think. ---  

--2NLGdgz3UMHa/lqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNYFiQIKyzvlFcI40RAuUnAJ9guiDBw2MxnnVTE4eNLwwnYsYxUACeO/wT
hnlRk4jHfCaCvh4yQqZ6UU0=
=wsF9
-----END PGP SIGNATURE-----

--2NLGdgz3UMHa/lqP--
