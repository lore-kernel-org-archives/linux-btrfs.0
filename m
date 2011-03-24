From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V5 2/2] btrfs: implement delayed inode items operation
Date: Fri, 25 Mar 2011 00:55:20 +0100
Message-ID: <20110324235520.GL17108@twin.jikos.cz>
References: <4D8B2DEB.1000001@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Ito <t-itoh@jp.fujitsu.com>, David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8B2DEB.1000001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there's one thing I want to bring up. It's not related to delayed
functionality itself but to git tree base of the patch.

There's a merge conflict when your patch is applied directly onto
Linus' tree, and not when on Chris' one.

On Thu, Mar 24, 2011 at 07:41:31PM +0800, Miao Xie wrote:
...
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6726,6 +6775,9 @@ void btrfs_destroy_inode(struct inode *inode)
>  	inode_tree_del(inode);
>  	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
>  free:
> +	ret = btrfs_remove_delayed_node(inode);
> +	BUG_ON(ret);
> +
>  	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
>  }
>  

the call to kmem_cache_free has been replaced by

commit fa0d7e3de6d6fc5004ad9dea0dd6b286af8f03e9
Author: Nick Piggin <npiggin@kernel.dk>
Date:   Fri Jan 7 17:49:49 2011 +1100
    fs: icache RCU free inodes

relevant hunk:

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6495,6 +6495,13 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
        return inode;
 }

+static void btrfs_i_callback(struct rcu_head *head)
+{
+       struct inode *inode = container_of(head, struct inode, i_rcu);
+       INIT_LIST_HEAD(&inode->i_dentry);
+       kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
+}
+
 void btrfs_destroy_inode(struct inode *inode)
 {
        struct btrfs_ordered_extent *ordered;
@@ -6564,7 +6571,7 @@ void btrfs_destroy_inode(struct inode *inode)
        inode_tree_del(inode);
        btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
-       kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
+       call_rcu(&inode->i_rcu, btrfs_i_callback);
 }


I don't think this disqualifies all the testing already done but maybe it's
time to rebase btrfs-unstable.git to .38 .

Chris?


dave
