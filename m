Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D30C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6810720851
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6810720851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbeK1MSJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:18:09 -0500
Received: from mout.gmx.net ([212.227.15.18]:45617 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbeK1MSJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:18:09 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M1W5x-1fYKMD0333-00tV6Z; Wed, 28
 Nov 2018 02:18:16 +0100
Subject: Re: [PATCH 1/9] btrfs: switch BTRFS_FS_STATE_* to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>
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
Message-ID: <8e0eb21f-ed80-cafd-84d7-00fa87bcbd8e@gmx.com>
Date:   Wed, 28 Nov 2018 09:18:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VPLtHmHfFY49bfPSua1Xq90fqRC1ORDn5"
X-Provags-ID: V03:K1:NgOC8P8fzH2uBYeJk3YoehLe5JlXXAA+CQXywzdbPftVr1woU9c
 Fn7qEiUlg+afzJfnkRq7kgw3gvdfLajCGoY0qADmXoitwmxdlJk6fGQQu17YhRsS3wLI7Li
 qiNVXhOL9S0+lUDNTBr/sEmVYiodZt+9ub0Hfv3aLFt4GdhOBarWfpdH54mVZlXeVq+b5z8
 sixmuxnuycckOHqjjN0WQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:w07WNpOTuko=:zzDLojGrNmKXtOiHchu8oP
 qSxbVJKbVNEjV06qe1LFwZQqGd1BdJRUO9QyoHZKpHJaRNe+zaZ6hP91ppP00roVCH9kNoW6L
 cZFIQ0Fr/Zs8C2xF8LUSCjt4Yn0iNKBRzmDLLJGZEa4DG5wWPCHJekRCiZRs3i7VKaurKUGf4
 6Uj9UJO+ju22TrMcina9IU8XrPRKyrxe60kjUZ7fg2TO3SBSYxqDNFKECvbFZEk4vafbN6cIE
 ThYp2T4t2320MDYlhxevFWFiBdWl37pYCUAsB8CaKoUlzVQVLjtzVSkN2Dqu1j3Nt/nFI2vUH
 xCVCEyV0j2Au61fnCNzV8xDj+fqCE5Xr2jLlkyARFB4nHFYTGNWkBAKedfdDmz1RmStIcy2JD
 GOGecjyCBmjTEMMzT1MBlfDzkPEYQnyK4Vz9PIcCRM1LqmpTvgFprunBR/IswP3bwyg8Twgkh
 V5KS5k/bqr88xvIC/7eYRct7R7+TtvcgqCPhv8A6MCj7z2NqyfTQpsJ0GIYiy1eGwcdoyoUFX
 kyv6JhLvkYPHsZq+5hlDxqyyEjg1lcLuLXHhBM8WDX/og9X59BJfp8Iga0nm7GKbphS3ReLkW
 yDypbahQER0FSChGg3PUqhbc+WfKgOo/ypJ5bHNDJZufXy/6hNcXgFlI8pW+N06DUTwLUU44w
 cZ/xC3y9y6kTQziqbt2xgaj5cjcell8dzXfpmTzrEet+3iUeZavioT9nTBsEzajH2Wl6aqSns
 rx/RDm0AXmJAQNI+D/guf49dvyECIdQURJmUazepOGaR+Bh/znT7mDRcETxs492dO9yoz616G
 s+ob1P6xzSFySHZX9jYApptw685vZc0hT38gjyxlmtHHga4O8ygqaPNaFWHZcj3Vf8mT5TGAf
 02hJBYI90V08eEqjK030jDtcR8SUG1ojJT2/avu4sXCXE1L9XACqgaAGDOdGA+
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VPLtHmHfFY49bfPSua1Xq90fqRC1ORDn5
Content-Type: multipart/mixed; boundary="hs02iBqIk6VFDYVBCL07mCNpn6wOVTYAv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8e0eb21f-ed80-cafd-84d7-00fa87bcbd8e@gmx.com>
Subject: Re: [PATCH 1/9] btrfs: switch BTRFS_FS_STATE_* to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>
In-Reply-To: <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>

--hs02iBqIk6VFDYVBCL07mCNpn6wOVTYAv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> global filesystem states.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Good comment.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a98507fa9192..f82ec5e41b0c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -109,13 +109,26 @@ static inline unsigned long btrfs_chunk_item_size=
(int num_stripes)
>  }
> =20
>  /*
> - * File system states
> + * Runtime (in-memory) states of filesystem
>   */
> -#define BTRFS_FS_STATE_ERROR		0
> -#define BTRFS_FS_STATE_REMOUNTING	1
> -#define BTRFS_FS_STATE_TRANS_ABORTED	2
> -#define BTRFS_FS_STATE_DEV_REPLACING	3
> -#define BTRFS_FS_STATE_DUMMY_FS_INFO	4
> +enum {
> +	/* Global indicator of serious filesysystem errors */
> +	BTRFS_FS_STATE_ERROR,
> +	/*
> +	 * Filesystem is being remounted, allow to skip some operations, like=

> +	 * defrag
> +	 */
> +	BTRFS_FS_STATE_REMOUNTING,
> +	/* Track if the transaction abort has been reported */
> +	BTRFS_FS_STATE_TRANS_ABORTED,
> +	/*
> +	 * Indicate that replace source or target device state is changed and=

> +	 * allow to block bio operations
> +	 */
> +	BTRFS_FS_STATE_DEV_REPLACING,
> +	/* The btrfs_fs_info created for self-tests */
> +	BTRFS_FS_STATE_DUMMY_FS_INFO,
> +};
> =20
>  #define BTRFS_BACKREF_REV_MAX		256
>  #define BTRFS_BACKREF_REV_SHIFT		56
>=20


--hs02iBqIk6VFDYVBCL07mCNpn6wOVTYAv--

--VPLtHmHfFY49bfPSua1Xq90fqRC1ORDn5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv97NQACgkQwj2R86El
/qitEAf7B9lCIHk36Uk5PCxsqAth8ciY+VsiuVdWWHTNGrZatVnXro3eHd7Aoyp8
EsILlmE77yzn7xBqXpeyrWy8yd/7A+YPMIRZkHeeqBb/w+yx40H8e2/CVXs0MR8E
9XiS32WBERQtE3iol/bz6bW9PROJMIzjMnGDD3glOyket6/3V8vszboH2VY3fEv5
GE2VZJWMieSBK5fFyNmsrr0jX75Qrh/ReZ+RSR9MWTTA5MVAPqJygv67LJpYJ9nS
rx2m0PYFCj8fuSuWCn7do3dsLKe76Bbw784PFb7u6J0r0oA3pe/pta98Ztnytihu
OYRMSPwd3iyX2lzhCwKXxxGmR1MAcQ==
=Xj8Z
-----END PGP SIGNATURE-----

--VPLtHmHfFY49bfPSua1Xq90fqRC1ORDn5--
