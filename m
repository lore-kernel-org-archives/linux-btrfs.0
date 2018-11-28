Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B8EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3170820851
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:22:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3170820851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbeK1MVr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:21:47 -0500
Received: from mout.gmx.net ([212.227.15.18]:41543 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbeK1MVr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:21:47 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MU1MP-1g12Lz2ObR-00QoDi; Wed, 28
 Nov 2018 02:21:55 +0100
Subject: Re: [PATCH 3/9] btrfs: switch BTRFS_FS_* to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <9ff441008db0d0bb2780cb94830c66fa65c78f60.1543348078.git.dsterba@suse.com>
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
Message-ID: <11534862-4765-b0c8-9e84-84c1c70a5697@gmx.com>
Date:   Wed, 28 Nov 2018 09:21:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <9ff441008db0d0bb2780cb94830c66fa65c78f60.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o1dRhXEmTdLIxRJwdmayqYLnlAcXyPppj"
X-Provags-ID: V03:K1:SfqUb6cnSTRvfawo26xeXM4slkWpXDIU8DqjEh7fWM+jpc1Y4ir
 mYGYH+6+lJvHB+smQOdkHQBTXaLyC2Xnk6KT7gFSwJpph7O0luLUtbVOU3uLboxOc5lltip
 gpiYIHoz4blZhROMiIK/3GCMdyAJg6sPSjEmB9T6CyEDKx2MaGC3//aYYJkhlYUyH3Q5S03
 uTFbXKm8XfX5XgSLEhzPA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nCri014pIko=:DYiUtYzjT2AsqzHV4czfF+
 KK+ryeXm93JZVd4vABvcfnmPIoiWoRqt4tuqUoEawGMUajQ3udiwjF5+MOdOXzxL9aKPv/tHl
 NetKMyhZT/1fHfLsJ4EfMMnYmBFI1/tB81Le2r3WPCwA95n9qPbXECr1mWSgssY+odnjSAWLX
 oSJL0vA8FcDLiyscXm8YYA9LZQ5AJczs1Ypu7EZy5m+pl6gG8jE78DTP6p5KHFQ6Stch2XNpc
 htBdovxYvfOZHjO8SCqO8DWBK2fPX+KBggOoUu5IvSOOX9x+eZCnjejk4ealeA7EsgXKCbhLs
 0OjSDpp8MGRNWtltL7A28jdXCueNqnEpRn5iCSuT3L98xIwMH/YpnpSQ7Pvo/1qmfepCoT0x7
 62H+IwOLHO8GU4szUP12p2K44pfWlZECbLV34lQZNyi13+NxmNPp7H+aaVEtBZGXkoIuFm3/X
 YlEGlnqRR1NivVeRE4W7XN9NqK52BPkBuBuKHiyyvVoerZEBbot95gbOT7lm1zIBe87LG+xtb
 nh/inxOFZO0hRWRlHEgoh+Z6q3Tk+kxCoJbH/WVnutvs315RmF4JpSAwmasKiTY3dO2J6VVYA
 SvdgRKqhL9pYXpjSdjQxWaqtrjqmUoNVoAZ08rMTgbQPT3JjUivsrdh1bADIZl6a6W2YSQ+N1
 RfZy4zMheVM0AETgie3h2Wn2pUhsMBkPCxGHY7ileC8wIRllAh1tj8GR8c5uJIMCPguh8SU7P
 KO9wGeAl3h4FI1EvmFkn+ERKLeG7b2yLHL1vtckah7Cvd74GkPnSTmDoSFTw5ruZAi1IhPZLk
 msXKLG6I8xI3VcSVhbx7wmyrQ8ckCxoAPGj2JCLP669v8/hDVYsmNugsqInLAuP1ygvdS1rkx
 yLRCUfA9fMITg+OYs46ppQQQaqo2KTsHp//gzcfGp1LeoRhhdE+uzL9PipNGj3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o1dRhXEmTdLIxRJwdmayqYLnlAcXyPppj
Content-Type: multipart/mixed; boundary="B6i51HXDdpfDnXS7odQXTGMC0nLCcb8eM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <11534862-4765-b0c8-9e84-84c1c70a5697@gmx.com>
Subject: Re: [PATCH 3/9] btrfs: switch BTRFS_FS_* to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <9ff441008db0d0bb2780cb94830c66fa65c78f60.1543348078.git.dsterba@suse.com>
In-Reply-To: <9ff441008db0d0bb2780cb94830c66fa65c78f60.1543348078.git.dsterba@suse.com>

--B6i51HXDdpfDnXS7odQXTGMC0nLCcb8eM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> internal filesystem states.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h | 63 ++++++++++++++++++++++++------------------------=

>  1 file changed, 31 insertions(+), 32 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 40c405d74a01..7176b95b40e7 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -757,38 +757,37 @@ struct btrfs_swapfile_pin {
> =20
>  bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr=
);
> =20
> -#define BTRFS_FS_BARRIER			1
> -#define BTRFS_FS_CLOSING_START			2
> -#define BTRFS_FS_CLOSING_DONE			3
> -#define BTRFS_FS_LOG_RECOVERING			4
> -#define BTRFS_FS_OPEN				5
> -#define BTRFS_FS_QUOTA_ENABLED			6
> -#define BTRFS_FS_UPDATE_UUID_TREE_GEN		9
> -#define BTRFS_FS_CREATING_FREE_SPACE_TREE	10
> -#define BTRFS_FS_BTREE_ERR			11
> -#define BTRFS_FS_LOG1_ERR			12
> -#define BTRFS_FS_LOG2_ERR			13
> -#define BTRFS_FS_QUOTA_OVERRIDE			14
> -/* Used to record internally whether fs has been frozen */
> -#define BTRFS_FS_FROZEN				15
> -
> -/*
> - * Indicate that a whole-filesystem exclusive operation is running
> - * (device replace, resize, device add/delete, balance)
> - */
> -#define BTRFS_FS_EXCL_OP			16
> -
> -/*
> - * To info transaction_kthread we need an immediate commit so it doesn=
't
> - * need to wait for commit_interval
> - */
> -#define BTRFS_FS_NEED_ASYNC_COMMIT		17
> -
> -/*
> - * Indicate that balance has been set up from the ioctl and is in the =
main
> - * phase. The fs_info::balance_ctl is initialized.
> - */
> -#define BTRFS_FS_BALANCE_RUNNING		18
> +enum {
> +	BTRFS_FS_BARRIER,
> +	BTRFS_FS_CLOSING_START,
> +	BTRFS_FS_CLOSING_DONE,
> +	BTRFS_FS_LOG_RECOVERING,
> +	BTRFS_FS_OPEN,
> +	BTRFS_FS_QUOTA_ENABLED,
> +	BTRFS_FS_UPDATE_UUID_TREE_GEN,
> +	BTRFS_FS_CREATING_FREE_SPACE_TREE,
> +	BTRFS_FS_BTREE_ERR,
> +	BTRFS_FS_LOG1_ERR,
> +	BTRFS_FS_LOG2_ERR,
> +	BTRFS_FS_QUOTA_OVERRIDE,
> +	/* Used to record internally whether fs has been frozen */
> +	BTRFS_FS_FROZEN,
> +	/*
> +	 * Indicate that a whole-filesystem exclusive operation is running
> +	 * (device replace, resize, device add/delete, balance)
> +	 */
> +	BTRFS_FS_EXCL_OP,
> +	/*
> +	 * To info transaction_kthread we need an immediate commit so it
> +	 * doesn't need to wait for commit_interval
> +	 */
> +	BTRFS_FS_NEED_ASYNC_COMMIT,
> +	/*
> +	 * Indicate that balance has been set up from the ioctl and is in the=

> +	 * main phase. The fs_info::balance_ctl is initialized.
> +	 */
> +	BTRFS_FS_BALANCE_RUNNING,
> +};
> =20
>  struct btrfs_fs_info {
>  	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
>=20


--B6i51HXDdpfDnXS7odQXTGMC0nLCcb8eM--

--o1dRhXEmTdLIxRJwdmayqYLnlAcXyPppj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv97a8ACgkQwj2R86El
/qgopQf+J7YvgcwRtpMuJVgZjgJ2L4xE/dMBpnFZgdYPojHbM/V1yC5YiTrn4tjG
fULtBD5sYcjYiP/DHyYJvKmpC9d1Zu2EbAi9hYKloONugqWbBlvXvPdMTdUfaPp9
RETeuEoQ3vbBENzs+rXpGn6d1GUrqY7BETEXyafr2jrmcsh01pfBOfqESnpyF/Ga
jsC1lfUAp/5zOx4u6Wx32BuLqx9ETKjuivuOM026UZDL7+LAB4E/Fmj6kTvDxynx
YnIj9K9GD3iTcFATUZoE7VuYOtu4m9NYFc2vFlIZ7c93mUTt2Ri1/O6Zk0DtfG5L
JeqeU/q2eHsF1wDyC973Uevd8HVB0w==
=PHd5
-----END PGP SIGNATURE-----

--o1dRhXEmTdLIxRJwdmayqYLnlAcXyPppj--
