Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kim.monte-stello.com ([91.121.114.170]:38888 "EHLO
	kim.monte-stello.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2IQU33 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 16:29:29 -0400
Date: Mon, 17 Sep 2012 21:29:23 +0100
From: Antoine Sirinelli <antoine@monte-stello.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Oops with a "degraded" volume
Message-ID: <20120917202922.GA14962@speedy>
References: <20120915141737.GA4784@kabis>
 <5056C728.40606@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
In-Reply-To: <5056C728.40606@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 17, 2012 at 02:46:00PM +0800, Liu Bo wrote:
> On 09/15/2012 10:17 PM, Antoine Sirinelli wrote:
> > I have experienced a very reproducible Oops within the btrfs driver. On
> > a linux 3.5.4, if I mount a volume with the option "degraded" because
> > one of the device is missing, I would get an Oops when I unmount it (or
> > even before). You can see attached the kernel log.
>=20
> Thanks for the report.  And this has been fixed by
>=20
> commit 99f5944b8477914406173b47b4f261356286730b
>     Btrfs: do not strdup non existent strings
>=20
> You can find this commit in 3.6.0-rc5. :)

That's right, I have done the same test with rc6 and it does not crash
anymore.

Many thanks,

Antoine

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQV4giAAoJENprakT/0XU0TqgP/jaU3vP/egGgkyE2bPxfRaCD
wsvDHDQ0lRoSydnDkQ9KdFQXcHNEluL3Gs3c0RKJSqFyOlTLhDFKLr9gQXofvHYL
rw1ZpZuMSXlvmReidwyiv0eBr9338WfEiarmfbdRJGicLyEKn3bHDVkZmPLme/FR
Esl6BEKaasn8cz7AKB+nYgS5zt8avGehEPntEx6InjjBsMz+4xd+1DKbzIcNJSxz
z0+JEu4+3V8FipUymXXA+ni+R9J3WJC7yUirUMDdbVtN8Qa1mOWzkr8MXvb92H9A
Fx/eBH1WiNknH9gdDbj/sRwMusWCJpGtIQwMH4ggV5/JO6+dF1AwuvgykNSBkMAW
CG+l6hwFTjRrcSuirNxv+T0EmXAqhYYk7x2TexchZvW1A1SPpqCSRBZQT2s+9QFU
ICCmGsroqkWH7v5DbR6ujcOnVfxZuVnC63tq5+t7MxJUkh1pOizPSYQ8UNc45JAt
Q9OiNAOoM9zNQrgvWKpc4sxGn4fBDqjA9EYBlsnLZKRhHprWq6CNxty/A6P7twow
2/FDM7ZgKTrdkUF6MnHprdcBhoH/Ef4l/302MhCSqidUF1Hmse4joLXDXaVOL7W5
JDBgJ/fJgu+7085lgHfSRxkHGpK3WDTGVejkk8P/EWgj+EQjQmIbOuT7HycSGk15
vEbzs2i9koMl1L2mMBZU
=NICp
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
