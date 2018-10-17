Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C9CC5ACC6
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 01:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A461F214C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 01:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A461F214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbeJQI7x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 04:59:53 -0400
Received: from mout.gmx.net ([212.227.15.19]:33513 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbeJQI7x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 04:59:53 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M3zne-1fLASk2x7q-00rVpz; Wed, 17
 Oct 2018 03:06:45 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M3zne-1fLASk2x7q-00rVpz; Wed, 17
 Oct 2018 03:06:45 +0200
Subject: Re: brtfs warning at ctree.h:1564 btrfs_update_device+0x220/0x230
To:     Dmitry Katsubo <dma_k@mail.ru>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <e5970ef2-3d22-6c49-0634-8e6d9d92191d@mail.ru>
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
Message-ID: <c9af2ee8-4148-957a-7e2e-a10f40a1dc00@gmx.com>
Date:   Wed, 17 Oct 2018 09:06:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <e5970ef2-3d22-6c49-0634-8e6d9d92191d@mail.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hqf5k8S9QD8ONLwGU0e09iTemmEq3gfDs"
X-Provags-ID: V03:K1:ItB8pl9ijhTOPYU+EBpIjAlLTnBWrnHJgC2dMeJSeswlKCFM5mb
 fTsTNJlSqQaeNR46ARdR5LzB4DxNMZU2DJl39RRg8WRWPyONvaE2CLIVoAH1ukg9ZFq/gy8
 Tt+ekadir8n/fcRyFTFNIQbMvFC6o7S1bJp794IbVCmwPNsYin/uMrkBXxG6/TuktIHlW0x
 nNf9F3rzWox1xD7TCQAQg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:riPYvGpz0og=:ajBTfhgZqTSore+egmezRx
 h1AOIL1HtyRfweQLdoml70XddqVrjSr2wFw4cxR7GmGMiIi77UYPbJVlPw0LO6eWW0k8fcC+8
 DzMLh0uvrgGjpXLlkxFF/Gas0mPiDJ/khqt1fGplp1v1W3rDNbqvNuCtYq5YgiuCzfDKwehIr
 /DkmMfCD1acSkdueE7N5CtMNsgV2QkvLi3zE2mrESlzAAm/7BHBrqwdwC8rAdG4jaJD4nrQz6
 60ObWN2+StSJL2op0K/banbu/p1qp3bcckptpQ9FBQXMRarQoJn/NucmxrGOpPt1l6MDnw7ZW
 pOirQcbI2FFYahf3dRzcggmFCvDGHe5tmRWGBDO54QNH+WpnjDl1TKGC7UAh4KvrgBZjs8ZMG
 erkl6TLTkcSDaolb240mIu5B/AT3jVPV/3pV0RGyic+XbSfpsR/gVP2RQnl+geqC8nbkymcq0
 f/avszGnMWYx0lfcVB7n+6pg6imI3AwQ9rdMZIwMzu+Z2N4i5CTniyRcv47Mr4p2KZA/NgVl0
 Hs7ro7i5SxD35KDCUM6HnDtRrMfaSLzcArvDh8+NBgoXzQfwo31CNgj/OlBUIvctodkXpfB/y
 N3HewmxO2J3TA3uilGzZeiqT4npMj3/AzgLHRfyHGYwT/smLYFjnyrCTfE9xEExoRKy3kldY+
 g99wDrck3oz/lhEGSVMJtDDTgpT6N9EWPv24ns+Hv/dc5UmQxLWjzhfhRtfRBaqaLBsAOPSi0
 lgYww4ca0GAbptqSw4xcGnQlrcCQPt2AyhLn8y3d/tGRjJizFM0A8gQCmNpX0nag4nuURjJbm
 D6rn8tJt8+yfWaNv3zg9aRXar82fg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hqf5k8S9QD8ONLwGU0e09iTemmEq3gfDs
Content-Type: multipart/mixed; boundary="ZXP76XwJ2ubIFp2QQBdTVNApRxmHJYJKN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <c9af2ee8-4148-957a-7e2e-a10f40a1dc00@gmx.com>
Subject: Re: brtfs warning at ctree.h:1564 btrfs_update_device+0x220/0x230
References: <e5970ef2-3d22-6c49-0634-8e6d9d92191d@mail.ru>
In-Reply-To: <e5970ef2-3d22-6c49-0634-8e6d9d92191d@mail.ru>

--ZXP76XwJ2ubIFp2QQBdTVNApRxmHJYJKN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/17 =E4=B8=8A=E5=8D=885:27, Dmitry Katsubo wrote:
> Dear btrfs team,
>=20
> I often observe kernel traces on linux-4.14.0 (mostly likely due to bac=
kground
> "btrfs scrub") which contain the following "characterizing" line (for t=
he rest
> see attachments):
>=20
> btrfs_remove_chunk+0x26a/0x7e0 [btrfs]
>=20
> I wonder if somebody from developers team knows anything about this pro=
blem. It
> seems like after such dump btfs volume continues to function OK.

It's a known minor problem.

"btrfs rescue fix-device-size <device>" could fix it offline (unmounted)

Or if you're using the fs as root fs, resize the fs by removing 4K would
also solve the problem:

  # btrfs filesystem resize <devid>:-4K <mnt>

The cause is old mkfs/kernel isn't aligning device size correctly, while
later kernel is pretty picky about that alignment.
It's mostly a developer oriented warning, no harm except a lot of scary
kernel warning and may slow down log system.

Thanks,
Qu

>=20
> Thanks for any information!
>=20


--ZXP76XwJ2ubIFp2QQBdTVNApRxmHJYJKN--

--hqf5k8S9QD8ONLwGU0e09iTemmEq3gfDs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvGiyEACgkQwj2R86El
/qiAMwf9Fw8ArKaYfv93N2Og9Es7duW/C2CtVABFqS8R5y9LE36RFKPJvgZaLg5z
OqyLGiKJPNd1ZvYi0J0uHqfVM0xXWIMfXWYWrTrBltoBldZ/iUw2flqiYSHXBq61
fkZL3CuHx0jJo0PlNNFR+8MCggB/P8sodQmumEVllOEO7IiqnAc80XgDpl6Nj3s2
37j4LzZsfWByZnQnB5EAEKPevBS2sbCMQ9c+wLOhaHCwuykHEaDO7OlGMuEsEOFF
R6MPUYOcSVxmm8Aqv99O77GYrt8SWxEW1kpa0L91J1u15Kabg2p/WxCIfsnyM3fc
66B63QbXm3uuV2vPOnT8LR8ukjqxXA==
=AcGj
-----END PGP SIGNATURE-----

--hqf5k8S9QD8ONLwGU0e09iTemmEq3gfDs--
