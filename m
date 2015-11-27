Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38692 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbbK0UnH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 15:43:07 -0500
Date: Fri, 27 Nov 2015 20:43:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS: could not find root 8
Message-ID: <20151127204305.GE24333@carfax.org.uk>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V9E4GD/88frki9uz"
In-Reply-To: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V9E4GD/88frki9uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 27, 2015 at 10:33:29PM +0200, Imran Geriskovan wrote:
> After upgrading from systemd227 to 228
> these messages began to show up during boot:
> 
> [   24.652118] BTRFS: could not find root 8
> [   24.664742] BTRFS: could not find root 8
> 
> Are they important?

   That's the quota tree. I don't know exactly what's happening, but
possibly systemd is now enabling qgroups for its own purposes, and
what you're seeing is simply the qgroups being enabled for the first
time?

   Hugo.

-- 
Hugo Mills             | Great oxymorons of the world, no. 8:
hugo@... carfax.org.uk | The Latest In Proven Technology
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--V9E4GD/88frki9uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWWMBZAAoJEFheFHXiqx3k53YQALJ0SbPs9QuBPwm/A0M1fm/M
ntYebZN6+OBwMZtNcmqpW0XmoqmONwhOdJn2B1MEYnGaqKDjN9mZ+TIDjRgdMxaJ
Wv5NfPTWb9QZ6k71sgNFX8mMx2QpIBLshKDm2+EsJAaAtwLuJoKZuhilORTrC9uU
kyFpf8yb6Qo+JEDEcxovnIjXz962rNyViuEIYoYpkfJIpg/2R2ZWJSeE+/wUOEQr
XNwPXe1YSzorzd13NDy2dAuXQGnNRLiLt5OQ9ZGAHwsNLcHFfw/BxakUQhD1eJyD
AHDddBAR4JLfXqbJohuubOHiD7B8zvMjaH7iPq9SmJi2/E9JYz4ZxxTQT+AYhBgW
H8uijuK4D/4Xu1kDliLZK9JyZ/P7aOqVLKXwV0QzTtHMZBbUv4jvi6RLijHD8M4l
pL4C1GzzxYh+pNrVwwMJ4JYAtBavr983HwZjwAx3KEmtS8yFDetdFDR1FPK9k+Fx
6Cj1b4BVKUtzb68+ppXRlGFHOEqtoetmIYKRvc6M2bskglwTFY+mbVUDjuFnCQFo
Pc2K9kInwsPfdTpMS6o6kcKfkDhtg5ePEK4wFMd1RsOpn5M8iaxOVFT8nAUMvPcs
tzQA1kJeWPJ/QsZIVIkbeQ5lzSzgdn7GryYz4JSqXKMLniDJvKBGt0bSnRatVT9i
xeAGwrwPyBId7mMg9zlf
=zJNw
-----END PGP SIGNATURE-----

--V9E4GD/88frki9uz--
