Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753664AbdKMRCK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 12:02:10 -0500
Date: Mon, 13 Nov 2017 18:00:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: set plug for fsync
Message-ID: <20171113170015.GA28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171110001616.7875-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171110001616.7875-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 09, 2017 at 05:16:16PM -0700, Liu Bo wrote:
> Setting plug can merge adjacent IOs before dispatching IOs to the disk
> driver.
> 
> Without plug, it'd not be a problem for single disk usecases, but for
> multiple disks using raid profile, a large IO can be split to several
> IOs of stripe length, and plug can be helpful to bring them together
> for each disk so that we can save several disk access.
> 
> Moreover, fsync issues synchronous writes, so plug can really take
> effect.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/file.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e43da6c..063180b 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2018,10 +2018,13 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
>  static int start_ordered_ops(struct inode *inode, loff_t start, loff_t end)
>  {
>  	int ret;
> +	struct blk_plug plug;
>  
> +	blk_start_plug(&plug);

Can you please add a comment here? Essentially repeating the commit
message. The plug/unplug calls are never obvious so the expectations
could be documented.

>  	atomic_inc(&BTRFS_I(inode)->sync_writers);
>  	ret = btrfs_fdatawrite_range(inode, start, end);
>  	atomic_dec(&BTRFS_I(inode)->sync_writers);
> +	blk_finish_plug(&plug);
>  
>  	return ret;
>  }
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
