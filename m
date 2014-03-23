Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59424 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaCWQSr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 12:18:47 -0400
Date: Sun, 23 Mar 2014 16:18:43 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-tools missing "btrfs device delete devid=x path" ?
Message-ID: <20140323161843.GD25400@carfax.org.uk>
References: <20140323152516.GJ12833@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
In-Reply-To: <20140323152516.GJ12833@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 23, 2014 at 08:25:17AM -0700, Marc MERLIN wrote:
> I'm still doing some testing so that I can write some howto.
> 
> I got that far after a rebalance (mmmh, that took 2 days with little
> data, and unfortunately 5 deadlocks and reboots.
> 
> polgara:/mnt/btrfs_backupcopy# btrfs fi show
> Label: backupcopy  uuid: eed9b55c-1d5a-40bf-a032-1be6980648e1
>         Total devices 11 FS bytes used 114.35GiB
>         devid    1 size 465.76GiB used 32.14GiB path /dev/dm-0
>         devid    2 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdd1
>         devid    3 size 465.75GiB used 0.00 path  <----  drive is freed up now.
>         devid    4 size 465.76GiB used 32.14GiB path /dev/dm-2
>         devid    5 size 465.76GiB used 32.14GiB path /dev/dm-3
>         devid    6 size 465.76GiB used 32.14GiB path /dev/dm-4
>         devid    7 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdi1
>         devid    8 size 465.76GiB used 32.14GiB path /dev/dm-6
>         devid    9 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdk1
>         devid    10 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdl1
>         devid    11 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sde1
> Btrfs v3.12
> 
> What's the syntax for removing a drive that isn't there?

   btrfs dev del missing /path

   Removes all the missing devices.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Anyone using a computer to generate random numbers is, of ---    
                       course,  in a state of sin.                       

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUy8JY1heFHXiqx3kAQIsRg//TsZS/WfR2fwhYZurMglKfGWFURRAcPQB
nsoIQl21OzOCw5/OrcSYK+gjiTyn+9xlRLEpMdNLdTbqUhx/Mjsa1+bKomgc51m1
JGEtTEC5+UcKkaZaFUikfWtgoM6ADi1wNipwa6oR5tAwRrf5zlrCyxWhcYvMDvUQ
ONd//jpoUJIWrilLAxdZ/n2jOOjX6LLwbRte/J44T03OAE+jcJaJ+Nr1/2svX3Mo
UY57efYxb16l8fLR94iG2kzKm3qcHYj+60UseIAjsIwbVQ2RyS9OHyZVvIAzOIhH
eZo0smqLI0SKFBr4N3efXQfXkbaLm+S4SkTlOKgfj3XF4tkHTaf/osaWy/nih6Hx
HcD5R77BGz3GEk536dH0ir43RyvF18efbloHJkRDstfk3jByVzTamc/IZxM65mzb
Pvlsffpa6aN+BjKjGfu9VrmhhyMxDKYq8A9etbl3dLB+UiP75YAueHYnQ+4mKqqo
xHJipqGGHuRqbkJxfd/oBK+uoZk7uUi0CmOQKy+M6QjIq64qx3HlC+RZVjiU8gD3
Q7Z0N2nLhH4bs38KgFMHOyBNP3SqQ+9NcQdxmd5ExFiZGVkXFJ6IbALnljolBwhG
MNCmhOlfN7WtwBOMW0ke0YpjLcK27X5T/koMxvg9Ct2kvJDHI5HprHzFWiKCPUFa
SwLpzWM7UT8=
=79jm
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
