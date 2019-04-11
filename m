Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627FAC10F11
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 00:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F492133D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 00:45:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="fTMlmxWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfDKApX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 20:45:23 -0400
Received: from mout.gmx.net ([212.227.15.18]:38479 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbfDKApX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 20:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554943519;
        bh=TSTAfmQuC6tovfm9KEq1VU7pRzXUNq5XmwScB5wAfhI=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=fTMlmxWUtAh9yLlu29VK+LLVpl+uXK845DZrRMpFrcVjjqhDJQFNiD7O2RIG4LYN2
         yqDLCLxXKtRryyhYD9axrQTH2/4Yqkx38A50faOcNLArxxpCX1Q02E1k5jnVhO7W25
         K88+1eWJhQJ7l8yspS9qmjNzOm97PopgEsHIP3WU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LbMF8-1gTWVQ35mE-00l07j; Thu, 11
 Apr 2019 02:45:19 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
 <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
 <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
 <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
 <f6ee7655-e6e2-4162-6c34-7b4b3dba71c7@avgustinov.eu>
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
Message-ID: <b667bc68-2aa8-deca-161d-81f156d7e6e6@gmx.com>
Date:   Thu, 11 Apr 2019 08:45:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f6ee7655-e6e2-4162-6c34-7b4b3dba71c7@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WWz2acEgRmFztHvjnZbJY3q0AqZBBn42n"
X-Provags-ID: V03:K1:K9lzH6HnjxBLzNgupnIeCjy0gdEafCz+R8SWpYFK02NSP39CTuZ
 t1P6ASuQ114VyEcKsLygFpPmougrHZnkPp+d1lpAPqVAoIxAW+wYYsac+wkKutul4DFu/wO
 7PwTj9EaUS0RSfzSyLPpwWnAVskvjy6UZdnizsFTZWGkecLJc+xEAUxrBcZHis3CbAEeV01
 r8TltwXpLH4G4fL7NUX3Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:t6ymGSMJ5SU=:x4ppel2VD4cmuucuH7nkL8
 KngnMt7Flm1FEFxEmmjT/Fh7Fb5mccfXJgP60uLBGZYge4JH31qHRxXYWnuWiZWn00/W+oa+B
 614BRlYIP+ge6TpTQBFXBKG13qmLtlPzakySxUY9zgLFSu8pAx1NH63GMIF6ydZXbNZoV2I2n
 jopyVoCqwYr5ORKcsEnIx/BnnERYhXanvoURRU1pfV7rqJFqJ1yozBEVbgDFlAyt74oBk/k71
 vxz8BwMYxz+2OiwkFUi0ObMUKxA9fd+EklfnsmP3F6yMBzlsH68Je5hUMKsd1XQd4hozYAzXI
 nTOQ0sLafPKEgPUCm4vCLmDsUhL/n5shgrhrwjrNu90NGfUzLMbbF5CPW3Zs+FSs4HNJYHTlP
 puym7TlC1tDF+EAFUkpSvklOQlUcVPKDyMm6XYnMEWh4UZhtuJkc/d5tLLSlCjsAfLWe3Nh8G
 T1BqbJvuUdFBQsXSYnNQEmCMjicUuSzr8YhmeSEQzfrX2FfeK+mqrMmh8jNxtTTVUv6K4PjK2
 cYe343eH3QM2PPoQ5XJa0AHfQQdGMPEXjF34Q3r+T27S52DNd3615OasrF34gcfeky/VAy6/A
 F2n2EZ3v37wu1I+OgcdahQEhD/XixP1kdBvzel10K/1jSpXR4Zo+UxyfkGZ0Fp/Qa+R/Mu6fV
 En0PeJc3HeLhU48Ok+SFj7Du6tecl3Yrtmq+AYXjVW+ZG+Rl3D/yhGlyVO1mLuBhxySKieger
 c6szo4DZHo22vSNVx7tx9ssQ4HXfS0gl9Yjr/dWeqxQse8ymmlACgQeTyNOQQH/oVOPh5+CGz
 tULS2AIHSq2x4In76LQi78Qf+c0yTzKKpH1ykxd8f7NfifCvwfyRXfDS1b6qP3XdcEJDaM595
 i6+P1tbvLNP9gELf7OnQrYvnT/T/MWEBaYbPbXpWC41/MPEwgsKabFTmZ5YmMI
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WWz2acEgRmFztHvjnZbJY3q0AqZBBn42n
Content-Type: multipart/mixed; boundary="CswRee40tWTyhO45HKrbCDaylQeyqnU5K";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>, Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <b667bc68-2aa8-deca-161d-81f156d7e6e6@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
 <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
 <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
 <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
 <f6ee7655-e6e2-4162-6c34-7b4b3dba71c7@avgustinov.eu>
In-Reply-To: <f6ee7655-e6e2-4162-6c34-7b4b3dba71c7@avgustinov.eu>

--CswRee40tWTyhO45HKrbCDaylQeyqnU5K
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/11 =E4=B8=8A=E5=8D=885:03, Nik. wrote:
>=20
>=20
> 2019-04-07 20:45, Chris Murphy:
>> On Sun, Apr 7, 2019 at 1:42 AM Nik. <btrfs@avgustinov.eu> wrote:
>>> 2019-04-07 01:18, Qu Wenruo:
>>
>>>> You have 2 bits flipped just in one tree block!
>>>>
>>> If the data-tree structures alone have so many bits flipped, how much=

>>> flipped bits are to be expected in the data itself? What should a nor=
mal
>>> btrfs user do in order to prevent such disasters?
>>
>> I think the corruption in your case is inferred by Btrfs only by bad
>> key ordering, not csum failure for the leaf? I can't tell for sure
>> from the error, but I don't see a csum complaint.
>=20
> I do not quite understand where the "bad key ordering" came from, but m=
y
> question why (in my case) it keeps happening only to the btrfs file
> systems?

Because btrfs uses a more generic tree structure, to keep everything in
other.

Unlike other fs (xfs/ext*), they have their own special structure for
its inode, its regular file, its directory. Btrfs use one single but
more complex structure to record everything.

This also means, there are more somewhat redundancy in the tree
structure. Thus easier to get corrupted.
E.g. If xfs only needs 3 blocks to record its data structures, btrfs may
need 7 blocks. Thus if one bit get flipped in memory (either by hardware
of fs itself) it's easier to hit btrfs than xfs.


> Is it relevant, that all four failed systems have had initially
> ext4 format and were converted to btrfs (with the btrfs-progs used 5-6
> years ago)?

Converted to btrfs has some problem, especially when it comes to 5~6
years ago.
That old convert uses (almost abuse) a certain feature of btrfs,
creating a very strange chunk layout. It's valid but very tricky.
I'm not sure if it's related, but possible.

>=20
> Another question: I am sure that many btrfs users are ready in some
> cases to trade reliability for performance; wouldn't it be interesting
> to introduce a kind of switch/option like the "verify on", used many
> years ago on msdos-systems to ensure that write operations (especially
> on floppy disks) were successful? Just an idea...

My personal take is, reliability is beyond everything, especially for an
already somewhat unstable or easy to corrupt fs.

So from recent kernel releases, we have more and more mandatory
verifications.
At least we're trying to make btrfs more and more robust.

Thanks,
Qu

>=20
> My btrfs-restore is still running (since Monday evening, until now abou=
t
> 50% restored), and I am on a business trip. As soon as it finishes and =
I
> am back home I will compare with the backup and give more info, but it
> seems that this would need another day or two.
>=20
> Kind regards,
>=20
> Nik.
> --=20
>=20
>> I'd expect a RAM caused corruption could affect a metadata leaf data,
>> followed by csum computation. Therefore no csum failure on subsequent
>> read. Whereas if the corruption is storage stack related, we'd see a
>> csum error on subsequent read.
>>
>> Once there's corruption in a block address, the corruption can
>> propagate into anything else that depends on that block address even
>> if there isn't another corruption event. So one event, multiple
>> corruptions.
>>
>>
>>> And another thing: if I am getting it right, it should have been more=

>>> reliable/appropriate to let btrfs manage the five disks behind the md=
0
>>> with a raid1 profile instead binding them in a RAID5 and "giving" jus=
t a
>>> single device to btrfs.
>>
>> Not necessarily. If corruption happens early enough, it gets baked
>> into all copies of the metadata.
>>
>>


--CswRee40tWTyhO45HKrbCDaylQeyqnU5K--

--WWz2acEgRmFztHvjnZbJY3q0AqZBBn42n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyujhsACgkQwj2R86El
/qjqUwf+Kb7m7FM65v012J5Nm3K56yQUUA1W/iRhOqnFkb4wWhrKMKkZ2cM8PDGs
2LvnygGQEyIa5EiESIgXQ2o7nvr7bDcBfgAPHocVAjSUgI9qjH+eRJwMPnKP9x6o
y4FrloesAM3uU3TcPEUUoRrqrbnZ8JfbENa+ScAPWId9QxvT7Nx7ef7057WZcYsp
GB+xF0gKzj8Ecc3i6y+sV9QHLOI3RZWWATkshvDYCZ7B/WNKfj3I4eX2Yl9Y1rcX
0MvNMEqj2Lht/2HI5d6WfgOzo5TfgNv/54lwIPh6bJ/VCuBvW/Qrxt9Q00gSAlVi
z48AOmY5JnSVO0pJqdkf7aOCP04jjg==
=lNVs
-----END PGP SIGNATURE-----

--WWz2acEgRmFztHvjnZbJY3q0AqZBBn42n--
