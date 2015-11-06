Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52491 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031823AbbKFDZL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 22:25:11 -0500
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
To: Mark Fasheh <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag> <5636BDA0.4020200@cn.fujitsu.com>
 <20151103192625.GE15575@wotan.suse.de> <563958F0.6030904@cn.fujitsu.com>
 <20151105192346.GI15575@wotan.suse.de> <563BFC15.4070705@cn.fujitsu.com>
 <20151106031526.GJ15575@wotan.suse.de>
CC: Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <jbacik@fb.com>, Chris Mason <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <563C1D91.2000105@cn.fujitsu.com>
Date: Fri, 6 Nov 2015 11:25:05 +0800
MIME-Version: 1.0
In-Reply-To: <20151106031526.GJ15575@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2015/11/05 19:15 -0800:
> On Fri, Nov 06, 2015 at 09:02:13AM +0800, Qu Wenruo wrote:
>>> The same exact code ran in either case before and after your patches, so my
>>> guess is that the issue is actually inside the qgroup code that shouldn't
>>> have been run. I wonder if we even just filled up his memory but never
>>> cleaned the objects. The only other thing I can think of is if
>>> account_leaf_items() got run in a really tight loop for some reason.
>>>
>>> Kmalloc in the way we are using it is not usually a performance issue,
>>> especially if we've been reading off disk in the same process. Ask yourself
>>> this - your own patch series does the same kmalloc for every qgroup
>>> operation. Did you notice a complete and massive performance slowdown like
>>> the one Stefan reported?
>>
>> You're right, such memory allocation may impact performance but not
>> so noticeable, compared to other operations which may kick disk IO,
>> like btrfs_find_all_roots().
>>
>> But at least, enabling qgroup will impact performance.
>>
>> Yeah, this time I has test data now.
>> In a environment with 100 different snapshot, sysbench shows an
>> overall performance drop about 5%, and in some case, up to 7%, with
>> qgroup enabled.
>>
>> Not sure about the kmalloc impact, maybe less than 1% or maybe 2~3%,
>> but at least it's worthy trying to use kmem cache.
>
> Ok cool, what'd you do to generate the snapshots? I can try a similar test
> on one of my machines and see what I get. I'm not surprised that the
> overhead is noticable, and I agree it's easy enough to try things like
> replacing the allocation once we have a test going.
>
> Thanks,
> 	--Mark

Doing fsstress in a subvolume with 4 threads, creating a snapshot of 
that subvolume about every 5 seconds.

And do sysbench inside the 50th snapshot.

Such test takes both overhead of btrfs_find_all_roots() and kmalloc().
So I'm not sure which overhead is bigger.

Thanks,
Qu
>
> --
> Mark Fasheh
>
