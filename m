Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53164 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdGYNwH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 09:52:07 -0400
Date: Tue, 25 Jul 2017 13:51:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?H=E9rikz?= Nawarro <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid assurance
Message-ID: <20170725135146.GM7140@carfax.org.uk>
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QPZaqi6af6gbSrAE"
In-Reply-To: <20170725134656.GL7140@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QPZaqi6af6gbSrAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 25, 2017 at 01:46:56PM +0000, Hugo Mills wrote:
> On Tue, Jul 25, 2017 at 09:55:37AM -0300, H=E9rikz Nawarro wrote:
> > Hello everyone,
> >=20
> > I'm migrating to btrfs and i would like to know, in a btrfs filesystem
> > with 4 disks (multiple sizes) with -d raid0 & -m raid1, how many
> > drives can i lost without losing the entire array?

   Oh, and one other thing -- if you have different-sized devices,
RAID-0 is probably the wrong thing to be using anyway, as you won't be
able to use the difference between the largest and second-largest
device. If you want to use all the space on the available devices,
then "single" mode is probably better (although you still lose a lot
of data if a device breaks), or RAID-1 (which will cope well with the
different sizes as long as the largest device is smaller than the rest
of them added together).

   You can see about the disk usage in different scenarios with the
online tool at:

http://carfax.org.uk/btrfs-usage/

   Hugo.

--=20
Hugo Mills             | One of these days, I'll catch that man without a
hugo@... carfax.org.uk | quotation, and he'll look undressed.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                   Leto Atreides, D=
une

--QPZaqi6af6gbSrAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZd0zyAAoJEFheFHXiqx3k9YAP/RcPKubQsKnzzYZUz9XzhmfR
5Pe98jCrMAoLgxBO6/o/h8VcbwUI9gjofDBzfnHvDdhPkxx7ou0Cx3SngZzieQxX
NLH7Odr5yifU5xqzYT0PtzA8eZ/R9d7Cwmm+qlz4D3U1o06tTy9ymyHKQ1MHeGOC
OAOWXXC7BWnD9TR0s/14zLM+AEE0RHBnW720xuCrLLG+HvLnKHYLtKxAI2Kyv3Ij
OmgmoanqBJaCRVAPC2dytooYBqBMH8vWd8IbWyAeW9zvEOe7Wo2HTgkfyeeax9vY
yF1fSiB5b4QTSpBSy56Ilh4IIWWWEr4kmnBRMQeSrQbODEh1v490fWSbW8wW4m8u
WXxGDWCozYb9ZbTzW+Jv+9wCQfOA8DDFlYtUbE4lSTjZNcCJTfKRNLcbeB+yKAZr
UfRKGVVG3o1EpaGs0eZu1kMvAZZeFKZd5FXySrvmBgs4VMCF0W+U06z8GLSQxlJr
t9PXq3119yLW9ifXmxm4yQXIBnj6HgqF6F5H+wYfc6SOj024uZWzATo8GI2xlUlh
q5S2E0qpZ8tgL8l5yw9WqfgDrCYtRpi0YNTgtA6qyai2KaFHbJ8jnFaZTAXAy+6B
rcu01R6i88GjqH4BudV6pyp89T1mtjc3d1xf1bNYpVRj7NFVL6Ll+q/xlcwPcR5m
gHsGLFLW/96IoCk2D+Yz
=T8R/
-----END PGP SIGNATURE-----

--QPZaqi6af6gbSrAE--
