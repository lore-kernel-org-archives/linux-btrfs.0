Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68229C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EF7F20851
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:23:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EF7F20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbeK1MWp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:22:45 -0500
Received: from mout.gmx.net ([212.227.15.19]:34529 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbeK1MWo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:22:44 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0ML7NR-1gRXRu2dtZ-000JOr; Wed, 28
 Nov 2018 02:22:56 +0100
Subject: Re: [PATCH 4/9] btrfs: switch BTRFS_ROOT_* to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <f78a535281ed0bd208db0c2f70aa0e43f18cb40c.1543348078.git.dsterba@suse.com>
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
Message-ID: <fb77a24d-5e5c-b7bb-a83a-e43eef90a0fb@gmx.com>
Date:   Wed, 28 Nov 2018 09:22:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <f78a535281ed0bd208db0c2f70aa0e43f18cb40c.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uBeJfrJV0czMoBF6u5HzALd5C3oWSKDZm"
X-Provags-ID: V03:K1:folYSviMBSxaCZA6iYKznGkDQA8a/S/BOxPx22bC/ghm4eoP8PC
 WOCFmapx4WvwQvHmUek0eYYcJNjQgPMN2BgwK9KvfTvvZIcXCJYX19Spvu4RdsN+Sfh9Ps7
 TbsNE+QH/Susg2Uz226mPb64n+GeKgBppeGcGctfW49VUqDtTPJ0cDDxNLCUWJLKGj48s3e
 9OR3kNmLyn9112T/nnruA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Run7Rgs0Zfw=:9HXi0JB5xdiv45E0E7v2lQ
 EdguSvqh31fkb16ss9Yfs/bDUhV9HY+A+E9HGAvL93J3zZYeUdA+zqZpy3KjZOtWtQ32UrNU6
 UOSWZiy/1hD2q5YhjyBq9wkf7OE4ggNljiYX69GAkWAH8kdseLCcoq4IXOMQg82pHsqp7CI1M
 Ptmzggd6K81e9Dx5eCmIc4LfD+nTxyrev9JogonFgmtJGfm50JU/L3mKkJ5s/PbYtIqdJdBub
 w5xmN+3K2yuwSx8AtKdNHadvhKDeserh1WCf4+83HVOR1gDryUr047XT058hJrduz2o4R1zTq
 3clS+kZjz9KkbUt3tDahatFsg/YI2nCS7LleH5r6ZvCItg0YZ9RwFbvuJCQqFgNJM10Tjba9y
 CZ/gw5MOkKTRxLEirK4323miDHdIuprvDMTaiPNiQjF8jublQiCB0LPSLbW3mJZG9MPbR1sSi
 R+4vQURckTqzsPdIrVSCeaJnrzg4FSrjDJ9gGOrDamdm0JRFR9KgmdPMsvdMgF/mHgSlo4y+j
 V3bEuK+4YT6EjhpdGG5g9mwm3andou91G2VX5pcFO1J9UVprkZNce1gRrWnlgPbOVXh6x4WbK
 7651TeYOTqnG32Y2193ilV1gpZCRExA0Shd5af/jNMI709ysk1LjZWuEV3AEbBzAYtc7YMj/L
 M7AxixjPzSOvIHcGoVi/zbAEOGNgmNhsqeR2Ujwc4DInrpLmiIDF4mQA02erARGLedJj5YGgF
 JkPnc1b+9cpIMfDB2NIKbCORYiIUvM2bWtoD9gHSKN+6JMHEz+wVCT7iyROHYhL/mimIyOUaU
 dfCFbjwj8fecnqwQ4rRpEa5m/c5UqK1LkDqkNtb0zpBeATuWI62ldY6kFMlTKYfKaMcaNhU3/
 B4qiPphq2cmvDlXjjMd/PL5lN/B4raEa/JnwEPfCQ=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uBeJfrJV0czMoBF6u5HzALd5C3oWSKDZm
Content-Type: multipart/mixed; boundary="9WEPuLbfZHLgb0ja2O32JzgS6CK9yDksF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fb77a24d-5e5c-b7bb-a83a-e43eef90a0fb@gmx.com>
Subject: Re: [PATCH 4/9] btrfs: switch BTRFS_ROOT_* to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <f78a535281ed0bd208db0c2f70aa0e43f18cb40c.1543348078.git.dsterba@suse.com>
In-Reply-To: <f78a535281ed0bd208db0c2f70aa0e43f18cb40c.1543348078.git.dsterba@suse.com>

--9WEPuLbfZHLgb0ja2O32JzgS6CK9yDksF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> root tree flags.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7176b95b40e7..4bb0ac3050ff 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1180,22 +1180,23 @@ struct btrfs_subvolume_writers {
>  /*
>   * The state of btrfs root
>   */
> -/*
> - * btrfs_record_root_in_trans is a multi-step process,
> - * and it can race with the balancing code.   But the
> - * race is very small, and only the first time the root
> - * is added to each transaction.  So IN_TRANS_SETUP
> - * is used to tell us when more checks are required
> - */
> -#define BTRFS_ROOT_IN_TRANS_SETUP	0
> -#define BTRFS_ROOT_REF_COWS		1
> -#define BTRFS_ROOT_TRACK_DIRTY		2
> -#define BTRFS_ROOT_IN_RADIX		3
> -#define BTRFS_ROOT_ORPHAN_ITEM_INSERTED	4
> -#define BTRFS_ROOT_DEFRAG_RUNNING	5
> -#define BTRFS_ROOT_FORCE_COW		6
> -#define BTRFS_ROOT_MULTI_LOG_TASKS	7
> -#define BTRFS_ROOT_DIRTY		8
> +enum {
> +	/*
> +	 * btrfs_record_root_in_trans is a multi-step process, and it can rac=
e
> +	 * with the balancing code.   But the race is very small, and only th=
e
> +	 * first time the root is added to each transaction.  So IN_TRANS_SET=
UP
> +	 * is used to tell us when more checks are required
> +	 */
> +	BTRFS_ROOT_IN_TRANS_SETUP,
> +	BTRFS_ROOT_REF_COWS,
> +	BTRFS_ROOT_TRACK_DIRTY,
> +	BTRFS_ROOT_IN_RADIX,
> +	BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
> +	BTRFS_ROOT_DEFRAG_RUNNING,
> +	BTRFS_ROOT_FORCE_COW,
> +	BTRFS_ROOT_MULTI_LOG_TASKS,
> +	BTRFS_ROOT_DIRTY,
> +};
> =20
>  /*
>   * in ram representation of the tree.  extent_root is used for all all=
ocations
>=20


--9WEPuLbfZHLgb0ja2O32JzgS6CK9yDksF--

--uBeJfrJV0czMoBF6u5HzALd5C3oWSKDZm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv97ewACgkQwj2R86El
/qgq9gf/Vyo4VeJ4d05yGlX6rtm/Rdj9MbHgB1RigykZO474HU+9WVrcgFq6G3B4
RzhMa7aCA6CHZcyhXr3uGPfOVC2djJ+O+7DZBtdpX91qym4JSGFftDKejBsIb/kg
rU8mHQEzLOjl5rkDXuF/6OI8ED9d+dN7cQOqV+Rjzywy9Hsd787+J4vxJ4ufyafz
E4F0bp6IeOBA7Yz8RxT99mmm/OKH3IfYtOO48IB0WcnD3xZs0mGu2PUNCzFvm7kT
jcKhUygdBOkwoH0ZnPqMVf4xfwMsxy6YHb8tm1nQQhZXjuqAQDBX0952Fj+EqOoq
cckltuHovCaM11wOCSqyNiSamoQx9Q==
=wzmW
-----END PGP SIGNATURE-----

--uBeJfrJV0czMoBF6u5HzALd5C3oWSKDZm--
