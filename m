Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CDBECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94D8120825
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94D8120825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbeKIAJj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:09:39 -0500
Received: from mout.gmx.net ([212.227.15.19]:58839 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbeKIAJj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 19:09:39 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LtIZH-1fOHuS3mLj-012qrp; Thu, 08
 Nov 2018 15:33:48 +0100
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181108131750.27833-1-fdmanana@kernel.org>
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
Message-ID: <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
Date:   Thu, 8 Nov 2018 22:33:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181108131750.27833-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xHFZDseU714N4UGoeHx3xAkrqnhWAXij9"
X-Provags-ID: V03:K1:jK8XoMHwWi7ieLzgHsqThE9tbzfk8q4X6xZr1l/kmkasA5ggzQf
 TAKeBrV7eNH3qbbGGKMTg75ETGBMkUItg/SXpk7nw7oCFNOiiek2HHGd0wluFqCpmIJAW2G
 JA0SpDflSdGO2Np0uX0mBlC44bQDZD7i6rmQbeVaHAv4THwZJryaLtYxJe6h4cvMLsZqmES
 pfX0LVh3PdANnFU2t3hmg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:YKyDyIQLblw=:EXRHh6PAKX95NDYrwqTtTu
 YPB/z4xvVkESxL5r2MuRWp+qwsQqNFaLlIlt1Fac53axfo/Qr3tMM3TdpPuLHLUz3bKEbG7Xb
 tencLpzp+zHVo6mXPCs+XqjfU7GP635UcsZLTuXAsHKiRZqVLl+pvNutfUdq6mdrLmxtCFtdV
 oThD3DLw02fiYH6F3e52bPB4suDnDn7+MyMSL1iPV+faK3pnpyPevCirwB5TUP75OBR0+LiVc
 0tCqC2t+BN5/F3VpAQKuXo7WqFvwyvNtcMfUfLBz42Un3/v0ncK7uHGc2g4iGKYGh3qFbLP7p
 Aytigaq75REART3Lyneor5lKBDWsxTP3Ij3hP+22Ysx9TUA0Na1pMEBFNUWgdVuS7V0KkefLO
 PF3bfZIcP9f9qu0PamynxPc9cpk6qCfmuZ3rRr/lXiqvX4VLnbaw3zfXbBOLkUj8xZApOFEJY
 RJDc4zupXt8QEEuKJjlJZSpAWLfC9bM7JjzyJtypn1XXpxxF1sR7DiqM00Fyaf13b/hKNQGBg
 UHGvFa+m6Rc+t/M3ExhKqQwgwfBn7YSv++fXWtHEJd693IG7tqkAlkjnOHbj91yeiMprTdHer
 Hm8KBW8lVyhiXAEHDZ+PKGKeXl8Drg5EduefvinsquS436oLD/tYuskcZkRmXFT058iXwLaJh
 uS4p6dXGro6FI+C2zi97B/+EePpXEh2AugMGuag/Bn8ix8IAfgClbccit2Q8otfEXP3TispRl
 +C5XFHzKarBNBPitm7F+/duzausyjwYMYudzuayIcAWpSbnXPSYRjVqiIeQjojbGmZ4asmS0O
 Qa5eus5U34bJXGg4CzuUHnMzygyhJ17Bd8jeZEAfORE4x82iJ3t7LhmE+0CNWjj+cGpcfXdTZ
 pWcDwc2ESl4I/+bp/R/x7ttJYzfSbs4j+cV68BJXMAT3pfF3yuD6M+5dHikkh4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xHFZDseU714N4UGoeHx3xAkrqnhWAXij9
Content-Type: multipart/mixed; boundary="tbBpPkyH5OjsP4D5NvyO8kvEW33bFr0B0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
References: <20181108131750.27833-1-fdmanana@kernel.org>
In-Reply-To: <20181108131750.27833-1-fdmanana@kernel.org>

--tbBpPkyH5OjsP4D5NvyO8kvEW33bFr0B0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/8 =E4=B8=8B=E5=8D=889:17, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> When creating a block group we don't need to set the log for full commi=
t
> if the new block group is not used for data. Logged items can only poin=
t
> to logical addresses of data block groups (through file extent items) s=
o
> there is no need to for the next fsync to fallback to a transaction com=
mit
> if the new block group is for metadata.

Is it possible for the log tree blocks to be allocated in that new block
group?

Thanks,
Qu

>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 577878324799..588fbd1606fb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10112,7 +10112,8 @@ int btrfs_make_block_group(struct btrfs_trans_h=
andle *trans, u64 bytes_used,
>  	struct btrfs_block_group_cache *cache;
>  	int ret;
> =20
> -	btrfs_set_log_full_commit(fs_info, trans);
> +	if (type & BTRFS_BLOCK_GROUP_DATA)
> +		btrfs_set_log_full_commit(fs_info, trans);
> =20
>  	cache =3D btrfs_create_block_group_cache(fs_info, chunk_offset, size)=
;
>  	if (!cache)
>=20


--tbBpPkyH5OjsP4D5NvyO8kvEW33bFr0B0--

--xHFZDseU714N4UGoeHx3xAkrqnhWAXij9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvkSUgACgkQwj2R86El
/qitsQgAsKS71fTwOHuQdor3iVdUG1unCVgs19klJ0byDHLuOSf71W1v9Q/FxHYJ
SZnjXlhOUlDkvwhjy7icgK60pZEbzDudvynervdpoyVKQ5n3/QfiCHEyf86TBv4D
j3g0SkEgtnUG9t6nSOrGd4CKafqAXyjnAng7MBnt/Jlk4tMLr1j7B7SCFJz+vn0x
xzinaVMs+BR35LyLCu2DaZtQrRbh1KVSoK7R0DAFPOYcU2YKFcPAykp81eZLSvv8
CudTM7TLmjHt9gI0lYDjgwPc4oL3BXHR4i87te0e7E04EJc1z+7P1n2xkAnYjBzK
8N/R7tIMhwqMddseNjza5l1yG7Gn+Q==
=WigC
-----END PGP SIGNATURE-----

--xHFZDseU714N4UGoeHx3xAkrqnhWAXij9--
