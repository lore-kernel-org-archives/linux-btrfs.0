Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EE4C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 12:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D69221871
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 12:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfCOMlE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 08:41:04 -0400
Received: from mout.gmx.net ([212.227.15.19]:42077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbfCOMlE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 08:41:04 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M86jp-1grDMg0oOv-00vi63; Fri, 15
 Mar 2019 13:41:00 +0100
Subject: Re: [RFC PATCH 1/2] btrfs-progs: add 'btrfs inspect-internal
 csum-dump' command
To:     Su Yue <Damenly_Su@gmx.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190228144432.17038-1-jthumshirn@suse.de>
 <20190228144432.17038-2-jthumshirn@suse.de>
 <81928a3c-e75b-7059-cd29-660a70fa7f1e@gmx.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <4b351082-d45e-07aa-e76d-c93f8344b858@gmx.com>
Date:   Fri, 15 Mar 2019 20:40:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <81928a3c-e75b-7059-cd29-660a70fa7f1e@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OmD9TblkcSTX0UYjp1MYtK991AS3xl4Hj"
X-Provags-ID: V03:K1:D4ThVcMD+3NQ6KiOTgiu1QZvYqga00gSekUz0w+2FyqeItK5WhC
 19XDuRBjt5sC9eCc9da3dpEtQe3Rl+tjJaEmDD0izn3EpKdBEVD6fjfi5cmzfruB8ykY2Vl
 gISuo8iw6pqL2V0R2ZQV3xwDclxeVdJC8ODsOL1oDmBtPjJt1ROJOteZizVLEqCn1/Des4J
 NcCDXvoTS9CnF/cSMw2UA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mmL4j5IlDAk=:vY+6FzOGxTI9pQTYa3g7iQ
 dlgV432BQMPG8dJnG9yjlrmIgMOOtFmX4368MK5VMDB55tfS9yhAF4FkbdljYclTBapCtbDhM
 6O7hG1tKdtEhybcCe7Wt6iNwoyWcw6CWc0FhwANgRBIJb3Y/WJSap2rzosQFkYd9bgYSOAKyK
 mk3RJc1LZwGYIzyvEeAWzRdNYtkrtnZ5cEewVLb04eVPTJWAeDZdCWY5rAVFSnC6zGBeEPPB0
 cMd2fPZZ2KyQ6Q026Avv6KLbn3bAbbhea/dt/9LlreedviUrXiYBRtXicb3zjSveSQ/FVDIW1
 qYQkRrRjf73aYxKj1lJnBPLlWdrAD1gJdqayx7clInIfBm3zmvdfl0rMjye3JJe1SHuCmfLmB
 i+PerVpS1s9t4sxW2P7ZfOE+slhXJR7yG4slHA+N5YSeVyAIUpwb58qILFB0DBLUUJg091Zz6
 VgmcvFzi6Hl3lx2zIi0dHig7i7UThEL2ePtARgtHf+aYuvHsc9nWDud2lmckJ3cqrLnecc/aJ
 tdJDYs5JxsHSv9W0hnLBGBYGV2/RbFcAPkmsvvy/ysMysHRVCwRjx7FowG2x2pGrbnVn3WOjD
 A7tR6QJpySelKn1Nw+0WwBI9bm+rcOmQAghYGxX4MwsCocm8uRhPyt8o60CNBugl+VOH92ba2
 fMaD/sLonHmd0b+5wZTdm3NSnWYeNTljH9HQ2wVrBbOZ2QGD/tYIN7wkibNCScBBnYH/820yg
 jNbx59caf3+ZJiTtkGbxXHIIubLABwPpLU8XkWBuEb2xUJN1289sZBYiD5vqgwbEjxv83OzHe
 m6ZG2ZRps2XpfIIuKYUsRldesrD2HX/otRk+KU0JAx7X09lCl1JiDrQG/sxhCIFOmc7InwtwQ
 Z84jOfxLSbQA4ITOEiUivWbH2Jcu8xXURN5r3NByQT0eDJtLG6vafHwHmQeYL+
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OmD9TblkcSTX0UYjp1MYtK991AS3xl4Hj
Content-Type: multipart/mixed; boundary="rv05LUklUCLOwPC0oDqb1zItrKUORmZVX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <Damenly_Su@gmx.com>, Johannes Thumshirn <jthumshirn@suse.de>,
 Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Message-ID: <4b351082-d45e-07aa-e76d-c93f8344b858@gmx.com>
Subject: Re: [RFC PATCH 1/2] btrfs-progs: add 'btrfs inspect-internal
 csum-dump' command
References: <20190228144432.17038-1-jthumshirn@suse.de>
 <20190228144432.17038-2-jthumshirn@suse.de>
 <81928a3c-e75b-7059-cd29-660a70fa7f1e@gmx.com>
In-Reply-To: <81928a3c-e75b-7059-cd29-660a70fa7f1e@gmx.com>

--rv05LUklUCLOwPC0oDqb1zItrKUORmZVX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

[snip]
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_debug("extent start: %l=
lu, len: %llu\n", bytenr, extent_len);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 csum_path =3D btrfs_alloc_=
path();
>=20
> Hmm.. Here you allocate a path and release it after use, why not just d=
o
> it in btrfs_lookup_csum()?

BTW, in user-space we have more stack memory, that's to say we could
completely afford something like:

	struct btrfs_path path;

	btrfs_init_path(&path);
	#do something with the path
	btrfs_release_path(&path);

In fact that's the preferred method.

>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_lookup_csum(=
info->csum_root, csum_path, bytenr,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_len);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_release_path(csum_pa=
th);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {

The naming is confusing as file-item.c has the same function name, but
different parameter list/return value.

What about reusing that one or using a wrapper around that one?

Thanks,
Qu


--rv05LUklUCLOwPC0oDqb1zItrKUORmZVX--

--OmD9TblkcSTX0UYjp1MYtK991AS3xl4Hj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyLnVYACgkQwj2R86El
/qh/7Af/TSiSxjsf/F6aEsCHemE2o7oYgalQJ/wg+xv2p+E50DCV0u6bQfUrOhxv
ktOFH1KqEdMEmvxSWYkM1b9LL2ab5tBV4QLJNje1qKiWc6oX4C13I5dlDqPAHEpQ
7AOpm8QT2LLPdvnWvz3nzgR9CFCfbTMT+N5NUoIzsMRcuf4bLhILlIwuZg5Mt3gc
9Wf9hJvSLKwi3lahGPuyplqWGGrUhJ1Q0p92O8pTQMYc8WP4C9jVwqCCpF/R7fxO
4skbcRf00CTeb3OB6zSbxTEXMicWAVRz75unUF7M2kCsxZgwvPBOZ95BwGopoKMs
hD6iCxz/JvIz1FDiYpgN7OOmlCKvjg==
=xUq9
-----END PGP SIGNATURE-----

--OmD9TblkcSTX0UYjp1MYtK991AS3xl4Hj--
