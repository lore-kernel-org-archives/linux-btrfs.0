Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2A1C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D8D20843
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:51:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13D8D20843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbeIZODf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 10:03:35 -0400
Received: from mout.gmx.net ([212.227.15.18]:49707 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbeIZODf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 10:03:35 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M5tof-1fpa3g2ZI1-00xtdx; Wed, 26
 Sep 2018 09:51:50 +0200
Subject: Re: [PATCH v2] btrfs-progs: delete unused is_vol_small() and
 BTRFS_MKFS_SMALL_VOLUME_SIZE
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>
 <1537947877-11663-1-git-send-email-anand.jain@oracle.com>
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
Message-ID: <c798601f-26d5-e381-089c-c3382bfb2c87@gmx.com>
Date:   Wed, 26 Sep 2018 15:51:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1537947877-11663-1-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FlFVvqrZB8SZB5CvnRG24oXq4xHlreXF4"
X-Provags-ID: V03:K1:DeIw23L9kVNHy7TzMjVgppwT7fAhAYI4C9umAS5bpM5ZsjGsqn8
 KWAEgozCbcrR6XLXGXWpnJmJd7czJwgFQQb0Kfrf7Qx9mC3Ro/M+PMKs2E0Ke6cy62ttgqZ
 ++r7ZaOJ2heszshlMeyxchY/ioKp61UBt4Z6yEmC1c8hpdQ2Ogzno+91Etc+/VxvgscrxY5
 /wPETynv4L42HwwWIKyIA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:+E0iQfL0uMs=:fHoBwAUNV0RipGhRGxYYxI
 5DEIEAN5skXLVIatlYJ+lju/SwPpRW+1Y+t9QMwXbQGqg7f9ACVzJKawxpIzT71B3SNBa5a6Z
 pr43RmFThviD3jOM1FfU4ee/nvRdtMTfynsbMf3rurqUMi3yJ8HokwwjcQvoHR9hcx5mNjTf6
 krQTnzD1ZbKAXt6xYMBrsj1wcboldpR/VfTJixfwAdZMLsrabhwRp6cyf+xHFLLxyBQyD/ZT3
 b7s39RjoLh/+rhJRLEDppPyzT+KpGcFmT4mvWvVDNKvJVBZcy2JSIMfd/e2q/SZpLIAj9SwXG
 shLVE/hoPIRsdUcm5slIcE9aYbx61HpbbAlFz51stshetebkwypiIU0lAqaVpt1quCVbha/vg
 UdcWk7Me/izdLSbLRVUb/7QdaA12Xh5tJvFvKz4FaOrun4ZNa9wateOxjEndGprQ6m2Se2gsL
 KfcOPRHwiEcbynIT8XeNTh/K6EvqwZ9co8GNb9HypfzSynIR24lz4XZkWfqrnvsNI+6XQU4Gs
 lZ3R89MLaCISu7UVjdzhYARo/r090/Z+oo1Vdw0fggBWsfTrgkmNBXLFEXnej4aewuHjrtvbz
 h1vNg4C2Ei37rj8R5LWrdLoOMbLOgTYf+ApMfME5auqMusepedNTC6RdK8Kve1ZuxUNdF3WPZ
 vu1VY0E0eJ52GgAT7GtPD1KbVsNKDqrAPcXdfFiW4Uq3TFJRqrFBY6do9DBTl20zdPMLfC2ey
 lfSfkDSA55xC/VIieNo27aArma5SKMT10AB/YCYb8L2oI9nmnT2WIzUqccZubJEAxQpN4mbWx
 Y1J1V63wGX22K6RdWZ26JShQrhjLg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FlFVvqrZB8SZB5CvnRG24oXq4xHlreXF4
Content-Type: multipart/mixed; boundary="i0YXFWcz4pStlMkwsYrhNKy0h8nS6Iznx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <c798601f-26d5-e381-089c-c3382bfb2c87@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: delete unused is_vol_small() and
 BTRFS_MKFS_SMALL_VOLUME_SIZE
References: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>
 <1537947877-11663-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537947877-11663-1-git-send-email-anand.jain@oracle.com>

--i0YXFWcz4pStlMkwsYrhNKy0h8nS6Iznx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/26 =E4=B8=8B=E5=8D=883:44, Anand Jain wrote:
> Since commit c11e36a29e84 (Btrfs-progs: Do not force mixed block group
> creation unless '-M' option is specified) we don't have automatic
> mixed mode, and the function is_vol_small() and
> the define BTRFS_MKFS_SMALL_VOLUME_SIZE become obsolete, so clean it up=
=2E
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> v1->v2: drop is_vol_small() in mkfs/common.h
>  mkfs/common.c | 29 -----------------------------
>  mkfs/common.h |  2 --
>  2 files changed, 31 deletions(-)
>=20
> diff --git a/mkfs/common.c b/mkfs/common.c
> index 0ace262b0e5f..c59e1d8eda4a 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -772,35 +772,6 @@ int test_status_for_mkfs(const char *file, bool fo=
rce_overwrite)
>  	return 0;
>  }
> =20
> -int is_vol_small(const char *file)
> -{
> -	int fd =3D -1;
> -	int e;
> -	struct stat st;
> -	u64 size;
> -
> -	fd =3D open(file, O_RDONLY);
> -	if (fd < 0)
> -		return -errno;
> -	if (fstat(fd, &st) < 0) {
> -		e =3D -errno;
> -		close(fd);
> -		return e;
> -	}
> -	size =3D btrfs_device_size(fd, &st);
> -	if (size =3D=3D 0) {
> -		close(fd);
> -		return -1;
> -	}
> -	if (size < BTRFS_MKFS_SMALL_VOLUME_SIZE) {
> -		close(fd);
> -		return 1;
> -	} else {
> -		close(fd);
> -		return 0;
> -	}
> -}
> -
>  int test_minimum_size(const char *file, u64 min_dev_size)
>  {
>  	int fd;
> diff --git a/mkfs/common.h b/mkfs/common.h
> index 28912906d0a9..b0ac3e35c6e9 100644
> --- a/mkfs/common.h
> +++ b/mkfs/common.h
> @@ -26,7 +26,6 @@
>  #include "common-defs.h"
> =20
>  #define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
> -#define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G
> =20
>  /*
>   * Tree root blocks created during mkfs
> @@ -69,7 +68,6 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)=
;
>  u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
>  		       u64 data_profile);
>  int test_minimum_size(const char *file, u64 min_dev_size);
> -int is_vol_small(const char *file);
>  int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
>  	u64 dev_cnt, int mixed, int ssd);
>  int test_status_for_mkfs(const char *file, bool force_overwrite);
>=20


--i0YXFWcz4pStlMkwsYrhNKy0h8nS6Iznx--

--FlFVvqrZB8SZB5CvnRG24oXq4xHlreXF4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlurOpEACgkQwj2R86El
/qjp2Qf/V3s08f9FRJAay1IvEBQJoAK/HXOapk/YS2xHAQ/1Dy9vUZlZhY/FrwgS
3Q8XL7j6rOWfi5MCXpDNYXqssoSZAu2pernAXj7nQd+pmr7Jkc1wliVcY5xqQGtX
8nBYOzD7bYI9xv6xyHq9/Y5kGtowmX8quFwhUiM7NCk0IaPMw5IWVGCMhVRBts/6
f/xplryebwyExA4I4DhvSr2VJs9nhEB74+DU3IZlz8rjoQCFGe7PZssNtuaKGNaV
uJfL131zaFGvlLT2xds5rqrm9upCZUDnCZG7/Snn61RZ2aiEcwni8bsyMLshwu5a
RxeXjqwVxOmvwyVUAdeFYIXpCCEneA==
=67Ik
-----END PGP SIGNATURE-----

--FlFVvqrZB8SZB5CvnRG24oXq4xHlreXF4--
