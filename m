Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7815CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD9E20839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:52:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BD9E20839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbeLLNwY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:52:24 -0500
Received: from mout.gmx.net ([212.227.17.21]:37645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbeLLNwX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 08:52:23 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MMXVC-1gWWR00JO2-008Mgd; Wed, 12
 Dec 2018 14:52:21 +0100
Subject: Re: name hash mismatch
To:     =?UTF-8?B?0J7Qu9C10LMg0JLQu9Cw0YHQvtCy?= <allsys01@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAKKX_zOEE=N5FrTyfg6JzJ7FfrBix0dnoKK2tYvmTD2kwvEXrg@mail.gmail.com>
 <7793059d-fca6-9465-6276-de7b764c7f89@suse.com>
 <c7b5775c-9f3d-8793-1c05-66abc486d05e@gmx.com>
 <CAKKX_zMt8=zJjdK6p0bD_bVCiYsiuCbv-yRvPy9yCbrrZbwnSA@mail.gmail.com>
 <a1ca88f9-499e-0dfa-a49f-759ab37c391b@gmx.com>
 <CAKKX_zPGBpzhq=j9wT3QXed3LWbfOn5yxctrJHRK8vhYh2MKgw@mail.gmail.com>
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
Message-ID: <15b41149-3ebc-8432-7f4b-cfe0a7520fec@gmx.com>
Date:   Wed, 12 Dec 2018 21:52:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAKKX_zPGBpzhq=j9wT3QXed3LWbfOn5yxctrJHRK8vhYh2MKgw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1QOApopnIC5ZYQaxuoVy0ZRPa6MnaU6yU"
X-Provags-ID: V03:K1:oz968WH2k3XePeWnp35Lu3oB0Z2ENCvqBEvyqUwQfN1YjqevZ2x
 dXxj9abbLleV7A20fstOGgTTxKp3gG97gbZQbOr4yEhK6PZaq7V9xTgXIhp5MwVzSVgitgU
 Kng/9Nn9B1J/F7oa6Gpvad9soxGWFuSVOL5lm/zcZvar56/DQ4/mEfHCVF7J1nm3So2SqnT
 e4h54lZhGN/BGfTDARuCA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ilywc1mODhg=:kEnQAo5jgqCjhcdcChIY1h
 wIY5jc7D6rrCyO+XvPxWzsAWX3DKNDykL91Ze6NtQov3wamaexzOno4OjbyNxuG+Ft1+q7KUS
 VpRpZpVeoEX/MaeE7W1oXyrNDjfZIzHZPTKbW/bPmjCqkIuSczdvsREwqWr8OAe1yypoaomi5
 UaqhJiVXTb0DlmZ8bM1Ug8s6TjZCxdHk7ixabTZmgwD+QSpotj4nmVJPG083BkbAxcKBdamH8
 N9kvf/8d4cOMZCuPc5xSnAZFNlgZ2BZHExcARQ94KqoR49NZoV1DobKi2ngwtOfIeJIR5sHa0
 mFxzJrFa3sc3wr3jRQ1AhO9AyIrm1ILx+7M0a5hXkQIjU/+dGQiOceoGseq3xK4Y6vE1LbdeD
 Cl0dE7qVoF8cEO0zXwSTTuIKqE+Y5A0qEq8y3WwrDew/1R6hqN2pa6ngGQ7rbKvuTJ8Y99Frh
 HMfZn4in/c1TYh6yy+d1jExGDSYblf4U/FZZ9Ub036/B0dwlF3MSqTSOfFIs5aoDpNKAyuxRg
 hMbgewqFtsPoL1OBzGx4bgMum0pzaheD7myQqsPMBThpXR4dfp4B1XJjdJKB7CgGRFojU7M22
 MD28iGrN2OFADqEHqbAIQO7ArBdPJprYHz0GZ/fpMZOnOsn1CtDasVYSnUFoOuYlU6rHc/PEc
 h4SLC+2cJP66fJOBn/cpFVwxlWA5ohEssSgWtb5p0m3LcwKq1YoOMGr0S2ox/Bcg+PEGQ6FT+
 U/2B7ZOTWbzDJVLs2VOdJIBzrKYugisEay6TKO9BVap9iPciJBhlj+DqS7Z31/iWG8Brqbq6q
 Zlo/3qSMePu96cRjfKd/7e2rGRbk2pIOv3RWB2euhCZG+HfJIo/GIIjlJup2ILVQ/pDdq5wOM
 76RcOT66N/rpT6Q1CKpDy69uPZ8m9pg6e6+FIdp8EIBIfAP7mQPzqKH0QZn9lA
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1QOApopnIC5ZYQaxuoVy0ZRPa6MnaU6yU
Content-Type: multipart/mixed; boundary="i1xSClzPpUMU8QnU7fNbw9NZphLQgrBnA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?0J7Qu9C10LMg0JLQu9Cw0YHQvtCy?= <allsys01@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <15b41149-3ebc-8432-7f4b-cfe0a7520fec@gmx.com>
Subject: Re: name hash mismatch
References: <CAKKX_zOEE=N5FrTyfg6JzJ7FfrBix0dnoKK2tYvmTD2kwvEXrg@mail.gmail.com>
 <7793059d-fca6-9465-6276-de7b764c7f89@suse.com>
 <c7b5775c-9f3d-8793-1c05-66abc486d05e@gmx.com>
 <CAKKX_zMt8=zJjdK6p0bD_bVCiYsiuCbv-yRvPy9yCbrrZbwnSA@mail.gmail.com>
 <a1ca88f9-499e-0dfa-a49f-759ab37c391b@gmx.com>
 <CAKKX_zPGBpzhq=j9wT3QXed3LWbfOn5yxctrJHRK8vhYh2MKgw@mail.gmail.com>
In-Reply-To: <CAKKX_zPGBpzhq=j9wT3QXed3LWbfOn5yxctrJHRK8vhYh2MKgw@mail.gmail.com>

--i1xSClzPpUMU8QnU7fNbw9NZphLQgrBnA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/12 =E4=B8=8B=E5=8D=889:51, =D0=9E=D0=BB=D0=B5=D0=B3 =D0=92=D0=BB=
=D0=B0=D1=81=D0=BE=D0=B2 wrote:
> Could you guide me ?
> What should I do after compile latest btrfs-progs?

"btrfs check --readonly <device>" and paste the output.

Thanks,
Qu

>=20
> =D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3., 16:47 Qu Wenruo quwe=
nruo.btrfs@gmx.com
> <mailto:quwenruo.btrfs@gmx.com>:
>=20
>=20
>=20
>     On 2018/12/12 =E4=B8=8B=E5=8D=889:36, =D0=9E=D0=BB=D0=B5=D0=B3 =D0=92=
=D0=BB=D0=B0=D1=81=D0=BE=D0=B2 wrote:
>     > if there any way to remove that item?
>=20
>     IIRC kernel can't remove it since the hash doesn't match, kernel wo=
n't
>     be able to delete it.
>=20
>     btrfs-progs check-next branch can handle it, but you need to ensure=

>     there is no other bugs.
>=20
>     So, you still need to compile the latest btrfs-progs and then the
>     check-next branch.
>=20
>     Thanks,
>     Qu
>=20
>     > the file that belong to it is useless for me but it preventing to=

>     > mount filsystem in higher kernel versions
>     > =D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3. =D0=B2 16:26, Q=
u Wenruo <quwenruo.btrfs@gmx.com
>     <mailto:quwenruo.btrfs@gmx.com>>:
>     >>
>     >>
>     >>
>     >> On 2018/12/12 =E4=B8=8B=E5=8D=889:00, Nikolay Borisov wrote:
>     >>>
>     >>>
>     >>> On 12.12.18 =D0=B3. 14:44 =D1=87., =D0=9E=D0=BB=D0=B5=D0=B3 =D0=
=92=D0=BB=D0=B0=D1=81=D0=BE=D0=B2 wrote:
>     >>>> Hello
>     >>>> If anyone could help with with "name hash mismatch" error at b=
trfs.
>     >>>> full error is
>     >>>> "BTRFS critical (device sda5): corrupt leaf: root=3D2234
>     >>>> block=3D244700761008 slot 136 ino=3D2531, name hash mismatch w=
ith key,
>     >>>> have 0x000000000026cd84d"
>     >>>> so i could not access one file neither to remove it.
>     >>>>
>     >>>> uname -a
>     >>>> Linux linux-wwqj 4.12.14-lp150.12.16-default #1 SMP Tue Aug 14=

>     >>>> 17:51:27 UTC 2018 (28574e6) x86_64 x86_64 x86_64 GNU/Linux
>     >>>> btrfs --version
>     >>>> btrfs-progs v4.15
>     >>>
>     >>> First I'd suggest to update to the latest btrfs progs. Then jus=
t run
>     >>> btrfs check --readonly --mode lowmem /path/to/device=C2=A0 and =
paste the
>     >>> output. This won't do any changes to your filesystem but will g=
ive a
>     >>> better idea of what the corruption might be.
>     >>
>     >> Yep, that's pretty much recommended.
>     >>
>     >> On the other hand this kernel warning message just means exactly=

>     what it
>     >> says.
>     >> One of your DIR_ITEM has incorrect hash.
>     >>
>     >> IIRC this is an old bug in kernel, not sure when it get fixed bu=
t it
>     >> should definitely get fixed now.
>     >>
>     >> If btrfs check --readonly shows *NO OTHER* bug, I have the check=
-next
>     >> branch which could fix it.
>     >>
>     >> But please keep in mind, don't run btrfs check --repair right no=
w.
>     >>
>     >> Thanks,
>     >> Qu
>     >>
>     >>>
>     >>>>
>     >>>> tnx in advance
>     >>>>
>=20


--i1xSClzPpUMU8QnU7fNbw9NZphLQgrBnA--

--1QOApopnIC5ZYQaxuoVy0ZRPa6MnaU6yU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwREo8ACgkQwj2R86El
/qh0lgf9Ho/hYIoPSHQkwg1h7/PIAEN1Ra/f4CxGGTyiSpX2Xmnv+D+OO22WT5tR
23PB2g4CvJeNewjliuxmej9bMJofq2yUNnzD3Ik4r1TSZC3dX0yBKG773pdbwDER
U4fFPy12KGGAWB4Ih1xAwaqwGwhx8925puhWwBCPoLIFA0i1nMrfXivo1I2WCKGV
kkkCWixGfWV6h+2AeL4SH8NLx9BC1U2bVYATCZtR1gVJC8Mplqq7wUgcqTtnsVVA
1GSgVXMeP/StSgF/PpvGdpi/q3yN3PfPBwijSSNwtELQpfN5SGJX93qfMzFIhoHO
7JLmkOTU6taW/5zJ1e0rQgePizEdFw==
=72O/
-----END PGP SIGNATURE-----

--1QOApopnIC5ZYQaxuoVy0ZRPa6MnaU6yU--
