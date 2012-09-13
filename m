Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19683 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab2IMDgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 23:36:04 -0400
Message-ID: <5051549B.7070206@cn.fujitsu.com>
Date: Thu, 13 Sep 2012 11:35:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: delay block group item insertion
References: <1347473053-3158-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1347473053-3158-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	wed, 12 Sep 2012 14:04:13 -0400, Josef Bacik wrote:
> So we have lots of places where we try to preallocate chunks in order to
> make sure we have enough space as we make our allocations.  This has
> historically meant that we're constantly tweaking when we should allocate a
> new chunk, and historically we have gotten this horribly wrong so we way
> over allocate either metadata or data.  To try and keep this from happening
> we are going to make it so that the block group item insertion is done out
> of band at the end of a transaction.  This will allow us to create chunks
> even if we are trying to make an allocation for the extent tree.  With this
> patch my enospc tests run faster (didn't expect this) and more efficiently
> use the disk space (this is what I wanted).  Thanks,

This patch also fixes a deadlock problem that happened when we add two or
more small devices(< 4G) into a seed fs(the profile of metadata is RAID1),
and a enospc problem when we add a small device (< 256M) into a big empty
seed fs(> 60G).

(My fix patch which is similar to this one is on the way, I'm a bit slow :) )

> @@ -1400,6 +1407,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	 */
>  	cur_trans->delayed_refs.flushing = 1;
>  
> +	if (!list_empty(&trans->new_bgs))
> +		btrfs_create_pending_block_groups(trans, root);
> +
>  	ret = btrfs_run_delayed_refs(trans, root, 0);
>  	if (ret)
>  		goto cleanup_transaction;

I think we can not make sure we won't allocate new chunks when we
create the pending snapshots and write out the space cache and inode
cache, so we should check ->new_bgs and call btrfs_create_pending_block_groups()
when committing the cowonly tree roots.

And beside that, We'd better add a BUG_ON() after we update the root tree to
make sure there is no pending block group item left in the list.

Thanks
Miao
