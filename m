Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34763 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934233AbeFVQZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 12:25:03 -0400
Subject: Re: [PATCH] btrfs: Add more details while checking tree block
To: Su Yue <Damenly_Su@gmx.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
 <7b34f539-ef57-ecb3-37c8-7b3759874249@suse.com>
 <06086fd3-f28b-5cc7-f3c6-3fca659b2fa0@mendix.com>
 <trinity-79615ff6-1782-43b2-b564-19a911272004-1529684276139@3c-app-mailcom-bs09>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1d838113-c2be-c80a-4238-8d2c52b3663c@suse.com>
Date: Fri, 22 Jun 2018 19:25:00 +0300
MIME-Version: 1.0
In-Reply-To: <trinity-79615ff6-1782-43b2-b564-19a911272004-1529684276139@3c-app-mailcom-bs09>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.06.2018 19:17, Su Yue wrote:
> 
> 
> 
>> Sent: Friday, June 22, 2018 at 11:26 PM
>> From: "Hans van Kranenburg" <hans.van.kranenburg@mendix.com>
>> To: "Nikolay Borisov" <nborisov@suse.com>, "Su Yue" <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
>> Subject: Re: [PATCH] btrfs: Add more details while checking tree block
>>
>> On 06/22/2018 01:48 PM, Nikolay Borisov wrote:
>>>
>>>
>>> On 22.06.2018 04:52, Su Yue wrote:
>>>> For easier debug, print eb->start if level is invalid.
>>>> Also make print clear if bytenr found is not expected.
>>>>
>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>> ---
>>>>  fs/btrfs/disk-io.c | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index c3504b4d281b..a90dab84f41b 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -615,8 +615,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>>>  
>>>>  	found_start = btrfs_header_bytenr(eb);
>>>>  	if (found_start != eb->start) {
>>>> -		btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
>>>> -			     found_start, eb->start);
>>>> +		btrfs_err_rl(fs_info, "bad tree block start want %llu have %llu",
>>>
>>> nit: I'd rather have the want/have in brackets (want %llu have% llu)
>>
>> From a user support point of view, this text should really be improved.
>> There are a few places where 'want' and 'have' are reported in error
>> strings, and it's totally unclear what they mean.
>>
> Yes. The strings are too concise for users to understand errors.
> Developers always prefer to avoid "unnecessary" words in logs.
> 
>> Intuitively I'd say when checking a csum, the "want" would be what's on
>> disk now, since you want that to be correct, and the "have" would be
>> what you have calculated, but it's actually the other way round, or
>> wasn't it? Or was it?
> For csum, you are right at all.
> 
> In this situation, IIRC bytenr of "have" is read from disk.
> Bytenr of "want" is assigned while constructing eb, from parent ptr
> , root item and other things which are also read from disk.
>>
>> Every time someone pastes such a message when we help on IRC for
>> example, there's confusion, and I have to look up the source again,
>> because I always forget.
> 
> Me too.
>>
>> What about (%llu stored on disk, %llu calculated now) or something similar?

Wha tabout expected got

>>
> "(%llu stored on disk " part sounds good to me. But I don't know how to 
> describe the second part. May the good sleep help me.
> 
> Thanks,
> Su
>>>
>>>> +			     eb->start, found_start);
>>>>  		ret = -EIO;
>>>>  		goto err;
>>>>  	}
>>>> @@ -628,8 +628,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>>>  	}
>>>>  	found_level = btrfs_header_level(eb);
>>>>  	if (found_level >= BTRFS_MAX_LEVEL) {
>>>> -		btrfs_err(fs_info, "bad tree block level %d",
>>>> -			  (int)btrfs_header_level(eb));
>>>> +		btrfs_err(fs_info, "bad tree block level %d on %llu",
>>>> +			  (int)btrfs_header_level(eb), eb->start);
>>>>  		ret = -EIO;
>>>>  		goto err;
>>>>  	}
>>>>
>>
>> -- 
>> Hans van Kranenburg
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
