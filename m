Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63954 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbdLMAze (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:55:34 -0500
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        jeffm@suse.com
References: <20171212073436.16447-1-wqu@suse.com>
 <20171212211209.GB3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <645e99a8-67ee-b3ce-89cc-e60a481f4bc5@gmx.com>
Date: Wed, 13 Dec 2017 08:55:21 +0800
MIME-Version: 1.0
In-Reply-To: <20171212211209.GB3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xNKxqcCfUQOtTEDcSKJIaKoaMGrHKtQTG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xNKxqcCfUQOtTEDcSKJIaKoaMGrHKtQTG
Content-Type: multipart/mixed; boundary="t58Mgb17QXA27VEnFa3jTkhrbdKoFAsNh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 jeffm@suse.com
Message-ID: <645e99a8-67ee-b3ce-89cc-e60a481f4bc5@gmx.com>
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
References: <20171212073436.16447-1-wqu@suse.com>
 <20171212211209.GB3553@twin.jikos.cz>
In-Reply-To: <20171212211209.GB3553@twin.jikos.cz>

--t58Mgb17QXA27VEnFa3jTkhrbdKoFAsNh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8813=E6=97=A5 05:12, David Sterba wrote:
> On Tue, Dec 12, 2017 at 03:34:22PM +0800, Qu Wenruo wrote:
>> The patch is consist of 2 main parts:
>> 1) Type based qgroup reservation
>>    The original patchset is sent several months ago.
>>    Nothing is modified at all, just rebased. And not conflict at all.
>>
>>    It's from patch 1 to patch 6.
>>
>> 2) Split meta qgroup reservation into per-trans and prealloc sub types=

>>    The real work to address metadata underflow.
>>    Due to the over-reserve problem, this part is still in RFC state.
>>    But the framework should mostly be fine, only needs extra fine-tuni=
ng
>>    to get more accurate qgroup rsv to avoid too early limit.
>>
>>    It's from patch 7 to 14.
>=20
> I'm going to add the whole patchset to next, the first part has been
> there for some time and no test failures were reported. I optimisticall=
y
> expect that the second part will also be fine.

The type based reservation is completely fine, since it doesn't
introduce anything new, just a preparation for the incoming meta rework.

However I prefer not to push the whole patchset to upstream until
over-reserve behavior is solved.
Since it breaks quite some test cases with small limit.

> However I'm not sure how
> good is the test coverage of qgroups in fstests, so lack of reports may=

> not mean anything.

That's why I submitted mkfs.btrfs quota support some times ago. :^)

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--t58Mgb17QXA27VEnFa3jTkhrbdKoFAsNh--

--xNKxqcCfUQOtTEDcSKJIaKoaMGrHKtQTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlowenkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiaRwf/aCt4leWhh699Q7PxHEqTsnlD
vxnYjVcToHp+hg5qYAjJlYZ5mhStYJcxY3MrEqotDTAuOmJZzwieTPeqDwBoDmze
v3edVOWznbAn3hEHYNbdTExcr7vl1FhWWa0+HyIO+kjyDf7ggpqi3uy3R27I1zLO
3saCQC3WXsFH499tT3WEX8jp0fVaqXmCqQ8QZlvkS4Tl+QiDFaXaemBIBK3ggDfx
f+HMRPoTWQpLvZVjGSSDQ3V8D6uWsa+6ehwsnNrK2nrb5tcm7m24QuSs0OelGPHT
B4Yi26FHSST41tF8bhQeeOnCeMNH85Gm4pT74qgsYqHXMtgUdBZ2Kcn+rcuoeA==
=6nUL
-----END PGP SIGNATURE-----

--xNKxqcCfUQOtTEDcSKJIaKoaMGrHKtQTG--
