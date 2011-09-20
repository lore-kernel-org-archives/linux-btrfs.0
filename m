From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: your mail
Date: Tue, 20 Sep 2011 16:35:40 +0100
Message-ID: <20110920153540.GE21530@carfax.org.uk>
References: <c627c52800e0bb4e7884aa7174cb4a18@www.jots.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Cc: linux-btrfs@vger.kernel.org
To: File's@jots.org, checksum?@jots.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c627c52800e0bb4e7884aa7174cb4a18@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 20, 2011 at 11:24:30AM -0400, Ken D'Ambrosio wrote:
> Just wondering if/how one goes about getting the btrfs checksum of a given
> file.  Is there a way?

   Checksums are computed on individual 4k blocks, not on the whole
file. There's no explicit interface for retrieving checksums, but if
you understand the data structures, you can get hold of the checksums
for a file using the BTRFS_IOC_TREE_SEARCH ioctl.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "How deep will this sub go?" "Oh,  she'll go all the way to ---   
                    the bottom if we don't stop her."                    

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD4DBQFOeLLMIKyzvlFcI40RAvBKAJ9yq7BDY1w4CZAFye1M3LyZgq6jfACWM9r/
oGQo2BAaMYJqHd9TcbFIgg==
=U+K1
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
