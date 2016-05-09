Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29220 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbcEIBgL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 21:36:11 -0400
Subject: Re: [PATCH] btrfs-progs: Restrict e2fsprogs version for new convert
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160415111726.GD28775@twin.jikos.cz> <57143652.20206@cn.fujitsu.com>
 <20160425145532.GA29353@twin.jikos.cz> <20160502123321.GH29353@twin.jikos.cz>
 <0c6be9c0-c2ef-9356-a100-3f457be5648b@cn.fujitsu.com>
 <20160506150302.GF29353@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <27dbb290-3208-0934-bd12-e3edbbfa1575@cn.fujitsu.com>
Date: Mon, 9 May 2016 09:36:07 +0800
MIME-Version: 1.0
In-Reply-To: <20160506150302.GF29353@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/06 17:03 +0200:
> On Tue, May 03, 2016 at 08:59:58AM +0800, Qu Wenruo wrote:
>>
>>
>> David Sterba wrote on 2016/05/02 14:33 +0200:
>>> On Mon, Apr 25, 2016 at 04:55:32PM +0200, David Sterba wrote:
>>>> On Mon, Apr 18, 2016 at 09:20:18AM +0800, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> David Sterba wrote on 2016/04/15 13:17 +0200:
>>>>>> On Thu, Apr 14, 2016 at 02:24:34PM +0800, Qu Wenruo wrote:
>>>>>>> New btrfs-convert is using a lot of new macro in e2fsprogs 1.42.
>>>>>>> Unfortunately the new compatible layer for older e2fsprogs is still
>>>>>>> under development.
>>>>>>
>>>>>> It hasn't been released yet so it's not really a big problem, although
>>>>>> it makes testing on my side a bit harder. The configure-time check
>>>>>> should be 1.41 and until it's fixed we can print a warning.
>>>>>>
>>>>>>
>>>>> Did I missed something?
>>>>>
>>>>> I checkout 1.41.14 and it shows no cluster support in ext2fs.h.
>>>>>
>>>>> Also git describe shows it's v1.41.14-36-g1da5ef7, after the last v1.41
>>>>> version.
>>>>>
>>>>> So I think the check should be 1.42, just as the patch.
>>>>
>>>> The idea is to keep lowest supported version 1.41, because this version
>>>> can be commonly found on enterprise distros. The lack of cluster is
>>>> expected and needs to be dealt with both build- and run-time.
>>>
>>> I've committed the following patch, as it was your idea to add the
>>> version check:
>>
>> I'm fine to 1.41 for now, but I'm afraid that the compatible layer won't
>> be any time soon.
>> So it may still broke 1.41 e2fsprogs.
>
> This means the convert rework has to be postponed until the
> compatibility with 1.41 is implemented, otherwise it would be regression.
>
>
I'll try my best to implement it asap.

As the BIGALLOC ro compat feature is not really ro compat.
That changed how we get used space.
(Even we are only getting used space, it much like space allocation though)

So for 1.41 e2fsprogs, we must implement(copy from dump2fs though) a new 
method for get ext2 used space.

And for 1.41 case, we won't even support any unknown RO compat flags, 
like BIGALLOC.

If that's OK for you, I think it can be done in this week.

Thanks,
Qu


