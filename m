Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55476 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3H3CR3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:29 -0400
Message-ID: <5220003F.6090103@cn.fujitsu.com>
Date: Fri, 30 Aug 2013 10:15:27 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix send to deal with sparse files properly V2
References: <1377186470-4000-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1377186470-4000-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/22/2013 11:47 PM, Josef Bacik wrote:

please use checkpatch.pl to check coding styles before sending patches:

WARNING: line over 80 characters
#86: FILE: fs/btrfs/send.c:4051:
+            if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0) {

total: 0 errors, 1 warnings, 59 lines checked

Thanks,
Wang
> Send was just sending everything it found, even if the extent was a hole.  This
> is unpleasant for users, so just skip holes when we are sending.  This will also
> skip sending prealloc extents since the send spec doesn't have a prealloc
> command.  Eventually we will add a prealloc command and rev the send version so
> we can send down the prealloc info.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: fix where we were skipping holes that needed to be written because we
> punched a hole between the original snapshot and the send snapshot.
>
>   fs/btrfs/send.c |   34 +++++++++++++++++++++++++++++++---
>   1 files changed, 31 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index db7da68..cbe92da 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3920,7 +3920,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
>   	btrfs_item_key_to_cpu(eb, &found_key, slot);
>   	if (found_key.objectid != key.objectid ||
>   	    found_key.type != key.type) {
> -		ret = 0;
> +		/* If we're a hole then just pretend nothing changed */
> +		ret = (left_disknr) ? 0 : 1;
>   		goto out;
>   	}
>   
> @@ -3946,7 +3947,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
>   		 * This may only happen on the first iteration.
>   		 */
>   		if (found_key.offset + right_len <= ekey->offset) {
> -			ret = 0;
> +			/* If we're a hole just pretend nothing changed */
> +			ret = (left_disknr) ? 0 : 1;
>   			goto out;
>   		}
>   
> @@ -4011,8 +4013,8 @@ static int process_extent(struct send_ctx *sctx,
>   			  struct btrfs_path *path,
>   			  struct btrfs_key *key)
>   {
> -	int ret = 0;
>   	struct clone_root *found_clone = NULL;
> +	int ret = 0;
>   
>   	if (S_ISLNK(sctx->cur_inode_mode))
>   		return 0;
> @@ -4025,6 +4027,32 @@ static int process_extent(struct send_ctx *sctx,
>   			ret = 0;
>   			goto out;
>   		}
> +	} else {
> +		struct btrfs_file_extent_item *ei;
> +		u8 type;
> +
> +		ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +				    struct btrfs_file_extent_item);
> +		type = btrfs_file_extent_type(path->nodes[0], ei);
> +		if (type == BTRFS_FILE_EXTENT_PREALLOC ||
> +		    type == BTRFS_FILE_EXTENT_REG) {
> +			/*
> +			 * The send spec does not have a prealloc command yet,
> +			 * so just leave a hole for prealloc'ed extents until
> +			 * we have enough commands queued up to justify rev'ing
> +			 * the send spec.
> +			 */
> +			if (type == BTRFS_FILE_EXTENT_PREALLOC) {
> +				ret = 0;
> +				goto out;
> +			}
> +
> +			/* Have a hole, just skip it. */
> +			if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0) {
> +				ret = 0;
> +				goto out;
> +			}
> +		}
>   	}
>   
>   	ret = find_extent_clone(sctx, path, key->objectid, key->offset,

