Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16399 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab2ITPMk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 11:12:40 -0400
Message-ID: <505B325D.4020802@oracle.com>
Date: Thu, 20 Sep 2012 23:12:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: small fix the commment for the action flags in
 delayed-ref.h
References: <505B3117.9040603@gmail.com>
In-Reply-To: <505B3117.9040603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/20/2012 11:07 PM, Wang Sheng-Hui wrote:
> The action has been merged into struct btrfs_delayed_ref_node,
> and no struct btrfs_delayed_ref is available now.
> 

You can consider sending this kind of typo fix patch to trivial list instead.

thanks,
liubo

> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/delayed-ref.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index ab53005..c9d7036 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -18,7 +18,7 @@
>  #ifndef __DELAYED_REF__
>  #define __DELAYED_REF__
>  
> -/* these are the possible values of struct btrfs_delayed_ref->action */
> +/* these are the possible values of struct btrfs_delayed_ref_node->action */
>  #define BTRFS_ADD_DELAYED_REF    1 /* add one backref to the tree */
>  #define BTRFS_DROP_DELAYED_REF   2 /* delete one backref from the tree */
>  #define BTRFS_ADD_DELAYED_EXTENT 3 /* record a full extent allocation */
> 

