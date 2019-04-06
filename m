Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A707C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 07:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5521B20989
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 07:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dEUTp9XN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfDFH50 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 03:57:26 -0400
Received: from mout.gmx.net ([212.227.17.21]:57449 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfDFH5Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 03:57:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554537406;
        bh=gC+9z4bgYL8QrsSwHxobwYUg8BuyltA8i9cBBzqBwoc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dEUTp9XNQ6/KVJTr+KnOG4qTIhNdadcn+EVKSqoZBZ08gjPQv/2wOwwJEbSw+cIAu
         Wr40//HqE//YxeelhNDhnj4vgzWSJhk6wDM/mSsbr+MT7i7LAy6pSVF+laAR4AZSwo
         FyPRfesnOaaZzUwVRA7DAraOugtrVh+YJtjFH41Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MMGWH-1hGEQC0NeH-007zkl; Sat, 06
 Apr 2019 09:56:46 +0200
Subject: Re: [PATCH 2/2] btrfs: Add error string for EUCLEAN
To:     Nikolay Borisov <nborisov@suse.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20190406031426.22436-1-wqu@suse.com>
 <20190406031426.22436-2-wqu@suse.com> <20190406045008.GE1177@magnolia>
 <02797135-0903-4d4d-67a1-469a13e20397@gmx.com>
 <782bc384-9022-6f5d-d4d5-90ff180bbb90@suse.com>
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
Message-ID: <364069a4-92ba-0f1c-99c6-e9a0474e2dc2@gmx.com>
Date:   Sat, 6 Apr 2019 15:56:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <782bc384-9022-6f5d-d4d5-90ff180bbb90@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rrIYHWyGs7a+wNY77BViXBfQfZ+ngO4+938Cd+FMUtp2E2hs2FJ
 ALt/w1Y9ZX+tZP0HVXptiFkGW70FLRo9+yYYeYuJw5kkgz6/Fvf+uekYSl7tdGPdxRSjh/Y
 l/8MjxYLDc2J+GHfrktVbIZyinYyBjow48oE/psLgX3gEqLOX/WGPajPVVPommKawblxmfL
 7aUJBLBRcL6b1bHXnEdtA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:A92rHVafRZk=:fH+XMw1jSpxhrEgSjBqIab
 V3D4MZlngrtZ5vJMfclvMZuSj24AFUWGRqABt9SJquF/lVrNWDfFHA2P4mMsOJricx50m22TV
 AqIukxIdPIZsIrweKrqOfBuTEiJK7EKKYwjGluCnjt1uO8jK95NwrzIdmIAqPJ5kUi9L7d5X4
 Ly0r6DMsllTVxANYZ6dNgPdkA/DtTNVL0qt/P9EvXY9WnWev4T2cgW9IC3QkMpjwdSHnXXX+s
 YkYWG8rvEHJc3z8bBCw+c2DeGR3ePXqd/8ghBgD1qCkpa5kFedrUvah14FQ7cRRzIz3hot7o2
 GEGnzomvArUbseQAxUa2IClcb7RYHk0kEJ5AGDOMtpz9becc20n7Xw87IwHyAcUHv+P7VynMJ
 LYUCPt5jr9T1FSG99KMMfOvoxgdIVqB7WPMqrBvVqCuCsaaCyBYSHi4kV1D6k6VyVQUaXamWd
 3oEBNti8UHPrsqwHZachR7HluS7lCrajeZBztSrMtK0w5KeKn+uogKjSPzBl8ndCoTRuAfu0N
 Tvl/5aQ2fuHlQ4NGWmgzulQMmRkyBn1CzYr2bvddNzA138iGed7aCfNb5JReoYhpP3GrX+2e8
 9IzcFCPatcI4mf9B2Go4+i7y3c5b3HEo2ORLYAQ5PVVwvr5zNjhW1UiOscg9BX5Nige9sRSvd
 qdyYtUmDX/2Zag3dMgWnBgoR4sXFBGmfxjV2xObiRuk0OyeeQdrTvhJvSQM2dJ8nbA0NLTXfq
 ++oSeihj13EqSxYa5iWwzTIvCAUxS7rhc8x/ti6K25XDw4QvjmW5GfoRsW/DD8DY+ktjxEqnr
 0WEBBQQRhe0nUMmNAiQu1Mlqfqi5YBpoZKUrRBJ6jP6YnAtW2NhI28eNMIRn6svJvf59rScwQ
 fKzWOLAD28jYJ/hJLIJMArUMwpkINAab2NMu1FWEs4iUUHxnaIRnozjDsRrjPKQ53MV5BEpXG
 FfIAZhFBNBQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/6 =E4=B8=8B=E5=8D=882:20, Nikolay Borisov wrote:
>
>
> On 6.04.19 =D0=B3. 8:05 =D1=87., Qu Wenruo wrote:
>>
>>
>> On 2019/4/6 =E4=B8=8B=E5=8D=8812:50, Darrick J. Wong wrote:
>>> On Sat, Apr 06, 2019 at 11:14:26AM +0800, Qu Wenruo wrote:
>>>> Since we're going to support write time tree checker, it's possible t=
hat
>>>> transaction get aborted due to tree-checker, also due to new
>>>> BLK_STS_SELFTEST bit, we can distinguish real EIO error and EUCLEAN
>>>> error.
>>>>
>>>> Now add error string for EUCLEAN too.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/super.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>>> index 120e4340792a..a4cbbd7861d3 100644
>>>> --- a/fs/btrfs/super.c
>>>> +++ b/fs/btrfs/super.c
>>>> @@ -86,6 +86,9 @@ const char *btrfs_decode_error(int errno)
>>>>  	case -ENOENT:
>>>>  		errstr =3D "No such entry";
>>>>  		break;
>>>> +	case -EUCLEAN:
>>>> +		errstr =3D "Selftest failure";
>>>> +		break;
>>>
>>> EUCLEAN usually spits out "Structure needs cleaning" in userspace (and
>>> ext4 & xfs have been using it for years to complain about corrupt data=
),
>>> so why diverge here?
>>
>> Because the original "structure needs cleaning" doesn't really show the
>> meaning we're using.
>
> On the contrary, structure needs cleaning means the filesystem has
> detected a consistency error. How that detection has happened shouldn't
> burden the user, the important fact is it has. Selftest is somewhat
> cryptic, I'd suggest at least "verification error" or just go with
> canonical "Structure needs cleaning".

OK, I'll go that way.

Thanks for the hint,
Qu

>
>>
>> We really means, something wrong happened, thus I prefer something like
>> selftest failure.
>>
>> And, the idea of adding -EUCLEAN, is to replace the original "unknown"
>> output, if you're sticking with the original error string, we still nee=
d
>> that branch.
>>
>>>
>>> Wait... does "tree-checker" mean online metadata checking, and 'selfte=
st
>>> failure' is what gets spit out when it finds some metadata it doesn't
>>> like?
>>
>> Yep.
>>
>> Thanks,
>> Qu
>>
>>>
>>> --D
>>>
>>>>  	}
>>>>
>>>>  	return errstr;
>>>> --
>>>> 2.21.0
>>>>
>>
