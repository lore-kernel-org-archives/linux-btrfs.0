Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52079 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754128AbcIEBTL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 21:19:11 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Sean Fu'" <fxinrong@gmail.com>, <dsterba@suse.com>
CC: <clm@fb.com>, <anand.jain@oracle.com>, <fdmanana@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
In-Reply-To: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
Subject: RE: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment in btrfs_read_chunk_tree.
Date: Mon, 5 Sep 2016 09:19:05 +0800
Message-ID: <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Sean Fu

> From: Sean Fu [mailto:fxinrong@gmail.com]
> Sent: Sunday, September 04, 2016 7:54 PM
> To: dsterba@suse.com
> Cc: clm@fb.com; anand.jain@oracle.com; fdmanana@suse.com;
> zhaolei@cn.fujitsu.com; linux-btrfs@vger.kernel.org;
> linux-kernel@vger.kernel.org; Sean Fu <fxinrong@gmail.com>
> Subject: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment in
> btrfs_read_chunk_tree.
> 
> The input argument root is already set with "fs_info->chunk_root".
> "chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info)" in caller
> "open_ctree".
> “root->fs_info = fs_info” in "btrfs_alloc_root".
> 
The root argument of this function means "any root".
And the function is designed getting chunk root from
"any root" in head.

Since there is only one caller of this function,
and the caller always send chunk_root as root argument in
current code, we can remove above conversion,
and I suggest renaming root to chunk_root to make it clear,
something like:

- btrfs_read_chunk_tree(struct btrfs_root *root)
+ btrfs_read_chunk_tree(struct btrfs_root *chunk_root)

Thanks
Zhaolei

> Signed-off-by: Sean Fu <fxinrong@gmail.com>
> ---
>  fs/btrfs/volumes.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 366b335..384a6d2 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6600,8 +6600,6 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
>  	int ret;
>  	int slot;
> 
> -	root = root->fs_info->chunk_root;
> -
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> --
> 2.6.2
> 




