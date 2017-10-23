Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wolfsden.cz ([37.205.8.62]:44848 "EHLO wolfsden.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751113AbdJWUYG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 16:24:06 -0400
Date: Mon, 23 Oct 2017 22:24:04 +0200
From: Wolf <wolf@wolfsden.cz>
To: ein <ein.net@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scrub doesn't correct coruption
Message-ID: <20171023202404.bdxvjw4hc3bahym5@wolfsden.cz>
References: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
 <59EDB66B.9060209@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mx5bm5hxseazvo3y"
In-Reply-To: <59EDB66B.9060209@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mx5bm5hxseazvo3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On , ein wrote:
> On 10/23/2017 10:39 AM, Wolf wrote:
> > [...]
> >
> > Is this and issue somewhere inside btrfs or is disk HW related problem?
>=20
> Highly unlikely hardware related. According to SMART and dmsg, there's
> no indication which would suggest disk failure.

That's my thinking too (and the reason while the disk is still in the
array instead of going back for warranty), but since the scrub failed to
correct the issue despite saying it did, I'm a bit curious what's going
on.

W.

--=20
There are only two hard things in Computer Science:
cache invalidation, naming things and off-by-one errors.

--mx5bm5hxseazvo3y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKUV4RjubkPramXVZs4umGUJTxRIFAlnuT+QACgkQs4umGUJT
xRLglg/9FSe5JLdygGynZI7mQFV6HLHVhSLAu347NH8EgK3II8LnMfdCPZdDPgJL
AuLTM2oqvVo00imOfswb75f5+ys9UvS/nUSwdx1ccvC6YGP83Yspe73jEsR7clE5
qpqpqXfFVRG7qxra5j2nhYbS8Fp9hgbhxsO0FKX7mCJ8R0mNjIIpskXvxwZ3Mp1l
Jl62B3iZMOamkRN3TIDyflw2Jjq/3eWu97KzvKP/aybu6vNxY3iQmTYtjbfbSZcM
Q6cSqMNHWmPHfZXXw7e9IqSGKF6wBA9sxiM4zmfDeKCjylT0GzOWc3wOBSGzC3F9
sGJjkFF2txyZHSE4mR3k5Uqf1/FW3i+SscluTato9dCxsvpOMIjOT4fM5ifdKQN1
iTYIy5E8GdFVSfSe0zUenfaL931bTHpp+21V4ymhzRGNTWi3vKZ4ck9xEk8HI8y8
NHgVX9F4Eblh9DsEWfTRGEg7cNKEm+2jVJLBlB9bdGj70GFbIu/xNyce0aNK6ldc
hFdvNErfhqWS7g3Xgxw+Is0vk4AqiZn75x3xFyMyyJLWpGgsOB3lrFzD7ecEG5/m
1xW+WsQyQAZOFn0i7OojFpPlfjdUvRa3RoncezfoiecvXt+5wxBOKm2RKKFAzPjy
46lchmKgaVohbrtIFXfNZF7lrW1LewsInUsDgozo7l2BLOZbOLY=
=orvz
-----END PGP SIGNATURE-----

--mx5bm5hxseazvo3y--
