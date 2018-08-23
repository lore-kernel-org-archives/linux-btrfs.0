Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:50842 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbeHWV6i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 17:58:38 -0400
Received: by mail-it0-f67.google.com with SMTP id j81-v6so8886236ite.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 11:27:42 -0700 (PDT)
Date: Thu, 23 Aug 2018 14:27:38 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: jkexcel <jkexcel@comcast.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert missing in btrfs-tools v4.15.1
Message-ID: <20180823182737.g2o7377e7torldtk@navis>
References: <1438689914.6655.1532811050018@connect.xfinity.com>
 <20180728213448.GA16016@DigitalMercury.dynalias.net>
 <6c37e7ef-5669-7464-c72a-69a2074ebfb1@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hplpz22xm64uklka"
In-Reply-To: <6c37e7ef-5669-7464-c72a-69a2074ebfb1@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hplpz22xm64uklka
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Qu,

On Sun, Jul 29, 2018 at 07:44:05AM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B407=E6=9C=8829=E6=97=A5 05:34, Nicholas D Steeves wrote:
> > Resending because I forgot to CC list.
> >=20
> > Hi jkexcel,
> >=20
> > On 28 July 2018 at 16:50, jkexcel <jkexcel@comcast.net> wrote:
> >>
> >> I'm an end user trying to use btrfs-convert but when I installed
> >> btrfs-tools and its dependency btrfs-progs on kubuntu 18.04, the
> >> installation was successful, and it shows that v4.15.1-1build1 was
> >> installed.
> >>
> >> However, when using the command  # brtfs-convert  /dev/sda4 (with the
> >> drive unmounted) the resulting error appears "command not found"
> >> I also tried command "btrfs convert" in case this was folded into the
> >> main tool, but this also failed.
> >>
> >> 1. Is btrfs-convert still available?
> >>
> >> 2. Where can I find it?
> >>
> >> 3. Has btrfs-convert been replaced? what is it's new name?
> >>
> >> 4. Is it safe to use a downgraded version of btrfs-tools ie: 4.14 or
> >> older?
> >=20
> > You can blame me for that.  In Debian several users had reported
> > release-critical issues in btrfs-convert, so I submitted a patch to
> > disable it for the forseable future, eg:
> >=20
> >   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D864798
> >   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D854489
>=20
> Both report looks pretty old (4.7~4.9).
>=20
> In fact, just in v4.10 we had a big rework for convert.
> It should work much better after that.
>=20
> Furthermore, we have newer (but smaller) fixes to remove a lot of
> BUG_ON(), and do graceful exit for ENOSPC case since then.
>=20
> And the design of btrfs-convert (at least for the latest btrfs-convert)
> is to ensure until everything goes well, we won't touch any bytes of the
> ext* fs (in fact we open the ext* fs in RO mode).
> So it at least won't corrupt the ext* fs.
>=20
> >=20
> > Also, please consider the official status "As of 4.0 kernels this featu=
re
> > is not often used or well tested anymore, and there have been some repo=
rts
> > that the conversion doesn't work reliably. Feel free to try it out, but
> > make sure you have backups" (
> > https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3 ).
>=20
> The wiki page looks needs to be updated.
>=20
> Both btrfs-convert and base btrfs-progs are improving, especially after
> v4.10 btrfs-convert goes through a big rework and works well so far, and
> even added support for reiserfs under the same framwork.
>=20
> So IMHO it's at least worth trying.
>=20
> Thanks,
> Qu

Thank you for sharing the cut-off where success became more likely :-)
Debian 9 could have had 4.9.1 at the newest, so it wouldn't have had
btrfs-convert.  So it sounds like btrfs-convert could have been
enabled for the experimental suite (which is almost only used by
Debian developers and not users) for 4.10.  Looking at the changelog
it seems we might have had to disable it again before 4.14.1 or 4.16.

I'm happy we're having this conversation now, because the time to give
it another try is probably sometime in the next month :-)  See my long
email to David for the caveats.

Cheers,
Nicholas

--hplpz22xm64uklka
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlt+/JcACgkQWogwR199
EGETxw/+O3FeuaH/ofJNIV2JrwV9dMrTwVUicXNwzAJVzKT3ROLLB1Xn2xnx3gNR
PoA4vOP1rq0bfDZEOCvi88JCo/uPUCtboo517QmmbxFKLwUcFeuo5XJOq0xoAnVO
HS81/GIvjTo3Kk9hPEk8paLzcV5DKC7FcTcm3uYI0PCp7CNEiyfA5yDP4eTui7sL
KDQmdOsiP02Na7Xz4+xzaFJuJSoIFoDzvIQCnwm0dWs+lunEmuuDKh6WRkrohyQR
bf+D5bBQ1xMd6Ic154gcpLOKqL9rvhejIgGl9d2YLOruavsOAZduxIG1cILiM3oM
lZi+GEfKBakwLy+kZfeHS1NMR1T/kOmWSHi1aDmFvjXdQAvN1IyawcxIzcCRVOxZ
jnjB3l7ALEDJRM1Iv/L5TruRXBFu0JlttH4br4Wl3EWkOdqIbq5ZjoyuhECtgeoG
/7V5qmt4oBMAvFxWAGwJHRnU8yj+yy3nRjNvp3iHJQqlEKcdZs3C8BmR2XYsncvk
hXotykOf9Vrr+yy+uglFpT7VJxW71rl7o+4IVGNtOU2T8o8Rb0Kjv5Qe7MS2ieKN
qHoyaYCBQ+Dhznug6yO3p0kqLOLyTg8eULuv6if1pPiZ5ZdZXNUX1l0rJAs6Vf9I
OCYWiZivHUeoHNW4wt62KlsXtioMWblJbGzmHMDFQbZgSPVfefs=
=FFro
-----END PGP SIGNATURE-----

--hplpz22xm64uklka--
