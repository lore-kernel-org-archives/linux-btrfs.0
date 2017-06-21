Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36312 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751083AbdFUUbe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 16:31:34 -0400
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
To: Jeff Mahoney <jeffm@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
 <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
From: Chris Mason <clm@fb.com>
Message-ID: <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>
Date: Wed, 21 Jun 2017 16:31:16 -0400
MIME-Version: 1.0
In-Reply-To: <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2017 04:14 PM, Jeff Mahoney wrote:
> On 6/14/17 11:44 AM, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> In a heavy write scenario, we can end up with a large number of pinned
>> bytes.  This can translate into (very) premature ENOSPC because pinned
>> bytes must be accounted for when allowing a reservation but aren't
>> accounted for when deciding whether to create a new chunk.
>>
>> This patch adds the accounting to should_alloc_chunk so that we can
>> create the chunk.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index cb0b924..d027807 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4389,7 +4389,7 @@ static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
>>  {
>>  	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
>>  	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
>> -	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved;
>> +	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned + sinfo->bytes_may_use;
>>  	u64 thresh;
>>
>>  	if (force == CHUNK_ALLOC_FORCE)
>>
>
>
> Ignore this patch.  It certainly allocates chunks more aggressively, but
> it means we end up with a ton of metadata chunks even when we don't have
> much metadata.
>

Josef and I pushed this needle back and forth a bunch of times in the 
early days.  I still think we can allocate a few more chunks than we do 
now...

-chris

