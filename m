Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36151 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756268AbeEJBnY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 21:43:24 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: check: Make btrfs check return error for
 qgroup mismatch
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180430061700.18498-1-wqu@suse.com>
 <20180508174513.GO6649@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d28e1cb9-7610-89ff-4980-34a969fbe779@gmx.com>
Date: Thu, 10 May 2018 09:43:09 +0800
MIME-Version: 1.0
In-Reply-To: <20180508174513.GO6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nZLF66cdCAi75C7SHv47pVzRpk8L7OiCm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nZLF66cdCAi75C7SHv47pVzRpk8L7OiCm
Content-Type: multipart/mixed; boundary="t2P9q8oZtAKV0bv2w7e1aYP69sV6Faba9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <d28e1cb9-7610-89ff-4980-34a969fbe779@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: check: Make btrfs check return error for
 qgroup mismatch
References: <20180430061700.18498-1-wqu@suse.com>
 <20180508174513.GO6649@twin.jikos.cz>
In-Reply-To: <20180508174513.GO6649@twin.jikos.cz>

--t2P9q8oZtAKV0bv2w7e1aYP69sV6Faba9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8809=E6=97=A5 01:45, David Sterba wrote:
> On Mon, Apr 30, 2018 at 02:16:59PM +0800, Qu Wenruo wrote:
>> Current btrfs-check will check qgroup consistency, but even when it
>> finds something wrong, the return value is still 0.
>>
>> Fix it by allowing report_qgroups() to return int to indicate qgroup
>> mismatch, and also add extra logical to return no error if qgroup repa=
ir
>> is successful.
>>
>> Without this patch, fstests can't detect qgroup corruption by its fsck=

>> alone.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Applied, thanks. Please send the 0/N (cover letter) mail even for
> 2-patch series.

Any advice on the necessity of the cover letter?

Is cover letter highly recommended for any patches which have any
dependency like the 2nd test case?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--t2P9q8oZtAKV0bv2w7e1aYP69sV6Faba9--

--nZLF66cdCAi75C7SHv47pVzRpk8L7OiCm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrzo60ACgkQwj2R86El
/qjOyggAiFg70IoAGEqnSJRhBDv3j0stcJzmSAQv/2bH+C2G9s3jAn1X2DFZm1Rs
m5M6F63Cjj/08tmxUlWmXy5D50htV/G7qbXvNE6xQQPlrpsejUSjvSKzbTh7Ke02
bQQbJ4ExQk+MqXqPOakuTBb6JPFJUyrbr3qSPUHgGJpdFkq+faZQ6xboHqakeWmI
Xuunk8iKYZg8MIkwonkmxQgO2pamNppTuTIoooDWCy1/m0UvLADJ+fxgNNK/8ZCD
DyVixoGeHrmfc0spnoHT6OKmjk6ljffvHvskN/y2iwfM4HK0apDoImTkGhkK8qBD
6L/wWKAzFFBj+oq4AUSFde1plrGSGQ==
=asi9
-----END PGP SIGNATURE-----

--nZLF66cdCAi75C7SHv47pVzRpk8L7OiCm--
