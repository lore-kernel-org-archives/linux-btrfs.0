Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46858C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 06:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECB1B2086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 06:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECB1B2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbeKSQvG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 11:51:06 -0500
Received: from mout.gmx.net ([212.227.17.22]:35663 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbeKSQvG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 11:51:06 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHrk1-1gSCTt2Z2L-003gb3; Mon, 19
 Nov 2018 07:28:17 +0100
Subject: Re: Broken filesystem, looking for guidance
To:     =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
        linux-btrfs@vger.kernel.org
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
 <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
 <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
 <67736550-3c2c-0ba6-81d4-d0cdc9a1d1eb@gmx.com>
 <43ddede36c4d58bd12a9a4f549a9bf05cb9c0c1c.camel@seblu.net>
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
Message-ID: <22f635aa-ee0d-7f93-87fd-5d788124ebd6@gmx.com>
Date:   Mon, 19 Nov 2018 14:28:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <43ddede36c4d58bd12a9a4f549a9bf05cb9c0c1c.camel@seblu.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T5DriZ0yI9MkrF2r6OcXVpuJSOai9cfsq"
X-Provags-ID: V03:K1:z/1Mg9Y9ZpDyJVrFR3S7iA1p7dny9YSGcZbL+3/pYu96d6TRoit
 WZfwMG/+yM8eSrBXWIA1byReokr3ruQ5scwht4kXfEmPZKBHg9MVRAb8R2xFR4peOXwuoZX
 pLa9QvWxFVfVh3CuPqoVUY5M3mm6vXp+Vg0mzbhfnh4j77XFi0y2WdYLrM7Sg1qc61yy2qg
 6f1sGy9Xp9wYSCpvSDLaA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:78/8K78Eak0=:t2lzOK3LDdzPds05VdFBWd
 h7sTx1L4uZoY0T+Duq1p+MULr0zPZG8z/QUcHqle5R/bLMakE+C4YXKmfJnoi0RWkKSAmQD0Y
 BlBXQ7L585v4ctRi9c+SHUtTpp/ylCy5cYFRwvvDPc6q5Lbsu+leXdmRlXuNMtPvnbj35VFIv
 yMo9sAw9LUZLrm5uBZRMwjIQZrd0LlfO5pvwNVzrwjM8bnsvYXRtR6YM5tfzbIMNr/iZFZ3hl
 gBbkKz5rzbOgmCwcYwKR7e+VG83vUnKqLzHURv222PGW9UBykqz6ie/RKVXq+d4XzMavsyZ1Q
 cpC3+Qbh8AVh10LO1i02SkYSBX9xe+e1wOUq73afKMvZ/nVU0pYx+zKQcW8s3TumCIxydbutU
 AiJLXK/HCdoeivey037FrwT+qzjwHXQOzGQU9UiWDckgwPlVO/+3ILwfpA4K1kiqFXs/iY+pV
 pZ2r7SPmfD7Vco7ZZp5DiTO7CXfgvnfkk6vITk2pB+mJn9A9kpOLauWS/3tdxRJNk/aVuN2qm
 l8mxCDcUowCL4fFkiMsZ79qecGWz2ha+r1ieLirO35PPhaGuoOo09lu/sP/ve0dI/xp6pOUEX
 cUPh5W82uL8tEzCdx53Z4o7KLvljK9kVxQJRychBBrW3AA/njjHRDv60ieO9Q/q4kJ4Uj1D2s
 8sUvsV3fqWqEkOtRZ9v7dHAGFPD22ZWPIZA873KaM0t6+fOVIAW8E4rQ6SvlucNto2SxgeEwa
 U96isq+5TI9eqQLahQ38ylLgmc9TtHw82tmfwfwBHl/Ka7O496BblgEYkA03DT3wmiSTYOTng
 cFq9e2OsrjPPOde2BbAljSC3IUtksXbVwNJNdbDCbZFe2bDCcNtj3nVzFaG3wvU3hQTC4Rnbu
 rLUNY6cBo3AevYTgGydtM5izvW7KAhID6MQJjZABace+RzyTWbwwObYjSYH0f+
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T5DriZ0yI9MkrF2r6OcXVpuJSOai9cfsq
Content-Type: multipart/mixed; boundary="zKqBFbCZTfdeGbaSlmcmGxLJ0PIOUUVsp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
 linux-btrfs@vger.kernel.org
Message-ID: <22f635aa-ee0d-7f93-87fd-5d788124ebd6@gmx.com>
Subject: Re: Broken filesystem, looking for guidance
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
 <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
 <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
 <67736550-3c2c-0ba6-81d4-d0cdc9a1d1eb@gmx.com>
 <43ddede36c4d58bd12a9a4f549a9bf05cb9c0c1c.camel@seblu.net>
In-Reply-To: <43ddede36c4d58bd12a9a4f549a9bf05cb9c0c1c.camel@seblu.net>

--zKqBFbCZTfdeGbaSlmcmGxLJ0PIOUUVsp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8B=E5=8D=881:23, S=C3=A9bastien Luttringer wrote:
> On Mon, 2018-11-19 at 13:00 +0800, Qu Wenruo wrote:
>> May I ask for the oldest kernel ran on the fs?
> Looks like the first kernel on the host is 3.12.2.

OK, then it makes sense for such strange dir ref corruption.

>=20
>> To make it clear again, any --init-* should only be used when you're
>> completely sure what is going to happen (at code level).
> Copy.
>=20
>>
>> From btrfs-check-20181119, all the extra damage are possibly caused by=

>> either --repair or this --init-csum-tree.
> Copy that.
>=20
>>
>> From 20181029, it may be possible with extra help from btrfs-progs
>> developers. But at current point, it's near impossible to recover it t=
o
>> a fully functional state.
> I understand the only solution is to rsync data to another server, form=
at and
> rsync back ?

That's the basic idea.

Thanks,
Qu

>=20
> Regards,
>=20
> S=C3=A9bastien "Seblu" Luttringer
>=20


--zKqBFbCZTfdeGbaSlmcmGxLJ0PIOUUVsp--

--T5DriZ0yI9MkrF2r6OcXVpuJSOai9cfsq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvyV/0ACgkQwj2R86El
/qjqwwgAnhJJgRcai5+fegPDrJ+ncCzVl70zjh4k8Z21I3ZKlzGRgQtIjZej68MJ
XoFV4tZDub9xcNBFaeV8yFe6v0aoJKj3IcTeqwSY+vEo774x9VX9LZY5sU/fwRyD
cTwwm5VyAQWfMh6/6ZuTMIh9avaTDu0lSR13v+h2wlo60Mgfb54kKmMBLTp3ZnB4
B+FFZyzHKF4B9/H4C1VBMlgKAyeQg1EAUYpVRiwCi6Yc6z2ky7kxTgX64+Hs+3dE
MAUiBEq7/jODNjX0505ulViHbOmwTtiOZsgvnS00wQTjn4M3e2k3BEOmO5fCaOUK
JcK04ClCQMr3Xqisw5fzAmek+DXbNQ==
=UE7O
-----END PGP SIGNATURE-----

--T5DriZ0yI9MkrF2r6OcXVpuJSOai9cfsq--
