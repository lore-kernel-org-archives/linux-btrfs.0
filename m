Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36727 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbKSX7c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 18:59:32 -0500
Date: Thu, 19 Nov 2015 23:59:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: anything wrong with `balance -dusage -musage` together?
Message-ID: <20151119235931.GH24333@carfax.org.uk>
References: <564E60FD.1010801@lukas-pirl.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ch6x/diZ8cQC324S"
In-Reply-To: <564E60FD.1010801@lukas-pirl.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ch6x/diZ8cQC324S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 20, 2015 at 12:53:33PM +1300, Lukas Pirl wrote:
> Hi list,
> 
> I rarely see balance used with -dusage -musage together, esp. with
> values other than zero.
> 
> The question is, is there anything wrong with running (say) `balance
> -dusage=50 -musage=30` regularly?

   Nothing actively wrong with that, no. It certainly won't break
anything. It's just rarely actually useful. The usual situation is
that you run out of one kind of storage before the other (data vs
metadata, that is), and you need to free up some allocation of one of
them so it can go to the other. This is typically too much data
allocation, and metadata has run out (so -d is more often used than
-m).

   For the "usual" case of running out of metadata allocation, you
don't actually need much space to reclaim, so -dlimit=X for small X is
an easier approach to use.

   Hugo.

-- 
Hugo Mills             | Questions are a burden, and answers a prison for
hugo@... carfax.org.uk | oneself
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                          The Prisoner

--ch6x/diZ8cQC324S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWTmJjAAoJEFheFHXiqx3kkUUP/RkQalLkw52exve8JSOnhI0p
wYMbW6gOzm6Mdh0CpyPULVKbLYfTDDxZl14yV7iRj3T2DgQK1a3HotJBCiA1ppvd
E6D88dpnIkpQEVWFjNDuGNzJYk6pSi1TeYdr14/CYVnNReQtePNENFL1yGGUig2O
QDd8jAb6WMuu7FvEujGNzFSdOx7sbn6NQfDb0ExfIvdYVa+asaAQeFJkIHxv+wr0
J3hD3M3jrkZdyed0xoXMmxdo46mel04naxlgbPxuGolByQYdCKBiNQFZEdXp4Noe
OOXYdqA+Osxdrk5Stis+EMz/Kjg0m2tORfpsWL6/+z5APQnITqzaVC9oQsquGsuM
LyXp35TLGhdadwPXcuXOCvVQWx45s0Yz5ySB4ohwcMl3ei7koRQTYX1mF7RSkqnh
RwEDcFXi7p2iUIGoFKKGbeJiXZvTw14XHhzz/YzmaqUWfTiRZPQ6l39aeY/V+wAr
hQAWzQjzg2ySHvPjwOBGlHPPXFW6KUKEKI63446M05i7kkn3cwJvnQtPS6wtqXXx
HSmEYADX8gPc7d1Twr6tKi1U4388nXdEB4a2yP/h4asbFBPEkmR3L7MZ3t0RpJ+z
Ao3I7S52OSqlWUSU8qJclD89Wz2qZXnTaiQkDsGdJbMw+DMBrHgYofUQT3lhjYAg
z6EuHU0NAppv8z/AQfaz
=HSdO
-----END PGP SIGNATURE-----

--ch6x/diZ8cQC324S--
