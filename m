Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34696 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaKXU6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 15:58:30 -0500
Date: Mon, 24 Nov 2014 20:58:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141124205825.GX32735@carfax.org.uk>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <1416859665.3019.6@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ycl1UgPPPgGZoSL"
In-Reply-To: <1416859665.3019.6@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4Ycl1UgPPPgGZoSL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 24, 2014 at 03:07:45PM -0500, Chris Mason wrote:
> On Mon, Nov 24, 2014 at 12:23 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >This brings a strong-but-slow checksum algorithm, sha256.
> >
> >Actually btrfs used sha256 at the early time, but then moved to
> >crc32c for
> >performance purposes.
> >
> >As crc32c is sort of weak due to its hash collision issue, we need
> >a stronger
> >algorithm as an alternative.
> >
> >Users can choose sha256 from mkfs.btrfs via
> >
> >$ mkfs.btrfs -C 256 /device
> 
> Agree with others about -C 256...-C sha256 is only three letters more ;)
> 
> What's the target for this mode?  Are we trying to find evil people
> scribbling on the drive, or are we trying to find bad hardware?

   You're going to need a hell of a lot more infrastructure to deal
with the first of those two cases. If someone can write arbitrary data
to your storage without going through the filesystem, you've already
lost the game.

   I don't know what the stats are like for random error detection
(probably just what you'd expect in the naive case -- 1/2^n chance of
failing to detect an error for an n-bit hash). More bits likely are
better for that, but how much CPU time do you want to burn on it?

   I could see this possibly being useful for having fewer false
positives when using the inbuilt checksums for purposes of dedup.

   Hugo.

-- 
Hugo Mills             | That's not rain, that's a lake with slots in it
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--4Ycl1UgPPPgGZoSL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUc5vxAAoJEFheFHXiqx3kgvsP/A+dfVbHuB6XwCrMHMvA6qwS
5a9eaK8vQivKU0kk97V1ILt9SnrLeGNrx7hi6ZnXO2cC5Qa3zzJr+VUcwe5tXvdi
+WAlgMI0SJ/IyiJU2ZqbbY9U1O3+NwFfb90VtM7ZXiYMj3Ixcg8oSiu4+CuQj7Ml
MpAHZyYplCFUMJEyO0ExMCi/4LJfQsEreNz1yoxOPFDz2mWz9VrbUwFZ4+TDfCkt
jjzsy2gxv1zXPh7YW3HsHqy8JX8ZfbZz0K2JR7+6zxvBgnIg2wks60VpsZjquLqM
uzjCdbHbl2ZfU5I6GuYZheNPXQS6m6jbNOlF84l+MN5vekoByNgr9goEYx1UjgTY
oOy3MOftCedeDxOABhvMXa8M2yqlVBEsVt/GybtYuKVK9vSzoKUzRe/6UZ6xiagt
7ToaV/pEm+0fTlWTtOfvBL6mGYtb6In8izIXkggGa7viuUt8t/XH7EZTGoYnitK2
CCeXskP1zjBXOE84RbGK8FifTeDlgiFKeVQduAwLlzQAJM/QHDc5XDjOhw6GhRgC
RDAuSpv6w1GNOFFLzwsQypoqUjiXwLuowjJRbKsVf9reCJQebAsIV96SIG96jArD
DVdo4mCtzoFHG5eigEO8nJWIyEt77J+/rEPw+/iUs5Y6Hs0ZHxNMKlpBg29OJDu0
q7jmcTPqnobP+GrveU7j
=woRW
-----END PGP SIGNATURE-----

--4Ycl1UgPPPgGZoSL--
