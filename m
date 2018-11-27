Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266B1C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 01:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4B46204FD
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 01:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4B46204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbeK0MJP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 07:09:15 -0500
Received: from mout.gmx.net ([212.227.15.18]:57697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbeK0MJO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 07:09:14 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M6BKc-1fUVWy1kbq-00yB9L; Tue, 27
 Nov 2018 02:13:07 +0100
Subject: Re: Linux-next regression?
To:     Andrea Gelmini <andrea.gelmini@linux.it>,
        linux-btrfs@vger.kernel.org
References: <20181126150137.GA16029@glet>
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
Message-ID: <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com>
Date:   Tue, 27 Nov 2018 09:13:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181126150137.GA16029@glet>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fcKckGJ2T9Vz8Q5eHXJ86pAbBLnMTOxYC"
X-Provags-ID: V03:K1:6FEgQ5QNB/AYBgo96fPmIYhsUP2SC65sDWY6C1aCosm7gJXfOFX
 oZ46YhwvfuV0GZ5UgoLth8b5PVoPYtBD6hG6Ngg5EtxTWseb2pEvwmvr5RSBfdOmElJxB6p
 VIWRbLqLZbrUXCVrLEBlGRzg7hL78KCxIETwAGsK88E7CsqMp5aef5ntmEfOmV1ywTermWB
 TvxjnwE+MUpHCH6SRsnlQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Lkx2KlCN3fs=:Xx5JnipHICYUqXbsAYEQAy
 cN5ZTanlF8N2b8HODIPHAoyas8QpfSTlPC7k+vcqX4Vv+ugVutFMg6+AtsSEqtFm9yLRLdOzm
 7lLG++nWLtQA1x0UkKFOxPE1dNj8tTXPzQuCOkP/DPeDZXzNsDxvhZ271t/QQQMw9rGfcmMeD
 c64DOCYUzWHklEsfw0Q6y1oNIPnW82E4l4ckiN7PY2yJZ5EhcbKxwqP7K5GtMXxmGhBvZyhn5
 7BeqPsc66PRcr0XqzNEWG5ed0a3bCnndfA2wQ3R2e0NaBqoP2k3PyAO6YFZ0VdzE36Sh0hlWe
 /JMcxV+SIO5uDSFqKZL87Hx6bsfgkSQktjiAsGe9Okyhr3F2h/bDDLfXQB02aBtU20XzvoMrD
 RjV3bJOYw16h2yBkEJux8IhvvRrTi98UKFGqU/2f2rK9pD3oMaGFln+Iq3fFyTFmZZsYPGiTh
 YUxii6BEjWR2CCmp9CVX3Lg6C/U9iHD2QeKsLM+SMyIdMR0abdIPenS2Qfq8W9Q+PJNLCv9Nx
 YjLIdYtuEW/ZxTjU/8DgFahbJQqwQq9ozvC5L5bgpqjGZU6VGl8cCu1B1FQugWsns99R3pVPD
 S07VvSS9w6stECQBr8qJIldA3Uzd/ZNLPSK7thV0AozXDFdvzjKMw27bLTzD9Esz6wXalN7Ij
 cqrH/s0XZPxacFE7irBnXAyzAo4Vlav7kSNi6OqZCxPoHWj2QQtBMpG+LaU1FrFH3DLQ/t6qb
 I5zyFks4Bm1lfKldZo5O1I0NV7ynewPh9DNXuxImpFG1jFVo/sXBHwYwoWhP+XuRDCI2Q2wl2
 9vzBwMWZgAWC0rPwViFXPRxtzblN8iQsr8d3e+7AKd4qHNlGdTac4fW3B5ekZ2mokczOjMT42
 AnUrM01QCaxMpfUTJeXcVaKEZnN06umQhwINGek2Q=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fcKckGJ2T9Vz8Q5eHXJ86pAbBLnMTOxYC
Content-Type: multipart/mixed; boundary="2owFtbn5roK2gyYt0ClUJxmSX5RXpawFI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrea Gelmini <andrea.gelmini@linux.it>, linux-btrfs@vger.kernel.org
Message-ID: <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com>
Subject: Re: Linux-next regression?
References: <20181126150137.GA16029@glet>
In-Reply-To: <20181126150137.GA16029@glet>

--2owFtbn5roK2gyYt0ClUJxmSX5RXpawFI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/26 =E4=B8=8B=E5=8D=8811:01, Andrea Gelmini wrote:
> Hi everybody,
>    and thanks a lot for your work.
>=20
>    I'm using BTRFS over LVM over cryptsetup, over Samsung SSD 860 EVO (=
latest git of btrfs-progs).
>    Usually I run kernel in development, because I know BTRFS is young a=
nd there are still lots of bugs and corner case to fix.
>=20
>    Anyway, I just want to submit to you a - maybe - useful info.
>=20
>    Yesterday I compiled and booted latest linux-next,=C2=B9 and I've go=
t this:
>=20
> -----------
> nov 26 01:18:22 glet kernel: Btrfs loaded, crc32c=3Dcrc32c-intel
> nov 26 01:18:22 glet kernel: BTRFS: device label home devid 1 transid 3=
2759 /dev/mapper/cry-home
> nov 26 01:18:23 glet kernel: BTRFS info (device dm-3): force lzo compre=
ssion, level 0
> nov 26 01:18:23 glet kernel: BTRFS info (device dm-3): disk space cachi=
ng is enabled
> nov 26 01:18:23 glet kernel: BTRFS info (device dm-3): has skinny exten=
ts
> nov 26 01:18:23 glet kernel: BTRFS error (device dm-3): bad tree block =
start, want 2152002191360 have 8829432654847901262

This means we failed to read one extent tree block and caused the problem=
=2E

And if you're using default mkfs profile it should try again to use the
extra copy, but it doesn't look like to be the case.

BTW, does it always happen like this? Or is there any possibility involve=
d?

> nov 26 01:18:23 glet kernel: BTRFS error (device dm-3): failed to read =
block groups: -5
> nov 26 01:18:23 glet kernel: BTRFS error (device dm-3): open_ctree fail=
ed
> -----------
>=20
>    Now, rebooting with 4.19.0-041900 (downloaded from here)=C2=B2, or 4=
=2E20-rc4 (compiled on this machine), the problem disappears.
>=20
>    Now, running scrub a few times, and copying data (all files of the l=
ogical volume) to external device, gives no complain
Would you please also try "btrfs check --readonly"?

>=20
>    Here I stop. This is my primary dev laptop, and at the moment I can'=
t spend time switching/rebooting/testing. I'm comparing the data with las=
t backup (I rsync each hour), but it takes time (it's more then 3TB).
>=20
>    So, that was about to let you know. Well, it's Ubuntu 18.10, and bet=
ween reboots no dist-upgrade or changes in booting related packages or sy=
stemd.
>=20
>   One question: I can completely trust the ok return status of scrub? I=
 know is made for this, but shit happens...

No, scrub only checks csum of data and tree blocks, it doesn't ensure
the content of tree blocks are OK.

For comprehensive check, go "btrfs check --readonly".

However I don't think it's something "btrfs check --readonly" would
report, but some strange behavior, maybe from LVM or cryptsetup.

Thanks,
Qu

>=20
> Kisses,
> Gelma  =20
>=20
> -----------------
> =C2=B9 commit:  8c9733fd9806c71e7f2313a280f98cb3051f93df
>   "Add linux-next specific files for 20181123"
> =C2=B2 http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.19/
>=20


--2owFtbn5roK2gyYt0ClUJxmSX5RXpawFI--

--fcKckGJ2T9Vz8Q5eHXJ86pAbBLnMTOxYC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv8mh4ACgkQwj2R86El
/qgOyggAhAKA6VSUE6c5lfgYrZn5UvfA5nzXBU21OpoxGgPDe2116DUrBnGrb8Gy
G8if3qFwQwiAKziJy5oWG7iz/2hkVDI0SzQAzSIcEoJ8dD1YQRKF5/hAuVBf5NpN
JsJzIsQ/bu8TymwH4s7V1xbjyLTclZIjYZqVnDV18olQLHkvzIBFiKjSpk3E9gkt
amtIbE4M6wsoCEDTuaVlRUt3stMGbP1rS6ny3ymLWOcBsdeSUMippA2/uY0cm+SK
ia/xUh4dJxWVRlaAo2Bj/zHZgPCfuS2Hdstds49PrXlSFDY+W2AX0HPop0noRLos
hp692jf0CLCXk97mgbdnjQOYtoBiLw==
=pKqk
-----END PGP SIGNATURE-----

--fcKckGJ2T9Vz8Q5eHXJ86pAbBLnMTOxYC--
