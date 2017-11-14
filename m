Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54188 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751076AbdKNH6q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 02:58:46 -0500
Subject: Re: [PATCH 0/4] Lowmem mode btrfs fixes exposed by complex tree
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
References: <20171113073453.29198-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ede186d7-2248-8f4d-e446-4a0f07d7b8f8@gmx.com>
Date: Tue, 14 Nov 2017 15:57:56 +0800
MIME-Version: 1.0
In-Reply-To: <20171113073453.29198-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KfAhnqbf34W7N24VDRQ4GKC0Q9wMBHuxh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KfAhnqbf34W7N24VDRQ4GKC0Q9wMBHuxh
Content-Type: multipart/mixed; boundary="tNkbJiGSfXvk5HF8VSMQQwNklG9C1fn8a";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Message-ID: <ede186d7-2248-8f4d-e446-4a0f07d7b8f8@gmx.com>
Subject: Re: [PATCH 0/4] Lowmem mode btrfs fixes exposed by complex tree
References: <20171113073453.29198-1-wqu@suse.com>
In-Reply-To: <20171113073453.29198-1-wqu@suse.com>

--tNkbJiGSfXvk5HF8VSMQQwNklG9C1fn8a
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8813=E6=97=A5 15:34, Qu Wenruo wrote:
> The patchset (along with "backref lost" bug fixes and test cases) can b=
e
> fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fix

Branch updated with new fixes for "referencer count mismatch".
Thanks Chris Murphy for his image.

If nothing goes wrong, the branch should fix all the problem Chris
Murphy found.

Thanks,
Qu
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


--tNkbJiGSfXvk5HF8VSMQQwNklG9C1fn8a--

--KfAhnqbf34W7N24VDRQ4GKC0Q9wMBHuxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloKogQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg0CwgAlze33kvumgrTsMK+DNXgau8q
WASzO/qDYxphldmlYe/0gZ/nC7xeqYXNXkFWVS8xoJifyIR3Su+Izzzs0ZVw/EiM
Nlqj3CPWzXj/w5c+aa+pQLJ4Rdne5Gx+iSA3BF4j+gchCuvv/u6IBmwp6mIC34g0
5APfXhnpdibxu7M9ZlYP/cxVxIzNBgkCpfYYQYqpqmeuP0VmXq7dLQ716FK0AMNF
3i+NZu5Z3XoS5I+N1akKMHTVRW4FjM2Sn3eP5bAbF8lOrQAJ9llJBHju2JToyAzB
yk1tFqVTM0wW4Fm+SyKXVorKsKLbbxSrudraxOGPMULIK0bI7Pv7SbqwySeqWA==
=QzBB
-----END PGP SIGNATURE-----

--KfAhnqbf34W7N24VDRQ4GKC0Q9wMBHuxh--
