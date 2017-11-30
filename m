Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54687 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdK3G4X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 01:56:23 -0500
Subject: Re: [PATCH 1/5] btrfs-progs: Add location check when process
 share_data_ref item
To: dsterba@suse.cz, Gu Jinxiang <gujx@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, lakshmipathi.g@gmail.com
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
 <20171128190239.GC3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <552db79a-ccd1-3dcb-05fb-a5e2cc26f73f@gmx.com>
Date: Thu, 30 Nov 2017 14:55:49 +0800
MIME-Version: 1.0
In-Reply-To: <20171128190239.GC3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1Wo7nq9H7sBRBmDpC81Dc9nIF8t7diUoO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1Wo7nq9H7sBRBmDpC81Dc9nIF8t7diUoO
Content-Type: multipart/mixed; boundary="LU4bBi547a2AK0pjPHPKibwcdMvdlpm3e";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Gu Jinxiang <gujx@cn.fujitsu.com>,
 linux-btrfs@vger.kernel.org, lakshmipathi.g@gmail.com
Message-ID: <552db79a-ccd1-3dcb-05fb-a5e2cc26f73f@gmx.com>
Subject: Re: [PATCH 1/5] btrfs-progs: Add location check when process
 share_data_ref item
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
 <20171128190239.GC3553@twin.jikos.cz>
In-Reply-To: <20171128190239.GC3553@twin.jikos.cz>

--LU4bBi547a2AK0pjPHPKibwcdMvdlpm3e
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8829=E6=97=A5 03:02, David Sterba wrote:
> On Fri, Nov 24, 2017 at 06:41:28PM +0800, Gu Jinxiang wrote:
>> The following test failed becasuse share_data_ref be added into
>> extent_cache when deal with root tree node.
>=20
> The whole function run_next_block would need to be revisited with
> respect to error handling and sanity checks. Adding them only when a
> fuzzed image hits the particular code path is not IMHO the best
> approach.

As suggested before, backporting tree-checker from kernel may be a good
solution for all later possible fuzzed problem.
(And can make btrfs-progs become a good testbed for tree-checker related
patches before merging into kernel)

For this particular case, planned key->type check against root should
handle it quite well.

Thanks,
Qu

>=20
> If there's some fuzzed test case, we should try to find all similar
> missing checks and fix them before moving to another type. Addressing
> only the failed tests gives a false sense of fixing, there are usally
> more similar bugs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--LU4bBi547a2AK0pjPHPKibwcdMvdlpm3e--

--1Wo7nq9H7sBRBmDpC81Dc9nIF8t7diUoO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofq3UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgURwf+I/8xcMYE2XU79NDLT9Qq0tuO
Wh6Ef8Vs1PQbXS1XliFusQ6ZinOriZEsGM9tdUItIRyEmZvJbq1R3yT5NjxQ7H2l
/RGrVNBZoPv+Yr6rxQXTZ5GgPQumj4C1k0F/L10AQZVdmtyrlkxmeTXLpKLLBwqq
NgPcQl9eNWKtHwYlYsheX5gOLl+0Rxjk1gF8JvYcl7Qc9u5eSPXjJg4Tg64kbbyV
NUXYnm6h8dUC00zW2cxL5mLwxr4ST2oVG1PlmrgejsuNb93XB3ABz0UCacRCLzdo
561aXJiK71VQnyRyfpeYCTQefOqp7MhcnLF61Sg5szw/3dA8PxlkBR4qZfIByg==
=8EdD
-----END PGP SIGNATURE-----

--1Wo7nq9H7sBRBmDpC81Dc9nIF8t7diUoO--
