Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29989 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933534AbcHJUNj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 16:13:39 -0400
Date: Wed, 10 Aug 2016 16:12:33 -0400
From: Tejun Heo <htejun@fb.com>
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>
Subject: Re: [PATCH 2/2] writeback: allow for dirty metadata accounting
Message-ID: <20160810201233.GB3398@mtj.duckdns.org>
References: <1470769707-26079-1-git-send-email-jbacik@fb.com>
 <1470769707-26079-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1470769707-26079-3-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Josef.

On Tue, Aug 09, 2016 at 03:08:27PM -0400, Josef Bacik wrote:
> Provide a mechanism for file systems to indicate how much dirty metadata they
> are holding.  This introduces a few things
> 
> 1) Zone stats for dirty metadata, which is the same as the NR_FILE_DIRTY.
> 2) WB stat for dirty metadata.  This way we know if we need to try and call into
> the file system to write out metadata.  This could potentially be used in the
> future to make balancing of dirty pages smarter.
> 3) A super callback to handle writing back dirty metadata.
> 
> A future patch will take advantage of this work in btrfs.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
...
> +	if (!done && wb_stat(wb, WB_METADATA_DIRTY)) {
> +		struct list_head list;
> +
> +		spin_unlock(&wb->list_lock);
> +		spin_lock(&wb->bdi->sb_list_lock);
> +		list_splice_init(&wb->bdi->sb_list, &list);
> +		while (!list_empty(&list)) {
> +			struct super_block *sb;
> +
> +			sb = list_first_entry(&list, struct super_block,
> +					      s_bdi_list);
> +			list_move_tail(&wb->bdi->sb_list, &sb->s_bdi_list);

It bothers me a bit that sb's can actually be off bdi->sb_list while
sb_list_lock is released.  Can we make this explicit?  e.g. keep
separate bdi sb list for sb's pending metadata writeout (like b_dirty)
or by just walking the list in a smart way?

> +			if (!sb->s_op->write_metadata)
> +				continue;
> +			if (!trylock_super(sb))
> +				continue;
> +			spin_unlock(&wb->bdi->sb_list_lock);
> +			wrote += writeback_sb_metadata(sb, wb, work);
> +			spin_lock(&wb->bdi->sb_list_lock);
> +			up_read(&sb->s_umount);
>  		}
> +		spin_unlock(&wb->bdi->sb_list_lock);
> +		spin_lock(&wb->list_lock);
>  	}
>  	/* Leave any unwritten inodes on b_io */
>  	return wrote;
> diff --git a/fs/super.c b/fs/super.c
> index c2ff475..940696d 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -215,6 +215,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  	spin_lock_init(&s->s_inode_list_lock);
>  	INIT_LIST_HEAD(&s->s_inodes_wb);
>  	spin_lock_init(&s->s_inode_wblist_lock);
> +	INIT_LIST_HEAD(&s->s_bdi_list);

I can't find where sb's are actually added to the list.  Is that
supposed to happen from specific filesystems?  Also, it might make
sense to split up additions of sb_list and stat into separate patches.

Thanks.

-- 
tejun
