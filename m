Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36822 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753484AbcDAIuS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 04:50:18 -0400
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz> <56FDC0A2.1030909@cn.fujitsu.com>
 <20160401084418.GI6230@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FE363E.5090202@cn.fujitsu.com>
Date: Fri, 1 Apr 2016 16:50:06 +0800
MIME-Version: 1.0
In-Reply-To: <20160401084418.GI6230@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/04/01 10:44 +0200:
> On Fri, Apr 01, 2016 at 08:28:18AM +0800, Qu Wenruo wrote:
>>
>>
>> David Sterba wrote on 2016/03/31 18:30 +0200:
>>> On Thu, Mar 31, 2016 at 10:19:34AM +0800, Qu Wenruo wrote:
>>>> At least 2 user from mail list reported btrfsck reported false alert of
>>>> "bad metadata [XXXX,YYYY) crossing stripe boundary".
>>>>
>>>> While the reported number are all inside the same 64K boundary.
>>>> After some check, all the false alert have the same bytenr feature,
>>>> which can be divided by stripe size (64K).
>>>>
>>>> The result seems to be initial 'max_size' can be 0, causing 'start' +
>>>> 'max_size' - 1, to cross the stripe boundary.
>>>>
>>>> Fix it by always update extent_record->cross_stripe when the
>>>> extent_record is updated, to avoid temporary false alert to be reported.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>
>>> Applied, thanks.
>>>
>>> Do you have a test image for that?
>>>
>>>
>> Unfortunately, no.
>>
>> Although I figured out the cause the the false alert, I still didn't
>> find a image/method to reproduce it, except the images of reporters.
>>
>> I can dig a little further trying to make a image.
>
> After another look, why don't we use nodesize directly? Or stripesize
> where applies. With max_size == 0 the test does not make sense, we ought
> to know the alignment.
>
>
Yes, my first though is also to use nodesize directly, which should be 
always correct.

But the problem is, the related function call stack doesn't have any 
member to reach btrfs_root or btrfs_fs_info.

In the very beginning version of such crossing stripe check, I used to 
add a btrfs_root/btrfs_fs_info parameter to the function.

But the code change are too many, so I use 'max_size'.

I can try to re-do such modification, but IIRC it didn't cause a good 
result.

Thanks,
Qu


