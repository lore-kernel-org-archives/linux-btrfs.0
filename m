Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098B7C65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 07:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B71672064D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 07:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B71672064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbeJEOtQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:49:16 -0400
Received: from mout.gmx.net ([212.227.15.19]:33877 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbeJEOtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 10:49:16 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MdKkd-1gPBMM1CCp-00ITBZ; Fri, 05
 Oct 2018 09:51:42 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MdKkd-1gPBMM1CCp-00ITBZ; Fri, 05
 Oct 2018 09:51:42 +0200
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
To:     Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
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
Message-ID: <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
Date:   Fri, 5 Oct 2018 15:51:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fgu0kIQLQvK0eNOD2jDE6dv0xxgHIXSly"
X-Provags-ID: V03:K1:lvoJ+SO7ftGO0bxmSdCsIMdhuxvnNvJU8c0aI69nXgqr0PjYk4l
 aQ8cVAx64N7uJUGjEPEEADWJh83n6ssBhrU9EQI1O43sDqrZBEI7guk0yOiccNizJiD2PDr
 yTX3vJ5Zb1EaoGA3DwCu/b0SHDVL+2vusJpirf/FQU8bgUr3v3truDl4Jaefd0leMdX3FHs
 Crys3dC49TehoOz9hZfPA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:xdfo0NGUsNc=:E29MQ5p0X51HKECnyVf+sS
 vrJdkWGjs2+8JEIPZp8+r3Pbbc6/i+3EUNXpv/4I9E/4p5CFBAcSxWdMwoJ672Dspuy8EvBEl
 MH+v7y9Ou6vke5rux4z38kuiBUzPogvhVKbAYcL1XT8WSVYrOD/Rjat2GoLuAmR2maMdq6Hmw
 Yizrc2CrPcW7LRUBR2N99aMh+KmHTEOV796itjz9FLXyWRL5ax2zAdcS+quscyIVlyON/g6YA
 tQwwFvdTyYeRqxQ2k2BnGDnY5LEACyFWEQtRfQarbptf2FamnJjinXDNo3TyhZT1X5mryMV6j
 Hl2PPfkvl+XeI2GGTvbO2m6KrfCPJX6N2LIAaRp36KpT/PTwrEdsXdIWlrUeQxkZSAc910NFk
 MiXEGJfZEUiiybkpp4x172iT+2yO65RtQP20AbGK/d8WA1Zm1WYkZLJTBTlgHqtI3BY8nC1r5
 lglT1m6/Kr8MhCkYUUtRqv50TKMhJocsn7d/IneUGJF0X08+ZU//WrjBdXuWXWPJTxNIsZbNT
 hMHJnRUHX+DEZ2/ALQIt2Yf7REnmASKmSGJhXRxfJyAV+8i1kGcQAlz5ueGXyf0OxCTrY72rV
 h6xr3lW0xyYLO65l+F4lMYOuRRY6Wwy6DdFPDGQtkMD4+2Tvyt5L/YUH2uJJkqEe5CqaOoKnx
 8Vc3FuDy0jigKClbko6FCLjut4d+QPlZOZD+Ti+xS+46gsr64q4FufGFxegFh2oRgyDctvoMT
 +UZ9Gr7D92p1c4BJJO22rsiRzVYF1tj7X77e05e5M1KG/b/JkLH+5GXmv9DoCxO/5KNCnacxk
 4fHFRH5/fbMwyO6OyRqq7zT3VrHnA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fgu0kIQLQvK0eNOD2jDE6dv0xxgHIXSly
Content-Type: multipart/mixed; boundary="RyOCjQCT4NVeicQKkrro29Ju7uTByxpdY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>

--RyOCjQCT4NVeicQKkrro29Ju7uTByxpdY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/5 =E4=B8=8A=E5=8D=885:24, Hans van Kranenburg wrote:
> This patch set contains an additional fix for a newly exposed bug after=

> the previous attempt to fix a chunk allocator bug for new DUP chunks:
>=20
> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c90=
3@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374

For that bug, did you succeeded in reproducing the bug?

I'm adding dev extent overlap checking in btrfs_verify_dev_extents() and
btrfs-progs.
I think it could help to detect such problem.

Thanks,
Qu

>=20
> The DUP fix is "fix more DUP stripe size handling". I did that one
> before starting to change more things so it can be applied to earlier
> LTS kernels.
>=20
> Besides that patch, which is fixing the bug in a way that is least
> intrusive, I added a bunch of other patches to help getting the chunk
> allocator code in a state that is a bit less error-prone and
> bug-attracting.
>=20
> When running this and trying the reproduction scenario, I can now see
> that the created DUP device extent is 827326464 bytes long, which is
> good.
>=20
> I wrote and tested this on top of linus 4.19-rc5. I still need to creat=
e
> a list of related use cases and test more things to at least walk
> through a bunch of obvious use cases to see if there's nothing explodin=
g
> too quickly with these changes. However, I'm quite confident about it,
> so I'm sharing all of it already.
>=20
> Any feedback and review is appreciated. Be gentle and keep in mind that=

> I'm still very much in a learning stage regarding kernel development.
>=20
> The stable patches handling workflow is not 100% clear to me yet. I
> guess I have to add a Fixes: in the DUP patch which points to the
> previous commit 92e222df7b.
>=20
> Moo!,
> Knorrie
>=20
> Hans van Kranenburg (6):
>   btrfs: alloc_chunk: do not refurbish num_bytes
>   btrfs: alloc_chunk: improve chunk size variable name
>   btrfs: alloc_chunk: fix more DUP stripe size handling
>   btrfs: fix ncopies raid_attr for RAID56
>   btrfs: introduce nparity raid_attr
>   btrfs: alloc_chunk: rework chunk/stripe calculations
>=20
>  fs/btrfs/volumes.c | 84 +++++++++++++++++++++++-----------------------=

>  fs/btrfs/volumes.h |  4 ++-
>  2 files changed, 45 insertions(+), 43 deletions(-)
>=20


--RyOCjQCT4NVeicQKkrro29Ju7uTByxpdY--

--Fgu0kIQLQvK0eNOD2jDE6dv0xxgHIXSly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu3GAoACgkQwj2R86El
/qjp0wgAlq3KZmRNH3ltaQqlhaV+XWHPnCKbOAbRXO+buV948Un33yAaUCn800hT
On8Bq1TDj6PsshnNR2HAt57Dvp70r/sxFX0UCsvGISyxLkS6g46R/djrmT24Fq8M
+abUw6lCua+PeLHzA7+p0oKOYTUfPpEGMVYgflGhFmItVHHs3T5HlWNa9m6l+XNa
//TFUrVRXsXWwsjTzmfUr2kps8pGQBXtgXLiRDqfZFUxPdg8WVYMa+2ecAkDN+rC
YgbmCMmXtWBwcGGKMUurYTEUZ3WVDHXz7LmNQEbhvcnDv2j2L/9puaP61qCiN5zB
Jm5eQAYAsLs24EmtRKRRWZin+cxfyw==
=A0UF
-----END PGP SIGNATURE-----

--Fgu0kIQLQvK0eNOD2jDE6dv0xxgHIXSly--
