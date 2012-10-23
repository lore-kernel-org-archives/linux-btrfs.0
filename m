Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:17927 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2JWPcq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 11:32:46 -0400
Message-ID: <5086B8A2.9040902@oracle.com>
Date: Tue, 23 Oct 2012 23:32:50 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: comment for loop in tree_mod_log_insert_move
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net> <1351000527-24952-7-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-7-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2012 09:55 PM, Jan Schmidt wrote:
> Emphasis the way tree_mod_log_insert_move avoids adding
> MOD_LOG_KEY_REMOVE_WHILE_MOVING operations, depending on the direction of
> the move operation.
> 

Good work.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index bed06e8..c608b3c 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -596,6 +596,11 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
>  	if (tree_mod_dont_log(fs_info, eb))
>  		return 0;
>  
> +	/*
> +	 * When we override something during the move, we log these removals.
> +	 * This can only happen when we move towards the beginning of the
> +	 * buffer, i.e. dst_slot < src_slot.
> +	 */
>  	for (i = 0; i + dst_slot < src_slot && i < nr_items; i++) {
>  		ret = tree_mod_log_insert_key_locked(fs_info, eb, i + dst_slot,
>  					      MOD_LOG_KEY_REMOVE_WHILE_MOVING);
> 

