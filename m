Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44430 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3KBUjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 16:39:31 -0400
Received: by mail-qc0-f174.google.com with SMTP id v1so3136366qcw.5
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Nov 2013 13:39:31 -0700 (PDT)
References: <20131030204834.GA20844@gmail.com> <1383416676-16591-1-git-send-email-rashika.kheria@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1383416676-16591-1-git-send-email-rashika.kheria@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A632F12B-DA53-4A97-933F-6F8BAB9448CE@toxicpanda.com>
Cc: "opw-kernel@googlegroups.com" <opw-kernel@googlegroups.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Zach Brown <zab@redhat.com>
From: Josef Back <josef@toxicpanda.com>
Subject: Re: [PATCH v4] btrfs: Add helper function for free_root_pointers()
Date: Sat, 2 Nov 2013 16:39:28 -0400
To: Rashika Kheria <rashika.kheria@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've already pulled v3 into btrfs-next, for this I prefer v3.  Thanks,

Josef

> On Nov 2, 2013, at 2:24 PM, Rashika Kheria <rashika.kheria@gmail.com> wrote:
> 
> The function free_root_pointers() in disk-io.h contains redundant code.
> Therefore, this patch adds a helper function free_root_extent_buffers()
> to free_root_pointers() to eliminate redundancy
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Zach Brown <zab@redhat.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> This revision fixes the following issues of the previous revision-
> Early return when root is NULL
> 
> fs/btrfs/disk-io.c |   60 +++++++++++++++++-----------------------------------
> 1 file changed, 19 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 62176ad..f719394 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2013,50 +2013,28 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>    btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
> }
> 
> +static void free_root_extent_buffers(struct btrfs_root *root)
> +{
> +    if (!root)
> +        return;
> +    free_extent_buffer(root->node);
> +    free_extent_buffer(root->commit_root);
> +    root->node = NULL;
> +    root->commit_root = NULL;
> +}
> +
> /* helper to cleanup tree roots */
> static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
> {
> -    free_extent_buffer(info->tree_root->node);
> -    free_extent_buffer(info->tree_root->commit_root);
> -    info->tree_root->node = NULL;
> -    info->tree_root->commit_root = NULL;
> -
> -    if (info->dev_root) {
> -        free_extent_buffer(info->dev_root->node);
> -        free_extent_buffer(info->dev_root->commit_root);
> -        info->dev_root->node = NULL;
> -        info->dev_root->commit_root = NULL;
> -    }
> -    if (info->extent_root) {
> -        free_extent_buffer(info->extent_root->node);
> -        free_extent_buffer(info->extent_root->commit_root);
> -        info->extent_root->node = NULL;
> -        info->extent_root->commit_root = NULL;
> -    }
> -    if (info->csum_root) {
> -        free_extent_buffer(info->csum_root->node);
> -        free_extent_buffer(info->csum_root->commit_root);
> -        info->csum_root->node = NULL;
> -        info->csum_root->commit_root = NULL;
> -    }
> -    if (info->quota_root) {
> -        free_extent_buffer(info->quota_root->node);
> -        free_extent_buffer(info->quota_root->commit_root);
> -        info->quota_root->node = NULL;
> -        info->quota_root->commit_root = NULL;
> -    }
> -    if (info->uuid_root) {
> -        free_extent_buffer(info->uuid_root->node);
> -        free_extent_buffer(info->uuid_root->commit_root);
> -        info->uuid_root->node = NULL;
> -        info->uuid_root->commit_root = NULL;
> -    }
> -    if (chunk_root) {
> -        free_extent_buffer(info->chunk_root->node);
> -        free_extent_buffer(info->chunk_root->commit_root);
> -        info->chunk_root->node = NULL;
> -        info->chunk_root->commit_root = NULL;
> -    }
> +    free_root_extent_buffers(info->tree_root);
> +
> +    free_root_extent_buffers(info->dev_root);
> +    free_root_extent_buffers(info->extent_root);
> +    free_root_extent_buffers(info->csum_root);
> +    free_root_extent_buffers(info->quota_root);
> +    free_root_extent_buffers(info->uuid_root);
> +    if (chunk_root)
> +        free_root_extent_buffers(info->chunk_root);
> }
> 
> static void del_fs_roots(struct btrfs_fs_info *fs_info)
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
