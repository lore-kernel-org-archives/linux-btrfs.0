Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EBBC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 326612175B
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="K5VaWlNj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfCTA7E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 20:59:04 -0400
Received: from mout.gmx.net ([212.227.17.22]:32963 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbfCTA7D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 20:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553043517;
        bh=tH7PBP+oIFQo5f3HX7vXy1wn86VCCTCON5PmUpVxWSY=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=K5VaWlNj6J3Ovud9mutnNu1xxvee7N/JLCWAG0GV0QEa1c8rSMbakGG+NJdMp6jJ0
         HM7NMoyazgg6Ze5xBdXaDy3YfJfWJyUyFNKnLMCo9hMRHG51/3dCmzSU2EuUDtRQUG
         x4tPyFAxb+ziOp1G5bGnzw2J5Tp6pWfZABHDVKvs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LwF9u-1gx1fh2QRS-017zr1; Wed, 20
 Mar 2019 01:58:37 +0100
Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices
 total_rw_bytes 64008166047744
To:     Piotr Balwierz <nikt@sucha.eu>,
        "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <13409678.203.1508836811909.JavaMail.gkos@dynomob>
 <bde403d9-c487-d385-deb1-35c898765f7a@gmx.com>
 <14075786.243.1508845404640.JavaMail.gkos@dynomob>
 <b040ab81-b40a-7ace-b493-5e5c539e7231@gmx.com>
 <27675301.364.1508871760291.JavaMail.gkos@dynomob>
 <13f15a18-c659-1cda-e69c-858a50a53401@sucha.eu>
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
Message-ID: <9039b84b-9dc6-f012-9e4c-5e8d19cbcad8@gmx.com>
Date:   Wed, 20 Mar 2019 08:58:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <13f15a18-c659-1cda-e69c-858a50a53401@sucha.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="txtflcefLOZOlZt3rtdr0UlTmYseE9LuF"
X-Provags-ID: V03:K1:CAEj6EPztNG9ww0JrDeWrn3aVj0L6CcGZYpTc2s5Xb9BSyu3LEJ
 N/m4o6C3pAx3zIL/ai3ZVvfC6hXu5pVKWbJ9fPdB65LJGnaqgd/d6DgJo7jp8IBlAFXborl
 5rtWYEaf6TTnsOFHQOzrdFiiVpDCIuvkydGBzflqxKzOFvuOW3BVZHAjf8y0VMhvIs9H+Jd
 TKizIl4tpWyIgCM2a4x7g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nB/HaW+PC6Y=:2V7cmPBP/lu1MXUXn592Gp
 l8rEZCQnHwtzFT0BbezrDaRCA75lZxCVUKV85zTwab96mJpV2R5PVlS5dcpvm3Q+vlSeIx00C
 pHLAF4F3xotGz6wrS218b43kJxUu0pZd+QwESBJDZPMFxnWURxkIyJCwjv/+Q4BIJBdjRhOM/
 YN076ANM2cUv1hYM6CJU9zxCHIeEmQ6rfmjDqDtoFW1Y1NGNhPqz0XaL0PKzjuNIUcuwBC9w2
 k0a/68KIn5o4uSTZ7ph5DhG5T7SUEEUF+POX+DheSfEdRbbtEtxvSskYuB8ni8PAwqacg3vrl
 gs3AjBVgthkoQfDgUkL57hicQn6bdlYkklaQhqx2lILFRMh1P2QAh8RXCj6KhOc9i6HjsoXWn
 wKtJ3Doo3w7eukNxzx42A/WfyVwazAIAG0ylqwaC+jqkvHGweUAWU/uh/qkTTIR9u/tfPke4S
 ZSI4sUNvtQHIog+BLUnuDx+pKqpj/DGmaPWxVmVpYiprKZh25fC7KXBmlT9lIAI99P6PuMiTJ
 16YAWby/Ode0vBiwRj6mSd4sv+n2OZLvV/uHfup9f2qUaCIIWXe41DMHBV8KrLREFTY3F6T6i
 qPIULvTdd9h/iwHtKjX4rYWM63D6HqYb6zd0LEoN/KURtI9CykRt0vZfNjwGNgKm9xF8GJ9Bs
 kxDBCC85skWogAmkIgFTwd1ohgxqlTOcLslgU560MVWQKwVYsJYEwzSAeEsLtw3JClBZ1/zK1
 rVT2HhveSyttkUnt8RjGIjCiFD81AtEsAdfTTrzOV057OH0RuiA8M+Wtol6YpXApB62K69MhU
 /w2GsTkfIPKQIzRZWz9uuV+YFvDAoxpcV9C8ubxhS/VZOmnPNcbkWzBGCBnykqMkoWKPOKBFw
 qoISJ65K0kI5MLxPqLO/hPwsNaQzY+GDcLR43OklnthwvXobJdFwZ6DpXV+px4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--txtflcefLOZOlZt3rtdr0UlTmYseE9LuF
Content-Type: multipart/mixed; boundary="ujzxvVRTSYEvIrX0P0yQiuHG9mtjGsY1A";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Piotr Balwierz <nikt@sucha.eu>,
 "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
 Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9039b84b-9dc6-f012-9e4c-5e8d19cbcad8@gmx.com>
Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices
 total_rw_bytes 64008166047744
References: <13409678.203.1508836811909.JavaMail.gkos@dynomob>
 <bde403d9-c487-d385-deb1-35c898765f7a@gmx.com>
 <14075786.243.1508845404640.JavaMail.gkos@dynomob>
 <b040ab81-b40a-7ace-b493-5e5c539e7231@gmx.com>
 <27675301.364.1508871760291.JavaMail.gkos@dynomob>
 <13f15a18-c659-1cda-e69c-858a50a53401@sucha.eu>
In-Reply-To: <13f15a18-c659-1cda-e69c-858a50a53401@sucha.eu>

--ujzxvVRTSYEvIrX0P0yQiuHG9mtjGsY1A
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/20 =E4=B8=8A=E5=8D=886:36, Piotr Balwierz wrote:
> Hello BTRFS experts,
>=20
> I am reporting/confirming the same problem present in kernel 4.19.0
> (Debian Buster, x86_64).
> To be specific:
>=20
> 0) The BTRFS partition used to work fine for 2 years until a power cut
> today. It uses lzo compression. Until power cut kernel version was
> probably 4.14.0
>=20
> 1) BTRFS partition refused to mount during boot with the following
> kernel and systemd errors:
>=20
> |Mar 19 15:10:52 mamut kernel: BTRFS error (device dm-5): open_ctree
> failed Mar 19 15:10:52 mamut kernel: BTRFS info (device dm-5): use lzo
> compression, level 0 Mar 19 15:10:52 mamut kernel: BTRFS info (device
> dm-5): disk space caching is enabled Mar 19 15:10:52 mamut kernel: BTRF=
S
> info (device dm-5): has skinny extents Mar 19 15:10:52 mamut systemd[1]=
:
> mnt-storage.mount: Mount process exited, code=3Dkilled, status=3D15/TER=
M Mar
> 19 15:10:52 mamut systemd[1]: mnt-storage.mount: Failed with result
> 'timeout'. Mar 19 15:10:52 mamut systemd[1]: Failed to mount
> /mnt/storage. Mar 19 15:10:52 mamut kernel: BTRFS error (device dm-5):
> super_total_bytes 52798547820544 mismatch with fs_devices total_rw_byte=
s
> 105597095641088 Mar 19 15:10:52 mamut kernel: BTRFS error (device dm-5)=
:
> failed to read chunk tree: -22 Mar 19 15:10:52 mamut kernel: BTRFS erro=
r
> (device dm-5): open_ctree failed|
>=20
> 2)|Note that total_rw_bytes in kernel error message equals exactly twic=
e
> ||super_total_bytes|. super_total_bytes is the correct size of the
> partition (52TB, 48TiB). It equals to the size reported by fdisk.
> Something being counted twice? The partition is on top of a 8-fold
> multipath to a fibre channel-attached disk array (in case it matters).
>=20
> 3) the first manual mount failed with a generic message (wrong fs type =
etc)
>=20
> 4) the first btrfs check (without --repair) fails with an IO error. I
> used to have no IO errors on this device before.
>=20
> |# btrfs check /dev/mapper/fc_trunk-part3 Opening filesystem to check..=
=2E
> Checking filesystem on /dev/mapper/fc_trunk-part3 UUID:
> 40a2e65b-f34a-4d33-946d-055d93fe7ffa [1/7] checking root items ERROR:
> failed to repair root items: Input/output error|
>=20
> 5) the second btrfs check with --repair succeeds. I did *not* run btrfs=

> rescue fix-device-size.
>=20
> =C2=A0=C2=A0=C2=A0 btrfs check --repair /dev/mapper/fc_trunk-part3
> =C2=A0=C2=A0=C2=A0 enabling repair mode
> =C2=A0=C2=A0=C2=A0 Opening filesystem to check...
> =C2=A0=C2=A0=C2=A0 Checking filesystem on /dev/mapper/fc_trunk-part3
> =C2=A0=C2=A0=C2=A0 UUID: 40a2e65b-f34a-4d33-946d-055d93fe7ffa
> =C2=A0=C2=A0=C2=A0 [1/7] checking root items
> =C2=A0=C2=A0=C2=A0 Fixed 0 roots.
> =C2=A0=C2=A0=C2=A0 [2/7] checking extents
> =C2=A0=C2=A0=C2=A0 No device size related problem found
> =C2=A0=C2=A0=C2=A0 [3/7] checking free space cache
> =C2=A0=C2=A0=C2=A0 cache and super generation don't match, space cache =
will be invalidated
> =C2=A0=C2=A0=C2=A0 [4/7] checking fs roots
> =C2=A0=C2=A0=C2=A0 [5/7] checking only csums items (without verifying d=
ata)
> =C2=A0=C2=A0=C2=A0 [6/7] checking root refs
> =C2=A0=C2=A0=C2=A0 [7/7] checking quota groups skipped (not enabled on =
this FS)
> =C2=A0=C2=A0=C2=A0 found 41629742850048 bytes used, no error found
> =C2=A0=C2=A0=C2=A0 total csum bytes: 40569609916
> =C2=A0=C2=A0=C2=A0 total tree bytes: 76425707520
> =C2=A0=C2=A0=C2=A0 total fs tree bytes: 15665889280
> =C2=A0=C2=A0=C2=A0 total extent tree bytes: 16241786880
> =C2=A0=C2=A0=C2=A0 btree space waste bytes: 4094701258
> =C2=A0=C2=A0=C2=A0 file data blocks allocated: 54396052914176
> =C2=A0=C2=A0=C2=A0 referenced 67747603632128

If btrfs-check can repair, then your fs is not seriously corrupted,
which is a good news.

>=20
> 6) The second try of manual mount succeeded, but it took 2 minutes.

Slow mount is related to extent tree size.

> =C2=A0=C2=A0=C2=A0 # time mount /mnt/storage
> =C2=A0=C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0 2m9.076s
> =C2=A0=C2=A0=C2=A0 user=C2=A0=C2=A0=C2=A0 0m0.005s
> =C2=A0=C2=A0=C2=A0 sys=C2=A0=C2=A0=C2=A0=C2=A0 0m2.753s
>=20
> 7) btrfs inspect-internal dump-super reports only the correct size:
>=20
> =C2=A0=C2=A0=C2=A0 btrfs inspect-internal dump-super -fa /dev/mapper/fc=
_trunk-part3 |
> grep total
> =C2=A0=C2=A0=C2=A0 total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 52798547820544
> =C2=A0=C2=A0=C2=A0 dev_item.total_bytes=C2=A0=C2=A0=C2=A0 5279854782054=
4
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 5=
2798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 5=
2798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0 =C2=A0 =C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 52=
798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=
=C2=A0 52798547820544
> =C2=A0=C2=A0=C2=A0 total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 52798547820544
> =C2=A0=C2=A0=C2=A0 dev_item.total_bytes=C2=A0=C2=A0=C2=A0 5279854782054=
4
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 5=
2798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 5=
2798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0 =C2=A0 =C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 52=
798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=
=C2=A0 52798547820544
> =C2=A0=C2=A0=C2=A0 total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 52798547820544
> =C2=A0=C2=A0=C2=A0 dev_item.total_bytes=C2=A0=C2=A0=C2=A0 5279854782054=
4
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 5=
2798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 5=
2798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0 =C2=A0 =C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 52=
798547820544
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=
=C2=A0 52798547820544
>=20
>=20
> 8) I did not try a second reboot.
> btrfs-progs v4.20.1
>=20
> btrfs fi usage /mnt/storage
> Overall:
> =C2=A0=C2=A0=C2=A0 Device size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 48.02TiB
> =C2=A0=C2=A0=C2=A0 Device allocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 37.94TiB

This explains the slow mount.

Unless using the new BG_TREE feature I purposed, the slow mount can't
really be solved.

Thanks,
Qu

> =C2=A0=C2=A0=C2=A0 Device unallocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 10.08TiB
> =C2=A0=C2=A0=C2=A0 Device missing:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B
> =C2=A0=C2=A0=C2=A0 Used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 37.93TiB
> =C2=A0=C2=A0=C2=A0 Free (estimated):=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10.08TiB=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 (min: 5.04TiB)
> =C2=A0=C2=A0=C2=A0 Data ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 1.00
> =C2=A0=C2=A0=C2=A0 Metadata ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.0=
0
> =C2=A0=C2=A0=C2=A0 Global reserve:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512.00MiB=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 (used: 0.00B)
>=20
> Data,single: Size:37.80TiB, Used:37.79TiB
> =C2=A0=C2=A0 /dev/mapper/fc_trunk-part3=C2=A0=C2=A0=C2=A0=C2=A0 37.80Ti=
B
>=20
> Metadata,DUP: Size:73.00GiB, Used:71.17GiB
> =C2=A0=C2=A0 /dev/mapper/fc_trunk-part3=C2=A0=C2=A0=C2=A0 146.00GiB
>=20
> System,DUP: Size:8.00MiB, Used:4.09MiB
> =C2=A0=C2=A0 /dev/mapper/fc_trunk-part3=C2=A0=C2=A0=C2=A0=C2=A0 16.00Mi=
B
>=20
> Unallocated:
> =C2=A0=C2=A0 /dev/mapper/fc_trunk-part3=C2=A0=C2=A0=C2=A0=C2=A0 10.08Ti=
B
>=20
>=20
>=20
> Hope that it will be helpful,
> Piotr J. Balwierz
>=20
>=20
>=20
> On 24/10/2017 20.02, Konstantin V. Gavrilenko wrote:
>> The mentioning of the device scan scode and the fact the total_bytes
>> is double made me try hashing the raid from the fstab.
>> So i booted, run the "inspect-internal dump-super" that confirmed that=

>> it is in order.
>> # grep -i total_bytes hashed-inspect-internal
>>
>> total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32004083023872
>> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 32004083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32004083023872
>> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 32004083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32004083023872
>> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 32004083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3200=
4083023872
>>
>> then I unhashed the device in fstab, mounted it manually and it
>> successfully mounted.
>>
>> # time mount /mnt/arh-backup1/
>>
>> real=C2=A0=C2=A0=C2=A0 2m49.021s
>> user=C2=A0=C2=A0=C2=A0 0m0.000s
>> sys=C2=A0=C2=A0=C2=A0=C2=A0 0m1.244s
>>
>>
>>
>> With the unhashed device in the fstab, i rebooted and upon reboot I
>> run mount
>>
>> time mount /mnt/arh-backup1/
>> mount: wrong fs type, bad option, bad superblock on /dev/sda,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 missing codepage or helper =
program, or other error
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 In some cases useful info i=
s found in syslog - try
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dmesg | tail or so.
>>
>> real=C2=A0=C2=A0=C2=A0 1m20.499s
>> user=C2=A0=C2=A0=C2=A0 0m0.000s
>> sys=C2=A0=C2=A0=C2=A0=C2=A0 0m0.045s
>>
>> that failed. I further waited for couple of minutes and run the mount
>> again, and it mounted successfully.
>>
>>
>> So it seems that because of the amount of time it takes mount, nearly
>> 3 minutes, to mount the device, there is some sort of race condition,
>> and two device scans are running at the same time, or something simila=
r.
>> I can say one thing for sure, it wasn't happening on 4.10 and I have
>> only observed such behaviour on 4.12 and 4.13
>>
>> p.s. the disk does not mount automatically upon boot, but can be
>> mounted manually later
>>
>>
>> # uptime
>> =C2=A0 19:54:45 up 4 min,=C2=A0 1 user,=C2=A0 load average: 0.30, 0.74=
, 0.39
>>
>> # time mount /mnt/arh-backup1/
>>
>> real=C2=A0=C2=A0=C2=A0 2m52.247s
>> user=C2=A0=C2=A0=C2=A0 0m0.000s
>> sys=C2=A0=C2=A0=C2=A0=C2=A0 0m1.246s
>>
>>
>> Here is the=C2=A0 dmesg extract. It seems that for some reason on 204t=
h
>> second the system return "open ctree failed"
>> on 329 second, I started the mount manually.
>>
>> [=C2=A0 204.389231] BTRFS error (device sda): open_ctree failed
>> [=C2=A0 329.234613] BTRFS info (device sda): force zlib compression
>> [=C2=A0 329.234618] BTRFS info (device sda): using free space tree
>> [=C2=A0 329.234620] BTRFS info (device sda): has skinny extents
>>
>>
>> hope that helps and thanks for your help
>>
>>
>> Yours sincerely,
>> Konstantin V. Gavrilenko
>>
>>
>>
>> ----- Original Message -----
>> From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
>> To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
>> Cc: "Linux fs Btrfs" <linux-btrfs@vger.kernel.org>
>> Sent: Tuesday, 24 October, 2017 3:44:21 PM
>> Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices=

>> total_rw_bytes 64008166047744
>>
>>
>>
>> On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 19:44, Konstantin V. Gavrilenko=
 wrote:
>>> answers inline marked with KVG:
>>>
>>> Yours sincerely,
>>> Konstantin V. Gavrilenko
>>>
>>>
>>>
>>>
>>> ----- Original Message -----
>>> From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
>>> To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>, "Linux fs
>>> Btrfs" <linux-btrfs@vger.kernel.org>
>>> Sent: Tuesday, 24 October, 2017 11:37:56 AM
>>> Subject: Re: super_total_bytes 32004083023872 mismatch with
>>> fs_devices total_rw_bytes 64008166047744
>>>
>>>
>>>
>>> On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 17:20, Konstantin V. Gavrilenk=
o wrote:
>>>> Hi list,
>>>>
>>>> having installed the recent kernel version I am no longer able to
>>>> mount the btrfs partition with compression on the first attempt.
>>>> Previously on 4.10.0-37-generic everything was working fine, once I
>>>> switched to 4.13.9-041309-generic I started getting the following
>>>> error while trying to mount it with the same=C2=A0 options
>>>> "compress-force=3Dzlib,space_cache=3Dv2"
>>>>
>>>> [=C2=A0 204.596381] BTRFS error (device sda): open_ctree failed
>>>> [=C2=A0 204.631895] BTRFS info (device sda): force zlib compression
>>>> [=C2=A0 204.631901] BTRFS info (device sda): using free space tree
>>>> [=C2=A0 204.631903] BTRFS info (device sda): has skinny extents
>>>> [=C2=A0 204.890145] BTRFS error (device sda): super_total_bytes
>>>> 32004083023872 mismatch with fs_devices total_rw_bytes 6400816604774=
4
>>>> [=C2=A0 204.891276] BTRFS error (device sda): failed to read chunk t=
ree: -22
>>>> [=C2=A0 204.944333] BTRFS error (device sda): open_ctree failed
>>> Such problem can be easily fixed with this branch:
>>> https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev
>>>
>>> Use "btrfs rescue fix-device-size" should handle it well.
>>>
>>> But the problem is, normally the super_total_bytes should only be les=
s
>>> than 4K smaller than total device size.
>>>
>>> Unless something else went wrong, it should not have such large
>>> difference.
>>>
>>>
>>> KVG: Thanks, will try.
>>> The drive was initially created as RAID5 with 4 x 8tb devices, and
>>> later expanded to included another 8Tb. So now it is 5x8tb RAID5.
>>>
>>>
>>>> For some reason, the super_total_bytes is exactly half of
>>>> total_rw_bytes.
>>>>
>>>>
>>>> however, if after unsuccessful first mount attempt, I mount it with
>>>> minimum number of options "space_cache=3Dv2" the partition mounts.
>>>> Then I umount it, and mount normally, with full set of options
>>>> "compress-force=3Dzlib,space_cache=3Dv2" it mounts without an error.=

>>>> I also observed the same error on 4.12.14-041214-generic
>>>> Any ideas why this might be happening?
>>> Would you please provide super dump by:
>>>
>>> # btrfs inspect-internal dump-super -fa /dev/sda
>>>
>>> (Although I don't think it will be very interesting since it can be
>>> mounted later)
>>>
>>>
>>> KVG: here you go
>>>
>>> # btrfs inspect-internal dump-super -fa /dev/sda
>>> superblock: bytenr=3D65536, device=3D/dev/sda
>>> ---------------------------------------------------------
>>> csum_type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 (crc32c)
>>> csum_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 4
>>> csum=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0xc4b95762 [match]
>>> bytenr=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 65536
>>> flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( WRITTEN )
>>> magic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _BHRfS_M [match]
>>> fsid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 017b587a-3e88-4f08-8616-=
ec686f8f969f
>>> label=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 arh-backup
>>> generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 145942
>>> root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 17334200778752
>>> sys_array_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
129
>>> chunk_root_generation=C2=A0=C2=A0 145699
>>> root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 1
>>> chunk_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 20971520
>>> chunk_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
>>> log_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 17334149644288
>>> log_root_transid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> log_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0
>>> total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32004083023872
>> Here 32004083023872.
>>> bytes_used=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 19719727349760
>>> sectorsize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 4096
>>> nodesize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 16384
>>> leafsize (deprecated)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 16384
>>> stripesize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 4096
>>> root_dir=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 6
>>> num_devices=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1
>>> compat_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x0
>>> compat_ro_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( FREE_SPACE_TREE |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 FREE_SPACE_TREE_VALID )
>>> incompat_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0x169
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( MIXED_BACKREF |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 COMPRESS_LZO |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 BIG_METADATA |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 EXTENDED_IREF |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 SKINNY_METADATA )
>>> cache_generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7
>>> uuid_tree_generation=C2=A0=C2=A0=C2=A0 145942
>>> dev_item.uuid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ee632cde-2139-4181-9d57-ff892768f2ef
>>> dev_item.fsid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 017b587a-3e88-4f08-8616-ec686f8f969f [match]
>>> dev_item.type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0
>>> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 32004083023872
>> And here, 32004083023872 again.
>>
>> So it matches now.
>>
>> And considering the original report says it's twice the size, I wonder=

>> if it's something related to device scan.
>>
>> Like the same disk get counted twice, so it's reporting like that.
>>
>> If the problem happens again, would you please try run "btrfs device
>> scan" and remount it with the same mount option?
>>
>>
>>> dev_item.bytes_used=C2=A0=C2=A0=C2=A0=C2=A0 19832028266496
>>> dev_item.io_align=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.io_width=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.sector_size=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.devid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
1
>>> dev_item.dev_group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.seek_speed=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.bandwidth=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.generation=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> sys_chunk_array[2048]:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 0 key (FIRST_CH=
UNK_TREE CHUNK_ITEM 20971520)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 length 8388608 owner 2 stripe_len 65536 type =
SYSTEM|DUP
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_align 65536 io_width 65536 sector_size 409=
6
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 num_stripes 2 sub_stripes 0
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 stripe 0 devid 1 offset 20971520
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 stripe 1 devid 1 offset 29360128
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>>> backup_roots[4]:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 0:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334200778752=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177021952=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133260288=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 1:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334201057280=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177988608=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133161984=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 2:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334200778752=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334184558592=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334135275520=C2=A0 gen:
>>> 145943=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 3:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334201057280=C2=A0 gen:
>>> 145939=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177988608=C2=A0 gen:
>>> 145939=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334131884032=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>>
>>> superblock: bytenr=3D67108864, device=3D/dev/sda
>>> ---------------------------------------------------------
>>> csum_type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 (crc32c)
>>> csum_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 4
>>> csum=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0xd1c4187f [match]
>>> bytenr=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 67108864
>>> flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( WRITTEN )
>>> magic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _BHRfS_M [match]
>>> fsid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 017b587a-3e88-4f08-8616-=
ec686f8f969f
>>> label=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 arh-backup
>>> generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 145942
>>> root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 17334200778752
>>> sys_array_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
129
>>> chunk_root_generation=C2=A0=C2=A0 145699
>>> root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 1
>>> chunk_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 20971520
>>> chunk_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
>>> log_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> log_root_transid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> log_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0
>>> total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32004083023872
>>> bytes_used=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 19719727349760
>>> sectorsize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 4096
>>> nodesize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 16384
>>> leafsize (deprecated)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 16384
>>> stripesize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 4096
>>> root_dir=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 6
>>> num_devices=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1
>>> compat_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x0
>>> compat_ro_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( FREE_SPACE_TREE |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 FREE_SPACE_TREE_VALID )
>>> incompat_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0x169
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( MIXED_BACKREF |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 COMPRESS_LZO |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 BIG_METADATA |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 EXTENDED_IREF |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 SKINNY_METADATA )
>>> cache_generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7
>>> uuid_tree_generation=C2=A0=C2=A0=C2=A0 145942
>>> dev_item.uuid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ee632cde-2139-4181-9d57-ff892768f2ef
>>> dev_item.fsid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 017b587a-3e88-4f08-8616-ec686f8f969f [match]
>>> dev_item.type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0
>>> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 32004083023872
>>> dev_item.bytes_used=C2=A0=C2=A0=C2=A0=C2=A0 19832028266496
>>> dev_item.io_align=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.io_width=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.sector_size=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.devid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
1
>>> dev_item.dev_group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.seek_speed=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.bandwidth=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.generation=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> sys_chunk_array[2048]:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 0 key (FIRST_CH=
UNK_TREE CHUNK_ITEM 20971520)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 length 8388608 owner 2 stripe_len 65536 type =
SYSTEM|DUP
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_align 65536 io_width 65536 sector_size 409=
6
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 num_stripes 2 sub_stripes 0
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 stripe 0 devid 1 offset 20971520
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 stripe 1 devid 1 offset 29360128
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>>> backup_roots[4]:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 0:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334200778752=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177021952=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133260288=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 1:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334201057280=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177988608=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133161984=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 2:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334200778752=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334184558592=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133161984=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 3:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334201057280=C2=A0 gen:
>>> 145939=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177988608=C2=A0 gen:
>>> 145939=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334131884032=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>>
>>> superblock: bytenr=3D274877906944, device=3D/dev/sda
>>> ---------------------------------------------------------
>>> csum_type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 (crc32c)
>>> csum_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 4
>>> csum=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x2c434e4e [match]
>>> bytenr=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 274877906944
>>> flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( WRITTEN )
>>> magic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _BHRfS_M [match]
>>> fsid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 017b587a-3e88-4f08-8616-=
ec686f8f969f
>>> label=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 arh-backup
>>> generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 145942
>>> root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 17334200778752
>>> sys_array_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
129
>>> chunk_root_generation=C2=A0=C2=A0 145699
>>> root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 1
>>> chunk_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 20971520
>>> chunk_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
>>> log_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> log_root_transid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> log_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0
>>> total_bytes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32004083023872
>>> bytes_used=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 19719727349760
>>> sectorsize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 4096
>>> nodesize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 16384
>>> leafsize (deprecated)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 16384
>>> stripesize=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 4096
>>> root_dir=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 6
>>> num_devices=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1
>>> compat_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x0
>>> compat_ro_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( FREE_SPACE_TREE |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 FREE_SPACE_TREE_VALID )
>>> incompat_flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0x169
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ( MIXED_BACKREF |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 COMPRESS_LZO |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 BIG_METADATA |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 EXTENDED_IREF |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 SKINNY_METADATA )
>>> cache_generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7
>>> uuid_tree_generation=C2=A0=C2=A0=C2=A0 145942
>>> dev_item.uuid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ee632cde-2139-4181-9d57-ff892768f2ef
>>> dev_item.fsid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 017b587a-3e88-4f08-8616-ec686f8f969f [match]
>>> dev_item.type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0
>>> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 32004083023872
>>> dev_item.bytes_used=C2=A0=C2=A0=C2=A0=C2=A0 19832028266496
>>> dev_item.io_align=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.io_width=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.sector_size=C2=A0=C2=A0=C2=A0 4096
>>> dev_item.devid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
1
>>> dev_item.dev_group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.seek_speed=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.bandwidth=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> dev_item.generation=C2=A0=C2=A0=C2=A0=C2=A0 0
>>> sys_chunk_array[2048]:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 0 key (FIRST_CH=
UNK_TREE CHUNK_ITEM 20971520)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 length 8388608 owner 2 stripe_len 65536 type =
SYSTEM|DUP
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_align 65536 io_width 65536 sector_size 409=
6
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 num_stripes 2 sub_stripes 0
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 stripe 0 devid 1 offset 20971520
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 stripe 1 devid 1 offset 29360128
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>>> backup_roots[4]:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 0:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334200778752=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177021952=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133260288=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 1:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334201057280=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177988608=C2=A0 gen:
>>> 145941=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133161984=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 2:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334200778752=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334184558592=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334133161984=C2=A0 gen:
>>> 145942=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 3:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17334201057280=C2=A0 gen:
>>> 145939=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 20971520=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145699=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=A0=C2=A0 1=
7334177988608=C2=A0 gen:
>>> 145939=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 17334131884032=C2=A0 gen:
>>> 145940=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 32391168=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gen:
>>> 145836=C2=A0=C2=A0=C2=A0=C2=A0 level: 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 17154410381312=C2=A0 gen:
>>> 145925=C2=A0=C2=A0=C2=A0=C2=A0 level: 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=A0=C2=A0 3=
2004083023872
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 19719727349760
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=A0=C2=A0 1=

>>>
>>>
>>>
>>>
>>>
>>> And device tree dump by:
>>> # btrfs inspect-internal dump-tree -t dev /dev/sda
>>>
>>> KVG: Here you go again
>>>
>>> # btrfs inspect-internal dump-tree -t dev /dev/sda >
>>> /tmp/inspect-internal-dump-tree
>>> parent transid verify failed on 17334203744256 wanted 145954 found
>>> 145956
>>> parent transid verify failed on 17334203744256 wanted 145954 found
>>> 145956
>>> parent transid verify failed on 17334203744256 wanted 145954 found
>>> 145956
>>> parent transid verify failed on 17334203744256 wanted 145954 found
>>> 145956
>>> Ignoring transid failure
>>>
>>> # wc -l <
>>> inspect-internal-dump-tree=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0
>>> 74760
>> That's beyond my expectation, but since the super block matches, I
>> wonder it's related to device scan implemented wrongly or has some rac=
e.
>>
>> And in that case, dump-tree output is not that important.
>>
>> BTW, are you running dump-tree with device mounted? If so the transid
>> verification failure may not be a big problem.
>>
>>>
>>> # head -n 150 <
>>> inspect-internal-dump-tree=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
>>> [13:28:00]
>>> btrfs-progs v4.13.3
>>> device tree key (DEV_TREE ROOT_ITEM 0)
>>> node 32391168 level 1 items 88 free 405 generation 145836 owner 4
>>> fs uuid 017b587a-3e88-4f08-8616-ec686f8f969f
>>> chunk uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (0 PERSISTENT_IT=
EM 1) block 32407552 (1978) gen 145836
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 23=
4113466368) block 231767769088
>>> (14145982) gen 274
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 47=
3557893120) block 484797186048
>>> (29589672) gen 378
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 71=
0854836224) block 861293805568
>>> (52569202) gen 482
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 94=
9225521152) block 1042388156416
>>> (63622324) gen 587
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 11=
87596206080) block 1221328453632
>>> (74543973) gen 691
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 14=
24893149184) block 1583808970752
>>> (96668028) gen 764
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 16=
62190092288) block 1603743318016
>>> (97884724) gen 843
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 19=
00560777216) block 2231483187200
>>> (136198925) gen 1017
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 21=
38931462144) block 2241853407232
>>> (136831873) gen 1080
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 23=
71933437952) block 2268266070016
>>> (138443974) gen 1138
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 26=
10304122880) block 2311626964992
>>> (141090513) gen 1177
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 28=
48674807808) block 2590371545088
>>> (158103732) gen 1263
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 30=
88119234560) block 2837798567936
>>> (173205479) gen 1314
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 33=
26489919488) block 3114321903616
>>> (190083124) gen 1372
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 35=
64860604416) block 3591785086976
>>> (219225164) gen 1448
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 38=
02157547520) block 3718121062400
>>> (226936100) gen 1524
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 40=
40528232448) block 21927333150720
>>> (1338338205) gen 136290
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 42=
78898917376) block 4133925863424
>>> (252314811) gen 1724
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 45=
16195860480) block 22441652109312
>>> (1369729743) gen 133266
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 47=
55640287232) block 14608468082688
>>> (891630132) gen 133130
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 49=
92937230336) block 5180103491584
>>> (316168426) gen 2146
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 52=
31307915264) block 20077315735552
>>> (1225422103) gen 131467
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 54=
68604858368) block 5866555588608
>>> (358066137) gen 3067
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 57=
05901801472) block 6367858622464
>>> (388663246) gen 3174
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 58=
26160885760) block 6367858638848
>>> (388663247) gen 3174
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 60=
64531570688) block 17709247496192
>>> (1080886688) gen 63205
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 63=
03975997440) block 17459226411008
>>> (1065626612) gen 145661
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 65=
00470751232) block 17459593674752
>>> (1065649028) gen 145669
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 67=
37767694336) block 14608384458752
>>> (891625028) gen 132007
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 69=
76138379264) block 15230725767168
>>> (929609727) gen 132017
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 71=
36125911040) block 13657160859648
>>> (833566947) gen 137915
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 72=
55311253504) block 13657457180672
>>> (833585033) gen 137917
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 74=
92608196608) block 22441489580032
>>> (1369719823) gen 136294
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 77=
30978881536) block 13854137253888
>>> (845589432) gen 138616
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 79=
69349566464) block 7788285968384
>>> (475359251) gen 140545
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 82=
07720251392) block 14113310818304
>>> (861408131) gen 127092
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 84=
46090936320) block 8679398998016
>>> (529748474) gen 17985
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 86=
84461621248) block 8916314619904
>>> (544208656) gen 18574
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 89=
22832306176) block 29434636730368
>>> (1796547652) gen 144688
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 91=
57981765632) block 6453626322944
>>> (393898091) gen 145220
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 93=
61992712192) block 19459087679488
>>> (1187688457) gen 132049
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 96=
00363397120) block 12893675651072
>>> (786967508) gen 116367
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 97=
20622481408) block 22441517318144
>>> (1369721516) gen 95603
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 98=
47860887552) block 22441466626048
>>> (1369718422) gen 117878
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 10=
082473476096) block 22493359931392
>>> (1372885738) gen 117882
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 10=
232797331456) block 13983139643392
>>> (853463113) gen 137923
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 10=
471168016384) block 6959763996672
>>> (424790283) gen 105377
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 10=
591427100672) block 10067009994752
>>> (614441528) gen 27773
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 10=
830871527424) block 10072383062016
>>> (614769474) gen 28150
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 11=
070315954176) block 10072413356032
>>> (614771323) gen 92253
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 11=
309760380928) block 22493328687104
>>> (1372883831) gen 133268
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 11=
548131065856) block 1042474778624
>>> (63627611) gen 133909
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 11=
785428008960) block 15016548761600
>>> (916537400) gen 121951
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 12=
024872435712) block 12656435298304
>>> (772487506) gen 32985
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 12=
263243120640) block 12893629710336
>>> (786964704) gen 33745
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 12=
500540063744) block 16644219928576
>>> (1015882564) gen 112366
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 12=
738910748672) block 14703563259904
>>> (897434281) gen 145699
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 12=
976207691776) block 14113684733952
>>> (861430953) gen 137926
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 13=
214578376704) block 15230715084800
>>> (929609075) gen 116469
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 13=
452949061632) block 12787035504640
>>> (780458710) gen 119919
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 13=
690246004736) block 10067511001088
>>> (614472107) gen 119958
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 13=
928616689664) block 14113506328576
>>> (861420064) gen 106290
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 14=
166987374592) block 861654532096
>>> (52591219) gen 140596
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 14=
404284317696) block 6959531130880
>>> (424776070) gen 103496
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 14=
643728744448) block 484408541184
>>> (29565951) gen 103596
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 14=
882099429376) block 205519962112
>>> (12543943) gen 137977
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 15=
118322630656) block 13289788358656
>>> (811144309) gen 145698
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 15=
356693315584) block 13289789358080
>>> (811144370) gen 145698
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 15=
596137742336) block 15736233984000
>>> (960463500) gen 117936
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 15=
833434685440) block 1221260197888
>>> (74539807) gen 138299
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 16=
071805370368) block 6368249397248
>>> (388687097) gen 124384
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 16=
310176055296) block 12787123699712
>>> (780464093) gen 138137
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 16=
548546740224) block 9420764561408
>>> (574997837) gen 124415
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 16=
787991166976) block 22441589932032
>>> (1369725948) gen 124583
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 17=
025288110080) block 15016789147648
>>> (916552072) gen 144864
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 17=
263658795008) block 17459171082240
>>> (1065623235) gen 144951
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 17=
502029479936) block 673143095296
>>> (41085394) gen 143317
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 17=
740400164864) block 19010757427200
>>> (1160324550) gen 141153
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 17=
979844591616) block 10067131596800
>>> (614448950) gen 141191
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 18=
217141534720) block 205212958720
>>> (12525205) gen 124623
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 18=
455512219648) block 205287997440
>>> (12529785) gen 124626
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 18=
692809162752) block 16703827378176
>>> (1019520714) gen 124744
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 18=
931179847680) block 7268874698752
>>> (443656903) gen 124899
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 19=
169550532608) block 14291177324544
>>> (872264241) gen 141256
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 19=
407921217536) block 29134446510080
>>> (1778225495) gen 142791
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 19=
646291902464) block 6453644148736
>>> (393899179) gen 143236
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key (1 DEV_EXTENT 19=
883588845568) block 15998310219776
>>> (976459364) gen 143270
>>> leaf 32407552 items 223 free space 12 generation 145836 owner 4
>>> leaf 32407552 flags 0x1(WRITTEN) backref revision 1
>>> fs uuid 017b587a-3e88-4f08-8616-ec686f8f969f
>>> chunk uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 0 key (0 PERSIS=
TENT_ITEM 1) itemoff 16243 itemsize 40
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 persistent item objectid 0 offset 1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 device stats
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 write_errs 0 read_errs 0 flush_errs 0
>>> corruption_errs 0 generation 0
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 1 key (1 DEV_EX=
TENT 20971520) itemoff 16195 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 20971520 leng=
th 8388608
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a=
9963084
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 2 key (1 DEV_EX=
TENT 29360128) itemoff 16147 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 20971520 leng=
th 8388608
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a=
9963084
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 3 key (1 DEV_EX=
TENT 37748736) itemoff 16099 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 29360128 leng=
th
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a=
9963084
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 4 key (1 DEV_EX=
TENT 1111490560) itemoff 16051 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 29360128 leng=
th
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a=
9963084
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 5 key (1 DEV_EX=
TENT 2185232384) itemoff 16003 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 16135487488 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 6 key (1 DEV_EX=
TENT 3258974208) itemoff 15955 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 17209229312 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 7 key (1 DEV_EX=
TENT 4332716032) itemoff 15907 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 18282971136 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 8 key (1 DEV_EX=
TENT 5406457856) itemoff 15859 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 19356712960 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 9 key (1 DEV_EX=
TENT 6480199680) itemoff 15811 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 20430454784 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 10 key (1 DEV_E=
XTENT 7553941504) itemoff 15763 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 21504196608 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 11 key (1 DEV_E=
XTENT 8627683328) itemoff 15715 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 22577938432 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 12 key (1 DEV_E=
XTENT 9701425152) itemoff 15667 itemsize 48
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev extent chunk_tree 3
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_objectid 256 chunk_offset 23651680256 l=
ength
>>> 1073741824
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 chunk_tree_uuid 00000000-0000-0000-0000-00000=
0000000
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 13 key (1 DEV_E=
XTENT 10775166976) itemoff 15619
>>> itemsize 48
>>>
>>> KVG: and the complete file is attached to this message
>>>
>>>
>>>
>>>
>>> Normally it should not be mountable after v4.6 kernel if
>>> super_total_bytes mismatch, but I'm more interested in how it mounted=

>>> successfully.
>>>
>>> KVG: I've no idea why it mounts successfully when the compressions
>>> flags are omitted. No indication in the dmesg.
>> I think it's device scan code, maybe I can check it later.
>>
>> Considering your superblock is good, you won't encounter such problem
>> any longer.
>>
>> And if it really happens again, please try "btrfs device scan" first.
>>
>> Thanks,
>> Qu
>>
>>>
>>> And BTW, are you using x86_64 kernel or x86 kernel?
>>> I don't think it's related in your case, but some reports about 32bit=

>>> kernel has strange bugs are in mail list, so just in case.
>>>
>>> KVG: both kernels are 64bit. with 4.10.37 it mounts without a
>>> problem, with newer kernels the problem exis
>>>
>>> [=C2=A0=C2=A0=C2=A0 0.000000] Linux version 4.10.0-37-generic
>>> (buildd@lgw01-amd64-037) (gcc version 5.4.0 20160609 (Ubuntu
>>> 5.4.0-6ubuntu1~16.04.4) ) #41~16.04.1-Ubuntu SMP Fri Oct 6 22:42:59
>>> UTC 2017 (Ubuntu 4.10.0-37.41~16.04.1-generic 4.10.17)
>>>
>>> [=C2=A0=C2=A0=C2=A0 0.000000] Linux version 4.13.9-041309-generic (ke=
rnel@tangerine)
>>> (gcc version 7.2.0 (Ubuntu 7.2.0-8ubuntu3)) #201710211231 SMP Sat Oct=

>>> 21 16:32:44 UTC 2017
>>>
>>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>>
>>>>
>>>> System information
>>>>
>>>> distribution: Ubuntu 16.04
>>>> btrfs-progs v4.8.1 later upgraded to v4.13.3
>>>>
>>>> # btrfs fi usage /mnt/backup
>>>> Overall:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Device size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29.=
11TiB
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Device allocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 18.04TiB
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Device unallocated:=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11.07TiB
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Device missing:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0.00B
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 17.99TiB
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Free (estimated):=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11.12TiB=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 (min: 5.58TiB)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Data ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 1.00
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Metadata ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 2.00
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Global reserve:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512.00MiB=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 (used: 0.00B)
>>>>
>>>> Data,single: Size:17.93TiB, Used:17.88TiB
>>>> =C2=A0=C2=A0=C2=A0 /dev/sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 17.9=
3TiB
>>>>
>>>> Metadata,DUP: Size:53.50GiB, Used:51.78GiB
>>>> =C2=A0=C2=A0=C2=A0 /dev/sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 107.00GiB
>>>>
>>>> System,DUP: Size:8.00MiB, Used:2.30MiB
>>>> =C2=A0=C2=A0=C2=A0 /dev/sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 16.0=
0MiB
>>>>
>>>> Unallocated:
>>>> =C2=A0=C2=A0=C2=A0 /dev/sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11.0=
7TiB
>>>>
>>>>
>>>>
>>>>
>>>> Yours sincerely,
>>>> Konstantin V. Gavrilenko
>>>>
>>>>
>>>> --=20
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.h=
tml
>>>>
>>
>>
>=20


--ujzxvVRTSYEvIrX0P0yQiuHG9mtjGsY1A--

--txtflcefLOZOlZt3rtdr0UlTmYseE9LuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyRkDcACgkQwj2R86El
/qhkiAf/ShxEAGtOeV/dkkAyL6KSo+bG3Y8YJdLJiTwKsBfTPMod7YmFNbIgwQCE
pzR8m6spX/hl9vOL6Fh/M56tk4jsT+37NfGNlXfbRqUrtbwPqcLr9Lpqj3lH/28a
PvBE+b0zJE0cS7/n4+B3Fzga2L8e3piqxsOkLvHit+uJD3lJwtno1MBzppR+VyIR
S6NvdOSLItJrmI1MC/I49AWtHViSh492g6/7qIK6JqKAX+5LHoDQL0RErh7I/zDO
MCz7Cmb0pN43PwriF0uZPOY2JOzvBDoTQk9jO2gDluvVf4hsbRnromptcZ3m3ja1
W83EuLj+q6wHGATUoaQ1hACGhFsHlg==
=HadV
-----END PGP SIGNATURE-----

--txtflcefLOZOlZt3rtdr0UlTmYseE9LuF--
