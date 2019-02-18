Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4411CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 01:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12700218A6
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 01:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfBRB7p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Feb 2019 20:59:45 -0500
Received: from mout.gmx.net ([212.227.15.18]:36705 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfBRB7p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Feb 2019 20:59:45 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LoEPJ-1hXLoV176H-00gEVv; Mon, 18
 Feb 2019 02:59:43 +0100
Subject: Re: Subvolume ID 5 Showing Deleted
To:     Carlos Medrano <crlsmedrano99@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <020801d4c71d$eb30cd10$c1926730$@gmail.com>
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
Message-ID: <faa2ab00-3673-870e-9867-617c4d9733a2@gmx.com>
Date:   Mon, 18 Feb 2019 09:59:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <020801d4c71d$eb30cd10$c1926730$@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JbstRHQ3Msj7o4to1SiLc1HaYkjRFUGdF"
X-Provags-ID: V03:K1:JpEBxqT+3H/IVFo3aW7EYbTVcci7hu5ldSo4CuDXsa+R2llEb2n
 ihPUfVmscdryzXT0X3ifS4mopcvfJUPP5+GP42yTw10SksBUxs52k/niUoMBVNxQGgN0ep8
 0fNA26wrWspjwfyB2xSedQxDKeZvn0i+ahAWtlMsiOP9AIZM4c+mHhBxsvtRRKzqQ9oU9Jv
 OQ2uH6reWc7IYBBs0NB0g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GUatJo9J8CE=:M2lquwf1VAwv1246W4Hqj/
 07uZt1BtHo+yq35MvEK4PRwfsNn6EARGur7edOBgX43F2Gi/LUsCmQPGEG9+Cn1jgpTu9qOUp
 Xrf0ZbIkugaK8vvp2+XPAPBcuArQKQ9XVFtGP9jseoM/UFnzLoBMnO1IcitjkjTOzGDTdMv+V
 Lqp7CbqOGi6Qe6Nx8WyTRRswys7BTM37NdLUGuS7MOYyBUBxAO3gRZNhF/lPZYV0xsryAf33h
 jaWFIDS1/ogfEiNtUpfqVnKLNQBE5Q6Z6ammkqBYEhP5Wg/tup6MkRU6DsPGJt62CyzCFW5Op
 dWVs0xk62drQ7MdUIIQUFlF/jhjzTY3kqbXVQbBxmrWzQr0LXcbDveHI56c6rnzDsSvJubEYF
 dbgk25c1CBybPqz0gnP/e32E0p51wSu8Subp0P0qYUvpWWPRNHuksogtQ5xeYtPiz3jqOAZMF
 Hx2o8Zx3fgZ2AVVqv0330W56fbn0XA8XTBqzyqgL5CsKCNlJ50fPFZz06DGl2w8BU025Dy6Z+
 UCSnRmoIcrXju0HR6/ONzv7CjuKKWBk3fE6xHivEB+PC9UMaFWwQgCo+W6N3OLiZqNtBYg2J6
 J2KIoGz6jRUXSqy0F753v/RL3l9kP/ycOr+jpoe3fblKv/DAMv0Q5Vc2/zvDpVeSSSYaIB5Uu
 j90YEMT2gVtd99JW8PhNw6kOMF7Rpr/vRSavKVeHr/8LIvQoEKe1aedhnRR9tKEp8H3te630A
 oLOgME3tvOr4nGXuwl9Z2JEihEHpmE1Rkj0aOZ0NKTTarNC8gzbS3mWDpuV6bk2/bQyxaMSTi
 c/9XCuIZwzrVyqwLm5bnBGYeiA9504x4om1R9bY7DdXlXcqqHuX4a81GAxNq7ZLIocWWAq/DT
 FC0KdNuV+k3KwRbw57iUmtALRd4uAGsKZv8x2M573JF2tN1cGxf+sajIsDuWI+
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JbstRHQ3Msj7o4to1SiLc1HaYkjRFUGdF
Content-Type: multipart/mixed; boundary="GlN2XnQ4GUF8P82EWDAMbHTG8AiBQHV8n";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Carlos Medrano <crlsmedrano99@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <faa2ab00-3673-870e-9867-617c4d9733a2@gmx.com>
Subject: Re: Subvolume ID 5 Showing Deleted
References: <020801d4c71d$eb30cd10$c1926730$@gmail.com>
In-Reply-To: <020801d4c71d$eb30cd10$c1926730$@gmail.com>

--GlN2XnQ4GUF8P82EWDAMbHTG8AiBQHV8n
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/18 =E4=B8=8A=E5=8D=888:07, Carlos Medrano wrote:
> Greetings Mailing List,
>=20
> Is it normal for btrfs subvolume list -d to show id 5 as deleted? E.g.
>=20
> [crlsmdrn@server001 ~]$ sudo btrfs subvol list -d /
> ID 5 gen 707098 top level 0 path DELETED

This is fixed by commit f4a82d9e6754 ("btrfs-progs: subvol list: don't
list FS_TREE as deleted").
It's included in v4.14.

Considering you're using RHEL7 or its variant, it may be possible that
the distro is not providing latest btrfs-progs. You may need to compile
btrfs-progs from source or grab btrfs-progs rpm from other repos.

Thanks,
Qu



--GlN2XnQ4GUF8P82EWDAMbHTG8AiBQHV8n--

--JbstRHQ3Msj7o4to1SiLc1HaYkjRFUGdF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxqEYoACgkQwj2R86El
/qhaogf/dTKTBkgOsB4fZ7W9pemlExhU3omOPxsvMzsjR7rbOhlcq+HvlZEL7+Mf
agPQn0lRE1I0TTYc/E+tXAKK0maLaJ6YlfdKqx6QajqFfnqNbm4x8pij96jV607O
GSvOFGAvanrlM/Ts0roQS91c+N8xXQv5ttWfj7Q63tzhYEFJvo00pCAZAyyw27/q
8AAYxIew5iMV5KWSLoNVb6VWnaCLjLBUu770JlKdj2Lwqti1535BNF3D+bC8Vz5S
bOrI7gn1XfBo8osE5sNOCwR8bUnIrrxdVgT3Jc05BHCYGHhgXVNf4VHO5S92wrAE
L5jK46aMPcqV8hAB+xZJUAkWAFKwUg==
=Voxd
-----END PGP SIGNATURE-----

--JbstRHQ3Msj7o4to1SiLc1HaYkjRFUGdF--
