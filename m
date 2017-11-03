Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51565 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750826AbdKCEkB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Nov 2017 00:40:01 -0400
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
 <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
 <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
 <0bc63e4d-1176-9534-01ac-5cf6292bccdd@gmx.com>
 <CAKuJGC8vE+vdTXf-WKuMfP-Sd=hiNmaCsm_1=vTQi7ngBh3kCQ@mail.gmail.com>
 <CAKuJGC_cwYHe_Y2bEADNR0UGrB7kncE-N5vrE=CRvMJ8g9726Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c8b15c71-1557-85d5-6cbf-06cbaef369e0@gmx.com>
Date: Fri, 3 Nov 2017 12:39:53 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC_cwYHe_Y2bEADNR0UGrB7kncE-N5vrE=CRvMJ8g9726Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="e6P2FnCdt8IVHgCT9bN6N91gpgLgvVjSj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e6P2FnCdt8IVHgCT9bN6N91gpgLgvVjSj
Content-Type: multipart/mixed; boundary="iEsnolWfLnwoD8as02ess8j5jfRdFkWuT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <c8b15c71-1557-85d5-6cbf-06cbaef369e0@gmx.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
 <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
 <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
 <0bc63e4d-1176-9534-01ac-5cf6292bccdd@gmx.com>
 <CAKuJGC8vE+vdTXf-WKuMfP-Sd=hiNmaCsm_1=vTQi7ngBh3kCQ@mail.gmail.com>
 <CAKuJGC_cwYHe_Y2bEADNR0UGrB7kncE-N5vrE=CRvMJ8g9726Q@mail.gmail.com>
In-Reply-To: <CAKuJGC_cwYHe_Y2bEADNR0UGrB7kncE-N5vrE=CRvMJ8g9726Q@mail.gmail.com>

--iEsnolWfLnwoD8as02ess8j5jfRdFkWuT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

BTW, it would be better to see if this patch also solves your problem.

https://patchwork.kernel.org/patch/10038011/

Thanks,
Qu

On 2017=E5=B9=B411=E6=9C=8803=E6=97=A5 12:00, Lakshmipathi.G wrote:
> After disabling FS_CHECK_INTEGRITY and FS_RUN_SANITY_TESTS in the
> config. Now the issue resolved. thanks.
>=20
> cast: https://asciinema.org/a/Dy6eHhhWPEIxotVbVUBWrhFeF
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>=20
>=20
> On Thu, Nov 2, 2017 at 12:55 PM, Lakshmipathi.G
> <lakshmipathi.g@gmail.com> wrote:
>> Okay thanks, I'll disable above mentioned entry in kernel config and
>> run the tests.
>> Will get back with  updated results.
>>
>>
>> ----
>> Cheers,
>> Lakshmipathi.G
>> http://www.giis.co.in http://www.webminal.org


--iEsnolWfLnwoD8as02ess8j5jfRdFkWuT--

--e6P2FnCdt8IVHgCT9bN6N91gpgLgvVjSj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln78xkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgfrwf+JwN2etE9s4V18roOLpnsqsp7
kZ5uEI702yJU9cRFJ+B9/+J+T14cUjTHsA6zTYGzqj38+e0FuIQnH7j2OGPxooXt
UntkiKbneXeQurgHpUzD7AXqqSlfHFO6pbsBwZNeHVQ6Vq9GqhMVSSjjHxXV0FKh
7ODaLL9xI/nSnCuN4lwDCRP9MFihs0XpjIWlaB2F1mQryWUtuJOH0lCfV9ur4JmX
V/VmkbmpCftKbNmkmEVHS4fvrvhiGbGZoTpp5lVYq/lGlMH7RHRZpMwhRGfN3ZLP
6ckjBH6J0T/bKZiwPcsUvVgEUyG8kZq08PqaBMiJqON79iu85geSywYPZSXRTg==
=Fbdi
-----END PGP SIGNATURE-----

--e6P2FnCdt8IVHgCT9bN6N91gpgLgvVjSj--
