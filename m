Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48220 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932868AbbKFBCS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 20:02:18 -0500
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
To: Mark Fasheh <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag> <5636BDA0.4020200@cn.fujitsu.com>
 <20151103192625.GE15575@wotan.suse.de> <563958F0.6030904@cn.fujitsu.com>
 <20151105192346.GI15575@wotan.suse.de>
CC: Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <jbacik@fb.com>, Chris Mason <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <563BFC15.4070705@cn.fujitsu.com>
Date: Fri, 6 Nov 2015 09:02:13 +0800
MIME-Version: 1.0
In-Reply-To: <20151105192346.GI15575@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2015/11/05 11:23 -0800:
> On Wed, Nov 04, 2015 at 09:01:36AM +0800, Qu Wenruo wrote:
>>
>>
>> Mark Fasheh wrote on 2015/11/03 11:26 -0800:
>>> On Mon, Nov 02, 2015 at 09:34:24AM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> Stefan Priebe wrote on 2015/11/01 21:49 +0100:
>>>>> Hi,
>>>>>
>>>>> this one: http://www.spinics.net/lists/linux-btrfs/msg47377.html
>>>>>
>>>>> adds a regression to my test systems with very large disks (30tb and 50tb).
>>>>>
>>>>> btrfs balance is super slow afterwards while heavily making use of cp
>>>>> --reflink=always on big files (200gb - 500gb).
>>>>>
>>>>> Sorry didn't know how to correctly reply to that "old" message.
>>>>>
>>>>> Greets,
>>>>> Stefan
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>> Thanks for the testing.
>>>>
>>>> Are you using qgroup or just doing normal balance with qgroup disabled?
>>>>
>>>> For the latter case, that's should be optimized to skip the dirty
>>>> extent insert in qgroup disabled case.
>>>>
>>>> For qgroup enabled case, I'm afraid that's the design.
>>>> As relocation will drop a subtree to relocate, and to ensure qgroup
>>>> consistent, we must walk down all the tree blocks and mark them
>>>> dirty for later qgroup accounting.
>>>
>>> Qu, we're always going to have to walk the tree when deleting it, this is
>>> part of removing a subvolume. We've walked shared subtrees in this code for
>>> numerous kernel releases without incident before it was removed in 4.2.
>>>
>>> Do you have any actual evidence that this is a major performance regression?
>>>  From our previous conversations you seemed convinced of this, without even
>>> having a working subtree walk to test. I remember the hand wringing
>>> about an individual commit being too heavy with the qgroup code (even though
>>> I pointed out that tree walk is a restartable transaction).
>>>
>>> It seems that you are confused still about how we handle removing a volume
>>> wrt qgroups.
>>>
>>> If you have questions or concerns I would be happy to explain them but
>>> IMHO your statements there are opinion and not based in fact.
>>
>> Yes, I don't deny it.
>> But it's quite hard to prove it, as we need such a huge storage like Stefan.
>> What I have is only several hundred GB test storage.
>> Even accounting all my home NAS, I only have 2T, far from the
>> storage Stefan has.
>>
>> And what Stefan report should already give some hint about the
>> performance issue.
>>
>> In your word "it won't be doing anything (ok some kmalloc/free of a
>> very tiny object)", it's already slowing down balance, since balance
>> also use btrfs_drop_subtree().
>
> When I wrote that I was under the impression that the qgroup code was doing
> it's own sanity checking (it used to) and since Stephan had them disabled
> they couldn't be causing the problem. I read your e-mail explaining that the
> qgroup api was now intertwined with delayed ref locking after this one.

My fault, as btrfs_qgroup_mark_exntent_dirty() is an exception which 
doesn't have the qgroup status check and depend on existing locks.

>
> The same exact code ran in either case before and after your patches, so my
> guess is that the issue is actually inside the qgroup code that shouldn't
> have been run. I wonder if we even just filled up his memory but never
> cleaned the objects. The only other thing I can think of is if
> account_leaf_items() got run in a really tight loop for some reason.
>
> Kmalloc in the way we are using it is not usually a performance issue,
> especially if we've been reading off disk in the same process. Ask yourself
> this - your own patch series does the same kmalloc for every qgroup
> operation. Did you notice a complete and massive performance slowdown like
> the one Stefan reported?

You're right, such memory allocation may impact performance but not so 
noticeable, compared to other operations which may kick disk IO, like 
btrfs_find_all_roots().

But at least, enabling qgroup will impact performance.

Yeah, this time I has test data now.
In a environment with 100 different snapshot, sysbench shows an overall 
performance drop about 5%, and in some case, up to 7%, with qgroup enabled.

Not sure about the kmalloc impact, maybe less than 1% or maybe 2~3%, but 
at least it's worthy trying to use kmem cache.

>
> I will say that we never had this problem reported before, and
> account_leaf_items() is always run in all kernels, even without qgroups
> enabled. That will change with my new patch though.
>
> What we can say for sure is that drop_snapshot in the qgroup case will read
> more disk and obviously that will have a negative impact depending on what
> the tree looks like. So IMHO we ought to be focusing on reducing the amount
> of I/O involved.

Totally agree.

Thanks,
Qu

>
>
>> But we can't just ignore such "possible" performance issue just
>> because old code did the same thing.(Although not the same now,
>> we're marking all subtree blocks dirty other than shared one).
>
> Well, I can't disagree with that - the only reason we are talking right now
> is because you intentionally ignored the qgroup code in drop_snapshot(). So
> let's start with this - no more 'fixing' code by tearing it out and replacing
> it with /* TODO: somebody else re-implement this */   ;)
> 	--Mark
>
> --
> Mark Fasheh
>
