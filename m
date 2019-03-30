Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F86C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD1F7218A3
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SjD8hsB7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbfC3NRb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 09:17:31 -0400
Received: from mout.gmx.net ([212.227.17.20]:38829 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730787AbfC3NRb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 09:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553951846;
        bh=6DTdx6kt2FZpJaAwf3DYNEQsN9MY316mvdras0VL9Rw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=SjD8hsB70SCXf3kyeMFlwMDSNVbnxylm9E+fUYdQhGrzgXvhsppd3/IPk07z0jWid
         rhMUUrOEsZS4eMzgnj68XZ5x1KW8AEtZtk8ACD+qVDJtEfwtVZJ/APsJWyFOB0+2dS
         Jvhp65ZP0YIA9tIh2otXmvvGAJ4EhAd7OMjrGwe4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lu7ty-1gzo0Y2et4-011PSf; Sat, 30
 Mar 2019 14:17:26 +0100
Subject: Re: Unrecoverable Btrfs filesystem after a single power failure?
To:     =?UTF-8?Q?Tobiasz_Karo=c5=84?= <unfa00@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAOsCCbMp=Jy6jeZi_eSK_u77ScAaMC1-KWErxU9T=E3qMWQv0A@mail.gmail.com>
 <828ef4b6-491b-0ebf-4b10-a33bb91ceeae@gmx.com>
 <CAOsCCbP8-eec2DWoR8+iONyuq8CvKvO7k6GA6NHXndKM0mywiw@mail.gmail.com>
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
Message-ID: <6231e8e1-90fc-d250-a80f-2c1ff92f436d@gmx.com>
Date:   Sat, 30 Mar 2019 21:17:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAOsCCbP8-eec2DWoR8+iONyuq8CvKvO7k6GA6NHXndKM0mywiw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MQm7qSH5B2Kb6bOjAgtsLGYLUlD1DrHTn"
X-Provags-ID: V03:K1:gDc2W7BvqikDtANX3BMzmMKZ2OihovMrYGtfTaeKNPK+1we4+7d
 PCFxK1VmkJ3KqRCQ6oj7gMQJDscpGAYCXqAKFsL5MMmSFMN5j+54yW85YOdSkwKMo/J5CYS
 SvCgwim5XYYzWMoAU+RFBA5lrEk8EUzTQyLV0VxLM7hfNKyFcDXOxmh0VmHUoEY+s3W9qq2
 P+rt2ffmh7qyDHwVWdGHg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bbzm17JkBQM=:CvNWlXol0dkMzq+BGmjJ7R
 3d40ratt8/xmeWOEFfVHBJrwEzJKfU7kvOXDq1ahNK5vmI7Xdn4PVy7SFZZqbq8qgCcqDoj/3
 cuPLoNTpBF7yu+X4gKcCXLVPikp+eupTk0NtPCqBT4Ior95/R1PnKr4aDFDD3MQtEkt+4cUgx
 IItdpvakQFei8Kj4Ct5WV1JFmo1ZfVSEPMfNqr3sYMLDtrLSn5/T4HEXTZkD9WBkOhDh3BlVT
 17hPavI6tcBcIy90fjSjvYRb7jw3i8s0J1bwWt6hh3wlc8BM9TlC6L9yeU73PZNn8KOMBSUCW
 UdKwg82Z+VPSSFORRO2VD5XAkRWl+swCeBaEjtD5iFtGZ86OHkltdXdjRYlSB99Tm4/PRAgcV
 b9nxiHUH912qjT+VqSJckWYd8Zc/c/n7ND8PAT0yxvlqUVSJjH76/XKUtN+AT5Q1nZhwyd2bz
 cYDrCV84PhHrgCJwHiEqbAUPLNZbV9AvC+DO/qhiUvrhP2HyQDQZOvaGcAf+skWFkj6WsKPi1
 +7vN++h23Dl3JrrFBRR200BEjV67ldyUBc1GGIVh8RCOfTkEyWIu3fGN39RwZSNx0H2zn7jit
 NN8I+8GkkJUYv1BYdMPiz7eexqWpd6FJ/L3z/YbL/tco5YQVBYGUDLJQ2SMWj/XeWtU85ReOy
 8B4T3U5qmLUx8+/sxiRHzqVDEklcRUi8ZrlwzHfjvwbNblVBzNcVQPXIJ03jbIb3bUGpz5efW
 4zn5Yo+DoZvV4337mdnCk+GJgFC0+nQUVm4hcPJvCGLooKIozmcA0o0DuXMycUhhDkt2ZduiV
 CDnondlIP64FL6XK+4XMByaG9L73EhfBbiYooc1wmbtuA20imTKSuccVl5LDvouHtuLOlLilP
 jEAuE7mC9gpnqyCgRA4nEyWNzC8wmS2ToMteAenhT5uVsbBhN5D1zO+iOi/hhF
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MQm7qSH5B2Kb6bOjAgtsLGYLUlD1DrHTn
Content-Type: multipart/mixed; boundary="uVZEOYDVoo9FLTvwuDCNJ8KsLKeqlZswq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Tobiasz_Karo=c5=84?= <unfa00@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <6231e8e1-90fc-d250-a80f-2c1ff92f436d@gmx.com>
Subject: Re: Unrecoverable Btrfs filesystem after a single power failure?
References: <CAOsCCbMp=Jy6jeZi_eSK_u77ScAaMC1-KWErxU9T=E3qMWQv0A@mail.gmail.com>
 <828ef4b6-491b-0ebf-4b10-a33bb91ceeae@gmx.com>
 <CAOsCCbP8-eec2DWoR8+iONyuq8CvKvO7k6GA6NHXndKM0mywiw@mail.gmail.com>
In-Reply-To: <CAOsCCbP8-eec2DWoR8+iONyuq8CvKvO7k6GA6NHXndKM0mywiw@mail.gmail.com>

--uVZEOYDVoo9FLTvwuDCNJ8KsLKeqlZswq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/30 =E4=B8=8B=E5=8D=889:12, Tobiasz Karo=C5=84 wrote:
> I am afraid I probably run btrfs --check on that filesystem after I was=

> unable to mount it.

Then the question is, if that run failed just like the output.

If that's the case, it means btrfs check wasn't even able to open the fs
not to mention to write anything. And all my previous statement still
stands.

>=20
> I would be happy to know that this issue was caused by user error, as
> it's easier for me to deal with than a software error.
>=20
> This filesystem was a backup, and I have a copy of all that.
>=20
> I can simply recreate that filesystem, that's not an issue, but I wante=
d
> to make sure I can avoid data loss in case that happens again, and I if=

> not - maybe this can help fix a software problem in Btrfs.

I believe in next btrfs-progs release, possible 5.0, you can be
more-or-less safer to run "btrfs check --repair", at least it shouldn't
crash your fs as serious as current btrfs check does.

>=20
> It sounds pretty nasty, that running btrfs --check --repair can trash a=

> filesystem to be honest!

That's why it's still mark dangerous.

Although in the past, we just think neh, it's just btrfs check isn't as
clever.
But now, I think we really know why btrfs check --repair is so dangerous.=


Thanks,
Qu

>=20
> Let me know if I can provide any more information. If not - I'm going t=
o
> wipe that filesystem.
>=20
> On Sat, Mar 30, 2019, 13:22 Qu Wenruo <quwenruo.btrfs@gmx.com
> <mailto:quwenruo.btrfs@gmx.com>> wrote:
>=20
>=20
>=20
>     On 2019/3/30 =E4=B8=8B=E5=8D=886:26, Tobiasz Karo=C5=84 wrote:
>     > Hi!
>     >
>     > I have a strange case of a Btrfs failure.
>     >
>     > I'm running Manjaro, btrfs-progs 4.20
>=20
>     Arch based, so kernel version shouldn't be that old.
>     Good job on that.
>=20
>     >
>     > # uname -a
>     > Linux unfa-desktop 4.19.30-1-MANJARO #1 SMP PREEMPT Tue Mar 19
>     > 17:49:12 UTC 2019 x86_64 GNU/Linux
>     >
>     > I've been writing data with rsync to a 3 TB Wester-Digital MyBook=
 via
>     > USB 3.0, when accidentally, I've cut power to the disk's power br=
ick.
>     >
>     > The result - I can't do anything with the filesystem any more.
>     > Whatever I try I get this:
>=20
>     Please verify that, you haven't run "btrfs check --repair" or "btrf=
s
>     check --init-*" on that disk.
>=20
>     And if you have ran before, please provide the following the kernel=

>     message of the verify first mount failure.
>=20
>     If it shows something like transid mismatch, and has the *exact* sa=
me
>     "wanted 1530 found 1532", then we are sure it's not "btrfs check" w=
rite
>     operation screwed up the situation.
>=20
>     In fact, just exposed in this weak, btrfs-progs write operation can=
 lead
>     to the exact same problem. Either a crashed btrfs check write, or a=

>     gracefully aborted btrfs check write, can cause the problem.
>=20
>     If that's the case, I'm afraid you can only try to salvage the data=

>     using btrfs-restore, and remember don't run btrfs check with --repa=
ir or
>     any --init-* options, until btrfs-progs is fixed and a developer is=

>     asking for that run.
>=20
>=20
>     If that's not the case, then things is getting really tricky.
>=20
>     The offending tree blocks are from the future, which means btrfs/ke=
rnel
>     block layer/driver layer/hardware controller doesn't implement flus=
h/fua
>     well.
>=20
>     From my personal investigation, btrfs follows its flush/fua sequenc=
e
>     pretty well.
>     Unless you're using nobarrier, btrfs shouldn't cause the problem.
>=20
>     For block layer part, I have seen some error reports on blk-mq in r=
ecent
>     kernels, but it shouldn't be the case, your are only 2 versions old=
er
>     than upstream 4.19.32.
>=20
>     For device driver/hardware controller, I'm not 100% sure, as btrfs =
has
>     less flush/fua request compared to other fs, if the hdd controller =
is
>     doing some black magic to "optimize" performance for certain fs, th=
en it
>     would have a more obvious impact on btrfs, but less for journal bas=
ed fs
>     like ZFS/Xfs/Ext*.
>=20
>     Thanks,
>     Qu
>=20
>     >
>     > # btrfs check --repair --init-csum-tree /dev/sdc
>     > enabling repair mode
>     > Creating a new CRC tree
>     > Opening filesystem to check...
>     > parent transid verify failed on 1634923266048 wanted 1530 found 1=
532
>     > parent transid verify failed on 1634923266048 wanted 1530 found 1=
532
>     > Ignoring transid failure
>     > Couldn't setup extent tree
>     > Couldn't setup device tree
>     > ERROR: cannot open file system
>     >
>     > This is a backup drive, and I don't need it to recover, but I wan=
t to
>     > learn from this as much as possible. Power failures happen, and I=
 want
>     > to know what to do when the same thing happens to my main product=
ion
>     > filesystem.
>     >
>     > You can read more detail here:
>     >
>     https://unix.stackexchange.com/questions/509565/unrecoverable-btrfs=
-filesystem-after-a-power-failure
>     >
>     > And much more detail here:
>     >
>     https://forum.manjaro.org/t/unfixable-btrfs-filesystem-after-a-powe=
r-failure/80994
>     >
>     > I am writing here as I'm completely out of ideas at this point, a=
nd it
>     > seems like this is a very rare case.
>     >
>     > I was very happy to switch to Btrfs from ZFS, but now I am not so=

>     > comfortable using it, if a single power failure can completely tr=
ash a
>     > filesystem beyond all repair.
>     >
>     > Or can it?
>     >
>=20


--uVZEOYDVoo9FLTvwuDCNJ8KsLKeqlZswq--

--MQm7qSH5B2Kb6bOjAgtsLGYLUlD1DrHTn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyfbF8ACgkQwj2R86El
/qiNgwf+NABFWx82U5ldaR+E+VXmz+kssM1Jv1lNbLpc7itGFp2APBR0SRNvWLlQ
nOXtL3kHBKLnY4lLpK8d8PNmevYgV9j5KQaGNfdovns0fmFNf8glqMknjAOQFWtO
mda0THRw6Gcr9UAsFQdG6LCZoAct3DVWElhBAVb2rNUh42oZQl3Bbl03sqd1G6UK
P6kIc010jTRq6gNoJu9PlwPw6SB9tjlvdxqNk/oFv4wGkbvFqAYDOhgAfj7zS6CB
Cjb5U4G9JwrIyRy5r+2Xf7nK3cvPPlRZl8ZhLL7gAe2+c4WFXIPnDxvx830syO08
pOSgeHYfZDPXDRmtc4s8I9l7sXn5Uw==
=Liy8
-----END PGP SIGNATURE-----

--MQm7qSH5B2Kb6bOjAgtsLGYLUlD1DrHTn--
