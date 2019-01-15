Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA42EC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 00:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B290120659
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 00:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfAOAzH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 19:55:07 -0500
Received: from mout.gmx.net ([212.227.17.21]:44477 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfAOAzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 19:55:07 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LcmN9-1h8sW32Zfz-00k6Fj; Tue, 15
 Jan 2019 01:54:38 +0100
Subject: Re: [PATCH v3.1 3/7] btrfs: relocation: Delay reloc tree deletion
 after merge_reloc_roots()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190107054151.18662-1-wqu@suse.com>
 <20190107054151.18662-4-wqu@suse.com> <20190114172107.GE2900@twin.jikos.cz>
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
Message-ID: <8b353e42-90b3-235f-b172-6f0cb55b2feb@gmx.com>
Date:   Tue, 15 Jan 2019 08:54:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190114172107.GE2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BQi2a3K9kLeIjz9KwRb3ujZwj12Bw7j9N"
X-Provags-ID: V03:K1:dQbiwauh+C2ZkF3xWHclTU6eS+IDrk7V1CA6ccHCUjX8C3sLvYw
 Accnc6rqn93socZ6Wc4so0h3h826wAztf6w9eWuCuJ/lJOGftsNe7GnMpIYAMu8O6EncKid
 DFJtFQTzhDooN+zM5nWK7KwF89lWtMOl8VDga/n1K1UZ+8d3EU3UdiagUk1hYZP8yyLDbpd
 CGEFcUc8WO1bx+fIiJbKw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mfwnc6gA3c8=:FYuZ9Z4o2XGbq4pGe2vj3O
 g9QYuAI0LR20DfYnZ2o7eoLDcvmU/SQkr/zqouG41816gmKLDkyv2sGs2Ubi4fF4k1rAgRWfD
 Hv8QBMFTKzlzXP+Asom+Jj4WZFHrVEiTQvRaKSyLd9y8vJ4Rqu4Knyc5bzxVSNgOiTFH3fUz7
 bWEdY3NQc2jydE3uhSY3xeJMGqRg2EIJf1OJJ9ROgUxXOi5+ulo6lCbfrXi+GE0EIviwbyINE
 xfnObPqWkhEztDN/tvEB35UzFLHry/uxeNRaVpq5SDODbV74YgyGy3YlAbKI9KPHd2FuHcAf4
 7McQrg6SsHTrc5pM5tH5lk1AlnQehLpt4zla2deJjBKz8MUtpp8jGIIj+8T42L+wyNTGlC/ih
 aS22Vl+4Cl0FYzgW2ajox9RdC7eMfGbXTSywsyn61MHCvRsN8wsaU72Q5+82+DaiMqx8a1szg
 1XdNxQBjLp3Xp5EuG4KIsIYFUWpUJIjTciVfM2bY3CvdLI0q/DY7ZNff8NiwQXH3Twuz+XtJJ
 SDQfb/qckJarR8IUwVCuD1kSKa6cl9237UwQ992H/j449gxjK24gHkYvesaTjn1nMK6+MPvJj
 INC3Hq7D2KPMwh8MGOdSiUpHcGue8QmN2l4MQUL/ovcD68GPYQ6HOGtzludCyQwR65n2Hyx6T
 M513qOyL4PEf2dQ7xG+1tRZ07wYldkzZqcbYoja1GfNQJ6h1TvsGd+LhQA1lGWiYCD+lPQERN
 olXn3ahLJHHk1nXjNPlH60rGwXKS2lINTLZLyRVMaWLk1IXODNyNGwk2hgzU0zJHb2sInb621
 xf8r1XFq/iYgD1kDSeCK+PDg4kKR6kyJN2FkawTfsDzAdcCQzLH2dvu79hvIqGHXbsqEWL6/e
 Hz7XyviG+BuZg6yp8t5vO6/TmOroukXI0SlIwKdro9n394TiUkcc3MDQYcCrB9
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BQi2a3K9kLeIjz9KwRb3ujZwj12Bw7j9N
Content-Type: multipart/mixed; boundary="3FLF4cUPm2QmZHnOYVKWyuuuyrVCwBXLt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8b353e42-90b3-235f-b172-6f0cb55b2feb@gmx.com>
Subject: Re: [PATCH v3.1 3/7] btrfs: relocation: Delay reloc tree deletion
 after merge_reloc_roots()
References: <20190107054151.18662-1-wqu@suse.com>
 <20190107054151.18662-4-wqu@suse.com> <20190114172107.GE2900@twin.jikos.cz>
In-Reply-To: <20190114172107.GE2900@twin.jikos.cz>

--3FLF4cUPm2QmZHnOYVKWyuuuyrVCwBXLt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8A=E5=8D=881:21, David Sterba wrote:
> On Mon, Jan 07, 2019 at 01:41:47PM +0800, Qu Wenruo wrote:
>> +/*
>> + * Helper structure to keep record of a file tree whose reloc
>> + * root needs to be cleaned up.
>> + *
>> + * Since reloc_control is used less frequently than btrfs_root, this =
should
>> + * prevent us to add another structure in btrfs_root.
>> + */
>> +struct dirty_source_root {
>> +	struct rb_node node;
>> +
>> +	/* Root must be file tree */
>=20
> The naming starts here and is used in the following patches too: the
> naming is IMO confusing, here it's still ok but variables like
> 'file_bytenr' or 'file_parent' sound weird in context of relocation.

'file_bytenr' and 'file_parent' are introduced in the 5th patch.

My main concern of using traditional naming like 'source/destination'
is, for swapped blocks, source/destination needs extra context to
determine which is which.

So I tend to use naming which shows directly to which tree the block
belongs.

>=20
> The file tree is the subvolume right, or would it be confusing in
> another way?
>=20
So did you mean use something like 'subv_bytenr' and 'subv_generation'?

I'm OK for this naming.

Thanks,
Qu


--3FLF4cUPm2QmZHnOYVKWyuuuyrVCwBXLt--

--BQi2a3K9kLeIjz9KwRb3ujZwj12Bw7j9N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw9L0MACgkQwj2R86El
/qicDQgAq3VrwGvDNJh7EN1/nYzId9J/rSvg4PiaXo873RCYdbn97ZY7ofOvj9Dj
R0FHAT2iaSIxAQj2jNnMH5aRDjX0LgxftDMbPN1eTR56vUK/LgrgZRJ+BASGHZnw
Nrz6sTwzKKNd6sN90Zx8krUZRwfAAHkgwWQI4NANRtwzmBnoLDf6qXs7diNu9r36
hJ0Wa6BJIIK1EA5Eb/N8ZqzWRUnId+bCw/sbC2ZiK5atQhENorHCIEWssRWwp+5f
HTZdoIOKB46iODdq1zFtXKCjblf4BfeYkkHWzVY9HcEX2ZsLT8IKAxeeO4t/tf9X
VID3oxh5UZbbxoZMrwMlZk9ZzyZ3jQ==
=AdGJ
-----END PGP SIGNATURE-----

--BQi2a3K9kLeIjz9KwRb3ujZwj12Bw7j9N--
