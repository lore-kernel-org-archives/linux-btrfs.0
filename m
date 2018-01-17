Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55118 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751963AbeAQFc5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 00:32:57 -0500
To: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Timeline or roadmap to split lowmem mode and original mode check?
Cc: linux-btrfs@vger.kernel.org
Message-ID: <521779a7-60bc-c7c9-b35d-77c5e36aaacc@gmx.com>
Date: Wed, 17 Jan 2018 13:32:46 +0800
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2xbiVp8GZlSFIOC6XiDS7VGfRLcBEkb46"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2xbiVp8GZlSFIOC6XiDS7VGfRLcBEkb46
Content-Type: multipart/mixed; boundary="XV30WNxkKM3Gh8RWeo6Pp7XRGUQanKL7N";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <521779a7-60bc-c7c9-b35d-77c5e36aaacc@gmx.com>
Subject: Timeline or roadmap to split lowmem mode and original mode check?

--XV30WNxkKM3Gh8RWeo6Pp7XRGUQanKL7N
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

There is the long planned work to split the original mode and lowmem
mode check into their own .[ch] files.

I found it harder and harder to locate repair functions for original and
lowmem mode when writing fixes for them.

I wonder if it's a good time to start the split work, and if you're OK
with it, my plan is to:

1) Start the split work based on 4.14.1

2) Split check code into:
   check/common.[ch]	<<< Not sure how many functions will be there
   check/lowmem.[ch]
   check/origin.[ch]
   check/main.c

Currently most fsck fixes and enhancement are from Fujitsu guys who I'm
quite familiar with, so rebasing their code won't be a big problem for me=
=2E

If this works for you, I can start the work asap.

Thanks,
Qu


--XV30WNxkKM3Gh8RWeo6Pp7XRGUQanKL7N--

--2xbiVp8GZlSFIOC6XiDS7VGfRLcBEkb46
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpe3/4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgkIAgApX1IuRXrO/BtWWOP3TGw4XDd
3NVWhFvpH5ApugQydcNtKAOrzn3zm8ZCrvvNyceJ+yeueqv3oRdiOjlFTSEthHdL
xguy5Ue0KNtMl4sDSkiv58jNDdRo8rVwjO1BCII0xLq//MyfbuQRzHzeTVQxgGvl
9uDR0zjKgs9rkRldaWz6craz6hi+RHZny67HR9HXn21Um/Ud1Ja2A0N8lJPfmtvC
0WQxkYxoykNW5HMz99IW2rf8oo20gDQ4C6WT5ljrSDijjGp1NXy2Cxc/837j6Tod
SantgwE0mLuwBl862yatop8BkYfTJ5EclfNu8cg4ivdzjPykqycP5NEpKPuClQ==
=P583
-----END PGP SIGNATURE-----

--2xbiVp8GZlSFIOC6XiDS7VGfRLcBEkb46--
