Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34829 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbIJVdE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 17:33:04 -0400
Received: by ioiz6 with SMTP id z6so76816587ioi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2015 14:33:03 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150910210104.GS1145@wotan.suse.de>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20150910210104.GS1145@wotan.suse.de>
Date: Thu, 10 Sep 2015 22:33:02 +0100
Message-ID: <CAL3q7H7SgKs=WYumRJ=5eEL7_4+NJX5FhtRyRPS4kd-4vAayAg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/14] Accurate qgroup reserve framework
From: Filipe David Manana <fdmanana@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 10, 2015 at 10:01 PM, Mark Fasheh <mfasheh@suse.de> wrote:
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

https://patchwork.kernel.org/patch/7047641/

Came way before this patchset :)

>
>
>> the very bad btrfs space allocating principle:
>>   Allocate as much as you needed, even it's not fully used.
>>
>> So for accurate qgroup reserve, we introduce a completely new framework
>> for data and metadata.
>> 1) Per-inode data reserve map
>>    Now, each inode will have a data reserve map, recording which range
>>    of data is already reserved.
>>    If we are writing a range which is already reserved, we won't need to
>>    reserve space again.
>>
>>    Also, for the fact that qgroup is only accounted at commit_trans(),
>>    for data commit into disc and its metadata is also inserted into
>>    current tree, we should free the data reserved range, but still keep
>>    the reserved space until commit_trans().
>>
>>    So delayed_ref_head will have new members to record how much space is
>>    reserved and free them at commit_trans() time.
>>
>> 2) Per-root metadata reserve counter
>>    For metadata(tree block), it's impossible to know how much space it
>>    will use exactly in advance.
>>    And due to the new qgroup accounting framework, the old
>>    free-at-end-trans may lead to exceeding limit.
>>
>>    So we record how much metadata space is reserved for each root, and
>>    free them at commit_trans() time.
>>    This method is not perfect, but thanks to the compared small size of
>>    metadata, it should be quite good.
>>
>> More detailed info can be found in each commit message and source
>> commend.
>>
>> Qu Wenruo (19):
>>   btrfs: qgroup: New function declaration for new reserve implement
>>   btrfs: qgroup: Implement data_rsv_map init/free functions
>>   btrfs: qgroup: Introduce new function to search most left reserve
>>     range
>>   btrfs: qgroup: Introduce function to insert non-overlap reserve range
>>   btrfs: qgroup: Introduce function to reserve data range per inode
>>   btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function
>>   btrfs: qgroup: Introduce function to release reserved range
>>   btrfs: qgroup: Introduce function to release/free reserved data range
>>   btrfs: delayed_ref: Add new function to record reserved space into
>>     delayed ref
>>   btrfs: delayed_ref: release and free qgroup reserved at proper timing
>>   btrfs: qgroup: Introduce new functions to reserve/free metadata
>>   btrfs: qgroup: Use new metadata reservation.
>>   btrfs: extent-tree: Add new verions of btrfs_check_data_free_space
>>   btrfs: Switch to new check_data_free_space
>>   btrfs: fallocate: Add support to accurate qgroup reserve
>>   btrfs: extent-tree: Add new version of btrfs_delalloc_reserve_space
>>   btrfs: extent-tree: Use new __btrfs_delalloc_reserve_space function
>>   btrfs: qgroup: Cleanup old inaccurate facilities
>>   btrfs: qgroup: Add handler for NOCOW and inline
>
> I took a quick look through a few of these, none of them have any trace_*
> functions, yet you're adding several new entrypoints to the qgroup code.
> Those are incredibly useful for debugging on live systems and in fact I've
> got a patch which reintroduces the ones you removed in your last patch
> series ;)
>
> This time around can you please provde tracepoints for at least your new
> high level entrypoint functions into the qgroup code?
>
> Thanks,
>         --Mark
>
> --
> Mark Fasheh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
