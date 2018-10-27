Return-Path: <SRS0=kVXZ=NI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEBEC46475
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Oct 2018 00:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B7F2085B
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Oct 2018 00:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00B7F2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbeJ1ImF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 04:42:05 -0400
Received: from mout.gmx.net ([212.227.17.22]:38073 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbeJ1ImE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 04:42:04 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M34eJ-1fPHH82v3v-00srgm; Sun, 28
 Oct 2018 01:59:18 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M34eJ-1fPHH82v3v-00srgm; Sun, 28
 Oct 2018 01:59:18 +0200
Subject: Re: btrfs-qgroup-rescan using 100% CPU
To:     Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAH=dxU7OXpWYRVkhoPtcfPj3r6Sh5Mkmz4nc6jOy_W8osX5zOQ@mail.gmail.com>
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
Message-ID: <f666e341-3c9c-1108-717a-5165cb2ca3c1@gmx.com>
Date:   Sun, 28 Oct 2018 07:59:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAH=dxU7OXpWYRVkhoPtcfPj3r6Sh5Mkmz4nc6jOy_W8osX5zOQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zXqqlKsT7t18XV7DecBf4n2S78SHPbS1Y"
X-Provags-ID: V03:K1:MunCXoAxIEMXxqhNKlyKimN5GM+oguO8oc5gcY3NaEnJTmjTkZB
 cUkP64z/4xYCF6ceoKTUhlbkPk62K3mK1Eekc3Xoj6jWegwFyhlYP2hW8A/nQNymxJljfKk
 J9pW7qtbCzT1hfl0NAPTuApD9w5nK7MhUwqmim6RraAgO7Kh9cIU9qMgqtEiB6dgDrk2a34
 CbD2ZrDmvdd9DTZl4bDrg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:xGErKipnASM=:9ko+LvrOVQwAW/xeraN32v
 godrjIwPJ7AunY486cKbFRntdg7zS1w6J3vQx+enq93rOnAmCGLvAaPi4uzrzgiuJsC1TB7lu
 Onw/IGmTfPWV+0ubYFB2+AZEiqlf+mzQW/MzQevhJ/g2nH2bnQMmecxiocgEIa40Chk0COKhZ
 LlwBLB3zZIlElKUFS8mRniQvZ06isaPb83CR8QG0msRZB1b/WW3tqwHHwZxdfhk2UHSE8QWh6
 cUfwG4kvJTljTjanJ0UH9FEf9Uew/tVZVVAA3RnWdXmZl2qNwx3p6UN0zlP2oQP2fqi5Rs61z
 6HMpLolAfxloZatJPNE/R3gH31kGcUZ6AmQIXaFs/Fdhp5zUDkB/OOI+/xvk7bG+66ou7E0qe
 QrzxBsAJOTPcD3plGVGT0lD+HJ5/7FEyJlKTmNTCFI2wV3BcLtTrixfXDBrlx6fDdo3mK6cbN
 dX8E8/YmjUJi3C5sUzytNAb4aq9D+rl8VYTvgS06L58scqsJsyLJoJxcPB9fABmFI/0W2LOJA
 eQIOvHjcjKyXgfRf6yHdJ6cVSHXLQoOWTJjFe0hKWtYkPd1DL0P21shhYYoJC9CJgx9F/Hbva
 AOyfExf/5GxEeZdyZv5RlHVjN7x+jj1nvabEMKJ+uq+x7UGvh+QHa/vp81GushNrtUtbjjY3F
 DYF5g9xbIj/mqgbrJ+D+IGxxl3Mjx3en6njldBIC4YgNEXDzRS91IS5bj5WIPeMvwVyRCuWSN
 zktS1NcG8golcj7qrqaw7eTRKnNoFAUf6pcHem1AVABLUbDNneYZReZq439gydTEcMJgeyR3c
 NqFFNINfM2AFCyK/yako5+g2gRjOQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zXqqlKsT7t18XV7DecBf4n2S78SHPbS1Y
Content-Type: multipart/mixed; boundary="tHOcQMUFgRF4NRFhBKlRtPvKRZHJjwG8t";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dave <davestechshop@gmail.com>,
 Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f666e341-3c9c-1108-717a-5165cb2ca3c1@gmx.com>
Subject: Re: btrfs-qgroup-rescan using 100% CPU
References: <CAH=dxU7OXpWYRVkhoPtcfPj3r6Sh5Mkmz4nc6jOy_W8osX5zOQ@mail.gmail.com>
In-Reply-To: <CAH=dxU7OXpWYRVkhoPtcfPj3r6Sh5Mkmz4nc6jOy_W8osX5zOQ@mail.gmail.com>

--tHOcQMUFgRF4NRFhBKlRtPvKRZHJjwG8t
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/28 =E4=B8=8A=E5=8D=886:58, Dave wrote:
> I'm using btrfs and snapper on a system with an SSD. On this system
> when I run `snapper -c root ls` (where `root` is the snapper config
> for /), the process takes a very long time and top shows the following
> process using 100% of the CPU:
>=20
>     kworker/u8:6+btrfs-qgroup-rescan

Not sure about what snapper is doing, but it looks like snapper needs to
use btrfs qgroup.

And then enable btrfs qgroup will do a initial qgroup scan.

If you have a lot of snapshots or a lot of files, it will take a long
time to do the initial rescan.

That's the designed behavior.

>=20
> I have multiple computers (also with SSD's) set up the same way with
> snapper and btrfs. On the other computers, `snapper -c root ls`
> completes almost instantly, even on systems with many more snapshots.

The size of each subvolume also counts.

The time consumed by qgroup rescan depends on the number of references.
Snapshots, reflinks all contribute to that number.

Also, large files contribute less than small files, as one large file
(128M) could only contain one reference, while 128 small files (1M)
contains 128 references.

Snapshot is one of the heaviest workload in such case.
If one extent is shared 4 times between 4 snapshots, then it will cost 4
times CPU resource to do the rescan.

> This system has 20 total snapshots on `/`.

That already sounds a lot, especially considering the size of the fs.

>=20
> System info:
>=20
>     4.18.16-arch1-1-ARCH (Arch Linux)
>     btrfs-progs v4.17.1
>     scrub started at Sat Oct 27 18:37:21 2018 and finished after 00:04:=
02
>     total bytes scrubbed: 75.97GiB with 0 errors
>=20
>     Filesystem           Size  Used Avail Use% Mounted on
>     /dev/mapper/cryptdv  116G   77G   38G  67% /
>=20
>     Data, single: total=3D72.01GiB, used=3D71.38GiB
>     System, DUP: total=3D32.00MiB, used=3D16.00KiB
>     Metadata, DUP: total=3D3.50GiB, used=3D2.22GiB

=46rom a quick glance, it indeed needs some time do to the rescan.


Also, to make sure it's not some deadlock, you could check the rescan
progress by the following command:

# btrfs ins dump-tree -t quota /dev/mapper/cryptdv

And look for the following item:

	item 0 key (0 QGROUP_STATUS 0) itemoff 16251 itemsize 32
		version 1 generation 7 flags ON|RESCAN scan 1024

That scan number should change with rescan progress.
(That number is only updated after each transaction, so you need to wait
some time to see that change).

Thanks,
Qu

>=20
> What other info would be helpful? What troubleshooting steps should I t=
ry?
>=20


--tHOcQMUFgRF4NRFhBKlRtPvKRZHJjwG8t--

--zXqqlKsT7t18XV7DecBf4n2S78SHPbS1Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvU+9IACgkQwj2R86El
/qhW5Qf9ExF6EOnKX4zbOlukO5cT584M9i8A1nqEnmXLrmqSNCMfDbsk7zMutDzM
nn4NTT2ngKOOq7oDgQchej1/VeK2tHVVOz6N8Betjp2y4aV+yI6SpIoCvWAYSMD1
6385PFpoq+TUUzWxSH5b/3AbfrUFIh6ewqJdQ105glR1ppB1ovOVpxAezNBidLUD
rV0vexXzMtRzqqdJq96vJxMqvuhkDNT0YcIlA/s7iSGVnxY3pQxQVX+PTOHKkvfO
xlp7Ux2pRcrZZdSUY+xl7gKrty333c0SYJNLOdBwzk2krK4dceiWVP+fseT37ZKn
P5HvqWTeVrrhW4cvkR14B8zPdYLruQ==
=1U+Q
-----END PGP SIGNATURE-----

--zXqqlKsT7t18XV7DecBf4n2S78SHPbS1Y--
