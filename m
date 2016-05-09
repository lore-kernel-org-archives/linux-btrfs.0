Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbcEIRcn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 13:32:43 -0400
Date: Mon, 9 May 2016 19:32:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Scott Talbert <scott.talbert@hgst.com>
Cc: linux-btrfs@vger.kernel.org, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix memory leak during RAID 5/6 device replacement
Message-ID: <20160509173220.GO29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462799668-26910-1-git-send-email-scott.talbert@hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462799668-26910-1-git-send-email-scott.talbert@hgst.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CC Zhao Lei <zhaolei@cn.fujitsu.com>

On Mon, May 09, 2016 at 09:14:28AM -0400, Scott Talbert wrote:
> A 'struct bio' is allocated in scrub_missing_raid56_pages(), but it was never
> freed anywhere.
> 
> Signed-off-by: Scott Talbert <scott.talbert@hgst.com>
> ---
>  fs/btrfs/scrub.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 82bedf9..607cc6e 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2130,6 +2130,8 @@ static void scrub_missing_raid56_end_io(struct bio *bio)
>  	if (bio->bi_error)
>  		sblock->no_io_error_seen = 0;
>  
> +	bio_put(bio);
> +
>  	btrfs_queue_work(fs_info->scrub_workers, &sblock->work);
>  }
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
