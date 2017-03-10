Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933018AbdCJTNH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Mar 2017 14:13:07 -0500
Subject: Re: [PATCH v3] btrfs: add missing memset while reading compressed
 inline extents
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <1489025563-8071-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <446e5250-2a96-5f46-737f-5c142bfc1471@fb.com>
 <20170310044112.GD21290@hungrycats.org>
 <9fdd7187-191d-3308-3259-d6420a18929e@fb.com>
 <20170310185640.GB31830@hungrycats.org>
CC: <linux-btrfs@vger.kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
From: Chris Mason <clm@fb.com>
Message-ID: <f2be1367-60c1-b761-1d88-0008c0a73446@fb.com>
Date: Fri, 10 Mar 2017 14:12:54 -0500
MIME-Version: 1.0
In-Reply-To: <20170310185640.GB31830@hungrycats.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/10/2017 01:56 PM, Zygo Blaxell wrote:
> On Fri, Mar 10, 2017 at 11:19:24AM -0500, Chris Mason wrote:
>> On 03/09/2017 11:41 PM, Zygo Blaxell wrote:
>>> On Thu, Mar 09, 2017 at 10:39:49AM -0500, Chris Mason wrote:
>>>>
>>>>
>>>> On 03/08/2017 09:12 PM, Zygo Blaxell wrote:
>>>>> This is a story about 4 distinct (and very old) btrfs bugs.
>>>>>
>>>>
>>>> Really great write up.
>>>>
>>>> [ ... ]
>>>>
>>>>>
>>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>>> index 25ac2cf..4d41a31 100644
>>>>> --- a/fs/btrfs/inode.c
>>>>> +++ b/fs/btrfs/inode.c
>>>>> @@ -6805,6 +6805,12 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>>>>> 	max_size = min_t(unsigned long, PAGE_SIZE, max_size);
>>>>> 	ret = btrfs_decompress(compress_type, tmp, page,
>>>>> 			       extent_offset, inline_size, max_size);
>>>>> +	WARN_ON(max_size + pg_offset > PAGE_SIZE);
>>>>
>>>> Can you please drop this WARN_ON and make the math reflect any possible
>>>> pg_offset?  I do agree it shouldn't be happening, but its easy to correct
>>>> for and the WARN is likely to get lost.
>>>
>>> I'm not sure how to do that.  It looks like I'd have to pass pg_offset
>>> through btrfs_decompress to the decompress functions?
>>>
>>> 	ret = btrfs_decompress(compress_type, tmp, page,
>>> 		extent_offset, inline_size, max_size, pg_offset);
>>>
>>> and in the compression functions get pg_offset from the argument list
>>> instead of hardcoding zero.
>>
>> Yeah, it's a good point.  Both zlib and lzo are assuming a zero pg_offset
>> right now, but just like there are wacky corners allowing inline extents
>> followed by more data, there are a few wacky corners allowing inline extents
>> at the end of the file.
>>
>> Lets not mix that change in with this one though.  For now, just get the
>> memset right and we can pass pg_offset down in a later patch.
>
> Are you saying "fix the memset in the patch" (and if so, what's wrong
> with it?), or are you saying "let's take the patch with its memset as is,
> and fix the pg_offset > 0 issues later"?

Your WARN_ON() would fire when this math is bad:

memset(map + pg_offset + max_size, 0, PAGE_SIZE - max_size - pg_offset);

Instead or warning, just don't memset if pg_offset + max_size >= PAGE_SIZE

-chris
