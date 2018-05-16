Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752351AbeEPGru (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 02:47:50 -0400
Subject: Re: [PATCH 6/6] Btrfs: remove always true check in unlock_up
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526406728-109055-7-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a9d10243-012b-a517-3fe9-1821a096cad7@suse.com>
Date: Wed, 16 May 2018 09:47:47 +0300
MIME-Version: 1.0
In-Reply-To: <1526406728-109055-7-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.05.2018 20:52, Liu Bo wrote:
> @path->lock[i] is always true at this point.

You must explain why it's true. The reason is since at the beginning of
the for loop the check is performed :

   if (!path->locks[i])
      break;


Codewise it's ok:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/ctree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index f7c3f581f647..16d28a4ec54f 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2330,7 +2330,7 @@ static noinline void unlock_up(struct btrfs_path *path, int level,
>  			no_skips = 1;
>  
>  		t = path->nodes[i];
> -		if (i >= lowest_unlock && i > skip_level && path->locks[i]) {
> +		if (i >= lowest_unlock && i > skip_level) {
>  			btrfs_tree_unlock_rw(t, path->locks[i]);
>  			path->locks[i] = 0;
>  			if (write_lock_level &&
> 
