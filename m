Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:37520 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab3AXRBL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 12:01:11 -0500
Message-ID: <5101675B.9020305@jan-o-sch.net>
Date: Thu, 24 Jan 2013 17:54:51 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-prog/send: fix wrong best-parent assignment in,
 find_good_parent()
References: <510120C4.10406@cn.fujitsu.com>
In-Reply-To: <510120C4.10406@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, January 24, 2013 at 12:53 (+0100), Chen Yang wrote:
> We use find_good_parent() to look for a suit snapshot in the clone source
> snapshots as the parent, not the source subvolume of the snapshot which
> is about to be sent. fix it
> 
> Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
> ---
>  cmds-send.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/cmds-send.c b/cmds-send.c
> index 9b47e70..3a88c54 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -150,7 +150,7 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
>  		if (tmp < 0)
>  			tmp *= -1;
>  		if (tmp < best_diff) {
> -			best_parent = parent;
> +			best_parent = parent2;
>  			best_diff = tmp;
>  		}
>  	}
> 

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

Thanks,
-Jan
