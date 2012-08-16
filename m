Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44097 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2HPPSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 11:18:21 -0400
Message-ID: <502D0F30.8030901@oracle.com>
Date: Thu, 16 Aug 2012 23:18:08 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix trivial typo for the comment of BTRFS_FREE_INO_OBJECTID
References: <502D0986.8050202@gmail.com>
In-Reply-To: <502D0986.8050202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/16/2012 10:53 PM, Wang Sheng-Hui wrote:
> It should be "storing".
> 

Please cc these typo fixes to trivial@kernel.org.

thanks,
liubo

> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/ctree.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4bab807..f9289db 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -116,7 +116,7 @@ struct btrfs_ordered_sum;
>  #define BTRFS_FREE_SPACE_OBJECTID -11ULL
>  
>  /*
> - * The inode number assigned to the special inode for sotring
> + * The inode number assigned to the special inode for storing
>   * free ino cache
>   */
>  #define BTRFS_FREE_INO_OBJECTID -12ULL
> 

