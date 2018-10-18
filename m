Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87568ECDE42
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 00:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DFD22145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 00:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DFD22145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbeJRIzy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 04:55:54 -0400
Received: from mout.gmx.net ([212.227.17.22]:34857 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbeJRIzy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 04:55:54 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LjquD-1ffWkb1Sjx-00bqNJ; Thu, 18
 Oct 2018 02:57:29 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LjquD-1ffWkb1Sjx-00bqNJ; Thu, 18
 Oct 2018 02:57:29 +0200
Subject: Re: Conversion to btrfs raid1 profile on added ext device renders
 some systems unable to boot into converted rootfs
To:     Tony Prokott <tprokott@zoho.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
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
Message-ID: <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
Date:   Thu, 18 Oct 2018 08:57:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WF1D33S5hriQ9z0yCsEO3jMT0aDALlxQr"
X-Provags-ID: V03:K1:gqOAxLprvja7aNGKDd5ToSFsv3rfbY4cSelvK2xRImfHgPTqZYa
 g+zZUjg+OyRC3Rsyp74fWzjGqN+dEoOucVyl+yyghiJQv9D8ZTDNwU8LffX3blJw0xW3/SL
 qPdPl/LzS5L6Pz4XSkDiTynN4Vpm6INMUI1U4TqD2JqDZWaAtTQBSqA2ameSSC2zAjtLB2h
 Whc8LEGHx+NpYRaAlyAzQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:lJIDWs3bYTM=:sm+Mjzhgvc2UEt64gWjKv7
 Gk1AMPg8aQDbF2Tgz6+hnjp80HoXlzQ4WXyz3Q+HcX/M6HKq5aJSKJArN4eUT37IP3TXzP230
 R7huZTe6+5y5KYV9+98pQTRqUOzy7tKLC3CurU1HxIJwDGfwrHm3pEhf8XGqfyVY8xIx4R6y/
 JeTmZcXmTPSjz24IgT51P9zcAeAcmoFo+H/zSeOVbBUF8ZQCUN6T+cjG39u5s3x2MyaUW0fDp
 uG5iJRv4j0O7Eja8gQy7b8yjDaaZSr8siBLqB4Hfqvq2EPa3BC8tGcbwTQJkdRkSlDMbcBC4i
 EuBcN/3GcvBIAvKGQ1KLEThFvfPC+nxZSkfpOclglzqR4h9Jr3WTD4OXq74AJjcR0MuxJ7Yx8
 vJKdHyIcInM8EfqYHn3XwpJxMA/SDrOpeZh9yKFuj8INrzMuZoJeklP+NHhZpZzKEKgaGdXdq
 u1Wb3brM8hbF6/F/ijGdMvmFcgsMTFZJhv3m8advTE5ESLVyWz0PCK4pMaRPgnsNA2fTaTkRT
 RS2GHLmf7Hvh7RFajTGo0iVIVh840rvGQTrKMHatxh8YdxhK3DMxelV6MofMeJXgCTOW3XLjn
 HYBd3IfuA18UIYAWBp/AgJKQEeUCiBK+XnhdBJOFQH9jJa89OLSh/heOwK/7gytNccMGPVFy0
 razK8kZCC8us4FbP2YTahE1lxQ07AFb4iu65d1Lbn69Yq8zvlF5KCJQORQjBtnjfqtHf8zAJY
 Ik2lSeo6fW0kmn324nMnbin8uVlZAepBEZgTBOPc6xUgMxXM/2c04vE+dVzo/TpT9OLh/hosD
 NKnhWt7lBjVEdpEH/LJeM2N5HjuSw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WF1D33S5hriQ9z0yCsEO3jMT0aDALlxQr
Content-Type: multipart/mixed; boundary="N22Ovm1vlm1QOi2PwureChbO4TgIUrs34";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tony Prokott <tprokott@zoho.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
Subject: Re: Conversion to btrfs raid1 profile on added ext device renders
 some systems unable to boot into converted rootfs
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
In-Reply-To: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>

--N22Ovm1vlm1QOi2PwureChbO4TgIUrs34
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/18 =E4=B8=8A=E5=8D=8812:38, Tony Prokott wrote:
> Good day. My technical trouble seems to be beyond the scope of active h=
elpers on debian's irc support channel. Reasonable supposition that it's =
quite particular to the development stage of btrfs infrastructure on 4.17=
=2Exxx backport kernels and userland tools available on debian 9.5 stretc=
h as well as buster, the testing suite to be released in the next several=
 months as 10.0 stable.=20
>=20
>  > / # uname -a; lsb_release -a
>  > Linux localhost 4.17.0-0.bpo.3-amd64 #1 SMP Debian 4.17.17-1~bpo9+1 =
(2018-08-27) x86_64 GNU/Linux
>  > Distributor ID: LinuxMint
>  > Description: LMDE 3 Cindy
>  > Release: 3
>  > Codename: cindy
>  >=20
>  > / # btrfs --version
>  > btrfs-progs v4.7.3
>  >=20
>  > / # btrfs fi sh
>  > Label: 'sys'  uuid: [snip]
>  > Total devices 2 FS bytes used 24.07GiB
>  > devid    1 size 401.59GiB used 26.03GiB path /dev/sda2
>  > devid    2 size 401.76GiB used 26.03GiB path /dev/sdc1
>  >=20
>  > / # btrfs fi df /
>  > Data, RAID1: total=3D24.00GiB, used=3D23.27GiB
>  > System, RAID1: total=3D32.00MiB, used=3D16.00KiB
>  > Metadata, RAID1: total=3D2.00GiB, used=3D820.00MiB
>  > GlobalReserve, single: total=3D69.17MiB, used=3D0.00B
>  >=20
>  > / # btrfs su li -ta /
>  > ID	gen	top level	path
>  > --	---	---------	----
>  > 260	115103	5		<FS_TREE>/d9
>  > 261	115103	5		<FS_TREE>/d10
>  > 262	123876	5		<FS_TREE>/home
>  > 263	115148	261		<FS_TREE>/d10/@
>  > 264	115136	261		<FS_TREE>/d10/@home
>  > 443	123874	447		<FS_TREE>/md3/@
>  > 444	123876	447		<FS_TREE>/md3/@home
>  > 447	115103	5		<FS_TREE>/md3
>  > 451	115144	260		<FS_TREE>/d9/@
>  > 452	115136	260		<FS_TREE>/d9/@home
>=20
> Providing no dmesg content so far, as it doesn't bear on the kind of di=
fficulty in question. My system requires expert help now to restore boota=
bility to 2 of its OS installations; it has a btrfs root file system in s=
ubvolumes for stretch, buster, and LMDE3(cindy) which derives directly fr=
om stretch and so has most core elements if not cfg defaults in common; e=
ven kernel versions are alike, besides buster. subvolid=3D262 is a  /home=
 fs shared among  linux distros; 451, 263, and 443 are rootfs for stretch=
, buster and cindy respectively.
>=20
> All 3 installations had been booting and running fine when data block g=
roup profile was "single" on an internal sata HDD /dev/sda2; then an exte=
rnal usb3 drive enclosure's sata HDD partition /dev/sdc1, also of size ~0=
=2E4TiB, was added and balanced as btrfs "raid1"; raid conversion did not=
 damage subvolume content or filesystem integrity afaict, but rather rend=
ered stretch and buster unbootable (more to follow), whereas cindy carrie=
d on without hiccup.
>=20
> At first it seemed as though the initrd's might be missing a module or =
so, to allow access to external drives -- i.e. grub starts the unbootable=
 kernel/initrd but drops to busybox prompt right away without starting ex=
ternal drives, referring to allegedly "missing" btrfs device's UUID_SUB.
>=20
> But after chrooting to update-initramfs and cataloging resulting image =
content, usb_storage and uas were present under /lib/modules/xxx already,=
 and failing systems still just busybox without a real rootfs rather than=
 launch systemd; even tried kernel option "rootwait" which had no effect =
on access to ext storage; udev still seems not to have noticed the ext dr=
ives once busybox had control.

Still looks like a initramfs problem other than btrfs problem.

In the busybox environment, have you tried listing /dev to see if that
external device is found?

>=20
> I could list all initrd modules present in cindy & absent for others, b=
ut need better knowledge than my reasonable guesses of what's required to=
 make btrfs volume companion devices cooperate at boot time, as initrd tr=
ansitions to steady state rootfs.

Since you have a busybox environment, have you checked if "btrfs"
command lives in the initramfs?

IIRC at least you need the following things/abilities to boot:

1) usb and sata drivers
   Means you could see both devices in the busybox environment under
   /dev

2) "Btrfs" command
   Mostly for scan

Then you could try the following commands under busybox environment:

# btrfs device scan
# mount <device> <some temporary mount point>

If it works, it may mean you're missing "btrfs device scan" during boot
so kernel can't see all RAID1 disks for btrfs and failed to boot.

Please refer to your distribution initramfs creation tool to see how to
add that scan. (Some distro has special hook for btrfs to handle such cas=
e).

Thanks,
Qu

>=20
> What would be a more practical diagnostic? Could stretch & buster initr=
d's somehow be failing to do a btrfs device scan at the proper moment? No=
t so interested in giving up on btrfs software raid so early in the game.=

>=20
> thanks in advance-
> TP [not a list subscriber]
>=20
>=20


--N22Ovm1vlm1QOi2PwureChbO4TgIUrs34--

--WF1D33S5hriQ9z0yCsEO3jMT0aDALlxQr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvH2nUACgkQwj2R86El
/qjFjAgAmt6XsLOBx53NVnRiwBEb+Cp8ucu3mIZORJKtYmcfJsDXYIXlu/y9p3bw
Bq3YggZudM8tB8O2IBotrKZ1SywJafgyRhrqpnoeQ7gInu4uEEYfli0hr9sRMUIC
nN2Y5qhku6eVL5JFy+EjljXHmKVVofg8bE1InkuJ2bDzDV6uHWFCOQcElozVdVdb
kE2NEW1toi+u0ht1sNvFmW9evJcON8vWRnJRYizFZnsTzpsynLZd06u361hvZHfP
UR7w/QzKvwr062u5Qm27StqqKrBbwkGtYiea9oxaY/S9YPQetcnV1yTOdOywmupo
Q52WL9shAFrTU6lxrUNLuGVnSnK5Pw==
=NKjt
-----END PGP SIGNATURE-----

--WF1D33S5hriQ9z0yCsEO3jMT0aDALlxQr--
