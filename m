Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33036 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966344AbcAZPuC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 10:50:02 -0500
Received: by mail-pf0-f175.google.com with SMTP id e65so101161937pfe.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 07:50:02 -0800 (PST)
References: <1453792397-4363-1-git-send-email-bhlee.kernel@gmail.com>
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: simplify expression in btrfs_csum_bytes_to_leaves()
Date: Tue, 26 Jan 2016 23:58:17 +0900
Message-ID: <87twm0jsl2.fsf@gmail.com>
In-reply-to: <1453792397-4363-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

Please ignore this patch.  Because the function's name is wrong in the
subject line.  While I was writing the commit log, I copy & pasted the
first function's name showing in git diff result. I will prepare V2 soon.

Byongho Lee writes:

> Simplify expression in btrfs_csum_bytes_to_leaves().
>
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
> ---
>  fs/btrfs/ctree.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a9496644f47d..3ab8026280a2 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3448,8 +3448,7 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes);
>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
>  						 unsigned num_items)
>  {
> -	return (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
> -		2 * num_items;
> +	return root->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
>  }
>  
>  /*

