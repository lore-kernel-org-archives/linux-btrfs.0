Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58860 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbdKWHnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 02:43:43 -0500
Subject: Re: btrfs restore corrupt file
To: Chris Murphy <lists@colorremedies.com>,
        Jorge Bastos <jorge.mrbastos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAHzMYBQ7tsHFuHkJ5zjK6Wx0bD0XHp0TGti_uJNV5pz4ak7wJA@mail.gmail.com>
 <CAJCQCtQpCJc1h8qnLv6M_aMf-0q_9saNwCrNwt1HML1jFLHq8g@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4799dfcb-2a05-f1f5-8f08-285b5dec3488@gmx.com>
Date: Thu, 23 Nov 2017 15:43:33 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQpCJc1h8qnLv6M_aMf-0q_9saNwCrNwt1HML1jFLHq8g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2JpOSue5qrKaLitLRBT9N2tBXSai5PlGR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2JpOSue5qrKaLitLRBT9N2tBXSai5PlGR
Content-Type: multipart/mixed; boundary="L93mJKVXGj2xEJDQMsDkxkici3LKKl6dX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Jorge Bastos <jorge.mrbastos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <4799dfcb-2a05-f1f5-8f08-285b5dec3488@gmx.com>
Subject: Re: btrfs restore corrupt file
References: <CAHzMYBQ7tsHFuHkJ5zjK6Wx0bD0XHp0TGti_uJNV5pz4ak7wJA@mail.gmail.com>
 <CAJCQCtQpCJc1h8qnLv6M_aMf-0q_9saNwCrNwt1HML1jFLHq8g@mail.gmail.com>
In-Reply-To: <CAJCQCtQpCJc1h8qnLv6M_aMf-0q_9saNwCrNwt1HML1jFLHq8g@mail.gmail.com>

--L93mJKVXGj2xEJDQMsDkxkici3LKKl6dX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8823=E6=97=A5 13:25, Chris Murphy wrote:
> On Wed, Nov 22, 2017 at 12:18 PM, Jorge Bastos <jorge.mrbastos@gmail.co=
m> wrote:
>> Hello,
>>
>> While doing btrfs checksum testing I purposely corrupted a file and
>> got the expect I/O error when trying to copy it, I also tested btrfs
>> restore to see if I could recover a known corrupt file and it did copy=

>> it but there was no checksum error or warning. I used btrfs restore -v=

>>
>> Is this expect behavior or should restore warn about checksum failures=
?
>>
>> Kernel used was 4.13.13,  btrfs-progs v4.13.2
>=20
> I think it's expected. "The checks done by restore are less strict"
> from the man page. Although it'd be nice if -v option at least could
> flag such files as possibly being corrupt.
>=20
I think people always consider "btrfs restore" as a tool to "restore" dat=
a.

The proper name of it should be "salvage" and moved under "btrfs
rescue", to reduce the confusion.

Thanks,
Qu


--L93mJKVXGj2xEJDQMsDkxkici3LKKl6dX--

--2JpOSue5qrKaLitLRBT9N2tBXSai5PlGR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloWfCUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgZ5Qf/WeNVFLlbOVNm1gqzRdmm79w+
bGUL3MGxFG/G29H/jnVx/RF7JcQxETbSqOrUIxdlq4bSIX0+40GtiGtzinGeTH8H
ZMS+cQe0WYICiEq7ZesbjeIH7VgRtKenP64RxCJMsKOf0JneWVL7vUCZxueuQNjM
JzZHJ1VS9ZjfP+4Juto8gXAP3MsKs67AKlQirYXuJcPXcqhzYPZT4CVuTr1rfldd
XpQuaTQv/vWZeI3qyKJCes3EF3B3exmenh7CoI8eu2f/OwcMKLx628SxQWFoNtOz
E3iQoVwBypyR+NSSskvTFTFFGZz/lKC+AjzN4OMPG66SgjVJsSozDcwGiPz5Ow==
=w+Ia
-----END PGP SIGNATURE-----

--2JpOSue5qrKaLitLRBT9N2tBXSai5PlGR--
