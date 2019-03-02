Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DECC43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 11:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE71A20449
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 11:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfCBLx7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Mar 2019 06:53:59 -0500
Received: from mout.gmx.net ([212.227.17.20]:55981 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbfCBLx7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 2 Mar 2019 06:53:59 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MJWAZ-1gxZAu21nv-0035vk; Sat, 02
 Mar 2019 12:53:56 +0100
Subject: Re: Getting qgroup reports in user space (without enabling qroup)?
To:     Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <8a91a9b3-8b4c-2df4-1c69-9e260816a2ca@gmail.com>
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
Message-ID: <c5a1f71f-a2b4-7ac2-1cb9-7787d9f980a0@gmx.com>
Date:   Sat, 2 Mar 2019 19:53:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <8a91a9b3-8b4c-2df4-1c69-9e260816a2ca@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TzTxxGZveaNuX0rAzBtE5qUN5299T5XMk"
X-Provags-ID: V03:K1:AmkwsWRJmZYm1LNhVLh4/48fJC1znnccwqwqQlgfjKvkts6XoHk
 6NbL2bYk603rbvXOqZSstNVEfikaMrBewrdyB/sdh8SNRJ3Xz/dDFVATZEvt1a8GHNdOj4j
 rIF5oRbkuRWhiZXq/KY9mCFZc0ctujahgq/Wj7uXxsvLyQXiIn8ZR9EPT1oSLfW/OsADEb/
 uwShifeCC7Jtqg1LMEe5A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:dJf1FZhIQ2M=:lmRepADvKu4AlKQJ0zSnuS
 WyRgbxaNW4zRs0yhN7EbMDIrntv9o5W4WZunFcF3DcqyGMcC9F4HCDUMs8K3Lfmj+KuGuFyw+
 pJpDuk3JQk0B8WceLzcQ/zgEK6EmrbLOiQHAymCqDnyYtoFX5c+75Br9cdnqMtF7IXeT0yyZQ
 LzKrB9DtCugh9HyjVOWgrtgAHFpvTcutl/Lf+b5Vw6sLBVmgjT206iMVicMXRBXd4iPnT/te5
 q09zBhiBYrjiRTdXefkleMoyaMgcUj8z8R5NaZAahc/XLUH/eBTKx9J9AyisAstG7Lcwejvhg
 Wte62HwphNtY3sEpxbYAx05dSqak5e4Fr4OPbyyKvf63HLJMhPjBRzfD+TxNLaEnvaZWmVyNV
 JeMdr6rdw4Ju/nnZHxl/1BixK5rJfnRufwFYCqkmbl2Ng9lBbetCsqdPp9spwHYK35+PN00Xc
 vBelEEMt1v/q/YUUMhw1av2p/MKqpvd7p8oEum554zP5xO6q7NkUVSWUEfxR/aMP68xnD1e/B
 KSwTMq5wa4xY1/XcA3FHSywUOA0odRQ9nB6aaNEotSuV2cnBesd1lVjri4gF74Vf/oVdzBBQs
 lkPNBGYiEmLnqxjUElw1iYIbyh71n8Fqr3RkIHn5ntyDui4B8lLpzJyVAkGXHbB2vcGEpNfA5
 SWUnNVow4ece7r5JvdqP8IB3nW/6OM3z9Oydq0HBFduWbuVq0Cxuu3ON3qbvgS8CgVyr/HFwz
 n2adFA5DdB9WG98nUsLoGpN9nstjiPmZFqccK1TNU8tYkOq2fqk8ahNdtgUi9rlVhk6PXRV+/
 566G5Yv2ivVakHfolRhoXOBSgN0eyp4EPUCRzkIfZIGBhfnFJtNq1ymKf9Sdv3oayVxJWubIL
 xWHUUaQkuaj3FUwB1GSav2BAwBjjyZPFGmohJe4EqXMBgkZ67XwQxMFJq+ZHpQ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TzTxxGZveaNuX0rAzBtE5qUN5299T5XMk
Content-Type: multipart/mixed; boundary="s2lml9TkM470BmbBrZ2GfOcMXagkqgBRu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <c5a1f71f-a2b4-7ac2-1cb9-7787d9f980a0@gmx.com>
Subject: Re: Getting qgroup reports in user space (without enabling qroup)?
References: <8a91a9b3-8b4c-2df4-1c69-9e260816a2ca@gmail.com>
In-Reply-To: <8a91a9b3-8b4c-2df4-1c69-9e260816a2ca@gmail.com>

--s2lml9TkM470BmbBrZ2GfOcMXagkqgBRu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/2 =E4=B8=8B=E5=8D=882:23, Andrei Borzenkov wrote:
> Is there any user-space tool that can produce report similar to "btrfs
> qgroup show" with multi-level qgroups? To clarify what I mean - here is=

> "btrfs qgroup show" output from openSUSE with enabled snapper.
>=20
> qgroupid         rfer         excl parent
> --------         ----         ---- ------
> ...
> 0/259         6.17GiB    262.43MiB ---
> ...
> 0/702         6.03GiB      1.30GiB 1/0
> 0/718         6.04GiB     89.88MiB 1/0
> 0/720         6.52GiB     87.28MiB 1/0
> 0/724         6.10GiB     29.16MiB 1/0
> 0/727         6.78GiB    217.02MiB 1/0
> 0/729         6.24GiB     39.25MiB 1/0
> 0/731         6.65GiB     72.67MiB 1/0
> 0/732         6.24GiB    212.18MiB 1/0
> 0/741         6.35GiB    778.79MiB 1/0
> 0/742         6.58GiB     74.09MiB 1/0
> 1/0          20.33GiB     14.42GiB ---
> ...
>=20
> Without qgroups there is really no way to find out how much space
> snapshots are taking. "btrfs fi du" just shows equivalent of "rfer" and=

> "excl" for each subvolume, but there is no way you can compute the
> values shown for 1/0 qgroup from individual numbers.
>=20
> I do not think "btrfs fi du" can do it as it only knows whether extent
> is shared or not, it cannot know whether extent is shared between
> specific subvolumes.

No, there is really no good way to do the same work of qgroup.

>=20
> Is something like this even possible in user space without qgroups? It
> is well known that qgroups are frowned upon and common advice is to
> disable them as soon as someone reports performance issues.

There are incoming improvements for qgroup, especially solves the
performance for qgroup + balance, the biggest performance pitfall.
The target is v5.1 or v5.2.

And there is planned enhancement to imoprove the backref walk code, to
improve the overall performance of qgroup.

So feel free to try out qgroup in v5.2.

Thanks,
Qu


--s2lml9TkM470BmbBrZ2GfOcMXagkqgBRu--

--TzTxxGZveaNuX0rAzBtE5qUN5299T5XMk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx6bs8ACgkQwj2R86El
/qgeUgf+JcfN5tkWXoC5ENp4s1yp6zzaHPB3oWS7pN7pWXgjEI3ojes4CswgPcS2
784C4+edJJXX8PZPwyxXTEDjLXLlg62iSstFKWiedoEjs0q4ptouOZgGdtqK+HTr
f4x/V6usuYV+dljjOJCCafav/0aI21ZsebcQFfsD/l9boSP4kXsMtmpJBQU7TYjm
zf37ltMjIymukMiWbbVQyD+URwpIL2wiAFMHbiCOfFfKGkOpEdoHjFK5s5Jym0tJ
CLijKtwgxFoFQDbvIQqNOrXfpLwKyUuy3RT3T8M49mHFCojOZ4SX35pGMmN3Hnsq
uNKli/ey7aDPfVe2LBMy789NZPe+Kw==
=9hnn
-----END PGP SIGNATURE-----

--TzTxxGZveaNuX0rAzBtE5qUN5299T5XMk--
