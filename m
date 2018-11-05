Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF06C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7237820825
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:03:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7237820825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbeKEUWi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:22:38 -0500
Received: from mout.gmx.net ([212.227.17.21]:58583 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbeKEUWi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 15:22:38 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LrNoG-1fNVkg31vo-0138Gj; Mon, 05
 Nov 2018 12:03:11 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LrNoG-1fNVkg31vo-0138Gj; Mon, 05
 Nov 2018 12:03:11 +0100
Subject: Re: [PATCH] btrfs: tree-checker: Fix misleading group system
 information
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <425b8a43-ec24-82f7-0627-82edc81e329d@gmx.com>
Date:   Mon, 5 Nov 2018 19:03:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="K8qmIWbMujQQBjS9cWCBZ6696M31s4w1U"
X-Provags-ID: V03:K1:9eahrhMnlywjp/3Gv3E+vEFzzqZp4z92T+auR5Jggu3cHVQqxFU
 /f3wxL3LfnSep9018zqXaQ+kbSPZd2f4fFwRn54LYLRPgQd5PZhKy1ekKDlSNL31I4C65Zn
 MxoxCcanPGLl3J3IRTglULWq8IK4rZzmBuhVJTmiVfEqCYWO71FWQTJiAZUp8+83I+6cw7Q
 OE847/ypGyxVRDhVBw1oQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:oyB3qrLxHzE=:VwJtWkkDV1BETKyNG+xTOq
 vKJlKUadAr7h/BvLZ+DuLXxXw9UU+Pm/L44WntVN6wz6qfH22XuaSfjqUOgRjmakdpy4sYVO3
 vqNKexvE4WnjN7GCLljSObTgwbwHdbg/OaKpWLsxjxp9WnMLcMQYUvZ+nWWzjHbOFco4cSd17
 tr8HU6b9azkau61PIiu3rpT9lWGlnjdlAolBC5PMLawvZbHGAgJdMftrELFo98GJV9qJ84Her
 K8CUfa3dcTnbHo9jLMKaAJraQM/lozOGTyIZHpxjYZh7u72R4ofYsT50ehnqN2c3SS0u+cRAA
 1tBRpgFt9qvIM3DNGouBLXMxnxb+ho0TK3K0mgWwzgS5TAuYHbbfmaDE4rGlRxWSDjrwHy9Kx
 7IJgFeB5uSuI1cgBqKR0+sYX1mJiOnZyUbXFZ5/X635YD0j4Sum5/TNiKTkHz68NFQ7p/+365
 8V9nLl1WFWHGP53B3/nqxeeCl06NqqfhJyAHt1PI3sPatQLTXtIArc+RgvlAtjIhYM9Xgcl7b
 HpindOL/mAKtveEQ+qk6nr/Uo9NBpHvcg+a9CGDb4xT0TNogZDVH26o4X7SEaU3uYlYZJzaZf
 K8hMW5VlaIEepgTAM9E35BDDg661zDqLN116LhVi5PmjC0DjkNuYffx0uivbX65fn7j9yMjy4
 54yZr6yWfKojbjVpNmlrA4yuy0ClVhMSzPjvHpDWl/ngFqvXevlRNtTBgqu1jkRoQlJcvVR66
 FXuvytnbP0e08EKjaK5QBF0v3E8Mv/prmZnf85e2pmBWPbNuLZtHb10eOka5eo02s/c89acea
 9fiekI1PsD9c1fV4uLBMePI0iz7fg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K8qmIWbMujQQBjS9cWCBZ6696M31s4w1U
Content-Type: multipart/mixed; boundary="vTy3TN7zbyPHZcXMAvJQJADZAEzwnKYCO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Shaokun Zhang <zhangshaokun@hisilicon.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>
Message-ID: <425b8a43-ec24-82f7-0627-82edc81e329d@gmx.com>
Subject: Re: [PATCH] btrfs: tree-checker: Fix misleading group system
 information
References: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>

--vTy3TN7zbyPHZcXMAvJQJADZAEzwnKYCO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/5 =E4=B8=8B=E5=8D=886:49, Shaokun Zhang wrote:
> block_group_err shows the group system as a decimal value with a '0x'
> prefix, which is somewhat misleading.
>=20
> Fix it to print hexadecimal, as was intended.
>=20
> Cc: David Sterba <dsterba@suse.com>=20
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>=20
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

BTW, did you catch it with some real world case or just by looking into
the code?

Thanks,
Qu

> ---
>  fs/btrfs/tree-checker.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index cab0b1f..efcf89a 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -440,7 +440,7 @@ static int check_block_group_item(struct btrfs_fs_i=
nfo *fs_info,
>  	    type !=3D (BTRFS_BLOCK_GROUP_METADATA |
>  			   BTRFS_BLOCK_GROUP_DATA)) {
>  		block_group_err(fs_info, leaf, slot,
> -"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx=
, 0x%llu or 0x%llx",
> +"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx=
, 0x%llx or 0x%llx",
>  			type, hweight64(type),
>  			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
>  			BTRFS_BLOCK_GROUP_SYSTEM,
>=20


--vTy3TN7zbyPHZcXMAvJQJADZAEzwnKYCO--

--K8qmIWbMujQQBjS9cWCBZ6696M31s4w1U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvgI2gACgkQwj2R86El
/qjf6gf/ScWkL10kdvipBBZyOkLmEMWXCO+LJMLTq6vuASb2Ljr8jamQN7W0KV2g
ZrRgS55Oa9kTw5EUTrDPk91wtV9NzPSJU2e+O1c4ctWYfYZ+/uSO+fcXWCnczN4/
BXx2UhfWGWuo77sfKGhqy64X2sawL4li62qaWrv7XUeVru8ATABZPUJmz7IHbTAt
vFIRF3TUFubJ3c2FJtnds1lKVrRBSI7fpgXCH2fZbx4XhiDFlSdzN6rZ/Zdva3q8
dsEv78Q5wZi2y2PahitIjnN+CXvk0ZzHzkVn3OLWq7aCarRtvhZlU2d/kSW+qZE5
30tdikq3Ws9zS6/1N8MmW99Ku/sTdA==
=0aBc
-----END PGP SIGNATURE-----

--K8qmIWbMujQQBjS9cWCBZ6696M31s4w1U--
