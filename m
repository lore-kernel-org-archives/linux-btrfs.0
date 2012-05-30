Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab2E3B0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 21:26:41 -0400
Message-ID: <4FC5769D.7080509@cn.fujitsu.com>
Date: Wed, 30 May 2012 09:23:41 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix return code in drop_objectid_items
References: <1338325076-9203-1-git-send-email-josef@redhat.com>
In-Reply-To: <1338325076-9203-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/30/2012 04:57 AM, Josef Bacik wrote:

> So dpkg fsync()'s the file and the directory containing the file whenever it
> writes to a file which is really slow in btrfs.  This is partly because
> fsync()'ing a directory _always_ committed the transaction instead of just
> going to the tree log.  This is because drop_objectid_items() would return 1
> since it does a btrfs_search_slot() which returns 1.  In tree-log jargon
> this means that we have to commit the transaction to be safe.  So just check
> if ret is greater than 0 and set it to 0 if it does.  With this patch we now
> use the tree-log instead of committing the entire transaction, which is
> twice as fast on my box.  Thanks,
> 


Good catch.

Reviewed-by: Liu Bo <liubo2009@cn.fujitsu.com>

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/tree-log.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 425014b..2017d0f 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2667,6 +2667,8 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
>  		btrfs_release_path(path);
>  	}
>  	btrfs_release_path(path);
> +	if (ret > 0)
> +		ret = 0;
>  	return ret;
>  }
>  


