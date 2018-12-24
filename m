Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D14C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 02:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BBAB218A3
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 02:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbeLXCAp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 21:00:45 -0500
Received: from mout.gmx.net ([212.227.15.15]:51647 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbeLXCAo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 21:00:44 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lh7sF-1h83TS1mSt-00oTGm; Mon, 24
 Dec 2018 03:00:42 +0100
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Chris Murphy <lists@colorremedies.com>,
        Peter Chant <pete@petezilla.co.uk>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
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
Message-ID: <2dfe1853-07bc-2db4-9797-5409ff74114d@gmx.com>
Date:   Mon, 24 Dec 2018 10:00:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3ckLyGIx6IsKdAtnDFv4JkLhhQQjTUurO"
X-Provags-ID: V03:K1:UGsD1FyYmc1Ngj6IGij5NdkwfQu7jLqi5pJh0neYg7ZQFhlDQ6+
 PDBkF5NRMuCZiuExNhnWX5TrNkmmB0YQDc8xH5vhdKTnCbVq0dVjh0gSD91eGRgir213vRX
 W4/HtMaAyrTmRzGPLP9HdPRb/XmN/ukfPIaQGtSMWIHV7hAOlE2YplOQtQUcySnjuRVkDiZ
 WofxruZ43BmlUETWRQltg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Kb9dhjzvPT0=:1cSOh8z7reUefErGICgOzG
 NFnixNP+2R2JxoJBPoBYrQx7smX3Cc4DBXLXuobZfhOfNfqeBHNOkPBcp50EG6wWalNzEVohG
 4/BIqJcVhRfPttLD3avSBju8HMJWBSfGcfhLHgs+FSe0V3HMN0SpVLPBub5spXv8sgYibGAFI
 R/PkLXXtKDPUrb99GoCjBL9OxbT6yCT3uUeSnkpN5Nhx0fXg9DdOImFKDKy47NqPPAmAOgvbu
 eSOB+n8Gmjd1EaqJ3zEJtR1RTQEUVz3nhvZqsIb31i1g80PjY1NfKvbm6nnX9QopVudZikZsc
 xrJWH5QcGjcKVyEE3/iR/W2S7z2aMRxm+1r8g/GEGXu/gEUWzZj1ZfKVE9uYNfilD6jseQF0N
 q0rYQNJZWFYildqA7alhjlyUsTtYjbYakT2eGHT6TZsioJcRjfgCWaoO62jeQv+xd7pkM7jv+
 xsvDt8E1CA8Yb9RHznQKpqrN0UsfDKIKR5jdl1VJzsaJOvkvvk3SBouM9Jcj4mHZCTQ4cOQY3
 ARsF0Ga49quyO/LAF4TXk+h3hTrd1zfPujji3oOIzGFCfd2y4P5xYSel61hYl1D80AK0YAA6B
 TuBLwfYDqsdDbW+3/2m47raJgB2BFFkM55X3iiFxWgKeC6sNzUYQcAvGkb7NSnpK4Sm1e4p58
 VcqQ/kIr3C8k+KHSpGsFyKlTg0GpUmDFuo/H6YeHVlPBHLOAxa8HjGD66IAMbYcM2I4iFhTrZ
 gIp7FHtVy4B4FChYXrcCZUMvVHHic7vVWmuk6IQuisrIIFadjmufjcbkL+oZoAhSKnOhoZoGu
 sNmuleZqQ+a6hNfx8IjO6ewT3t8q8WwuQiR8Awg9fPr5YEruNpeWYu7g3Zkkoyf1YoafBp09e
 4/HbEAB6YPwSYp7JgMKRRP9502Y9jlAq6unA1WQIqfQya6G4rHsNmGhjpByjE3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3ckLyGIx6IsKdAtnDFv4JkLhhQQjTUurO
Content-Type: multipart/mixed; boundary="rcu9dIhBGFIHm2vgtn3EHUNVFWCt6bSA7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>, Peter Chant <pete@petezilla.co.uk>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <2dfe1853-07bc-2db4-9797-5409ff74114d@gmx.com>
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
In-Reply-To: <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>

--rcu9dIhBGFIHm2vgtn3EHUNVFWCt6bSA7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/24 =E4=B8=8A=E5=8D=888:58, Chris Murphy wrote:
> On Sat, Dec 22, 2018 at 10:22 AM Peter Chant <pete@petezilla.co.uk> wro=
te:
>=20
>> btrfs rescue super -v /dev/sdb2
> ...
>> All supers are valid, no need to recover
>>
>>
>> btrfs insp dump-s -f <dev>
> ...
>> generation              7937947
> ...
>>         backup 0:
>>                 backup_tree_root:       1113909100544   gen: 7937935  =
  level: 1
> ...
>>         backup 1:
>>                 backup_tree_root:       1113907347456   gen: 7937936  =
  level: 1
> ...
>>         backup 2:
>>                 backup_tree_root:       1113911951360   gen: 7937937  =
  level: 1
> ...
>>         backup 3:
>>                 backup_tree_root:       1113907494912   gen: 7937934  =
  level: 1
> ...
>=20
>=20
> The kernel wrote out three valid checksummed supers, with what seems
> to be a rather significant sanity violation. The super generation and
> tree root address do not match any of the backup tree roots. The
> *current* tree root is supposed to be in one of the backups as well.

Oh, I missed this.

Indeed, super generation should match one one backup root.
There are cases where we won't record backup roots, but that's only for
fsync() calls, and for such case it should only update log_root, not
root generation.
(But I'm not that familiar with fsync() nor log tree codes, I could be
totally wrong)

But at least, its log_root is 0, so it's less possible to be caused by
fsync() routine.

>=20
> Qu, any idea how this is even theoretically possible? Bit flip right
> before the super is computed and checksummed?

7937947 =3D 0x791f9b
7937937 =3D 0x791f91

The last low half byte, it's 0xb vs 0x1
0xb =3D 1011
0x1 =3D 0001

2 bits flipped. I'm not so sure if it's possible.

> Seems like some kind of
> corruption before checksum is computed.
>=20
>=20
>> I'm getting suspicious of the drive as when I was trying the various
>> btrfs rescue * tools I saw a 'bad block', or similar, error displayed.=

>> I also have a separate basic install on ext4 on the same disk.  Though=

>> e2fsck shows no errors and mounts fine I cannot log into that install.=

>> Maybe a coincidence, but too many bad things thrown up make me
>> suspicious.  Whatever is happening this seems to be really fighting me=
=2E
>=20
> I'm not sure how even a bad device accounts for the super generation
> and backup mismatches. That's damn strange.

Yes, indeed.

I'd recommend to use "btrfs check -r 1113911951360" to verify if it's
only superblock generation corrupted.

Thanks,
Qu
>=20
> If you get bored with the back and forth and just want to give up,
> that's fine. I suggest that if you have the time and space, to take a
> btrfs-image in case Qu or some other developer wants to look at this
> file system at some point. The btrfs-image is a read only process, can
> be set to scrub filenames, and only contains metadata. Size of the
> resulting file is around 1/2 of the size of metadata, when doing
> 'btrfs filesystem usage' or 'btrfs filesystem df'. So you'll need that
> much free space to direct the command to.
>=20
> btrfs-image -ss -c9 -t4 <devicetoimage> pathtofile
>=20
> It might fail, if so you can try adding -w and see if that helps.
>=20
> There is no log listed in the super so zero-log isn't indicated, and
> also tells me there were no fsync's still flushing at the time of the
> crash. The loss should be at most a minute of data, not an
> inconsistent file system that can't be mounted anymore. Pretty weird.
>=20
> What were your mount options? Defaults? Anything custom like discard,
> commit=3D, notreelog? Any non-default mount options themselves would no=
t
> be the cause of the problem, but might suggest partial ideas for what
> might have happened.
>=20
>=20
>=20


--rcu9dIhBGFIHm2vgtn3EHUNVFWCt6bSA7--

--3ckLyGIx6IsKdAtnDFv4JkLhhQQjTUurO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwgPcAACgkQwj2R86El
/qj0wwf/Q6ev9MfS7CEu1d7EeeJ9qcUGd311VTZUzLGz/hUpHU2Oehe/LtJtu5Ry
FsAMiIvQLpTpCa/zhceVuKCpxz2QBXVe5J2p/IH2ffeiKRWB+vSf8t4ONyvrpG+q
gO3Kf0gDTxm9XBEdaTNfWSY/nnLxeb9jf6K1QHeMRLW7cGJjex867YbdxX4npPdV
C42zSeG4S9+iivNqaV3BTRSNn+qU3mgprf+5cdVSdFLW9emf6Zo6oovItd9xdPFx
k1UK7qsR8iMIJy8Jz3n7PvRwF6GbZA3NE3Xa04gJYIfopHB+mWP37M1zjJNQkSoy
+fKFcAwj75foVvghu5N5SlpmDjTRiQ==
=PFPA
-----END PGP SIGNATURE-----

--3ckLyGIx6IsKdAtnDFv4JkLhhQQjTUurO--
