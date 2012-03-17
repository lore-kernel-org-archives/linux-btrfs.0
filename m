From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 12:25:22 +0000
Message-ID: <20120317122522.GD3172@carfax.org.uk>
References: <C52pxfli1uB@helmut.hullen.de>
 <loom.20120317T131420-684@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120317T131420-684@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 17, 2012 at 12:19:54PM +0000, Alex wrote:
> Helmut Hullen <Hullen <at> t-online.de> writes:
> 
> > 
> 
> > 
> > Where is the problem, how can I use the full space?
> > 
> > Viele Gruesse!
> > Helmut
> 
> Effectively it's missing the trigger to rebalance when the 'primary' device
> starts to get full, or just to randomly spread the data between the devices.

   No, a balance isn't going to help here. RAID-0 requires a minimum
of 2 chunks in a block group. With two disks, you're only going to be
able to fill the smallest one before you run out of space.

> Isn't this going to be a problem for anyone restoring from a backup? Lots of
> data heading to btrfs without a pause.

   Again, not the issue here.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am but mad north-north-west:  when the wind is southerly, I ---  
                       know a hawk from a handsaw.                       

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPZIKyIKyzvlFcI40RAl8mAJ9Oez9oR1fPnZkV7ZuLJk2S175c5wCcC8y3
H2ri/jqr+/IgzBdjnRtqqSE=
=dvCJ
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
