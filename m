Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65145 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2GRKC3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 06:02:29 -0400
Received: by obbuo13 with SMTP id uo13so1916854obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2012 03:02:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com>
Date: Wed, 18 Jul 2012 13:02:27 +0300
Message-ID: <CAHf9xvZmDPTqSHK3b2WLH1jhkQo4RqpMqPpX7i1wzh2CHuDZWg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix btrfs_is_free_space_inode to recognize
 btree inode
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,
can you pls explain this a bit more to me.
I see in my fs that there are (FREE_SPACE,0, offset) items in the root
tree. It seems that offset here is the objectid of the appropriate
BLOCK_GROUP_ITEM. Also, I see that each FREE_SPACE points at some
INODE_ITEM within the root tree, and this INODE_ITEM also has extents.
I presume that these extents contain the free space cache in some
format, is that correct?

However, I don't see any FREE_INO entries, what are they? Are they
perhaps used only when "inode_cache" mount option is used, so inode
numbers are not always incremented in btrfs_find_free_ino(), but
smaller unused numbers are reused?

Also, I don't see anywhere BTRFS_BTREE_INODE_OBJECTID in the tree root
tree. So what is this "btree inode" that you mention?

Thanks,
Alex.


On Tue, Jul 10, 2012 at 2:28 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> For btree inode, its root is also 'tree root', so btree inode can be
> misunderstood as a free space inode.
>
> We should add one more check for btree inode.
>
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/btrfs_inode.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 12394a9..b168238 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -194,8 +194,10 @@ static inline void btrfs_i_size_write(struct inode *inode, u64 size)
>  static inline bool btrfs_is_free_space_inode(struct btrfs_root *root,
>                                        struct inode *inode)
>  {
> -       if (root == root->fs_info->tree_root ||
> -           BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
> +       if (root == root->fs_info->tree_root &&
> +           btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID)
> +               return true;
> +       if (BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
>                 return true;
>         return false;
>  }
> --
> 1.6.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
