From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V2] btrfs: fix possible deadlock by clearing __GFP_FS flag
Date: Sun, 27 Mar 2011 10:02:34 -0400
Message-ID: <1301234502-sup-4509@think>
References: <4D8EF048.5050203@cn.fujitsu.com> <4D8F2D32.3000601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D8F2D32.3000601@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2011-03-27 08:27:30 -0400:
> Changelog V1 -> V2:
> - modify the explanation of the deadlock.
> - clear __GFP_FS flag in the free space's page cache.
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index a039065..57df380 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -88,6 +88,8 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
>      }
>      spin_unlock(&block_group->lock);
>  
> +    inode->i_mapping->flags &= ~__GFP_FS;
> +
>      return inode;
>  }
>  

I did this part slightly differently, in btrfs_read_locked_inode.  That
way we know the mask isn't changing while page allocations are taking
place.

-chris
