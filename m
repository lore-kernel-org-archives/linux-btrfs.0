Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F94C28CF8
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 01:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54F472087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 01:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54F472087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbeJLJ0i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 05:26:38 -0400
Received: from mout.gmx.net ([212.227.17.21]:54279 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbeJLJ0i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 05:26:38 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LlGoc-1fZnFP2SwQ-00b3fQ; Fri, 12
 Oct 2018 03:56:34 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LlGoc-1fZnFP2SwQ-00b3fQ; Fri, 12
 Oct 2018 03:56:34 +0200
Subject: Re: errors reported by btrfs-check
To:     =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>,
        linux-btrfs@vger.kernel.org
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
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
Message-ID: <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
Date:   Fri, 12 Oct 2018 09:56:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="va02lMw720BnCQk8f0SHWTBdTaqOPnQwi"
X-Provags-ID: V03:K1:LrnXCK08bN6mdNJ2kV2a0KLtCzSUQ1zFh7qzGVKwbLn0eU8aZrI
 LIdwZ+bBBsvTSgy0MzPbR5kmzW2TKT1IAqHl62/BfZ0oe26XcUCNIAPQ3SA/5ACmfLMYN0T
 +NQbVQVDi+miUUyCZRGhmePJi65YvmwyII2Kl4QgmrigR3EqzjRx+RHkTJMJp4BfnZdN9d8
 nUS+ofDlsJuLyUgfqJTdQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:8YFdH9rj0eI=:pe47Z5vjOQ45LbM5rmxysF
 YDBV4k4rxrZMyDsdaHwRKA8luynoMs0g/qEV6UFptcz5OocXHvVclnzrtCIfAOultViqr3u9k
 gsuAATeo7fsPU+okf2G6pnDL1IqQtd1CxkLUbArv4SvFiw0QVSJw4ajYoPsSFZQ/7TN/KRx7X
 ltjskmMJNf4dScIuVR+s2jur7XIIrS0LibI9VMYwYp75ESxpLLPqPgrp6kee7Zis9wpSCzwLE
 GkhdagmgYAwfalwe8+SmjvnTvSw87TU5Yp8dSxS9Aomhjo+OrJZNiTEkHJeBXPWLn7wFv4Hni
 tHekLKeB4phXlFAVEFkPAESIb7uW6zylu01VxmjFORxn5dJOV07uplvXWqUOLOcyZE5HBJSZa
 iCM80XqQ+TJv3ax23j25syhYACuiemm6VY1o9PuDrqXsn6Dba1zwX0qSUHZ3o805NNlbxId1p
 sudYvcG22Bav2YY7iEzBlhvRyHZW9nQDucT56oVdOgL52iOuoSaLtsgczoxa7krxiSAo/BPz6
 wLrNGNAiYzPyLuOz7akSantFGPA0lL8oBbByxQ05G7NrCatelgMhlPqvLeGY/qiqyr/ztM3wN
 rVbacU8Y6R4IT0TKBNoc9rPN48dZCQkM0ZiSHce1icQweUhTW2xUnIO1UlDhaSYewEpnyPRHH
 ca3P2FkTzTgYUQWJa0t0jlZ7CxgrUkxtO7opZmIHG2eJrAb0RyqSial3bQ1Talj7BTpuh78FV
 Zlhzeps7501HtHoQfdjOTU079OT6dBEuEXEBI77ELjdTGwOLPVHhNJ8emFIdQR2ifMM8gLZgs
 ZzPvJHkffrZ6n5LC23luhUF+Mp1Rw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--va02lMw720BnCQk8f0SHWTBdTaqOPnQwi
Content-Type: multipart/mixed; boundary="VBAcWOvvgqT6PXmRjNHMmTOe9PW6aFWTU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>, linux-btrfs@vger.kernel.org
Message-ID: <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
Subject: Re: errors reported by btrfs-check
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
In-Reply-To: <4610292ca252e23c9da2791ae1acf194@t-5.eu>

--VBAcWOvvgqT6PXmRjNHMmTOe9PW6aFWTU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/12 =E4=B8=8A=E5=8D=884:30, J=C3=BCrgen Herrmann wrote:
> Hi!
>=20
> I just did a btrfs check on my laptop's btrfs filesystem while i was
> on the usb stick rescue system.
>=20
> the following errors where reported:
> root@mint:/home/mint# btrfs check /dev/mapper/sda3crypt
> Checking filesystem on /dev/mapper/sda3crypt
> UUID: a914c141-72bf-448b-847f-d64ee82d8b7b
> checking extents
> checking free space cache
> checking fs roots
> root 258 inode 3082368 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 258 inode 3082370 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 258 inode 3082371 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 258 inode 3082373 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 258 inode 3082414 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 258 inode 3082415 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 258 inode 3082421 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 4096
> root 1387 inode 3082368 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1387 inode 3082370 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1387 inode 3082371 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1387 inode 3082372 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 8192, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 16384, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 24576, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 32768, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 40960, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 49152, len: 20480
> =C2=A0=C2=A0=C2=A0=C2=A0start: 73728, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 81920, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 90112, len: 8192
> root 1387 inode 3082373 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1387 inode 3082374 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 8192, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 16384, len: 20480
> =C2=A0=C2=A0=C2=A0=C2=A0start: 40960, len: 12288
> =C2=A0=C2=A0=C2=A0=C2=A0start: 57344, len: 4096
> =C2=A0=C2=A0=C2=A0=C2=A0start: 65536, len: 8192
> root 1387 inode 3082380 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 233472
> root 1387 inode 3082386 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 4096
> root 1387 inode 3082398 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 20480, len: 16384
> root 1387 inode 3082414 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1387 inode 3082415 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1387 inode 3082421 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 4096
> root 1391 inode 3082368 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1391 inode 3082370 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1391 inode 3082371 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1391 inode 3082373 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1391 inode 3082386 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 4096
> root 1391 inode 3082414 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1391 inode 3082415 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1391 inode 3082421 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 4096
> root 1394 inode 3082368 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1394 inode 3082370 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1394 inode 3082371 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1394 inode 3082373 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1394 inode 3082386 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 4096
> root 1394 inode 3082414 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1394 inode 3082415 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 8192
> root 1394 inode 3082421 errors 100, file extent discount
> Found file extent holes:
> =C2=A0=C2=A0=C2=A0=C2=A0start: 0, len: 4096
> ERROR: errors found in fs roots
> found 469458231296 bytes used, error(s) found
> total csum bytes: 451180560
> total tree bytes: 4558831616
> total fs tree bytes: 3802955776
> total extent tree bytes: 245055488
> btree space waste bytes: 842802897
> file data blocks allocated: 9656815640576
> =C2=A0referenced 929225080832
>=20
> Scrub completes ok though.
>=20
> I'm prepared to wipe the fs if needed, more than one backup is ready :)=


No need. File extent discount is not a big problem.

It only means btrfs lacks some hole file extent to fill the hole.

It can be "fixed" easily by enabling no_holes features:

# btrfstune -n <device>

>=20
> I wanted to ask here first if I should attempt a repair.

And of course, btrfs check --repair should be able to fix it.

Thanks,
Qu

>=20
> Best regards,
> J=C3=BCrgen


--VBAcWOvvgqT6PXmRjNHMmTOe9PW6aFWTU--

--va02lMw720BnCQk8f0SHWTBdTaqOPnQwi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu//04ACgkQwj2R86El
/qhZfAf+IEMX/7sMfzROMEbZRXluNiu8Q8tMsjZCsL1eOqOpIKZo25haWwj8ycv2
8xEcWPC8teWdMbXeOD9c1+Re7TzaqdKul0OO44G6nhAAqthSEIhjRq+orCpcrM7m
ePf7FmdV+EWP9XURCZ7unntr5n+dwgYC032l3dNd436FlHSYzFp3mJMKeCkM7Kfy
t8j21JK6REz8/X9cJxTaXjlmsfYl6VhSEFDLT6VrotN5v/KhsqrLpMF+79ZtLa1k
8FxIxwopnzYWbxXhhCuW1F+p9zemzzZPHhq8fJYypNeZd1ewRaTxGH4e9VE9fYnI
LgjMD77T7GHledT0FiXRIzH3i/Fj7g==
=FHZJ
-----END PGP SIGNATURE-----

--va02lMw720BnCQk8f0SHWTBdTaqOPnQwi--
