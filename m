Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0633CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5A9221780
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5A9221780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbeKMQzp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 11:55:45 -0500
Received: from mout.gmx.net ([212.227.15.18]:53627 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbeKMQzo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 11:55:44 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MWTfu-1fxbQR0fec-00XbQ0; Tue, 13
 Nov 2018 07:57:45 +0100
Subject: Re: [PATCH 2/2] btrfs-progs: gitignore: Ignore compressed man pages
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181113060914.27663-1-wqu@suse.com>
 <20181113060914.27663-2-wqu@suse.com>
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
Message-ID: <347a4931-d2e7-4e81-0d59-615e42bf67bf@gmx.com>
Date:   Tue, 13 Nov 2018 14:57:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181113060914.27663-2-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HF5P4E6tMTkHdeHXrNNC4KwANr1DhHv0S"
X-Provags-ID: V03:K1:3+wzZ8G5K9CHYGyvMA2qZrE2TiSNvaYHnac0RIX2cp98h1hgr/Z
 dT6dNKQLnRSGav8+Z3pnSTGzq+JYk6EWT8ShpLspMMxS1bWzzRJICWGR5EacSQy9DMjNXyj
 UHwQAL3+F9eqlVp1SWoCCvJ6cmEKk9KYnYRHcNWh/4SU3IqiwAjoP+JypOiKsInyxVdP00r
 /hELqQ7+z/pG+JOJaog1w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:0hwcGb+sJAU=:xJBW8IKj79XKnaf5k5fTKF
 w4+E+UomKqk1CF3fhKLAJyf0q8lwzfEMdaKw4QhwRAbRaggqKAHoQ0oaiOXtpKaW8nBojtGB4
 sK8pQU80z7ARNx7kDzZ5cmMIoVCHEb1ONkgRGk7ROPxKqmBwyyVMHQoMyRAnNOlaBFAE91bjX
 geOKojJSm6nfhCoqDHqB3UOrl/MtVcs5T0cs/iv/NksqMmFrTwQq9NbAg4HYMKHetCWTlm2QK
 CM9S+1D9907v9Uop5mbL7ZYwtuA3Dko/bG0yO5Y/n9Sf1eVDlE9ENxipp4IhQrDugzlrF+sbI
 fisuELqIY2ULbmTBaWALfHO3escTpVULA53gRYFnHpIlfrTFvPfc7zZD+oxctDrpiAKZNq0K2
 PXoOI4+clXtSb/2s7wcwiO+Zmt0t74Yj4dJrUiWfd64QqJCOewge5Y16BoVlxT40zXAn0Hg7X
 ZS/ftS/6HXLf6ppgBJjAIQgsgwej74jTOQYntn+7jFnqAqM6fIKFIzdTjsG7xtq8quxMtW/6c
 aUIWcNzo1Tb/+GeyEy/1t0uBhRFvN6Pys52VQD2arynLXqYqj7hmtZmKgVPUCG3aJK+TqTO+m
 Iq3LPJSKEfirDZbThX8noHh5i7b1ByqQMOw/IsnzUjv4Z3xZ1fiIoVsTzRmuPZqeUmLaIhGm6
 pRMfJg7TsWuY52dD1PKSz/Q/ML8BkTrW0zOdOWUyKyjtLx6I29PUSru0iwBq/ek5AFo86QWiJ
 xxR4T8kBwrbX/etv8g8mrccAlTsUiSPo+7Ye7qVwSBRcyKCV1wwQ02ryRqiJUC7gsEhDIx/Wr
 TkJHQ/mnA/RvAYLkDV7GyXRBu3y5Tj6wublF+6VHLMPsuytPb4w3AVE0pVElRowgezgo394fG
 ko29bKL0k+KPBwR8anugU/B+5ubH1W3xGymDtfnpLmP93F8MO0VRHFUKRp5S9k
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HF5P4E6tMTkHdeHXrNNC4KwANr1DhHv0S
Content-Type: multipart/mixed; boundary="MMivp0EIf9XY4mcgjuovYdOTBrSc46T3d";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <347a4931-d2e7-4e81-0d59-615e42bf67bf@gmx.com>
Subject: Re: [PATCH 2/2] btrfs-progs: gitignore: Ignore compressed man pages
References: <20181113060914.27663-1-wqu@suse.com>
 <20181113060914.27663-2-wqu@suse.com>
In-Reply-To: <20181113060914.27663-2-wqu@suse.com>

--MMivp0EIf9XY4mcgjuovYdOTBrSc46T3d
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/13 =E4=B8=8B=E5=8D=882:09, Qu Wenruo wrote:
> Just to Make "git status" more clean.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Please discard this one patch, as now we don't build .gz man pages anymor=
e.

> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/.gitignore b/.gitignore
> index 82620f3cf603..ae4dce545a7b 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -67,6 +67,7 @@
> =20
>  /Documentation/Makefile
>  /Documentation/*.html
> +/Documentation/*.gz
>  /Documentation/btrfs-balance.8
>  /Documentation/btrfs-check.8
>  /Documentation/btrfs-convert.8
>=20


--MMivp0EIf9XY4mcgjuovYdOTBrSc46T3d--

--HF5P4E6tMTkHdeHXrNNC4KwANr1DhHv0S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvqdeUACgkQwj2R86El
/qhfHQgAhqt3XKhiKKQ3xUnjsJHl8/DMayp3vcBeXlnJs/7vK0o8HiPFEjDuewkr
Xoor192Uw9u0eMFJs6fK6QQSNcrvL8ck6bYki1pUZiaHFNjKREf0laB3NrJOUEk9
eoyKqPhkNHtfcU9QXVxXDDAA+6jFT6qkanMZvagt0kj7F39TGiYNtRBwxyldWmux
ii3hWXnPPG5F0Rto8NuRe08/I2yLCIzZrOtolgPxf5b1TXWcYpaOqISSp56IulDI
KxM03GY8gjIyxdRunQ712v8Bp77MUAepIcsOiwZjeXJz+Dj1iNuYksGtgFZmGEny
feO63p9RCsb9s5nHklvFAsVCcka7jg==
=tR8T
-----END PGP SIGNATURE-----

--HF5P4E6tMTkHdeHXrNNC4KwANr1DhHv0S--
