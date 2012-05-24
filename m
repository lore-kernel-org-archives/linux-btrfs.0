Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:57280 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2EXK0m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 06:26:42 -0400
Date: Thu, 24 May 2012 12:26:30 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix the same inode id problem when doing auto
 defragment
Message-ID: <20120524102630.GP24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4FBDA00B.3010804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FBDA00B.3010804@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 24, 2012 at 10:42:19AM +0800, Miao Xie wrote:
> @@ -87,9 +102,9 @@ static void __btrfs_add_inode_defrag(struct inode *inode,
>  		parent = *p;
>  		entry = rb_entry(parent, struct inode_defrag, rb_node);
>  
> -		if (defrag->ino < entry->ino)
> +		if (__compare_inode_defrag(defrag, entry) < 0)
>  			p = &parent->rb_left;
> -		else if (defrag->ino > entry->ino)
> +		else if (__compare_inode_defrag(defrag, entry) > 0)
>  			p = &parent->rb_right;

you don't need to call the __compare_inode_defrag twice, the comparison
result will not change under hands between the two calls.

>  		else {
>  			/* if we're reinserting an entry for
> @@ -159,28 +174,33 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
>  /*
>   * must be called with the defrag_inodes lock held
>   */
> -struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info, u64 ino,
> +struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
> +					     u64 root, u64 ino,
>  					     struct rb_node **next)
>  {
>  	struct inode_defrag *entry = NULL;
> +	struct inode_defrag tmp;
>  	struct rb_node *p;
>  	struct rb_node *parent = NULL;
>  
> +	tmp.ino = ino;
> +	tmp.root = root;
> +
>  	p = info->defrag_inodes.rb_node;
>  	while (p) {
>  		parent = p;
>  		entry = rb_entry(parent, struct inode_defrag, rb_node);
>  
> -		if (ino < entry->ino)
> +		if (__compare_inode_defrag(&tmp, entry) < 0)
>  			p = parent->rb_left;
> -		else if (ino > entry->ino)
> +		else if (__compare_inode_defrag(&tmp, entry) > 0)

(same here)

>  			p = parent->rb_right;
>  		else
>  			return entry;
>  	}
>  
>  	if (next) {
> -		while (parent && ino > entry->ino) {
> +		while (parent && __compare_inode_defrag(&tmp, entry) > 0) {
>  			parent = rb_next(parent);
>  			entry = rb_entry(parent, struct inode_defrag, rb_node);
>  		}


david
