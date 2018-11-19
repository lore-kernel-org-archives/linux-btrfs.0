Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB36DC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 05:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46DF62086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 05:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46DF62086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbeKSPXj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 10:23:39 -0500
Received: from mout.gmx.net ([212.227.17.20]:36573 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbeKSPXj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 10:23:39 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MOTRh-1gLbPX2ghJ-005tjL; Mon, 19
 Nov 2018 06:01:03 +0100
Subject: Re: Broken filesystem, looking for guidance
To:     =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
        linux-btrfs@vger.kernel.org
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
 <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
 <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
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
Message-ID: <67736550-3c2c-0ba6-81d4-d0cdc9a1d1eb@gmx.com>
Date:   Mon, 19 Nov 2018 13:00:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YVhTg1vUZsru3rabZri5P8db5WwJ3CmXm"
X-Provags-ID: V03:K1:hMpoTfjg2dZe5BAasLYNHpjGH3gKVzuc++dm1qDGkYJkyzIkUul
 cI1nh2gs3vL1BwvhsyiuBcsjIrg8x3lVtKCCWbBM6Zu0qIbOcB8ufPgz9HIPIrNyjSRgnpG
 xmlHXZ1s92I/O7IpqTyiNOxVGherqQwPOjvTPPTuM1zmnLnLI4TT3VJG4xX2xfbLlCtLfxH
 e0MHjz4VJMw1KG+ZUbSUA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:ME+QbKAOSu0=:IVxUr3NV3FSJzlITLK+Z8l
 +THCHeD31EDGFd98l+V1fjZbLZiyNSdPQGygc5GYPzEJ6M5isHWsiIwNI6QGAGj5+IOb68qJZ
 lo1gXCP6h5ggWZtXG7bkNOuZqKCIN0pmCyqK2ZpVZn83HYbtBfpy16dcl0Kai33qifNAJCi7u
 yF8trcmH1ecHEc+D5gjmKIiHD3IHFdx3GF5SApHFieouH0mnvqcMJRQGQUd0w8OdB+JpkLw/t
 69lNn4vLwwOUUq/PKk5uzNdyqOD20sOXYYAqo3c24CVJFA7Myr8uwZPhaskJMJpTbZcfNnPkc
 KVa3Eju/hoi4MexDuXJMdNcgsjUJ6/c0SRYWokHZY4fCScLHCZXal18F8B2Zv8V2Q6tAixtwN
 lrHDLjybXjiU7sU86Gs50XixzEQv4NWX1LMTaKtinTqjXZDcOvl1rkQ304QjIA4wAsPgh4vJ2
 Gbt8fEB6eOqIBcXMi4hJ6IH2LoBobbwxMO7VfZSQGsymyBjmp4D5fIEp2lmiLFZUVUwCnLUUT
 QQ/uaEe7csB/SzL2C+GFowLGhsaO4or8XpM+wUlO4uYkAl0egYKPdNgnGP0o7SzWbYMsvF5fw
 Ypq8kQEtK9+DRkPndewUAUs/OiQdO8wZgG29N3POwGzHYZfV0NPWd2CErcS6HkhroqV3ayMaN
 2jb7qlS8lA625Hv29zx3oyh/4vD8qWaEcsFKk9JVPW13Wnrocpna/55mJuddlosPpig5h51FR
 SZw6YLXT0q9EWFLj4SGeXe+uoFcNhVBfgLYHJo9SNYIGBgZM7iDmPRxyy9Ex/e9XK2ytEqTXW
 r/fLd9E7KtiGrRQKeudARq+0S6TwdHAGaqV+ZGumem+cUt2W4GgD8eBjg8IO2lMTibDCSqmbH
 NsU1xlrky1TOdrs5OKsYNmVMYQok6vHZx0BTEPKGQx7Y/GXFxvCY+PdeP6L23m
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YVhTg1vUZsru3rabZri5P8db5WwJ3CmXm
Content-Type: multipart/mixed; boundary="IYcFttHhLb4Wph7C5TQP5FClRS94GppVE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
 linux-btrfs@vger.kernel.org
Message-ID: <67736550-3c2c-0ba6-81d4-d0cdc9a1d1eb@gmx.com>
Subject: Re: Broken filesystem, looking for guidance
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
 <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
 <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
In-Reply-To: <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>

--IYcFttHhLb4Wph7C5TQP5FClRS94GppVE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8A=E5=8D=8811:29, S=C3=A9bastien Luttringer wrote:
> On Mon, 2018-11-19 at 08:48 +0800, Qu Wenruo wrote:
>>
>> On 2018/11/19 =E4=B8=8A=E5=8D=883:37, S=C3=A9bastien Luttringer wrote:=

>>
>> You haven't post btrfs check --readonly output, thus not helpful.
>=20
> The oldest `btrfs check --readonly' output I saved is from 29th October=
 with a
> vanilla linux 4.19.0 kernel. Filename: btrfs-check-20181029.log
>=20
> A fresh `btrfs check --readonly' output was captured few minutes ago wi=
th a
> 4.18.18 vanilla kernel. The file is huge (2.7 GB uncompressed, 143MB af=
ter xz
> -9). Filename: btrfs-check-20181119.log.xz
>=20
> I saved a file named btrfs-check-20181119-sample.log with the first 100=
0 lines
> for easier reading.
>=20
> You can find these files here: https://cloud.seblu.net/s/QzLk9ptSYrgofp=
8

Much better.
Especially for btrfs-check-20181029.log.

ftelephony.h has pretty bad refs.
Despite that, it looks mostly OK.
It looks like a bug fixed in v4.19, not sure if that's the case.

However it looks like the repair makes extent tree worse, that's why
--repair should only be called with developers' advice or enough experien=
ce.

>=20
>> Please post the original kernel version where you hit the first kernel=

>> warning.
> There is a lot of first time a warning. I dont' know which one may be r=
elevant.
> I posted the output of `journalctl -oshort-iso --no-hostname |grep -e "=
Linux
> version" -e "BTRFS"|grep -v sdg' here :=20
> https://cloud.seblu.net/s/QzLk9ptSYrgofp8/download?path=3D%2F&files=3Db=
trfs_kernever.log.xz

May I ask for the oldest kernel ran on the fs?

>=20
> I excluded sdg because there is also a btrfs filesystem on it, but it's=
 only
> the system partition and there is no problem.
>=20
>> Without any useful detail, it's hard to say, but your filesystem is
>> already corrupted, by the original (maybe very old) kernel.
> To give you a overview of what happen:
> - The backuppc process crashed randomly during backups.
> - I tried scrub
> =3D> no error

It's corruption in btrfs internal cross reference, while scrub only
checks for csum for data/metadata, it won't detect such problem, thus
btrfs check --readonly is needed.

> - I tried btrfs check --readonly
> =3D> founds errors
> - I tried btrfs check --repair
> =3D> segfault.
> - I tried btrfs balance start --full-balance
> =3D> ok, but still errors

Balance is the last thing you could try for a corrupted fs.
It could make things worse, and would never ever make anything better.

And it's no longer recommended to do balance routine anymore, unless
you're hitting ENOPC or extreme unbalanced meta/data ratio.

> - I tried btrfs balance start -mconvert=3Draid10,profile=3Draid1=20
> =3D> ok, but still errors
> - I tried btrfs check -p --repair --clear-space-cache /dev/sdd
> =3D> ok, but still errors
> - I tried btrfs check -p --repair --clear-space-cache v2 /dev/sdd
> =3D> ok, but still errors
> - I tried btrfs check -p --mode lowmem /dev/sdd
> =3D> segfault (after long time)
> - btrfs check --init-csum-tree /dev/sdd
> =3D> abort

To make it clear again, any --init-* should only be used when you're
completely sure what is going to happen (at code level).

=46rom btrfs-check-20181119, all the extra damage are possibly caused by
either --repair or this --init-csum-tree.

>=20
>> Thus newer kernel can't process on the corrupted fs.
> Is there tools which can fix these issue?

=46rom 20181029, it may be possible with extra help from btrfs-progs
developers. But at current point, it's near impossible to recover it to
a fully functional state.

>=20
> Looks like I can still access to the data in read-only, despite the wro=
ng size
> of filesystem displayed in 'df -h' or 'btrfs fi us /home'.

The original corruption is only for some strange dir refs, thus no
problem for other files/directories, but could cause problem when
updating dir refs, just as the original kernel warning shows.

The new corruption is some extent tree mismatch, thus only damage write
operations.

Thanks,
Qu

>=20
> Regards,
>=20
> S=C3=A9bastien "Seblu" Luttringer
>=20


--IYcFttHhLb4Wph7C5TQP5FClRS94GppVE--

--YVhTg1vUZsru3rabZri5P8db5WwJ3CmXm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvyQ4sACgkQwj2R86El
/qibfAf+KLSGgHZ//3GeqvMeRFyM7wD5equYoGisNxiNhdynavUgD2KtfTOwfunq
hYXamMZ1cxn76+//ZMRA0eV/P7IcC3qIl+1jCe72UZAS+gDu4pt92tK6OouYReaC
4BmNEqcL+ZkI2VjToThDklHYBy7avaxzMSeTf8GLptXOPMlwyLccwJ82kLQYnwvL
MfZLXEwY/XpCxIG2KjCmXp5IyWKaLrDSp9Jt88NNRv2zxKlmM0+s1zsBNbKPSPHS
QgG20JhqWGmMPqFIv9gtDFRz0HB0QAJTZEevnjmfYp47kCcIVJB8v7DRK0bwu4uy
/j+B9raSvkuNa+E8RhZ4CXiTC1Quug==
=xt1F
-----END PGP SIGNATURE-----

--YVhTg1vUZsru3rabZri5P8db5WwJ3CmXm--
