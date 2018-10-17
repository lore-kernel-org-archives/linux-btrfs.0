Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B041AECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 10:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F124214AB
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 10:39:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F124214AB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbeJQSec (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 14:34:32 -0400
Received: from mout.gmx.net ([212.227.17.20]:34221 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbeJQSeb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 14:34:31 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LdHLB-1fmE7W2vqr-00iPnr; Wed, 17
 Oct 2018 12:39:24 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LdHLB-1fmE7W2vqr-00iPnr; Wed, 17
 Oct 2018 12:39:24 +0200
Subject: Re: Urgent: Need BTRFS-Expert
To:     Michael Post <michael_post@web.de>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
 <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
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
Message-ID: <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>
Date:   Wed, 17 Oct 2018 18:39:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bjiaYkhqoiluNAoqnCCVHkmsch3vMXueH"
X-Provags-ID: V03:K1:bYQkeLHaAWcGpDsMqm2pJLdt0qhEC/y0jgjukMbSfG4Gr9QcldS
 qvDaoz0XBL56sNiRISl3C/cbpFtPlvVYzRKWdbW2ysy8cpDsuiFOy53Bwq+OG094ST3aVG7
 XKITi/W27TsgFeAI5cXQFh7+mW6eCHOxB5SlNr7TVZu0VRsDxYFWIkR5sqj7Mo0NHQBwXB4
 ZpNLan2XkFUAcOEl8Bx6w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Ro5/3ouu8Yc=:2cENNq2QmI9VBxg8uUTgnp
 E2d5PRAkd2jojA2uMyQrL7DNWRhXBTYWyLBXJCaBH2NKFb7Efm5IbQgEWsE78JqEUTOLMbrwL
 V7vwBaRmON//zoUtmZUardftrV36L2fdft+2ikwOk/Fr1sU9t9x7aJeH95/ecS5vL5XY78kW5
 DyUBuTMLVgoOgj5WzaxQbYrXDkCwmAQsBLvnp7eeSNz0HgUoIiT5l23fEwQjKewrGDNLCrdAo
 /KwwKiADKZn3M3nf/apjblfApmh0LAO/4e+SBeueSYKu2pC9nTejBSzC3s4Jjl1963e5deB3G
 u23DnMbQjbb1UW/Q8u5eiAkkqyiyCEHvmWrnN+8vVWBxoMeHiVcJDKTwnBCTa2CMYhm6oVrtc
 91OPiw+R4mzBE3Tyi/GcdYuAENOY0bIrv2AMG7X5GWxxFVJKxUZiZGX5r+mCGMSFEGDrCTMHm
 IAGZzt/L73wqmqP0yV4HULAezq3oeSMz+z/FKvgri6R2t706g8i2hTjqjGo8q625IZnZBpJop
 2HGRxc8XrfWNoVDmX9P6ycQLnSsm3DLzr8n1CJKlzLJIjLEi3JrJ6TEjHM+1UqbBZ/jJo8uE6
 jZLaDuFP3o56dZnLVA64FzuqvcMQno7OwN6eQ7QOS2W826mrHVShpRZKSG2vY0onQqNzMPQd/
 M75uFSXkA7Mpsw47onrguPC9eJhAeie/8lx+FI2jOarZvODIBCwwhlVPiqDh1KLdgCCH+9TsG
 iM35DpTQf/OUkxE01ONJV6XpoS5ydigMJ45oz91ebfgYyyoD/lzzggtK5/XWnI3SSyrkCnRjm
 vCbD33XiIAjYQOp5pEZuBRkio0plQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bjiaYkhqoiluNAoqnCCVHkmsch3vMXueH
Content-Type: multipart/mixed; boundary="x1gLLGqYQvloWNw7efe7lnD9ZkXCL5Fgw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Michael Post <michael_post@web.de>, Hugo Mills <hugo@carfax.org.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>
Subject: Re: Urgent: Need BTRFS-Expert
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
 <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
In-Reply-To: <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>

--x1gLLGqYQvloWNw7efe7lnD9ZkXCL5Fgw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/17 =E4=B8=8B=E5=8D=885:27, Michael Post wrote:
> Hello Hugo,
>=20
> thanks for your information.
>=20
> I have an 1 TB BTRFS-Partition which suddenly could not be mounted.
>=20
> I tried the following commands
>=20
>=20
> host@:btrfs check -b /dev/mapper/vg0-virtualbox
> ....

This is the important part.
Please paste them out.

Thanks,
Qu

> Errors found in extent allocation tree or chunk allocation
> bytenr mismatch, want=3D1263661723648, have=3D0
>=20
>=20
>=20
>=20
> host@:btrfs rescue super-recover -y  /dev/mapper/vg0-virtualbox
> All supers are valid, no need to recover
>=20
>=20
> Then i did
> btrfs rescue chunk-recover -y  /dev/mapper/vg0-virtualbox
> This commands fails after around 2.5 hours with the messages, that it
> could not recover the chunc tree.
>=20
> What are the next possibilities?
>=20
> Greetings,
>=20
> Michael
>=20


--x1gLLGqYQvloWNw7efe7lnD9ZkXCL5Fgw--

--bjiaYkhqoiluNAoqnCCVHkmsch3vMXueH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvHEVYACgkQwj2R86El
/qgW2wgAjyyYpPP0RX4nnSsVq6/ySoP7/2UB70Rov41k4WuSBOlJ+/XKEIvgJ1zT
ySi4nGMekrBU2DwOl0KtNjbYlR4PQmqUaF4+DMeYQFKSFv6gi651eCbYA6Dxc4i9
mFQrkT2tIAfo1ciRTgEi7XEJTPyVJRNspxOwOLn83rt4WOFS2ugxf4pVLfMaQ03T
MMQKTZoN1FoX+XoNVy0CHFL2sDiirT2McspsScgPncHbByXWXD/5J0kymaZOuXA1
OJMpmWQXnxR8zTU4ilGh25tMjdAjohok8F0YBhy7NiUluSJQ4N2ve1mwfCHaYpnM
TBCX65MVXu4sUlm23fTjCC7dBZbgBQ==
=67Jm
-----END PGP SIGNATURE-----

--bjiaYkhqoiluNAoqnCCVHkmsch3vMXueH--
