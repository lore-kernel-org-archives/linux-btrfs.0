Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:15685 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbFCI2v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 04:28:51 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 52267AC01CA
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2015 17:18:20 +0900 (JST)
Message-ID: <556EB843.4060003@jp.fujitsu.com>
Date: Wed, 03 Jun 2015 17:18:11 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: allow user to clear the limitation on
 qgroup
References: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1433314653-548-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1433314653-548-2-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/06/03 15:57, Dongsheng Yang wrote:
> Currently, we can only set a limitation on a qgroup, but we
> can not clear it.
> 
> This patch provide a choice to user to clear a limitation on
> qgroup by passing a value of CLEAR_VALUE(-1) to kernel.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

> ---
>   fs/btrfs/qgroup.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 3d65465..0412d5b 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1317,6 +1317,11 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
>   	struct btrfs_root *quota_root;
>   	struct btrfs_qgroup *qgroup;
>   	int ret = 0;
> +	/* Sometimes we would want to clear the limit on this qgroup.
> +	 * To meet this requirement, we treat the -1 as a special value
> +	 * which tell kernel to clear the limit on this qgroup.
> +	 */
> +	const u64 CLEAR_VALUE = -1;
>   
>   	mutex_lock(&fs_info->qgroup_ioctl_lock);
>   	quota_root = fs_info->quota_root;
> @@ -1332,14 +1337,42 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
>   	}
>   
>   	spin_lock(&fs_info->qgroup_lock);
> -	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
> -		qgroup->max_rfer = limit->max_rfer;
> -	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
> -		qgroup->max_excl = limit->max_excl;
> -	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER)
> -		qgroup->rsv_rfer = limit->rsv_rfer;
> -	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL)
> -		qgroup->rsv_excl = limit->rsv_excl;
> +	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_RFER) {
> +		if (limit->max_rfer == CLEAR_VALUE) {
> +			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_MAX_RFER;
> +			limit->flags &= ~BTRFS_QGROUP_LIMIT_MAX_RFER;
> +			qgroup->max_rfer = 0;
> +		} else {
> +			qgroup->max_rfer = limit->max_rfer;
> +		}
> +	}
> +	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) {
> +		if (limit->max_excl == CLEAR_VALUE) {
> +			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_MAX_EXCL;
> +			limit->flags &= ~BTRFS_QGROUP_LIMIT_MAX_EXCL;
> +			qgroup->max_excl = 0;
> +		} else {
> +			qgroup->max_excl = limit->max_excl;
> +		}
> +	}
> +	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER) {
> +		if (limit->rsv_rfer == CLEAR_VALUE) {
> +			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
> +			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
> +			qgroup->rsv_rfer = 0;
> +		} else {
> +			qgroup->rsv_rfer = limit->rsv_rfer;
> +		}
> +	}
> +	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL) {
> +		if (limit->rsv_excl == CLEAR_VALUE) {
> +			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
> +			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
> +			qgroup->rsv_excl = 0;
> +		} else {
> +			qgroup->rsv_excl = limit->rsv_excl;
> +		}
> +	}
>   	qgroup->lim_flags |= limit->flags;
>   
>   	spin_unlock(&fs_info->qgroup_lock);
> 


