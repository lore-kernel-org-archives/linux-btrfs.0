Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FCAC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 13:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 057FA206B6
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 13:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfAGNba (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:31:30 -0500
Received: from mout.gmx.net ([212.227.15.15]:57889 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbfAGNb3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 08:31:29 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LsChr-1hR56113KJ-013tST; Mon, 07
 Jan 2019 14:31:27 +0100
Subject: Re: Fwd: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz'
 can hangs.
To:     gius db <giusdbg@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
 <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
 <2025891.FNXETDMuRi@exnet.gdb.it>
 <f441516a-7704-4e20-100f-ddd046b61be3@gmx.com>
 <CAO6awePqby834dBSgLx5r6onmD9HhGWAfN4bno0zK6pU0QjrEQ@mail.gmail.com>
 <CAO6aweNy006hbwEVCuoQ_cSRKP-QRX2UWji6D-E8gkxH8tbm7w@mail.gmail.com>
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
Message-ID: <5badae31-10cd-cb28-4808-8b8b56c1d444@gmx.com>
Date:   Mon, 7 Jan 2019 21:31:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAO6aweNy006hbwEVCuoQ_cSRKP-QRX2UWji6D-E8gkxH8tbm7w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X1eL92JrDNm3umm3pPjfzmjypSqLJVmfC"
X-Provags-ID: V03:K1:41K0ezu6praGoQ0MPYP7Hs+CgyBlQeBkPIp3Xyp6n0EdZwVaX3W
 MBBZ1vOnqF+VX3xH8fg95pa5OiOSKgaGk59GNOKIzepulhTTGuvkJpYsxfZTT42zxpLQcgu
 ELp2SLn2sSFthlNO71UdDVERlGnjst3qnMRyCupQcxBFp+DifNrvZ7S4BlVUndJTgXq6u84
 WglBe/lFb0URxWrPWiFdw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CPzTBnP9bm4=:H0uyqD895boxow7b//Mdl0
 EQUjY4TzJ61zHJPb2p/fwDHz2cDSwEi0RROUKFx51c+xecFbeNxFDjVLTJ3ic8B36wPMnrWmJ
 TFsufxTOnVFUwowx5TZvl/N8CBcAHCx+/KrHaY8owhhZvj9kqLTAH0wQBSY+SWi+yu86rI2uV
 LqoEhtMS6wijH+cLD0HJfDaxJ4SPPyEicgnNLdg2nxy43CmNV1G8IWUCssNLZIVyqYGWuUk5o
 p3J0/b+JWyNY/klE9EAPI1KDUbic6zoYqEJP2YPACEOpYSSGj2/VDfuI/bCoJ3Dtr2SNc6r7u
 R9gDoFGAPPWsTfo+Q5WuzKlcRAdn5dXz2UwuA39pQgNV5P7244gUx4W3oBCv5NxSvTMQlse1H
 9El3jO8/rZaBFQtwJuo09TevNV9GlM4mNzw+ZM17q55w3xxAIGpHPTRlMI1aEp+EPRAiGW7Xk
 uiWnTZMGreHbh6O8jCdh4gxKwsvN2Vxk0Rg4rXKPFhFsDdUA/j5i7Fdc5fATmXWkPnTnUW/Kx
 GTY8s4Vzz4qF7E1em2mmzzvGjbgR4sbrbVRgIJm9ywlsncvldoRuqj1P+znmuWfm6jExa+51G
 1NJs3E0LywZ/i5573XImy7UWrpuDpCi1O2vtvIWqZiATJh2N6nqBZpKyt2cTE/vJKOr9Lwa8j
 PSzjSYPKTVTJ2qLieN5DhU6L4ByYhN971IlWRNZXkF1pu1b0HNGGrbMaDGHofKrFUXvOmCKpL
 DxHZ+VOLIv2GZz2kGfymjq74+U75DJPg4H62+oqr6aVkL2mppmV5NGpFjihoggyqIskXdcJz2
 0W6xs0c5NPMKkTw85VnmBylHjWiZxYn0u3E8mDsbCb2IBsa2ODPevWngVzn+00h3x37kE+hgu
 trWTgWPWfrw7BFy7p08y2cgIhJndSNnlsxcBexZLq547nHPuckruSTu2wWWPL4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X1eL92JrDNm3umm3pPjfzmjypSqLJVmfC
Content-Type: multipart/mixed; boundary="pESO8UGs7xV00VnaD96yZkrX4xYRm17PY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: gius db <giusdbg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <5badae31-10cd-cb28-4808-8b8b56c1d444@gmx.com>
Subject: Re: Fwd: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz'
 can hangs.
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
 <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
 <2025891.FNXETDMuRi@exnet.gdb.it>
 <f441516a-7704-4e20-100f-ddd046b61be3@gmx.com>
 <CAO6awePqby834dBSgLx5r6onmD9HhGWAfN4bno0zK6pU0QjrEQ@mail.gmail.com>
 <CAO6aweNy006hbwEVCuoQ_cSRKP-QRX2UWji6D-E8gkxH8tbm7w@mail.gmail.com>
In-Reply-To: <CAO6aweNy006hbwEVCuoQ_cSRKP-QRX2UWji6D-E8gkxH8tbm7w@mail.gmail.com>

--pESO8UGs7xV00VnaD96yZkrX4xYRm17PY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/7 =E4=B8=8B=E5=8D=888:55, gius db wrote:
> Il giorno lun 7 gen 2019 alle ore 00:56 Qu Wenruo
> <quwenruo.btrfs@gmx.com> ha scritto:
> ]zac[
>>> I am quite convinced that it happens during the snapshot delete and t=
he
>>> subsequent cleanup.
>>> And maybe even the umount is part of the problem.
>>
>> No, I mean the corruption which finally results the hang was there for=
 a
>> long time.
>>
>> It's relatively common that extent tree get corrupted before and some
>> unfortunately operation touching the corrupted extent tree triggered
>> some user affecting error.
>=20
> Yes, I understand, but the use of filesytem is very specific.
>=20
> This filesystem and others that have had problems with corruption, are
> used only as backups.
> So the only operations that are performed are snapshot receive,
> snapshot create, snapshot delete.
> After the operations are finished, the filesystem is unmounted.
>=20
> It may just be a coincidence, but the problems of corruptions have
> occurred very often after a snapshoot delete.

I think this should give us a pretty good clue.

Specific workload, less active usage, and normally no concurrency.

And for the backup usage, you're using relatively new kernel only, right?=


Then this should be something taking into consideration for stress test.

Thanks,
Qu

>=20
> The other filesystems that are used in a generic way (operating
> system, warehouse and data processing, snapshot creating etc.), have
> never given problems.
>=20
> ]zac[
>>>
>>> btrfs check reported various corruptions and fixed them.
>>
>> Please paste the output if possible.
> ]zac[
>=20
> Sorry, I didn't think to save the btrfs check messages.
>=20
>=20
> Gdb
>=20


--pESO8UGs7xV00VnaD96yZkrX4xYRm17PY--

--X1eL92JrDNm3umm3pPjfzmjypSqLJVmfC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwzVKUACgkQwj2R86El
/qiN2gf+NvSKo22iB1F6eV+YgR7o7NJYvl6iDClJ6KXrOsfekRFoyg3C1NpAitVl
fFsx9ZkabQ4/mAzB7UIAn2EX0yjrip0EqdtL5DZ8/JyNzhVvgLZxFRx7mQS+faD4
daQF6PLCaovJ2JWz0xUA5dfqEwYkNEFew6EBwiQ9utnIMhteoqiCyNzgZEdd5t++
7X2aCiZP/r6x5NYF7LThhYQSR9pUlacmW9Af7hCF1ni13HDVTSQ/8SwxzPbtv8TC
91UoWLUYmCEmQQgo+XtB4C6YbptQeE3wJ7uFTgpJeA+3is7PI+RsSWJkP8/AYguA
v75gxy3iv2P6UHB9SyWotrv15qY+Lw==
=OQbY
-----END PGP SIGNATURE-----

--X1eL92JrDNm3umm3pPjfzmjypSqLJVmfC--
