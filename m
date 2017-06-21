Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52429 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751130AbdFUVQJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:16:09 -0400
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
To: Jeff Mahoney <jeffm@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
 <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
 <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>
 <60c34b65-2940-bcfa-db7c-8a384608e083@suse.com>
From: Chris Mason <clm@fb.com>
Message-ID: <b06bfd86-6bd4-50eb-0070-22feb5bb7f9e@fb.com>
Date: Wed, 21 Jun 2017 17:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <60c34b65-2940-bcfa-db7c-8a384608e083@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/21/2017 05:08 PM, Jeff Mahoney wrote:
> On 6/21/17 4:31 PM, Chris Mason wrote:
>> On 06/21/2017 04:14 PM, Jeff Mahoney wrote:
>>> On 6/14/17 11:44 AM, jeffm@suse.com wrote:
>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>
>>>> In a heavy write scenario, we can end up with a large number of pinned
>>>> bytes.  This can translate into (very) premature ENOSPC because pinned
>>>> bytes must be accounted for when allowing a reservation but aren't
>>>> accounted for when deciding whether to create a new chunk.
>>>>
>>>> This patch adds the accounting to should_alloc_chunk so that we can
>>>> create the chunk.
>>>>
>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index cb0b924..d027807 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -4389,7 +4389,7 @@ static int should_alloc_chunk(struct
>>>> btrfs_fs_info *fs_info,
>>>>  {
>>>>      struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
>>>>      u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
>>>> -    u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved;
>>>> +    u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved +
>>>> sinfo->bytes_pinned + sinfo->bytes_may_use;
>>>>      u64 thresh;
>>>>
>>>>      if (force == CHUNK_ALLOC_FORCE)
>>>>
>>>
>>>
>>> Ignore this patch.  It certainly allocates chunks more aggressively, but
>>> it means we end up with a ton of metadata chunks even when we don't have
>>> much metadata.
>>>
>>
>> Josef and I pushed this needle back and forth a bunch of times in the
>> early days.  I still think we can allocate a few more chunks than we do
>> now...
>
> I agree.  This patch was to fix an issue that we are seeing during
> installation.  It'd stop with ENOSPC with >50GB completely unallocated.
> The patch passed the test cases that were failing before but now it's
> failing differently.  I was worried this pattern might be the end result:
>
> Data,single: Size:4.00GiB, Used:3.32GiB
>    /dev/vde        4.00GiB
>
> Metadata,DUP: Size:20.00GiB, Used:204.12MiB
>    /dev/vde       40.00GiB
>
> System,DUP: Size:8.00MiB, Used:16.00KiB
>    /dev/vde       16.00MiB
>
> This is on a fresh file system with just "cp /usr /mnt" executed.
>
> I'm looking into it a bit more now.

Does this failure still happen with Omar's ENOSPC fix (commit: 
70e7af244f24c94604ef6eca32ad297632018583)

-chris

