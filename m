Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50812 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914AbbD1A6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 20:58:00 -0400
Message-ID: <553EDB0B.3000100@cn.fujitsu.com>
Date: Tue, 28 Apr 2015 08:57:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] btrfs: Fix superblock csum type check.
References: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com> <20150424150507.GQ4996@twin.jikos.cz> <553D8216.8090503@cn.fujitsu.com> <20150427105929.GT4996@suse.cz>
In-Reply-To: <20150427105929.GT4996@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH v2 1/2] btrfs: Fix superblock csum type check.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月27日 18:59

> On Mon, Apr 27, 2015 at 08:25:58AM +0800, Qu Wenruo wrote:
>>
>>
>> -------- Original Message  --------
>> Subject: Re: [PATCH v2 1/2] btrfs: Fix superblock csum type check.
>> From: David Sterba <dsterba@suse.cz>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date: 2015年04月24日 23:05
>>
>>> On Fri, Apr 24, 2015 at 09:12:40AM +0800, Qu Wenruo wrote:
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
>>>> @@ -173,6 +173,7 @@ struct btrfs_ordered_sum;
>>>>
>>>>    /* csum types */
>>>>    #define BTRFS_CSUM_TYPE_CRC32	0
>>>> +#define BTRFS_CSUM_LAST_TYPE	0
>>>>
>>>>    static int btrfs_csum_sizes[] = { 4, 0 };
>>>
>>> I'd prefer to fix it by removing the 0 from btrfs_csum_sizes instead of
>>> introducing a define.
>>>
>>
>> Removing the zero seems not help for this case, as some one can still
>> craft a strange csum_type to access outside the array.
>
> The ARRAY_SIZE will be 1, so if a crafted csum will be anything than 0,
> then the check will catch it, no?
Oh, I forgot there is ARRAY_SIZE check.
Now deleting the 0 in array is definitely the cleanest fix.

Thanks,
Qu
>
>> So I introduce the new macro and use the new macro to compare with
>> csum_type without acess the array.
>
> The macro serves the same purpose as the ARRAY_SIZE macro and is always
> in sync with the btrfs_csum_size.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
