Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E47C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 01:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 498932081D
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 01:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 498932081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbeKILAY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 06:00:24 -0500
Received: from mout.gmx.net ([212.227.15.18]:39713 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbeKILAY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 06:00:24 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MgKUo-1g78GY1vhG-00NgBH; Fri, 09
 Nov 2018 02:22:05 +0100
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
To:     Pieter Maes <maescool@gmail.com>, linux-btrfs@vger.kernel.org
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
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
Message-ID: <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
Date:   Fri, 9 Nov 2018 09:21:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wFloQMzc0kc2iz0cLt16QylyUPJOPFaqS"
X-Provags-ID: V03:K1:P+bsV0Ys1LhLf1TMUh18YHK9RttfD58COCcHGyog4dZTkwtsV54
 7ihqOw9XrGB3nIRqO38xycsfRXML2u2PgEU+4zZ0vYCSzsD06rFcnMOXrXkXhq4Qu3BYXY1
 N3zusNJ3XOI7Ap3jUWeUwVOuJ3zyB/NsqQjytJ3tu/Y7ZUhRSuPmrQBpNNWhUJACcavzjxj
 r5YmXjdCc4LfV8wmeO8uw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:C3c6qepeLuY=:/u6v7b5XfA8stbzxFBqsvg
 HC8p4x/vYDcw6JlcMoFTegi6sKcBteRII8gCoamatut2ld36tOtin+4HL9LJuQy9yTOtnaceV
 cCev4joCzmlTkVmb0GPsGw3WPi0divWiQ/rN+aTDzBVvhniHg0yO5Up43fcNYsJFF9chDV4vf
 2AvuI2CTKu1KYDJSy4ya+s2/HIEg6LuCmOYbkXJwoqttTmucfFBLLto8+Rb7TfIMZXdA0+c3s
 SDVKl0KyhlV8JraqIsMS8EP0Cw1F0aKdg/g1cV4u9fMzmkXFffKgyj4HbHd4wR9D/agnJi+wG
 Yv7twCfHYAlODcf1BdLniQ3mZBxEJgwX/arwAMrmFrjpddxCQ7Ahojm416FHm5ccl1A8mdq50
 0srQvWMhxmF8wZcq7KHwIE30+lgSzO5FfSgjAMyO9Hqc43eMWSfEQhsTA7dYZZN4PxN/awt/R
 Agp/nuyZLQfkyu8EEJXGC8zYMPPiWWGQSZ5YQ5HDpKHENkKgZIq/VJZiVxlkgaXJN4xsK+4rO
 GPr6m6jw/euw9PpD6xg6dGDe61P5UKtPqI/U+AfHu3+rWIVx90wf2XG782/5LtiHz323Jp/QJ
 DuExcsbasGS+cdbKxn0FNLAySRCzoHgoCOsTnV49z8Xc1E8/Z5KPGfW6UThoJBc2W/SPWnEcS
 p+2vcWjn6XqwLM/IkhhDPDyHwi1tfYCppR5oVjEt/8Q/BeyrSn1jRCiGRTrreRFGBkVJc4rKo
 Carju/pIEjkwUpwDbyg/ZLrZm11SEljRmwOm1o/PjEIBg8E+iFHtCDbEWg7eKZFLDYLiba+Kq
 QL1nW4Sn6AQ4ySSpNLETGs5s9cufp3cUZT0abIF1sKNB8tFNpY0cQ3ERnTe9v46ljT2lcCerj
 XlaaabuQvg1N1x4B4cXjS732fCYgRibr/VehsvJDc1/N7tjPfyxnX7aPerAIVO
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wFloQMzc0kc2iz0cLt16QylyUPJOPFaqS
Content-Type: multipart/mixed; boundary="JMOdGlPbtFe4hY9avvHvCHN3r1AnOqV3w";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Pieter Maes <maescool@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
In-Reply-To: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>

--JMOdGlPbtFe4hY9avvHvCHN3r1AnOqV3w
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/9 =E4=B8=8A=E5=8D=886:40, Pieter Maes wrote:
> Hello,
>=20
> So, I've had the full disk issue, so when I tried re-balancing,
> I got a panic, that pushed filesystem read-only and I'm unable to
> balance or grow the filesystem now.
>=20
> fs info:
> btrfs fi show /
> Label: none=C2=A0 uuid: 9b591b6b-6040-437e-9398-6883ca3bf1bb
> =C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes used 614.94GiB
> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 750.00GiB used 750.00=
GiB path /dev/mapper/vg0-root
>=20
> btrfs fi df /
> Data, single: total=3D740.94GiB, used=3D610.75GiB
> System, DUP: total=3D32.00MiB, used=3D112.00KiB
> Metadata, DUP: total=3D4.50GiB, used=3D3.94GiB

Metadata usage the the biggest problem.
It's already used up.

> GlobalReserve, single: total=3D512.00MiB, used=3D255.06MiB

And the reserved space is also been used, that's a pretty bad news.

>=20
> btrfs sub list -ta /
> ID=C2=A0=C2=A0=C2=A0 gen=C2=A0=C2=A0=C2=A0 top level=C2=A0=C2=A0=C2=A0 =
path=C2=A0=C2=A0=C2=A0
> --=C2=A0=C2=A0=C2=A0 ---=C2=A0=C2=A0=C2=A0 ---------=C2=A0=C2=A0=C2=A0 =
----=C2=A0=C2=A0=C2=A0
>=20
> btrfs --version
> btrfs-progs v4.4
>=20
> Log when booting machine now from root:
>=20
> ----
>=20
> [=C2=A0=C2=A0 54.746700] ------------[ cut here ]------------
> [=C2=A0=C2=A0 54.746701] BTRFS: Transaction aborted (error -28)

Transaction can't even be done due to lack of space.

[snip]
>=20
> ----
>=20
> When booting to a net/livecd rescue
> First I run a check with repair:
>=20
> ----
>=20
> enabling repair mode
> Checking filesystem on /dev/vg0/root
> UUID: 9b591b6b-6040-437e-9398-6883ca3bf1bb
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated=

> checking fs roots
> reset nbytes for ino 6228034 root 5

It's a minor problem.
So the fs itself is still pretty health.

> checking csums
> checking root refs
> found 664259596288 bytes used err is 0
> total csum bytes: 619404608
> total tree bytes: 4237737984
> total fs tree bytes: 1692581888
> total extent tree bytes: 1461665792
> btree space waste bytes: 945044758
> file data blocks allocated: 1568329531392
> =C2=A0referenced 537131163648
> ----
>=20
> But then when I try to mount the fs:
>=20
> ----
[snip]
>=20
> rescue kernel: 4.9.120
>=20
> ----
>=20
> I've grown the blockdevice, but there is no way I can grow the fs,
> it doesn't want to mount in my rescue system, and it only mounts
> read-only when booting from it, so I can't do it from there either

Btrfs-progs could do it with some extra dirty work.
(I purposed offline device resize idea, but didn't implement it yet)

You could use this branch:
https://github.com/adam900710/btrfs-progs/tree/dirty_fix

It's a quick and dirty fix to allow "btrfs-corrupt-block -X <device>" to
extent device size to max.

Please try above command to see if it solves your problem.

Thanks,
Qu

>=20
> I hope someone can help me out with this.
> Thanks!
>=20


--JMOdGlPbtFe4hY9avvHvCHN3r1AnOqV3w--

--wFloQMzc0kc2iz0cLt16QylyUPJOPFaqS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvk4TYACgkQwj2R86El
/qjuCgf/WpAtY4aNxZ3yWb9lGu6eMVRurwIHI6+4O52n+hdg8hwjYuL5abo2ZqPu
ELdffg5TjzNpGewLujgAS6OFTjiL0ijrRulTlPpDrbXkB+EbDKY6fBdTgJJvYFtN
C9lkoI7u7cN7+jy0cKI4w23f+NuVLPfe+dsK/mPGsxq/7S95izfh2pzDO+TZyDpy
7WnqnhOS0TItE91SJp9fZ84XeMfBy637lhRNof+x5o7UiohcUKsBAtt6Toay815X
D/W8VUkr3e68O+hBwY4Pw/HycRP/uLZL8wqFaSQ/D1Rjcu5+S2XOZq7nmR8zyf9f
A97KzstSgwMpBRQkIv8O/vJsnSVwNw==
=LkgV
-----END PGP SIGNATURE-----

--wFloQMzc0kc2iz0cLt16QylyUPJOPFaqS--
