Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756589AbdEUMpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 08:45:06 -0400
Subject: Re: btrfs metadata reclaim behavior/performance characteristics
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jeffm@suse.com
References: <dc9f3787-767b-6710-9694-9eb02aa07728@suse.com>
 <20170518144532.GA28854@lim.localdomain>
 <a9c76afa-a18a-36e2-b3e8-a66bce9a0c3f@suse.com>
 <20170518214724.GA10554@lim.localdomain>
 <7a698730-6f67-b158-c172-0a74a291277f@suse.com>
 <20170519183214.GB10137@lim.localdomain>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <93c1a20e-bb0b-13f0-b601-069ea02c3898@suse.com>
Date: Sun, 21 May 2017 15:45:02 +0300
MIME-Version: 1.0
In-Reply-To: <20170519183214.GB10137@lim.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.05.2017 21:32, Liu Bo wrote:
> On Fri, May 19, 2017 at 12:54:59PM +0300, Nikolay Borisov wrote:
>>> From: Liu Bo <bo.li.liu@oracle.com>
>>>
>>> Subject: [PATCH] Btrfs: skip commit transaction if we don't have enough pinned bytes
>>>
>>> We commit transaction in order to reclaim space from pinned bytes because it could process delayed refs, and in may_commit_transaction(), we check first if pinned bytes are enough for the required space, we then check if that plus bytes reserved for delayed insert are enough for the required space.
>>>
>>> This changes the code to the above logic.
>>>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>> ---
>>>  fs/btrfs/extent-tree.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index e390451c72e6..bded1ddd1bb6 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>>>  
>>> 	spin_lock(&delayed_rsv->lock);
>>>  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
>>> -			   bytes - delayed_rsv->size) >= 0) {
>>> +			   	   		         bytes - delayed_rsv->size) < 0) {
>>>  							       spin_unlock(&delayed_rsv->lock);
>>> 								return -ENOSPC;
>>>  								}
>>>
>>
>> Your patch does make a very big difference. Here are a couple of runs of
>> slow-rm:
>>
>>
>>
>> root@ubuntu-virtual:~# ./slow-rm.sh
>> Created 837 files before returning error, time taken 3
>> Created 920 files before returning error, time taken 3
>> Created 949 files before returning error, time taken 3
>> Created 930 files before returning error, time taken 3
>> Created 1101 files before returning error, time taken 4
>> Created 1082 files before returning error, time taken 4
>> Created 1608 files before returning error, time taken 5
>> Created 1735 files before returning error, time taken 5
>> rming took 1 seconds
>>
>> root@ubuntu-virtual:~# ./slow-rm.sh
>> Created 801 files before returning error, time taken 3
>> Created 829 files before returning error, time taken 3
>> Created 983 files before returning error, time taken 3
>> Created 978 files before returning error, time taken 3
>> Created 1023 files before returning error, time taken 3
>> Created 1126 files before returning error, time taken 3
>> Created 1538 files before returning error, time taken 4
>> Created 1737 files before returning error, time taken 5
>> rming took 2 seconds
>>
>> root@ubuntu-virtual:~# ./slow-rm.sh
>> Created 875 files before returning error, time taken 3
>> Created 891 files before returning error, time taken 3
>> Created 969 files before returning error, time taken 4
>> Created 1002 files before returning error, time taken 4
>> Created 1039 files before returning error, time taken 4
>> Created 1051 files before returning error, time taken 4
>> Created 1191 files before returning error, time taken 4
>> Created 2137 files before returning error, time taken 8
>> rming took 2 seconds
>>
>> So rming is a lot faster, but we create less files all in all and get
>> ENOSPC earlier. This means that most of the time bytes_pinned is not
>> enough to satisfy the allocation hence we are hitting the second
>> percpu_counter comparison.
>>
> 
> Right, it's sort of my expected bahavior because all 1K buffered IO ends up
> being inline extent, it's likely to run out of metadata space very soon.

Are you going to send this as an official patch to the ML ?

> 
>> Also, the reason why the previous links showed 0 for bytes_pinned was
>> due to me having completely forgotten that bytes_pinned is a percpu
>> counter, hence my stap script wasn't actually reading it correctly.
> 
> I see, bytes_pinned in space_info is different from the percpu one, they're
> updated at different time, but overall the percpu one is the the preciser
> counter.
> 
> -liubo
> 
