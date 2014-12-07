Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54104 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaLGSet (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 13:34:49 -0500
Date: Sun, 7 Dec 2014 18:34:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: ashford@whisperpc.com
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Message-ID: <20141207183444.GA1442@carfax.org.uk>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
 <44320137.fRRuR6EFMP@merkaba>
 <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
In-Reply-To: <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 07, 2014 at 10:20:27AM -0800, ashford@whisperpc.com wrote:
[snip]
> > 3) From what I gathered it is planned to allow different raid /
> > redundancy levels for different subvolumes. BTRFS can=C2=B4t know
> > beforehand where applications request to save future data, i.e.
> > in which subvolume.
>=20
> Same as above.
>=20
> If a user will be requesting to use a specific subvolume, it is up to them
> to verify that adequate free space exists there, or handle the exception.

   OK, so let's say I've got a filesystem with 100 GiB of unallocated
space. I have two subvolumes, one configured for RAID-1 and one
configured for single storage.

   What number should be shown in the free output of df?

   100 GiB? But I can only write 50 GiB to the RAID-1 subvolume before
it runs out of space.

   50 GiB? I can get twice that much on the single subvolume.

   *Any* value shown here is going to be inaccurate, and whatever way
round we show it, someone will complain.

   Hugo.

--=20
Hugo Mills             | My doctor tells me that I have a malformed
hugo@... carfax.org.uk | public-duty gland, and a natural deficiency in mor=
al
http://carfax.org.uk/  | fibre.
PGP: 65E74AC0          |                                     Zaphod Beebleb=
rox

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUhJ3EAAoJEFheFHXiqx3k/JoP/jUCxkGi3SGqFH3Onx9iUu1f
dNHPrWFU06X89OjQal7du+kxGHro3eR6WyYBbfuJQq+I2RBEhy236VCPAzVcIAh0
Praw++1DAyie7KUCB2CoaIwe4aBnk6E8IwY/EFvromQAppBVazbZDs1dE04Ds1Zq
ms0fgRQ6e3+KpR6qEr9CuQ3z9e1B6Xo782orOOcp183XcobHuNCtd1Y1LqJ38C2E
+ZJE1WFF4RPZlJY0QrOxHfKxy6+IdSbiyHc9NX9RaIqjiu3RN1wsutVPGq6nPX8H
BPYqyAGzYa0NBpeh6yKSI/YVxMaEM9UuD3LvbiN1p69v8JDNnxHisiOmk6Iu6f7J
o6ZiOYzrZ33wpj2VI7cy+ML8StiU0M2rTLD4SdU42A96bjmmS+FkjtCAHb3UGAt8
KAnROBlY3eUUZBbeJQ005X+A5lsIxA0Yvo/akxB1ZgzG7QKl6bxuynINvm5PdnYk
GLmG+/PEPHPxc9kp4fF9ReajufYhprcYpJt3jx3klSOonrja353qveoR8FWRIfDG
fdpM8JYx8JaCOjGqDYxVsSlRlqj+1gokPPZOT1+5baX25n97b6EBvG6wF8nP3o4A
soodpgLjHiHgdqGzc3ga5C0gTIqVAaYyIC0hbfQX3yXJaXc/klWQ7D5nVkLh6Nu5
1l3+3kvLjE0FErrBQqYv
=Li+t
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
