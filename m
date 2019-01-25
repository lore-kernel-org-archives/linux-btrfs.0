Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D04C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 07:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC54D218D0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 07:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfAYHlo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:41:44 -0500
Received: from mout.gmx.net ([212.227.17.21]:48811 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfAYHlo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 02:41:44 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M24Vr-1h1z4B2f51-00u3Ux; Fri, 25
 Jan 2019 08:41:41 +0100
Subject: Re: kernel calltraces with btrfs and bonnie++
To:     Stefan K <shadow_7@gmx.net>, linux-btrfs@vger.kernel.org
References: <4998841.JdUrKLmerL@t460-skr>
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
Message-ID: <424e17cb-3888-bf5b-c19b-e88ac0d5f88f@gmx.com>
Date:   Fri, 25 Jan 2019 15:41:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4998841.JdUrKLmerL@t460-skr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MOI5hdKpBX94P8Tvl4u5xhI2gB3X7lGYa"
X-Provags-ID: V03:K1:yesEQpJ5KXuxRmoksO65a7dooR902s8MqkTW5YO/A4a7oCj2qQy
 rdAKcELDmNujHCWFuiBD/n8iXeny7Gar5vVQ4usKvT1mPykY4jZkwGI2xPuVCJrRwAR5DYh
 wGOafFil+Uhy2G/l67Vviio3zfLcEEdWtos8i2KJPgvWJflP1z7b48QxjwZ4uRbl3xjZETf
 G5WRB+MlERVyZAVjEKB1Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oCbstwGLDXI=:WyUPxHAU9RIG7Z8NpvdqVj
 E678Y/fznz2wNl2B7CHii7ZbwtEshvWKRgxeG0dT2AxIZTKc+G9OpKW2zSk40T1oQrvH8sFtJ
 M3o9DBLEU9OivysxJk8ChYZFr6o/zTarOh7b40qD2ZlsTM4ANrjWjzKOIPlnB/fLSmuQR93ET
 f8Bq8Evn2CgbqdRi2L1yKeFiY235GjRlNdvgiqs0uWqZEPatk+plowtrtYoQ2BB3VvREDaCCd
 XMK+CM+A4AiyGpzdIrYq6eiaTsWInbpwLeo+xFWLkWWLXS6fiv2tqTbtyw1E0nIWzJOlnq9Ut
 j8cGP/EcF1l/qgSiaduUJgTx6la1QGIAKv1oapgqMSfG4Eim2bEDRP9d3Ql/6qiNTKcypHQ9V
 LUl2/dLLWKcWaRavSlHU+3tA8Na97x7g6q2gdqiHET85WO2ehwemmPxnQxt5hI63u+8WDH9M2
 bzDwuJOFmC1RBeawfGtIYP5FdorHJbJjAFpAa51oWPgyDgYhNPlrr8Kqoc6fbm54eWqOGCx64
 BHX3DQ8jgovwauKoBaTHtRsXh0SGGtGw2Ak5c0F5xVx+gbWdHg7Qa5cUIUpclTy/tlCcrSKGA
 PXmuZ/QzNT9S3l27Cke3p4UI0HDs4zjFpOHq3Ujqx05ZOx4jU3+cZfxAsXV2tkgUtmSWmzi3S
 bQRbz1bQ0Mp9yt93/6ordSF5cRS/ck49AamMYKf+fma8vhOLvwEiNEhaY9GUynjDhFR5CGL0/
 G0mEJVs2mZap6UiB+3Qiylocw7Wc1UzAUt2pNGvfHRvdLep08gShEfK1VVuKP5K+FbGSL88gz
 2zh2o+3lNxtI/vJGna69GEf7MCo/2p794GfKeBNhH5tBChQrhTwSS9OLRkDKy4AQKFYpqZDON
 xqI0uYdwIQqnscQM4qIq5DuJAoiu7JrOiacewNCIF/IjJJvmpDY3//z0MrXqVX
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MOI5hdKpBX94P8Tvl4u5xhI2gB3X7lGYa
Content-Type: multipart/mixed; boundary="crQjGL4E4PUjeHmjdDqiVmo3hx9YEvyuw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Stefan K <shadow_7@gmx.net>, linux-btrfs@vger.kernel.org
Message-ID: <424e17cb-3888-bf5b-c19b-e88ac0d5f88f@gmx.com>
Subject: Re: kernel calltraces with btrfs and bonnie++
References: <4998841.JdUrKLmerL@t460-skr>
In-Reply-To: <4998841.JdUrKLmerL@t460-skr>

--crQjGL4E4PUjeHmjdDqiVmo3hx9YEvyuw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/25 =E4=B8=8B=E5=8D=883:39, Stefan K wrote:
> Hello,
>=20
> if I run 'bonnie++ -c4' the system is unusable and hangs, I got also so=
me CallTraces in my syslog. Is that a normal behavior?=20
>=20
> My system is:
> uname -a=20
> Linux tani 4.19.0-0.bpo.1-amd64 #1 SMP Debian 4.19.12-1~bpo9+1 (2018-12=
-30) x86_64 GNU/Linux
>=20
> btrfs fi sh
> Label: none  uuid: 24be286b-ece6-4481-aa48-af255e96e5bd
>         Total devices 2 FS bytes used 128.89GiB
>         devid    1 size 219.84GiB used 131.03GiB path /dev/sdb2
>         devid    2 size 219.84GiB used 131.03GiB path /dev/sde2
>=20
> both are new SSDs:
> smartctl -i /dev/sdb
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.19.0-0.bpo.1-amd64] (loca=
l build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Device Model:     SAMSUNG MZ7LM240HMHQ-00005
> Serial Number:    S2TWNX0KA02412
> LU WWN Device Id: 5 002538 c40b988bf
> Firmware Version: GXT5404Q
> User Capacity:    240,057,409,536 bytes [240 GB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    Solid State Device
> Form Factor:      2.5 inches
> Device is:        Not in smartctl database [for details use: -P showall=
]
> ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Fri Jan 25 08:37:49 2019 CET
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
>=20
> if I run this I got this output in my /var/log/syslog:
>=20
> Jan 25 08:19:20 tani kernel: [  480.733545] WARNING: CPU: 8 PID: 8564 a=
t /build/linux-Ut6wTa/linux-4.19.12/fs/btrfs/ctree.h:1588 btrfs_update_de=
vice+0x1b2/0x1c0 [btrfs]

This is a known bug for older created btrfs with unaligned device size.

You could resize the fs by -4K and it should make the warning disappear.

Or you can use offline tool, "btrfs rescue fix-device-size" to fix it
offline.

Thanks,
Qu


--crQjGL4E4PUjeHmjdDqiVmo3hx9YEvyuw--

--MOI5hdKpBX94P8Tvl4u5xhI2gB3X7lGYa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxKvbEACgkQwj2R86El
/qjUqQf/Z8ZXJWYqoiQ/VJaVlr+fD9cel8moJyuhcO3hefCxur1NPB7tETdf3Nux
NBB9w7dH/f6FDwNre4pWofgWuYHDe75XLhHLsMhe+8yqD1GHP9x1iBBkIFOjPh0M
ccweouM8/VgJyO6HqgERWB2R//eb0D9FHLYcOB4w7hQJKMKDgVxe8W5yiNnLgbHp
HGgo4eiDCY9dn3br3lMKV8sB1L7Z1+5NdNL+2qY+ylrZYwVgUHx0597xdVB+/KIE
4yORy4RVy+2rORyiqgIMfZCUhGoBf04JxRfZ2FSQ1vo10r0HA3XtBWVldvlpm0sn
Cud1bklKJDzKZ/JWcn/IJhRrBwqzDQ==
=IKqg
-----END PGP SIGNATURE-----

--MOI5hdKpBX94P8Tvl4u5xhI2gB3X7lGYa--
