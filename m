Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59909 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751653AbdKAMHS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 08:07:18 -0400
Subject: Re: Reasonable amount of snapshots
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1509534294.1662.91.camel@gmail.com>
 <fb1522f7-ffbe-cc5c-8a1d-bb3812b2e0f0@gmx.com>
 <1509535904.1662.93.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <22d4b909-124f-3f01-d99a-18e9596fc76e@gmx.com>
Date: Wed, 1 Nov 2017 20:07:11 +0800
MIME-Version: 1.0
In-Reply-To: <1509535904.1662.93.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dQsANg8l3BCOPCNLSJOm0GXcWE5d1XFa8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dQsANg8l3BCOPCNLSJOm0GXcWE5d1XFa8
Content-Type: multipart/mixed; boundary="OunU6OOnNpsiCjLgpXN4xul4pXTR56EnW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <22d4b909-124f-3f01-d99a-18e9596fc76e@gmx.com>
Subject: Re: Reasonable amount of snapshots
References: <1509534294.1662.91.camel@gmail.com>
 <fb1522f7-ffbe-cc5c-8a1d-bb3812b2e0f0@gmx.com>
 <1509535904.1662.93.camel@gmail.com>
In-Reply-To: <1509535904.1662.93.camel@gmail.com>

--OunU6OOnNpsiCjLgpXN4xul4pXTR56EnW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8801=E6=97=A5 19:31, ST wrote:
> On Wed, 2017-11-01 at 19:17 +0800, Qu Wenruo wrote:
>>
>> On 2017=E5=B9=B411=E6=9C=8801=E6=97=A5 19:04, ST wrote:
>>> Hello,
>>>
>>> I read in different places that one should keep amount of snapshots l=
ow
>>> - around 15-20. My question - is this limitation on total number of
>>> snapshots on the system or only on related (parent<->child) chain of
>>> snapshots?
>>
>> Independent subvolume doesn't count, and it's filesystem based.
>>
>> So only snapshots (with source exists, and still shares a lot of trees=

>> with source) counts.
>>
>> And if you have multiple btrfs fses, then the count should be based on=

>> each fs.
>>
>>> What I want to do is the following: create (and then rotate) last 7
>>> daily snapshots (and maybe 4 weekly) for each user in his /home dir.
>>> For
>>> around 100 users. So if limitation is only on related snapshots then =
I'm
>>> OK since only each 7 (or maybe 7+4) of them are related which is well=

>>> under the 15-20 limit. However in total there could be 700 snapshots.=
 So
>>> what is true?
>>
>> You're OK since independent subvolumes won't cause too much stress for=

>> backref walk.
>>
>> The only thing you may need to consider is to limit the ability to
>> reflink data between subvolumes.
>> Like cp --reflink or even offline dedupe.
>=20
> Thank you very much! How can I limit this ability? (I'm on Debian9)
>=20
> All the best!

No way to limit, unfortunately.

Thanks,
Qu


--OunU6OOnNpsiCjLgpXN4xul4pXTR56EnW--

--dQsANg8l3BCOPCNLSJOm0GXcWE5d1XFa8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln5uO8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhbZAf/bqWIUqbmtOgisd0AqAPHebml
Jg9HgHlDIM+Qdnaf/NU+68SdHZCH/TD8QyHRcW2wVlmGc9jE277lsqO+gcLLxyp+
4hWMO/W4ElGQeRYB+8vLsgaSMaxAkUKpN4a1FzRpylLNnqBmUQC+V7MaMvScsGet
KUtSDvKpenakwJhOdWDnY+ZaYQ9rNYyvHrAhgPVEb3EBDyalJHnxVx2cwH8xKNcY
au3LGt4Y1XN/kOG8x5ldx7ZmBisKKd9Js0cQFeciBMcTENd34Uz8Y6+NvGav0vaA
JMGcpRKgeB9UqBBYctbE65QTc4q5UPzLfKjCnAqSkQ3ik2vi7BDlOuccmOArIg==
=E89m
-----END PGP SIGNATURE-----

--dQsANg8l3BCOPCNLSJOm0GXcWE5d1XFa8--
