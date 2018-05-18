Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59887 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbeERJ43 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 05:56:29 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: james harvey <jamespharvey20@gmail.com>
Cc: Steve Leung <sjleung@shaw.ca>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <CA+X5Wn51gEdshKO+g-o+UQtjTtMsBwV02ziyHjOQ2R4Anh=Dzw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6088eb00-2530-eabd-0e8a-fade3822924b@gmx.com>
Date: Fri, 18 May 2018 17:56:16 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn51gEdshKO+g-o+UQtjTtMsBwV02ziyHjOQ2R4Anh=Dzw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jCsYWULKwpBMkkPJHuUzMhSORIAXKdCv2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jCsYWULKwpBMkkPJHuUzMhSORIAXKdCv2
Content-Type: multipart/mixed; boundary="9M97W19uFerXpgeARwbyRbTjNrOaJjn45";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>
Cc: Steve Leung <sjleung@shaw.ca>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6088eb00-2530-eabd-0e8a-fade3822924b@gmx.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <CA+X5Wn51gEdshKO+g-o+UQtjTtMsBwV02ziyHjOQ2R4Anh=Dzw@mail.gmail.com>
In-Reply-To: <CA+X5Wn51gEdshKO+g-o+UQtjTtMsBwV02ziyHjOQ2R4Anh=Dzw@mail.gmail.com>

--9M97W19uFerXpgeARwbyRbTjNrOaJjn45
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 17:42, james harvey wrote:
> On Fri, May 18, 2018 at 1:49 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>> And btrfs check doesn't report the same problem as the default origina=
l
>> mode doesn't have such check.
>>
>> Please also post the result of "btrfs check --mode=3Dlowmem /dev/sda1"=

>=20
> Are you saying "--mode=3Dlowmem" does more checks than without it?

Sometimes it does more check.

>  "man
> btrfs check" says it's experimental and the difference is just
> original is unoptimized regarding memory consumption and can run out
> of memory, and low memory addresses this with increased IO cost from
> re-reading blocks increasing run time.  It doesn't indicate lowmem is
> a better check.

Well, due to the fact original mode and lowmem mode use completely
different way to check, you'd better consider lowmem mode as a
completely rework.
Thus sometimes it will cause different result. (Although most of the
time lowmem is causing false alerts)

Here in this particular case, lowmem does indeed do extra check.

And overall, lowmem mode provides more human readable error output.

Thanks,
Qu


--9M97W19uFerXpgeARwbyRbTjNrOaJjn45--

--jCsYWULKwpBMkkPJHuUzMhSORIAXKdCv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+o0AACgkQwj2R86El
/qiRdQf8Dz/Avq3cSzAi6zt7Z1FReVd4UL2n1k+3zyGycJdbbysBSUsG/RVjYvz6
OoGUdviTD7rc6c0SaQvsFCu0g6Lzfaq5IqA1IYfPOjpiG1KiRIUG+lrV2w7sSu/1
OEuo/AwtuKJQV73awGXxmXyRh3PB0YKLParYSPq6Dui7zBfTc3r+d/3NW0Cy44T+
PLoagv6wVHZtVk26n3A1sOW4uXPihknnNLbLGl1cL675fGEObxsOokaHDiEr7CQZ
dWzk+YYBwX5ZvdvY04DG3yuODndlxPtPREIeH7rhh6ocN/QrptPt2JXi5WO9uH9Q
k3HGy6a9EI7LDz9N2nsMcLxYVxBq5w==
=07dX
-----END PGP SIGNATURE-----

--jCsYWULKwpBMkkPJHuUzMhSORIAXKdCv2--
