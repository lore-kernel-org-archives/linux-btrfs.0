Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9282DC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49ED9213F2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MvshnnKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfDHNJs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:09:48 -0400
Received: from mout.gmx.net ([212.227.17.20]:59343 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfDHNJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 09:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554728984;
        bh=pJGX+w1TGF1B7HlahdSYdhYK++ho8G3FzKl7cBtzY9c=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=MvshnnKNycXitJv1uRd86J8NA5CYj3UP2b2nepZtX/7uyxQRdSHcvwIAVdHHBVQM5
         s1YAHK8b3suO+DIi6h8M35qjhhuHmwSESKF4+qpNoJ0wBLWF7OKNpLEa/2Ob6Lftc5
         TsPCeHSsf2FNLF83rnW7wokbuS7lfpOL+rjUO3hc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MDE6y-1h81zH1oQm-00GYvL; Mon, 08
 Apr 2019 15:09:44 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Chris Murphy <lists@colorremedies.com>,
        "Nik." <btrfs@avgustinov.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
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
Message-ID: <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
Date:   Mon, 8 Apr 2019 21:09:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LhDgwW9oChW0InIFxANOfpZgyii9l2ZH3"
X-Provags-ID: V03:K1:9ybHNEawdd15TZlRVhN91PppsXMEnZq7sf0ag+WnS7xZ4lt3hvT
 eFY6g8Vifzz/HebmocIJXVFeg1k7nlgYJ1ean8FMkQ/9zALL1DDmYyV7tOub2Yz0nDUsnAw
 v2MeEAfc3snqi4lCIzcvoDWP2dDueK0NydjCxIEJ/oxSgPp0XeN99MtSoMbPEFBYh/o8CTI
 Xa7FZlrSgGj0dqypv9I6w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:t5oGjJ8dzLo=:iQBpO+wwdiOWPfCptki/GH
 w2w6rHBLtXq6M2y1cV7AVTMzzxGOGSW6V9wFJ/6mm0C0D7WYWuU4nB2xeyu1vb6gkP1nzm9I/
 wItqYQrfosP4PQKioOrc2xiEIMqgiBolZtOpbc0bhelYrn+5EY06IJ8BL2UWEcWCHow4Z7XNe
 m5wJDecz6Eu/X2MPzSHT7ZCg+7j5QJwnq5z8mARqdQ/5EHhFu7qPRM4GDinQ/07AFzjuRc7al
 YfDNfBpsvOZUiTFpf0IFsEFK17xPq8XZCzTMVBL2Rh2SfkNpV5Cr86zVqwebke7u2lDcQ6F7R
 444WfOhTGDGbhuSfmS/kOIoPq/KLpq9S0TqBhMf6VELK1CB+y4+146G8uu3e3IZ6oyCcmK7+9
 zcEsehQZc2PxvhtXFyzmSa1U3YrxHyVMfno2xajIHcdHX8nGmDKtj+chsPHMhC6KHOTbqbvDY
 FB++3vFiqFBFNXIh84tR4aXasAIetyFTTlF4NOjBU1UaTISyK5X3ujMZszbL0oIDZjjAuyd+2
 B9HpXLnSOusmTKz4uzl4p4UBAEzmhqhxO9MGO+IDXwuCxZOrdXVkXYmLVX5XGGnhqdG9W6CYt
 sm5+yAZNMCNSFL1OFkkOrFW7QQeByVFFolDXzPAgdXtufuXsqpxqeP/HnDC3BJiQNkPa8aSV3
 44jMF44tgwYAqQDHrXKv2BEo1Zy8KVR8itfhApu22FcmEn0fxWugfozdVzNfMhicw88A5wOCs
 DpbL8OhbNMa74250BQ6BaUbymT8HzNnblJMRKdZiJ7ZK9CFWMVi+2l3FkTNL9I8Uh2D/Sb6P4
 TxMhc3nYGazwxNj5BYJHd5Vf7jx5DgiUrxolonqaqtlQxkdQI/afzn42BbYHFiAGk2HQbHbyu
 VzqWYJ+1B6QsyDkJsHyXxjTVuobQ/jua2ItbKFqT9a7sSxbLpSSYOK3NjfXftn
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LhDgwW9oChW0InIFxANOfpZgyii9l2ZH3
Content-Type: multipart/mixed; boundary="w7s8jnUjLUxRaKPSUCIjHX7nukgDmlLak";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>, "Nik." <btrfs@avgustinov.eu>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
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
In-Reply-To: <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>

--w7s8jnUjLUxRaKPSUCIjHX7nukgDmlLak
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Unfortunately, I didn't receive the last mail from Nik.

So I'm using the content from lore.kernel.org.

[122293.101782] BTRFS critical (device md0): corrupt leaf: root=3D1
block=3D1894009225216 slot=3D82, bad key order, prev (2034321682432 168
262144) current (2034318143488 168 962560)

Root=3D1 means it's root tree, 168 means EXTENT_ITEM, which should only
occur in extent tree, not in root tree.

This means either the leaf owner, or some tree blocks get totally
screwed up.

This is not easy to fix, if possible.

Would you please try this kernel branch and mount it with
"rescue=3Dskip_bg,ro"?
https://github.com/adam900710/linux/tree/rescue_options

I think that's the last method. Before that, you could try
btrfs-restore, which is purely user-space and should be easier to setup
than custom kernel.

Thanks,
Qu

On 2019/4/8 =E4=B8=8A=E5=8D=882:45, Chris Murphy wrote:
> On Sun, Apr 7, 2019 at 1:42 AM Nik. <btrfs@avgustinov.eu> wrote:
>> 2019-04-07 01:18, Qu Wenruo:
>=20
>>> You have 2 bits flipped just in one tree block!
>>>
>> If the data-tree structures alone have so many bits flipped, how much
>> flipped bits are to be expected in the data itself? What should a norm=
al
>> btrfs user do in order to prevent such disasters?
>=20
> I think the corruption in your case is inferred by Btrfs only by bad
> key ordering, not csum failure for the leaf? I can't tell for sure
> from the error, but I don't see a csum complaint.
>=20
> I'd expect a RAM caused corruption could affect a metadata leaf data,
> followed by csum computation. Therefore no csum failure on subsequent
> read. Whereas if the corruption is storage stack related, we'd see a
> csum error on subsequent read.
>=20
> Once there's corruption in a block address, the corruption can
> propagate into anything else that depends on that block address even
> if there isn't another corruption event. So one event, multiple
> corruptions.
>=20
>=20
>> And another thing: if I am getting it right, it should have been more
>> reliable/appropriate to let btrfs manage the five disks behind the md0=

>> with a raid1 profile instead binding them in a RAID5 and "giving" just=
 a
>> single device to btrfs.
>=20
> Not necessarily. If corruption happens early enough, it gets baked
> into all copies of the metadata.
>=20
>=20


--w7s8jnUjLUxRaKPSUCIjHX7nukgDmlLak--

--LhDgwW9oChW0InIFxANOfpZgyii9l2ZH3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyrSBMACgkQwj2R86El
/qiNRAgAn6Y8hdOjo+b0UWe5Hn0xqTmiri9OLT1+kjrP7/RHvE2DTwsnKbrDhyDL
omnhniHX6cbyGWwaIcq7F5pgaTCrKhmcIXyaf5Q+gfzL13HBYjBsQ7sZkaS8J83D
Nbk0M/FzYpStIl0ayf/3i3Y4ZAaFMDdJTMYk7nNqBy5MNSzeYfYK5luOkiZ4SjA5
2rMNNzwEkfqEGumXnk6lRKDg7x+0JEY8UUcNMeTrCU0W2o8tIZcW15HQjtwJEPyZ
fmaOLGy1/VeDphcdwYSOu7myFXRhkxx1rtqXCL2AGljtpu3dnZsTSLrJEFak1++3
JOKop7y9T/XGnc7qSf+kGUfUW1w5lQ==
=CI+j
-----END PGP SIGNATURE-----

--LhDgwW9oChW0InIFxANOfpZgyii9l2ZH3--
