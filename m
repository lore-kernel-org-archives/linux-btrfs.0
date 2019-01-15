Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46117C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 169CB20656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfAOLtE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:49:04 -0500
Received: from mout.gmx.net ([212.227.15.18]:35789 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbfAOLtE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 06:49:04 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MWkep-1glpGS2keZ-00Xrob; Tue, 15
 Jan 2019 12:49:00 +0100
Subject: Re: BTRFS critical corrupt leaf bad key order
To:     Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
References: <87d0oyw46b.fsf@lausen.nl>
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
Message-ID: <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
Date:   Tue, 15 Jan 2019 19:48:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <87d0oyw46b.fsf@lausen.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d9mi7IefCmjUWCwUP2pOqQneYmAVlOjTr"
X-Provags-ID: V03:K1:lHrDSj3q5kibZyVXNAZzCxvfb4Kb7zWBrPTP3BNsYkgUfEx/zpu
 EWgcglc7cTaVGw9SKsrHMMban7UAjGMkYr87RMNKpvkOEhzXEHBY3Fd/o0GEmlj45sn087k
 LYACmunhDcfReS+5RS3PWIpLHEvX6qv0UvAWT7IVwdA7UyyTnnXCBa6DycXm+VYZlKueDyF
 foQeEhCY2RmKp6byult1A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:frElLjJQyys=:h1Ozrf+kiVk/suvducdT83
 UORhat7OsU2YpFxKz46nSKHTog/NjW23HfYOvinXmoI5ZAtsmQ8gExNjk9mJQAlrJRn8HL9Fv
 TTzslGSoiv1/19zvHB0zZim9+AUuC645xnAaDzkwgFZ0TB4n11UC9PG1Gol2bixIOPAJuwLxA
 3wngQiQcHUllsmn7fQNBasAUxhXj51Zdm5t5hP0qKWuBH/9fpq08F5KZVjnOn4Tc5fTc6KZCo
 zEZyu9JUQ7buPHlQPxLCtwnmUVL8gw851f2WMhZguvk22GmqmTiyTCWNoSjIoO1f4sSdLOkan
 EzRf0k7M0WsIqpueQLguZP+UOZvl11RQQDsTa9yvghdooXk+TGXRTTVZlwM0DsAhOcB8cCld5
 KoqeVR47pxv/LfGxrV5rnRi4QPGebt9FJcPaFEAOnPWKj8umadfpXVUUp0f97FhaOoT1zsD0L
 US0Iy9zU73ZVgj+W6qGaNC7fB+Lfrwf1qAxwdfoGAt767au45VAP9aPxWOVNadwYjHQhxa5AH
 m2Pa/qbmcu2Kv1lhPmhcjMy8DUKX+bBvCUoCDHa8ImpXL/Wy0FaEvCFPMSOVCrlXvpavaOcwQ
 5l+CJA0IOhsl9c2aIhomvA3oYNCkLLj+4DnXvboY39lirh+p9jK076Gl+6xP/jnpYoslzQ5Zt
 mOAdbowBK8YwiosHkq7zSIPLj2pQWzSx96FhDyfd3AhytEYTk0PWlZnfYN6zzZ0E7UKS1NZ6L
 GujleiC76TFaghyfeqeBcDjVrZ7A3zFbv6tLcMF6DMg6fdbmxJIp9+JIb0G+WeHuFHpb1dp85
 BN2UaWbuslc3jyeBiygB1F3Ac0hpYYPkj3ddpWY/coZTP3E6EZx0ZxtybPzvb+5iesEXJTifH
 MC12ld7aUGHAVsLFfzPXovSklh6SPd4o0WxWGPyMDyfeqlOYyVIesiCEpvtiu9
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d9mi7IefCmjUWCwUP2pOqQneYmAVlOjTr
Content-Type: multipart/mixed; boundary="dBBMYrkgIwHqrwVytYPHFa4H2YNGtIyTf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
Message-ID: <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
Subject: Re: BTRFS critical corrupt leaf bad key order
References: <87d0oyw46b.fsf@lausen.nl>
In-Reply-To: <87d0oyw46b.fsf@lausen.nl>

--dBBMYrkgIwHqrwVytYPHFa4H2YNGtIyTf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8B=E5=8D=887:28, Leonard Lausen wrote:
> Hi everyone,
>=20
> I just found my btrfs filesystem to be remounted read-only with the
> following in my journalctl [1]:
>=20
>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS critical (device dm-2): c=
orrupt leaf: root=3D2 block=3D1350630375424 slot=3D68, bad key order, pre=
v (10510212874240 169 0) current (1714119868416 169 0)

Tree-checker catches the corrupted tree block, again and again.

>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS: error (device dm-2) in _=
_btrfs_free_extent:6831: errno=3D-5 IO failure
>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS info (device dm-2): force=
d readonly
>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS: error (device dm-2) in b=
trfs_run_delayed_refs:2978: errno=3D-5 IO failure
>   Jan 15 08:56:40 leonard-xps13 kernel: BTRFS info (device dm-2): delay=
ed_refs has NO entry
>=20
> Following Qu Wenruo's comment from 4th Sep 2018, I have generated the
> following tree-dumps:
>=20
>   sudo btrfs inspect dump-tree -t root /dev/mapper/vg1-root > /tmp/btrf=
sdumproot
>   sudo btrfs inspect dump-tree -b 1350630375424 /dev/mapper/vg1-root > =
/tmp/btrfsdump1350630375424
>=20
> The root dump is at https://termbin.com/lz0l and the block dump at
> https://termbin.com/oev5 . The number 1350630375424 does not occur in
> the root dump. The root dump has 16715 lines, the block dump only 645.

Super nice move, it shows the corruption and the cause.

	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33
	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 42
	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33

See the key objectid of key 67 is way larger than item 66/68.

And furthermore, it indeed looks like a bit rot:
0x18f19810000 (1714119835648)
0x98f19814000 (10510212874240)
0x18f19818000 (1714119868416)

See one bit got flipped.

I don't know it's corrupted in memory or on the SSD, although I tend to
believe it's caused by memory bit flip.
But anyway, it can be fixed by patching the corrupted leaf manually.

I'm working on the fix.
Please make sure there is no write into the fs (just in case, since the
fs should be RO).

And prepare a LiveUSB on which you could compile btrfs-progs (needs some
dependency).

It shouldn't take me too long time crafting the fix.

Thanks,
Qu


>=20
> Would this imply that the corrupt tree block was not yet commited? What=

> actions do you recommend to take next?
>=20
> My kernel version is 4.20.2. I am writing this email via ssh from the
> affected system on some working server. Besides the error message above=

> and the fact that the filesystem is readonly, I have not yet found any
> issues on the affected system. Note that the error was occuring under
> high system load while compiling a bunch of software on a tmpfs (and th=
e
> compilation was successful, but installation failed in the end due to
> trying to copy to the by then read-only btrfs root filessytem).
>=20
> Does this suggest a hardware issue?
>=20
> Thank you for your help and taking the time to read this.
>=20
> Best regards
> Leonard
>=20
> [1]: For unknown reason, the dmesg output does not reach back to the
> time of the error, but only contains log messages from after the
> filesystem was mounted ro.
>=20


--dBBMYrkgIwHqrwVytYPHFa4H2YNGtIyTf--

--d9mi7IefCmjUWCwUP2pOqQneYmAVlOjTr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw9yJ8ACgkQwj2R86El
/qhihgf+OZ0X5HJVm47nItlxIKff9RsZ8wlbKUkhoPiJSJuuo+NPYVjtrhhOKku4
9zUQhel8VZydKYod24I5CPiU1VS/orJ3aZ3ysjw6CodJluIOsex4JLNphaWO+D8C
A3YKXUt9nfU8KNWuhCKz0H8cgmjGXZfRm17xlPjYbkbZ4IR/2VSDAlOowtZ9W+oE
gntWbj0M2VVmPU/dNzxAKoUSpDr/WojejNPF6G+u3wjrai5mM64schjtcVdz791X
WA+9OJy5sCDcsrYsILXu5asJeIFjh8mbWYkUjeaSYJPDAazBTMFSkCFHqGDWUoKN
BGCjq6ozHtmrOGCPYQwHuD0vhmWC2g==
=bsSL
-----END PGP SIGNATURE-----

--d9mi7IefCmjUWCwUP2pOqQneYmAVlOjTr--
