Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F05C65C30
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 07:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532AB2088F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 07:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 532AB2088F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbeJGOpv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 10:45:51 -0400
Received: from mout.gmx.net ([212.227.15.15]:59209 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbeJGOpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Oct 2018 10:45:51 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lfjxq-1fKofH0Lco-00pN9A; Sun, 07
 Oct 2018 09:39:26 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lfjxq-1fKofH0Lco-00pN9A; Sun, 07
 Oct 2018 09:39:26 +0200
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
To:     evan d <forumscollective@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
 <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
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
Message-ID: <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
Date:   Sun, 7 Oct 2018 15:39:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QAlU9UNWn919WtnLEfAzHeYkl7q6P2s4D"
X-Provags-ID: V03:K1:jEfWHeQHPMuen0t2qTcd6GGcaoy1po4Hm0WfRUMLE4hbYFz+k4q
 OLdoP4uV2VLhbbltsxAbIZHC2m58ZIdSx2aRros6nG4PFiUwG2ISTcBnZhvsKeZdBimv2aG
 O3CskZd/V066a40bOFATy857OiiiAXOb9mTHycSSHJrfx0WVYTN8QrfdbYVtDcAsLBN+mAf
 jwm5pZi0aaxjkR26X41NQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:txeGkjteMcU=:tt5HRT/1JDWunyrSm8gzpH
 Mbm2Gon0St+FDn/gqaiKwBPbxwT/j58F/JciP6ekvvTyFwDlPbVbjhjzDmdlhvcZWYIRNibB2
 DXd4NzWWIk+jOqI+SphNIG73++T3B/RE/1dL/tPLTkxjeXEYYqMKPt5yQZuSLoN8OyskQbnss
 fXCB3yCKmp8O2yk9t7oe6y/nrfwg9PeQrBcLyvY0GJJBEm0CN+AcbjOReIMOO9uMOKrLdJpk2
 2DPgVSimHRm2hGlzgCS1NoVtXTsxNB00xgEvhZj0UdRQ13TZ2WRre57eHCZXawc0NQmrl6xSF
 Lb8Jd7oTr10TRhc0SSDLkq+WMmJz7NaMu+MLhIzPbNJqUwS9FmSkhG7ne6o69P5MVB9mAF4ia
 wGjYxVobg4GUVjbhk47hPKMWFwiX2MQ+gOcIVDSQLUWz64fpvXBYMcd2SVzPWrGJfgK3gYvzE
 ZJ5gaX8xA7YFTJ2xp4tJokbeBR1TvmbhvsU5z3KeSv0Nl4iTXfgcxFyeCJF2XWzYVt0OlolOC
 70DdoEeHGXONLH8IaqduK+oRzMmGqOD4dwivUXjWytNqNNz711YKa+DP+youplANkmVOnT4h1
 /+VwWk49pYiIEWOH/PgZxOJm6s6HyyFwXqmTSjaXunoBQO9OY6KGxDbfut629yGFc8MJXLj2m
 8M9VLo25d3HHhHdKNIQbc1RK46uBuy3e+ecyGLFgM3pPTcfJDUQZGwtLsbv3Bk+ZGB97b7RtR
 pMF+JZJLen91d3OpFax4dduQaw3r3SBs7d5jv/AiVgzuzihwcW3jz0GqI3NKoSa/tg2kmBRpb
 ow5CgTUrtvG0xuSjyQvkVUQQ0Mtdg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QAlU9UNWn919WtnLEfAzHeYkl7q6P2s4D
Content-Type: multipart/mixed; boundary="CIzynXWYWGg0U76pubrPEorHldfTgz18g";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: evan d <forumscollective@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
 <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
In-Reply-To: <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>

--CIzynXWYWGg0U76pubrPEorHldfTgz18g
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/7 =E4=B8=8B=E5=8D=882:47, evan d wrote:
>> None of your super blocks has correct magic.
>=20
>=20
> I take it this applies to both drives?

Yes, both drivers have something wrong.

>=20
>=20
>=20
>> This means either your whole disk get corrupted, or something introduc=
ed
>> some offset.
>>
>> Please try the following commands to dump more data around super block=
s,
>> so we could be able to find the possible offset:
>>
>> # dd if=3D/dev/sdb of=3Dpossible_sb_range.raw bs=3D1M count=3D128
>> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" possible_sb_range.
>>
>> For a valid btrfs without any offset, the result should look like:
>> 65600:_BHRfS_M
>> 67108928:_BHRfS_M
>=20
> # dd if=3D/dev/sdc of=3Dpossible_sb_range.sdc.raw bs=3D1M count=3D128
> 128+0 records in
> 128+0 records out
> 134217728 bytes (134 MB, 128 MiB) copied, 0.737479 s, 182 MB/s
>=20
> # dd if=3D/dev/sdb of=3Dpossible_sb_range.sdb.raw bs=3D1M count=3D128
> 128+0 records in
> 128+0 records out
> 134217728 bytes (134 MB, 128 MiB) copied, 0.726327 s, 185 MB/s
>=20
> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" possible_sb_range.sdb.=
raw
> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" possible_sb_range.sdc.=
raw
>=20
> Both return nothing.

Then this is not good at all.

The super blocks should be at 64K and 64M.
If first 128M doesn't hit, I highly doubt something more strange happened=
=2E

>=20
> Both drives pass S.M.A.R.T. testing so I'd have to think the
> corruption stems from some kind of offset rather than random
> corruption.

Corruption shouldn't happen like this.

And offset shouldn't be so large to offset the whole 128M range.

I'm considering something like encryption.
Maybe the disk is already encrypted by hardware?

>  They may have accidentally been inserted into a Windows
> machine (but not partitioned or formatted).  Could this be a likely
> cause?

Windows is just a black box, I have no idea what a Windows could do to a
disk.

But it doesn't explain why the 2nd super block can't be located, unless
Windows is wipe more data than the first 128M.

If the disk is larger than 256G, would you please try to locate the last
possible super at 256G?

# dd if=3D/dev/sdb bs=3D1M of=3Dlast_chance.raw count=3D128 skip=3D256M
# grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" last_chance.raw

If still no hit, you could try just run the grep command on the disk.
It would take a long long time reading all data from the disk.

If still no hit, it means definitely not some easy offset.

Thanks,
Qu
>=20


--CIzynXWYWGg0U76pubrPEorHldfTgz18g--

--QAlU9UNWn919WtnLEfAzHeYkl7q6P2s4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu5uCkACgkQwj2R86El
/qiltggAsBoY9Fdx5+g1XY1oBSPKrc+r0QXUCwUB1UOFG3tR1Wy/K+v8PibHgC/V
uPkJMCLk/RzN3zhKahSMzLbNlBRJx1Z6ccphn/JZ0YD2tmec4bbbUOuguOZ1UtS9
367SMcKHIJVb80n17s4pVxAL8sGNJE4e2GjxH1C8TTyp9/aNxsqeoJgXtZTLOEfX
cePjMZIGRGu1aM0fdOrgg3Ig5EBriFdbjHDMNXVVPJkdLgU7M7C/DHWGBOyLbUUy
1833P1fc3qUjS9fFd/vk9JDg2EO34uzTD7HZqSPfSI9vZteCZ1d2HgH5gJN5qbOj
5inF3qU1qXm4Yl8HwrmPI50s1Jyh9Q==
=eoAU
-----END PGP SIGNATURE-----

--QAlU9UNWn919WtnLEfAzHeYkl7q6P2s4D--
