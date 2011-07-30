From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Emergency - Can't Boot
Date: Sat, 30 Jul 2011 21:46:21 +0100
Message-ID: <20110730204621.GA6989@carfax.org.uk>
References: <1312055511.4346.9.camel@hydra.darkmatter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Cc: linux-btrfs@vger.kernel.org
To: "." <cacook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312055511.4346.9.camel@hydra.darkmatter.org>
List-ID: <linux-btrfs.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 30, 2011 at 12:51:51PM -0700, . wrote:
> I just did my monthly dist-upgrade and rebooted, only to have it stall
> at Control D.  It tried to automatically run fsck.btrfs and of course it
> failed, and insists that I run it manually.  I can't.  I've rebooted
> several times and can't get past Control D.  Don't know where it keeps
> track of the number of reboots since last fsck.
> 
> What do you do in a case like this?

   [Just a note -- this seems to have been fixed in a conversation on
IRC, by linking /bin/true to /bin/fsck.btrfs]

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Always be sincere,  whether you mean it or not. ---         

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFONG2dIKyzvlFcI40RAqHWAJ9MO2DC5Fcywhov+Hj8p/Q71BKakQCePL5/
vj4CodcWFghZ1JYXYo8JhCw=
=V5v+
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
