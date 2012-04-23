From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: do not do filemap_write_and_wait_range in fsync
Date: Mon, 23 Apr 2012 19:29:45 -0400
Message-ID: <20120423232945.GD22794@shiny>
References: <1335208001-8833-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335208001-8833-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 23, 2012 at 03:06:41PM -0400, Josef Bacik wrote:
> We already do the btrfs_wait_ordered_range which will do this for us, so
> just remove this call so we don't call it twice.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/file.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f0da02b..0c8ed6a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1492,14 +1492,15 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  
>  	trace_btrfs_sync_file(file, datasync);
>  
> -	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
> -	if (ret)
> -		return ret;
>  	mutex_lock(&inode->i_mutex);

Hmmm, I think there are some good benefits to doing the wait
outside of the mutex.

The question is, do we need to do it again after we take the mutex?  I
tend to think no, if you're racing another write with the fsync, you get
what you deserve.

-chris

