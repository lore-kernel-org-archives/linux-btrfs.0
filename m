Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:21285 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdILDDL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 23:03:11 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 47989AC011C
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 12:03:01 +0900 (JST)
Subject: Re: [PATCH] btrfs: send: fix error code if an unknown inode type is
 found
To: David Sterba <dsterba@suse.com>
References: <20170911165854.19460-1-dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <fa3a2302-b3cd-fafe-b9ec-9fd127706656@jp.fujitsu.com>
Date: Tue, 12 Sep 2017 12:02:44 +0900
MIME-Version: 1.0
In-Reply-To: <20170911165854.19460-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 2017/09/12 1:58, David Sterba wrote:
> There are two types for "not supported", but the correct one is
> EOPNOTSUPP, let's use that one. The error message in the error case is
> not very helpful, enhance it at least with the inode number.

When I first posted a similar patch, you said "I'd rather make it EINVAL".
https://marc.info/?l=linux-btrfs&m=145342170820262&w=2

But I think that EOPNOTSUPP is also good.
So, anyway,

Reviewed-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

> 
> The unknown type seems to be the block device (S_IFBLK)(as it's the only
> unhandled case. Adding this type would need to extend the send protocol,
> so this needs to stay as 'not supported'.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=196903
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/send.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 8f1d3d6e7087..5f944f9135d6 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2638,9 +2638,9 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
>  	} else if (S_ISSOCK(mode)) {
>  		cmd = BTRFS_SEND_C_MKSOCK;
>  	} else {
> -		btrfs_warn(sctx->send_root->fs_info, "unexpected inode type %o",
> -				(int)(mode & S_IFMT));
> -		ret = -ENOTSUPP;
> +		btrfs_warn(fs_info, "unexpected type 0%o of inode %llu",
> +				(int)(mode & S_IFMT), ino);
> +		ret = -EOPNOTSUPP;
>  		goto out;
>  	}
>  
> 


