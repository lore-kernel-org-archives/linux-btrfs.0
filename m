Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85CCC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 10:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95C2220839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 10:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95C2220839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbeLLKHd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 05:07:33 -0500
Received: from mout.gmx.net ([212.227.17.21]:45445 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbeLLKHc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 05:07:32 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ldspr-1hFk2i0Bxj-00j05P; Wed, 12
 Dec 2018 11:07:24 +0100
Subject: Re: [PATCH v2 2/8] btrfs: extent-tree: Open-code process_func in
 __btrfs_mod_ref
To:     Johannes Thumshirn <jthumshirn@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181212073102.7736-1-wqu@suse.com>
 <20181212073102.7736-3-wqu@suse.com>
 <c8dadde8-611a-e402-6b1f-495847164028@suse.de>
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
Message-ID: <96bd3959-822d-5289-4b84-3a5db88ac991@gmx.com>
Date:   Wed, 12 Dec 2018 18:07:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <c8dadde8-611a-e402-6b1f-495847164028@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hwEDLIRCy43XvnTs5c8wUvRM7V6Sg7WTT"
X-Provags-ID: V03:K1:nTd/M3qO68THC4lr41ej/zrWB8A9g5k6igDo2QYA9SGK96z5HaN
 l4dnHiS/QxBKnFudpv/j2t6eIuObwipkFprhMG/iNMXtOaBGthT3uiOA67hVVOSJMtsuobJ
 VaeHx3nmJFIUnNry06b1D2SQAcgKouUfynhM5ykKPbkt/tNzjOHcx+jkdcVfd4SeGKUpAHF
 xW7jahC8Hqf6XNvBJrGKg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QNz/prYMgsY=:iCZL6Zfi9RYe6cB+9rsmRZ
 qh0DP5ob4ejaLvYoCchLKSm1LXEuAdwgP0ZWMA+0DnHJRak6VBzjizaAEZ2A1fW8v3Fn2CpNt
 jxQkpxdmqG+ge8j0x9EKZ1FVsTVzQoAs4s1JFFFNqRF0ovqSKWNhJowKz302WSyfotUtaZZ2+
 BPMHRYSc3/VXDJRE3HpzqA8zaOTYp57jUODbGBTaefrFdG06DBGnyht2aJFT1iHKfd07ejPvk
 FJbg6OpUo5R+AjUCwBEl4FpHNCU8rUdKrlbpM7bseKADeBbvoE/Raim+NmHGhwJYFaiROPqJ8
 zIMUX7frAambI1RLcjhWS2vrBKvjXeeapoBrhTWBEnWWil2dTMgTcGenOikamkUi+fS/VIaxW
 5vCxc8Phfg3kNhKKtOvaSK99sNNEg1r7r097qrKBpfAzbFaVY61KRwbfP+L8uEJbJxvdJKlXo
 p4YIetQbX8+08htUeo//5MTtOFrS7I8R2qIyXkIHgpT7yfCjknj2gE4Ymm4PiN/tNzmJiMU6N
 l+8aTHfXXAvlcRjASwaaejk6klZFo+wf+6W3rNiYn3CLSEDVKrvGlC31Pg8T6jIEBkZpn/TkS
 +qFc4O73vMO7tTxw+EBtCFiMw7+Ii5mzq1gSbHOi5ODihzqO+3vwAf3jS2RMZ0v9Ofhmcp9qV
 D3emEI1LSJ1FRRoanMIMDY1cogJ2JH9ALLJ6ES1HHzsFTUN8lGoCghnTxY0KW+JtinB5Fak3v
 kpnK5XOCFkoFJy6txiuhtGwQ8XNl7gyml+kIED6QD9vAN1XJlXIP0mnPXZWywUkkrlv8vUxhf
 27KcAIwoaiagPo1p4SIdeOYeKrHFJtjiXbQn5tKDPd1TSV163s1F/V+ShxeJTeYEuVV/vJ5lB
 ofnfiIqC+CFdRieFVhoJYEOVQ2MS00wird3WXUIuzHanx/pDjOvsHNEUKf2tkr
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hwEDLIRCy43XvnTs5c8wUvRM7V6Sg7WTT
Content-Type: multipart/mixed; boundary="Aw7ZPLxrguSwAR3Zzray5CjX9QhdibfNh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Thumshirn <jthumshirn@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <96bd3959-822d-5289-4b84-3a5db88ac991@gmx.com>
Subject: Re: [PATCH v2 2/8] btrfs: extent-tree: Open-code process_func in
 __btrfs_mod_ref
References: <20181212073102.7736-1-wqu@suse.com>
 <20181212073102.7736-3-wqu@suse.com>
 <c8dadde8-611a-e402-6b1f-495847164028@suse.de>
In-Reply-To: <c8dadde8-611a-e402-6b1f-495847164028@suse.de>

--Aw7ZPLxrguSwAR3Zzray5CjX9QhdibfNh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/12 =E4=B8=8B=E5=8D=885:40, Johannes Thumshirn wrote:
> On 12/12/2018 08:30, Qu Wenruo wrote:
>> The process_func is never a function hook used anywhere else.
>>
>=20
> Hmm this sounds odd, maybe something like:
>=20
> The process_func function pointer is local to __btrfs_mod_ref() and
> points to either btrfs_inc_extent_ref() or btrfs_free_extent().

Much better, thanks for the better words!

I'll reword these commits.

Thanks,
Qu

>=20
>> Open code it to make later delayed ref refactor easier, so we can
>> refactor btrfs_inc_extent_ref() and btrfs_free_extent() in different
>> patches.
>=20
> Otherwise:
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>=20


--Aw7ZPLxrguSwAR3Zzray5CjX9QhdibfNh--

--hwEDLIRCy43XvnTs5c8wUvRM7V6Sg7WTT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwQ3dUACgkQwj2R86El
/qiHSgf/ceOj1v+ZVI+SK+/TpqjeU0PRlWWAi2nICLoN7AHGfnL+ovUsL03jKfRo
tZ/Qf4giHhrpgmhLU2VFWWTr6Q0Q2I3YWIE36/Zj5fKjxJ5YA1WW6je/WNwuU6GK
Kkf5oCcJnKq5pErlUZhvR/TuAkPm8xVYlmZ5mNm4N8UTovJJilTxaJjDgD4SzeJ9
GhjbhzlzndQYNUpX/U1JOvaYVqFrfwCtLUxecXuiw9sfvqAV0BB/TdrrQkbWFzUu
gV+6WbsypVPHPu4BEF9Q13wNEPhTmq67VeVabcrIV59l8uNi/BDiL1fqaIqsC7CT
z51RnQ0rdU/L5oii0YAyuGMFN1MEQQ==
=aTPE
-----END PGP SIGNATURE-----

--hwEDLIRCy43XvnTs5c8wUvRM7V6Sg7WTT--
