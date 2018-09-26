Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FD4C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A8FE2089D
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A8FE2089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbeIZNvf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 09:51:35 -0400
Received: from mout.gmx.net ([212.227.15.19]:55355 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbeIZNvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 09:51:35 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MQRWm-1gCoBJ49gy-00TifT; Wed, 26
 Sep 2018 09:39:55 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MQRWm-1gCoBJ49gy-00TifT; Wed, 26
 Sep 2018 09:39:55 +0200
Subject: Re: [PATCH] btrfs-progs: delete unused is_vol_small() and
 BTRFS_MKFS_SMALL_VOLUME_SIZE
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>
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
Message-ID: <205f0847-7fd4-c716-80ad-2553a8dae4e8@gmx.com>
Date:   Wed, 26 Sep 2018 15:39:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AIQH0ztlzascUF5R6oz0htKYN0zzAOvMR"
X-Provags-ID: V03:K1:duGuOCHEYSyLKBdLDgNJa194q3Sg64BY+lV7+LHxTUc1ZoTh5TL
 yMj1bsZtbuiy8eo+xH0Yu/lnPNSZF//A5Mf2/r+Do0P4+s6j3OJ4+eBUOQc1LTkxRa2pkGR
 3gB8zPRIa2G7Qi0NxxcyJrU6ihXGrNAu12qmEfv7oW1WZ1dtQ6WYOGwPB+Qx3d7wYCLBQiF
 DOjru7AeDsJraRLF969NQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Wg+a58zjXTU=:gL+SJyf8ivSgX0BH80ZnpA
 8Vtnoe0QlwaL2SHPr1OIXR1z+hdIUbG555+SNdQtDWzEeylEsEx9Fc5lt7y9relre316e3Flf
 vbcpA6wCwwakUD9192TVLcHch9zp0h8SgtVdQrshHeE3/emfM97xPlvVx0XbADMHS4EoqyADA
 z03Phslfua20rYUIQ+OTuoWfZlL6oEcLnxs5h8HafW++XH3WurTYXQZl5GORJT6qZ+C/vL1fo
 ztzQHzqZ5FCzNUe13J5nki4+7Ziq+GLK9CA1AwHSsiGsHzeK/7yi/teXDR8of0CmbEXXH6as+
 j8lI7yGUjUD7NZQhSk35F5CJMZnGzpOAAXMxR154zd2FfSTXYLs8jg894Uy6AXaiIRSyqhdQB
 PMIkpaFh+OgIyPQCAdZCfh0ZpwueNh0f4C7X2jxYYBceIJifn/KiewWcHMLh8upToSoLt9wqz
 ijCks/37hmNyW1LJJrgCUk1lbyJtn89hshrw4LKtsvvxk2NXP3aYJUFC5jxhlRQ1A5FuSKdP8
 Rfo5OLSR0NhtKJfdfR9vc5Fp1iReiCy3nOBBLSP7WMjKVLCUL4UJ009o+NQduNxBC+a6PiaO7
 uAC5m/I+gIYHQ3k3xR6WtTVl4liE66VtvbYZXwX9rGbJhyc2x63iZrSLzzcv9je5xT5Yzgkd5
 3c3Th2CF+HLvIMZIAg9qO3JULkrpijTqDeWlvyGaSMmVeSv+2ZjOKJV5tKJsGlQmLBQbpRc4I
 PPOfVffKyd3LNH4SiMHjX+y8rL8i4YD4z3LeIdjBVpR1hVXT68AnUZ1obuNHBoAca3kOUn/3p
 iCBtO4huWSpmtTzYzkKSbPSLxGfWw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AIQH0ztlzascUF5R6oz0htKYN0zzAOvMR
Content-Type: multipart/mixed; boundary="3rK5pQNnyjeXZhRaSZDw6AbLM1WpdeRXO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <205f0847-7fd4-c716-80ad-2553a8dae4e8@gmx.com>
Subject: Re: [PATCH] btrfs-progs: delete unused is_vol_small() and
 BTRFS_MKFS_SMALL_VOLUME_SIZE
References: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>

--3rK5pQNnyjeXZhRaSZDw6AbLM1WpdeRXO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/26 =E4=B8=8B=E5=8D=883:36, Anand Jain wrote:
> Since commit c11e36a29e84 (Btrfs-progs: Do not force mixed block group
> creation unless '-M' option is specified) we don't have automatic
> mixed mode, and the function is_vol_small() and the define
> BTRFS_MKFS_SMALL_VOLUME_SIZE was obsolete since then so clean it up.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  mkfs/common.c | 29 -----------------------------
>  mkfs/common.h |  1 -
>  2 files changed, 30 deletions(-)
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
> index 28912906d0a9..18f5c3b66270 100644
> --- a/mkfs/common.h
> +++ b/mkfs/common.h
> @@ -26,7 +26,6 @@
>  #include "common-defs.h"
> =20
>  #define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
> -#define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G

Wait for a minute, is_vol_small()'s declaration is not removed.

Did I miss something? Or it's already removed by some newer commit?

Thanks,
Qu

> =20
>  /*
>   * Tree root blocks created during mkfs
>=20


--3rK5pQNnyjeXZhRaSZDw6AbLM1WpdeRXO--

--AIQH0ztlzascUF5R6oz0htKYN0zzAOvMR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlurN8YACgkQwj2R86El
/qhUiwgAlqqTH2pFOCGXNDbWQaw8hTqShOLw+Pc+mzvqiyWoWnQsIYDGaD6Zaqd2
9LIccF678E8S1FzFS3vzSWlOuslJJivsmiD8XNfpUCqM4EwipGCnAnYG1xSL6al+
oH0mhkl5D3ElZoP7bZFAKLUn/8TJyP3JTpWxK1ib+6eMgBEJkUK2jc8PE2doUxCF
qtngg4T6FulMFaKnXvlnN8z0tbtjfmLAJYzbZHOmH/XVvP4FQNnWvmQXPWQut39O
ydCIo3FYeS51FtDdOtOIvRrORPnZEYBwwzN8gN7/9uwN463uCKF2dyqmyOBzta2O
wY4vThs3rl29TfpWqi9Aa/gEr+ATSw==
=c9kv
-----END PGP SIGNATURE-----

--AIQH0ztlzascUF5R6oz0htKYN0zzAOvMR--
