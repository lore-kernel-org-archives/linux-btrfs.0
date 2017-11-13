Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49614 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751597AbdKMJEs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 04:04:48 -0500
Subject: Re: [PATCH 0/4] Lowmem mode btrfs fixes exposed by complex tree
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
References: <20171113073453.29198-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <99b3e9fe-2a91-f6e7-1bd6-d1f1063fef0a@gmx.com>
Date: Mon, 13 Nov 2017 17:04:31 +0800
MIME-Version: 1.0
In-Reply-To: <20171113073453.29198-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mBWMErANIE1VkMHQkUImkFguFuUn9gnQJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mBWMErANIE1VkMHQkUImkFguFuUn9gnQJ
Content-Type: multipart/mixed; boundary="T2BIUlvRVGcL28vM9nPcQe472Tt5xtJ4i";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Message-ID: <99b3e9fe-2a91-f6e7-1bd6-d1f1063fef0a@gmx.com>
Subject: Re: [PATCH 0/4] Lowmem mode btrfs fixes exposed by complex tree
References: <20171113073453.29198-1-wqu@suse.com>
In-Reply-To: <20171113073453.29198-1-wqu@suse.com>

--T2BIUlvRVGcL28vM9nPcQe472Tt5xtJ4i
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8813=E6=97=A5 15:34, Qu Wenruo wrote:
> The patchset (along with "backref lost" bug fixes and test cases) can b=
e
> fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fix
>=20
> Despite the backref lost false alerts reported by Chris Murphy, there
> are still some other bugs to be fixed.
>=20
> One is also exposed by Chris Murphy, where btrfs-progs backref can't
> handle shared block ref for metadata. Fix by 1st patch.
>=20
> And 2 more bugs exposed by the test image which is originally designed
> for the bug fixed by 1st patch.
>=20
> Last but not the least, here comes the test image.
> Which is an image with a lot of metadata and under a relocation.
> It is definitely a bomb for old lowmem check.
>=20
> Qu Wenruo (4):
>   btrfs-progs: backref: Allow backref walk to handle direct parent ref
>   btrfs-progs: lowmem check: Fix function call stack overflow caused by=

>     wrong tree reloc tree detection
>   btrfs-progs: lowmem check: Fix false alerts for image with shared
>     block ref only backref
>   btrfs-progs: fsck-test: Add new image with shared block ref only
>     metadata backref

The last patch is a little big.

Even the image is dumped by -c9, it still takes near 300KiB.

Anyway, it's a binary patch, submitting to mail list doesn't help much
to review.

If any one want to test or just to see the last image, please fetch it
from github.

Thanks,
Qu

>=20
>  backref.c                                          |   3 ++
>  cmds-check.c                                       |  35 +++++++++++++=
++++----
>  .../020-extent-ref-cases/shared_block_ref_only.img | Bin 0 -> 304128 b=
ytes
>  3 files changed, 32 insertions(+), 6 deletions(-)
>  create mode 100644 tests/fsck-tests/020-extent-ref-cases/shared_block_=
ref_only.img
>=20


--T2BIUlvRVGcL28vM9nPcQe472Tt5xtJ4i--

--mBWMErANIE1VkMHQkUImkFguFuUn9gnQJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloJYB8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjWYQf9GCKhHw0LDZ1WO/g236CMmgyA
QwZ14VpshXivB4QAVoS6INI39MXeljkaW/VglnjHDr2qrUeXWAGhaP26uSI7nw3P
fNTBIg/4/fxIop72rN3vM2CUn2ASf/EJC5qgcdPAlkPgU4TCnXxHxSRwsOiCEGvi
VU0IVXmoRIamW+YYDJDjY2InSTmy8Fl61fS98JJkhCmOWjXD8jMrwQ50PGUhLBbh
33mXLRgUVqlmcs7Iaj+lDPjIk/zJC3n70yFevN5HhDV+4xGzyT+puxw7YIGpk58M
50LtUFadi1p2djbeXfXaAHmz3CrWAMIDoTwdym3nakA0n/sjVbIXL33BhNf7aQ==
=oNDB
-----END PGP SIGNATURE-----

--mBWMErANIE1VkMHQkUImkFguFuUn9gnQJ--
