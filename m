Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ABAC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 11:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC02A20657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 11:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfAQLmw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:42:52 -0500
Received: from mout.gmx.net ([212.227.15.15]:51185 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfAQLmw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 06:42:52 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MgLMU-1gYUxy0ygw-00NlFT; Thu, 17
 Jan 2019 12:42:49 +0100
Subject: Re: issue mounting volume
To:     Christian Schneider <christian@ch-sc.de>,
        linux-btrfs@vger.kernel.org
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
 <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
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
Message-ID: <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
Date:   Thu, 17 Jan 2019 19:42:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="igiAHzyIZO5yORWy9CKMCgxcKmEUUm880"
X-Provags-ID: V03:K1:te/ijgWLlZNyFVxAhtRlHoqg8qWRIk6pj4RBcXFIYqOegrpGYLb
 0BwvJVq5ANvBooQBk3mvtBan/1AkeoXoVwhbehQfq9+3ZXn0hX/mYlPbexk+mT0fpM6Yd9M
 Lyj7BGgmPU30ZVA8VUc93xVXcvcxM5zXhikn0L24vlV+/UQ1hGqovBeKAW7YoalkykiTY33
 oJsV9h0G/oYNag2Jp6EQQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pLEuKUs6kI0=:Rog2wlpqtQacMMHJCg92FM
 JuNq/BM2GiC16fDw5cjEUPzT+l3kRhs3n/tAzodDOSdJc/25V/yx/okAgt74OM9tDMucYNXQ0
 wrWzTTTGR5C55t0PmAoy7HYW2FRcA6QOrromGLZWZh3hVk/hsitpc3SwoTjsfml2N0YgcnQSJ
 S5pXx/NjGM1xSvjS4q7Hjz6twMo6XI/e6gYWs6jmHn1wzQH5LIIYkAK8z8ZQ+c8LZD+E8ZGMk
 2MFejsRw2R3E7StW7ZBx6vzfDpUzfwl4Yk9qhi3zukSd70Q2xYUBLf+kXV4crPBaEFJzr9gth
 wBZKfLZhfsa7hmL6c77nQH6rvmqxKjT3PDyYKUIkxF9gt7Haqw5btm05K0FOziAJ/xfGcs1ls
 jYQ0l9b5TQjDBzBGSYX6tbJqYaUwmQktWrSxM9nA3jwOj7lT56Zx12xdGqQigD3hX9qi7+UKg
 +7Bx8lgrNWbKns30PnX1utIhR3UaLUnmNaZuS3yD+Oq48NUR1y3r/CgDsu7evjSkM1tPnmzEH
 e4/6Z96b7eG5xZIJk7KZrtczqAlZRKRwomDqOTraEu2aPZVX1kSQ1DEhgohiNiAASQchxsul9
 Fs2r+oxZJh7wT6mafpcjDePUawexp4JkIGddfYDx8OeJkNXABcJyb8Wzo5GiTbUZnW7sGNB4i
 L+hTky4uNx0E+hBMCfwkMe/lb6Z6H089vV9cwC3lS1PDNv7WlhXeUM2wMd6pKSklqmgdw7ZMx
 mfRCIU6y53oaSnAV8AhjnlTKTscAp5BkdTyHN6UOPg3DkzG84y1S4hk+kAXQ/H0OY4UIrT4jh
 PDB8atWm23DZp/3QENXlEYlGoQnekhad1oytDa3UTFkGFgc55C46PEuquc2snh0kbONvf3TbC
 5RgnfOtINH1YpjMn5ivH0bpOmMzbCk8nFYzGKcsvZtukg5vFsTUpUVYoLpVIbl
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--igiAHzyIZO5yORWy9CKMCgxcKmEUUm880
Content-Type: multipart/mixed; boundary="joHzR47IVF7DycXB2JT3zc2enShhk5LA8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christian Schneider <christian@ch-sc.de>, linux-btrfs@vger.kernel.org
Message-ID: <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
Subject: Re: issue mounting volume
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
 <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
In-Reply-To: <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>

--joHzR47IVF7DycXB2JT3zc2enShhk5LA8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/17 =E4=B8=8B=E5=8D=886:42, Christian Schneider wrote:
>>
>> You could try this patch:
>> https://patchwork.kernel.org/patch/10738583/
>=20
> Do you know, which kernel is needed as base for the patch? Can I apply
> it to 4.19 or do I need more recent? If you don't know, I can just try
> it out.

My base is v5.0-rc1.

Although I think there shouldn't be too many conflicts for older kernels.=


Thanks,
Qu

>> Or go btrfs-restore.
>=20
> I already tried a dry run:
> btrfs restore -D /dev/md42 /
> This is a dry-run, no files are going to be restored
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> parent transid verify failed on 448937984 wanted 68772 found 68770
> parent transid verify failed on 448937984 wanted 68772 found 68770
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> parent transid verify failed on 450281472 wanted 32623 found 30451
> parent transid verify failed on 450281472 wanted 32623 found 30451
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
> We have looped trying to restore files in <filename> too many times to
> be making progress, stopping
>=20
> The filenames are actually directories, but as far as I understand,
> actually no files can be restored.
>=20
>=20
>> I'm more interested in the history of the fs.
>>
>> Did the fs get created/modified by some older kernel?
>> Especially considering you're using Gentoo, and every kernel update
>> needs time consuming compile, it may be caused by some older kernel.
>=20
> Yes, the filesystem is "older", though I don't really know how old, I
> would guess something between 1 and 2 years, and I update kernels every=

> 1-2 months. Unfortunatelly I can't give better details of creation of
> the fs.
>=20
> BR, Christian


--joHzR47IVF7DycXB2JT3zc2enShhk5LA8--

--igiAHzyIZO5yORWy9CKMCgxcKmEUUm880
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxAai4ACgkQwj2R86El
/qheowgAnFU11nmv8k7SjAFLQYWcpCu8IUeMF8gRQ/Tt4QGRZWWvHYUIzsrIMHb9
Rg4p7TJUGANQGZ4xcoQXs8aRWJRta/Xr12PV4bsaVTePx4oFTf7Su8JrkH+j+GPL
51s51lSXOYSzyN29pzG74wm9gPo1YOongP58WUK1l669unCT/9MA/14cwsrVxd72
+gbi+TW8zg8dqxY/Vft/N3a75mNl9aldVeXS5BL2UEya03SAmzRVcvE1MxqyUotj
cZIHjYFwlQQZt8GTT6C9syDuIs94KUZi+6DjGkXZvA8vYkyHdBdkoOlTAqdkPNX2
zqYIDTCUiFPwEABD9ESeutaKuZfu+g==
=QU5w
-----END PGP SIGNATURE-----

--igiAHzyIZO5yORWy9CKMCgxcKmEUUm880--
