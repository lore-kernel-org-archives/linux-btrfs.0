Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935284AbcJ1PDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 11:03:39 -0400
Subject: Re: [PATCH 0/4] Qgroup comment enhance and balance fix
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
 <f4f40424-e097-aed8-1888-b68f348263c0@cn.fujitsu.com>
Cc: rgoldwyn@suse.com
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <0560fc5d-38a4-2940-e8d6-6cad83caec9e@suse.de>
Date: Fri, 28 Oct 2016 10:03:35 -0500
MIME-Version: 1.0
In-Reply-To: <f4f40424-e097-aed8-1888-b68f348263c0@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/27/2016 07:33 PM, Qu Wenruo wrote:
> Any comment?
> 
> Especially the final patch will fix a long standing bug.
> 

While I have tested it, and it works, I did not get time to review it.
So, you can have my

Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> Thanks,
> Qu
> 
> At 10/18/2016 09:31 AM, Qu Wenruo wrote:
>> The patchset does the following things:
>> 1) Enhance comment for qgroup, rename 2 functions
>>    Explain the how qgroup works, so new developers won't waste too much
>>    time digging into the boring codes.
>>
>>    The qgroup work flow is split into 3 main phrases:
>>    Reverse, Trace, Account.
>>    And rename functions like btrfs_qgroup_insert_dirty_extent_record()
>>    to btrfs_qgroup_trace_extent(), to follow the "Trace" phrase.
>>
>>    Other function name already follows such schema before.
>>
>> 2) Move account_shared_subtree() and account_leaf_items() to qgroup.c
>>    Such functions are only used by qgroup, so move them to qgroup.c and
>>    rename them to follow "trace" schema.
>>
>> 3) Fix the long standing qgroup balance corruption
>>    Commit 62b99540a1d91e4 doesn't fix the problem completely.
>>    It can only handle case that merge_reloc_roots() are all done in one
>>    transaction.
>>
>>    If transaction commits during merge_reloc_roots(), the data extents
>>    will leak again.
>>
>>    The tree fix is to info qgroup to trace both subtree(tree reloc tree
>>    and destination fs tree), at replace_path() time.
>>    Inside  replace_path(), there is one transaction start and end, so we
>>    must make qgroup to trace both subtrees.
>>
>>    Thanks for previous work, now we can easily trace subtree, so the fix
>>    is quite simple now.
>>
>>    And the cause also makes it easier to create pinpoint test case for
>>    this bug.
>>
>> Qu Wenruo (4):
>>   btrfs: qgroup: Add comments explaining how btrfs qgroup works
>>   btrfs: qgroup: Rename functions to make it follow
>>     reserve,trace,account steps
>>   btrfs: Expoert and move leaf/subtree qgroup helpers to qgroup.c
>>   btrfs: qgroup: Fix qgroup data leaking by using subtree tracing
>>
>>  fs/btrfs/delayed-ref.c       |   2 +-
>>  fs/btrfs/extent-tree.c       | 220
>> +------------------------------------------
>>  fs/btrfs/qgroup.c            | 219
>> +++++++++++++++++++++++++++++++++++++++++-
>>  fs/btrfs/qgroup.h            |  64 +++++++++++--
>>  fs/btrfs/relocation.c        | 119 +++++------------------
>>  fs/btrfs/tree-log.c          |   2 +-
>>  include/trace/events/btrfs.h |   2 +-
>>  7 files changed, 302 insertions(+), 326 deletions(-)
>>
> 
> 

-- 
Goldwyn
