Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E1BC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 02:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 628AE21850
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 02:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfB1CJR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 21:09:17 -0500
Received: from mout.gmx.net ([212.227.17.21]:38415 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730240AbfB1CJR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 21:09:17 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M93Jp-1grFhK1KvN-00CS7b; Thu, 28
 Feb 2019 03:09:04 +0100
Subject: Re: [PATCH v2] btrfs: extent_io: Always return error pointer for
 extent buffer allocation failure
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190225043801.17321-1-wqu@suse.com>
 <20190227170653.GZ24609@twin.jikos.cz>
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
Message-ID: <2b6b667c-3457-2750-8ac9-07a8f2d13b26@gmx.com>
Date:   Thu, 28 Feb 2019 10:08:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190227170653.GZ24609@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GKdW930AYac3X4teTO2NuolSQ0BrYS7Wq"
X-Provags-ID: V03:K1:XHai5OhfbRMqBAW19vtpB8gjo5hoPU1q4P8VDg7NU09wHTTh3Uc
 534umpuiGwXi7N6Amq6E8owbcgLpuYtMbNnSqLz2cguXKM4zo+hZ6h1myg+tTUIFpiQbuqV
 pMKg9TL4upIIHRopRfOOTOBKMLx+iaKfkytGIhalxIySzOkDtGNP29rv6YASKg/jrsUGdGs
 qJOOKNYFB9onPvQv5PwqA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KxRCb1GSdg8=:T7GDu6EhyolI5IDscaB3fW
 BQ2r03UgPIdhOLWgBEt6RQ/bAvVBAAkrZ4Q+pa9UlfRgern7U5lRUEWCJ9KGnz6h3y41SvRvI
 t+khhrMLgPHALKfEImBDYWCBrGkwzjE4QrKgqP+2ymufjQDviHdN3faVGGshmLHPI36wlSpNV
 DxFqWxlqKDpjRKVL9ppicAiGuL3kNX+fNmT4Wg+gpxgtG0ecePb42xfO2zlpQI/W0v1gxBxil
 wwOFyPXhTDxId9le4GVzC2FcJtnQc/RZ4ietnsQ/hoOsa1EUUp/RMa/1xB1cfyAi2YxK7rNLB
 YBpN6LPs8gDkYWzMvGE6AyV1FjhGZuIN20w0KQtgYG3KPfxIuibr6T/8JD92NXaTQg5Ou+wTJ
 DCWUQYKXbyXCj24Q3zSijkCp42Tnkqjndq4ep6hK4PX6VxZs38iM+lb0f8LsvObvslRYXaqdy
 JQfW2HfQuQavPt8y4VnmUVexneqslAezpWa2YWvJWz2CUSLLMP1tgDvq95OLqp9g3pEFfTXwk
 fUaxBl2U4IpEQLL8uA9gp+/WenOeXll5V6Unesb5rm689b4Wm8cSwN2+++gJwHEo4TjCFrLpV
 WDsVNBbYYATDgvX1Y9/M9SRooIiOKjujjs3QQgaI4JWHhE0JATl8UIQt1qEQ1ZqSX1zYm8K2o
 kKTt7mq1Ac0Ml7sLjI7BkhUH8bLQOoqjsjeL1eH1DWUxkUAHvZjhGZFbA1rZRZqY1P2A/QIwe
 8tVphkEx33VbU9xyd4fTh5RExPlCWIQwp1LRH9yCyk/30tzUKZXdu/hg+u1dRTUAsrHtpxekH
 f7/dJJYRQZqOtB/irwo2nnqyyM/DPNAfg7AhZkjRousU1kZU//BaFoc9iE2Sa+6+3NwkcDOpn
 4+njHn+jxPMGpT29bTvRgf8yvIfIuo0211LK2OlNNIRwlcN9kS72ygX/pQ9ar8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GKdW930AYac3X4teTO2NuolSQ0BrYS7Wq
Content-Type: multipart/mixed; boundary="02J5QHXQqZweZelgkaGWlLhcRFn4QeYI1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <2b6b667c-3457-2750-8ac9-07a8f2d13b26@gmx.com>
Subject: Re: [PATCH v2] btrfs: extent_io: Always return error pointer for
 extent buffer allocation failure
References: <20190225043801.17321-1-wqu@suse.com>
 <20190227170653.GZ24609@twin.jikos.cz>
In-Reply-To: <20190227170653.GZ24609@twin.jikos.cz>

--02J5QHXQqZweZelgkaGWlLhcRFn4QeYI1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

[snip]
>>  	ret =3D radix_tree_preload(GFP_NOFS);
>> -	if (ret)
>> -		goto free_eb;
>> +	if (ret) {
>> +		btrfs_release_extent_buffer(eb);
>> +		return ERR_PTR(ret);
>> +	}
>>  	spin_lock(&fs_info->buffer_lock);
>>  	ret =3D radix_tree_insert(&fs_info->buffer_radix,
>>  				start >> PAGE_SHIFT, eb);
>> @@ -4875,21 +4892,26 @@ struct extent_buffer *alloc_test_extent_buffer=
(struct btrfs_fs_info *fs_info,
>>  	radix_tree_preload_end();
>>  	if (ret =3D=3D -EEXIST) {
>>  		exists =3D find_extent_buffer(fs_info, start);
>> -		if (exists)
>> -			goto free_eb;
>> -		else
>> -			goto again;
>> +		if (exists) {
>> +			btrfs_release_extent_buffer(eb);
>> +			return exists;
>> +		}
>> +		goto again;
>>  	}
>>  	check_buffer_tree_ref(eb);
>>  	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
>> =20
>>  	return eb;
>> -free_eb:
>> -	btrfs_release_extent_buffer(eb);
>> -	return exists;
>=20
> Changes in this functions are more than just the conversion, namely
> undoing the common exit block and adding the inline returns. These are
> different logical things so I'd rather see that in a separate patch.
> Thanks.

This part is not just undoing the goto branch.

For the error just after radix_tree_preload(GFP_NOFS), we're doing error
out.

For the return after find_extent_buffer(), we're returning valid found eb=
=2E

The old code is abusing the exit for both error out and found case.
Due to the change to ERR_PTR(), we can on longer follow that abuse any
more, thus I have to remove the old free_eb label.

Thanks,
Qu


--02J5QHXQqZweZelgkaGWlLhcRFn4QeYI1--

--GKdW930AYac3X4teTO2NuolSQ0BrYS7Wq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx3QrkACgkQwj2R86El
/qjOOQf+Nnqv+JYyy2QwzSclMx59lXRIL9K/HXKyN7qArntPrjrYYMcN42harqPT
siB76gXh2rtmEnjl16AYh5R1aXDlIAGzoEbUl6JgoD0znn7e2o5tgmI8OAOv9M9i
OcFacl6M/uuPzZWsDgEakK4i3lq30kLF0YH2NZp6Gb8gOCt4R9PATuLrNIEePQe9
93VqUyW7JQhO2pvVfQ4SB7Anhfr0nQ548rw3RVOprp0xf0cw+3gJErrhYwWQes1l
5or7Oz7gHt2bI5vGaFC/S1HublWLqt8Hpv1t/bn+m0Mkt2Ek9mWOPzyP/Uv3vW0X
SE1gSjKu8pQ4QuvJ6o8DJ5HHyTvecg==
=A3DW
-----END PGP SIGNATURE-----

--GKdW930AYac3X4teTO2NuolSQ0BrYS7Wq--
