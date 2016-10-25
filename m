Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753089AbcJYUBd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 16:01:33 -0400
Date: Tue, 25 Oct 2016 16:00:51 -0400
From: Tejun Heo <htejun@fb.com>
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <david@fromorbit.com>,
        <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <hch@infradead.org>, <jweiner@fb.com>
Subject: Re: [PATCH 4/5] writeback: introduce super_operations->write_metadata
Message-ID: <20161025200051.GD13857@htj.duckdns.org>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-5-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1477420904-1399-5-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On Tue, Oct 25, 2016 at 02:41:43PM -0400, Josef Bacik wrote:
> Now that we have metadata counters in the VM, we need to provide a way to kick
> writeback on dirty metadata.  Introduce super_operations->write_metadata.  This
> allows file systems to deal with writing back any dirty metadata we need based
> on the writeback needs of the system.  Since there is no inode to key off of we
> need a list in the bdi for dirty super blocks to be added.  From there we can
> find any dirty sb's on the bdi we are currently doing writeback on and call into
> their ->write_metadata callback.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

> @@ -1491,6 +1516,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  	unsigned long start_time = jiffies;
>  	long write_chunk;
>  	long wrote = 0;  /* count both pages and inodes */
> +	bool done = false;
>  
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
> @@ -1607,12 +1633,18 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		 * background threshold and other termination conditions.
>  		 */
>  		if (wrote) {
> -			if (time_is_before_jiffies(start_time + HZ / 10UL))
> -				break;
> -			if (work->nr_pages <= 0)
> +			if (time_is_before_jiffies(start_time + HZ / 10UL) ||
> +			    work->nr_pages <= 0) {
> +				done = true;
>  				break;
> +			}
>  		}
>  	}
> +	if (!done && sb->s_op->write_metadata) {
> +		spin_unlock(&wb->list_lock);
> +		wrote += writeback_sb_metadata(sb, wb, work);
> +		spin_lock(&wb->list_lock);

So, here and below, we're writing out metadata only after finishing
writing out data if the writeout budget is limited.  It'd be great to
document the behavior and why it's so in the callback definition.

Thanks.

-- 
tejun
