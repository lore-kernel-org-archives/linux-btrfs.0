Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33049 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaHKL6p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 07:58:45 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 2F2753EE0C0
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 20:58:44 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 42563AC0317
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 20:58:43 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id EDE971DB8032
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 20:58:42 +0900 (JST)
Message-ID: <53E8AFEA.6030900@jp.fujitsu.com>
Date: Mon, 11 Aug 2014 20:58:34 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: clone, don't create invalid hole extent map
References: <1407462426-6420-1-git-send-email-fdmanana@suse.com> <1407462426-6420-2-git-send-email-fdmanana@suse.com>
In-Reply-To: <1407462426-6420-2-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/08/08 10:47), Filipe Manana wrote:
> When cloning a file that consists of an inline extent, we were creating
> an extent map that represents a non-existing trailing hole starting at a
> file offset that isn't a multiple of the sector size. This happened because
> when processing an inline extent we weren't aligning the extent's length to
> the sector size, and therefore incorrectly treating the range
> [inline_extent_length; sector_size[ as a hole.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   fs/btrfs/ioctl.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d490abd..6e3a0d1 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3494,7 +3494,8 @@ process_slot:
>   			btrfs_mark_buffer_dirty(leaf);
>   			btrfs_release_path(path);
>   
> -			last_dest_end = new_key.offset + datal;
> +			last_dest_end = ALIGN(new_key.offset + datal,
> +					      root->sectorsize);
>   			ret = clone_finish_inode_update(trans, inode,
>   							last_dest_end,
>   							destoff, olen);
> 

