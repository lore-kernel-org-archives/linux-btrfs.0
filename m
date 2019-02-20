Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E41BC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 03:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 078492146F
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 03:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfBTDjM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 22:39:12 -0500
Received: from mout.gmx.net ([212.227.17.20]:50941 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfBTDjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 22:39:11 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MYfJW-1gaphe3hr8-00VNP0; Wed, 20
 Feb 2019 04:38:54 +0100
Subject: Re: [PATCH -next] btrfs: Fix type conversion in btrfs_read_root_item
To:     YueHaibing <yuehaibing@huawei.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190220030840.188854-1-yuehaibing@huawei.com>
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
Message-ID: <0b9cbf46-950a-2135-8c71-be4c7dfd9420@gmx.com>
Date:   Wed, 20 Feb 2019 11:38:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190220030840.188854-1-yuehaibing@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SKuvs6x35yDlQdbgK1bVklwvtfwVjNsqE"
X-Provags-ID: V03:K1:NAQzKRpB+bHdEhMnvogSTvH7h22wytjT9XF39mwENkOIrZbk4r+
 H5aLrN/d2Rs29WLHjbIyZbaI2R+/G4/BLchyV1/Kgqicx0xN4eGqn6/0qZg65ehXBock0GG
 HoqeHxnRHhJn0C6WnxHNL3ifDFaCaq3VF2SNrF1PsjQwhySfGdmUAxr1nhwMJZiL7cs2J6q
 v3RDPJbit8zx++XGyOdcQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:e2qdV2f7ZJo=:Vdn59SdG2LBbI77rMI/10x
 X9nQFWcNcKW4FhaOxZ61Hlk/nrweq6BO+6BSxYJzWkane2qgsEQquyYSjhzGPvBNjh1NKGhSe
 cZ4PkGGm1D1FXnoszML5zgv/x5tmAUuTBe33JkqvVT8gHxK1BH6g/MInm08AC1BSrzg6oynoY
 tAnR+1wDSow0C0CxREmHVH7rVA3X8XhRZutgjH43TbpyF1gwdoDLVP3QS+MQ+Wd0lRYDk0I1B
 9JeuRuDRIbTe1Qc0mMyEAYvl/uFse1cXBkSOAq5gEjhqDdAjgGAjdUQsbtrw7nkuyuWZf6X4M
 YZqS1DDl3HmfGd/gV6ls548dOXQolUn8+wJqjztG/VLwn582oCr599YXh214Ajs+8RUYNcPoe
 ZmMmrEVFeP5F+g8kvWtG+x7PS568NoTqt6xhHesRvEGt0ZbwqrJUKpCNAskkoLq3F6b2w5KW5
 MRz7TG/AsKX4VxR18ZEj+VclU/3jyCVOC+xqkSeR0WaL6ajc1x4gfTiuKZxJVjGNwC+wsH1l5
 +kSveXXgfe6qCP5921tVAKtIjQa+Goe7uEJIFnD3D4cnT7bJygG5CiNky82j2i3jNux2HBRuS
 aQ23Z00yW7KhvSPeIR66MqJy7GetfH7j/Gc3qZJC57ngsnFJL0a1rsVScqd8dyphCgT+jNDw8
 IN+wJVQ5Oy6wcugp/dIJYOLNwOGQLVxtUNYpLe/x///wXdPRLVDqVUGqweFBImiqab5wAFUgT
 Ku87uRjnKuZk8D4709QVg0XI+ZW4ru6Kue9b1JKmDd4JUhQPkCb9gXT2NPvO/pF54sTXA37QU
 2ql5ApxPQtM0EQA10GTc1/S1eKN6IDXawkrfZ4qcT31GdfF6uhyvUgiHB2L7SAbQsF2VCyosw
 l6MXLvdbJi+XFyDHAikA8VQ3c6vx4i4LAM/t4StPokUVY3zYWx2dPgsduL4f2t
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SKuvs6x35yDlQdbgK1bVklwvtfwVjNsqE
Content-Type: multipart/mixed; boundary="jTaruMgeTddB66kxsFNmViwpZnNwMA5dl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: YueHaibing <yuehaibing@huawei.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <0b9cbf46-950a-2135-8c71-be4c7dfd9420@gmx.com>
Subject: Re: [PATCH -next] btrfs: Fix type conversion in btrfs_read_root_item
References: <20190220030840.188854-1-yuehaibing@huawei.com>
In-Reply-To: <20190220030840.188854-1-yuehaibing@huawei.com>

--jTaruMgeTddB66kxsFNmViwpZnNwMA5dl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/20 =E4=B8=8A=E5=8D=8811:08, YueHaibing wrote:
> btrfs_item_size_nr return value is u32, convert it to int may result
> in truncation.Also read_extent_buffer expect a unsigned param, so
> min_t should use type u32 to compare.

Btrfs has a up limit on item size, it will never exceed 64K - various
overhead.

Furthermore, btrfs has metadata read time check to exclude such
obviously corrupted tree blocks, thus corrupted tree block will never
reach here.

Thanks,
Qu

>=20
> Fixes: 8ea05e3a4262 ("Btrfs: introduce subvol uuids and times")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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


--jTaruMgeTddB66kxsFNmViwpZnNwMA5dl--

--SKuvs6x35yDlQdbgK1bVklwvtfwVjNsqE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxsy8QACgkQwj2R86El
/qhJaAf6AgR7NSKtc4KR67kkqWFzh37VXspXmAZ4+jAfpJXS7Y5wKDM+RCXrXYhr
FtworWumikyqilxSXWsvhd76+6zHgmEGowybTGSopy0LFl4y0PxsBFOby2PuPmsc
kYEXhPWieq16IY/oyj2NZrXb4sR4sdVEGGkAricUGP2j803tFAv9wwSgLm1XRug7
eklKDXwzmGw8/qn5WtCurL5++svaKhX+VOyfIVbr8E6SSCKnrJvdV9NGb67rIVJk
orKXZ5/I8kOlGr0M49GlnzuYC1eo3cEIdn1rGFSkVTKekdZGPTyGy8CeCXP+1VDO
YSXfbe69UTIH7+r9mHdqJe7LOJtsTA==
=e6mE
-----END PGP SIGNATURE-----

--SKuvs6x35yDlQdbgK1bVklwvtfwVjNsqE--
