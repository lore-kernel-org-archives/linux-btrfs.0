Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10411 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751428AbbHUAaL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 20:30:11 -0400
Subject: Re: Major qgroup regression in 4.2?
To: Mark Fasheh <mfasheh@suse.de>
References: <20150813231307.GA1145@wotan.suse.de>
 <20150814211448.GB1145@wotan.suse.de> <55D13A02.2050400@cn.fujitsu.com>
 <20150817211332.GC1145@wotan.suse.de> <55D28DA1.4090504@cn.fujitsu.com>
 <55D2E6BE.4060208@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, <clm@fb.com>, <jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D6710E.5060006@cn.fujitsu.com>
Date: Fri, 21 Aug 2015 08:30:06 +0800
MIME-Version: 1.0
In-Reply-To: <55D2E6BE.4060208@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

Any further comment on the reason why we should mark all nodes/leaves 
dirty during a subvolume deletion?

Thanks,
Qu

Qu Wenruo wrote on 2015/08/18 16:03 +0800:
>
>
> Qu Wenruo wrote on 2015/08/18 09:42 +0800:
>>
>>
>> Mark Fasheh wrote on 2015/08/17 14:13 -0700:
>>> Hi Qu,
>>>
>>> Firstly thanks for the response. I have a few new questions and comments
>>> below,
>>>
>>> On Mon, Aug 17, 2015 at 09:33:54AM +0800, Qu Wenruo wrote:
>>>> Thanks for pointing out the problem.
>>>> But it's already known and we didn't have a good idea to solve it yet.
>>>>
>>>> BTW, the old framework won't handle it well either.
>>>> Liu Bo's testcase (btrfs/017) can easily trigger it.
>>>> So it's not a regression.
>>>
>>> I don't understand your meaning here. btrfs/017 doesn't have anything
>>> to do
>>> with subvolume deletion. The regression I am talking about is that
>>> deleting
>>> a subvolume in btrfs on 4.2 breaks qgroup numbers, whereas it did not in
>>> 4.1. Btw, I do acknowledge that 017 *was* broken before and fixed by
>>> your
>>> patches (thanks) but that's of course been at the expense of
>>> reintroducing
>>> the subvol regression :(
>> Oh, it seems that my memory went wrong about the test case.
>>
>> But I did remember old implement has something wrong with subvolume
>> deletion too.
>> (Or maybe I'm wrong again?)
>>>
>>>
>>>> Let me explain the problem a little and then introduce the fixing plan.
>>>>
>>>> [Qgroup for subvolume delete]
>>>> Here are two subvolumes, sharing the whole tree.
>>>> The whole trees are consistent with 8 tree blocks.
>>>> A B are the tree root of subv 257 and 258 respectively.
>>>> C~H are all shared by the two subvolumes.
>>>> And I is one data extent which is recorded in tree block H.
>>>>
>>>>
>>>> subv 257(A)    subv258(B)
>>>>     |     \       /    |
>>>>     C                  D
>>>>    / \                / \
>>>>    E F                G H
>>>>                         :
>>>>                         :
>>>>                         I
>>>>
>>>> Let's assume the tree block are all in 4K size(just for easy
>>>> calculation), and I is in 16K size.
>>>>
>>>> Now qgroup info should be:
>>>> 257: excl: 4K, rfer: 44K (6 shared tree block + 1 data + 1 tree root)
>>>> 258: excl: 4K, rfer: 44K
>>>>
>>>> If we are going to delete subvolume 258, then expected qgroup should
>>>> be:
>>>> 257: excl 44K, rfer 44K
>>>
>>> Ok, this is basically explaining how we expect the numbers from a
>>> subvolume
>>> delete to work out. Everything there looks normal to me.
>>>
>>>
>>>> Which means we need to recalculate all the reference relation of
>>>> tree block C~H and data extent I.
>>>>
>>>> [[The real problem]]
>>>> Now the real problem is, we need to mark *ALL* metadata and data
>>>> extent of a subvolume dirty to make subvolume deletion work.
>>>
>>> I don't understand why we have to mark all nodes of a subvol. The
>>> previous
>>> implementation was able to get this correct without recalculating every
>>> block in the tree. It only passed shared nodes and items through to the
>>> qgroup accounting code. The accounting code in turn had very simple
>>> logic
>>> for working it out - if the extent is now exclusively owned, we adjust
>>> qgroup->excl for the (now only remaing) owner.
>> Oh, you're right here.
>> I'm stupid on this, as exclusive extent doesn't matter in the case.
>>
>> So no need to iterate the whole tree, but only shared extents.
>> That's already a lot of extent we can skip.
> Oh, I forgot one case involved with higher level qgroup.
>             qg 1/0
>             /    \
>   subv 257(A)    subv258(B)
>       |     \ /----    |
>       C      D         J
>      / \    / \ /------\
>      E F    G H         L
>               :
>               :
>               I
>
> The picture is hard to see BTW...
> Explain a little.
> qgroup 257 and qgroup 258 are in the same higher level qgroup pool, 1/0
> And this time, suvol 257 and subvol 258 only shares part of there tree.
>          A (subvol 257)
>           /     \
>      C    D
>         / \     / \
>        E   F   G   H ..... I
>
>          B (subvol 258)
>           /     \
>          C       J
>         / \     / \
>        E   F   G   L
> Yes, one COW caused A->D->H route to be new B->J->L route in subvol 258.
>
> And lets take a look at the qgroup numbers:
> Still use 4K tree block and I is 16K.
> qg 257: excl: 28K rfer: 44K
> meta excl: A, D, H: 3 * 4 = 12K
> data excl: I = 16K
> meta rfer: all 7 tree blocks = 28K
> data rfer: I = 16K
>
> qg 258: excl: 12K rfer: 28K
> meta excl: B, J, L: 3 * 4K = 12K
> data excl: 0
> meta rfer: all 7 tree blocks = 28K
> data rfer: 0
>
> qg: 1/0: excl 56K rfer: 56K
> meta excl: A ~ H, J~L, 10 * 4K = 40K
> data excl: I = 16K
>
> Now, if only accounts shared nodes, which means only accounts
> C, E, F, G tree blocks.
> These 4 tree blocks will turn from shared to excl for subvol 257.
> That's OK, as it won't cause anything wrong in qg 257.
>
> But that will cause qg 1/0 wrong.
> And B, J, L is now owned by nobody, excl of qg 1/0 should be reduced by
> 12K.
> As they are not marked as dirty since they are not shared,
> so the result will be:
>
> qg 257: excl: 28 + 16 = 44K  rfer: 44K
> qg 1/0: excl: 56K rfer: 56K
> As related 4 tree blocks are still exel for qg 1/0.
> Their change won't cause excl/rfer change.
>
> So the result of qg 1/0 is wrong. Which should be excl: 44K: rfer 44K,
> just the same as qg 257.
>
> So, it is still needed to account all the nodes/leaves to ensure higher
> level qgroup get correct reading.
>
>
> Sorry for not pointing this out in previous reply, as qgroup is quite
> complicated and I did forgot this case.
>
> So, I'm afraid we need to change the fix to mark all extents in the
> subvolume to resolve the bug.
>
> Thanks,
> Qu
>
>>
>>>
>>> If you go back to qgroup_subtree_accounting() it, you would see
>>> *that it never* changes ->rfer on a qgroup. That is because the rfer
>>> counts
>>> on any related subvolumes don't change during subvol delete. Your
>>> example above in
>>> fact illustrates this.
>>>
>>> So to be clear,
>>>
>>> - Why do we have to visit all tree nodes with the qgroup code given that
>>> we only cared about shared ones before"
>>
>> My fault, as I didn't jump out of the box and still using the idea of
>> rescan whole tree to do it.
>>
>>>
>>>
>>>> Forgot to say, that's at transaction commit time, if we really do that,
>>>> commit time consumption is not acceptable if the subvolume is huge.
>>>
>>> This too is confusing to me. Even if we assume that qgroups will get
>>> every
>>> node now instead of just the shared ones:
>>>
>>> - Drop subvol already visits every node (though it doesn't pass them
>>> all to
>>> the qgroup code). We were doing this before just fine to my knowledge
>>> - what
>>> changed? The commit-time qgroup accounting?
>>
>> Nothing, as even old implement does qgroup accounting at
>> run_delayed_refs time, which is also done at commit_transaction.
>>
>> So that's just my meaningless worry.
>>
>>>
>>> - Also, btrfs_drop_snapshot() throttles transaction commits (via
>>> btrfs_end_transaction_throttle()), so anything done at commit time looks
>>> like it would be broken up into smaller chunks of work for us.
>>>
>>> Am I mistaken in how I understand these functions?
>>
>> No, you're right.
>> Overall my concern about commit-time qgroup accouting performance impact
>> is meaningless now.
>>
>>>
>>>
>>> Also I must ask... How did you discover this performance issue? Are we
>>> talking about something theoretical here or was your implementation
>>> slow on
>>> subvolume delete?
>> Mainly theoretical.
>> And theoretically, the new implement should be faster than old implement.
>>
>> But I'm not quite sure about the old implement is fast enough for
>> subvolume deletion.
>> Anyway, your fix seems no slower than old implement.
>> So I'm completely OK with it now.
>>
>>>
>>>
>>>> [[Possible fix plan]]
>>>> As you can see the biggest problem is the number of child
>>>> metadata/data extents can be quite large, it's not possible to mark
>>>> them all and account at commit transaction time.
>>>
>>> ... right so handling qgroups at commit time is performance sensitive in
>>> that too many qgroup updates will cause the commit code to do a lot of
>>> work.
>>> I think that actually answers one of my questions above, though my
>>> followup would be:
>>>
>>> Would I be correct if I said this is a problem for any workload that
>>> creates
>>> a large number of qgroup updates in a short period of time?
>> I'm afraid that's true.
>>
>> The typical one should be file clone.
>> And that may be one of the worst case.
>>
>> As file clone will increase data extent backref, even inside the same
>> subvolume, it will cause qgroup accounting.
>>
>> And it won't cause transaction to be committed, so in one transaction it
>> can do file clone a lot of times.
>> If all clone are happen on one extent, that's OK as qgroup only need to
>> do one accounting.
>> (BTW, only implement will do a lot of accounting even cloning the same
>> extent)
>>
>> But if someone is doing file clone on different extents, that will be a
>> disaster.
>>
>> Unlike other normal write, file clone won't cause much dirty page, so
>> transaction won't be triggered by dirty page threshold.
>>
>> So after a lot of file cloning on different extents, next transaction
>> commit will cost a lot of time.
>>
>> But that's my theoretical assumption, it may be totally wrong just like
>> what I thought about subvolume deletion.
>>
>>>
>>>
>>>> But the good news is, we can keep the snapshot and account them in
>>>> several commits.
>>>> The new extent-orient accounting is quite accurate as it happens at
>>>> commit time.
>>>
>>> Btw, one thing I should say is that in general I really like your
>>> rewrite
>>> grats on that - the code is far easier to read through and I like very
>>> much
>>> that we've taken some of the open-coded qgroup code out of our extent
>>> inc/dec code.
>>
>> It's my pleasure. :)
>>
>>>
>>>
>>>> So one possible fix is, if we want to delete a subvolume, we put the
>>>> subvolume into an orphan status, and let qgroup account to ignore
>>>> that qgroup from then on, and mark some extent dirty in one
>>>> transaction, and continue marking in next transaction until we mark
>>>> all extents in that subvolume dirty.
>>>> Then free the subvolume.
>>>>
>>>> That's the ideal method for both snapshot creation and deletion, but
>>>> takes the most time.
>>>
>>> It also sounds like a disk format change which would really suck to tell
>>> users to do just so they can get accurate qgroup numbers.
>>
>> With all your explain, I think your current fix is good enough, at least
>> no worse than old implement.
>>
>> So I'm OK with it.
>> As it fixes a regression without major performance drop.
>>
>> We can improve performance later if it's really needed.
>>
>>>
>>>
>>>> [Hot fix idea]
>>>> So far, the best and easiest method I come up with is, if we found
>>>> qgroup is enabled and the snapshot to delete is above level 1(level
>>>> starts from 0), then mark the QGROUP_INCONSISTENT flag to info user
>>>> to do a rescan.
>>>
>>> This is exactly the kind of band-aid solution we wanted to avoid the
>>> first
>>> time qgroups and subvolume handling were fixed.
>>>     --Mark
>> With your fix, the quick and dirty one is not needed anyway.
>>
>> Good job.
>>
>> Thanks,
>> Qu
>>>
>>> --
>>> Mark Fasheh
>>>
