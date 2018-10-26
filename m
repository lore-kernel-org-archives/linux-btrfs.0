Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94786C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F3920824
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59F3920824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbeJZVKR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 17:10:17 -0400
Received: from mout.gmx.net ([212.227.15.18]:39183 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbeJZVKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:10:17 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MZCUG-1g1mlh1IGi-00Kv4S; Fri, 26
 Oct 2018 14:33:16 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MZCUG-1g1mlh1IGi-00Kv4S; Fri, 26
 Oct 2018 14:33:16 +0200
Subject: Re: [PATCH 1/5] btrfs: Ensure at least 1g is free for balance
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-2-git-send-email-nborisov@suse.com>
 <efa4b7ed-118a-62cb-2726-7e4c534a8c5b@gmx.com>
 <aff57cd1-88a8-6f4c-5b61-32100f249def@suse.com>
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
Message-ID: <82fb00a5-5e82-7f54-ec6e-286b51a51442@gmx.com>
Date:   Fri, 26 Oct 2018 20:32:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <aff57cd1-88a8-6f4c-5b61-32100f249def@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:BZa19/kfrVAFoNu81kPOkBkzmZ/nSzYYQWlgzYGISCx2V2oqYtK
 ZH7cSwuBFTVW3NmWDozt2khwcIhAf9h2C9kaS5+EJPQbFyDEaYfMbsI91NnpQ7I7X62s3hi
 y5LM832bPEfJIaZkLhbN1K8vamL/l+WOJnEZLcBaae/oN/+XKZ4YGaYevyst2tdUn5+NZAp
 MZhNHO2aDqpIHLk54e0gw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Ls9VaqfvI4M=:wrHGmQ7sdptAr0dP2FfU94
 /6xFQso8ad9iMWLAhesRdlr40tFTY6wbge7NOkWptCPrZOyLdHjDm2rGHUfOxvrU5XDWgwOiZ
 ICIVXsaiQLEPl+zy8ta1r1NKJ51XaDMQdzq7reT2xz6b0p9MyHYqFcNqMs7ED9qeekNUM41/c
 uoh5DVQmFxdTdp0cvM3negd+e74eIFHUgU/9IVjKBbV+WAYkzewo5RiicO6Ms6xv42JXGwnSv
 +gNaP5iQx41kfQD+0Q6jvcaTBH4vXUFLuGHtStuysmmwozT5x+6sortqqZJ0Afaq9+eW49Fam
 cCW2iZO9lsbkLWNulEY5Yt+nR//gqsaWuUM4gPNmtWAcM5inheXIderiUK9YHIvk6+AgN2bM6
 bYjDf8KSsC1KEgRLmVKYHldV9cCSyRTstpVw/MSVs4tdOzub9JnKWuXWrR2riu6eEsRvdbVaA
 ivMOj3ovas0+WH5y7GTwZiWmtUTLz+tT07evYXAIsScesSrsNDKfM9e1xRIWEJgkegNaG8FXd
 pGH60vwB9rGLULTKPY8g6e/dTgoe1dsdZ2Xavf/6QyCoyw+LLUhSGQWkvpWw+uVnUPi8bTj8c
 kxCMkqrXz05f2YjZT4LdYOtdrSjDh9DR9aumItfw4N9Pmiv7sAKCWpS26sll9HjY228I5DY0p
 ip/wcjlU2kNw2+IWwbMc8HmtF1WyzndhzRu6qm9fg4T0UWSKcLKGb0U5oYKtTyoKhbSrFa6Ty
 CgTKZfdmINug498A8/DGypOe+2+av/VbMV+fKM+a91qRpSIBcLXk7H+svTtAc/0z6oL+gWTtA
 17hmG/aB2YOuKkzRzAMqPE4V8udUGL21wtDNoQX7W5GDnnxl84=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/26 下午8:08, Nikolay Borisov wrote:
> 
> 
> On 26.10.2018 15:04, Qu Wenruo wrote:
>>
>>
>> On 2018/10/26 下午7:43, Nikolay Borisov wrote:
>>> The first part of balance operation is to shrink every constituting
>>> device to ensure there is free space for chunk allocation. However, the code
>>> has been buggy ever since its introduction since calculating the space to shrink
>>> the device by was bounded by 1 mb. Most likely the original intention was to
>>> have an upper bound of 1g and not 1m, since the largest chunk size is 1g.
>>
>> Minor nitpick, largest chunk size -> largest chunk stripe size.
>>
>> As for data chunk, it's possible to get a 10G chunk, but still only 1G
>> stripe up limit.
>>
>>> This 
>>> means the first stage in __btrfs_balance so far has been a null op since it
>>> effectively freed just a single megabyte.
>>>
>>> Fix this by setting an upper bound of size_to_free of 1g. 
>>
>> One question come to me naturally, what if we failed to shrink the device?
>>
>> In fact if btrfs_shrink_device() returns ENOSPC we just skip to
>> relocation part, so it doesn't look like to cause regression.
>>
>> If this can be mentioned in the commit message, it would save reviewer
>> minutes to read the code.
> 
> Will incorporate it in v2.
> 
>>
>>
>>
>> BTW, I think for that (ret == ENOSPC) after btrfs_shrink_device(), we
>> should continue other than break, to get more chance to secure
>> unallocated space.
> 
> I agree but this should be done in a separate patch, this one deals with
> the silly upper bound of 1m.

No problem, just a hint for a new patch :)

Thanks,
Qu

> 
>>
>> Thanks,
>> Qu
>>
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>>  fs/btrfs/volumes.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index f435d397019e..8b0fd7bf3447 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -3467,7 +3467,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>>>  	list_for_each_entry(device, devices, dev_list) {
>>>  		old_size = btrfs_device_get_total_bytes(device);
>>>  		size_to_free = div_factor(old_size, 1);
>>> -		size_to_free = min_t(u64, size_to_free, SZ_1M);
>>> +		size_to_free = min_t(u64, size_to_free, SZ_1G);
>>>  		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
>>>  		    btrfs_device_get_total_bytes(device) -
>>>  		    btrfs_device_get_bytes_used(device) > size_to_free ||
>>>
>>
