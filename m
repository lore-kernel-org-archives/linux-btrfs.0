Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41341 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751953AbdC0SOa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 14:14:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C058AAC30
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 18:13:54 +0000 (UTC)
Subject: Re: [PATCH v5] qgroup: Retry after commit on getting EDQUOT
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20170327172957.2518-1-rgoldwyn@suse.de>
 <20170327173647.GQ4781@twin.jikos.cz>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <08d582e0-3670-ade4-3a2a-da72829d3da0@suse.de>
Date: Mon, 27 Mar 2017 13:13:46 -0500
MIME-Version: 1.0
In-Reply-To: <20170327173647.GQ4781@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/27/2017 12:36 PM, David Sterba wrote:
> On Mon, Mar 27, 2017 at 12:29:57PM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> We are facing the same problem with EDQUOT which was experienced with
>> ENOSPC. Not sure if we require a full ticketing system such as ENOSPC, but
>> here is a quick fix, which may be too big a hammer.
>>
>> Quotas are reserved during the start of an operation, incrementing
>> qg->reserved. However, it is written to disk in a commit_transaction
>> which could take as long as commit_interval. In the meantime there
>> could be deletions which are not accounted for because deletions are
>> accounted for only while committed (free_refroot). So, when we get
>> a EDQUOT flush the data to disk and try again.
>>
>> This fixes fstests btrfs/139.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>> Changes since v1:
>>  - Changed start_delalloc_roots() to start_delalloc_inode() to target
>>    the root in question only to reduce the amount of flush to be done.
>>  - Added wait_ordered_extents().
>>
>> Changes since v2:
>>   - Revised patch header
>>   - removed comment on combining conditions
>>   - removed test case, to be done in fstests
>>
>> Changes sinve v3:
>>   - testcase reinstated
>>   - return value checks
>>
>> Changes since v4:
>>  - removed testcase since btrfs/139 got incorporated in fstests
> 
> The point was to keep the test inside the changelog as well.


Yes, that was before we had btrfs/139 in fstest. I have put it in the
patch header. However, if you really want the test script back, I can
put it there. Let me know.


-- 
Goldwyn
