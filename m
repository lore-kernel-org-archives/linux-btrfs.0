Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:26315 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2JWQGy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 12:06:54 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9NFXS6i004770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 15:33:28 GMT
Message-ID: <5086B870.2020106@oracle.com>
Date: Tue, 23 Oct 2012 23:32:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] Btrfs: fix extent buffer reference for tree mod log
 roots
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net> <1351000527-24952-6-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-6-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2012 09:55 PM, Jan Schmidt wrote:
> In get_old_root we grab a lock on the extent buffer before we obtain a
> reference on that buffer. That order is changed now.
> 


Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 7093ff5..bed06e8 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1274,6 +1274,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  	free_extent_buffer(root->node);
>  	if (!eb)
>  		return NULL;
> +	extent_buffer_get(eb);
>  	btrfs_tree_read_lock(eb);
>  	if (old_root) {
>  		btrfs_set_header_bytenr(eb, eb->start);
> @@ -1286,7 +1287,6 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  		__tree_mod_log_rewind(eb, time_seq, tm);
>  	else
>  		WARN_ON(btrfs_header_level(eb) != 0);
> -	extent_buffer_get(eb);
>  	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(root));
>  
>  	return eb;
> 

