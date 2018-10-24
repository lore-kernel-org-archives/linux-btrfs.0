Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB4CC004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 05:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBA3F20652
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 05:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBA3F20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbeJXNeB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 09:34:01 -0400
Received: from mout.gmx.net ([212.227.15.15]:56287 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbeJXNeB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 09:34:01 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0McVKy-1fxW0v0yoq-00HcZh; Wed, 24
 Oct 2018 07:07:30 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0McVKy-1fxW0v0yoq-00HcZh; Wed, 24
 Oct 2018 07:07:30 +0200
Subject: Re: Have 15GB missing in btrfs filesystem.
To:     Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
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
Message-ID: <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
Date:   Wed, 24 Oct 2018 13:07:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7EvE2b0PCfr9NoblxI409dn2pxBLtHrwF"
X-Provags-ID: V03:K1:GlYF8NqnlBAJx7uZHWvX6ZhrXx/NmlJBJ4W3WzzXzhhChb7oYPe
 v8fogx1+KRWfLXGr+5bNvbB2aWwVgea3Em4FRlPPgpRob51gqh+HSD/uNUllf+M6ljYg/Sv
 1zEVlVzKZWkpI34F4NgpLslfKOJJe2kAqSrFjXkFVA1iHFHtWC32datG+2c0PmboZap2gW8
 sMOe4ar/RD/tjFDUOggig==
X-UI-Out-Filterresults: notjunk:1;V01:K0:rxpj20ux0ps=:8NQZ5xYlcLI5ojxkn7NfUS
 PVfTfkvRbuNFG8XGMjdal+mifg8fUiVG2A+9T8dzlMhnh2bRTuplQ50xIv6biASj/d7EszYTq
 qdQ92AfhScbYwMc4G1quZ2WGOBZSRUvnooC/WVxq/AZzNfCp8l7EpK6rr7SSEOhepi/grR16s
 3zVL56T5YQ/fA/yvU9qp28wwxtWSVgWHfiVFjwdh+XqfuyTEK1ucwPZnDARLFKtJhvREADeOG
 I5VLehBFAVU8/6udNzJ1QsfjCx0eE/Yc5HauRmpdEFfeTXgb2Itsn+lDcHTa6SyoB9+BEBVso
 gXYSpnYZaKo9w1OqYHjt3oIWjQVXiotlC0tNW+rJreU63bWhhE/LiAQuOIVxtAOeqSjwItPQu
 dpcp2Tp1LXcKRwRix7TuuD8bctqpGBq+p9VDh5zLzHzn7Wbvm8btweRaia7EsoQ0HnFNsk80f
 2QynHXgyt7wo7Dc3wt1uFS30mM7RDBAFl465RJEPer9cxO2m3kVOc2nLpsKgbve7lkWrcqVMz
 e7BOD400gRIhU+FcRaqkbXBdDWJ24Ot9iEuZog/NpNQv5emCX84s2QQVOAM0XzcnKQE8q6fmT
 wuvyRAz1Q+/6AoMbHgzdfKDhPyqvzTi/2DjhFUMFZcQ+xh0WH3l6xvwLT6UV3NjGlVTJtGftJ
 qnAwKFP6VAhVHAy0HDYz81jEqja1mJp5sguadu6/70Q7lgBBXitTKkSw8fAi8nEWFKpZVSGdW
 07ka808DzJsTCSNezPDkGfnBpj/hFNIw/B4iNcQADPgaGiVZwPZmY6SYO6JFUXF5ScRypRYIK
 SL0CV66kt/WTlPf/XAjIY5pIXirSg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7EvE2b0PCfr9NoblxI409dn2pxBLtHrwF
Content-Type: multipart/mixed; boundary="JL7dwhHURiKB2e56cnDFRvNVXW5gxz3ZV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Message-ID: <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
Subject: Re: Have 15GB missing in btrfs filesystem.
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
In-Reply-To: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>

--JL7dwhHURiKB2e56cnDFRvNVXW5gxz3ZV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/24 =E4=B8=8A=E5=8D=888:36, Marc MERLIN wrote:
> Normally when btrfs fi show will show lost space because=20
> your trees aren't balanced.

Not always the case.

Btrfs uses two level allocation:
1) Chunk
   2 types, data, metadata, and system.

   And that's "used" space of "btrfs fi show", or "Device allocated" of
   "btrfs fi usage"

2) Extent
   2 types, data and metadata.

   And that's "used" space of "btrfs fi df"

A metadata extent can only get allocated from a metadata chunk
(or a system chunk, but system chunks are pretty small).
A data extent can only get allocated from data chunk.

Balance can only solve the case where an near empty metadata chunk can't
be freed since it's still used by some metadata extents, or similar case
for data chunks.

It can't really magically reclaim free space from void.


=46rom your description, I don't think it's the case.

> Balance usually reclaims that space, or most of it.
> In this case, not so much.
>=20
> kernel 4.17.6:
>=20
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 186.89GiB
> 	devid    1 size 228.67GiB used 207.60GiB path /dev/mapper/pool1
>=20
> Ok, I have 21GB between used by FS and used in block layer.
>=20
> saruman:/mnt/btrfs_pool1# btrfs balance start -dusage=3D40 -v .
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=3D40
> Done, had to relocate 1 out of 210 chunks
> saruman:/mnt/btrfs_pool1# btrfs balance start -musage=3D60 -v .
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=3D60
>   SYSTEM (flags 0x2): balancing, usage=3D60
> Done, had to relocate 4 out of 209 chunks
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 186.91GiB
> 	devid    1 size 228.67GiB used 205.60GiB path /dev/mapper/pool1
>=20
> That didn't help much, delta is now 19GB
>=20
> saruman:/mnt/btrfs_pool1# btrfs balance start -dusage=3D80 -v .
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=3D80
> Done, had to relocate 8 out of 207 chunks
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 187.03GiB
> 	devid    1 size 228.67GiB used 201.54GiB path /dev/mapper/pool1
>=20
> Ok, now delta is 14GB
>=20
> saruman:/mnt/btrfs_pool1# btrfs balance start -musage=3D80 -v .
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=3D80
>   SYSTEM (flags 0x2): balancing, usage=3D80
> Done, had to relocate 5 out of 202 chunks
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 188.24GiB
> 	devid    1 size 228.67GiB used 203.54GiB path /dev/mapper/pool1
>=20
> and it's back to 15GB :-/
>=20
> How can I get 188.24 and 203.54 to converge further? Where is all that
> space gone?

Your original chunks are already pretty compact.
Thus really no need to do extra balance.

You may get some extra space by doing full system balance (no usage=3D
filter), but that's really not worthy in my opinion.

Maybe you could try defrag to free some space wasted by CoW instead?
(If you're not using many snapshots)

Thanks,
Qu

>=20
> Thanks,
> Marc
>=20


--JL7dwhHURiKB2e56cnDFRvNVXW5gxz3ZV--

--7EvE2b0PCfr9NoblxI409dn2pxBLtHrwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvP/g0ACgkQwj2R86El
/qh7tggAje1zeoK/XBCqX9QuUZjZ7UnY8KF7SmdwKP4h0N7JS3KIfeBvpoLAvlwG
GMR6lYB+E6hMdps1t4s8lMCxsa/TFZnVGUy7y9uzuqDffFzQsPFiZmR388vA1SDL
v8UM1is0J6rR71Vfg5Yj4jSx2gVT9h4eIk9/zCjSvV9gnKg9420tpB5rIju/Kq/j
dGbIddjc5dUDkIBMhxIXkz8Q126K5dU/0QqKI2b4mkNI8J0TkPiDyNqEvZEsM528
Nesf+FvpSDJGm6A1dHvEd5v5TfZ3/GFewmQpOhLyjuvPcpQgadOTjM08XW8KVydp
mNIequxB7AF4N4s3JVAu+7TWDDYnLg==
=lawr
-----END PGP SIGNATURE-----

--7EvE2b0PCfr9NoblxI409dn2pxBLtHrwF--
