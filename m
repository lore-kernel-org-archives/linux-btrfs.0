From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Balance RAID10 with odd device count
Date: Tue, 21 Feb 2012 01:22:53 +0000
Message-ID: <20120221012253.GE5350@carfax.org.uk>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
 <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
 <4F42F078.2030408@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Cc: Wes <anomaly256@gmail.com>, tom@drdabbles.us,
	linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F42F078.2030408@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 21, 2012 at 09:16:40AM +0800, Liu Bo wrote:
> On 02/21/2012 08:45 AM, Wes wrote:
> > meaning removing any 1 drive would result in lost data.
> 
> Removing any disk will not lose data cause btrfs ensure all the data
> in the removed disk is safely placed on right places.  And if there
> is not enough rest space for the data, the remove operations will
> fail.  Or what am I missing?

   The typo. :) He said he meant "removing any 2 drives" in the
follow-up mail.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'd make a joke about UDP,  but I don't know if ---         
                     anyone's actually listening...                      

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPQvHtIKyzvlFcI40RAmjiAJ9QV3BgwnRLKFfn5Gl3ts8E87sQrgCeNoqd
OTUKn2O+cEEWF2RgYU1yDO0=
=U6Zv
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
