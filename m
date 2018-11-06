Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF6EC0044C
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 01:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83742083D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 01:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B83742083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbeKFKvY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 05:51:24 -0500
Received: from mout.gmx.net ([212.227.17.21]:51193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbeKFKvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 05:51:24 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MMHaL-1gRovO2kEH-0081v4; Tue, 06
 Nov 2018 02:28:44 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MMHaL-1gRovO2kEH-0081v4; Tue, 06
 Nov 2018 02:28:44 +0100
Subject: Re: btrfs partition is broken, cannot restore anything
To:     Attila Vangel <vangel.attila@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
 <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
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
Message-ID: <1a569e29-d9f1-e86f-15cf-5a8b5e205103@gmx.com>
Date:   Tue, 6 Nov 2018 09:28:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="O3rHGST7VQ37ymhFniupYlZACrDeef1hW"
X-Provags-ID: V03:K1:1etMksmn1XYbLCCL0Jp/jdyEbjtgNXqWBb/piw1Jls4c4wacRJ3
 0n4jo4wyYTvbr+1pHuk9AA6g6A4eT/mSxYYarmoLg/fuq1HfMiwaOj+tw/Mf159CAZwO+YR
 RNq3MYIETm4uV+FWnQgS3EfroJXhAYHL0613tw6fkZreYgeKwms9AxNvEzuUejZMHanoanM
 wNEDAV7OTAuHH39ECPF+w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:GlJxpYYgiFs=:wDUX0RmHNB8FM5pXabCGzz
 a0rkQ5pMH9Uyab6cDd6sax0H31TQZKvPBYC65vk2eWFk/D+kSOJ6udDpeEhAhnl8qxfC9IWLY
 25nRDileerr3SxUH31vvRQBG3iBXl2+VfN1vyGQdJeL01JWsGq/yioW0AAfqfroAenxq7g2aE
 uUL898E+sFKfjZ7pBIbblh9KRgc3MS7iRGBmt72guC6Hrge9DVBkf0MkebDH2VZKm45BOlTZI
 Z+quXy70L3aIwvQ5aKeaY0JAntCuVwSPHqu2KXj/1+Q39uW18ZHUcENTSm7BUe+9Urno+5+Rq
 ggkF8y0Jny4tY/KhvAwST0gh3cv4mL0WmFq4ddHEL5Xs7wkkaazIl8FpRv5rrm2tHYDWFNnWB
 eGRhZcFUdMTPk25bxBz9p9eSkqfENOhowdLc3biYwLAgzeVvx0xlL3ynHHB9IqOyJEYrXIfbF
 9U/m6OdXlEbpYlNNUEfO1lkRmCxKPLPdopjsD5KCPBHRsxP7hADlz3LI3ZHuuE6OuZnpE/Hcx
 HPTfS+dBHpbmJyf7X20zJF+uYuURI3SWHALt/K+6nO4khrvlLFVxNWqAIV77p5Hxh6SD/tUR9
 M/ptuS7oy/R4hbcjDntddJ9L0RKOK8lDv3RHT+AqrGZsSgdM/2DWtdcotWhvQ9YrnyA14pxUX
 0aPpgx4PIdhqGGNQBn/a1IXAqcU8aaDUntmEwNn9P4OUrnIp0NpLPQd3LoWgbPGf9eTRZUL3d
 kxEgPgY93vJQ1u4uEAGyTTQz6pA5IbjW+lwjzAE8YF0AzkhJeIQNc2tNiRwHgPIPNuvBGZdQs
 7vgz2A6UTrt/TYp6xKy2he1fLZzCg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O3rHGST7VQ37ymhFniupYlZACrDeef1hW
Content-Type: multipart/mixed; boundary="HE5qyWTW3tPBEXwez3TpATUm2mvhu0MjV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Attila Vangel <vangel.attila@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <1a569e29-d9f1-e86f-15cf-5a8b5e205103@gmx.com>
Subject: Re: btrfs partition is broken, cannot restore anything
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
 <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
In-Reply-To: <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>

--HE5qyWTW3tPBEXwez3TpATUm2mvhu0MjV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/6 =E4=B8=8A=E5=8D=882:01, Attila Vangel wrote:
> Hi,
>=20
> TL;DR: I want to save data from my unmountable btrfs partition.
> I saw some commands in another thread "Salvage files from broken btrfs"=
=2E
> I use the most recent Manjaro live (kernel: 4.19.0-3-MANJARO,
> btrfs-progs 4.17.1-1) to execute these commands.
>=20
> $ sudo mount -o ro,nologreplay /dev/nvme0n1p2 /mnt
> mount: /mnt: wrong fs type, bad option, bad superblock on
> /dev/nvme0n1p2, missing codepage or helper program, or other error.
>=20
> Corresponding lines from dmesg:
>=20
> [ 1517.772302] BTRFS info (device nvme0n1p2): disabling log replay at m=
ount time
> [ 1517.772307] BTRFS info (device nvme0n1p2): disk space caching is ena=
bled
> [ 1517.772310] BTRFS info (device nvme0n1p2): has skinny extents
> [ 1517.793414] BTRFS error (device nvme0n1p2): bad tree block start,
> want 18811453440 have 0
> [ 1517.793430] BTRFS error (device nvme0n1p2): failed to read block gro=
ups: -5
> [ 1517.808619] BTRFS error (device nvme0n1p2): open_ctree failed

Extent tree corrupted.

If it's the only problem, btrfs-restore should be able to salvage data.

>=20
> $ sudo btrfs-find-root /dev/nvme0n1p2

No, that's not what you need.

> Superblock thinks the generation is 220524
> Superblock thinks the level is 1
> Found tree root at 25018368 gen 220524 level 1
> Well block 4243456(gen: 220520 level: 1) seems good, but
> generation/level doesn't match, want gen: 220524 level: 1
> Well block 5259264(gen: 220519 level: 1) seems good, but
> generation/level doesn't match, want gen: 220524 level: 1
> Well block 4866048(gen: 220518 level: 0) seems good, but
> generation/level doesn't match, want gen: 220524 level: 1
>=20
> $ sudo btrfs ins dump-super -Ffa /dev/nvme0n1p2
> superblock: bytenr=3D65536, device=3D/dev/nvme0n1p2
[snip]
>=20
> If I understood correctly, somehow it is possible to use this data to
> parametrize btrfs restore to save the files from the partition.

None of the output is really helpful.

In your case, your extent tree is corrupted, thus kernel will refuse to
mount (even RO).

You should run "btrfs check" on the fs to see if btrfs can check fs tree.=

If not, then go directly to "btrfs restore".

Thanks,
Qu

> Could you please help how to do it in this case? I am not familiar
> with these technical terms in the outputs.
> Thanks in advance!
>=20
> Cheers,
> Attila
>=20
> On Thu, Nov 1, 2018 at 8:40 PM Attila Vangel <vangel.attila@gmail.com> =
wrote:
>>
>> Hi,
>>
>> Somehow my btrfs partition got broken. I use Arch, so my kernel is
>> quite new (4.18.x).
>> I don't remember exactly the sequence of events. At some point it was
>> accessible in read-only, but unfortunately I did not take backup
>> immediately. dmesg log from that time:
>>
>> [ 62.602388] BTRFS warning (device nvme0n1p2): block group
>> 103923318784 has wrong amount of free space
>> [ 62.602390] BTRFS warning (device nvme0n1p2): failed to load free
>> space cache for block group 103923318784, rebuilding it now
>> [ 108.039188] BTRFS error (device nvme0n1p2): bad tree block start 0 1=
8812026880
>> [ 108.039227] BTRFS: error (device nvme0n1p2) in
>> __btrfs_free_extent:7010: errno=3D-5 IO failure
>> [ 108.039241] BTRFS info (device nvme0n1p2): forced readonly
>> [ 108.039250] BTRFS: error (device nvme0n1p2) in
>> btrfs_run_delayed_refs:3076: errno=3D-5 IO failure
>>
>> At the next reboot it failed to mount. Problem may have been that at
>> some point I booted to another distro with older kernel (4.15.x,
>> 4.14.52) and unfortunately attempted some checks/repairs (?) e.g. from=

>> gparted, and at that time I did not know it could be destructive.
>>
>> Anyway, currently it fails to mount (even with ro and/or recovery),
>> btrfs check results in "checksum verify failed" and "bad tree block"
>> errors, btrfs restore resulted in "We have looped trying to restore
>> files in" errors for a dozen of paths then exit.
>>
>> Is there some hope to save data from the filesystem, and if so, how?
>>
>> BTW I checked some diagnostics commands regarding my SSD with the nvme=

>> client and from that it seems there are no hardware problems.
>>
>> Your help is highly appreciated.
>>
>> Cheers,
>> Attila


--HE5qyWTW3tPBEXwez3TpATUm2mvhu0MjV--

--O3rHGST7VQ37ymhFniupYlZACrDeef1hW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvg7kgACgkQwj2R86El
/qh7mwf/SUaXwp4pZPvOJeFc4pOA36rDIiMDYiV3DhBPCkTydsUqeGPOV/QdPDdj
vDzjWAIee05jafYwFSSPVQVN+GjO7sr08dU9y3nW3NReVl0VW79ef0KK4+PWiAc5
TqEnPkVVUk/N7FQd4gnkXPCCC8O+go3Y+CLw1JOtPC5qqbD1/3zyzrywNBgh+4ql
mlNZ+irvRvBMoXko/9Jnd1mqcgOz3LSIgTglhVWHpVf3d5q4RSHErDKXu8uTVHaI
A8AjmE6rTEiZzlVEU0fmVQ5Lcy8jRP76mKpqzYM1O3mRVaJvSJLpFeV6ZpA2f8X5
b4VU87kWnIZSsHpGvKm2zKpqxmvI+A==
=Dv/m
-----END PGP SIGNATURE-----

--O3rHGST7VQ37ymhFniupYlZACrDeef1hW--
