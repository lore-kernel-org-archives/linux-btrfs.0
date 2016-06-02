Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33964 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbcFBJf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 05:35:27 -0400
Date: Thu, 2 Jun 2016 09:35:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gerald Hopf <gerald.hopf@nv-systems.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid5/6 production use status?
Message-ID: <20160602093525.GC24492@carfax.org.uk>
References: <1464819934.6742.71.camel@scientia.net>
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
In-Reply-To: <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 02, 2016 at 11:24:45AM +0200, Gerald Hopf wrote:
> 
> >Hey.
> >
> >I've lost a bit track recently and the wiki changelog doesn't seem to
> >contain much about how things went on at the RAID5/6 front... so how're
> >things going?
> >
> >Is it already more or less "productively" usable? What's still missing?
> Well, you still can't even check for free space.

   You can, but not with that tool.

https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools

   Hugo.

> ~ # btrfs fi usage /mnt/data-raid
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> Overall:
>     Device size:                  18.19TiB
>     Device allocated:                0.00B
>     Device unallocated:           18.19TiB
>     Device missing:                  0.00B
>     Used:                            0.00B
>     Free (estimated):                0.00B      (min: 8.00EiB)
> 
> btrfs --version ==> btrfs-progs v4.5.3-70-gc1c27b9
> kernel ==> 4.6.0
> 
> 

-- 
Hugo Mills             | UNIX: Spanish manufacturer of fire extinguishers
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXT/3dAAoJEFheFHXiqx3kYI0P/1aY/QwVC6GRl/QtTF5VXx4q
nZies37xL5RO0v2/u2vKQw9riJvX5PQUlZOVBBlIri7xa5Km3T09qevQWD9ol12h
GEwnr4h/j3dYhUt9vrhsGoRqb1RBo+X0+bwVzn0Zars8fcyhMurbrb1aM76AmSSm
y+HWcNvRCmIAUE22ManR6Ihqvur8shd8mGEZPQmURJBGBKa+o/ZzQN4tjDEDxM0I
b5A2tqNMRXz1GYcMXbW0ReaI+3ze7z7X+yQethXKhFZSjY5JVJlqUSU8kh1MommG
6UKk96WlrY2T1yXzQqHxa46XJU34IcXxcc/rOwfGrNMKvJK9EiGxXnNDzbgKGrxZ
oP+BnDnEwifzYBQ9P4EJdtE7yAe7e4QmBzmBbqlD69dVTO2E/xTyeVwxTslnpy+X
VCg0rrF66FdXsNaD9l3GBF4p13GEAqZivUl1NhGsnET5p8Quf6MFYkd8/2pFWW6j
A3noFd4ipcalwDbQQR5OiJI5xboiWjRxSWzswbXQ+4ka076ecBhhSWUeEa7HNmUE
fPLcTRODkykqu7ybyYF+cJRrcnzrW5WjPiJDsP++6HvNjeqBllzRqXHe/NVufkv5
rreISQoINocHUrJSyPtiflco74fly2YeU1w99X4JyDCVXea3SiIHwWYbof7Vfcdn
MZNkEAGHaFmQDdLW94Tu
=gIYR
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
