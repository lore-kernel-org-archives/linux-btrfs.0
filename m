Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9856BC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B2932145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:24:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B2932145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbeKPRfn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 12:35:43 -0500
Received: from mout.gmx.net ([212.227.15.15]:56139 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbeKPRfm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 12:35:42 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lzc5y-1fRpOa0qjy-014lDG; Fri, 16
 Nov 2018 08:24:27 +0100
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
Message-ID: <063537b3-66c6-b42e-d866-51b66212c746@gmx.com>
Date:   Fri, 16 Nov 2018 15:24:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XvR5uZ2hd7JnBN6Nh7ETOdvNoXtF7cT3l"
X-Provags-ID: V03:K1:ZVrgH/045mxA2IPBWl/2+fH2Zx4ZjWRSpYXi9G7hK6hdQFlGvQY
 nv9rNxx2sprsJWh/+KnDWnG9sY6dgl1hDo45AKtGwr3LU1oOQI79MGk7laZD75c67TgWeu3
 /niUvyMG2vdMDtJiO0su7xt+jKUHSe1MTtkMB0VLewfkdEC5SkH/07D/wL9OyKtKOf/D+00
 T+D2bHjf6U1qHLeSWLQDw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:sJ/EwJQJiSM=:NtYuXVL1Ro2vp5l6OQxNPe
 CPkbmPyYObdBaLQ7+ELnaegnrRJtV2ovAMwqHqVIBRjDCcMKTT/RKO2O+2quOhQL6uEHfxSbE
 ojVlC0+VNZOc+5pq8gP0GJ2yF1Qb2ZjxwIkSg8Jm6as+NCxO0Lvx+oYDPG+sLEkJcHs6Euidd
 mSLPgJSR1pyctxepeZNz9Zh0qrFQCuBsPggwEtwd6x8mK9qr8UvH0Q8gYFqffTh/PVij0jwnQ
 sx0Jwf9lkJdKqoPLAswc1pW1eg+iAc2zCvEYJqRwsuAaLN0MRnTWMLBQLQH02v+tnHPG08nOX
 Yv0qCAdSl03kSwbqNlc6kh49CuQmaK32G7IVtOMTLhXzgCCTlCR+wYpidwMAkOlMEhJSDjFzn
 XZiqp427wrZoAoSt9OMG/dZkyYxzspO+cAGvdX35TmxI1w5wGYLJ6yQcW2eyFY5c1/Ppjkcd0
 3ZQmjGp+0LHU5zYkfsoCb1aE1igGIIWJ0xhp0hKqrLZnHx070qSNnX4BnxDcxB8xB68CrGX0z
 6DIxXC3t0HvqwkufH9JBGRlbgF7OU4LUiXIVnqtG87e62JqPHGTMF1AGhL9hSEQQMdJPuo8+0
 KJp1A0Z8O+z+kP8FQZpPLcCivqLncgDxVtX+/XHoXaBUgkfR73BcOYQC5pFdk2EYvyKS+ToAi
 rq8LNQCxoQ6tSZfC9mw1s4mD2r1HCnW3LBXxX2vlBkssRDVzxwsCu4unwUqwu452QqXcAPs0O
 ZkgWwOkawBGYhYV7RRHGYb7uHYryEQv3kGj5gdWR7d8o+0+xsIBtxbN9Fw0RSknwsD4oOoYAV
 bEqd/T9ciJMzdj/Yc7303dB5AOJWMuDPMVFD+79pUcmBc08ukhHEMSnDBD5ybqWoHo5jkAv9q
 LfvHuMOvMIU5I3/hS6fl114pNYuzkX9mNFAhbCHlEpWYqyR9y6qJliWf33NbIa
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XvR5uZ2hd7JnBN6Nh7ETOdvNoXtF7cT3l
Content-Type: multipart/mixed; boundary="D1AX56fqT85sTwINJ1e62xWcfwngU2v8h";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yanjun <suyj.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <063537b3-66c6-b42e-d866-51b66212c746@gmx.com>
Subject: Re: [PATCH] btrfs-progs: fix gcc8 default build warning caused by
 '-Wformat-truncation'
References: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>
In-Reply-To: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>

--D1AX56fqT85sTwINJ1e62xWcfwngU2v8h
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

Have you tried "make W=3D1"?

This won't work.
You should use cc-disable-warning, however we forgot to include that
function.

I'll fix it and put your patch into my pile of make W=3D1 cleanups.

Thanks,
Qu

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


--D1AX56fqT85sTwINJ1e62xWcfwngU2v8h--

--XvR5uZ2hd7JnBN6Nh7ETOdvNoXtF7cT3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvucKcACgkQwj2R86El
/qgwbggAhn0HW9MQezrKD7MA04uU6c65HCbGqoBRgPG0AYWS6Sq3mcPpuJa/qr1J
MtklCB8ryodC8AB8IV73KMw/oh2gBrvuvqV3GFO0GDiLVIvCnHit0XaEg4lrfmhL
zz1j2Wcg1SRLfM0ELjcZIO8J84wkXlgFobCkiot2mkppHNopACrt4ZCUgd2IXaFg
opJlr2KPQrIhUNlZh4t/duACppxbr1PvD3qWJ/FihYI2pGYhKCtn2siUIrKg4MUH
vZz8dE21cKp4DMq+Owd60IDMbeyg72bNvtRip5+USRt1G8BU+YLXjv+CpK8i0Pf8
MnEj4VrWJuFTYKbxnyPiwFpm5lpyLQ==
=jqVq
-----END PGP SIGNATURE-----

--XvR5uZ2hd7JnBN6Nh7ETOdvNoXtF7cT3l--
