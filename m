Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AFFC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 00:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594B120821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 00:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfAIAFq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:05:46 -0500
Received: from mout.gmx.net ([212.227.15.15]:58889 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbfAIAFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 19:05:46 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LZzKf-1h8LO42m45-00loSj; Wed, 09
 Jan 2019 01:05:42 +0100
Subject: Re: Nasty corruption on large array, ideas welcome
To:     Thiago Ramon <thiagoramon@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAO1Y9wrAzSxGx+LYMPswzN4BbMNs__v7+y=BTZRBAW2bRN5Q1w@mail.gmail.com>
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
Message-ID: <a6270ef1-c914-e142-448c-7e7a388f221f@gmx.com>
Date:   Wed, 9 Jan 2019 08:05:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAO1Y9wrAzSxGx+LYMPswzN4BbMNs__v7+y=BTZRBAW2bRN5Q1w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LKt54Aj4xFp2iL8pKGhJSmWeqxOxH4it8"
X-Provags-ID: V03:K1:DLRiDagnmZNIzcCEmubQ80RNzunddqNBDgnDpxtHAUa4tC7Izoj
 ES5SOpRCWosaXytqtxjphB9/4p8gZfLs05JmOKBvEcuEWf5083O+YWvK5UseqjgW2CL6quE
 1hjlad+PCZBJkbmv2ZbxNRIztS7xbnv9GLemZUloGzT9BoOH8WqRmxnpVPmg2ztFfN7t6dL
 0pBH3whXoUQGgfiJdr0Cg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3w5TtMXLwDU=:0OSkWW1/BLXR/DWxM9WJgt
 S7MNyiL5dWvP5/SyvJHbrbNc8kUcDiVHCjXcrrG/rB2NStBdnjoFhNG0gaVoSz/wnANg4rBOa
 6dStCUgILyc+wW9GYfsMQ9cyuRdWFW9NcObLlqHk7l0WxtXGobp8lvDA7F9uOSMDBz7hlIfZn
 GG6PrOqp+rN5Ni3qO6w2iGCDci5EaxQztho3TDo24Js4JR+MYh7y7UbCC7spMk+uJfmWKp20K
 5tATfqSSWYyiHDcNp8yLZk6Zv0YF4/rRS2WZSOAL0fo3x6/gtPCyFHUVXoV6KUehOipNJu4k2
 v9BxmQ9DCpAsxM24TE7Bbivxx7nvu9f3EmrGKa7WPoJuOSywuimbe0fQpxsuYALcYpGVzxEKy
 bbNfymwa0sSR44QJ0PvYspDLjWgpNoq3546K0cHY3TA4IoOWPd/7H5Kfl85RVFgP1GdNBmd3F
 SVjQd9uQ7IgMjneHQ1OymvtSD4QHwOTJjdAk1RtccQzS3K9YgQENCl4i85HN2e1qFq9/NKamO
 kpe178UQZf0sZfvoeBkjP9DjQG+tpjrBpDymTMh6w5nWdVOhpuKSTmkQ5ley6ZwN4XMaFYmJP
 moDAZk0A/CrdJhZZgTTcjXVI5G9rZ8PpnBIGgyp2Cf0TFPq7wV5iSkJgsN3BtPI1NX3wRdI78
 mJ/rJHeBHwu54anGoTZoU49rUkEO9LglUv7Q4JyHGryinC3o5X1I4YShCTYw+/ErjyDHYkmNi
 VMDEPPksWZGUQAc+vT08Ngym7WDRGAfGLSMtzd8NtXATai9dAku9kU05Lpw2EAEcvaLR4Xbg9
 4IBP+bStxYMlp20Vc9L4gsRHv9x9ry+ZvK09oNGc7uMJpTWJw/uebCTeVvhuK0F5rRtp+6jgy
 rB1FIBJYkDg/52TtKNgcGVyX1BwrhR7xY2nHT9r3haBajXSLkoHUPVBwuFL9el
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LKt54Aj4xFp2iL8pKGhJSmWeqxOxH4it8
Content-Type: multipart/mixed; boundary="jb2GW5XQBQYQBjdomPR18wN8DooLU3OKR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Thiago Ramon <thiagoramon@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <a6270ef1-c914-e142-448c-7e7a388f221f@gmx.com>
Subject: Re: Nasty corruption on large array, ideas welcome
References: <CAO1Y9wrAzSxGx+LYMPswzN4BbMNs__v7+y=BTZRBAW2bRN5Q1w@mail.gmail.com>
In-Reply-To: <CAO1Y9wrAzSxGx+LYMPswzN4BbMNs__v7+y=BTZRBAW2bRN5Q1w@mail.gmail.com>

--jb2GW5XQBQYQBjdomPR18wN8DooLU3OKR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/9 =E4=B8=8A=E5=8D=883:33, Thiago Ramon wrote:
> I have a pretty complicated setup here, so first a general description:=

> 8 HDs: 4x5TB, 2x4TB, 2x8TB
>=20
> Each disk is a LVM PV containing a BCACHE backing device, which then
> contains the BTRFS disks. All the drives then were in writeback mode
> on a SSD BCACHE cache partition (terrible setup, I know, but without
> the caching the system was getting too slow to use).
>=20
> I had all my data, metadata and system blocks on RAID1, but as I'm
> running out of space, and the new kernels are getting better RAID5/6
> support recently, I've finally decided to migrate to RAID6 and was
> starting it off with the metadata.
>=20
>=20
> It was running well (I was already expecting it to be slow, so no
> problem there), but I had to spend some days away from the machine.
> Due to an air conditioning failure, the room temperature went pretty
> high and one of the disks decided to die (apparently only
> temporarily). BCACHE couldn't write to the backing device anymore, so
> it ejected all drives and let them cope with it by themselves. I've
> caught the trouble some 12h later, still away, and shut down anything
> accessing the disks until I could be physically there to handle the
> issue.
>=20
> After I got back and got the temperature down to acceptable levels,
> I've checked the failed drive, which seems to be working well after
> getting re-inserted, but it's of course out of date with the rest of
> the drives. But apparently the rest got some corruption as well when
> they got ejected from the cache, and I'm getting some errors I haven't
> been able to handle.
>=20
> I've gone through the steps here that helped me before when having
> complicated crashes on this system, but this time it wasn't enough,
> and I'll need some advice from people who know the BTRFS internals
> better than me to get this back running. I have around 20TB of data in
> the drives, so copying the data out is the last resort, as I'd prefer
> to let most of it die than to buy a few disks to fit all of that.
>=20
>=20
> Now on to the errors:
>=20
> I've tried both with the "failed" drive in (which gives me additional
> transid errors) and without it.
>=20
> Trying to mount with it gives me:
> [Jan 7 20:18] BTRFS info (device bcache0): enabling auto defrag
> [ +0.000010] BTRFS info (device bcache0): disk space caching is enabled=

> [ +0.671411] BTRFS error (device bcache0): parent transid verify
> failed on 77292724051968 wanted > 1499510 found 1499467
> [ +0.005950] BTRFS critical (device bcache0): corrupt leaf: root=3D2
> block=3D77292724051968 slot=3D2, bad key order, prev (39029522223104 16=
8
> 212992) current (39029521915904 168 16384)

Heavily corrupted extent tree.

And there is a very good experimental patch for you:
https://patchwork.kernel.org/patch/10738583/

Then go mount with "skip_bg,ro" mount option.

Please note this can only help you to salvage data (kernel version of
btrfs-store).

AFAIK, the corruption may affect fs trees too, so be aware of corrupted
data.

Thanks,
Qu


> [ +0.000378] BTRFS error (device bcache0): failed to read block groups:=
 -5
> [ +0.022884] BTRFS error (device bcache0): open_ctree failed
>=20
> Trying without the disk (and -o degraded) gives me:
> [Jan 8 12:51] BTRFS info (device bcache1): enabling auto defrag
> [ +0.000002] BTRFS info (device bcache1): allowing degraded mounts
> [ +0.000002] BTRFS warning (device bcache1): 'recovery' is deprecated,
> use 'usebackuproot' instead
> [ +0.000000] BTRFS info (device bcache1): trying to use backup root at
> mount time[ +0.000002] BTRFS info (device bcache1): disabling disk
> space caching
> [ +0.000001] BTRFS info (device bcache1): force clearing of disk cache
> [ +0.001334] BTRFS warning (device bcache1): devid 2 uuid
> 27f87964-1b9a-466c-ac18-b47c0d2faa1c is missing
> [ +1.049591] BTRFS critical (device bcache1): corrupt leaf: root=3D2
> block=3D77291982323712 slot=3D0, unexpected item end, have 685883288
> expect 3995
> [ +0.000739] BTRFS error (device bcache1): failed to read block groups:=
 -5
> [ +0.017842] BTRFS error (device bcache1): open_ctree failed
>=20
> btrfs check output (without drive):
> warning, device 2 is missing
> checksum verify failed on 77088164081664 found 715B4470 wanted 580444F6=

> checksum verify failed on 77088164081664 found 98775719 wanted FA63AD42=

> checksum verify failed on 77088164081664 found 98775719 wanted FA63AD42=

> bytenr mismatch, want=3D77088164081664, have=3D274663271295232
> Couldn't read chunk tree
> ERROR: cannot open file system
>=20
> I've already tried super-recover, zero-log and chunk-recover without
> any results, and check with --repair fails the same way as without.
>=20
> So, any ideas? I'll be happy to run experiments and grab more logs if
> anyone wants more details.
>=20
>=20
> And thanks for any suggestions.
>=20


--jb2GW5XQBQYQBjdomPR18wN8DooLU3OKR--

--LKt54Aj4xFp2iL8pKGhJSmWeqxOxH4it8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw1OtIACgkQwj2R86El
/qgN+wf/baNBOqiU+TtCJ13Rysp1fvIAeK+lmaG4hDk/YdJp5nmuKNZN1DDmire9
qXXvXmGrnp92C/Hqw0dDR2zmekmuFpiS5yk3r9rRGWPDMMq+7DbMC7I0FAXH4lek
NOLQntdgH26ByWuwJ75L149PZ6XEC7F0ofREztSAA4eHSlwCvVkpoCeKqkriqlTB
LyYe5AxJwC1/zEjpIAKxNrW/FMOypEyMIlzHspLZz3GGaTS3AA4eEdILlrS9kPEK
6sypxdAmdHxEPzZLRb9XJTqpYLbq0dauFxKGbIrHuumLlq2nPioMnCzupGdGxkX1
D9G9dGtUrIOnqxlSk8o4ul5fYaXCUQ==
=/9vV
-----END PGP SIGNATURE-----

--LKt54Aj4xFp2iL8pKGhJSmWeqxOxH4it8--
