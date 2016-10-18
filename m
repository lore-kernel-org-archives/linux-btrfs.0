Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46589 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753461AbcJRKcY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 06:32:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bwRgr-0004nG-SB
        for linux-btrfs@vger.kernel.org; Tue, 18 Oct 2016 12:32:13 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH] btrfs: pass correct args to
 btrfs_async_run_delayed_refs()
Date: Tue, 18 Oct 2016 10:32:00 +0000 (UTC)
Message-ID: <pan$9e691$50b48431$37da74db$d7e3b0a2@applied-asynchrony.com>
References: <20161018075613.10757-1-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 18 Oct 2016 15:56:13 +0800, Wang Xiaoguang wrote:

> In btrfs_truncate_inode_items()->btrfs_async_run_delayed_refs(), we
> swap the arg2 and arg3 wrongly, fix this.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2b790bd..2f1372b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4605,8 +4605,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  			BUG_ON(ret);
>  			if (btrfs_should_throttle_delayed_refs(trans, root))
>  				btrfs_async_run_delayed_refs(root,
> -							     trans->transid,
> -					trans->delayed_ref_updates * 2, 0);
> +					trans->delayed_ref_updates * 2,
> +					trans->transid, 0);
>  			if (be_nice) {
>  				if (truncate_space_check(trans, root,
>  							 extent_num_bytes)) {

Reviewed-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Passing the wrong transid..why did this ever work?

-h

