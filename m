Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:47635 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbeD2BuG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 21:50:06 -0400
Subject: Re: fs/btrfs/ctree.h:1559 warnings
To: Paul Richards <paul.richards@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAMoswehF-GGV-yi_5fFnuvmZWVkeb71F7OcgOgr80r1F-=R_tg@mail.gmail.com>
 <CAA7pwKOGS1MfwiO7AvfGPMP5ddhA6EMF+u3eZ+yE++RYvM=bfg@mail.gmail.com>
 <CAMoswejKgjw+ktxc7iGX9m6F-n5Xq_=kzyLiR4xYUf2s=bYaDA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20edd001-152b-edbb-548b-dcb2647d828a@gmx.com>
Date: Sun, 29 Apr 2018 09:50:00 +0800
MIME-Version: 1.0
In-Reply-To: <CAMoswejKgjw+ktxc7iGX9m6F-n5Xq_=kzyLiR4xYUf2s=bYaDA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2Rbs2aKRoJdYVQUBCjhRkv1s43MoDiFzl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Rbs2aKRoJdYVQUBCjhRkv1s43MoDiFzl
Content-Type: multipart/mixed; boundary="65b9Obzxsle6hOnuc9rwSYAtV8qFv7jAW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Paul Richards <paul.richards@gmail.com>,
 Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20edd001-152b-edbb-548b-dcb2647d828a@gmx.com>
Subject: Re: fs/btrfs/ctree.h:1559 warnings
References: <CAMoswehF-GGV-yi_5fFnuvmZWVkeb71F7OcgOgr80r1F-=R_tg@mail.gmail.com>
 <CAA7pwKOGS1MfwiO7AvfGPMP5ddhA6EMF+u3eZ+yE++RYvM=bfg@mail.gmail.com>
 <CAMoswejKgjw+ktxc7iGX9m6F-n5Xq_=kzyLiR4xYUf2s=bYaDA@mail.gmail.com>
In-Reply-To: <CAMoswejKgjw+ktxc7iGX9m6F-n5Xq_=kzyLiR4xYUf2s=bYaDA@mail.gmail.com>

--65b9Obzxsle6hOnuc9rwSYAtV8qFv7jAW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 04:16, Paul Richards wrote:
> On 28 April 2018 at 20:39, Patrik Lundquist <patrik.lundquist@gmail.com=
> wrote:
>> On 28 April 2018 at 20:54, Paul Richards <paul.richards@gmail.com> wro=
te:
>>>
>>> Hi,
>>> I recently upgraded from Linux 4.4.0 to 4.13.0 (Ubuntu 16.04 stock to=

>>> hwe kernel).
>>>
>>> Since then, I've noticed lots of btrfs warnings in dmesg (example at
>>> the end).  I believe these warnings to be benign, and they relate to
>>> my partition not being a multiple of 4KiB in size (I confirmed that
>>> alignment is okay in this instance).
>>
>>
>> Run btrfs rescue fix-device-size <device>.
>>
>=20
>=20
> Excellent, that looks like exactly what I need.  It's a shame my
> google-fu didn't uncover it before I posted.
>=20
> However, the "fix-device-size" sub-command is not available in
> btrfs-tools (v4.4) from Ubuntu 16.04.  I guess my original question
> still stands.  Is this warning safe for me to ignore?

Safe to ignore.

And there is another way to solve it.

Shrink your fs by 4K, and newer kernel will do the round down for you
and result new device size to be aligned.

Thanks,
Qu

>=20
>=20
> I will likely upgrade to Ubuntu 18.04 in a few months at which point
> I'll get a newer btrfs-tools, but until then can I safely ignore this
> warning?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--65b9Obzxsle6hOnuc9rwSYAtV8qFv7jAW--

--2Rbs2aKRoJdYVQUBCjhRkv1s43MoDiFzl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrlJMgACgkQwj2R86El
/qjdIAf+Jsl32BtInECDET+PTu51vmdD1t75jY5Jv/ig0hVh7YH1sScYYd5AxwdZ
hk7zHQjhPpzrPdf2XrETE3Dih04cLTXKJhU5VMLPO95RsB4XetQ7HooRXIGJbsmi
MHXZ6MgijIQyo6GVrBTcfc3Fgg1WTS6Z4Bbjx1+knNxDRc8pCY03zZdC6w96s7Op
GtUtPjOx9Ogy3sf7LMtvmC7K5CYPZxbkU7f0Gym0JOB40bG3CznY6VegS+wwjSWp
9tASHD5UjIQBEGU1/CH2VeOBY8/HRWYBnMcN8KSIJMxkpQjcwsSX1oJyU3Krb8XZ
2uZ8nX0Nt+qsU2a6utdg7dKVWJvleg==
=V1IO
-----END PGP SIGNATURE-----

--2Rbs2aKRoJdYVQUBCjhRkv1s43MoDiFzl--
