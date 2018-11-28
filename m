Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9FAC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22E3520851
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22E3520851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbeK1MTe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:19:34 -0500
Received: from mout.gmx.net ([212.227.15.19]:38503 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbeK1MTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:19:34 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Mg4FJ-1g4Nqb2y1t-00NRsd; Wed, 28
 Nov 2018 02:19:41 +0100
Subject: Re: [PATCH 2/9] btrfs: switch BTRFS_BLOCK_RSV_* to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <cc7de532fc2398392c2735c085f09d5ee07c3b9b.1543348078.git.dsterba@suse.com>
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
Message-ID: <03fabd1f-bbfb-7a18-d0a3-2e454d5a3bef@gmx.com>
Date:   Wed, 28 Nov 2018 09:19:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <cc7de532fc2398392c2735c085f09d5ee07c3b9b.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZMb4UhdxtixX0vIt4umgmD3ck24JnCOue"
X-Provags-ID: V03:K1:M6Cf/DGb1sE95tbfhkjidZIU/kVMgUGnZFYNRrBnLfQOjyWFejV
 IJ1j4sTogvYOiVp9yUKWpHGVpplhT/4XQ46x3yRSd2FdHD7JSTRxIM0g/cJfa+9DP3giOth
 yD7KSvPIh6fKqQWmqW3Cb2kFAc30ZMo7fk3xh1rqAqWM9CV0n0bEuLOpH+U7qjVaJjve7MY
 6age4H3dnzqNVpcCEIBnA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9cZdOMUhHD4=:hTTMabsYSamD47u4DoOx0B
 f/qZnl/WpKPUGikG2p0kLvMDmuGhDglAezQGS+VlmjLJDB1WUDTNfXzu9w47zlYKVgOzqe9go
 5btpBTfckz7gCofX3QqoyenCOmqjHImTskEAvzTE57k/wZjIeySjrRmzq5zdSIdLAuSijNyLG
 cDhwH5AlYWxEiexK0KMUFioDCuu5QDEf81BHdCpzgf5KAWXs2UK60Diu0V4AhXuHz6horIwq7
 jnyqrmhj0x6MmppZt6EvkTfukghGBEYABy/X8p5l6uz1dY1fdkYNwKACNqBn8Z8zMGOy1CGy2
 V//4ZlluL1oefQPjH3jmO4g8zLQ5SgzyWSl0Ia/CJHUwj+qCxwB94al9uqmqeWlPbYDi5+Ue+
 1KA/unXb3HB3u+4oim6jatQvXeP80+aNgflZY/scAA8AlcGtq8xVfn9aX/nctE9tZHe6JidW7
 T3EQyyZf7za6muGd5DON/PJCuvYU7+CZZKZWn45nT47x7ps16EjESmn7tugQF024Qztyf3JP+
 5eEXeZ/5c4EhHL3MDLv2P1L2jWJgfpT37fYqU5aF0bDUQDAQBR35psB5pvVjkFZh1OmbwhFT8
 AjTgl5Bsed372Tfe4+1tdqS+omc5NbY0r2q/uTlJyexCaqqkl9P3zt7BkK/FmBydXWPRFUITp
 cgD3kTSCyiMcQrjf90j8PVBN+AVW3lfYt3Eih1oHTTSGU4Bv7ZEIrmFfWuO6IvFjxrv+M/hJ/
 hHeXTkfuoU24DBsSdeNJKT8AhcikJ+bvMVCPZrjOHFXqoudMmb4ziDieQ5F2GO8gdW6lQxZQZ
 yVr4CwBY0FKYyRZyGHzpp7K60ZH3NAkCK8f3nUDWnqqJoTW+/03apcrk3M1LkUsbJsA3GwHrU
 uknmenkOQ0eHrr51Qg//IDIMJPsXulggCEUxCK45E=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZMb4UhdxtixX0vIt4umgmD3ck24JnCOue
Content-Type: multipart/mixed; boundary="wLMCAcXDQ2oC4Z8syNjJ2d5uhxTs4ynM9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <03fabd1f-bbfb-7a18-d0a3-2e454d5a3bef@gmx.com>
Subject: Re: [PATCH 2/9] btrfs: switch BTRFS_BLOCK_RSV_* to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <cc7de532fc2398392c2735c085f09d5ee07c3b9b.1543348078.git.dsterba@suse.com>
In-Reply-To: <cc7de532fc2398392c2735c085f09d5ee07c3b9b.1543348078.git.dsterba@suse.com>

--wLMCAcXDQ2oC4Z8syNjJ2d5uhxTs4ynM9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> block reserve types.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

However more comment will always be a good thing.

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index f82ec5e41b0c..40c405d74a01 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -461,13 +461,18 @@ struct btrfs_space_info {
>  	struct kobject *block_group_kobjs[BTRFS_NR_RAID_TYPES];
>  };
> =20
> -#define	BTRFS_BLOCK_RSV_GLOBAL		1
> -#define	BTRFS_BLOCK_RSV_DELALLOC	2
> -#define	BTRFS_BLOCK_RSV_TRANS		3
> -#define	BTRFS_BLOCK_RSV_CHUNK		4
> -#define	BTRFS_BLOCK_RSV_DELOPS		5
> -#define	BTRFS_BLOCK_RSV_EMPTY		6
> -#define	BTRFS_BLOCK_RSV_TEMP		7
> +/*
> + * Types of block reserves
> + */
> +enum {
> +	BTRFS_BLOCK_RSV_GLOBAL,
> +	BTRFS_BLOCK_RSV_DELALLOC,
> +	BTRFS_BLOCK_RSV_TRANS,
> +	BTRFS_BLOCK_RSV_CHUNK,
> +	BTRFS_BLOCK_RSV_DELOPS,
> +	BTRFS_BLOCK_RSV_EMPTY,
> +	BTRFS_BLOCK_RSV_TEMP,
> +};
> =20
>  struct btrfs_block_rsv {
>  	u64 size;
>=20


--wLMCAcXDQ2oC4Z8syNjJ2d5uhxTs4ynM9--

--ZMb4UhdxtixX0vIt4umgmD3ck24JnCOue
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv97SgACgkQwj2R86El
/qhdRwf/awNjXFyq1tymFVxlEECowm859kmv9uMcE6Y0AIhQM9hsKGxHSzE/l2Jm
r+ht6BI3zTL9X5PKDEU8TygsSFQzgtkDuW/2FTFGCnrl/Z4tQHTsLbNSaX4d4kld
Rnv3V/aqpr2kBAZpM52j7Q8Ltm3ysCMa5g+6qYLQIuanlizH8wESF5gJIg+CEKGJ
tHoLPHHWYU6FdXDVfAe1U3D3bZrBjmvi1xrm5LlTeQS9HHF9XT+rafZrdU3eqIV5
RcxsNZalYwTIzM2kyhI3ArdkTJTWvG6uYcalNZ31oxgwnEPJJKM/kKXwEVULcqLz
Vek/7ZnQEelrx4Rq58J5viAfL565Hg==
=0rUp
-----END PGP SIGNATURE-----

--ZMb4UhdxtixX0vIt4umgmD3ck24JnCOue--
