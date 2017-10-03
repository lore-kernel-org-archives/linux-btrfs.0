Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46291 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdJCVLX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 17:11:23 -0400
Date: Tue, 3 Oct 2017 21:11:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Stephen Nesbitt <snesbitt@aussieswithtails.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Seeking Help on Corruption Issues
Message-ID: <20171003211121.GF3293@carfax.org.uk>
References: <c67167b4-190b-dfdc-33a8-8cb75a4744ef@gmail.com>
 <20171003201047.GE3293@carfax.org.uk>
 <CAPXGFsE4HzGWhjKtp=E-4LN_-vQnFtqJDDhTva9Wkg9Gtm9D_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yH1ZJFh+qWm+VodA"
In-Reply-To: <CAPXGFsE4HzGWhjKtp=E-4LN_-vQnFtqJDDhTva9Wkg9Gtm9D_w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yH1ZJFh+qWm+VodA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Stephen,

On Tue, Oct 03, 2017 at 08:52:04PM +0000, Stephen Nesbitt wrote:
> Here it i. There are a couple of out-of-order entries beginning at 117. And
> yes I did uncover a bad stick of RAM:
> 
> btrfs-progs v4.9.1
> leaf 2589782867968 items 134 free space 6753 generation 3351574 owner 2
> fs uuid 24b768c3-2141-44bf-ae93-1c3833c8c8e3
> chunk uuid 19ce12f0-d271-46b8-a691-e0d26c1790c6
[snip]
> item 116 key (1623012749312 EXTENT_ITEM 45056) itemoff 10908 itemsize 53
> extent refs 1 gen 3346444 flags DATA
> extent data backref root 271 objectid 24999978 offset 0 count 1
> item 117 key (1621939052544 EXTENT_ITEM 8192) itemoff 10855 itemsize 53
> extent refs 1 gen 3346495 flags DATA
> extent data backref root 271 objectid 21751764 offset 6733824 count 1
> item 118 key (1623012450304 EXTENT_ITEM 8192) itemoff 10802 itemsize 53
> extent refs 1 gen 3351513 flags DATA
> extent data backref root 271 objectid 5724364 offset 680640512 count 1
> item 119 key (1623012802560 EXTENT_ITEM 12288) itemoff 10749 itemsize 53
> extent refs 1 gen 3346376 flags DATA
> extent data backref root 271 objectid 21751764 offset 6701056 count 1

>>> hex(1623012749312)
'0x179e3193000'
>>> hex(1621939052544)
'0x179a319e000'
>>> hex(1623012450304)
'0x179e314a000'
>>> hex(1623012802560)
'0x179e31a0000'

   That's "e" -> "a" in the fourth hex digit, which is a single-bit
flip, and should be fixable by btrfs check (I think). However, even
fixing that, it's not ordered, because 118 is then before 117, which
could be another bitflip ("9" -> "4" in the 7th digit), but two bad
bits that close to each other seems unlikely to me.

   Hugo.

-- 
Hugo Mills             | Great films about cricket: Silly Point Break
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--yH1ZJFh+qWm+VodA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJZ0/z5AAoJEFheFHXiqx3kQBEP90j4Jmrpzq6HZwIfj7WijS7L
cA9HpWmEyeTk+1JI6uylSPTqPGAGHpebXMxXs0IbxiHYune+Vur5d9VvPS8eXzVS
El+8rtMyI9M5g7hkwgm3rreXdyDlpIBEOajze0CeEAyiuU/tYiGhnc2RjRc3g46h
VmsNgOCpVpO6og2hWqCa1zfFUKdfz+bTiUwPmpNjzrhivIw2Xxt+jR4NWrD5zeyQ
9YW8rzKPfKv2TqAKbYrLh2cJUSlKMSAkWTwYXFb5yIexjFZWp0TOJwzqweJOQ8zP
3at3qMKNYh1nu2cg+rkiTnbRxvQIAmo7IRLCzQL/RnrJy0HOLf744OFNGZ+ttTmB
cC1FxaxmvrEABZndiBdkKhjlvZt9iFljEzVv1r57ltaaCixZjxaK6DJxT5uyfew0
onUXHnzw5v3eF4GhE77CHZUne6LYmkvXbSJ8IjvArKyNKJQYNVQm5x9VeD4UvUNA
uzgE5kFafLuNTZLW36sDm2Fzs4/QbX8NQ4LbNOSIW99D7yy0C6ZuqFDKO2xKQ46X
gD5XfonMFW+mXzQ+FrOeHloZ/GsF6zMFIOZhfemZtHEZNHXmupNu85ceGsppSvKq
UsXjHGC7w8wDSH6JLSc5M0+cn+kzqKysnokAbqNm7tMd3ojRwKFQ5akGOld1viKV
JdmSIcx4G7r0YgaHFzg=
=dIfP
-----END PGP SIGNATURE-----

--yH1ZJFh+qWm+VodA--
