Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:38249 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbeINEht (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:37:49 -0400
Subject: Re: [PATCH v2 1/7] btrfs-progs: adjust arguments of
 btrfs_lookup_inode_extref()
To: damenly.su@gmail.com, linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
References: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
 <20180912204924.10089-2-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2efa5d52-26af-e557-fa08-d5ffb296b337@gmx.com>
Date: Fri, 14 Sep 2018 07:26:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180912204924.10089-2-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/13 上午4:49, damenly.su@gmail.com wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> The argument index is not used in btrfs_lookup_inode_extref(),
> so remove it.
> And adjust positions its arguments to make it consistent with
> kernel part.
> 
> No functional change.
> 
> Fixes: 260675657767 ("btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.")
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Looks good, just small nitpick on coding style.

After fixing that, feel free to add my tag:

Reviewed-by: Qu Wenruo <wqu@suse.com>


> ---
>  ctree.h      | 6 +++---
>  inode-item.c | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/ctree.h b/ctree.h
> index 4719962df67d..e7f6c5df95f1 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -2708,9 +2708,9 @@ int btrfs_lookup_inode(struct btrfs_trans_handle *trans, struct btrfs_root
>  		       *root, struct btrfs_path *path,
>  		       struct btrfs_key *location, int mod);
>  struct btrfs_inode_extref *btrfs_lookup_inode_extref(struct btrfs_trans_handle
> -		*trans, struct btrfs_path *path, struct btrfs_root *root,
> -		u64 ino, u64 parent_ino, u64 index, const char *name,
> -		int namelen, int ins_len);
> +		*trans, struct btrfs_root *root, struct btrfs_path *path,

*trans and struct btrfs_trans_handle are in different lines, looks
pretty strange.

It would be much better to keep them in the same line, just what kernel
does.

> +		const char *name, int namelen, u64 ino, u64 parent_ino,
> +		int ins_len);
>  int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root,
>  			   const char *name, int name_len,
> diff --git a/inode-item.c b/inode-item.c
> index 1cc106670cd4..461557cb83d6 100644
> --- a/inode-item.c
> +++ b/inode-item.c
> @@ -228,9 +228,9 @@ static int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
>  }
>  
>  struct btrfs_inode_extref *btrfs_lookup_inode_extref(struct btrfs_trans_handle
> -		*trans, struct btrfs_path *path, struct btrfs_root *root,
> -		u64 ino, u64 parent_ino, u64 index, const char *name,
> -		int namelen, int ins_len)
> +		*trans, struct btrfs_root *root, struct btrfs_path *path,

Same here.

Thanks,
Qu

> +		const char *name, int namelen, u64 ino, u64 parent_ino,
> +		int ins_len)
>  {
>  	struct btrfs_key key;
>  	struct btrfs_inode_extref *extref;
> 
