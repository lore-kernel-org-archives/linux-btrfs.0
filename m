Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04530C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 00:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC07E2085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 00:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfAFX41 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 6 Jan 2019 18:56:27 -0500
Received: from mout.gmx.net ([212.227.15.15]:54441 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfAFX41 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 6 Jan 2019 18:56:27 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MXZw6-1glKNE3Ksg-00WVOC; Mon, 07
 Jan 2019 00:55:59 +0100
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
To:     Giuseppe Della Bianca <giusdbg@gmail.com>
Cc:     Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
 <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
 <2025891.FNXETDMuRi@exnet.gdb.it>
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
Message-ID: <f441516a-7704-4e20-100f-ddd046b61be3@gmx.com>
Date:   Mon, 7 Jan 2019 07:55:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <2025891.FNXETDMuRi@exnet.gdb.it>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VFvJq3egEvwfz6YZd5et7LIeXfMvQiwPi"
X-Provags-ID: V03:K1:9DLoJslOF08hGLrSXaowR48/w0mBbF7Sd3guO+YZeVywjKZ4WQr
 IyPIwjBwILozTU3X0EOUU9mqjY1teE3qZmxb9Mv7/5M1aR7yvHP/1x9xLzUpemElG2icwk7
 Y7pOwsaIT/a+1VJBJwQtbHFwjWP1etC9cFSAnS6Eo+f41nb8vOaZs8cW03JuT+Uk16+ZNHX
 LAlLQL73TLhV+zDRxtuvA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XN5V3Za6ZWo=:rBvuFsSU/+5d17mP08YTPP
 t8hz2BGdiovxVAD5XWTXG22VYmFFVaFXni6J0OTLxMrd/ZYUt5HOnJiYdKJ+ENa74ZzyJgcan
 NyINVoxV7K6rrEC4/wHVJuJHQ3oryuTxZBmjHbaCVjqfKkE/W8yKzRMAeirOeQ39XauQUBNIo
 UpQvaFN0RWDg7V2jFbHlFMw9teM4k6tdS1UzO6euEKeattpYv2+72+fj8t6mWNC/qcJPxXHyx
 aRQ7auUgkG5ZMS/nRKh6dJduwaq9E8/FAVPcE2uYYSGG3WbO5Os357JbJ0GgDyYyqrymZPscN
 DehWkVf1urbM43oCjLIYTh3LMJ14HY47BaM96AxO+lK1hpsCWaZqCcTczsSFb2RcwA6mOA4hK
 z+Wkvya47iPY/2eTQLlWIEIZLoJTbZx59T11AJcbQ2Ly0mkAL2uAmzgNJX7eh81EiVQa5kWYn
 cFISmQS3adpweFzT/BV+5ujxZVCVF5XhiA2dGuGLwh4XBCsMxnVHeZtg1A6VnI4JORh/TUiCo
 JZqFEWjhf/cPUfXzuBXL7lPI2+oK2WTu35DUxRgY59h9QMvMgButO1muS5MtlbyRnhaYBzBVU
 u1jiG2s+4Hjxa5vzBrZvswTkJXgofjBwO63MXnzb08dPAJnl0Q5sarKX+2Zh0HAAoQSn1nNOE
 EhXQHr47uoKZp0lyyjSfW1e1CrSFoDlolm9IkBbODg21pLDSlJzxXsut9wJpLYJa92PJ01orj
 X49H48IN6p5RLuMfO8n7VfzLWD1cUFjMF2VrBlF1JYUf5UIzqIYCmEGjAZWnYoFDiVquCmzyD
 +HB8O/hm/B1ZUhGubqu9OMtLwdKR8zIj0WyPvWCuWkqVknHp8wgHCo8Xdy5WsuQyvqaplqWEF
 8AUDLu6dXHQGY4Gta/wHwm41hzsV6iuomSOxNMdHSCClpy1eNgCwNsTlzMRvez
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VFvJq3egEvwfz6YZd5et7LIeXfMvQiwPi
Content-Type: multipart/mixed; boundary="i9HiJBWyi9h9SkC9vC9dL1b8OvrfHV9hl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Giuseppe Della Bianca <giusdbg@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <f441516a-7704-4e20-100f-ddd046b61be3@gmx.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
 <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
 <2025891.FNXETDMuRi@exnet.gdb.it>
In-Reply-To: <2025891.FNXETDMuRi@exnet.gdb.it>

--i9HiJBWyi9h9SkC9vC9dL1b8OvrfHV9hl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/7 =E4=B8=8A=E5=8D=881:57, Giuseppe Della Bianca wrote:
> In data domenica 6 gennaio 2019 15:12:38 CET, Qu Wenruo ha scritto:
> ]zac[
>> Do you have a full history of the kernel versions?
>=20
> I believe from version 4.13.9 to 4.17.7 .
> Today I updated everything to fedora 29, kernel 4.19.10 .
>=20
>> I'm not sure when the corruption happened.
>> It's completely possible that some old kernel caused the corruption bu=
t
>> not exposed until now.
>=20
> I am quite convinced that it happens during the snapshot delete and the=
=20
> subsequent cleanup.
> And maybe even the umount is part of the problem.

No, I mean the corruption which finally results the hang was there for a
long time.

It's relatively common that extent tree get corrupted before and some
unfortunately operation touching the corrupted extent tree triggered
some user affecting error.

>=20
>> Also, would you please run "btrfs check --readonly" on the fs?
>> It should show all corruption.
>>
>> And if "btrfs check" shows no corruption, then it's completely a bug i=
n
>> that given kernel (and even current kernel).
>=20
> btrfs check reported various corruptions and fixed them.

Please paste the output if possible.

Thanks,
Qu

> A this time it seems that the filesystem works fine (it's the first tim=
e it=20
> does not have to be redone from scratch).
>=20
>> Thanks,
>> Qu
>=20
> No, thanks to you for your work.
>=20
> Gdb
>=20
>=20


--i9HiJBWyi9h9SkC9vC9dL1b8OvrfHV9hl--

--VFvJq3egEvwfz6YZd5et7LIeXfMvQiwPi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwylYkACgkQwj2R86El
/qgUKwf/YZfwCWjNv/OvQhA+KEVww4jkfYgJOrlEVfjqkulpO1mGo233ytnrHqh6
ZYVnABdfeqH1O24+jTGeKnGoWXMj/5viAUKghefJ4WIcvejR+IAROXaCKtCGXxL/
mzZapfsebncRSn489t/MibqY+4uetWzPSWEs4CYDv9FAuIxB+Dn/tLlXr+xp7AZw
O9LvPzBtdEeAid3jYjiaG73g0EcEq4UuzcSOnF+4BJEG0lKwduI6z91oBg6xJm66
AF141kv2UrSTZ7T1R33pu4PGrLEHXRCr7HlP/yXYZnCcoEW583T1G0MwEtc45uN/
RykZmqMNWP5B0j0HQos75IGRcWpKUQ==
=G21R
-----END PGP SIGNATURE-----

--VFvJq3egEvwfz6YZd5et7LIeXfMvQiwPi--
