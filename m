Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaHIN0L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Aug 2014 09:26:11 -0400
Message-ID: <53E62169.1010905@redhat.com>
Date: Sat, 09 Aug 2014 08:26:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>, clm@fb.com, jbacik@fb.com
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop stray check of fixup_workers creation
References: <1407585075-31035-1-git-send-email-andrey.krieger.utkin@gmail.com>
In-Reply-To: <1407585075-31035-1-git-send-email-andrey.krieger.utkin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/9/14, 6:51 AM, Andrey Utkin wrote:
> The issue was introduced in a79b7d4b3e8118f265dcb4bdf9a572c392f02708,
> adding allocation of extent_workers, so this stray check is surely not
> meant to be a check of something else.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=82021
> Reported-by: Maks Naumov <maksqwe1@ukr.net>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Yup, harmless but unneeded.

However, might as well put the extent_workers & qgroup_rescan_workers checks
on the same line now...

Could probably do a V2 or fix it on commit, but anyway:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/btrfs/disk-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 08e65e9..1881713 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2601,7 +2601,7 @@ int open_ctree(struct super_block *sb,
>  	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
>  	      fs_info->caching_workers && fs_info->readahead_workers &&
>  	      fs_info->fixup_workers && fs_info->delayed_workers &&
> -	      fs_info->fixup_workers && fs_info->extent_workers &&
> +	      fs_info->extent_workers &&
>  	      fs_info->qgroup_rescan_workers)) {
>  		err = -ENOMEM;
>  		goto fail_sb_buffer;
> 

