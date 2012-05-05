From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs device delete missing problem
Date: Sat, 5 May 2012 11:48:51 +0100
Message-ID: <20120505104851.GI9860@carfax.org.uk>
References: <4FA48416.3070705@intellasoft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MPkR1dXiUZqK+927"
Cc: linux-btrfs@vger.kernel.org
To: Mark Murawski <markm-lists@intellasoft.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA48416.3070705@intellasoft.net>
List-ID: <linux-btrfs.vger.kernel.org>


--MPkR1dXiUZqK+927
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 09:36:22PM -0400, Mark Murawski wrote:
> Using the latest mason git (and kernel 3.3.4)
> 
> stan {~} root# btrfs  filesystem show
> Label: none  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>         Total devices 2 FS bytes used 7.09GB
>         devid    2 size 9.31GB used 9.09GB path /dev/sdd6
>         devid    1 size 9.31GB used 9.09GB path /dev/sdg6
> 
> Label: none  uuid: b142f575-df1c-4a57-8846-a43b979e2e09
>         Total devices 9 FS bytes used 1.35TB
>         devid    8 size 1.36TB used 1.07TB path /dev/sda
>         devid    7 size 1.36TB used 1.07TB path /dev/sde
>         devid    2 size 465.76GB used 134.00GB path /dev/sdb
>         devid    4 size 149.05GB used 0.00 path /dev/sdc
>         devid    9 size 465.76GB used 161.00GB path /dev/sdf
>         devid    3 size 149.05GB used 0.00 path /dev/sdh
>         devid    5 size 920.34GB used 616.03GB path /dev/sdd7
>         devid    6 size 920.34GB used 616.03GB path /dev/sdg7
>         *** Some devices missing
> 
> stan {~} root# btrfs device delete missing /storage
> May  5 05:28:40 stan kernel: btrfs: relocating block group 0 flags 2
> stan {~} root#

   sync here, or btrfs fi sync /storage, or wait at least 30 seconds
for everything to be written out to disk.

> stan {~} root# btrfs  filesystem show
> Label: none  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>         Total devices 2 FS bytes used 7.09GB
>         devid    1 size 9.31GB used 9.09GB path /dev/sdg6
>         devid    2 size 9.31GB used 9.09GB path /dev/sdd6
> 
> Label: none  uuid: b142f575-df1c-4a57-8846-a43b979e2e09
>         Total devices 9 FS bytes used 1.35TB
>         devid    3 size 149.05GB used 0.00 path /dev/sdh
>         devid    6 size 920.34GB used 616.03GB path /dev/sdg7
>         devid    9 size 465.76GB used 161.00GB path /dev/sdf
>         devid    7 size 1.36TB used 1.07TB path /dev/sde
>         devid    5 size 920.34GB used 616.03GB path /dev/sdd7
>         devid    4 size 149.05GB used 0.00 path /dev/sdc
>         devid    2 size 465.76GB used 134.00GB path /dev/sdb
>         devid    8 size 1.36TB used 1.07TB path /dev/sda
>         *** Some devices missing

   btrfs fi show doesn't go through the kernel to get its information
-- it simply reads the data on the disks directly. This means that if
the kernel hasn't flushed changes to disk, btrfs fi show will be out
of date, as you've got here.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The English language has the mot juste for every occasion. ---    

--MPkR1dXiUZqK+927
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPpQWTIKyzvlFcI40RAqOzAJwJL4/cEtxPXAtv6pnSwiwRXq9SDQCfWsVq
X1nXw/CUH76YG1lrNjbI07o=
=8dRy
-----END PGP SIGNATURE-----

--MPkR1dXiUZqK+927--
