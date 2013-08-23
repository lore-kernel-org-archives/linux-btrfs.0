Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20595 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab3HWHm4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 03:42:56 -0400
Message-ID: <521712B9.6050804@cn.fujitsu.com>
Date: Fri, 23 Aug 2013 15:43:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove ourselves from the cluster list under lock
References: <1377205499-14790-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1377205499-14790-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 22 Aug 2013 17:04:59 -0400, Josef Bacik wrote:
> A user was reporting weird warnings from btrfs_put_delayed_ref() and I noticed
> that we were doing this list_del_init() on our head ref outside of
> delayed_refs->lock.  This is a problem if we have people still on the list, we
> could end up modifying old pointers and such.  Fix this by removing us from the
> list before we do our run_delayed_ref on our head ref.  Thanks,

Looks good.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent-tree.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4c89566..95c6539 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2440,6 +2440,8 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  			default:
>  				WARN_ON(1);
>  			}
> +		} else {
> +			list_del_init(&locked_ref->cluster);
>  		}
>  		spin_unlock(&delayed_refs->lock);
>  
> @@ -2462,7 +2464,6 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  		 * list before we release it.
>  		 */
>  		if (btrfs_delayed_ref_is_head(ref)) {
> -			list_del_init(&locked_ref->cluster);
>  			btrfs_delayed_ref_unlock(locked_ref);
>  			locked_ref = NULL;
>  		}
> 

