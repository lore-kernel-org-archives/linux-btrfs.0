Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71209C282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 12:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4985320821
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 12:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfBEMR7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 07:17:59 -0500
Received: from mout.gmx.net ([212.227.17.20]:54107 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbfBEMR7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 07:17:59 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MNqcR-1gkdsf0FWV-007R3l; Tue, 05
 Feb 2019 13:17:54 +0100
Subject: Re: Help needed, server is unresponsive after btrfs balance
To:     Moritz M <mailinglist@moritzmueller.ee>
Cc:     linux-btrfs@vger.kernel.org
References: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
 <4ecaf7ef-49cb-d7f6-3535-941e44e2f469@gmx.com>
 <1a6d00fce82926ce9ec7db7bbab37c12@moritzmueller.ee>
 <30c7e926-98c7-fd82-f587-1478d31cbf58@gmx.com>
 <8f0a80ce7323b216ab90fdcb475b6340@moritzmueller.ee>
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
Message-ID: <a0f42594-1b35-5044-2d6d-b82f9f19105f@gmx.com>
Date:   Tue, 5 Feb 2019 20:17:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <8f0a80ce7323b216ab90fdcb475b6340@moritzmueller.ee>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q9MKGoBhfTjmmqlzrhmRaEIxuvJpZoJqu"
X-Provags-ID: V03:K1:vpDuvrNeTaznrTNNKMEnz+G4AtBvU6Z3UmMJnsyTEr3nS4nyHOs
 Y1HBIlZIHIzpwWUB1wfmE8Cqblp3EEJINKbIENo97QOb+HIp1+Lk28/2kwEFvE2EiPDqRK1
 7+ZZmBZgQiK+WJpp7NopBDxVNmVsF0nXtJdt4GgPJDJZigz7drFHRFVI4tYZ/OrpcYWpnPu
 RJw7LK3v95Z9o5FGNdL1g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CYDIcL3OlFI=:lRiIf93Ue24k2sSkEqG9E0
 PbyC6A/V0j+Hq3WNa4+aDIOqaQC99vBnCmZJpHc39YGFWZVjiEPdr9JpILOGfa74hp238tLFz
 NRgL3pNNIMDWxUhp5nIky4n2MqMrMnCHwRMZKa4WPTX56Rl3w1Pnx4SRyI5ZtdI6Uuiot36BN
 3cRni7O2iMxGWHGpayMbuE+qSvft5DvV/2vZ30wJpm1u7YFJPHTZUhq+ggnq/ZP1N7907G1bi
 3UpoDsT3OfuBKS+JB2PrxLS/Zcxaeoi8bNjPSidZmDCtaEFqt55h8x5nUsVCFpL1BJwT4CWxw
 TM0OSXe/okZrHes20UqiNiyz3Tp9oyC4XZ/lNf0MHcbj7GNBVEia7mMf+2wOWxICvwRFos0RD
 vzyRxHS/9zXxcmk/YjAw5lXeQdSF3MGCx5uecdDRJTXSfVsDpi37XlZWgFq0x/y0kDeLbGD5T
 HfA5txOLaawmfm+7b81S/UCgTkSGaeQkOP9RuSL/eE/oJFJFbxfWJNozZ+KeZthjsUccLdpnx
 rRnVLn26EImQ3MXXZE0hzuh3SCbnIfT0ZBpN66NvkL9Ja3m/vmnA6feCxJwvrf6VTzc6vLN0D
 GOdHYd25GOrSDKC4I2VT1WZCij0PnEz5ZkywWxThn/omrRMkueTiy41f4Gk/kJzIn/4ccwJHB
 B/lNXyvB3VIk1TjPZ/WOBFKKlD7xaP8Z7J08J+omO57NqogLg8VMfMiU8u5M/fSNc6hsP+OLI
 C4WiyvP6il9un+7h6U1PbpHPttbN/oLjvAo2KBEV3AxHgnwaf2q4L5u4gjQ5YllWiGn/adjB2
 aW0CH0axSSHq7IgZ/Jz7JRBRjHVZwg3P/K+eTq33ZIdW7Ez4dV3B2lLj5UZbT8CljFv00jPgE
 ruyK6jbFqUOSNY99mfvfdoWMWLcHnA7G50az2kr7ngWFatMlfXHwNg/rkVSo6I
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q9MKGoBhfTjmmqlzrhmRaEIxuvJpZoJqu
Content-Type: multipart/mixed; boundary="B2VOxD0Nk7Xrc12yu9xCavVMgKYPGi67N";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Moritz M <mailinglist@moritzmueller.ee>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <a0f42594-1b35-5044-2d6d-b82f9f19105f@gmx.com>
Subject: Re: Help needed, server is unresponsive after btrfs balance
References: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
 <4ecaf7ef-49cb-d7f6-3535-941e44e2f469@gmx.com>
 <1a6d00fce82926ce9ec7db7bbab37c12@moritzmueller.ee>
 <30c7e926-98c7-fd82-f587-1478d31cbf58@gmx.com>
 <8f0a80ce7323b216ab90fdcb475b6340@moritzmueller.ee>
In-Reply-To: <8f0a80ce7323b216ab90fdcb475b6340@moritzmueller.ee>

--B2VOxD0Nk7Xrc12yu9xCavVMgKYPGi67N
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/5 =E4=B8=8B=E5=8D=887:45, Moritz M wrote:
>=20
>=20
> Am 2019-02-04 14:55, schrieb Qu Wenruo:
>> On 2019/2/4 =E4=B8=8B=E5=8D=888:49, Moritz M wrote:
>>>>
>>>> You're using qgroups, it's known to cause huge performance overhead =
for
>>>> balance.
>>>>
>>>> We have upcoming patches to solve it, but it not going to mainline
>>>> before v5.1 kernel.
>>>>
>>>> So please disable qgroups if you're not using it actively.
>>>>
>>>
>>> Thanks, was not aware that I turned it on. Is
>>>
>>> btrfs quota disable /
>>>
>>> enough for disabling qgroups?
>>
>> Yep
>=20
> Do you have any idea how to validate if the enabled qgroups led to my
> problem?

It's a common fact.

Especially for balance.

In this patch you could see some of the performance difference:
https://patchwork.kernel.org/cover/10725589/

The final fix should make balance only takes 3 seconds for that workload.=

Exactly the same with qgroup disabled.

In short, quota enabled, balance takes 20s~2min (depends on the kernel
version), with quota disabled or with all my optimization, it takes 3s.

Thanks,
Qu


--B2VOxD0Nk7Xrc12yu9xCavVMgKYPGi67N--

--q9MKGoBhfTjmmqlzrhmRaEIxuvJpZoJqu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxZfu8ACgkQwj2R86El
/qiL/wf7BHAfbq8uHFDgCPDxldehWBB+6DFI1VHWhVh0z9Q/HtNQ4g4CUky5B46K
dTaV0ERWU6fDTxdVdwPMQwDKEfkDc41lmSn0b/RgG+0RxHN4KvEYT+MANh68dxJP
d1qiiq9l7Ov7zcDGV2wKSh23vkmLpcsUOcvbcO5DRNjUU7FO1DR1SIGT5GRpzKsi
4ySglsVZzsctLbB8k5xD0JK8Xm76jtuc5K1CAjrrcWhY8utCgNn0k36OOHnyUmFP
H+iFQGSINxr5N+NeaEkpEw/E9OmdlYlr3AN3PuB1d5QrPwDCJPscm9CYjCYEqcO/
yPepDWxbKMJEkZThGJYDfV4jGR9vlQ==
=DVaY
-----END PGP SIGNATURE-----

--q9MKGoBhfTjmmqlzrhmRaEIxuvJpZoJqu--
