Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43826 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbIOUiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 16:38:16 -0400
Date: Tue, 15 Sep 2015 20:38:15 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Csum I/O Error
Message-ID: <20150915203815.GC28645@carfax.org.uk>
References: <CAGqmi77Y3qiEs7aVwXQ-VT9b0yF4ViAA1szMicY5_GEXQaRYVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
In-Reply-To: <CAGqmi77Y3qiEs7aVwXQ-VT9b0yF4ViAA1szMicY5_GEXQaRYVw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 15, 2015 at 10:59:48PM +0300, Timofey Titovets wrote:
> Hi list,
> i've catch a io error, caused by csum mismatch
> Can i force fs to read data?
> This is really not a cool, if only way is use btrfs restore.
> 
> #Info vm machin, after power failure get 2 blocks with errors, and one
> mysql table, can't be readed by mysql (and also, i can't just dump it)

   The data is corrupt, or at the very least deeply untrustworthy. At
this point, the easiest thing to do is use dd_rescue or ddrescue on
it, which will skip the unreadable sectors and replace them with
zeroes -- which is no worse than the random data you're likely to
encounter from reading the broken data that the FS is (rightly)
protecting you from.

   Hugo.

-- 
Hugo Mills             | A diverse working environment: Di longer you vork
hugo@... carfax.org.uk | here, di verse it gets
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV+IG3AAoJEFheFHXiqx3kJwkP/jGOduIVn/4WVBlD8NQYBplP
HWtR6QWI4qDzxpkcyb1goFK4YsKtR7PPJ8YRRFkjwdBNkh+cUfRlOn1HjxsYYN+X
v/L/0AskwNTzm/jAo0jlfrmThzmKkmZxTjvqps0Z9ahVZPFW0aZXCUlBDjTAsXKU
zWFJ+Wp4jXU+ctQt38P7QlUhdMDXJ1PIqbSgENIzkZ17mzwKaYsGlGlB8hBfsBuK
j7Ylg06UNcxivXnYLJ9xp8p+NDP8VZpIzx+3o6GlucgAe8B5s9vjS9kbNOe6GBMX
kURfc4NGyK1u8Xq2k8Z6PaUFmYkqQkMPAQh1vHOISooyhBpULVkr/41rQxIgy9qu
DMRWwAUdzhaJ/uN/GICNHF6pdNYn9XdNkbQ6eJVfQHpMBxOLCOH1KjdZDUHCpXtt
KiTWShfvHGqoABAXrOlsZ+J4dieyFSa4l8ZUQ+mMCv3YMlkm+23rwqGYxPXOA2JU
jUUTJAlxqgF/wHG3r+b5imIDUxBB/ZjdL7MWpSkdbsRVLiRAzxvho6HFxIxcjlO+
QCBwyaX9jupk4n7dIjX7xdS7xbVFrvLF58l6gyluT40pm5jUxCcZPEuqfsTtNmWD
PmSqRtL0KwOsefDXfchHgnN57FavvAnHaYCzYiQ7RDif/WqHygOdEkfxqVq9dMNj
BKjE/Iii0OlhKnVqmcgR
=WTjf
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
