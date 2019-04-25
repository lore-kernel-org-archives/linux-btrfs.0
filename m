Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A073C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7349B206BF
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Q/GogBMT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfDYOLx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:11:53 -0400
Received: from mout.gmx.net ([212.227.15.18]:38067 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfDYOLw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556201508;
        bh=AHeUVa4rPHE71YdPAN0gE+/2+aLJ5EptljVlOb7LOMo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Q/GogBMT3Wnz0iKB11zVqo/lziUqXiEVoMUcAFqDM8c2QEvqZuU4M6mbAs5mPLuYF
         j3LW7oMYasqG2hmzzHUUasHy0JgCinEZDLd5ec2vK1kHHSV/e/McwoxwNkTe0JH5ds
         59jYjb0eLfCQQ4/H6YNtWYsQE7pJb5/EO2R+1RDo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MBUqL-1hW5QS0DKZ-00Cy5z; Thu, 25
 Apr 2019 16:11:48 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
 <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
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
Message-ID: <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
Date:   Thu, 25 Apr 2019 22:11:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v3hJ6SKfQ8yAfor7IkyOOzi7GYay1JeIU"
X-Provags-ID: V03:K1:kkGGVcodVLcCk+gDfyK/+X6mxfJcwJatF6yDboDjGjSCgmM+Lht
 +1AaefTs3o+hP8uZsUj9TxLrvhMroEC5h/CH7EPQKdTAzr+GngENtXMxjvXMPTZWsaDjVXF
 dU/jPkvR8Q54Yn9wHXHVftxQjtq+3aFQ/tBsV1R5MeWhqhEUBzMi8NPoK1YQtnd4r7aIVSD
 1ialqCrDUzdr7F0FimCYw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JbYIaH24+EQ=:/V6QYab9WJWmFwM76voz4y
 9+wMpRdaAqRQc82VGXSwmrS9X6Wq7un7/pKHX+C1MlU6u+yOdZtxQy2XVHN2e9ycHDMYGQ+lL
 YUogA0Qw8V0aTKWVP9jG/kgUfRbo1Sy9uW6+StBmVZneZ11izShngtCjAzOmd2L18ioNp7kZi
 2Iy/sTz1mPfNmaLzvcN9K7Nt4cCitKMo/F/FkFMsethA73/DcyRUzMVUQ+wWpzajvveBxznxP
 evPq0k5IjQ9L172lmh/mzL7tRC0QtM8eftJO4hfSekuQgL6+mVkel/H5h7XDtKnPKQ6hWrlDC
 Gs64tsz7YujRWSJAxLZHBP4ON72mYICUMHCTNtEGLWFX51IvHI58QWZyuwZRgaW2Cxn/As4bM
 5PrzalIYaSz+SQm5d+tOh+eSQ+LoWTbjFPQ5jDbmPAY66I1/2ehj8n+i4vh46ba6JOWnKdp1s
 J33co7v1z5G4EAvRuudOSp6rFZbVmp/Seq5a6DG0oezRfKg0ZAkahACs+ke/ERKAdPK7CVqyR
 Ao7P4DF0AqEqm7JgA+DU16R+uk3TRJZG/C08iPeeeAqBR7RDtYUUlxOJU/T7esXNMwLS8DZl6
 xNZg8APYzHgI4rzYZoX6xq7EpadUmvWmX2Lr5vhFjN4JzhxkItjASqO3+y5ZigdkfNJ7LjpW4
 8TdMfLv0350JlmAtZ2jzDYX4tCGHMYG/aWBxWMDa64SbKkvXT0HvRXhRhgZPKTArupLGAihhK
 /oDIYcG52xGJxsZ1/16hYl1VEVsJqLa2X8Q2Ny/eBVpZcVobXrkHzItcqvujgl3kH+LimAntd
 5Ee/cShbk4IFb9aISYcWknojEe164psA/VBLxDbHf3Y1eeoFYQ+xy5YF0g3Yo5g9tyyB2PK6g
 7Hqc4S5yEBSBIW0+wPx4Gyk8B1cjqpmQ7Wnbh8TSMJBVi9ZLJ0QAtcCVPH3Iq0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v3hJ6SKfQ8yAfor7IkyOOzi7GYay1JeIU
Content-Type: multipart/mixed; boundary="CLx7040MCDr92rPypaSgtPTYFbdeAfvp1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
 <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>

--CLx7040MCDr92rPypaSgtPTYFbdeAfvp1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/25 =E4=B8=8B=E5=8D=8810:09, Josef Bacik wrote:
> On Thu, Apr 25, 2019 at 09:50:25PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/25 =E4=B8=8B=E5=8D=889:25, Josef Bacik wrote:
>> [snip]
>>>>>
>>>>> What if the commit is reverted, if the problem is otherwise hard to=
 fix?
>>>>> This seems to break the semantics of fallocate so the performance s=
hould
>>>>> not the main concern here.
>>>>
>>>
>>> Are we sure the ENOSPC is coming from the data reservation?  That cha=
nge makes
>>> us fall back on the old behavior, which means we should still succeed=
 at making
>>> the data reservation.
>>>
>>> However it fallocate() _does not_ guarantee you won't fail the metada=
ta
>>> reservation, I suspect that may be what you are running into.
>>
>> For this script, we only needs 4 file extents at most.
>> Even the initial 8M metadata should be pretty enough, thus I don't thi=
nk
>> it's metadata causing the problem.
>> ---
>> #!/bin/bash
>>
>> dev=3D/dev/test/test
>> mnt=3D/mnt/btrfs
>>
>> mkfs.btrfs -f $dev -b 512M
>>
>> mount $dev $mnt
>>
>> fallocate -l 384M $mnt/file1
>> echo "fallocate success"
>> sync
>> dd if=3D/dev/zero bs=3D512K  oflag=3Ddirect conv=3Dnotrunc count=3D768=
 of=3D$mnt/file2
>>
>=20
> Wellll we don't do the nocow check _at all_ for O_DIRECT, so mystery so=
lved
> there.

Oh, wrong flag, remove that oflag and we still get the same problem.

fallocate success
dd: error writing '/mnt/btrfs/file2': No space left on device
95+0 records in
94+0 records out
49283072 bytes (49 MB, 47 MiB) copied, 0.0807034 s, 611 MB/s

Thanks,
Qu

>=20
> Josef
>=20


--CLx7040MCDr92rPypaSgtPTYFbdeAfvp1--

--v3hJ6SKfQ8yAfor7IkyOOzi7GYay1JeIU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzBwB0ACgkQwj2R86El
/qhDSAf7Bf0xpG0omjtiwKW5091igK3dY3lJs5JOfB31V38HNVG8izrKkI7WrId+
C2qWTvCnRvyaR7kR6PJDp/RcII27Id0q77WMW+0AlE06WokNrhjoh0yuB/fM6J/9
bt97iLkF0aBrFXnzUgOLpsOu8chf2CfhsUvKoCOnp711rhf+1s2Rmu/23p7davqP
Weqjibng8diPuONz0AZqgcGdPOwGTjmINY0FjxhHlO8jKApqqram36fDiDhuR5/a
UOU/uCUPniVM8y2BBMLHxL6eD85z0Ka7fqMAIgtPMnOr92Ig2PXR2oKnOLPw2Rpn
qNJlO+8PMou1UR8W20A2RdHJoq4Caw==
=WlmB
-----END PGP SIGNATURE-----

--v3hJ6SKfQ8yAfor7IkyOOzi7GYay1JeIU--
