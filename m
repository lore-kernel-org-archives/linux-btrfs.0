Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:35336 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab2JZHCH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 03:02:07 -0400
Message-ID: <508A3562.9040006@oracle.com>
Date: Fri, 26 Oct 2012 15:01:54 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] flush delalloc by multi-task
References: <5089045D.8050801@cn.fujitsu.com> <50892821.5010808@oracle.com> <5089EDB7.8030306@cn.fujitsu.com> <5089F003.8080400@oracle.com> <508A02BF.10502@cn.fujitsu.com>
In-Reply-To: <508A02BF.10502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2012 11:25 AM, Miao Xie wrote:
> On Fri, 26 Oct 2012 10:05:55 +0800, Liu Bo wrote:
>> On 10/26/2012 09:56 AM, Miao Xie wrote:
>>>> I can see the potential improvements brought by flushing inodes this way.
>>>>>
>>>>> But I don't think it makes much sense by making waiting process multi-task,
>>>>> since even we spread wait order extents into different cpus, they just occpied
>>>>> the cpu and went on waiting and scheduled then, I mean, the bottleneck is on
>>>>> what we're waiting for.
>>> Thanks for your comment, I think only btrfs_run_ordered_operations(root, 0) needn't
>>> wait for the works, the others must wait.
>>>
>>> The first reason is to avoid changing the semantic of those tree function. The second
>>> reason is we have to wait for the completion of all works, if not, the file data in
>>> snapshots may be different with the source suvolumes because the flush may not end
>>> before the snapshot creation.
>>>
>>
>> Yes, it's right that they must wait for all workers to finish.
>>
>> But I don't mean that(sorry for my confusing words).
>>
>> IMO we don't need to let *btrfs_wait_ordered_extents()* run as multi-task.
> 
> It also need to be done by multi-task because btrfs_wait_ordered_extents() doesn't imply
> that all the dirty pages in the ordered extent have been written into the disk, that is
> it also need do lots of things before waiting for the event - BTRFS_ORDERED_COMPLETE, so
> the multi-task process is useful, I think.
> 

Well, I missed the flushing part.

> Anyway, we need test to validate it.
> 
> Thanks
> Miao
> 
>>
>> thanks,
>> liubo
>>
>>
>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

