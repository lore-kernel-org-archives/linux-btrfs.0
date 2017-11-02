Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59353 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750917AbdKBGUa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 02:20:30 -0400
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
 <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
 <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0bc63e4d-1176-9534-01ac-5cf6292bccdd@gmx.com>
Date: Thu, 2 Nov 2017 14:20:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IcWJ4DHMQ2jw2VvoqIXSpe5kTE3pAeedE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IcWJ4DHMQ2jw2VvoqIXSpe5kTE3pAeedE
Content-Type: multipart/mixed; boundary="wrVWjnnoPEoGh5A0fvs9E7UdfFrHKAQGT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <0bc63e4d-1176-9534-01ac-5cf6292bccdd@gmx.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
 <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
 <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
In-Reply-To: <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>

--wrVWjnnoPEoGh5A0fvs9E7UdfFrHKAQGT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8802=E6=97=A5 13:50, Lakshmipathi.G wrote:
>>
>> I'll try to reproduce it with FS_CHECK_INTEGRITY enabled.
>>
>=20
> Okay thanks for the details.  Here's the kernel config file which hits
> this issue:
> https://github.com/Lakshmipathi/btrfsqa/blob/master/setup/config/kernel=
=2Econfig#L3906

Although I didn't reproduced your problem, I found fstests can easily
trigger the same problem.

The problem turns out to be that setup_items_for_insert() will call
btrfs_mark_buffer_dirty(), however that's not done at correct timing.

If FS_CHECK_INTEGRITY is enabled, every time we call
btrfs_mark_buffer_dirty(), we must ensure have setup the leaf correctly.

However for setup_items_for_insert(), it doesn't really insert the data
but only keys, leaving item data uninitialized, and triggering the bug.
(That's to say, we should not do leaf validation check at
btrfs_mark_buffer_dirty() time).

I'll try to move it to leaf write time to fix the problem.

For now, please disable FS_CHECK_INTEGRITY.

Thanks,
Qu

>=20
> thanks!
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>=20


--wrVWjnnoPEoGh5A0fvs9E7UdfFrHKAQGT--

--IcWJ4DHMQ2jw2VvoqIXSpe5kTE3pAeedE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln6uSYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgGzQf9Hmiaj7QS9xnZxyGoFyL4XwmQ
sv72k+VI+LbpI9L38w5XhLciSyAnyea5VpL9wBmNxhdaKd7rUKDroUgunENNsW4O
vmS2h8lk6gXnGBtZruhc7lPOVl0ACdGvMULxm1Dy82EL0J2Itj3/kpe4hqgkCrXE
dLwjL1sx+w9wY7759Vs3fQiFDoCINdwJ7ZPyzxJuKx26h+J8QRO8sh/Rd/wKOloR
HWD3VVJqEBUA8RejBNkuyg+xN+i6bycf6eoqm6+sjAjucEpTC9Ed66FYXKiBSe/Z
kteUfmQa7vMfwTZX572SCSpKVhcmjYNw0Hk6OW30v4DLRIKXL/PAdCu3q7QWAQ==
=CDoE
-----END PGP SIGNATURE-----

--IcWJ4DHMQ2jw2VvoqIXSpe5kTE3pAeedE--
