Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570E6C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 13:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 261F9206A2
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 13:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbeLQNy3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 08:54:29 -0500
Received: from mout.gmx.net ([212.227.15.18]:60537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbeLQNy3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 08:54:29 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MKIEQ-1gXFBs2wwY-001i5b; Mon, 17
 Dec 2018 14:54:27 +0100
Subject: Re: mkfs.btrfs vs btrfs-convert
To:     Raymond Jennings <shentino@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGDaZ_qug36TLzvQA47Pvo1t5pVkJdx7FhDYpc2LYa3eAWDiuQ@mail.gmail.com>
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
Message-ID: <45581fd8-f959-0df5-3a53-89e03a7a2c84@gmx.com>
Date:   Mon, 17 Dec 2018 21:54:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_qug36TLzvQA47Pvo1t5pVkJdx7FhDYpc2LYa3eAWDiuQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rTbpL17gygkbmS2X1mcZ8DY8AnPq1KVb4"
X-Provags-ID: V03:K1:5K26x4HJOuJFK+L6phRmTo29gncOunrPfMV7P6O+OJId+eUVYJ6
 b0lgcf7wUClf8sLmBpJCC7pAWRZ7RDVZPHoMXIHpQkndm3K6v3XGJtSzjyhwfb/KpbS1DRy
 AhCPsWBisldPIwTHjJQq7Jhh9Gp1vYVZAo3JgFQjZ492fttaObz8atxbtnMfLbJkiP/OabN
 ModPPLNPbSFmXK7+xMaow==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wpcwHdFhCjI=:YIaGEqD3q3GZjqLOJW9b9B
 95BY08heV4BrBDIlu1caiCuyF++8fc+vvD3ZFM6sr8jG2v3xktKMcyZ269UIlO69Pd1rljZ4y
 VrQ5SFTDfesImUAL27pCX0Zk7X8L6k3dDKQwreC0NUKU3Q2LdZ+3c10nD71C160p4Ga/zbWo9
 NuZbCdShJRSHW9/J9skF5ybeWvLv7Y1gkDrFL19deXbS34dMqDUnE9OK9ihntUAjpexqCuCJG
 7LrFjAzBlM6/+QUKTLi1M/IIyxOC+BMCZtDDpTpqByfBD9xJzmbJwJo/Jxy8z9I4MFkeqVyht
 FFwpsZ/VPNdmmH+UTPrAQrEdou8WQ9IkWgoteu5hKG5OvkH4FGNOMLC1Yj+0gqXasYOhVBWZ6
 kJzjv7tAqGPymdQzwWP7vPI0HwN3oZvavNzFQeyEdT8rOFvTiKG3Yrg3TnBJ8L7lsdDlx+iH2
 mu1vQ3WMAfXgVwtEsMJMwJ4NEOyZy3XcTcw7CaTv6HKBCQT+/3cSbq6+UQtgZKZqmL5PNUl15
 uECOX7MVO9wT9FRngmKKH7F9ActiDR4nmFf8j1m2ku5AWtJXAKXOgzuqioIVbXCXtn/M33D6e
 /9jjv3x1FKR2SaB9FQnlVyV9p6DlUx0/3JVnVixJCXwLCGFZrrBWiXDpe0+ge6u9pEv5gNfhD
 Dff6gA7dWowVpXtCc/jWmdrprjYIWKD5CdcsLnXMZpOIpNyiRPeMtYEAB4Ck/47/0P34euMkz
 kyNxhkliBtDPmz9Ee0gBpYj2VAqPsEGC79Kob1p9jsDGbZduqrUTd5KNX4HBV/ziWgBknKl1A
 sMAYTfc/99jUKEmVDh8SHNK2HKLuKJ7aO5aFmpdwFrhMTBvLgqSyfCTLdrCLLzvJuthdm1eE4
 JuFqUz/FiMYjrRywYc5TMInCT/kARdYsg32rNw25D7neMiIlg1hZ0fvdHMv6tX
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rTbpL17gygkbmS2X1mcZ8DY8AnPq1KVb4
Content-Type: multipart/mixed; boundary="yeiJJnk8m57z8m0vcrmRlKWoiIVEZjzYs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Raymond Jennings <shentino@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <45581fd8-f959-0df5-3a53-89e03a7a2c84@gmx.com>
Subject: Re: mkfs.btrfs vs btrfs-convert
References: <CAGDaZ_qug36TLzvQA47Pvo1t5pVkJdx7FhDYpc2LYa3eAWDiuQ@mail.gmail.com>
In-Reply-To: <CAGDaZ_qug36TLzvQA47Pvo1t5pVkJdx7FhDYpc2LYa3eAWDiuQ@mail.gmail.com>

--yeiJJnk8m57z8m0vcrmRlKWoiIVEZjzYs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/17 =E4=B8=8B=E5=8D=888:51, Raymond Jennings wrote:
> Just curious, but does btrfs-convert support all the same options as mk=
fs.btrfs?

Obviously, no multi-device support for btrfs-convert.

And btrfs-convert would create a strange chunk layout.
Kernel can handle it without problem, but the layout is still weird.

Despite that, one feature, mixed-bg is removed as btrfs-convert uses the
traditional separate chunk type (the reason the big rework on
btrfs-convert is to get rid of the mixed-bg).

>=20
> If not, should it?
>

For multi-device related one, since ext*/reiserfs doesn't support
multi-device, there is no need to support them anyway. So at least for
now, I don't see the need to support that features.
(You can always add new device after convert)

Thanks,
Qu


--yeiJJnk8m57z8m0vcrmRlKWoiIVEZjzYs--

--rTbpL17gygkbmS2X1mcZ8DY8AnPq1KVb4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwXqo0ACgkQwj2R86El
/qhZTAf/UZpm/VySMOEfXMOSac4H5Crg9/+AQxB5QeJ74LuUE5eKy225RUMG7HWf
Q6g6GMTBnheWQFZzz53OBAhNjdL/hZJsV35NbPnRYCjJAfvUFzTQVPz3D8iYiKHU
SjbAvyJEfntsd2Forz9l8e/QOVK/zRBEV16b5/ycPelB9UA7Ms5JZrjm1BssL5ei
xoFjsThL5jqmaLQYAFSzgMNKSo8NjoHbKQF0YlTBErjmyoqIRJEXYySaXUDoBUW6
f/pdSfspsS7Z9ur5fz0viOCwc7PyW2UnGgrh/zNvVMw1CFBbXz8gKIMywS0jThoi
3jbj+EBiomPJKugxadpl+hyEbyV9lw==
=pFKe
-----END PGP SIGNATURE-----

--rTbpL17gygkbmS2X1mcZ8DY8AnPq1KVb4--
