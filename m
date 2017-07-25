Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53185 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbdGYN65 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 09:58:57 -0400
Date: Tue, 25 Jul 2017 13:58:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?H=E9rikz?= Nawarro <herikz.nawarro@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid assurance
Message-ID: <20170725135835.GN7140@carfax.org.uk>
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk>
 <20170725135146.GM7140@carfax.org.uk>
 <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ai6NJizWfpRUKxSm"
In-Reply-To: <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Ai6NJizWfpRUKxSm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 25, 2017 at 10:55:18AM -0300, H=E9rikz Nawarro wrote:
> And btw, my current disk conf is a 1x 500GB, 2x3TB and a 5TB.

   OK, so by my mental arithmetic(*), you'd get:

 -  9.5  TB usable in RAID-0
 - 11.5  TB usable in single mode
 -  5.75 TB usable in RAID-1

   Hugo.

(*) Which may be a bit wobbly. :)

> 2017-07-25 10:51 GMT-03:00 Hugo Mills <hugo@carfax.org.uk>:
> > On Tue, Jul 25, 2017 at 01:46:56PM +0000, Hugo Mills wrote:
> >> On Tue, Jul 25, 2017 at 09:55:37AM -0300, H=E9rikz Nawarro wrote:
> >> > Hello everyone,
> >> >
> >> > I'm migrating to btrfs and i would like to know, in a btrfs filesyst=
em
> >> > with 4 disks (multiple sizes) with -d raid0 & -m raid1, how many
> >> > drives can i lost without losing the entire array?
> >
> >    Oh, and one other thing -- if you have different-sized devices,
> > RAID-0 is probably the wrong thing to be using anyway, as you won't be
> > able to use the difference between the largest and second-largest
> > device. If you want to use all the space on the available devices,
> > then "single" mode is probably better (although you still lose a lot
> > of data if a device breaks), or RAID-1 (which will cope well with the
> > different sizes as long as the largest device is smaller than the rest
> > of them added together).
> >
> >    You can see about the disk usage in different scenarios with the
> > online tool at:
> >
> > http://carfax.org.uk/btrfs-usage/
> >
> >    Hugo.
> >

--=20
Hugo Mills             | One of these days, I'll catch that man without a
hugo@... carfax.org.uk | quotation, and he'll look undressed.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                   Leto Atreides, D=
une

--Ai6NJizWfpRUKxSm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZd06LAAoJEFheFHXiqx3kXe0QAJ1NvM1Z26QqCmTikf2W3gml
Ac4x06PeikpPdAyrkqL46rRZEwaGt/VvLoQwLR0jCyoD7cR+P0pD9325JB9WjZqJ
4+YxE2D3ehFY2FmsrCcD95OIrxb0EP63BCjTQfVHusSXrgNekP09blAOc8RRxpxN
ycXUQ1m70xFGS+D6e0PcdS/FRGxP/81O7eXOd6YHQc4KjVKk9gHYGMd01F/XUaDy
1AYmsUSVnt6HtyiodpYxcTRtAs4/oq2V87+YjkOvDXlE6rlgfFK7HdI/+Byo1tlJ
91ikbLYQ6OQ6zodzC2s3Jg/O++xavgsQJ+y9VC4S7ULzxH/b7ZGEqJPHK23xTuoB
t1k1LGdA5KTj4Tsg+ohqa6anqMXLRTFT4OVitZs4qePJ4e0j8nbjtdZ0TSDBOqWI
73xt1R7Pt7rInLnUpJNqRas49kop5YUb7qovzqLlFGQ955zCMbEIGQxFaR7pV8hO
pARGzp7oi1GdOv4za7/n90cjnUuFM68dPPr6/oq5Hk5Fnre2YMDe+p3mWoW/ubXN
4j4/bk+ZTDik6i7CRsGJFi047fJpdMrYPDrgyG8ga8cs0SybhaeKFrDFJ9B71Agl
xefDeVFWJHp7NxAe3yTJixYM5EJfK/gzQ6f881dltrvjxE5nDAiI8KBx0ZYvsSyP
yOP3WfKepmyvv2dh5Vpl
=ANvu
-----END PGP SIGNATURE-----

--Ai6NJizWfpRUKxSm--
