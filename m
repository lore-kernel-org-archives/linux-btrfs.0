Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C5AC04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 11:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A15420834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 11:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A15420834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbeLCLfq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 06:35:46 -0500
Received: from mout.gmx.net ([212.227.17.21]:60011 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbeLCLfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 06:35:46 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MfBsk-1gsakw1rEg-00OqkK; Mon, 03
 Dec 2018 12:35:01 +0100
Subject: Re: Filesystem Corruption
To:     Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>
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
Message-ID: <f3662eec-3241-dc3e-7bcd-3d5b148d6e96@gmx.com>
Date:   Mon, 3 Dec 2018 19:34:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BRyCGcwSpSxHJ9oSBm4HTndLqdtAVsrN8"
X-Provags-ID: V03:K1:rH4hqd1SfZR4luvXTwxAz7iVbvWnGN3ty+HehvB4+0h+xsJ/kQg
 QVLE89atfVxM8mxBwgU0jbTIBQdVHdXNSQdLttV+8Xg3P98LOsHc+Z0lnx7CctgBk1UDeNe
 fTktGC2wub5EN2AxR3E1FWjBUx0s76QjfhwRL8285WD9+4tZPJhzbvln0bis5jbZE9/pDNE
 DIPKYGhcPoOe+DLcP04tA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nKRbs0qQh9k=:OUY9+twRUWLEVpd0VQCwSA
 F1YvHCDx7NXzRg5+Y8TmjC3t6lCEtCcofaVsJ0q7omeZDuyu9vecle6zp+dTqil2W9wPwTBXi
 XzuDwuImRdzCXG1YZO3py6BBjpwO8mo5lfXyn/PriPjl6AJHZeA6uJxMmu+x394ZvAEiJfo+p
 wM4SRhfZ1XSkHIujWKTmWRKR2X4+6Kt61jAo54tqsgTFdIcXCCsNWsUMvLzm27VAj/EyhsEC+
 OGeB3pAtZyvakk5Xnz8QS1WombWIj1C2oa/3wdOIlsNN1wLd9JohpOUSPMSt0eVj8axq8Eecc
 IMOePuzw01iaJmxnIFSXoJiHzHpmYH/QMn4ZTgmYaD9XyyJ7nzwtb36Woz4WJlFnDtzmVkdCU
 RqxMLeSVU294sG82ck998k9XOVv1lRp0yimcWX+j3ruBvdQrGsIV2n4pP820nAcpFVOTPDV5O
 su/u1QXY5Des5tEwSB6dkuw5yI01UH1Sh3K/YVRllAb787xPIH4M7LcTjr5BmiCL2EZAEdZpq
 VNii5/9jinxRNlVTdbtj+oKpPxung+SOeUc9X1HuCPX7bS0BC7132Bi72IYui/fOgAbQq9php
 vdgGhIjLVQdcThLRyGOVpnQT3LcO0m1QIZpXPnxlyHwmvmVXMaxeko0adNIN13w1p/5wnKryz
 BLheAUyDV73VZ2lrmTlih1jxLuw4LivXDfOQP0Gk7QRKnwaYALqmI21OFCU0AJ4HiLbpZNY5o
 kNix932u5NLdajGicqZtQLRqwSgfxnsdz62UZYNhoYzDFojZ20aGl5+0wnIRVsRWuZYmRWSZs
 gl+Azo/45o4WitBIFf7Ly5WD20aDDyjaXgaVke+3r2tDPoYpe0npVpGZDp9/Q9FRUoMls9T76
 j6VJbBT4Dyd8N6xKNa6X3AzJFlDugo/kchj9LP/jXety3bkPMXUgBv6dmVCHJl
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BRyCGcwSpSxHJ9oSBm4HTndLqdtAVsrN8
Content-Type: multipart/mixed; boundary="TgNkyJZJIzXclR6Hamw4MCpvPxZwDoFAJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <f3662eec-3241-dc3e-7bcd-3d5b148d6e96@gmx.com>
Subject: Re: Filesystem Corruption
References: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>
In-Reply-To: <CAA3ktqmXjF0AFjtL55798c7DyXmWewjXBtM_FNoktH1aAtRoNQ@mail.gmail.com>

--TgNkyJZJIzXclR6Hamw4MCpvPxZwDoFAJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/3 =E4=B8=8B=E5=8D=885:31, Stefan Malte Schumacher wrote:
> Hello,
>=20
> I have noticed an unusual amount of crc-errors in downloaded rars,
> beginning about a week ago. But lets start with the preliminaries. I
> am using Debian Stretch.
> Kernel: Linux mars 4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u4
> (2018-08-21) x86_64 GNU/Linux
> BTRFS-Tools btrfs-progs  4.7.3-1
> Smartctl shows no errors for any of the drives in the filesystem.
>=20
> Btrfs /dev/stats shows zero errors, but dmesg gives me a lot of
> filesystem related error messages.
>=20
> [5390748.884929] Buffer I/O error on dev dm-0, logical block
> 976701312, async page read
> This errors is shown a lot of time in the log.

No "btrfs:" prefix, looks more like an error message from block level,
no wonder btrfs shows no error at all.

What is the underlying device mapper?

And further more, is there any kernel message with "btrfs"
(case-insensitive) in it?

Thanks,
Qu
>=20
> This seems to affect just newly written files. This is the output of
> btrfs scrub status:
> scrub status for 1609e4e1-4037-4d31-bf12-f84a691db5d8
>         scrub started at Tue Nov 27 06:02:04 2018 and finished after 07=
:34:16
>         total bytes scrubbed: 17.29TiB with 0 errors
>=20
> What is the probable cause of these errors? How can I fix this?
>=20
> Thanks in advance for your advice
> Stefan
>=20


--TgNkyJZJIzXclR6Hamw4MCpvPxZwDoFAJ--

--BRyCGcwSpSxHJ9oSBm4HTndLqdtAVsrN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwFFOAACgkQwj2R86El
/qgZuwf/UP0xUjhEAZpa9GaolpFE8riJSKp3rfAPaLZurTQWL7vUqO/HgERvH0Tr
YSf6dxACgHh/DosvSbd6oZXV5gIjz/IN+Fh0VFC99KMrUSmlajeKIWn5Z51X664c
4d9iTtUhnn9VCw5JkHbaghEhKh8Js9segf8FvSYh3/fErh7KZzqZJLFVGpZiHLak
02fXLUVE0MPjxcmQtQVvL23WTEbmnZtiY12V+nQXDn5NWCQ0QkSypL30azIK1AIk
Yv9k1j1IgkaoRqL/N0ASq3hdjf0u34Vpp9qGSdJFZ7Z9p03/iceV+dBikEXKA5Vw
q1vh4jOHPqehXReLp06HoRQ4i2OBsg==
=kvgo
-----END PGP SIGNATURE-----

--BRyCGcwSpSxHJ9oSBm4HTndLqdtAVsrN8--
