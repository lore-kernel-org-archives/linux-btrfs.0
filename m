Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E93C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA3B2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:24:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EA3B2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbeK1MYi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:24:38 -0500
Received: from mout.gmx.net ([212.227.15.18]:41719 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbeK1MYi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:24:38 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M6zkD-1fV3Gb3K6f-00wmKa; Wed, 28
 Nov 2018 02:24:46 +0100
Subject: Re: [PATCH 5/9] btrfs: swtich EXTENT_BUFFER_* to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <132de3b38834a3703cc9cebe56e7de8dcbcec1c9.1543348078.git.dsterba@suse.com>
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
Message-ID: <ff8334f4-6980-8013-3234-22ab1bf58c05@gmx.com>
Date:   Wed, 28 Nov 2018 09:24:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <132de3b38834a3703cc9cebe56e7de8dcbcec1c9.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SuDDCV7LjhsLoydnXVmv3El5I3SDw4rkO"
X-Provags-ID: V03:K1:gCuqtgXArN/kKYjPcaCrRCSK3JaEqTdEIBKGyIhewxbuJ/MXvrU
 c5O6bIZTk4JOiGLGdKo2uSOD/YW5kzg9Gu9ol0qY9cGAV8VR9itrnf4dV0MKhr1iv/R9/gK
 DacMN6sTjVZea/NI1ITj+wtrbM63NP+V1MrxpTLwsEg2nim/dIJaEwHNnkFmVLOBAdtCb6e
 4E7E7HDGxP8qPqnEZURkw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SeJiRssWPXU=:Vpjp0tYg1RKDUNacM2VEE/
 zs73vrgSDbrbIE5e5Are8H+nfMtpSmJLHFMZqTbUUOdWJEY8iV6bXfIxR4IfVNG0MpEbP/vit
 khcyUZzfBQ5Ftz+hFGwWLrL7Tztvhi/7jvES7YTvAOsUu8JWIaKPbrT4wB1azBEkYHGMrgDhf
 9EYMJobGmWLq3/Hi/fobeBNzPR8mkdP0LfFJjJDUUgk+9t9Kdef1pytcyiJquYPgR8A1enpPX
 zn1XIF+hNyKM0Jwp6+F97YIvfft1cxjKq3qCWHI1jR6cnIaKF7Gdm1ywdI3SdrLn6m8pmq4pN
 96ZrqEb26Xabfbnaow+YFncceNTcqB3JcYyFhDQXAsle90tNUwXpP5lWqe/gfiq99kZLtHHv5
 zD5eit1T6nmx0C9aNahqbaRPf445RDK0rO+U0gAYlLDYfivUFJkwo+4EbeBMgjaH2d4QUETMc
 soh/cJX4KpigzoyhCwZeJnS1KUYYiG3Yp61gFD+lbiUZ3LQfb2W1SsuII03HsceMtWTnuiDje
 D4HA0H0trYtTLS/Hgk3kvP9rLCOgLyWQK84yZclh6ddNZ5OfzJwLvorJOdgkx+iUsceEpr2yT
 EyA8Tr7MNQA2iXjnuBP9pGrTp2ci6HpM8keq4g8KZBCsv0HNc4QGCWX/PJggSTqWssQa235uN
 WQey0kYxUaiHs7Uu/SeGZYDEFMGS9IhoPD4bguW69n9SJxA7HqasPX56BNRv0GG8gTjNyNHu5
 SfbI6gQwci1WnCyBS6G/1VvxC9OdkOTJ6MP4v6IsGHZr6AhdwYh7sXNDISxS/cgFfhqeRPvd9
 MpjU/iQBoVG1zM542KNQwoW5gk89lj11Uc1xGHa7qHqZOjqFSMLRU7Ufj/0LGrKkPqNEC2kDc
 XLRqcb9p9gVsJ54on1kgG28l6/V3YwrIpGNCOr+nleJ758SVxEPqG3wB0j1kDK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SuDDCV7LjhsLoydnXVmv3El5I3SDw4rkO
Content-Type: multipart/mixed; boundary="hG5nNwEZ1l6SWUtL8Xzr7jNVkb0hoRHiG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ff8334f4-6980-8013-3234-22ab1bf58c05@gmx.com>
Subject: Re: [PATCH 5/9] btrfs: swtich EXTENT_BUFFER_* to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <132de3b38834a3703cc9cebe56e7de8dcbcec1c9.1543348078.git.dsterba@suse.com>
In-Reply-To: <132de3b38834a3703cc9cebe56e7de8dcbcec1c9.1543348078.git.dsterba@suse.com>

--hG5nNwEZ1l6SWUtL8Xzr7jNVkb0hoRHiG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> extent buffer flags;
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/extent_io.h | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index a1d3ea5a0d32..fd42492e62e5 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -37,18 +37,22 @@
>  #define EXTENT_BIO_COMPRESSED 1
>  #define EXTENT_BIO_FLAG_SHIFT 16
> =20
> -/* these are bit numbers for test/set bit */
> -#define EXTENT_BUFFER_UPTODATE 0
> -#define EXTENT_BUFFER_DIRTY 2
> -#define EXTENT_BUFFER_CORRUPT 3
> -#define EXTENT_BUFFER_READAHEAD 4	/* this got triggered by readahead *=
/
> -#define EXTENT_BUFFER_TREE_REF 5
> -#define EXTENT_BUFFER_STALE 6
> -#define EXTENT_BUFFER_WRITEBACK 7
> -#define EXTENT_BUFFER_READ_ERR 8        /* read IO error */
> -#define EXTENT_BUFFER_UNMAPPED 9
> -#define EXTENT_BUFFER_IN_TREE 10
> -#define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
> +enum {
> +	EXTENT_BUFFER_UPTODATE,
> +	EXTENT_BUFFER_DIRTY,
> +	EXTENT_BUFFER_CORRUPT,
> +	/* this got triggered by readahead */
> +	EXTENT_BUFFER_READAHEAD,
> +	EXTENT_BUFFER_TREE_REF,
> +	EXTENT_BUFFER_STALE,
> +	EXTENT_BUFFER_WRITEBACK,
> +	/* read IO error */
> +	EXTENT_BUFFER_READ_ERR,
> +	EXTENT_BUFFER_UNMAPPED,
> +	EXTENT_BUFFER_IN_TREE,
> +	/* write IO error */
> +	EXTENT_BUFFER_WRITE_ERR,
> +};
> =20
>  /* these are flags for __process_pages_contig */
>  #define PAGE_UNLOCK		(1 << 0)
>=20


--hG5nNwEZ1l6SWUtL8Xzr7jNVkb0hoRHiG--

--SuDDCV7LjhsLoydnXVmv3El5I3SDw4rkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv97lMACgkQwj2R86El
/qi4RQf/bRsM/eXVzdPGFQZnGZGoG0p0oIFGuvpSeTO+gs0JhkOllzWDUAz/hnFM
F1xtR+keZ/s4WsjjRdqnxoUryAn6Nhcd3x4pPTs4Ms2H1hfs2dXSESxhTG709SmA
w4sf4FrXw8my/POF+Vzwaq2aeu0WnOiZwZXyGu/iWmB9+6bty3rMD/RbZqG74bhb
I37eZYF/jCfYT0/79ZMqflgxbZcOCnU7usbFrGMhg5EJNjH0TCofSBvALTWH6TOH
6WeSYKwE4oRTHVmKkmkvM1TFxZ5na+RxWZ+Rj2A9QFzcFc9kjhZMLRlK0iFdwdqy
UGFAjxRTgyJUHu0bywXpLXfL2xItkw==
=kv3j
-----END PGP SIGNATURE-----

--SuDDCV7LjhsLoydnXVmv3El5I3SDw4rkO--
