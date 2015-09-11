Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55179 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416AbbIKAn0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 20:43:26 -0400
Subject: Re: [PATCH RFC 00/14] Accurate qgroup reserve framework
To: Mark Fasheh <mfasheh@suse.de>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150910210104.GS1145@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F223AB.1080400@cn.fujitsu.com>
Date: Fri, 11 Sep 2015 08:43:23 +0800
MIME-Version: 1.0
In-Reply-To: <20150910210104.GS1145@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2015/09/10 14:01 -0700:
> Hi Qu,
>
> On Tue, Sep 08, 2015 at 04:56:52PM +0800, Qu Wenruo wrote:
>> [[BUG]]
>> One of the most common case to trigger the bug is the following method:
>> 1) Enable quota
>> 2) Limit excl of qgroup 5 to 16M
>> 3) Write [0,2M) of a file inside subvol 5 10 times without sync
>>
>> EQUOT will be triggered at about the 8th write.
>
> Does this happen on all kernels with qgroups or is this related to your
> recent rewrite?
All kernels.

My recent rewrite only affects the accounting part (the excl/rfer 
numbers), reserve part is somewhat independent from accounting part.

But I have to admit that, in fact my rewrite introduced some 
incompatibility with old reserve codes.

One of the most obvious one is the hot fix introduced in late 4.2-rc.
And still some hidden one. For example, old reserved space will be freed 
at end_trans() time.

But with new accounting rewrite, we shouldn't do that until 
commit_trans(). As reserved space will be converted into rfer/exel only 
at commit_trans().
If freed too early like old codes, we may have the possibility to exceed 
the limit.

Thankfully, all these will be addressed in the big patchset.
>
>
>> [[CAUSE]]
>> The problem is caused by the fact that qgroup will reserve space even
>> the data space is already reserved.
>>
>> In above reproducer, each time we buffered write [0,2M) qgroup will
>> reserve 2M space, but in fact, at the 1st time, we have already reserved
>> 2M and from then on, we don't need to reserved any data space as we are
>> only writing [0,2M).
>>
>> Also, the reserved space will only be freed *ONCE* when its backref is
>> run at commit_transaction() time.
>>
>> That's causing the reserved space leaking.
>>
>> [[FIX]]
>> The fix is not a simple one, as currently btrfs_qgroup_reserve() follow
>
> Indeed, this is quite a large patch series and I see no testing details from
> you. Can you please at the least provide a single reproducer in the form of
> something that can be added to xfstests?
Like Filipe mentioned, it's already submitted to fstests.

And sorry for not mentioning it in the comment message.

BTW, there will be more test cases coming for qgroup soon, with a lot of 
error exposed in the development of the patchset.
>
>
>> the very bad btrfs space allocating principle:
>>    Allocate as much as you needed, even it's not fully used.
>>
>> So for accurate qgroup reserve, we introduce a completely new framework
>> for data and metadata.
>> 1) Per-inode data reserve map
>>     Now, each inode will have a data reserve map, recording which range
>>     of data is already reserved.
>>     If we are writing a range which is already reserved, we won't need to
>>     reserve space again.
>>
>>     Also, for the fact that qgroup is only accounted at commit_trans(),
>>     for data commit into disc and its metadata is also inserted into
>>     current tree, we should free the data reserved range, but still keep
>>     the reserved space until commit_trans().
>>
>>     So delayed_ref_head will have new members to record how much space is
>>     reserved and free them at commit_trans() time.
>>
>> 2) Per-root metadata reserve counter
>>     For metadata(tree block), it's impossible to know how much space it
>>     will use exactly in advance.
>>     And due to the new qgroup accounting framework, the old
>>     free-at-end-trans may lead to exceeding limit.
>>
>>     So we record how much metadata space is reserved for each root, and
>>     free them at commit_trans() time.
>>     This method is not perfect, but thanks to the compared small size of
>>     metadata, it should be quite good.
>>
>> More detailed info can be found in each commit message and source
>> commend.
>>
>> Qu Wenruo (19):
>>    btrfs: qgroup: New function declaration for new reserve implement
>>    btrfs: qgroup: Implement data_rsv_map init/free functions
>>    btrfs: qgroup: Introduce new function to search most left reserve
>>      range
>>    btrfs: qgroup: Introduce function to insert non-overlap reserve range
>>    btrfs: qgroup: Introduce function to reserve data range per inode
>>    btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function
>>    btrfs: qgroup: Introduce function to release reserved range
>>    btrfs: qgroup: Introduce function to release/free reserved data range
>>    btrfs: delayed_ref: Add new function to record reserved space into
>>      delayed ref
>>    btrfs: delayed_ref: release and free qgroup reserved at proper timing
>>    btrfs: qgroup: Introduce new functions to reserve/free metadata
>>    btrfs: qgroup: Use new metadata reservation.
>>    btrfs: extent-tree: Add new verions of btrfs_check_data_free_space
>>    btrfs: Switch to new check_data_free_space
>>    btrfs: fallocate: Add support to accurate qgroup reserve
>>    btrfs: extent-tree: Add new version of btrfs_delalloc_reserve_space
>>    btrfs: extent-tree: Use new __btrfs_delalloc_reserve_space function
>>    btrfs: qgroup: Cleanup old inaccurate facilities
>>    btrfs: qgroup: Add handler for NOCOW and inline
>
> I took a quick look through a few of these, none of them have any trace_*
> functions, yet you're adding several new entrypoints to the qgroup code.
> Those are incredibly useful for debugging on live systems and in fact I've
> got a patch which reintroduces the ones you removed in your last patch
> series ;)
Sounds great.

I was planning to add them later after the patchset merged, but since 
now it's not possible to merge into 4.3, I'll add tracepoints in the 
4.3~4.4 time interval.

BTW, I'm not quite a fan of using trace point to debug, as it's not so 
convenient compared to pr_info method.
And of course, takes more codes than pr_info.
(Yep, I'm quite a lazy bone)

Any good practice to make full use of tracepoint for debugging?

Thanks,
Qu
>
> This time around can you please provde tracepoints for at least your new
> high level entrypoint functions into the qgroup code?
>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh
>
