Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53497 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbeAKBbL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 20:31:11 -0500
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
 <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
 <d9ab30af-0b3a-7021-876c-5e545b417d40@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d5c6d2f2-97ab-4ccd-f1f2-ca4506bef138@gmx.com>
Date: Thu, 11 Jan 2018 09:30:58 +0800
MIME-Version: 1.0
In-Reply-To: <d9ab30af-0b3a-7021-876c-5e545b417d40@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ASuYbcVLdnTCl5yaMSDpoExHYWNfRZjDn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ASuYbcVLdnTCl5yaMSDpoExHYWNfRZjDn
Content-Type: multipart/mixed; boundary="ZJoIkheR1CxyaDlg9OtnVgc1m8PhZr8sq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <d5c6d2f2-97ab-4ccd-f1f2-ca4506bef138@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
 <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
 <d9ab30af-0b3a-7021-876c-5e545b417d40@suse.com>
In-Reply-To: <d9ab30af-0b3a-7021-876c-5e545b417d40@suse.com>

--ZJoIkheR1CxyaDlg9OtnVgc1m8PhZr8sq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8810=E6=97=A5 23:33, Nikolay Borisov wrote:
>=20
>=20
> On 10.01.2018 03:30, Qu Wenruo wrote:
>> That system chunk can be relocated by balance, and in that case new
>> chunk may start beyond 1M.
>>
>> So the most reliable method would be manually checking the the first
>> device extent of this device, and to determine if we should minus that=
 1M.
>>
>> If the first device extent starts beyond 1M, reducing 1M would be good=
=2E
>> Or don't modify it.
>=20
> So assuming I run generic/015 on a system with your mkfs patches to put=

> system chunk after 1mb and I implement a logic in
> btrfs_calc_avail_data_space to subtract 1mb if the first extent of a
> device starts at 1mb. In that case the test is still going to fail i.e
> have the discrepancy of 1mb due to 1mb being subtracted first due to
> there being unallocated space on the device, but then on the second df
> btrfs_calc_avail_data_space will return 0 so df is going to report spac=
e
> only from the block groups.
>=20
>=20
> Thinking a bit more I think with your mkfs.btrfs patch there is no need=

> to check where the device extent starts, since now we are guaranteed to=

> always have a hole of at least 1mb at the beginning.

The check here is mainly for old filesystems, whose device extent can
start in the reserved range.

But considering the difference will be no larger than 1MB, and using
small filesystem (100ish MiB) is already very rare in btrfs, such
difference won't really cause much problem, except for the test case.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ZJoIkheR1CxyaDlg9OtnVgc1m8PhZr8sq--

--ASuYbcVLdnTCl5yaMSDpoExHYWNfRZjDn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpWvlIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjMLQf9H3O1bKTG2ruzQTnjUkDswQhA
ukqWSrJVDopd5rHQJuv2LWiR/0N01i3rAd3aAOOVelY8xdXmnGtf3XvNljBmasgE
nXKPC6E3+PP1A/clnzp8ibFp/SMCE0PCa8yPcHtGCUkFpb1aaR6zFTvfVLVEQGD/
l6R2soX6dKud3fOAJdPDpujqhFN0Ui4uja0jh0nRinIA7u5bCghWYogc6h+oh6km
r3CqBYw4LK9BVl0FitMZd1Iicm6YNKY7/Au3fDXBaOBR3rwonXaxrQIUAhr2b3LF
cU8pnAzsCQIa9jObh5q4Ucc/k/hnTTy1mkUb2OsPKTCWazMfS43qzJ6I3O2Ebg==
=0DKN
-----END PGP SIGNATURE-----

--ASuYbcVLdnTCl5yaMSDpoExHYWNfRZjDn--
