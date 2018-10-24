Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA210C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1F5F2075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:09:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1F5F2075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbeJXLfK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:35:10 -0400
Received: from mout.gmx.net ([212.227.15.19]:47613 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbeJXLfJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:35:09 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M2LZc-1fN1kh3mfk-00sAJK; Wed, 24
 Oct 2018 03:24:33 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M2LZc-1fN1kh3mfk-00sAJK; Wed, 24
 Oct 2018 03:24:33 +0200
Subject: Re: [PATCH 03/13] btrfs-progs: lowmem: fix false alert if extent item
 has been repaired
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-4-suy.fnst@cn.fujitsu.com>
 <3363e342-9acc-95d4-cf70-2872fc8b6258@gmx.com>
 <825f4755-1f86-e778-7c9b-3798ea5c7185@cn.fujitsu.com>
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
Message-ID: <efb6600b-3a78-52e7-e039-bd23632bc452@gmx.com>
Date:   Wed, 24 Oct 2018 09:24:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <825f4755-1f86-e778-7c9b-3798ea5c7185@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:tv4AkgajI4BAoynPkI1B4urGcpD8BhE6RuFTmDnB/MhqhAahJrn
 RgT66ToNiHWZsfSP5/6j5jRinSQZFCW4KCeT6aBxnjcj/dk5+rSQGtXerkQjThZ+yDXG8yr
 7LXZM4AiYABNFGhKQFfM3iTjxTL2Byu8iUE3IdzHlWZRx0RCivxqJHXntm6Nedj+BXfRvnT
 ANb8tZ/xMa9IWlDQ//mVQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:ijr6IjPazOI=:l8KnI2gdGxKfp/L3vstuWg
 z/2kU0955HWum29irBNpyrywXsnYmrUmiMn+THPR90wuVHvRuce5tJmnA7TOGN9Lh6yVtL7az
 XHbmMfMlX5YsSO2YdeBAMo3Uxg2RCutZZF+EvJnXvwVdXh6iLYifuVT60CiO7+b+ba9jkw/i4
 gA2487d0d/nKLwQQWCcdLfrmb6DFU7dLvcbAuFRBacIB2w43KFonoIlYPd/Fp1j0mUYy6r/a2
 VGIMr++aUey/xgTZ3nZqhKu/LQ29kB80zNqbPis78J0moC7dJwo2pyuMTnLg8wGDEt+nroI1V
 DBwCPXATGavpIAjiJD2gIQTzpYDRtzXuZ6ilV7a1HiJCpUBOmCjIo9jn0RLfdagT9ZgEMNCXk
 Z3KwpJSmU5DT2cPwDlWsOgtj0PywYt4Oyi1BiF10x1H5Hk2ZVAOOZyZIlgGNPhBfjHqzlt3SR
 rLl38zOp0rxAC1W7IAewEU3nAXHaoQrywOuAePQwVGNRLxfRssAsHKkYtcivQHPC2p1ICKfFM
 wng360KqgCX9jPyaSyCEJX0I9jFLxujV+k5GjILRcyqA1aajEAW7Q7E9iJsmnJ4JB5OXebqw0
 xaHBAc3LUITkzKwh/sDO9jkXj03U5fljmKpX0FgFjeu19DSq14Yn7YE0PVIyCsrTmtQxnCGqH
 dkJUBmkHwvlG8CsUJ5eWfjB3Oh+wvJ+EhxGTyx6bqV5zr0deVYWKt0gCQIJRFEQkg6bYwKp8c
 3GWk/YbtoTCJ1hjG673EBioiX5qOvaQu+WHVJVGk/QCYwnlPbEEWjArEAi3yw+bsfj4gdOO56
 h2Co57U+a7LTbJNWbfhVXZxpxG68kUu1ysYdFUVNmJRsSRtR8Y=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/24 上午9:27, Su Yue wrote:
> 
> 
> On 10/23/18 6:30 PM, Qu Wenruo wrote:
>>
>>
>> On 2018/10/23 下午5:41, Su Yue wrote:
>>> Previously, @err are assigned immediately after check but before
>>> repair.
>>> repair_extent_item()'s return value also confuses the caller. If
>>> error has been repaired and returns 0, check_extent_item() will try
>>> to continue check the nonexistent and cause flase alerts.
>>>
>>> Here make repair_extent_item()'s return codes only represents status
>>> of the extent item, error bits are passed by pointer.
>>> Move the change of @err after repair.
>>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>>   check/mode-lowmem.c | 106 ++++++++++++++++++++++++++++----------------
>>>   1 file changed, 68 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>>> index 76e7be81ceb1..769b3141de8b 100644
>>> --- a/check/mode-lowmem.c
>>> +++ b/check/mode-lowmem.c
>>> @@ -3788,35 +3788,35 @@ out:
>>>   /*
>>>    * Only delete backref if REFERENCER_MISSING now
>>>    *
>>> - * Returns <0   the extent was deleted
>>> - * Returns >0   the backref was deleted but extent still exists,
>>> returned value
>>> - *               means error after repair
>>> + * Returns <0   the whole extent item was deleted
>>> + * Returns >0   the backref was deleted but extent still exists,
>>> @err_ret
>>> + *        will be set to be error bits after repair.
>>
>> Well, I have to admit the parameter list is really human friendly from
>> the initial design.
>>
> 
> As my previous design, callers of repair_xxx functions just take
> care of successes, failures and pathes. If exposing the logic
> to the callers is acceptable, will do it as your suggestions.

Sorry, I miss the "not" word, so the correct line should be:

> Well, I have to admit the parameter list is really mot human friendly
> from the initial design.

Thanks,
Qu



> 
> Thanks,
> Su
> 
>> In fact, the only real user of @err is just that "if ((err &
>> (REFERENCER_MISSING | REFERENCER_MISMATCH)) == 0)" line.
>>
>> We can in fact get rid of that @err parameter and do that check at the
>> only caller of repair_extent_item().
>>
>>
>> And then redefine the return value.
>>
>> Like "Return < 0 if we failed to repair backref for the extent.
>> Return 0 if we repaired the backref for the extent".
>>
>> [snip]
>>>   -    if (err && repair) {
>>> +    if (tmp_err && repair) {
>>>           ret = repair_extent_item(fs_info->extent_root, path,
>>>                key.objectid, num_bytes, parent, root_objectid,
>>> -             owner, owner_offset, ret);
>>> -        if (ret < 0)
>>
>> If follow my above method, here the code can be a little easier:
>>     if (tmp_err && repair) {
>>         if (!(tmp_err & (REFERENCER_MISSING |
>>             REFENCER_MISMATCH)) {
>>             err |= tmp_err;
>>             goto next;
>>         }
>>         ret = repair_extent_item(...);
>>         if (ret < 0)
>>             err |= tmp_err;
>>     } else if (tmp_err) {
>>         err |= tmp_err;
>>     }
>>
> 
>> Without the need to passing @err into repair_extent_item() nor modifying
>> @err in that function.
>>
>> Thanks,
>> Qu
>>
>>> +             owner, owner_offset, &tmp_err);
>>> +        err |= tmp_err;
>>> +
>>> +        if (tmp_err & FATAL_ERROR || ret < 0)
>>>               goto out;
>>> -        if (ret) {
>>> +        /*
>>> +         * the error has been repaired which means the extent item
>>> +         * is still existed with other backrefs, go to check next.
>>> +         */> +        if (ret > 0) {
>>> +            eb = path->nodes[0];
>>> +            slot = path->slots[0];
>>> +            ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
>>> +            item_size = btrfs_item_size_nr(eb, slot);
>>>               goto next;
>>> -            err = ret;
>>>           }
>>> +    } else {
>>> +        err |= tmp_err;
>>>       }
>>>   -    ptr += btrfs_extent_inline_ref_size(type);
>>> +    ptr_offset += btrfs_extent_inline_ref_size(type);
>>>       goto next;
>>>     out:
>>>
>>
>>
> 
> 
