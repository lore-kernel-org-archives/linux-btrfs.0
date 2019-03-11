Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD98C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 01:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E83A20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 01:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfCKBSG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 21:18:06 -0400
Received: from mout.gmx.net ([212.227.17.20]:60795 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfCKBSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 21:18:06 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M7CRe-1gpJQS0CRS-00x5vl; Mon, 11
 Mar 2019 02:18:02 +0100
Subject: Re: confusing behavior when supers mismatch
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
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
Message-ID: <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com>
Date:   Mon, 11 Mar 2019 09:17:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1oOmBBp2E1JFItGhffjt0CAWVG7vxvuvL"
X-Provags-ID: V03:K1:EMvdaBisKtjvJEDVXuAotXwBROEpp83MCb45PduJjVPgG7L5gaF
 yerWISl2pxU8BiTzX3j8iOLfueRO3FYJurm9UJ2XAuWjNoF4l5hz0JFIgWMnJBFaMCXird8
 5WiYy1UBt/goKGGMItHevIqKBDd/pumz9W1Fw/kIMxxkUcO67g4BhaLC+WaK8GZ7SQZbzJo
 hg+1KbqaHUSUvEn4kVwtg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yWgxExOy6sU=:rWaZ0a7LLKqVQcEowdElF/
 /72k0sBF9nO1IueN0qNYPfEX7bq2LXssfDsnyWwkgzQcSYzSQ06XOWXnk8Ino59dhm/XBj49s
 Pcas9ElgH9JWjr/pz8l3Bfm3Kml0/IiLrINitNWZo+dyr67B44TQh0lT/0pzo9EtNlvZyYqxa
 5q6ImsyqYTwZhZuKYFgy8fwXwx1QsJdYbm6vo+twGN4vGUTnNIo8Hu9vPbV1W21AzNw9SwlqP
 l2rcfi5/+XGw2v2obWhJa+rOpWaiL6VADuCH4N1z4RtK2l/kNDMJaVZZ9aXLnEPuh2jmGrBVr
 xcU7AGqmvE9M1v+DfqGujAvloV26J3RNQSoxmB9gnF1UOpFTG+JP0jStOcoIFNt6xm8j0+uMk
 4VU0W9mltXqfK2vqwY4B6HUuK9WFchnCtrmblF6cgHJvv3WiE2rmVcMZWszBUVwETdRUj25fd
 YoICgbWipB6xE4Is0dnp+TeFCuRSp+pvvCIDfUL0lnzcRwJo/9kPf3w9oGpj9jDaYOQqJaPQu
 WX/4A5tICJfuVYd4j9TAXft4erDEvGaeprGK+4Rklqz3I7aBCo/C3QItmLfaWm3bxv4NFopfX
 D2MTsnMf/zgBlisLT3VIvXBjouLeU8LOJe05EAz7aVoMZfGLJfeG2/kwExqasy7XnCgLyl6ri
 htywYQCitILf9SqptR067tIfofkFuuhlxde9r4bs1NWsZa1w/7gKEHRIPriYFjC/hWGfYukoF
 Br4qqWduzEAsqjE6rVMjR2QSHP/+5myfx0LRg+ES0aoxXwtxszBfCbLoBHTdQBxZ5vwTzOgav
 BVw7AGoJckPTOyf66tf9mKGc1jzq5skgqVRuYBAaXgqkkJYX/E1xabls0lyspnWxmiVr2JOtn
 INMLspLUu+JU0f5myAR+ZIsE6euMYPAx6rEcg+STIZ3E5XQ89K4OQoprXIzV1S
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1oOmBBp2E1JFItGhffjt0CAWVG7vxvuvL
Content-Type: multipart/mixed; boundary="gvEYZv2bNrvSc15D2vIlJ6wuLW9akrQ10";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com>
Subject: Re: confusing behavior when supers mismatch
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
In-Reply-To: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>

--gvEYZv2bNrvSc15D2vIlJ6wuLW9akrQ10
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/11 =E4=B8=8A=E5=8D=887:09, Chris Murphy wrote:
> In the case where superblock 0 at 65536 is valid but stale (older than
> the others):

Then this means either the fs is fuzzed, or the FUA implementation of
the disk is completely screwed up.

Btrfs kernel submit super blocks as the following sequence:
1) wait all metadata write
2) flush
3) FUA the primary superblock
4) write the backup superblocks

If backup is newer than primary, then the FUA write doesn't reach disk
before normal write.
This means any fs could be corrupted on that disk, not only btrfs.

>=20
> 1. btrfs check doesn't complain, the stale super is used for the check
> 2. when mounting, super 0 is used, no complaints at mount time, fairly
> quickly the newer supers are overwritten

The reason why kernel doesn't search backup roots is to avoid stale btrfs=
=2E
For case like mkfs.btrfs -> do btrfs write -> mkfs.xfs -> try mount as
btrfs again, this would cause problems.

So IMHO always use the primary superblock is the designed behavior.

Thanks,
Qu

>=20
> Is this expected? In particular, in lieu of `btrfs rescue super`
> behavior which considers super 0 a bad super, and offers to fix it
> from the newer ones, and when I answer y, it replaces super 0 with
> newer information from the other supers.
>=20
> I think the `btrfs rescue` behavior is correct. I would expect that
> all the supers are read at mount time, and if there's discrepancy that
> either there's code to suspiciously sanity check the latest roots in
> the newest super, or it flat out fails to mount. Mounting based on
> stale super data seems risky doesn't it?
>=20


--gvEYZv2bNrvSc15D2vIlJ6wuLW9akrQ10--

--1oOmBBp2E1JFItGhffjt0CAWVG7vxvuvL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyFt0cACgkQwj2R86El
/qhwugf/XRZ+5sHjyVRifkv8j/7ECdITGyNeRg1hyoEWqkNhF3T+XHpCw5cN9Gsu
5BGfYpEnrHo042UUdsFjnce0aSbNnd3curLQ8HpClX+bTozjpWv0IqSqzE3K2Qgt
/9YZSUhbDR76H4dIaUUsxArxuamKJbfeW4NFhOuZIXHTZdLZhE84+R+IOAXnJ0Ta
zuPjLmG1M0EEeT6wvQjWxBqiyj+vgiVHi/HeCc6so2FOrBPdWbDutSE96V+2aDHi
Z2FCoXoVxkRI4IneyGOKeu3SKN73duf72/xkhl5ss135eFR5epVPCtMK8K4ZqkVw
sPTU055srg4rRRiEoR8tJIpfM3DtEQ==
=FEul
-----END PGP SIGNATURE-----

--1oOmBBp2E1JFItGhffjt0CAWVG7vxvuvL--
