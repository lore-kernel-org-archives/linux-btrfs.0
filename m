Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594D2C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 12:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D6FE20663
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 12:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="PgwhYhzw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbfC3MWd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 08:22:33 -0400
Received: from mout.gmx.net ([212.227.15.18]:36681 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730428AbfC3MWc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 08:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553948549;
        bh=lhZIgAG7MZ846Eaz+B2HPgJ4sM8og2nouEJEavDAII8=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=PgwhYhzwwv1ui2TiDkM+cDYGVq/rP05HFsWVlQMklVQTZNgt13ymmajksGk8hWIvw
         UV0KvuuUuWuxyEfyzVIgHldvJYCv9fAak9Zmp4Sa/pBk508obvzrpa46dbdk1Rgesq
         NaNsWGIVU4MtwomhX2QGP457/BCJCxiJwMrrzNRs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MOwbP-1h3rLo0NBH-006QP2; Sat, 30
 Mar 2019 13:22:29 +0100
Subject: Re: Unrecoverable Btrfs filesystem after a single power failure?
To:     =?UTF-8?Q?Tobiasz_Karo=c5=84?= <unfa00@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAOsCCbMp=Jy6jeZi_eSK_u77ScAaMC1-KWErxU9T=E3qMWQv0A@mail.gmail.com>
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
Message-ID: <828ef4b6-491b-0ebf-4b10-a33bb91ceeae@gmx.com>
Date:   Sat, 30 Mar 2019 20:22:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAOsCCbMp=Jy6jeZi_eSK_u77ScAaMC1-KWErxU9T=E3qMWQv0A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BQDP7zOuSUo3xxi6lwRdfNuG10ZuOQ1OK"
X-Provags-ID: V03:K1:rn7kLAsxwegAE0ri0o9kZKR6SxUJBp2p5a1gyL2CABaIN6LiBpm
 RPMU1XqPJ5MBEnwRbYT21hWe6IJaGe6WESGh+qw+ldZc6c4RXl7+3uiczATkcIdGfjQHJ+G
 DKZz+No63bZz0THOtiJwrYYqDtMc2kjtMfDz4YXGpdn34aEZh6OxnpxuiznZguDoYCUC+kq
 7cEPDlRUf8h5imY9AQh2g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zWoON8sPKFo=:Zej8ENudj7G9jN7UMTJzGv
 GwXLIw5JNuiztH7w1i3rwarwiqrSRreWSK9a/p2wie6h7aCGL9tlGUJGYvo4W9hWIbjl2+QDb
 eVrl7iUAfjLePejWEDgeXJ8GmfTrPIxdp17suRR38Stbu43nIy0/W7SlWj10K+qNdfneLdqrz
 aKMkBHpGNoy3+cfx10w+IEBNO7rheXglxsfbRE+2oar7OIFN6pVUeyeepEdLMMJxCwMdWuTrb
 DRV/Db+Qk4qHgaLWmn4bQqkcEyZAmOuJ4oSG7GTyHgJDcR9AYHmkFZvTMUKC1KM/5TUbI0/2B
 P9X8RjQm8ZbEbZ5iYFjc6GtD60aurUtfA5x1uSc9v4xAoxmFs1CXtcs9yYzKzq99FQQ7mVftT
 YpINKJrIveFB64uLyjWu+txpD7zTXraGPhyz7SZfjcSgBnGuR0+WZQtDP7WfJo2Dsufd1kOky
 GJGH/gaUTALS1/ovLRmMNpDo5SxZTOjN2eCRhmpKkcmbjn6d9fcWb2YC2WGHgp3iJKdJjIBQ2
 8YtrVsqibl5F7ImUnF23oSMxjlOeqnw0p82iMxoB6jY0uor7i4ZAVokS0pFmuA87+2FoXBizy
 Y0hu/MUgcYnwVuFNB7ba1FFC37/fdPZZRW7ZypJSUIRvR6+KDYvfF26kfgp0NEIyDD5BKR5kh
 boqu9egzB4fkGmaQsg8WEpNVSs5TMGWowEcd46VRwSnJHk0964hdIodI1h9erlGY1itQpIDiR
 5w527LJeN0B5wJlheXUCopPrjPA5UQYbItw4K1wpPTMSHjfoXyJ0efsUiTVbuK2pNSO8FgyXl
 BjwSclLBXxm5U/sFXVjVLnUlU2g2vBky18PgMUr9EY9HDbHSZN9EXZgp/lqIPw3/cszLE6FgJ
 WDzdX+ovlaAG9jTNwORUvXJshlF0SBLSaTZARICOEY92xWB32GTDPb3u4V6rfR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BQDP7zOuSUo3xxi6lwRdfNuG10ZuOQ1OK
Content-Type: multipart/mixed; boundary="h7Lpxc4En5RdBrXKYlRND72DzsSNS9VbL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Tobiasz_Karo=c5=84?= <unfa00@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <828ef4b6-491b-0ebf-4b10-a33bb91ceeae@gmx.com>
Subject: Re: Unrecoverable Btrfs filesystem after a single power failure?
References: <CAOsCCbMp=Jy6jeZi_eSK_u77ScAaMC1-KWErxU9T=E3qMWQv0A@mail.gmail.com>
In-Reply-To: <CAOsCCbMp=Jy6jeZi_eSK_u77ScAaMC1-KWErxU9T=E3qMWQv0A@mail.gmail.com>

--h7Lpxc4En5RdBrXKYlRND72DzsSNS9VbL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/30 =E4=B8=8B=E5=8D=886:26, Tobiasz Karo=C5=84 wrote:
> Hi!
>=20
> I have a strange case of a Btrfs failure.
>=20
> I'm running Manjaro, btrfs-progs 4.20

Arch based, so kernel version shouldn't be that old.
Good job on that.

>=20
> # uname -a
> Linux unfa-desktop 4.19.30-1-MANJARO #1 SMP PREEMPT Tue Mar 19
> 17:49:12 UTC 2019 x86_64 GNU/Linux
>=20
> I've been writing data with rsync to a 3 TB Wester-Digital MyBook via
> USB 3.0, when accidentally, I've cut power to the disk's power brick.
>=20
> The result - I can't do anything with the filesystem any more.
> Whatever I try I get this:

Please verify that, you haven't run "btrfs check --repair" or "btrfs
check --init-*" on that disk.

And if you have ran before, please provide the following the kernel
message of the verify first mount failure.

If it shows something like transid mismatch, and has the *exact* same
"wanted 1530 found 1532", then we are sure it's not "btrfs check" write
operation screwed up the situation.

In fact, just exposed in this weak, btrfs-progs write operation can lead
to the exact same problem. Either a crashed btrfs check write, or a
gracefully aborted btrfs check write, can cause the problem.

If that's the case, I'm afraid you can only try to salvage the data
using btrfs-restore, and remember don't run btrfs check with --repair or
any --init-* options, until btrfs-progs is fixed and a developer is
asking for that run.


If that's not the case, then things is getting really tricky.

The offending tree blocks are from the future, which means btrfs/kernel
block layer/driver layer/hardware controller doesn't implement flush/fua
well.

=46rom my personal investigation, btrfs follows its flush/fua sequence
pretty well.
Unless you're using nobarrier, btrfs shouldn't cause the problem.

For block layer part, I have seen some error reports on blk-mq in recent
kernels, but it shouldn't be the case, your are only 2 versions older
than upstream 4.19.32.

For device driver/hardware controller, I'm not 100% sure, as btrfs has
less flush/fua request compared to other fs, if the hdd controller is
doing some black magic to "optimize" performance for certain fs, then it
would have a more obvious impact on btrfs, but less for journal based fs
like ZFS/Xfs/Ext*.

Thanks,
Qu

>=20
> # btrfs check --repair --init-csum-tree /dev/sdc
> enabling repair mode
> Creating a new CRC tree
> Opening filesystem to check...
> parent transid verify failed on 1634923266048 wanted 1530 found 1532
> parent transid verify failed on 1634923266048 wanted 1530 found 1532
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> ERROR: cannot open file system
>=20
> This is a backup drive, and I don't need it to recover, but I want to
> learn from this as much as possible. Power failures happen, and I want
> to know what to do when the same thing happens to my main production
> filesystem.
>=20
> You can read more detail here:
> https://unix.stackexchange.com/questions/509565/unrecoverable-btrfs-fil=
esystem-after-a-power-failure
>=20
> And much more detail here:
> https://forum.manjaro.org/t/unfixable-btrfs-filesystem-after-a-power-fa=
ilure/80994
>=20
> I am writing here as I'm completely out of ideas at this point, and it
> seems like this is a very rare case.
>=20
> I was very happy to switch to Btrfs from ZFS, but now I am not so
> comfortable using it, if a single power failure can completely trash a
> filesystem beyond all repair.
>=20
> Or can it?
>=20


--h7Lpxc4En5RdBrXKYlRND72DzsSNS9VbL--

--BQDP7zOuSUo3xxi6lwRdfNuG10ZuOQ1OK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyfX3cACgkQwj2R86El
/qgRYgf+KMa1/MYzqAMQI/hQM24ImxlUL3AM9ysMdlRmUg59pWrSpiKF66McTwSN
RILA+t1vbQb6w7q2Ll79DU6VDhC8m/9G+Zl217MDkn/1gJ+teYE2K34g1Krmg5Sb
JJe/XkYwAWsiE+7N7imZTPk2XjHslNHWaQgzxAWr1EsC9gKcz4yb05TgfAVGZrEL
lwcuvGU7fMnfs2ibBJ/BVkxZy5X0y7rsPR2S1Glspumt3xRJ32y9ZYWz0WNWNIGg
p9jToQJazIgIIZ8dp1Ki6pUaHjZceYEL6IG7edYL2ts+fbz2JzKxC8H0f1fxuqyl
l15MvjZq7+ukQvs5D3dZPW5t8MCazQ==
=TmS3
-----END PGP SIGNATURE-----

--BQDP7zOuSUo3xxi6lwRdfNuG10ZuOQ1OK--
