Return-Path: <SRS0=kVXZ=NI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75751ECDE47
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Oct 2018 02:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F48020869
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Oct 2018 02:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F48020869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbeJ1K7I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 06:59:08 -0400
Received: from mout.gmx.net ([212.227.15.15]:46323 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbeJ1K7I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 06:59:08 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MPUlV-1gBtey2MFd-004kXw; Sun, 28
 Oct 2018 03:16:02 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MPUlV-1gBtey2MFd-004kXw; Sun, 28
 Oct 2018 03:16:02 +0100
Subject: Re: FS_IOC_FIEMAP fe_physical discrepancies on btrfs
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        linux-btrfs@vger.kernel.org
References: <20181027154555.GH16768@wantstofly.org>
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
Message-ID: <72a61025-fa97-131e-b428-9b1356a949bc@gmx.com>
Date:   Sun, 28 Oct 2018 10:15:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181027154555.GH16768@wantstofly.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iUzl5hEEYOFvh2WVMgCG7cwzhO2BDP5hq"
X-Provags-ID: V03:K1:z/IXKOApsRdtEVvOjQxCu9LoSQeEWhxLQvulNd1awJH3RzB7a7r
 nGfbCXULOsnczd0ve8sW4XtV/heSCWfRJGEr8J3N9OweVnsLHvSr2VakyrHiISGXq/Ef+ta
 V7xp9kWXdmhTmt8SpmwKaKY27pcIhlXJMzJtsqqn39OzwvR5AfJ/PgbJIVa6uq1YIgtJ11i
 CfaRJHToGVr9Wd6O+Goog==
X-UI-Out-Filterresults: notjunk:1;V01:K0:I0EYBt5qRcg=:q9It4IBFKjykFN9SKPeWKI
 FyLHaxfkQqTMUgfBMJIYexD87tOv0+j9x95hp2Ov8DuHwiChHaSyAjIKi41ghSzUyw7xhWfwT
 lz/TAM8I/y15O/Lp3Ju1tGsoJgt+H1ykxOhBJGaow6saOMTt62vF5ejlCJSRK1WmQgHkkiqfc
 vZ9+74lzEQFrdzOj+zh8dUIo+x2Rv5/QdSD/m8tnOsuy4nhce+XV6ywOON8dxCWdjeQViakSI
 crHSVDmoC/fX9whRQvY7MeQWo5eSIyNtu8cNBONTJduFuoTMcw9fS6M/0XSnxsBh5SHfQFb/7
 /JeQ6dw4XvSUhSai4ExVi5vofvPAAq08nWBH+FmUpUuUcsf5BMky8Iu3AFBy3O3PmQ75MVE7u
 /X2O6uDshlUlu9q1jtQ499ASSiQ0s0LUy7kNJxKVTBAMFWeSfWf73H66Zz+szC+A+Cjn7SBOi
 8q4GwdF85TC+JZwy65Mrh1Sl5lx4Ljaev21p/SR0rbE7UKMrI2vR1REA0B+WQWuVs06+Lzp6u
 QiSaW8ywYWig4sgS9QThFbqQKdUr8FB0UFjinLVuLjW8WHSfc0lhEAiF3iBdspxzlcrgKm+gy
 ut5ebD58I6wW9jyN6CL4X/vLWhyYybWgjXijQ9AessoHlc5qzDZqlyW45uNIiomj3Tk8IYs9h
 yS1BBL0BEYy+/DeuufLUupalAnRaislx//lzIKh+bKNQ6JXubTNzBbupFJ0Fkx7G+YBxajNYN
 w7NTh+uaAfPjEzI94bhCqCfkBRPlZJV3BLQq1cxvHyeVZtL9zZGoY0RXdkHZ9GuIKgaOEEmF1
 uWF8PD1h/vkIb6FrbC+zbYOG1RceQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iUzl5hEEYOFvh2WVMgCG7cwzhO2BDP5hq
Content-Type: multipart/mixed; boundary="XrbHvBlZk71peiFpjHq4zzS7R3w3WZGrH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>, linux-btrfs@vger.kernel.org
Message-ID: <72a61025-fa97-131e-b428-9b1356a949bc@gmx.com>
Subject: Re: FS_IOC_FIEMAP fe_physical discrepancies on btrfs
References: <20181027154555.GH16768@wantstofly.org>
In-Reply-To: <20181027154555.GH16768@wantstofly.org>

--XrbHvBlZk71peiFpjHq4zzS7R3w3WZGrH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/27 =E4=B8=8B=E5=8D=8811:45, Lennert Buytenhek wrote:
> Hello!
>=20
> FS_IOC_FIEMAP on btrfs seems to be returning fe_physical values that
> don't always correspond to the actual on-disk data locations.  For some=

> files the values match, but e.g. for this file:
>=20
> # filefrag -v foo
> Filesystem type is: 9123683e
> File size of foo is 4096 (1 block of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: f=
lags:
>    0:        0..       0:    5774454..   5774454:      1:             l=
ast,eof
> foo: 1 extent found
> #
>=20
> The file data is actually on disk not in block 5774454 (0x581c76), but
> in block 6038646 (0x5c2476), an offset of +0x40800.  Is this expected
> behavior?  Googling didn't turn up much, apologies if this is an FAQ. :=
(

Btrfs uses chunk map to build a logical address space.

And all bytenrs in btrfs are in that logical address space, not physical
disk bytenr.

So you need refer to chunk mapping to get the real on-disk bytenr.

You could consider inside btrfs there is another layer like LVM, and
btrfs is on a super large virtual device.

The result returned by fiemap() is just the bytenr in that virtual
device (LV).
For real on-disk bytenr (PV), you need to do the mapping calculation.

Thanks,
Qu

>=20
> (This is on 4.18.16-200.fc28.x86_64, the current Fedora 28 kernel.)
>=20
>=20
> Thanks,
> Lennert
>=20


--XrbHvBlZk71peiFpjHq4zzS7R3w3WZGrH--

--iUzl5hEEYOFvh2WVMgCG7cwzhO2BDP5hq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvVG90ACgkQwj2R86El
/qjzdggAiXIIFe+NR8oh7HpmE2SfHxX7blZVYOx9P9/jmUmqbg+XFtYtJrFtIx0P
ZycCw5nMnUhvpSzcY/i57fKI4waORxIhBb5OuohkDtledOjFg+/vq3LsDFLrKrQo
FSoeTp/gzfJAwbW8ILa1snC3aT1YMJf5QWIjNzKBCjRHK2YMF75Tl4UZKuhkcUz9
15AfncAje3c5mhWNFb9cnyNZXM+tDlvoDOcUyNQWIE4XS0B0pmnOJeB1CFFRALEq
tIPetm0R8iE2WaEXB9eJj0xPen0DdIWF8qOvIYXshEnsjPoOPVW/+A6TkVkJh4il
OhPNIJoE3HOcOx7RVBE7NA4xIaYr+g==
=MDaB
-----END PGP SIGNATURE-----

--iUzl5hEEYOFvh2WVMgCG7cwzhO2BDP5hq--
