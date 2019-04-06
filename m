Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1B6C282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 762E621871
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="gc8o5kRN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfDFAWW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 20:22:22 -0400
Received: from mout.gmx.net ([212.227.15.18]:35223 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfDFAWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 20:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554510133;
        bh=I2RL8QeOaqgcEO63fIFqtr9JoSgV3v1F7fEFOa8i/Ck=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=gc8o5kRN4JvM+oTEE1N698GcoHzNNDYVWYSFzufqvOLEQ01z1ridxGY44dG2toNqH
         KOPARZEVs/sQGKHjSGJtKQinpSDYQLOZ8SGmnf+KBa1iOBemrQvyO1RkwBI6S5+jxy
         sV+D2hc+CCyY86G0QtD2vrLh3w0sNdNCML5TjiD4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LcBBl-1gT1az1cGr-00jct4; Sat, 06
 Apr 2019 02:22:13 +0200
Subject: Re: [PATCH 0/2] Fixup and optimization for write time tree checker
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404034708.3399-1-wqu@suse.com>
 <20190405154945.GX29086@twin.jikos.cz>
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
Message-ID: <d17bb3bb-456f-0940-d95e-9cedc2ce4406@gmx.com>
Date:   Sat, 6 Apr 2019 08:22:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190405154945.GX29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ayb1iU5c281tBkDNqWhm8b0rg2gn9wCjC"
X-Provags-ID: V03:K1:Gyi6jvWF//6078UfCs1Xq2dP9xI7wS/eMud8GhCDRy9YebvFQOb
 tcz/jdd4WcDlxHL6rRkGhqSxxVv3E+6jNSWCuADSmWALzicOZ53y+UMeWY+kCMMEs5msejy
 fBGEaqNalcxkJhky99NV+gZlwgFALreZxLOEh02/5Zn+hD6rnDO8n4AOrGqabCxeKsOhxQO
 VWCmUFbd05j2gujQ4cxiA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8Cr1eMDtK8w=:iu4xI9mHEj0ligCTKYjnE9
 nZRVZRjMl/PuFrM8d4zWh2REDvnWIqSe9PITz+UcZSX5zSj/Dm4U8ng1mvMaCOITgr2CRxsb5
 D33TzBZqAxAxGNh9qm6eaTzTvrvl2M2hMApw5gClYpaaxwguMITAhkPDEwPbloK7ofqB57len
 UwAShZ9FRvzKtPi+E5KM99koZALNE5I4/3QHiBIxYE9xS/KJZ+JNo9Q0ypI00pGpVigOvSFi+
 nCeAmtEAHRe2X0NdT8qAS0HsPlaUIxrPjsNZV3bJMC+T1w7gRZzFvSw3qf3QyEk6ynmX4p8DH
 V2TmwkcLYHrALp+/NxBGzo5oB16ZKeV/Ij2wW+O7i889cFJXdiiYgFh8U+RqWttwSmaYxpobo
 qXsew6ZdfTFdrjo79XuwsXAx6cOl1bTMYHPCf0ckQ88T7b+GQerdrfEYHMxYr2hnt9Y2Xv/Lz
 O+SayA39Vv9ovtq72dDzNpY89zhs88YYs9sTUhnabxQ36VyJC5x+Sp9qBXqUk7gIQw1RGVgO7
 b7IwHLEcXlhGh1XMB+1RaYvJ684+CxpzU/vj7IKEeWSA5+OLZc1P7pgsimB9mTxqzAV5JQoai
 WZFwSXvTTWZ6U52UzAMtOuzd+pCTPdPNh1y4dwq5R/fCJmH5sbGA7QiJ2R9Z8NwD2ViNqDrkw
 OftcT0IBCp2s3ySJ+Uhd7vd5mavQMvTSoohxGROxNjCBIRPVUqeEaWi2zET/spgTpulZ3cgXE
 5A+pZiZxwI3XLt+CV4y/aTMy0TMmQjEziUmToNblJOUlpDN2/Sm3yxEKzxfbiwP75qwoFcm4+
 tIpf3c/N+3Am8/MO/ZXWHVGFqr3u3XS34MoKaID2ndj6sj8hKcZNTDlQa2XMfFVZRLDr7idNJ
 uMwST8dGf6fRVWRZCBMbdy5QUu9R5qC6QGh+QtBhwEv6ASMgahgekXu+YWNe9j
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ayb1iU5c281tBkDNqWhm8b0rg2gn9wCjC
Content-Type: multipart/mixed; boundary="WMnBKzU9MXZa9G63NwpYQ7MzOYN35sa5E";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <d17bb3bb-456f-0940-d95e-9cedc2ce4406@gmx.com>
Subject: Re: [PATCH 0/2] Fixup and optimization for write time tree checker
References: <20190404034708.3399-1-wqu@suse.com>
 <20190405154945.GX29086@twin.jikos.cz>
In-Reply-To: <20190405154945.GX29086@twin.jikos.cz>

--WMnBKzU9MXZa9G63NwpYQ7MzOYN35sa5E
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/5 =E4=B8=8B=E5=8D=8811:49, David Sterba wrote:
> On Thu, Apr 04, 2019 at 11:47:06AM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/tree_checker_testing
>>
>> Which is based on misc-next, with the following commit as HEAD:
>> commit 56d46f96de92ec69963acb7b1d9aed83d2a56a7b (david/misc-next-with-=
write-checks, david/misc-next)
>> Author: Nikolay Borisov <nborisov@suse.com>
>> Date:   Wed Mar 27 14:24:18 2019 +0200
>>
>>     btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_b=
it
>>
>> These two patches changes the behavior of write time tree-checker, whe=
re
>> the initial patches didn't check the content of the leaf, leaving memo=
ry
>> bit flipping possible to sneak in.
>>
>> This patchset also introduces a new optimization, where original empty=

>> leaf owner check can be pretty expensive and cause false alerts for
>> write time tree checker.
>> With this new optimization, write time tree checker can reuse the
>> existing btrfs_check_leaf_full().
>=20
> This on top of misc-next throws 6 'write time' errors:
>=20
> btrfs/101               [14:00:24][ 3963.736352] run fstests btrfs/101 =
at 2019-04-05 14:00:24
> [ 3970.417649] BTRFS error (device vdc): block=3D2446344192 write time =
tree block corruption detected

In my case, these tests just pass, so I haven't checked the dmesg.

But indeed I can reproduce the same dmesg line.

Before removing the device, btrfs will use btrfs_shrink_device(new_size
=3D 0) to remove all data from that device.

And that will cause on-disk total_bytes to be 0, triggering the bug.

So indeed the behavior is different between read and write time.

I'll check how to do it correctly.

Thanks,
Qu

>=20
> btrfs/151               [14:06:52][ 4351.133395] run fstests btrfs/151 =
at 2019-04-05 14:06:52
> [ 4351.659771] BTRFS error (device vdb): block=3D570572800 write time t=
ree block corruption detected
>=20
> btrfs/164               [14:07:19][ 4378.349990] run fstests btrfs/164 =
at 2019-04-05 14:07:19
> [ 4380.645918] BTRFS error (device vdb): block=3D2479882240 write time =
tree block corruption detected
>=20
> btrfs/176               [14:07:39][ 4398.493736] run fstests btrfs/176 =
at 2019-04-05 14:07:39
> [ 4399.186203] BTRFS error (device vdb): block=3D22036480 write time tr=
ee block corruption detected
> [ 4399.302700] BTRFS error (device vdb): block=3D1372585984 write time =
tree block corruption detected
>=20
> btrfs/184               [14:10:13][ 4552.496289] run fstests btrfs/184 =
at 2019-04-05 14:10:13
> [ 4553.292780] BTRFS error (device vdb): block=3D4602216448 write time =
tree block corruption detected
>=20
> Have you seen the errors during your testing?
>=20


--WMnBKzU9MXZa9G63NwpYQ7MzOYN35sa5E--

--Ayb1iU5c281tBkDNqWhm8b0rg2gn9wCjC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyn8S8ACgkQwj2R86El
/qjNhggAsnTT2sp12Z1atZFjjtu3UoEJN0OanRQsuPxNfHamB/bAazlC7tvQp2D9
lBquiUn5hdIhQSgI5oj4UBb/8rVcnQZqtlJni1+cbDNInOaBHP1xaeNDHfaGTa4/
qlL6EOnnr6Xog7PEF7Bx2EXTJ4yUYGl1XnYV2yNTe9C7oeu1suMNTB4tzmSz8UfP
RzrHCSEPX1kMOvmsvU54BVqWoiywF5hPyHxJ+KwGyx7pFBPp3wLN3qLd9/OompBH
9NtlsGjjvBGI1gQg00o4vycnVJPefvWM83IhU3Q68UMtuCRvf0Rq5Y27Uu08dqqN
ObqqbihJHw6BNKviNvUzTZZyIoKl6g==
=e6NJ
-----END PGP SIGNATURE-----

--Ayb1iU5c281tBkDNqWhm8b0rg2gn9wCjC--
