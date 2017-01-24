Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12141 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750873AbdAXAkz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 19:40:55 -0500
Subject: Re: [PATCH v3 2/6] btrfs-progs: utils: Introduce basic set operations
 for range
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
 <20161219065642.25078-3-quwenruo@cn.fujitsu.com>
 <20170123172835.GO11951@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0f627fae-095d-b172-8560-2f5b18fa1832@cn.fujitsu.com>
Date: Tue, 24 Jan 2017 08:40:47 +0800
MIME-Version: 1.0
In-Reply-To: <20170123172835.GO11951@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/24/2017 01:28 AM, David Sterba wrote:
> On Mon, Dec 19, 2016 at 02:56:38PM +0800, Qu Wenruo wrote:
>> Introduce basic set operations: is_subset() and is_intersection().
>>
>> This is quite useful to check if a range [start, start + len) subset or
>> intersection of another range.
>> So we don't need to use open code to do it, which I sometimes do it
>> wrong.
>>
>> Also use these new facilities in btrfs-convert, to check if a range is a
>> subset or intersects with btrfs convert reserved ranges.
>
> I see the range helpers used only inside convert so I don't think we
> need to export them into utils. Then you could introduce a helper
> structure with start and len members and use that instead of 2 arrays

Right, I could move it convert.

>
>> --- a/disk-io.h
>> +++ b/disk-io.h
>> @@ -97,11 +97,16 @@ enum btrfs_read_sb_flags {
>>  	SBREAD_PARTIAL		= (1 << 1),
>>  };
>>
>> +/*
>> + * Use macro to define mirror super block position
>> + * So we can use it in static array initializtion
>> + */
>> +#define BTRFS_SB_MIRROR_OFFSET(mirror)	((u64)(16 * 1024) << \
>> +					 (BTRFS_SUPER_MIRROR_SHIFT * (mirror)))
>
> This is unrelated change and should go separately.

OK, I can send out a patch first.

Thanks for reviewing,
Qu

>
>>  static inline u64 btrfs_sb_offset(int mirror)
>>  {
>> -	u64 start = 16 * 1024;
>>  	if (mirror)
>> -		return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
>> +		return BTRFS_SB_MIRROR_OFFSET(mirror);
>>  	return BTRFS_SUPER_INFO_OFFSET;
>>  }
>>
>
>


