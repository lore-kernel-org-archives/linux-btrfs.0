Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35714 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbcD0BNE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 21:13:04 -0400
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
To: Josef Bacik <jbacik@fb.com>, Mark Fasheh <mfasheh@suse.de>
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
 <571A697B.6050502@fb.com> <20160422182148.GZ2187@wotan.suse.de>
 <571A6C3F.1010704@fb.com>
 <2ab669a3-33cf-e4a8-f8c6-02962f778cb3@cn.fujitsu.com>
 <a3aa73dd-e426-c3d6-59e4-6fcafe64ca8a@fb.com>
 <0baab689-a487-4a21-691d-dd3bc555a725@cn.fujitsu.com>
 <81c22500-a40f-3dc5-18b0-3f6d800524ff@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <fdmanana@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f65621c3-d43c-9847-e10a-4f485a8d2ad2@cn.fujitsu.com>
Date: Wed, 27 Apr 2016 09:12:55 +0800
MIME-Version: 1.0
In-Reply-To: <81c22500-a40f-3dc5-18b0-3f6d800524ff@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Josef Bacik wrote on 2016/04/26 10:26 -0400:
> On 04/25/2016 08:35 PM, Qu Wenruo wrote:
>>
>>
>> Josef Bacik wrote on 2016/04/25 10:24 -0400:
>>> On 04/24/2016 08:56 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> Josef Bacik wrote on 2016/04/22 14:23 -0400:
>>>>> On 04/22/2016 02:21 PM, Mark Fasheh wrote:
>>>>>> On Fri, Apr 22, 2016 at 02:12:11PM -0400, Josef Bacik
>>>>>> wrote:
>>>>>>> On 04/15/2016 05:08 AM, Qu Wenruo wrote:
>>>>>>>> +    /* +     * Force parent root to be updated, as we
>>>>>>>> recorded it before so its +     * last_trans ==
>>>>>>>> cur_transid. +     * Or it won't be committed again
>>>>>>>> onto disk after later +     * insert_dir_item() +
>>>>>>>> */ +    if (!ret) +        record_root_in_trans(trans,
>>>>>>>> parent, 1); +    return ret; +}
>>>>>>>
>>>>>>> NACK, holy shit we aren't adding a special transaction
>>>>>>> commit only for qgroup snapshots.  Figure out a different
>>>>>>> way.  Thanks,
>>>>>>
>>>>>> Yeah I saw that. To be fair, we run a whole lot of the
>>>>>> transaction stuff multiple times (at least from my reading)
>>>>>> so I'm really unclear on what the performance impact is.
>>>>>>
>>>>>> Do you have any suggestion though? We've been banging our
>>>>>> heads against this for a while now and as slow as this
>>>>>> patch might be, it actually works where nothing else has so
>>>>>> far.
>>>>>
>>>>> I'm less concerned about committing another transaction and
>>>>> more concerned about the fact that it is an special variant
>>>>> of the transaction commit.  If this goes wrong, or at some
>>>>> point in the future we fail to update it along with
>>>>> btrfs_transaction_commit we suddenly are corrupting metadata.
>>>>> If we have to commit a transaction then call
>>>>> btrfs_commit_transaction(), don't open code a stripped down
>>>>> version, here be dragons.  Thanks,
>>>>>
>>>>> Josef
>>>>>
>>>>>
>>>>>
>>>> Yes, I also don't like the dirty hack.
>>>>
>>>> Although the problem is, we have no other good choice.
>>>>
>>>> If we can call commit_transaction() that's the best case, but
>>>> the problem is, in create_pending_snapshots(), we are already
>>>> inside commit_transaction().
>>>>
>>>> Or commit_transaction() can be called inside
>>>> commit_transaction()?
>>>>
>>>
>>> No, figure out a different way.  IIRC I dealt with this with the
>>> no_quota flag for inc_ref/dec_ref since the copy root stuff does
>>> strange things with the reference counts, but all this code is
>>> gone now.  I looked around to see if I could figure out how the
>>> refs are ending up this way but it doesn't make sense to me and
>>> there isn't enough information in your changelog for me to be
>>> able to figure it out. You've created this mess, clean it up
>>> without making it messier.  Thanks,
>>>
>>> Josef
>>>
>>>
>> Unfortunately, your original no_quota flag just hide the bug, and
>> hide it in a bad method.
>>
>> Originally, no_quota flag is used for case like this, to skip quota
>> at snapshot creation, and use quota_inherit() to hack the quota
>> accounting. It seems work, but in fact, if the DIR_ITEM insert need
>> to create a new cousin leaf, then quota is messed up.
>>
>
> No, and this is the problem, you fundamentally didn't understand what
> I wrote, and instead of trying to understand it and fix the bug you
> just threw it all away.  The no_quota stuff was not a hack, it was
> put in place to deal with refs we already knew where accounted for,
> such as when we converted to mixed refs or other such operations.

Even we know it has been accounted, it's still a hack to jump away from
normal accounting routing.

Just like what we do in qgroup_inherit(). We believe snapshot creation
will always make the exclusive to nodesize.
But in fact, we didn't consider the higher qgroup, and qgroup_inherit()
is just messing up that case.


And Yes, I DID threw the old qgroup code away.
As there are too many existing bugs and possible bugs, not only in
qgroup, but also in backref walk.

Backref walk can't handle time_seq really well, that's one of the reason
for btrfs/091.
And new comer must handle the extra no_quota flag, which is more easy to
cause new regression.

>
> There were bugs in my rework, but now the situation is untenable.
> What we now have is something that holds delayed refs in memory for
> the entire transaction, which is a non-starter for anybody who wants
> to use this in production.

Nope, we didn't hold delayed refs in current qgroup codes.

Delayed refs can be flushed to disk at any time just as it is.
We only trace which bytenr will go through qgroup routine, nothing to do 
with delayed refs.

Yes you can have millions of delayed refs, but there won't be millions
of different extents. Or sync_fs() would have been triggered.

> On our gluster machines we get millions of delayed refs per
> transaction, and then there are multiple file systems.  Then you have
> to post-process all of that during the critical section of the
> commit?  So now suddenly I'm walking millions of delayed refs doing
> accounting all at once, that is going to cause commit latencies in
> the seconds which is completely unacceptable.

In fact qgroup code will never account or walk through delayed refs.

Qgroup code will only walk through backrefs in extent tree. (commit tree 
and just before commit tree)
So, millions is already reduced to a much smaller amount.

Then, for old qgroup code, each time a inc/dec_extent_ref() will walk
through all backref.

So in special case like in-band dedupe, thousands of inc_extent_ref()
will cause thousands backref walk through, no matter when you do the
walk through, it will hugely delayed the transaction.

But in new qgroup code, twice for any dirty extent in one trans.
Even in the best case, it is the same with old case.
And much much much much much faster in worst case.


And further more, since qgroup code won't bother with the already 
b**lsh*t delayed-refs, it only needs to care extent tree.
This also avoid the backref bugs in walking delayed_ref.


Although, the root problem is in backref walking.
It's too time consuming, and we need some cache for it.
Or dedupe(in-band or out-of-band or reflink) can easily screw it up with 
fiemap.

Just create a 1G file with all its extents pointing to a single 128K one.
Then fiemap will just hang your system.

>
> Anyway I spent some time this morning reading through the new stuff
> to figure out how it works now and I've got a patch to fix this
> problem that doesn't involve screwing with the transaction commit
> stuff at all. I sent it along separately
>
> Btrfs: fix qgroup accounting when snapshotting
>
> This fixes the basic case that was described originally.  I haven't
> tested it other than that but I'm pretty sure it is correct.
> Thanks,
>
> Josef
>
Unfortunately, it isn't correct and even didn't fix the bug.

I'll comment in that thread.

Thanks,
Qu




