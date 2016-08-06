Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54261 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbcHFUpu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2016 16:45:50 -0400
Date: Sat, 6 Aug 2016 20:45:48 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Determine the creation time of a root tree
Message-ID: <20160806204548.GD13790@carfax.org.uk>
References: <CAMG9ccwBF4x+f_y3QFqsYnjDFX=CwQm5ktqpLD5EbQm4jdfQzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
In-Reply-To: <CAMG9ccwBF4x+f_y3QFqsYnjDFX=CwQm5ktqpLD5EbQm4jdfQzg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 06, 2016 at 06:11:58PM +0300, Ivan Sizov wrote:
> Is there a way to know when the root tree or generation was created?
> btrfs-find-root doesn't have such option.

   In UTC (or similar wall-clock-like units)? Not easily.

   I think you'd have to do something like look at the modification
time of a file, and then find the latest generation of any item
associated with that file, which would give you a time/inode pairing.
Do enough of those, and you'd have some kind of map that you could use
to approximate the time for a given genid.

   Hugo.

-- 
Hugo Mills             | This year, I'm giving up Lent.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXpkx8AAoJEFheFHXiqx3ktXAP/i1/2UgBEICcPD0HE1mETfXO
Cf5LRyS+Gjq56VXqD9oyMCKFt9h/UdB8PnsTAzOWtxmIBiLlfpiF5MBiD3m2TlQm
KCpf7NixMINoTPxdUSylMyv00BfUM9JTAy/+wBYnqQ5Frz0LISSJBq1dbE6Gx2iu
t2do7oLU/KV/qt/We78K0s6rQzJzM4d+azL8PwVHNA2OAskG6xAyBWj6BjSUV2mI
aC04giNxugMr1oPOunp0E/euWMUJrlQcJyvPuMnA3iW536bNhKqYuP4vMyAxlSVo
KItEFD15EsUgEYtkVmRfU6aGJxY0vw64qoGIWfK82f98pmAoCUV+tgPAcOijrHTs
sFeJGbVlfvgLa+2fiKf0R/C7TkhAXfJLnag9QeK95tqrHeUe8KoYZwsd+j/UIO1n
TOPocbr/CxLG4Ro9nFHgQYBKVMV2C4Gqj54ZWHqBJKBvBLSoBxpb+5WCC6jIqtzY
MPkqLe/gXue++4qum+VUwB+ABxhVopQOePH+SD32kSWWj+RQM2Y02ZAHic00U04J
4QoHZlZBxDpJChUraB9bIJlhgNHmZNJT8QmGeU6vc/bHffs1+APab2lMUHKJZJD+
EyDCs5onSYLZwjp8Tq+Ke3AjieA2ScMHNykxqKJw/JWhdeQuRlE5FHWJz64KSmnj
BuAlGc97yE4g1JPQLMc9
=AEZZ
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
