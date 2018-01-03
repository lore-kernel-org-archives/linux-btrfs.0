Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49933 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752133AbeACKZn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Jan 2018 05:25:43 -0500
Subject: Re: Kernel crash during btrfs scrub
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <3e11c358-c18d-684b-f5c7-a09f78bc7b07@mail.ru>
 <dd8cc8ea-1a3d-ee75-ab75-0cc5802f33d4@gmx.com>
 <b5487ea9-59c9-0aa1-a717-dbf78f14f515@mail.ru>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2c43d4b7-9303-5c99-ab64-fa6dc2be73a1@gmx.com>
Date: Wed, 3 Jan 2018 18:25:36 +0800
MIME-Version: 1.0
In-Reply-To: <b5487ea9-59c9-0aa1-a717-dbf78f14f515@mail.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Hrfews25GNCcjwxyMQhgOXsd1x3Tkd58d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Hrfews25GNCcjwxyMQhgOXsd1x3Tkd58d
Content-Type: multipart/mixed; boundary="l3S1sbyPNa0X89fRJe5zFcb3GSynM5FBT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2c43d4b7-9303-5c99-ab64-fa6dc2be73a1@gmx.com>
Subject: Re: Kernel crash during btrfs scrub
References: <3e11c358-c18d-684b-f5c7-a09f78bc7b07@mail.ru>
 <dd8cc8ea-1a3d-ee75-ab75-0cc5802f33d4@gmx.com>
 <b5487ea9-59c9-0aa1-a717-dbf78f14f515@mail.ru>
In-Reply-To: <b5487ea9-59c9-0aa1-a717-dbf78f14f515@mail.ru>

--l3S1sbyPNa0X89fRJe5zFcb3GSynM5FBT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8803=E6=97=A5 18:14, Dmitry Katsubo wrote:
> On 2018-01-03 05:58, Qu Wenruo wrote:
>> On 2018=E5=B9=B401=E6=9C=8803=E6=97=A5 09:12, Dmitry Katsubo wrote:
>>> Dear btrfs team,
>>>
>>> I send a kernel crash report which I have observed recently during bt=
rfs scrub.
>>> It looks like scrub itself has completed without errors.
>>
>> It's not a kernel crash (if I didn't miss anything), but just kernel
>> warning.
>>
>> The warning is caused by the fact that your fs (mostly created by old
>> mkfs.btrfs) has device with unaligned size.
>>
>> You could either resize the device down a little (e.g. -4K) and newer
>> kernel (the one you're using should be new enough) could handle it wel=
l.
>>
>> Or you could update your btrfs-progs (I assume you're using Arch, whic=
h
>> is already shipping btrfs-progs v4.14) and use "btrfs rescue
>> fix-device-size" to fix other device related problems offline.
>> (Not only the warning, but also potential superblock size mismatch)
>>
>> Thanks,
>> Qu
>=20
> Thanks for reply!
>=20
> Why couldn't a warning message be issued as one-liner, e.g. with proper=

> description and without scaring stack trace?

Because we're using WARN_ON() and the backtrace is in fact very useful
for developers to locate the problem.

For one-line message, the problem is we don't know who caused the
problem if there are multiple callers.

But since the cause of the problem is located, one-line output seems bett=
er.

Thanks,
Qu

>=20
> btrfs /dev/sda1 warning: device size is not aligned with FS (mostly cre=
ated by old mkfs.btrfs), see https://btrfs.wiki.kernel.org/index.php/FAQ#=
=2E..
>=20


--l3S1sbyPNa0X89fRJe5zFcb3GSynM5FBT--

--Hrfews25GNCcjwxyMQhgOXsd1x3Tkd58d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpMr6AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qionwf9EhZ3Q6KGz3LmXUmChudDJCYP
Ner38pCZ1dXOBBDCGeKJGfLGMKtigXPWspaTWV2uFeqGMiW4zc8qvc7trCK+GIRa
pEU4Ue2L28JZtFom9fx1eEa2DJkupbSfgyLI03g5WFu0ZfjxltJ6kQcpzuuo14B+
ArLXFAWu3SHoxBWnqjCqYTP66mtkSlrXncmQmXKna+GJEtVVC0I9Qhn5ZZiXyMDY
/XTpVwHd1kz00wmxvYXzkCelk0VKI/BnWRDt2yZcASgwF1hYyC55ASAbxnAc1mLb
lxMpUf9RNOlW85KBDlg/AZQZNsO4vYGp6rcA6zgry+YidKF+8OPdJsK7Fv2Zsw==
=CLsW
-----END PGP SIGNATURE-----

--Hrfews25GNCcjwxyMQhgOXsd1x3Tkd58d--
