Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D54C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 13:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9045520874
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 13:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbeL1Nq4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 08:46:56 -0500
Received: from mout.gmx.net ([212.227.15.19]:39629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727249AbeL1Nq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 08:46:56 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MQ2Wx-1gh1LK1u0x-005K4u; Fri, 28
 Dec 2018 14:46:46 +0100
Subject: Re: Kernel traces
To:     "Stephen R. van den Berg" <srb@cuci.nl>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
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
Message-ID: <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
Date:   Fri, 28 Dec 2018 21:46:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181228134006.GA13717@cuci.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YtlBHyYLamlSRl5oOWTNzxKmJgKq83tCy"
X-Provags-ID: V03:K1:12mYzzGBqRnWrORI4NTizEfLJFm72MU/8P9VOAQMc7sg2s7pel9
 ycMhcAXBa89HBenw6+7xR4BRvZcxqtV2b9+UNgBw1LGYDy3HcoMl/xsvqK90diFPHh8lZkb
 J4R2ehbBWaHl+43Ucf/ty0NIMk4l51Z30DHSRMdlso/PXab369p+eaAFKDfckZvpB1bxjc6
 wmMm+lqQMF6ftyT7AbxqQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8hmqjjzFFmM=:LzltlqgNUFWIFoBU4s+O+c
 IuPZ9WVqS8xsaaHS+Wob9/7MLi5RnILd7KTBF1ONpWzur7h7aOpxGQYuRs0sr2SzlMi+hmcoN
 BzM0BaiFej3U1tZzbK5XanLoFON9hc4UIglpB7VDfv9p3pYKLhSBQ7Rg8QptTxayw6uyj4s48
 fRG0ME9wX0kV1H2IgxkDygjB0XUyqhwCfQQ3vFvgXjb0QIuUc570+zLLGTHjrEvyDrcAlPboM
 WpvJ4ltSbDLqPXcs8X3uOEUyO1uDoELYzawESRCb4/mzN5Fy80uxZem11zlDTPJmrjCouawbp
 IjgzBzVWnJ/Aocf2fAtS8qSqW5TZ8bbDuCKXSlM8BvHDsXjPyZt8zN8S94zinUmZsBlUAj9u4
 iloSCTkd1UuKqXpBaswhFJH4yMFYF00Tfusyei/nW2w6ytdUAuNyA3Q+mqzu0QOFouDZG70Cm
 Pysf0Uyc/fULaBlYagmIfS7ldjuYGV/sBMxuPrxwpzvhVak1WZ22YTwusHWOQbHJbMFemNy4M
 zbHNsij0xQhocvJQR8KnaelWKFoA3jRtzMzEw4imaApnNSGgZxYON5wPzRgLmUMdUnHN/SSng
 BqaJSxGi/8QFW9uz/XFOMPGyLcj670bEbBU8gnOuTAXiQfP2Bazkqt0/kA9xCQrcJn42/3xqV
 lP1Zjj9Wgyw75Xecy/sBV2jG4VWVyRbFywIEat0smusVGptLsEG4xseTwpKtcbIq4ljZ6H9M6
 5L43xoUX6uT5yEKoW7CHSjXJpae69AYwCIjYowXHLqa+bjryA5HK53kay/En6Ajk9EdlAp+dq
 HYr5xhXsBUEW2qsLsMQFCwUgDgEU8IWzzdSpVTAqP80BpcH8Ox72hH2R2SGaKeQaFHeLZ4IhN
 KZW03wn7cyndaIr4STV3R+HnWBIsqkP+TFjjdyQwvFZ5qj8F/r3CsmS4FevP2z
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YtlBHyYLamlSRl5oOWTNzxKmJgKq83tCy
Content-Type: multipart/mixed; boundary="5nlJiaPnbtGncMDVmWgeTsaGckAF4Mc9H";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
Subject: Re: Kernel traces
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
In-Reply-To: <20181228134006.GA13717@cuci.nl>

--5nlJiaPnbtGncMDVmWgeTsaGckAF4Mc9H
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/28 =E4=B8=8B=E5=8D=889:40, Stephen R. van den Berg wrote:
> Qu Wenruo wrote:
>>> Ok.  Finally have a sysrq+w output of 4.19.8.
>>> The uptime of this system has been a few days.  It has already receiv=
ed quite
>>> some btrfs-sends in that time (every night).  When the sysrq+w output=
 was
>>> taken, the system started to get more and more processes in a D kerne=
l state
>>> bordering on becoming unusable.  I had to hard-reset the system after=
 this
>>> to get it going again.
>=20
>> It's caused by qgroup, and a dead lock on btrfs_drop_snapshot().
>=20
>> This is one of the easiest way to trigger an ABBA deadlock.
>=20
>> Please either disable qgroup or apply this patch to solve it:
>> https://patchwork.kernel.org/patch/10725371/
>=20
> Any idea in which kernel version this patch is/will be included?
>=20

If we're lucky enough, it would be v5.0 or v4.21.
It may be more likely for v5.1 or v4.22, as there are tons of pending
qgroup related patches for v5.0/v4.21.

Thanks,
Qu


--5nlJiaPnbtGncMDVmWgeTsaGckAF4Mc9H--

--YtlBHyYLamlSRl5oOWTNzxKmJgKq83tCy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwmKUEACgkQwj2R86El
/qgY6Qf/ZkE7vw3brhOXSXHMLnXG9nbVJ/HZDl1jehf53fsb5Ws3QESoq1V1Z4Xs
FEqwXu7BUB7RBLMAAb13yZF6iKuIMmVn9ouCoYuT4GJ7rEXWSlGOp8ZXwXe8vtJv
KJH/O7MmnDMBW3b3uogDRHJM//i9eKJMKcKgpJeGszcf5Rx4jYDJsKuuFh3ra63U
DFlH4KYQ0QQ2NmB8luqzowMahxArC5B39izQNurUvFgxGTxTLO+CHw3pzLAxvKY3
ir9S2EV1a3rAGHYuXnF2fdHgtYizEYPNnoZrw77BeqY0RaQeBVqljM3UOxAY7ZBm
jDiJp4ok81R0Aim9s3Z2JmrnJ8Nuqw==
=72Cn
-----END PGP SIGNATURE-----

--YtlBHyYLamlSRl5oOWTNzxKmJgKq83tCy--
