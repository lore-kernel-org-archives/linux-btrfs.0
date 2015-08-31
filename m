Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49964 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbbHaGvQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 02:51:16 -0400
Subject: Re: [PATCH] btrfs: Remove unneeded cast to s64 for qgroup rfer state
To: Alexandru Moise <00moses.alexander00@gmail.com>
References: <20150829114553.GA7522@gmail.com>
 <55E3B191.7030800@cn.fujitsu.com> <20150831063252.GA3537@gmail.com>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55E3F95C.8020909@cn.fujitsu.com>
Date: Mon, 31 Aug 2015 14:51:08 +0800
MIME-Version: 1.0
In-Reply-To: <20150831063252.GA3537@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Alexandru Moise wrote on 2015/08/31 09:32 +0300:
> On Mon, Aug 31, 2015 at 09:44:49AM +0800, Qu Wenruo wrote:
>>>>     >From the perspective of users, qgroup's referenced or exclusive
>>>>     is negative,but user can not continue to write data! a workaround
>>>>     way is to cast u64 to s64 when doing qgroup reservation
>>>
>>> I am unable to reproduce this problem without his modification.
>>> I could be wrong in reverting this, so I'm gonna CC Wang as well so
>>> he is aware of this patch.
>>
>> The cast is a workaround for a quite old qgroup bug, which will
>> cause excl/rfer overflow to minus.
>>
>> The remove of cast rfer/exel now is OK, as qgroup keeps maturing,
>> especially after 4.2-rc1 rfer/exel will keep sane under most case
>> (exception will be qgroup reassign and subvolume deletion, but will
>> not case minus value even under than case).
>
> rfer/exel and reserved are all of type unsigned int, how exactly would
> they overflow to minus?

Due to qgroup bugs of course,
In old implement, btrfs_find_all_roots() will not always find the 
correct roots.

Causing quota to minus more bytes on existing qgroups.

For example qg->rfer is 16K, btrfs_find_all_roots() think the qg 
previously own a 32K extent but not now, and qgroup accounting decides 
to decrease qg->rfer by 32K, now you get -16K, which is a super huge 
number if used as u64.

>
>>
>> But I'm not a fan to remove it now.
>> As qgroup still has a known huge bug for the qg->reserved part, we
>> are aware of it and working on it actively.
>
> Can you tell me more about this known huge bug and how you can
> reproduce it using the present implementation?
>

Check the fstest patch I submitted:
https://patchwork.kernel.org/patch/7023301/

Btrfs qgroup has qgroup reserved space leak problem, and under some 
case, it can also overflow to minus.(I don't have a minus reproducer, 
but it already happened several times in my test environment)

That's what we are fixing now, trying to make it public before 4.3-rc1.

Thanks,
Qu
