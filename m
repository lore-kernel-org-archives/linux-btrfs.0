Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:41141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933054AbeCEKYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 05:24:54 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Free space cache file (v1 space cache) corruption
Cc: Josef Bacik <jbacik@fb.com>
Message-ID: <8d38ea96-ebb7-5e5b-1352-a18c1b1778bb@gmx.com>
Date: Mon, 5 Mar 2018 18:24:41 +0800
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lhU018Bg2rpuKcfwg1UBYPklz8wnCAGQa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lhU018Bg2rpuKcfwg1UBYPklz8wnCAGQa
Content-Type: multipart/mixed; boundary="pk4Tv1Tvg3lzzcuGPlt92p8HjFo5UOgnR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Josef Bacik <jbacik@fb.com>
Message-ID: <8d38ea96-ebb7-5e5b-1352-a18c1b1778bb@gmx.com>
Subject: Free space cache file (v1 space cache) corruption

--pk4Tv1Tvg3lzzcuGPlt92p8HjFo5UOgnR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

As the investigation about unexpected btrfs corruption goes on, here we
expose an strange v1 space cache corruption.

The script is updated to gist:
https://gist.github.com/adam900710/d37f38070f7fc4d858ffe856c516b426

The script itself is pretty straight forward:

0) Create a btrfs with large enough data chunk
   Original single data chunk created by mkfs is not large enough.
   Do a full balance to create a large enough data chunk, so space cache
   will live in a data chunk which also has its own cache.

1) Does some fsstress load along with dm-log-writes.
   The load is pretty small. Just -n 200 could reproduce it.

   dm-log-writes will record all the operations to later analyse.

2) Use dm-log-writes to replay to each FLUSH and FUA operations and do
   fsck
   In the script, it does this manually, just to check both FUA and
   FLUSH.
   In fact we can use --check fua option to do it in one line.

   Although btrfs check won't return error as it detects invalid free
   space cache and just ignore them, but we can get free space cache
   related error prompt.

Then we can get some free space cache corruption in both flush and fua
operations.
And some of them can even survive across *several* transaction.

Further more, when such corruption happens, space cache file extent
seems to be CoWed, instead of being overwritten.
In my test environment, the whole 64K file extent of metadata block
group cache just get CoWed.
(In previous trans, its bytenr is XXX by in next trans it's YYY, and the
inode size doesn't change at all, but nbytes seems is increasing)

Although kernel and btrfs check can both report such problem due to free
space bytes difference, but that's already the last defensing line.
The corrupted free space cache passes both generation and csum check.

I'll keep digging while advice from anyone who is familiar with free
space cache would really help in this case.

Thanks,
Qu


--pk4Tv1Tvg3lzzcuGPlt92p8HjFo5UOgnR--

--lhU018Bg2rpuKcfwg1UBYPklz8wnCAGQa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqdGukXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj8tQgAo/dvrlYzC4mNgqP0wbzeMxku
Ur4e0v9OsO33+lYjCu65mveLEWySYghkS2u7ZxfzU5majHi3SvJeJwjhJeVBzLLh
I+lxhRbLS6rbqup7OmznCTctmjo1RmmFm9TAY3rQCp1Ed5IiDddvjfTNMhrXBAC9
Shm8xx2AYzLZYs+RZMOZ6oImCDeb6ngN+F/dZ4CPlGEtYP+y5QRohwjlRdVBr+MB
7Kbfu84k20yAxtO1ezqMr1NNkTdgte7G8GvCUrPEXfIUGBrkzHhRUbmyFXmwnOov
8qBEwBPWCXQ6SrS51kVry5OrK9qHd93Hf2ZBi/kSQXBpxrNYEqU0GRsBNe7I2A==
=l8Wi
-----END PGP SIGNATURE-----

--lhU018Bg2rpuKcfwg1UBYPklz8wnCAGQa--
