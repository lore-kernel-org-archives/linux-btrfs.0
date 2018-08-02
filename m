Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbeHBI5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 04:57:19 -0400
Subject: Re: BTRFS and databases
To: Remi Gauvin <remi@georgianit.com>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <8b5d3277-1afc-9b10-2960-f9fd4396e2e1@georgianit.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <46d12c3f-9756-99be-a99c-75af5acc3296@gmx.com>
Date: Thu, 2 Aug 2018 15:07:25 +0800
MIME-Version: 1.0
In-Reply-To: <8b5d3277-1afc-9b10-2960-f9fd4396e2e1@georgianit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f5pn0QE8o0EJ9aMrwItgZe0f4dlEsf4Ge"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f5pn0QE8o0EJ9aMrwItgZe0f4dlEsf4Ge
Content-Type: multipart/mixed; boundary="aXuXHZaL52LVxW90i4XVtqZloKVbBpaAi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Remi Gauvin <remi@georgianit.com>, MegaBrutal <megabrutal@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <46d12c3f-9756-99be-a99c-75af5acc3296@gmx.com>
Subject: Re: BTRFS and databases
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <8b5d3277-1afc-9b10-2960-f9fd4396e2e1@georgianit.com>
In-Reply-To: <8b5d3277-1afc-9b10-2960-f9fd4396e2e1@georgianit.com>

--aXuXHZaL52LVxW90i4XVtqZloKVbBpaAi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8801=E6=97=A5 22:33, Remi Gauvin wrote:
> On 2018-07-31 11:45 PM, MegaBrutal wrote:
>=20
>> I know that with nodatacow, I take away most of the benefits of BTRFS
>> (those are actually hurting database performance =E2=80=93 the exact C=
oW
>> nature that is elsewhere a blessing, with databases it's a drawback).
>> But are there any advantages of still sticking to BTRFS for a database=

>> albeit CoW is disabled, or should I just return to the old and
>> reliable ext4 for those applications?
>>
>=20
> Be very careful about nodatacow and btrfs 'raid'.  BTRFS has no data
> synching mechanism for raid,

Not completely the case though.
Discussed in another thread, for nodatacow/nodatasum case we indeed
don't have any anyway to keep data correct.

But for RAID1 datacow or metadata case, it should not be case.
For tree block, we have generation/first_key/level check done when
searching tree blocks.
And for scrub, we also have generation check, so in theory we could
recovery such problem during scrub.

For data, since we have cow (along with csum), it should be no problem
to recover.

And since datacow is used, transaction on each device should be atomic,
thus we should be able to handle one-time device out-of-sync case.
(For multiple out-of-sync events, we don't have any good way though).

Or did I miss something from previous discussion?

Thanks,
Qu

> so if your mirrors end up different
> somehow, your Array is going to be inconsistent.
>=20


--aXuXHZaL52LVxW90i4XVtqZloKVbBpaAi--

--f5pn0QE8o0EJ9aMrwItgZe0f4dlEsf4Ge
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltira0ACgkQwj2R86El
/qiPUQgAkbsCu/upKtVBADoF6/lKhxO/Ok4JPFEpBqFDocsDwuxBcoT1sboq6j0t
w6UtXxffjIehUjxquAgTjv47+KCEddTS/NlYCnXq05//ysTDnljUR/cB32uQ3zYZ
MLJyaAOIn+cU6ykmwY5Ufe1jSZcXDMiEeYBzBfcDo6MIyF8IUxvHQ34EYyMyooZN
Cxdq68Ckvg+1i58jST9p/HDIHXA3ftMrb5MovrfEs2v1kz5QdE6L6k2+mLf8yPFc
eR5FoFl2COoEueKa3Byp7GmkKm8Cl0jGP253BhksT+6YYB4h7ccSjZuitAmHx/+t
fZbSCwttLc8pSq8h6AJkj6QlmbB1mA==
=yRAJ
-----END PGP SIGNATURE-----

--f5pn0QE8o0EJ9aMrwItgZe0f4dlEsf4Ge--
