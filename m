Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFED2C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 05:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FB87207DD
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 05:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FB87207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbeJZNqq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 09:46:46 -0400
Received: from mout.gmx.net ([212.227.17.21]:45621 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbeJZNqp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 09:46:45 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M81vR-1fKvy20Rcn-00vekl; Fri, 26
 Oct 2018 07:11:12 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M81vR-1fKvy20Rcn-00vekl; Fri, 26
 Oct 2018 07:11:12 +0200
Subject: Re: [PATCH] btrfs-progs: fix gcc8 default build warning caused by
 '-Wformat-truncation'
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>
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
Message-ID: <fc70a989-34aa-d764-55d3-2d86c5aedcd2@gmx.com>
Date:   Fri, 26 Oct 2018 13:11:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PiwAvJ9GmsrPEI1LLFJeboD0FkQ0EaLai"
X-Provags-ID: V03:K1:kHb0PX+vMQGiNzI1k/L9JQ+mJ+i0ZJFU1no4zIxD2EZwhtpYbo6
 M8VR0GEk2bQn/JvH/l/OJkySGYNknF4htC1cyoy3sACPDG7k9cWQqVNpj3W1uuomdKh8l95
 9+zujhJeBnbJLB+np7SMyzgAKU7UBr2yTV/FD7glXNQrXUxW7qiwdsNBSZw5RJ+v86KNL6e
 E0+cPY3U48pMTiXRtAk4A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:JBFav3OVSjY=:nUMsz9bTA73ki2dOUU6Zm7
 qRxjP9Vz0SC65yhz08UotwPhyp6MHhtXjluteEZdUg60BQktHjD9huxKFI5iThuUztyJJygVy
 gKA5g3pi8aPIJxCZz6ZeLJwZcvRlGJdftK6HOLL9hPb7JUoaHO5wizio4MOvlkVXRtGjcb6KE
 ibkrTiXZYYAm8vFs5qbz1OuVDwx1BrHajF4M8QCdoiFZCz/xMjanX9J8VIelln7A2wldO94A8
 hh0ziKqttI2z3ECs2tNSgAbHSFdDRUWcWqAWcZRsZDZt8mothh12cby1gxPJUU+UF4NY2r0So
 LfyW9jmDtuG/z1DHqXkCcj8Q6LGyIDNa20qm4JmTOfHe67lJ97Was9VDLmbECioZ5xQ3sFryV
 luYCbtyobCjIYgzSCIMLkenCx8hdQ+gu1xUsMc7uEltcgaf8nQMCotsR5oC+cJHSxgDQJQCi+
 y/s15IAXQdiUTjOVfS2sSbc2fjG6lg4m93YLr8yN2nTiQ40RHjuX1oaMxLHVb2+FeeSjFGgSu
 uH4fq9ZVX0ZUb7qpJZwdNrZ+I8MAuYpycggnaiXP393sxw1jKEe9R8ZQWaj4JjfJDS1DgMQfv
 Vu8ImhsK1dJu7dJxjSdRArwMdxZSoMsB+kei6tWjfKZN0Gi4Mr6JUmx7Yi72bU13JfNjeojA3
 FGC5AzYsRHL7Fc9qptBxtR8i+7HRatpXyX4Nc/zTjJzEua+tBT8098FxeDhZHbXOqPuFHfZuO
 3+dB/onV8OOae9YCUoT+L5FBLx7pttPeW0wxg93uF8T0v9AEnW2lwpCBn8ndqUMi8XFD9FDLy
 dLV41p4Yxh2cO3nRECBa9xMgQmYDQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PiwAvJ9GmsrPEI1LLFJeboD0FkQ0EaLai
Content-Type: multipart/mixed; boundary="a1WYJNtkfLX03M9upv8OeYbUkHe724JNV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yanjun <suyj.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <fc70a989-34aa-d764-55d3-2d86c5aedcd2@gmx.com>
Subject: Re: [PATCH] btrfs-progs: fix gcc8 default build warning caused by
 '-Wformat-truncation'
References: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>
In-Reply-To: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>

--a1WYJNtkfLX03M9upv8OeYbUkHe724JNV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/26 =E4=B8=8A=E5=8D=889:58, Su Yanjun wrote:
> When using gcc8 compiles utils.c, it complains as below:
>=20
> utils.c:852:45: warning: '%s' directive output may be truncated writing=

> up to 4095 bytes into a region of size 4084 [-Wformat-truncation=3D]
>    snprintf(path, sizeof(path), "/dev/mapper/%s", name);
>                                              ^~   ~~~~

As long as we're using snprintf(), we expect some string to be
truncated, so it's not a problem at all.

> In file included from /usr/include/stdio.h:873,
>                  from utils.c:20:
> /usr/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk'
> output between 13 and 4108 bytes into a destination of size 4096
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> This isn't a type of warning we care about, particularly when PATH_MAX
> is much less than either.
>=20
> Using the GCC option -Wno-format-truncation to disable this for default=

> build.
>=20
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  Makefile.extrawarn | 1 +
>  configure.ac       | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/Makefile.extrawarn b/Makefile.extrawarn
> index 1f4bda94a167..ed76fb5b5554 100644
> --- a/Makefile.extrawarn
> +++ b/Makefile.extrawarn
> @@ -47,6 +47,7 @@ warning-1 +=3D -Wold-style-definition
>  warning-1 +=3D $(call cc-option, -Wmissing-include-dirs)
>  warning-1 +=3D $(call cc-option, -Wunused-but-set-variable)
>  warning-1 +=3D $(call cc-disable-warning, missing-field-initializers)
> +warning-1 +=3D $(call cc-option, -Wformat-truncation)
> =20
>  warning-2 :=3D -Waggregate-return
>  warning-2 +=3D -Wcast-align
> diff --git a/configure.ac b/configure.ac
> index df02f20655d9..c626beca8b77 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -12,7 +12,7 @@ LIBBTRFS_MAJOR=3D0
>  LIBBTRFS_MINOR=3D1
>  LIBBTRFS_PATCHLEVEL=3D2
> =20
> -CFLAGS=3D${CFLAGS:-"-g -O1 -Wall -D_FORTIFY_SOURCE=3D2"}
> +CFLAGS=3D${CFLAGS:-"-g -O1 -Wall -D_FORTIFY_SOURCE=3D2 -Wno-format-tru=
ncation"}
>  AC_SUBST([CFLAGS])
> =20
>  AC_PREREQ([2.60])
>=20


--a1WYJNtkfLX03M9upv8OeYbUkHe724JNV--

--PiwAvJ9GmsrPEI1LLFJeboD0FkQ0EaLai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvSoesACgkQwj2R86El
/qgeWQf/drfLJuJ3L/b0vsQTN7i6Sk3B25a13KR6HruPsY9yq7jdssM9+E2i4Q5r
ldttNISXz5UP6wIK5YwiLP4J+vR+dnL19O8u0z1MuM7BsZCA3JC+iQMQB1sCIeFr
/4PXkW4kYO5T9JKRnlgwdF846XB9eVxhi/O25icjMg4EYIezKHrP3VaDcmZ4GpCR
OoAs3+ct1nGJ1yytf589QxtJCjGlgT2L9dY8GkdHea0huGsK6l1dxK0R2KSVyIWU
59nq3LGIXJc8JtVtrorhvmofFK7CU0sBnP1H/Gn3YmBIeAHDtqMkbeOschYcdlcz
fr7/JxlzQGEZt720BoMqq8sMUvDNNQ==
=B4pE
-----END PGP SIGNATURE-----

--PiwAvJ9GmsrPEI1LLFJeboD0FkQ0EaLai--
