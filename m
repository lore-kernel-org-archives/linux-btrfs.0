Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7655EC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 01:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36BA8217D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 01:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbeLRBND (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 20:13:03 -0500
Received: from mout.gmx.net ([212.227.15.15]:56843 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbeLRBND (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 20:13:03 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M5uLh-1hJbum0FZZ-00xpYr; Tue, 18
 Dec 2018 02:12:53 +0100
Subject: Re: [PATCH 0/5] btrfs-progs: check update
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181126060438.26075-1-wqu@suse.com>
 <20181217195921.GU23615@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <ecb53c7a-a716-518d-94a4-77e3c7b1e34d@gmx.com>
Date:   Tue, 18 Dec 2018 09:12:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181217195921.GU23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4osLxOnX2mt3nHZTfTnavTh2pEmyexyi8"
X-Provags-ID: V03:K1:oNKx85b/YKfW5HRHwrQtTZIOkGVA69MsMJUpwKeX46XJhVBObzB
 QrZCSY/B0y6VLeHf4NtNNFFW/TAyxBQzTNSmySQ5GyK3VBbcC7A+Rccd+KFYpjNzPaDM9na
 XVApBRVTxFxjgGbk4j8dac3SX0ascJ2shbEWu6whZe3vDAoa6qZ4IgfwEKuhpY2Dv09rnbE
 n5cu2VQKo0EP3c5vqqLIA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7IJ5Vlz3taM=:a5AiRmj9ocS7iWQ/0dftCK
 xvCPJh5t0BDs7TzR+k0Pw1jALHx2kSSkqurzxqfRHFcqH4Fxfc5DhhNW1xUXLvBUm+gz6N2va
 zB6/sKFvpNSw0y8Yd6CoWdV5FI5Cxl/1Vr1nGFHrSUmZb6OGaOwZQG3UA9piR1SxhCSOVJgfB
 xYMYX6heaG0eroRld8y+1m3P+AFDHMUbG7P45lZDT1SBi/NNbS479YWoH5Kr0E7xNniZNOeTv
 D1eR31MTsLJ8m+nJUSKDPYa9NKNVAzrRNOiirtPgSWsPWLDvUowYAOxn7WAryvFvdijUeORCv
 boNvRp1ucZU3JbQNj7YcXU/mnJopeGKraGJEiMcpKaMW7vwqz9zdtGyxOads/sPA0nKM/ASxU
 Y5XubVZVEAHPEO30tSgClpLeeC9t2nS0C9KK0kg+uJHEhuHES95DhjPueFfAfuB42q17PFhOy
 euVOa82okSlmfYb5wK6fOKjy6ymBWyYt6H+kQvGmhX11KHqsrZ99y5VcKeVFmbTDnfdOOjO8u
 hctIg7OBRK47vF6liBMr7S1Py4MgDoKtXuV4SBE96S/2mUxz3l/7j/Z3414cg/pmfTrM07PRP
 nOoirqKe3WygfoTUypAw7ztwrsUlfmRI2uY7YiQOoy8sHD568CareWqYm26+uv30sUsD3sohR
 +dn6TdWqF72WfoOM/+edrW4q5giEOCt3OaKAUclQRLZPFCUtkfVtPmmGb6cw9PQWKLoS68MYK
 DK6Op4Kxfi40ovYKm2YJ+S+fyuEXAg9H3gVbT8Gb+vRoqf+QqT+A3usyy6jALAp1TyNBDOY8h
 Y9DNuJXF8Iv6uodq9gvYu5lOqSOxaGLVH4K9GP7EghWGH32mUIlVk/VrljUQFqx9U/oNdjLZt
 pUnEHeD5hwXm/W0m/Iy4+otGLOarhJ/mDEFzvAsLQ5qcBAAzFVpLnar4NfCO7l
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4osLxOnX2mt3nHZTfTnavTh2pEmyexyi8
Content-Type: multipart/mixed; boundary="qe8zmVvUoeo1IK04iWWDLfRWQMrfbbrMd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ecb53c7a-a716-518d-94a4-77e3c7b1e34d@gmx.com>
Subject: Re: [PATCH 0/5] btrfs-progs: check update
References: <20181126060438.26075-1-wqu@suse.com>
 <20181217195921.GU23615@twin.jikos.cz>
In-Reply-To: <20181217195921.GU23615@twin.jikos.cz>

--qe8zmVvUoeo1IK04iWWDLfRWQMrfbbrMd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/18 =E4=B8=8A=E5=8D=883:59, David Sterba wrote:
> On Mon, Nov 26, 2018 at 02:04:38PM +0800, Qu Wenruo wrote:
>> Hi David,
>>
>> Please merge this pull request:
>> https://github.com/kdave/btrfs-progs/pull/155
>>
>>
>> This patch can be fetch from the following branch:
>> https://github.com/adam900710/btrfs-progs/tree/check-next
>>
>> The base commit is:
>> commit 5d64c40240135cc22f4ba2b902bfe20418a599ea (david/devel)
>> Author: David Sterba <dsterba@suse.com>
>> Date:   Tue Nov 20 11:13:08 2018 +0100
>>
>>     btrfs-progs: docs: fix rendering of exponents in manual pages
>>    =20
>>     Reported on IRC that the inode number limit appears to be 264, whi=
le the
>>     actual value is 2^64. Fix that for the manual page backend by rede=
fining
>>     the format.
>>    =20
>>     Signed-off-by: David Sterba <dsterba@suse.com>
>>
>>
>> This small patchset contains 2 check related functionality:
>> 1) Ability to repair dir item with mismatch hash
>>    Both lowmem and original check, along with test case update.
>>
>> 2) Check qgroup limit exceed
>>    The patch to deprecate BTRFS_QGROUP_LIMIT_RSV_RFER|EXCL is dropped
>>    for this pull request, as it's still uncertain if it's OK or not, a=
nd
>>    it's very easy to rebase that patch.
>>
>> The patchset passes all selftest with one exception:
>> misc-tests/021-image-multi-devices
>>
>> That test case failure is caused by poorly recovered multi-device
>> btrfs-image.
>> The problem exists from the very beginning, just recent enhanced kerne=
l
>> code will refuse to mount and I'll address it later in another patchse=
t.
>>
>> There is some other check related patches, naming "btrfs-progs: fixes =
of
>> file extent in original and lowmem check" from Fujitsu, which is still=

>> being updated. I'll push them in next update.
>>
>> Thanks,
>> Qu
>>
>> Qu Wenruo (5):
>>   btrfs-progs: lowmem check: Add ability to repair dir item with
>>     mismatch hash
>>   btrfs-progs: original check: Use mismatch_dir_hash_record to record
>>     bad dir items
>=20
> This patch changes the output style from "report when it happens" to
> "print a summary". I find the latter a bit more unfriendly as it can
> take long time before something gets printed at all and it looks like
> there's no problem with the dir items until that point.
> Also if memory allocation fails at the time the entry is added to list,=

> the information is lost.

I though the summary mode is the default behavior for original mode.
I'm happier to change it to report-when-found behavior.

>=20
> We can do both but would need to set the verbosity, the default can be
> the summary. For the verbose level 'more-is-better'. The output of chec=
k
> needs to be improved, that's known, so I'll take the patch as-is, the
> overall output changes would need a full code audit anyway.
>=20
>=20
>>   btrfs-progs: original check: Add ability to repair dir item with
>>     invalid hash
>>   btrfs-progs: fsck-tests: Make 026-bad-dir-item-name test case to
>>     verify if btrfs-check can also repair it
>=20
> The patches look good.
>=20
>>   btrfs-progs: qgroup-verify: Check if qgroup limit is exceeded
>=20
> This patch has very short changelog compared to what it does, can you
> please update and resend? Thanks.
>=20
No problem.

Thanks,
Qu


--qe8zmVvUoeo1IK04iWWDLfRWQMrfbbrMd--

--4osLxOnX2mt3nHZTfTnavTh2pEmyexyi8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwYSZAACgkQwj2R86El
/qhSpQgAoI3+rBcWHXoxnfADq4WeSxUaBcBieEy/l5c27RrdZzqt3z2tiok0KS4d
lOsAvOSBM0/9FxlSceHn240BopoSUICEbv6qgcqRUXBNnwP8cf4PrGFZG2SFd7+a
6IAvJJX9cZ0tyk0pYo3jtoL2imxUJCpUYLFPsv6KHDZ0h0jfXdvtILgt0elZ/Xms
lRkoZaGOwHFHBWx/i6wFzwCDoVAPFhddP0Dy36U4TlTVtBo77MKlwGE7lEHe78cA
3tdKZad+a//9zF5h+QDZExhfKbvVNGRwWLYjK8T2jlHx5crU+CqCGlDLQ4jLRG0T
WfB+r/ZsIRHpd0nBkkDpn1VNTb8CEw==
=LPg3
-----END PGP SIGNATURE-----

--4osLxOnX2mt3nHZTfTnavTh2pEmyexyi8--
