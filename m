Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59160 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387502AbeHAKkp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 06:40:45 -0400
Date: Wed, 1 Aug 2018 08:56:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS and databases
Message-ID: <20180801085602.GC7524@carfax.org.uk>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
In-Reply-To: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2018 at 05:45:15AM +0200, MegaBrutal wrote:
> I know it's a decade-old question, but I'd like to hear your thoughts
> of today. By now, I became a heavy BTRFS user. Almost everywhere I use
> BTRFS, except in situations when it is obvious there is no benefit
> (e.g. /var/log, /boot). At home, all my desktop, laptop and server
> computers are mainly running on BTRFS with only a few file systems on
> ext4. I even installed BTRFS in corporate productive systems (in those
> cases, the systems were mainly on ext4; but there were some specific
> file systems those exploited BTRFS features).
>=20
> But there is still one question that I can't get over: if you store a
> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
> with nodatacow, or would you just simply use ext4?

   Personally, I'd start with btrfs with autodefrag. It has some
degree of I/O overhead, but if the database isn't performance-critical
and already near the limits of the hardware, it's unlikely to make
much difference. Autodefrag should keep the fragmentation down to a
minimum.

   Hugo.

> I know that with nodatacow, I take away most of the benefits of BTRFS
> (those are actually hurting database performance =E2=80=93 the exact CoW
> nature that is elsewhere a blessing, with databases it's a drawback).
> But are there any advantages of still sticking to BTRFS for a database
> albeit CoW is disabled, or should I just return to the old and
> reliable ext4 for those applications?
>=20
>=20
> Kind regards,
> MegaBrutal

--=20
Hugo Mills             | In theory, theory and practice are the same. In
hugo@... carfax.org.uk | practice, they're different.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbYXWiAAoJEFheFHXiqx3kc2MP/0NrsYr48BifmgTOlJNvtZPH
jUH1DOnk+uGdUdkbC3Svi2oLyqJOMCgXDpRW4Ntjr7udXq+pHcNBUG9IEYm8v8Bl
Fz0DjIFOCV44HVPyiBr8nmwnxrHF7z1ApTlq9nv6/TqeRHeOpsiq9IUP4Ay3NKFX
ZKGn+xbj4vF45uC9xtZ494CAlTohn+X11iPilmJ7sqgXKEIzn3LHI4UDSatHHQCM
2aJ/O5HUgLrouBt0zVCXJ8o5IlgThZO9DNw7pFW817AntbZ/hZu7SwiZXBH9w3e1
Pz3bLskLMF1Be/dOLlKuzzxlSeyaQmv2p2wp6rOabQ1i/7ozEzqLUpQohrBzx0oW
3hUizz7yncVsBmFXiY8bz2EXGvUv2+YSF5WYjfkUIsrumo8xRt8gcqpXkOV8HtnC
wKd4P6AJGGf3XJ1fWGNcBKM3LhKdYgBpU+z8txS9njZiLnnEFO3HQOgiaku+WfeP
EXhFvWcu/YaFzYi1BS2ULGwuBpoyR/E+o9nsWyDpGNZoB1Uounx6eAIZwbDfW7ip
PnLcsWt8SB0QW5N6UiIa2TxhnXFPqYFQL3O/PhdfDKd24mEF/c3XGi4uZdtvXhP9
RXPobdwEMO/qoqo5keW+MUbUnwyZ9mCuv6v6a4r6inj0azF7CBZjofAgsKA+t2tI
vP8Yfq3I4zaRYVB0TZ+s
=ufgD
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
