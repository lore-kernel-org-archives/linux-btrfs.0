Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F74C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 12:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D09320659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 12:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfANMfP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 07:35:15 -0500
Received: from mout.gmx.net ([212.227.15.18]:54801 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbfANMfO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 07:35:14 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lxxrw-1hLVRL2i9c-015Hyb; Mon, 14
 Jan 2019 13:35:05 +0100
Subject: Re: [REGRESSION] Super slow balance in v5.0-rc1
To:     Tomasz Chmielewski <tch@virtall.com>, linux-btrfs@vger.kernel.org
References: <7c6234aaeaf813400da5ff1e68f8c898@virtall.com>
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
Message-ID: <2c1782e8-b68a-4992-84e8-adeef34ca688@gmx.com>
Date:   Mon, 14 Jan 2019 20:34:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7c6234aaeaf813400da5ff1e68f8c898@virtall.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RECBDimD5F1A7iiX8P1jrCI6Q7afkjDKE"
X-Provags-ID: V03:K1:LaOQXS1NvXHgqT7Lw4B6dXJg5YuUeEzuV2rOOFKhIAnUpFAzcUX
 XRk6SQR7nM3kIO1yT4WoBVbmw/MDFSP/2zz9mqBXDxVOJ/lhqMIu4qPTwdYBcv1eQ5n4XAZ
 Wsqb3VBWe4QVS/arLG8SxuQVVYH0QSGsBIU8YduD3MT6F0SjfMhHpIY7gO0zO4rLRaF4VBv
 UbN82Ev7DdXAOog3pByIw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yqBpImYJi3s=:qIj7ZEIUnuxvQx26mkZisy
 VG9P+ubJdCpSXHRnhz1cSRvE8oHo7WnSGR2mFKewaIEwF8mRlJZDjD6qDJTLc+xNEcVj4eNPl
 795k76+oIRQAR+b/a/x0ErcGZvcrrHn2G58k3YNtQhZKbX9I+ZWrEkQQxljGYI2jUNawv1PM0
 B92nd5jDm5sANKmN1Yboa/u1xxYzr5lCJLyqVCabHam+xhd4Ir2nbpr0uH+pGXRUnr3NKlOTx
 HtA/qJxro5SqwAkhplQPKI/y7wjjkrzwiP1M/EPEGkjCFR/zVQbZziRX42VXWXyNV77AND8KG
 bVkDlWKwPP8auDDrNYwWaSvui/l5hn0H97EyabSA7UnasMBnp2kxonmSTJVoeCF8FP2GFfmTG
 9VsyEor62EYI8251rxq+tBGhmAY/OKTT04bf9JauKU3axQ6ZpYvxNjwkSUzQH7Nu+SHh7tkr+
 qePUDqWqjB0c891O6cLr4O453y/JSZiw0GNAi82J157JEkTruEmFNg7SzmHrD4dlScjV+fFJ6
 oQiOx60RdAwcnOvC8gjr2qW2L4CMPMkFOlE3umXHOBaPpYdkiSaMGfyv3kanewlRUO48YZ51b
 AgqLejXx2565XWgdKZkm3K7so+ebzGZUoZVKPKvyvqo0FQeiR5g4mB86D80jvnwyzYU6FWT0D
 1ukBFYOORfAaKcrf+kRgOdOkAS+VCE5mFFzsaRogYaFRYa2xeicnOruQ8Kg6NBL8Ly53iGPfP
 nYcemRdFYWNBPOh/3JdcZz7U3SWb72ygTKb5P9YzyNvGWOI1i9DxFXvwSTdaHp2Xsfxd4d/om
 MMdkVTUywhIv8CY/C023JassX0j7HgmJWMquy+WrpuDtp5QLia9A8L1VHezFbKQGCH4RsL+e5
 z80Y2HGNOuVUQVIZDSw7SHjIE8o45I3BYW4X+0a4Pyyf8UlFBWj9HYa8PHm1yE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RECBDimD5F1A7iiX8P1jrCI6Q7afkjDKE
Content-Type: multipart/mixed; boundary="hbQCcrVcl9kfsmlyTwbZYJ8boHuv65b39";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Chmielewski <tch@virtall.com>, linux-btrfs@vger.kernel.org
Message-ID: <2c1782e8-b68a-4992-84e8-adeef34ca688@gmx.com>
Subject: Re: [REGRESSION] Super slow balance in v5.0-rc1
References: <7c6234aaeaf813400da5ff1e68f8c898@virtall.com>
In-Reply-To: <7c6234aaeaf813400da5ff1e68f8c898@virtall.com>

--hbQCcrVcl9kfsmlyTwbZYJ8boHuv65b39
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/14 =E4=B8=8B=E5=8D=887:47, Tomasz Chmielewski wrote:
>> When rebasing my qgroup + balance optimization patches, I found one ve=
ry
>> obvious performance regression for balance.
>>
>> For normal 4G subvolume, 16 snapshots, balance workload, v4.20 kernel
>> only takes 3s to relocate a metadata block group, while for v5.0-rc1, =
I
>> don't really know how it will take as it hasn't finished yet.
>=20
> Are you sure it's v5.0-rc1 regression, not earlier?

At least for what I'm describing, yes. v5.0-rc1 introduced bug, and
already pinned down.

So I'm afraid you're hitting another different bug.

>=20
> I'm trying to do a metadata-only balance from RAID-5 to RAID-1, with
> 4.19.8.
>=20
> It was going relatively "normal", until it got stuck and showing no
> progress.
>=20
> I've canceled the balance, upgraded to 4.20, started the balance again.=
> For straight 11 days, it rewrote terabytes of data on the disks, with n=
o
> progress at all.> Also, 4.19.8 had a balance interrupted because of "ou=
t
> of space", despite we have terabytes free.
>=20
> Metadata RAID-5 usage stays at 4.12GiB for the past 11 days (and a few
> more days with 4.19.8).

Are you using qgroup? Which is another huge cause of slow balance.

Thanks,
Qu

>=20
>=20
>=20
> # btrfs fi usage /data
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> Overall:
> =C2=A0=C2=A0=C2=A0 Device size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 14.47TiB
> =C2=A0=C2=A0=C2=A0 Device allocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 112.06GiB
> =C2=A0=C2=A0=C2=A0 Device unallocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 14.36TiB
> =C2=A0=C2=A0=C2=A0 Device missing:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B
> =C2=A0=C2=A0=C2=A0 Used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 107.93GiB
> =C2=A0=C2=A0=C2=A0 Free (estimated):=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 (min: 8.00EiB)
> =C2=A0=C2=A0=C2=A0 Data ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0.00
> =C2=A0=C2=A0=C2=A0 Metadata ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.6=
4
> =C2=A0=C2=A0=C2=A0 Global reserve:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512.00MiB=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 (used: 1.86MiB)
>=20
> Data,RAID5: Size:5.28TiB, Used:3.04TiB
> =C2=A0=C2=A0 /dev/sda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.76TiB
> =C2=A0=C2=A0 /dev/sdb5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.76TiB
> =C2=A0=C2=A0 /dev/sdc5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.76TiB
> =C2=A0=C2=A0 /dev/sdd5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.76TiB
>=20
> Metadata,RAID1: Size:56.00GiB, Used:53.97GiB
> =C2=A0=C2=A0 /dev/sda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29.00GiB
> =C2=A0=C2=A0 /dev/sdb5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 27.00GiB
> =C2=A0=C2=A0 /dev/sdc5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 27.00GiB
> =C2=A0=C2=A0 /dev/sdd5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29.00GiB
>=20
> Metadata,RAID5: Size:12.38GiB, Used:11.13GiB
> =C2=A0=C2=A0 /dev/sda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.12GiB
> =C2=A0=C2=A0 /dev/sdb5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.12GiB
> =C2=A0=C2=A0 /dev/sdc5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.12GiB
> =C2=A0=C2=A0 /dev/sdd5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.12GiB
>=20
> System,RAID1: Size:32.00MiB, Used:416.00KiB
> =C2=A0=C2=A0 /dev/sdb5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32.00MiB
> =C2=A0=C2=A0 /dev/sdc5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32.00MiB
>=20
> Unallocated:
> =C2=A0=C2=A0 /dev/sda5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.83TiB
> =C2=A0=C2=A0 /dev/sdb5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.83TiB
> =C2=A0=C2=A0 /dev/sdc5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.83TiB
> =C2=A0=C2=A0 /dev/sdd5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.83TiB
>=20
>=20
> # btrfs balance status /data
> Balance on '/data' is running
> 13 out of about 64 chunks balanced (15 considered),=C2=A0 80% left


--hbQCcrVcl9kfsmlyTwbZYJ8boHuv65b39--

--RECBDimD5F1A7iiX8P1jrCI6Q7afkjDKE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw8gfMACgkQwj2R86El
/qhbJQf9Ghc+mKGEIxo/5Vu8p4Lid8RjBH3VxL7T37WiQnN2/L3bbmHJUjkgm6Uh
Mt3lna7pG0kcODgZcbRzc+ssb8VCmTIwsTL7A5T7Ht2YKd6aRgnBEHWCrDU6Zfwl
FZ4y69n7I4YdGdozlkO/dnjs7a+TuZUX7e46DgG69k7Gp7JzJPONx87XyRR4up3S
MvSHm00qknKhXEeVSgOhnXJ0k5V6U07pRsEPiJXiWKQzxpzBsododtX2hezzGNTt
OTYjMwvXScIWaIXLaH1GdflKtmcblzg3BnP70YbeLpVkVcxdmCssPKFMsOdcZdLo
M0Hf8fnHMRYd3/WkUm10kKH0KgZiiw==
=/Gkf
-----END PGP SIGNATURE-----

--RECBDimD5F1A7iiX8P1jrCI6Q7afkjDKE--
