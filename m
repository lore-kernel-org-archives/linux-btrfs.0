Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75750C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 11:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B56D20868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 11:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B56D20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbeJLShs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:37:48 -0400
Received: from mout.gmx.net ([212.227.17.21]:50583 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbeJLShs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 14:37:48 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lz3JU-1fXJDX3n5E-014ED3; Fri, 12
 Oct 2018 13:05:48 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lz3JU-1fXJDX3n5E-014ED3; Fri, 12
 Oct 2018 13:05:48 +0200
Subject: Re: errors reported by btrfs-check
To:     =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>
Cc:     linux-btrfs@vger.kernel.org
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
 <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
 <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>
 <979a7a81-6ffc-b0b9-abf4-1ad1ecfcbcd2@gmx.com>
 <1707cc15134893e4518115cf9ab42df3@t-5.eu>
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
Message-ID: <b3ab2b2a-e2af-f4ec-5cc3-6cb52c217274@gmx.com>
Date:   Fri, 12 Oct 2018 19:05:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1707cc15134893e4518115cf9ab42df3@t-5.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="I2B2R7t53WMlUeMQbSRz36Zp07NffGS9M"
X-Provags-ID: V03:K1:VyWg1I5AKwOAdESw8bt9UPrwslTlTRf+poY8g00R0aUXhlKN5mi
 lfSmhgpySDfjUV4lzAG+V5qV8QJ+mzzgdkaz2JNHHTw/Zo/9c9uF29318kEDAT1mtNlwnWE
 /BznhWCAoPn1aJhdq+8DK9lG25754BkbMlvh+Fi5wssMhE8QpoJZSVa26hcjCHJMyxvXnK/
 Y68r5abs9P2W0/g7z8vlA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:kQYQuXREFac=:+iRAwsb6hfQHPi04buoB8m
 JCx7acO/WZ9M6jQPFzJVKRR0L+MsFUR8Fv0/WRISig2qSIy9qOMKZEQH6v0NGuBltGl/w2Oc2
 wH0U5ceP9lUVp9F4GgFQhP4YL7LL5/K1QwN96W07W1wPG+STFgV+zyroesGOb0Rme3qL0b/9c
 H51LuoyU5cyc21DDl3YneUDKv5/R4cjTIzRcF2jfQeX4K8qyy2ZvN8xTqDMhudkGk73o795wT
 kzOxLYah9zCWe3ULO4M4Fp0xGImzaBhBz29eepeiRBJOj93MERI0lcGiASID2gKayaAnkKK5Y
 wenmT0uhvQAHNw3owbDIeR3XArHC6fiQGE1lDKqmulmr102XD913KUR9JibTllaOK/PPWXl/M
 FFYujsTbTceM8FvmvWB1nG+b9/wtbJ1e0wnoTntEJ//GtxMOqmXJ8ywwt5Yv5PFjU+PjFg/4z
 f+h/PQFyRVdD+n/tsy2sAiIVe+x+BxgRf7mH6Q6VjcHTZyaDRz1klSFJJ+Q3mHUABTSmSMa3B
 MjyPI/2Fjlz+8GcCew8MTe0O4H2plORtO//cTtTgXAvjn28ijfhf1gLgb+SEg9WjGyn5aJm04
 QfB/J4ydS4AoAghWKBisLa0c4fmWEToZWmkwDRdJbWjU7rvtTTTlvrnFTm2ndYaf6tZ0nzYUw
 YpflG7BLLT6X9Q0ItD+waLzVKIS7ZXqKuPByHwMZm41uWc4+deH/3L/Ar+O59BYXm8qHoIE7d
 dCejMOMNQytZqgEoUvMjHlMtN09cO7LPJn82TqoJ3Dii/fcz/gXK/rZx3IBzirWXWooWXH/TP
 4weSwSFVKTOZYIFHsa+u66t2oNECg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I2B2R7t53WMlUeMQbSRz36Zp07NffGS9M
Content-Type: multipart/mixed; boundary="NDsecoiHKIenstUlwzMznSgpbZaY5y98u";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <b3ab2b2a-e2af-f4ec-5cc3-6cb52c217274@gmx.com>
Subject: Re: errors reported by btrfs-check
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
 <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
 <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>
 <979a7a81-6ffc-b0b9-abf4-1ad1ecfcbcd2@gmx.com>
 <1707cc15134893e4518115cf9ab42df3@t-5.eu>
In-Reply-To: <1707cc15134893e4518115cf9ab42df3@t-5.eu>

--NDsecoiHKIenstUlwzMznSgpbZaY5y98u
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/12 =E4=B8=8B=E5=8D=886:35, J=C3=BCrgen Herrmann wrote:
> Am 12.10.2018 10:19, schrieb Qu Wenruo:
>=20
> [snip]
>=20
>> Please run the following command:
>>
>> # btrfs ins dump-tree --follow -b 166456229888
>>
>> It could be caused by the fact that btrfs-progs --repair doesn't handl=
e
>> log tree well.
>>
>> If that's the case, "btrfs rescue zero-log" should help.
>>
>> But anyway, feel free to re-create the fs if zero-log doesn't help.
>>
>> Thanks,
>> Qu
>=20
> First of all, thanks for your help!
>=20
> Did that:
>=20
> root@mint:/home/mint# /tmp/btrfs ins dump-tree --follow -b 166456229888=

> /dev/mapper/sda3c=C2=A0 > /tmp/btrfs-ins.txt
> parent transid verify failed on 166475366400 wanted 127054 found 127060=

> Ignoring transid failure
> WARNING: eb corrupted: parent bytenr 166456229888 slot 22 level 2 child=

> bytenr 166475366400 level has 0 expect 1, skipping the slot
>=20
> The created btrfs-ins.txt is ~300MB in size, so i did not attach that
> here. do you need id? then I can upload it to my owncloud and post a
> link here.
>=20
> after that i tried to zero the log:
> parent transid verify failed on 166475366400 wanted 127054 found 127060=

> parent transid verify failed on 166475366400 wanted 127054 found 127060=

> Ignoring transid failure
> ERROR: child eb corrupted: parent bytenr=3D166456229888 item=3D22 paren=
t
> level=3D2 child level=3D0
> ERROR: could not open ctree
>=20
> mounting is still not possible:
> [ 2726.355134] BTRFS info (device dm-0): disk space caching is enabled
> [ 2726.355138] BTRFS info (device dm-0): has skinny extents
> [ 2726.395638] BTRFS error (device dm-0): parent transid verify failed
> on 166475366400 wanted 127054 found 127060
> [ 2726.395647] BTRFS error (device dm-0): failed to read block groups: =
-5

This means the extent tree is corrupted.

This is not a good thing at all.

Please go ahead and recreate the fs.

I'm not sure how is --repair contribute to this bug in current stage.
The biggest problem is, after your first --repair attempt, it doesn't
report any extent tree corruption.

> [ 2726.451907] BTRFS error (device dm-0): open_ctree failed
>=20
> Anything left to try?

No, please go ahead to do what you need to.

Thanks,
Qu

>=20
> Best regards,
> J=C3=BCrgen


--NDsecoiHKIenstUlwzMznSgpbZaY5y98u--

--I2B2R7t53WMlUeMQbSRz36Zp07NffGS9M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvAgAgACgkQwj2R86El
/qgonwf+LOCVxbn+prTArgW4OJURR1ZSPeFaRroLsKJfF/4HuyqWDXhfoAKTmhxD
kLJ1keUcKb5cfbk4P1NYUKaWrHzQx+Y3WZCDLsiotEtjmQtTMMeJM02CLRsZ0G4F
wtGLeEYELmwx0EBQqVnRXtJWzyE4zlAuYaFwfWh1saqTPx0rNoHUNzq504AA6Ol5
mBlBppd5tEoXermsRm11W2ZdiBZUNtoAy2y6isTW/GcGBkQTwf60qnoErPP20jnw
6K+knA5Zo6b9k/QsEiVIv1Kf/JYn/dzRDc37oGmzAPZd5VxJsdjLMqAQm1ZpmjYR
n1VeIqHiXPfHM5FUjBTVpKfyrLoIrg==
=zyzi
-----END PGP SIGNATURE-----

--I2B2R7t53WMlUeMQbSRz36Zp07NffGS9M--
