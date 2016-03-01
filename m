Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9872 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751362AbcCAINm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 03:13:42 -0500
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <56D3A56A.20809@cn.fujitsu.com> <20160229153352.GE2334@torres.zugschlus.de>
 <56D4E621.3010604@cn.fujitsu.com> <20160301065448.GJ2334@torres.zugschlus.de>
 <56D54393.8060307@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D54F2F.5050205@cn.fujitsu.com>
Date: Tue, 1 Mar 2016 16:13:35 +0800
MIME-Version: 1.0
In-Reply-To: <56D54393.8060307@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2016/03/01 15:24 +0800:
>
>
> Marc Haber wrote on 2016/03/01 07:54 +0100:
>> On Tue, Mar 01, 2016 at 08:45:21AM +0800, Qu Wenruo wrote:
>>> Didn't see the attachment though, seems to be filtered by maillist
>>> police.
>>
>> Trying again.
>
> OK, I got the attachment.
>
> And, surprisingly, btrfs balance on data chunk works without problem,
> but it fails on plain btrfs balance command.
>
>>
>>>> I now have a kworker and a btfs-transact kernel process taking most of
>>>> one CPU core each, even after the userspace programs have terminated.
>>>> Is there a way to find out what these threads are actually doing?
>>>
>>> Did btrfs balance status gives any hint?
>>
>> It says 'No balance found on /mnt/fanbtr'. I do have a second btrfs on
>> the box, which is acting up as well (it has a five digit number of
>> snapshots, and deleting a single snapshot takes about five to ten
>> minutes. I was planning to write another mailing list article once
>> this balance issue is through).
>
> I assume the large number of snapshots is related to the high CPU usage.
> As so many snapshots will make btrfs take so much time to calculate its
> backref, and the backtrace seems to prove that.
>
> I'd like to remove unused snapshots and keep the number of them to 4
> digits, as a workaround.
>
> But still not sure if it's related to the ENOSPC problem.
>
> It would provide great help if you can modify your kernel and add the
> following debug: (same as attachment)
>
> ------
>  From f2cc7af0aea659a522b97d3776b719f14532bce9 Mon Sep 17 00:00:00 2001
> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: Tue, 1 Mar 2016 15:21:18 +0800
> Subject: [PATCH] btrfs: debug patch
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/extent-tree.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 083783b..70b284b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9393,8 +9393,10 @@ int btrfs_can_relocate(struct btrfs_root *root,
> u64 bytenr)
>       block_group = btrfs_lookup_block_group(root->fs_info, bytenr);
>
>       /* odd, couldn't find the block group, leave it alone */
> -    if (!block_group)
> +    if (!block_group) {
> +        pr_info("no such chunk: %llu\n", bytenr);
>           return -1;
> +    }
>
>       min_free = btrfs_block_group_used(&block_group->item);
>
> @@ -9419,6 +9421,11 @@ int btrfs_can_relocate(struct btrfs_root *root,
> u64 bytenr)
>            space_info->bytes_pinned + space_info->bytes_readonly +
>            min_free < space_info->total_bytes)) {
>           spin_unlock(&space_info->lock);
> +        pr_info("no space: total:%llu, bg_len:%llu, used:%llu,
> reseved:%llu, pinned:%llu, ro:%llu, min_free:%llu\n",
> +            space_info->total_bytes, block_group->key.offset,
> +            space_info->bytes_used, space_info->bytes_reserved,
> +            space_info->bytes_pinned, space_info->bytes_readonly,
> +            min_free);
Oh, I'm sorry that the output is not necessary, it's better to use the 
newer patch:
https://patchwork.kernel.org/patch/8462881/

With the newer patch, you will need to use enospc_debug mount option to 
get the debug information.

Sorry for the inconvenience.

Thanks,
Qu

>           goto out;
>       }
>       spin_unlock(&space_info->lock);
> @@ -9448,8 +9455,10 @@ int btrfs_can_relocate(struct btrfs_root *root,
> u64 bytenr)
>            * this is just a balance, so if we were marked as full
>            * we know there is no space for a new chunk
>            */
> -        if (full)
> +        if (full) {
> +            pr_info("space full\n");
>               goto out;
> +        }
>
>           index = get_block_group_index(block_group);
>       }
> @@ -9496,6 +9505,8 @@ int btrfs_can_relocate(struct btrfs_root *root,
> u64 bytenr)
>               ret = -1;
>           }
>       }
> +    if (ret == -1)
> +        pr_info("no new chunk allocatable\n");
>       mutex_unlock(&root->fs_info->chunk_mutex);
>       btrfs_end_transaction(trans, root);
>   out:


