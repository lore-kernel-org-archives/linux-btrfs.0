Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F66C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 05:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E2B1218D3
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 05:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbeLWFCn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 00:02:43 -0500
Received: from mout.gmx.net ([212.227.15.18]:54759 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbeLWFCm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 00:02:42 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MOfx8-1gUrMk008c-0068nz; Sun, 23
 Dec 2018 06:02:41 +0100
Subject: Re: btrfs-convert just dumped core
To:     Raymond Jennings <shentino@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGDaZ_rX9bwugUbysqvbEm0mGs-6sXx2_p6PhUMmUz4j_T9emQ@mail.gmail.com>
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
Message-ID: <55306393-de0f-b75c-5027-cf2cc16b303f@gmx.com>
Date:   Sun, 23 Dec 2018 13:02:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_rX9bwugUbysqvbEm0mGs-6sXx2_p6PhUMmUz4j_T9emQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iuaOtpjfV1BZ80Y7BfbZp1ca7kE4m0x6P"
X-Provags-ID: V03:K1:KlyBt2Tij9drLCPWAfsS0FXNls9S5dpCuFLTZvDpIhRJDZwGohu
 U4c+jTlUVfBTxqIhWbezxe2qfahuGirjgOWXeFSfi5r3zpm6r4C3RL0mBn+iGMtC3Pigu9U
 ZgLchQ0VcG3UJgEzB8iYYzHgO0r1fqaF+cpyoQEbXJCpdO+8UjHGfqd5FFVTB0EMlcMKCDB
 sOvZQaFu5vpvVX8KwskJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y8Bxm5BYJQY=:sopG/i7g5HLNW57wpc0w3+
 i5MOz3A42ghY54EX9TKnx37j8AypDU/fLDhDoGCRcgMVt+NW+4G3sNiUS2uPJNUG7/VbSASRM
 JGsW6CZ9vE6HMsqzKIalRnqB7nv1FynPHf1r+qgcP/Y5O9gps5uFPIVGCML1KcoDrzJs/KN1b
 nfhHXrwrSvUCWZbYT5Huvj4QcDgQYW12aSOmUX3ZrQoZgqEBbGrUCkWcoZ6J/yl6leIdS/lVA
 uHOtKPuuDSBbGclQAeHIPTPKThgQpZEKyeQigb9P1gRecQ8oLUxGoNbZOWjpghxkIUKAbhvx6
 O86pJaVvZu6+6/9ddH6Fk5PLo7edaoPIpAsq2q+8QAyyNyEP02hX9rC1A8AdGS5ywsK1pIuSa
 oJCa1ijAxgGZShDJXdbyOEHxU9vK+2YRg9qaRhndOpXtvd6bElkioX/tJ0a34OmN/oSz+6EPy
 jSW/MEi1uj3wRRw7izUd0hlVLHZD89zNbfuGPpl7xMqu0Ezu6pEzEDWkdO99TgXFEfwhNoaWi
 cWt1IngFpmagrOs8pQbDm4nCUuPgslOZAUPnsYZ6ggsOMtoHTDRbWWnXqG2fxz6UCxlo8eP43
 J1yim0AmGCipO/5LigncD9NZSZH/nVDt5NpD9nJCzoJUcP2ACmJmRcrhohumbRdicQktVjNZt
 Kvf5Rk0eTqHjY5fb+LiqBqfETSE8e7v5S7kkmuN0mkH7XYYQ3ogryoC1gWVDZfHwKr2ypiBGE
 ODa+LJ8HpIi4raWw45TL+YszJGRa0aRbR3uKtTXLHysluagBH/NB7DcXY1SorBYgceF8T5jEz
 XLNswor9onew1BcYmZAW7VtMoSTKMubGwP4pvadQ9E6Tym9EQkvIxiOT4Gc1Weod0yysqxGS6
 S04/GeCn1yZsbM1JHz9+UvlO50mtROUURRup7CGixyNBBit7rOlkUnO1r8svMd
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iuaOtpjfV1BZ80Y7BfbZp1ca7kE4m0x6P
Content-Type: multipart/mixed; boundary="EKfA24O2mSNfxLakyXJFRCQKAyC2Ye5gC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Raymond Jennings <shentino@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <55306393-de0f-b75c-5027-cf2cc16b303f@gmx.com>
Subject: Re: btrfs-convert just dumped core
References: <CAGDaZ_rX9bwugUbysqvbEm0mGs-6sXx2_p6PhUMmUz4j_T9emQ@mail.gmail.com>
In-Reply-To: <CAGDaZ_rX9bwugUbysqvbEm0mGs-6sXx2_p6PhUMmUz4j_T9emQ@mail.gmail.com>

--EKfA24O2mSNfxLakyXJFRCQKAyC2Ye5gC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/23 =E4=B8=8A=E5=8D=888:50, Raymond Jennings wrote:
> I tried to convert an ext4 volume, and it tripped an abort and dumped c=
ore.

Btrfs-progs version?
Backtrace from dumped core?
Error message?

Thanks,
Qu

>=20
> The volume in question had a good e2fsck both before and after.
>=20


--EKfA24O2mSNfxLakyXJFRCQKAyC2Ye5gC--

--iuaOtpjfV1BZ80Y7BfbZp1ca7kE4m0x6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwfFuwACgkQwj2R86El
/qisxQgAsD9nr8bPJdjA9Gaa3wh/TEbRxvnO9YswOzGv4ft4ijyMXjF82lNIxVag
4oVvLLstZjTuNH2MuOPqkVIFJS3t8qBarPibNZC8iEdrUmXiyBLD6t3XGat/Mba2
DTkYcdup9icJibRtQGRxXDki3Kq7gyHpXr47VxTo5uRKEppvQqPI4cUcL3nycil6
qMTNHt2XznBNWyH8V9TN9MPH21/cDYFO3ndKDw9mxaIe00tXzeieZFksfiY9JquR
YibMLTYqpCv/KyjMu/o77rOAHOst+GASYzEhCqk7xpfKd+bbO+YiaHHjrlHOAe3Z
d8243v350iKhO/60Z6ORm3k45zJ62g==
=nDwq
-----END PGP SIGNATURE-----

--iuaOtpjfV1BZ80Y7BfbZp1ca7kE4m0x6P--
