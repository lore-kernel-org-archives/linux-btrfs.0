From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Extreme slowdown
Date: Fri, 16 Dec 2011 09:11:03 +0000
Message-ID: <20111216091103.GB17573@carfax.org.uk>
References: <4EEA4124.20907@robotech.de>
 <4EEAA86C.4080706@cn.fujitsu.com>
 <4EEB06AC.4070500@robotech.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Cc: Liu Bo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EEB06AC.4070500@robotech.de>
List-ID: <linux-btrfs.vger.kernel.org>


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 16, 2011 at 09:51:56AM +0100, Tobias wrote:
> Am 16.12.2011 03:09, schrieb Liu Bo:
> >On 12/16/2011 02:49 AM, Tobias wrote:
> >>Any hints how i could speed it up?
> >>
> >
> >I recommend to run defragment on your files,
> >it should help you, although defrag maybe slow, too.
> >
> 
> When deleting files does it matter if the data is fragmented?

   Yes. Deleting a file involves visiting the metadata for every
extent (i.e. fragment) and updating it to reduce the reference count
and possibly free up the space -- which itself involves more writes,
as the free space cache is updated.

> When i do normal file-access the speed of reading is ok so until not
> i didn't care about fragmentation. Especially because the data isn't
> changes after the first write.
> 
> Can i do a defrag on the metadata only?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                    --- UNIX:  Italian pen maker. ---                    

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFO6wsnIKyzvlFcI40RAg3xAKDOnvOC4/L3IS+Gy6MXzbAy7RZL1ACcCydp
0IWCJ1xHJAV0g5v/DkZucMU=
=sEi/
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
