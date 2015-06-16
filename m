Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57331 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbFPNYe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 09:24:34 -0400
Date: Tue, 16 Jun 2015 13:24:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Automatic balance after mkfs?
Message-ID: <20150616132433.GJ9850@carfax.org.uk>
References: <pan.2015.06.16.13.13.40@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdJFN6SSISdF2ksn"
In-Reply-To: <pan.2015.06.16.13.13.40@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sdJFN6SSISdF2ksn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2015 at 01:13:40PM +0000, Holger Hoffst=E4tte wrote:
>=20
> Forking from the other thread..
>=20
> On Tue, 16 Jun 2015 12:25:45 +0000, Hugo Mills wrote:
>=20
> >    Yes. It's an artefact of the way that mkfs works. If you run a
> > balance on those chunks, they'll go away. (btrfs balance start
> > -dusage=3D0 -musage=3D0 /mountpoint)
>=20
> Since I had to explain this very same thing to a new btrfs-using friend
> just yesterday I wondered if it might not make sense for mkfs to issue
> a general balance after creating the fs? It should be simple enough
> (just issue the balance ioctl?) and not have any negative side effects.

   Mount, balance, unmount... You can't balance on an unmounted FS.
You'd also have to write something to the FS (see below).

> Just doing such a post-mkfs cleanup automatically would certainly
> reduce the number of times we have to explain the this. :)
>=20
> Any reasons why we couldn't/shouldn't do this?

   On an empty filesystem, it used to throw away the RAID
configuration, which was identified from the existing chunks on the
FS. With no chunks remaining, the RAID configuration reverted to
single all round (IIRC). I don't know if that's been fixed since those
days, but it's something to be wary of, at the very least.

   I've added the question as an entry to the FAQ, anyway.

   Hugo.

--=20
Hugo Mills             | vi vi vi: the Editor of the Beast.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--sdJFN6SSISdF2ksn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVgCOQAAoJEFheFHXiqx3kL8EP/ifrppYyU0ITyvEB5rJOmD6E
2YDPPiFRy5mnnEw1QdyYkOJRlJMe5WbDElEHPzfRPK+qdubF5C01cPKe+PqlasVn
HGN20SUw1nRj8IIibNRivKyzMz/Y3RTuRThfQWzEbWmKbl5qJxOFF4WzhbPUak2b
4UIDuWaGnBl7xm9nqK3SQZapic6IOfMV7/OdWrekHwxC6IvtPUhumSn0OOYH7hzL
U6kmzQPwIkbwVnI5WgXRwXcSnTT+sElTt1oSLG8BLCFhmYcowkBFpHjkG29HT3wx
dJWlxGESh+oFAkI9UDwIMzNuZNvoXCyBJ5T6wKgbBbHWQ7xqf6UPGIQwI4BEJPlI
yToSK1vRCcB5nrbOtEgwbbBUZAH1tWVNvagbJKTQjUvyO6zmHb8a78C47ctUHiXS
b4QCKNcy5R4rvuQYsadFB6mL+A5HzpIUlgldxvcwds8XPCKBrrFNpdw9VsuxyvSe
7ThbRYMEzgqnr8y/EAAlRVdiLPf47i7WIR0ZLljVV6OQSqFfWo01oXr5XjUI3Ff5
piGalfkzBfULPuSQbuitZehnyCBJ4ABOl2IkKUEOX7CzENfXvBW2NHC7qe1UxXYl
JuX8uYwT8VvN3l7k+JSZZ07XHrTjHTNRNHE6LnNEchGUlOJHLQMMcdIi/m/7UuTW
jUhwVZ+bZlpMU9JZtZ7S
=Jkxi
-----END PGP SIGNATURE-----

--sdJFN6SSISdF2ksn--
