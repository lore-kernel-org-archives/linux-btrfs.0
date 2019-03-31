Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B451EC4360F
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 12:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BE452086C
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 12:00:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ikF0SB8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbfCaMAq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 08:00:46 -0400
Received: from mout.gmx.net ([212.227.17.20]:37663 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbfCaMAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 08:00:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554033642;
        bh=k5mkvLntIY2H33RZsFwWRP38H5JmuWmBJ2xbuQM3Vpk=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=ikF0SB8SpkXdhl/lDCPE+b0L6jsnxZUWY9SWrdFQ8hwgcGoQFwDEr0Rn2q8pQz8Gk
         Y6bS0CxuY1TzrXNd7kT5m/ga7IKKLesPyIfkVhFFrT4TZDWZhYvKUlxY8ueDAXglfi
         PhVWJEkaD82CrpLiCmq9wxtZY58wqbPdqXGlwpak=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lq9Ma-1gfeAr1jn6-00dqxP; Sun, 31
 Mar 2019 14:00:42 +0200
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Alberto Bursi <alberto.bursi@outlook.it>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
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
Message-ID: <371167e3-b1d1-48f5-e8a3-501cc41bddf6@gmx.com>
Date:   Sun, 31 Mar 2019 20:00:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q9zkLup2XwznxS4PM0y51auFweXQFMLhx"
X-Provags-ID: V03:K1:qecvgJSWo+srSBTIqthwiIoxH5OXC+2H3n5ijpNpGolYiJCC0TQ
 7gyHpf/qxSL9EhTEPYI5glsm1Ql+5DReRm5P8taSenI2NymLpXd5RrzGz2kYky88pSWWVY9
 AqJbMgH+rApbb4YVJU0Iac2sRaBFXubAI3lO7n4+ZlT6mw/yBPmOm8CYygv7GS4368sHKRV
 tzjA4obKwrKIF59LlHl1Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JXbDVuB4bPg=:tk4/Knd6wquDsBu3PWc6HP
 ur+sfOGIDw08+OFtxJ9LHg898dEKvB/JlOn2/II37i+gJIBSlTCvGFiNZPojZiVr0tSBfv7JO
 LqjjdaUPonFkySE4VNHSHyT9TdKPuvWv59AGjsco/Xc/evHR2co4/Xf774x2PgM34NSaMsGGd
 aD5cHVq5fzugWa5aH62fcb8RAkaY5S/29rRgi+VjZOej+ivtG4tMR+VjW5IgYbY23eumGfGEs
 Qa1TlT3fdms+9pdFX8tfYWWvXRw5CPB7q8Q7rGY7mJw/svGPAwjWCtY+XijaEAou4sjSYXMoK
 PItT7HQ548RXUgMdFae2/wItH0TKRdpoS7GlCAQuj+c9I+L2Yoeeq2OfDDpLISo4JVNJslRfg
 O7knB4fLORKocd0B8kcQbWkrneZty7Cp2TbQlX+CxD9f7xgV7KZuPl4qWM0GrB3SVqUZIdjt0
 Slb3LbyAIWgvnOwZiAx3H25lQgwrlsKN9BaBfd6UhYY4yIg/MDSDQho2WaajKoc0gGuy3FEAJ
 1PqIbOdCrc7c9+Z/LbKILqM5PRuAjTKWKJv+j3HemrhweJlFITdDTDvnF92ejBHwl3lbb02SY
 3yc/oIu77U2UrKxX4LneZkMXzpBfnMaC05F1QQDHWTb31lI2THdKArcZGdcjmPiFLIbf35OW6
 r37qknytHEr6G7seCW5JoUZGqAJO+NCBNKCbzQo252NxQO62B/eF4Aeo+2D8/P6v4QVyYoNF4
 nipDDqb275Q6Q9xpQ0h22t2AXgnENLL2SpDsqE63KFbZWR+1aOjrW0jVZPK9SEJdLnGDlVzMx
 2U8RsR3DKxjQJOuOPOqi5tiYq4W4aoKhq2W9DtZLX6siBUqUnpdadrSGsh19JooY/RnIK5TUi
 m3ACL2HTExUPrugbZTFBFLSBMGCABNAJGt/12JE1vVKI6JRA/856ZLzziqM+DMDqTZU0Nrls+
 DmsfzO8E4RFixWVvoTiIzFuHC1eE+Dq84YAiYBrhIozOMXZ63rMT+
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q9zkLup2XwznxS4PM0y51auFweXQFMLhx
Content-Type: multipart/mixed; boundary="ytWfEIWV3UfSMJ6b0TIo7ywH7CUvUtreD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Alberto Bursi <alberto.bursi@outlook.it>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Message-ID: <371167e3-b1d1-48f5-e8a3-501cc41bddf6@gmx.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
In-Reply-To: <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>

--ytWfEIWV3UfSMJ6b0TIo7ywH7CUvUtreD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/31 =E4=B8=8B=E5=8D=887:27, Alberto Bursi wrote:
>=20
> On 30/03/19 13:31, Qu Wenruo wrote:
>> Hi,
>>
>> I'm wondering if it's possible that certain physical device doesn't
>> handle flush correctly.
>>
>> E.g. some vendor does some complex logical in their hdd controller to
>> skip certain flush request (but not all, obviously) to improve perform=
ance?
>>
>> Do anyone see such reports?
>>
>> And if proves to happened before, how do we users detect such problem?=

>>
>> Can we just check the flush time against the write before flush call?
>> E.g. write X random blocks into that device, call fsync() on it, check=

>> the execution time. Repeat Y times, and compare the avg/std.
>> And change X to 2X/4X/..., repeat above check.
>>
>> Thanks,
>> Qu
>>
>>
>=20
> Afaik HDDs and SSDs do lie to fsync()

fsync() on block device is interpreted into FLUSH bio.

If all/most consumer level SATA HDD/SSD devices are lying, then there is
no power loss safety at all for any fs. As most fs relies on FLUSH bio
to implement barrier.

And for fs with generation check, they all should report metadata from
the future every time a crash happens, or even worse gracefully
umounting fs would cause corruption.

Thanks,
Qu

>=20
> unless the write cache is turned off with hdparm,
>=20
> hdparm -W0 /dev/sda
>=20
> similarly to RAID controllers.
>=20
> see below
>=20
> https://brad.livejournal.com/2116715.html
>=20
> https://queue.acm.org/detail.cfm?id=3D2367378
>=20
>=20
> -
>=20


--ytWfEIWV3UfSMJ6b0TIo7ywH7CUvUtreD--

--Q9zkLup2XwznxS4PM0y51auFweXQFMLhx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlygq+EACgkQwj2R86El
/qiVDQf+IPEssw2chE7hAEdaL13eLLIbRmFlhULPKD58fb6Fb3Ip+R5fpbK2Ufzi
RLJBSxOAqUed1uIawy4vo/wQJJiZ630cjq8lBMPj0PylveGwfVgQbwP4QB6NDMw8
1tyW/UVghQ7+vU98bRSHWbE6XQnvy7ON6Xsvraya/cU3UjzJi7eyOCKIqVvEsVp+
M4R3IREA1pDkQuREQOtIWJ3ERqvO5sX3tV+3aH+QwZXOTh6mVFgdnsY4vFCfemsn
1kXgx29wvQ8mI9c8T2gGt7P3Lnslz1mVBTv5r1teNqu2fmFSrgpOvdIqsHjWCkTO
hrS5QpSlvOrAch5cvqhRChoJQEpRPg==
=wnhl
-----END PGP SIGNATURE-----

--Q9zkLup2XwznxS4PM0y51auFweXQFMLhx--
