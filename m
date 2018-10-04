Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63004C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 08:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 275F92098A
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 08:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 275F92098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbeJDPUx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 11:20:53 -0400
Received: from mout.gmx.net ([212.227.17.20]:44185 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbeJDPUx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 11:20:53 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LeSOH-1fMJMk0Jh7-00q9Mz; Thu, 04
 Oct 2018 10:28:36 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LeSOH-1fMJMk0Jh7-00q9Mz; Thu, 04
 Oct 2018 10:28:36 +0200
Subject: Re: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
To:     Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-2-wqu@suse.com>
 <0ce061ae-eeb3-a338-02e7-631b3818cb8a@oracle.com>
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
Message-ID: <400132f1-e20e-4b8b-d15d-ea2fd26c7ffa@gmx.com>
Date:   Thu, 4 Oct 2018 16:28:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <0ce061ae-eeb3-a338-02e7-631b3818cb8a@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lwhYGXFTzLekjKrqyi5oPgE5OEnLg0kNl"
X-Provags-ID: V03:K1:mXpuYgYHJEvIu3jDdNNOj3rpddWnDafT68MLiv1clCOi3pwcSG5
 EIx4Kh3ltGAvxddec4YOeyjok1cHNWYUdiLaUsfr+uRzv/AJkw+Do+U5e1gTsqO9zVf/mQC
 hVRL1gjivRXOMoCFEAzm6p2qOqUgVuykGBFnEaYRCxsy2CDxpTgpcsMTQa8QeYeek1Wz4eH
 p1WK5UhmGXXcDsi4oEZMA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:cL4KHpKd894=:gdeFWNqrSsz4oT6n3aDGbE
 7Hs9lX7NkDv24j6IxA7xLhp9PAqijHHSn9MZKCjpyKRjUYDmDh4YJKAyicesitJcJ2aBcRuj/
 kQzI1dlvQH+NNufEroCd1G3xz0PN8IT76O8x4P4yWJLjzy4+huR6FFpZJL2eVXAsM61aFFWps
 NPYkqczyDmuQ+OYCAvN4WVzHLdsCGFFThXy3k9AdH4cTDd2BrOv9wyPOHsYwaUyf+sOOIpzJs
 5UUzbtAph/2dp3JOhu5wmb+FPm4cyFxhQsOdwgQK9qXkv9CWoT15FtPlcdcRdLwI+2rAzuJbt
 R7swB4QC8c5uhjE0z2abFzU6c5sJ7dEHHWHzROljA2qXtVo+IYur52QCCNCcRaz4/vMCmSNHj
 wCMyUMkAnKtZfXSEP3TwVMXO4WWUkN5E4njdD6Zwu8Mqu7YE/5UlJ7mYbnnbW0CvPBdo3CGz1
 D25X3rQgecuQBel+RR4bQVMEnkyKL4Tw32zvoDjIKjSae6RVlTHHGMcYQIBgnnjVZ1djre01v
 mu58cG7IJLIyn6o8Rbyi/3xPcx4v9Df7rxrkjLPx/QrUFUtp8RZi1I4TdusJrj4H8YzDFqeZ+
 bmsUFldCBhiD1MMUgyiFtC4VmhNPHbUCu8cuOf+DE0kHs29lNdFQWd81H9ft1U1/oq1Lf4sJH
 SL6BFqv4IUjlFiuBwy9u3O1kxkOdu4YfCb6DxN4xuVwBOolFxM2N+QMLIcNJhGz2AAZcg6RkA
 wgMuxb2biAWwq3FKToC8t9gtDY+yrAKv897sEw3zonGrTEu+audZtU0Oy3YX+6alauL7Y8okj
 OBnpuuXBuNRp4OcjsSTovoFK61alg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lwhYGXFTzLekjKrqyi5oPgE5OEnLg0kNl
Content-Type: multipart/mixed; boundary="TagAfqnX3gdGY5TWajS9yo4B3nJdEFJin";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <400132f1-e20e-4b8b-d15d-ea2fd26c7ffa@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-2-wqu@suse.com>
 <0ce061ae-eeb3-a338-02e7-631b3818cb8a@oracle.com>
In-Reply-To: <0ce061ae-eeb3-a338-02e7-631b3818cb8a@oracle.com>

--TagAfqnX3gdGY5TWajS9yo4B3nJdEFJin
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/4 =E4=B8=8B=E5=8D=884:07, Anand Jain wrote:
>=20
>> we
>> already expect log tree root generation always to be super block
>> genration + 1.
>=20
> =C2=A0This is close to what I was looking for by reading the cover-lett=
er,
> =C2=A0basically=C2=A0 what is the impact/bug by not populating it?

Nothing really.

Both kernel and btrfs-progs completely ignore it.

> but can you
> =C2=A0explain more, I wonder how was check working so long then?

For btrfs-progs, the behavior will not change at all.
It still assume log tree root's generation is super geneartion + 1.
And if doesn't match reports a transid mismatch error.

For kernel, super validation checker will do such generation check earlie=
r.

So instead of reporting transid mismatch and then btrfs_log_recover
error, it will report log tree is bad.

>=20
>> But it could be later used to detect log tree corruption early.
>=20
> =C2=A0If there is no impact/bug its rather a good idea to change this w=
hen
> =C2=A0the early log tree corruption detection part is ready. So that th=
ere
> =C2=A0is absolute clarity.
>=20
> =C2=A0The reason why I am grossly wary is - we have incomplete business=

> =C2=A0about how do we handle the write-hole, say raid1 to begin with.

If the solution is going to rely on log tree, then the patch shouldn't
affect anyone.

The main purpose here is to make the log_root_transid to follow all
other generation behavior (root, chunk).
Nothing to really affect users.

Thanks,
Qu

>=20
> Thanks, Anand


--TagAfqnX3gdGY5TWajS9yo4B3nJdEFJin--

--lwhYGXFTzLekjKrqyi5oPgE5OEnLg0kNl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu1zy4ACgkQwj2R86El
/qg39Qf+J/OVMuJVE/QiOk8NSWZEud0soD4opBDGHQhNOL9eJFgvS4b/GaQ7guXy
P5IiuHTMKKSjb13M9enb4V/+GKn4/BxwTFAC7zARpzbskHFAN7vhUIX3y/m/GLJf
iBSL/CNGbGzjlbeDVAUUNikitpzUHSy11AIdPUR+OaXXEOyUn8EmW8IwqJpcVkSB
h+sPUUjxhVFbnWYv1P+4O8LaH1QEoLsdFjmaTL/lQXffNwN6CTzEE9jwEgP5M42R
zpCB/ZzDv9ndw47muJx8Z5MFOgH/wsCABhZVxqfUOqgCk1wU2gcSXriMGP9CFKoF
Zyt3VLR0XYILSnelccBZ8+zjzmTFLQ==
=c5Sw
-----END PGP SIGNATURE-----

--lwhYGXFTzLekjKrqyi5oPgE5OEnLg0kNl--
