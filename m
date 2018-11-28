Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C7DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB6362086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB6362086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbeK1Mdq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:33:46 -0500
Received: from mout.gmx.net ([212.227.15.15]:47271 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbeK1Mdq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:33:46 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MYP57-1fwcqY14ID-00VA3v; Wed, 28
 Nov 2018 02:33:56 +0100
Subject: Re: [PATCH 0/9] Switch defines to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
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
Message-ID: <45dcab9e-fb88-8980-90d9-1875ea1ee992@gmx.com>
Date:   Wed, 28 Nov 2018 09:33:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <cover.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RNbrPZkQIir6nMUfgAIKSatosFiR6DYOR"
X-Provags-ID: V03:K1:gM9EOW8OiapWpb1dsgiz9QFD/fD7mVIpdsiK7ac471ljwDHTwnP
 kFQw5gtWRe6GsOS0OiehRK3O3C8ss0GcOjWqgY862XxLe6AWaVTw5EbY29QWSevs1DcHLAz
 CLxP1rGLdW9jlh+HPI2vgGPvIdysK4sYqEAoDG2PmB6JKVFJbC4dA1gOQlAm0i6hRcADkkk
 ix/+tN2piGMlsnmEBRnkA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:uE3FPSw41xQ=:jnDTnIpG2FRc2dwv/Rwlm+
 Rmzp6X3JE+6pDbSPlJ6GHdW1MtsYv4a69rlXNfOuZzInswNloWKADcEO9Pe123Fw/XTxTji/l
 rv/Lfh/mau7lkP+nanCr6/oUCM1qAELoIXtgka3cmTJYSMyVvg9YPAfwFNQgi6MYp8vgMvWst
 tsBbo5e5tUuI5O67s/Hxs9Mykq/9bzhG8JEGdYa20S8rw3zoBkiRLGiGCAmLgpeDU4Dxq/sxx
 i1lXh0uM117dM+lf9i8gecXG0izd7vWHq+vpZIQIQHPgEPcM0KxHdiA/q18yPKMCdKCH4j/sM
 M9+66kQsIPu+PQ9CNHr3xXF4JQDOsQZTr3QooJ6hbN/4e+2iDyK5o2ojx+LNujMrIHXipPzCi
 dgr8avNEQ2EN8CzjyMVHEQL8bkpGqQkYF7ZMpFMC90yAVC0AlFaQxPR70xKE5rU3+FDODCz/B
 vKOOi0xCcY059sPd5aTGZ0sAS2Rd57h4FWFwH5L5y9n2cbDCXOKWZans2FMNzpNBQgjDZs+N7
 vABMN/h4g3VfpjpSPnuv+5XhErcAnPOzNlU3SLaUsNKSvYZb6RNeID/mTNaS4Cl/dFpcEuBbn
 5TGSaGOBltnTRmN2W1XjoHL/jH2klpzR8FKs/W3ym0UnNnbdUMW3SHwF9ayKPTsCZYdroMley
 k1mafCAK2Al5Mu2tkwX7PJJmueMvXcubNtZnH1Xcv19B0rZmDwPkFwcR362t67w21znp6dcPw
 6vDSMclbInuVsJPEvlyxrwLjiLF6Tr6CjklVd5np0dXIDDTVZzSb+2rX3CYTrCXdnOBRGih+1
 uYnLE2K8VIqItXtIKIaIdHxEtJujN9GPVC2F4uNqCnFlJLJgAcg0dJNM8MkYoCpYAd3lgiTeM
 D6vKtnZArrDqpbHiPCvBDbGhOOljLM51N2hWeDKBQ=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RNbrPZkQIir6nMUfgAIKSatosFiR6DYOR
Content-Type: multipart/mixed; boundary="73i2IkkDiRPKvmaJx5QygT3FPalafrD0n";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <45dcab9e-fb88-8980-90d9-1875ea1ee992@gmx.com>
Subject: Re: [PATCH 0/9] Switch defines to enums
References: <cover.1543348078.git.dsterba@suse.com>
In-Reply-To: <cover.1543348078.git.dsterba@suse.com>

--73i2IkkDiRPKvmaJx5QygT3FPalafrD0n
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> This is motivated by a merging mistake that happened a few releases ago=
=2E
> Two patches updated BTRFS_FS_* flags independently to the same value,
> git did not see any direct merge conflict. The two values got mixed at
> runtime and caused crash.
>=20
> Update all #define sequential values, the above merging problem would
> not happen as there would be a conflict and the enum value
> auto-increment would prevent duplicated values anyway.

Just one small question for the bitmap usage.

For enum we won't directly know the last number is, my concern is if
we're using u16 as bitmap and there is some enum over 15, will we get a
warning at compile time or some bug would just sneak into kernel?

Thanks,
Qu

>=20
> David Sterba (9):
>   btrfs: switch BTRFS_FS_STATE_* to enums
>   btrfs: switch BTRFS_BLOCK_RSV_* to enums
>   btrfs: switch BTRFS_FS_* to enums
>   btrfs: switch BTRFS_ROOT_* to enums
>   btrfs: swtich EXTENT_BUFFER_* to enums
>   btrfs: switch EXTENT_FLAG_* to enums
>   btrfs: switch BTRFS_*_LOCK to enums
>   btrfs: switch BTRFS_ORDERED_* to enums
>   btrfs: drop extra enum initialization where using defaults
>=20
>  fs/btrfs/btrfs_inode.h  |   2 +-
>  fs/btrfs/ctree.h        | 168 ++++++++++++++++++++++------------------=

>  fs/btrfs/disk-io.h      |  10 +--
>  fs/btrfs/extent_io.h    |  28 ++++---
>  fs/btrfs/extent_map.h   |  21 +++--
>  fs/btrfs/locking.h      |  10 ++-
>  fs/btrfs/ordered-data.h |  45 ++++++-----
>  fs/btrfs/qgroup.h       |   2 +-
>  fs/btrfs/sysfs.h        |   2 +-
>  fs/btrfs/transaction.h  |  14 ++--
>  10 files changed, 169 insertions(+), 133 deletions(-)
>=20


--73i2IkkDiRPKvmaJx5QygT3FPalafrD0n--

--RNbrPZkQIir6nMUfgAIKSatosFiR6DYOR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv98H4ACgkQwj2R86El
/qisoAf8CDgmwdmjljcIa3/L5XiOO62UsOMcIgEa9hvoXT70CC7kz2KOKi+I1pJn
XUhbCfzv5DCfQhK7cHzcgJuzo8Ne4YINSaUFB289GTWrxyoLcVziKp0D4u188tFA
CMOgDF9D5efj6EHY+RqtNgNbO11xHlrVhcJiKDjjSodYsQQ6rdNQh1TkGDCtHwMg
XRIPMmPejy0aAuFNCltwnvT0Bp9qS1+1pVlPTjNWrWoyo9iZy7PjMsvMxEAgmcRt
LwQFIAaoMZpw1WPYT7PGveEBc869wfjh9YwX7kH2wGXKILTrjYEh5Ipq0VntV3nJ
JEwpeAUdWnYE6wGTSMaFRTbTTtNkuQ==
=ye0N
-----END PGP SIGNATURE-----

--RNbrPZkQIir6nMUfgAIKSatosFiR6DYOR--
