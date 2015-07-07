Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38507 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbbGGPuP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 11:50:15 -0400
Date: Tue, 7 Jul 2015 15:50:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: David Wilhelm <thefeshy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel crash on btrfs device delete missing
Message-ID: <20150707155014.GF10539@carfax.org.uk>
References: <CAKhV5s4=WR6t35Vo0JWekMKiv2ZOJF-py4sVSB4THZNd7cOe_Q@mail.gmail.com>
 <CAKhV5s4M4fKgm+ZkCZHQL8QK20Oq19Nkj9CKOncjvFQbweY-Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8PhoBjPxaQXD0vg"
In-Reply-To: <CAKhV5s4M4fKgm+ZkCZHQL8QK20Oq19Nkj9CKOncjvFQbweY-Eg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p8PhoBjPxaQXD0vg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 07, 2015 at 11:45:56AM -0400, David Wilhelm wrote:
> Additional things I've tried:
> 
> btrfs scrub completes without errors
> 
> btrfs check runs through to cgroups without issue, then takes 100% of
> CPU and runs off with it.
> 
> btrfs balance has exactly the same issue as delete - many warnings
> regarding delayed-ref.c, followed by these two errors in extent-tree.c
> 
> http://pastebin.com/dNwGsy8j (linked because gmail seems to insist on
> word wrapping)
> 
> Where can I go from here?

   That looks like the kind of thing you need a developer for. You've
already reported it here, but sticking a copy of what you've
discovered so far into bugzilla.kernel.org may help it not to get
lost.

   Hugo.

-- 
Hugo Mills             | "I don't like the look of it, I tell you."
hugo@... carfax.org.uk | "Well, stop looking at it, then."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Goons

--p8PhoBjPxaQXD0vg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVm/U2AAoJEFheFHXiqx3kq28QAJOn7skeG2CFFmyF+IHW5QVy
f13Zf0yuR98MJxsx9c1m89Wau+pHfDI9yVXN9CPHopHGWqneDfRWyF7YxS+QpVw7
4x1cD8pB3OzNEJAnjZlhHUsflWnUOtuX7KJsXZESecMsLo13b09HMiUIYaFfUnQ/
pXJjI9reyraMyM/MeP7qGflhkVDZapCKKSzajlH9lRaVE5vlm5zLfQeUYVFPqCwA
P4REsFrfna54sDx1QyuMii2N6kk4Pe9EKHR2wobumnxDwlU7786YBPBWBcWAcZA5
aGwwjNVsHsfQ0Yn0BUpZor7IB4wefNLxicHTGhLw0XGEMKv/AC/cDONHZ7HkmGq1
oBGcZ1qjYdH65I6O058jxFy28OfnT7Q7EWNcd0RgJvf5L0SUkDhTXdChOjvdY323
uqGj85Ju0tu77HMSW2dGUNDeL4eViEX5ru9XlnL7TNftXop8uf9ebYvc/qlsGdcW
RgB9+8XggTdjlNnkTxuSPrjkiZqVm0mfcvytOEux9zuOBXk3yaTzeXAeu3JTmYOx
bQCEOoC0EZ+w62Dub/r/RcpfXFmpwSKCTECKt6u08Azt7aqnKf+CTbcpANIiPKtp
VFIxwTWar/iA5s2Lesxxf+ZdVKxfYYmYy4Gu1i/Av9z2n8rVGh6uKexRO/zRwiwD
zNpIO9g1dFtkQdezSzI4
=GdJn
-----END PGP SIGNATURE-----

--p8PhoBjPxaQXD0vg--
