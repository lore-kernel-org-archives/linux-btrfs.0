Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23714 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab2K3JE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 04:04:28 -0500
Date: Fri, 30 Nov 2012 17:02:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: shhuiw@gmail.com
Cc: chris.mason@fusionio.com, jbacik@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove warning check in io_ctl_map_page
Message-ID: <20121130090252.GA7353@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <n>
 <1354255348-5011-1-git-send-email-y>
 <50b84c20.a657320a.776a.fffff16d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50b84c20.a657320a.776a.fffff16d@mx.google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 30, 2012 at 02:02:26PM +0800, shhuiw@gmail.com wrote:
> From: Wang Sheng-Hui <shhuiw@gmail.com>
> 
> io_ctl_map_page is called by many functions in free-space-cache.
> In some scenarios, the ->cur is not null, e.g. io_ctl_add_entry.
> Remove the check here.

Hi Wang,

Seems to be impossible according to the code, even in io_ctl_add_entry().

So have you seen such a warning in your flight running?  If you do,
maybe you can post it here and we can figure out the whys.

thanks,
liubo

> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/free-space-cache.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index c3318cb..4ea66d4 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -307,7 +307,6 @@ static void io_ctl_unmap_page(struct io_ctl *io_ctl)
>  
>  static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
>  {
> -	WARN_ON(io_ctl->cur);
>  	BUG_ON(io_ctl->index >= io_ctl->num_pages);
>  	io_ctl->page = io_ctl->pages[io_ctl->index++];
>  	io_ctl->cur = kmap(io_ctl->page);
> -- 
> 1.6.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
