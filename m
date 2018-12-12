Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9212AC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 05:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CFD62084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 05:09:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CFD62084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbeLLFJN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 00:09:13 -0500
Received: from mout.gmx.net ([212.227.17.20]:34169 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbeLLFJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 00:09:12 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LdKs1-1hF78j2UkL-00iRgo; Wed, 12
 Dec 2018 06:09:05 +0100
Subject: About enum convert (Old "Re: [PATCH 1/8] btrfs: delayed-ref:
 Introduce better documented delayed ref structures")
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-2-wqu@suse.com>
 <235ca34f-bcda-128d-dc3d-7465766271c7@suse.com>
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
Message-ID: <61926f61-2f34-2636-74ed-bcb04bb969fb@gmx.com>
Date:   Wed, 12 Dec 2018 13:09:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <235ca34f-bcda-128d-dc3d-7465766271c7@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:aGT3ksYj07fFPsVIYIh77+f0xsoMchEvV0nldbQBV6ruqyOCBmc
 39bD61Y6igw2PRrCrP3CiPam/2XT5PcXh1UKbhvSjkqQewdhSQ6Nj/Ekm3nRsRf7eW+mIT5
 SJJiy0rRAQRt8bta7BxUKXhead0nrokY7xeRDeoqQhbprF1CnMwDhBNgO0CnDUzhfYzGsyy
 KxEdGOQNyKY3NUn+tSO8Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GWqDnLx4+bo=:IJAbFMnbxAkgDuJmchOyHF
 jmKuwTX3B6+IJUGj9WH0eq+WcLkptnUUVVdiGhshUxCemClr3URqdHwa95VdUyiUuhoyzhAWx
 VCGrOsxbXOtPSFPjG0rXC1HpVFUnhPUtKWwRdHsPrW9XWdenXh+v9dEuatpuxg6aqXUdtsXsY
 8BznYxXjibXkcy18n48xpXdjU6WNdi+HMfLS1joz+oMC44vp14mNTbts5jyphUjYYuAf1aOkQ
 zzwnHCQ2PcoEiTf+kuD1dQPmv3KnCjwA4cdpf9E8F25noshhkapEiTbX1hQtsYJH6pgI/E1Y3
 GtBuM1dBn9Hf/Ca7ONrJNweNvZndnlb/BlJpvmxlxcOEinnmnQGYvSvqKQoONLR5keUYUbelZ
 cMAhe83ZPPeOKljZcsMCVt8bPdUNUU0iVuoBDNMwMBAC6SKQRRRPaSJlzFf36xK5HOMshvrsF
 TWKGjlCti4YogsW6XmPi91Mm+NXq2SI1jtWBoGHtKY855J3SYSxs2KpvUjqMLisLMt+0A3wNm
 DiCEPkft7tBG/pz11z96pr6X6PEG9blK2nBwGnpRMnbiCf3ZdOswA+LL41wgEKXAtn5z32Y5i
 gxLcd6hmZB3oyiWnu3MSvtXwTExAZoq7HpBrR6g4Yq54GTJDukWsc4YDnX1tOaPa67Tf2dQ9V
 tgWb+eSvi90TknHfIG7d285CEeotKVZZlp1rx8stMbkOfK8NnaRcRlnPq+GLdPsT7ImKJO8Tr
 1xXKXm/fBCc0+Y0FJpb2Ki4bq7z7ibdsLIWidlchsL5YDM5jaFub0XXsqr/Wr2yJZhQAmtNAH
 hzzicwNq2W+0zJNazebaFi0hrZDqs2qdkCxUvQIpIE2a8CI1TTs/bZJtDt954a9bbP7KwPlfW
 NiisoJ6ZM0fqSX4SoGMGqrUbkbLF8Uk787lZrTml8O3fhPgN5PC3/MmIN0uOEu+Xi1JCeAQII
 WxWth+takPw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/10 下午5:48, Nikolay Borisov wrote:
> 
> 
[snip]
> 
> IMO it makes sense in this series to have a patch which converts the
> action defines to an enum and subsequently modify functions/structs to
> actually be of enum type.
> 

I'm completely OK to convert it to enum, for its conflict free nature.

However I'm not sure to which degree we should go.

For current David's enum cleanup, we all go anonymous enum, which just
acts as an auto-increasing #define.
However AFAIK compiler can further compress the size of named enum if
needed, and it provides much better type check to prevent us to do
stupid type convert.

I'm wondering which way should we go. The named enum (which needs to
modify all parameters) or anonymous enum for less code modification?

Thanks,
Qu
