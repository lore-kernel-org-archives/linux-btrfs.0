From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btr fs unmountable after disk failure
Date: Fri, 13 Apr 2012 11:58:22 +0100
Message-ID: <20120413105822.GF4856@carfax.org.uk>
References: <alpine.LNX.2.01.1204131252070.26191@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ChQOR20MqfxkMJg9"
Cc: linux-btrfs@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1204131252070.26191@frira.zrqbmnf.qr>
List-ID: <linux-btrfs.vger.kernel.org>


--ChQOR20MqfxkMJg9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 13, 2012 at 12:55:43PM +0200, Jan Engelhardt wrote:
> 
> I originally created a RAID1(0) compound out of 4 drives. One of them 
> [sdf] failed recently and was removed. The filesystem is no longer 
> mountable with the 3 drives left.
> On 3.3.1:
> 
> # btrfs dev scan
> [ 1065.572938] device label srv devid 1 transid 11386 /dev/sdc
> [ 1065.573044] device label srv devid 3 transid 11386 /dev/sde
> [ 1066.089981] device label srv devid 2 transid 11386 /dev/sdd
> # mount /dev/sdd /top.srv
> [ 1070.201339] device label srv devid 2 transid 11386 /dev/sdd
> [ 1070.201666] btrfs: disk space caching is enabled
> [ 1070.203310] btrfs: failed to read the system array on sde
> [ 1070.204458] btrfs: open_ctree failed
> (Sparse error message, innit..)

   I think you need "-o degraded" in this case.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Mixing mathematics and alcohol is dangerous.  Don't ---       
                            drink and derive.                            

--ChQOR20MqfxkMJg9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPiAbOIKyzvlFcI40RAjRrAKCW6NgCYuAOyPojT19aC0AkD/kR7gCgxUpp
JwFzmc96/znPARDFzgW7gBo=
=9cTH
-----END PGP SIGNATURE-----

--ChQOR20MqfxkMJg9--
