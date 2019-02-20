Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFECC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 12:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAE3A2086C
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 12:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfBTMgz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:36:55 -0500
Received: from mout.gmx.net ([212.227.15.18]:53061 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfBTMgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 07:36:55 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MNZ9u-1gzCGY0eUs-0079ye; Wed, 20
 Feb 2019 13:36:33 +0100
Subject: Re: [PATCH v2 -next] btrfs: Remove unnecessary casts in
 btrfs_read_root_item
To:     YueHaibing <yuehaibing@huawei.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190220030840.188854-1-yuehaibing@huawei.com>
 <20190220123202.43256-1-yuehaibing@huawei.com>
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
Message-ID: <a141e8c2-ec40-3a41-3d4a-fa2a8a978b61@gmx.com>
Date:   Wed, 20 Feb 2019 20:36:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190220123202.43256-1-yuehaibing@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VQAk2EcGfbtQYq2ZG4Nplb3a1xKgKxeFb"
X-Provags-ID: V03:K1:reF3fUZUV7wwrrdARKnASNl35BcFfdtvb7R1cEv6vrVvAKKv0bG
 PCPrNGBzR/liGRcatuWpcXFTPEUfW7bqs0TZKDyBhF4HahLmL26BJhkkO4JFO15wRKYKJYq
 2WRDIZ1j/I1P/zjbFrpxEZjyofjCrVOko+9mnVG0C/TtY7HMmrMno8z2hbgZqr0yV+0ZsWp
 FSelrA9zoIYyvwhnPsDjA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WoyLNsIArs4=:WCv2vpaaIyZ5+38ZSzuNwp
 Fl0L6RAn+OylYlVzC1rShBM9abaRpFFb5LT5knpvfh7/JFEJPWkYTGW+Nz2Q4beAk35G3dIn5
 YCbx1UBtqXQzS84X1Mom5hkRL96H2YA1dc/SeH/WorS6kUYhP5A1Kn4kefzoDh6Qsva9bJpPU
 ya2JbyNnFf9lu0qVmK3nzzt5XEjLoq8euou25kW8Yi3MBEcqUJJV/OkqdNVCN0yyCZ4fygaNV
 LEG3Jq0ykkitXM5JKGNMhlZ/1sBbDqBkkSnS0IEZp+79+bGQTQ/2WWBW0wOIAZJh5bp4ucrm3
 SXTGotP1S/eX89vLh85spZU9mSJu0I3ryEx5vL6t2maOLznnc/WFaM0PfcQL4UjhmBMgqCe+t
 1i+h8Rhlsiokb07V6Nm3/GLbMAdMK1qGhMKkhSqqTmDKL5dq4xlA2X0aytQ3kZFRV23bzNmuA
 RuMkd3Zvlagt5KfaEmZlX+4nybpDTRSgBjm6MV8RguuS1dSMuEJcnbiJoqa1qHsMs3R3P+KoX
 i+YiwlLOs8CoThM2YKwS8TyzfZo8zxa4rDyaGc3Kc7NZgkfl9A02H7vbCSl8hVxGuij9YJ6b/
 V4vKCSWOdiYpbVbZp6EkNoP3LkQL1dZUYOAUM4xEaHRhap29Kso6fLpoQ3hR+wnbwSQ/9hQR7
 XZdz5dzb0REoF5JDcGq9ASQXyypsGK4VdPo0CRUrCjX7aZz85H9hsyiyqY22l8sOLtMVjMRe4
 RhPRh2EGY88IJnP/6hZpAsDl2IPHumc+eGogkj6ZwvpqiOCNnx5YymNNj4TEySOe+FKwpu+X/
 rkpCvXnwrUyuQl5aTlYaeupZsaBMbueB+9GFkRuatB6k6hI+Ez6lw5Q6fALlGyQH3gmSVu9bE
 OIFRm3Qg9G7IlC2sy4X897ahRsnyA7FCx9A0MSlicJI0GFjI+OE5pVeRmThYDCBvj8FL0jW14
 BV+SrQ2RsXpQ7SE5MM2+iieopElxXIFfIyPkPBhEMC3KO93Uhh5tFwefP1ZD4pXxMNLp8i17S
 YHSBtOtmtMP2Z4oAB4ifjeAx9d9TDZNmDEHkrSV4H/kDHz7Y3Tp0w+dFY46gmJr0vY9MYv+WH
 lcv+w3YlR7MbWc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VQAk2EcGfbtQYq2ZG4Nplb3a1xKgKxeFb
Content-Type: multipart/mixed; boundary="EKwfjgP3xMdvfGuJ97upe0lFn9qkFvCVQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: YueHaibing <yuehaibing@huawei.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <a141e8c2-ec40-3a41-3d4a-fa2a8a978b61@gmx.com>
Subject: Re: [PATCH v2 -next] btrfs: Remove unnecessary casts in
 btrfs_read_root_item
References: <20190220030840.188854-1-yuehaibing@huawei.com>
 <20190220123202.43256-1-yuehaibing@huawei.com>
In-Reply-To: <20190220123202.43256-1-yuehaibing@huawei.com>

--EKwfjgP3xMdvfGuJ97upe0lFn9qkFvCVQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/20 =E4=B8=8B=E5=8D=888:32, YueHaibing wrote:
> There is a messy cast here:
> 	min_t(int, len, (int)sizeof(*item)));
>=20
> min_t() should normally cast to unsigned.  It's not possible for
> "len" to be negative, but if it were then we definitely
> wouldn't want to pass negatives to read_extent_buffer().  Also there
> is an extra cast.
>=20
> This patch shouldn't affect runtime, it's just a clean up.
>=20
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

The commit message is much better.

Thanks,
Qu

> ---
> v2: modify commit message as Dan suggested=20
> ---
>  fs/btrfs/root-tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 02d1a57af78b..893d12fbfda0 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -21,12 +21,12 @@ static void btrfs_read_root_item(struct extent_buff=
er *eb, int slot,
>  				struct btrfs_root_item *item)
>  {
>  	uuid_le uuid;
> -	int len;
> +	u32 len;
>  	int need_reset =3D 0;
> =20
>  	len =3D btrfs_item_size_nr(eb, slot);
>  	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
> -			min_t(int, len, (int)sizeof(*item)));
> +			   min_t(u32, len, sizeof(*item)));
>  	if (len < sizeof(*item))
>  		need_reset =3D 1;
>  	if (!need_reset && btrfs_root_generation(item)
>=20
>=20
>=20


--EKwfjgP3xMdvfGuJ97upe0lFn9qkFvCVQ--

--VQAk2EcGfbtQYq2ZG4Nplb3a1xKgKxeFb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxtScIACgkQwj2R86El
/qgv9wgAkCODEPZ6E8+ECLbmeSimSxlkehYyYdrPx91jRrIjoNhfDnedWnKGqlKE
nMkeBkttD8URGblky+23lRl76XQl+nEBuz3IOlAPwOhLKjCkZaMe+nVaCcBr9wwP
KxH9vA7/O0hVvu9PTnauapDqwUPFTnqDEpT6rMPnG0lYJcaxBjkl0NBobQfeggGu
cLFovH/C5PN5901mrBwu6Mhm4IyshwG4HLSCyAU8WpwQiSe6qe+dvZ/86l2dCLLs
dSJG6WyQ6ElguO+T+08Jps1TVHWnghjFMRdyapLU+68DMizlwaMlrR8741S+3LMq
LN+ut/TyqWOzA9Dcv/YK4FbvR/bblg==
=g1QZ
-----END PGP SIGNATURE-----

--VQAk2EcGfbtQYq2ZG4Nplb3a1xKgKxeFb--
