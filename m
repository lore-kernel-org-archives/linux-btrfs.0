Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40868 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaEIR6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 13:58:31 -0400
Date: Fri, 9 May 2014 18:58:27 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: laie <laie@halifax.rwth-aachen.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: destroyed disk in btrfs raid
Message-ID: <20140509175827.GG16185@carfax.org.uk>
References: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="doKZ0ri6bHmN2Q5y"
In-Reply-To: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--doKZ0ri6bHmN2Q5y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 08:02:45PM +0200, laie wrote:
> Hello!
> 
> I've some trouble with my btrf filesystem. I've lost one backing raid
> device, it's luks header is overwritten and not restoreable.
> 
> The lost disk was recently added. 'btrfs filesystem balace' was running for
> some time, but the new device is the smallest in the set.
> 
> Data is stored with Raid0, Metadata with Raid1. Degraded mounting works
> fine.
> 
> Now I'm looking for a way to tell btrfs to provide me with a list of the
> corrupted files and delete them afterwards. This would be great, because
> otherwise it would take very long to get the data back from slow backups.

   Simple solution: cat every file to /dev/null, and see which ones
fail with an I/O error. With RAID-0 data, losing a device is going to
damage most files, though, so don't necessarily expect much to survive.

   Hugo.

> Thanks in advance
> Max
> 
> 
> btrfs --version
> Btrfs v3.12
> 
> btrfs fi show
> Label: userspace  uuid: there is one ;)
>         Total devices 3 FS bytes used 27.21TiB
>         devid    1 size 21.83TiB used 13.03TiB path /dev/dm-3
>         devid    2 size 16.37TiB used 13.01TiB path /dev/dm-2
>         devid    3 size 8.19TiB used 4.27TiB path
> 
> btrfs fi df /home/
> Data, RAID0: total=30.24TiB, used=27.18TiB
> System, RAID1: total=32.00MiB, used=1.99MiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=32.00GiB, used=31.42GiB
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- UDP jokes: It's OK if no-one gets them. ---             

--doKZ0ri6bHmN2Q5y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU20XQ1heFHXiqx3kAQKV6hAAnyvYVdkpKjatrBlPLT8Gln0oqR//1aUG
OM0Kro50nFNZqtHeftUHoC6YGyMq53Xsl6iAh9oVPHTHKWAAhUIolEm5BSPwvA8J
tvw3MVJ8HRIMhIOhXTFa4HNxp1Pier617aQ+2/ugwBX/Dh8AIpD9E9aG+1HIedQK
UBhApS2bjs5NZvhwLv1RL2bvxZfJDWyRgrgQZGPSdWVA2vcOVnIuVCsIH1rVt1EY
v9YfIR0I3HbauuZYAihXjboHCCXr6329YDU0E3N+hSYBRGiYxrKXNC/QDjmlcQ8m
OqzKYULkNtOSAKibB2m0hboZ1aHgvhamffyOcQhJMB7DCSHcz81pBA+rNcuSUNc8
bFxOj8BiRs8zw8iMvIkW+bRBz5kKtwHb9D5W24WA+i4E6fAWbzwaxf/XRr1jYlEj
W1TkNDhvBEhygXWzWvacR0JggBkIuf/pVR77HUcLCrXm6dR1RYP2oLi5ywAFbt2k
zbOKnomw+tQtp55vmujYbPhM9gyf16x/QP2PlKdkbGgDuQ88qPMJ6ZXcrpvnq1ZR
VrhntrhzKHCdAIyHufDB86JTomRp5v+U/9IHZKlKcLIS9LljLJukgHSUxg6GXGEu
annibBKE3foC3h+w/O/rxXbmb6Cw9NEf9uAx7hKZeyp+ndBzdCp7pkvvqSCGoQ/B
wIBx96FiETs=
=AOr/
-----END PGP SIGNATURE-----

--doKZ0ri6bHmN2Q5y--
