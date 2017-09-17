Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61565 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750862AbdIQMZ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 08:25:56 -0400
Subject: Re: [PATCH] btrfs: Report error on removing qgroup if del_qgroup_item
 fails
To: Sargun Dhillon <sargun@sargun.me>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
References: <20170917090226.GA30640@ircssh-2.c.rugged-nimbus-611.internal>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b55672b3-c84d-46b8-f2b8-8b206ad32ccb@gmx.com>
Date: Sun, 17 Sep 2017 20:25:43 +0800
MIME-Version: 1.0
In-Reply-To: <20170917090226.GA30640@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月17日 17:02, Sargun Dhillon wrote:
> Previously, we were calling del_qgroup_item, and ignoring the return code
> resulting in a potential to have divergent in-memory state without an
> error. Perhaps, it makes sense to handle this error code, and put the
> filesystem into a read only, or similar state.
> 
> This patch only adds reporting of the error if the error is fatal,
> (any error other than qgroup not found).
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>

Looks good to me.

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks,
Qu

> ---
>   fs/btrfs/qgroup.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 770f667269f5..e172d4843eae 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1305,6 +1305,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
>   		}
>   	}
>   	ret = del_qgroup_item(trans, quota_root, qgroupid);
> +	if (ret && ret != -ENOENT)
> +		goto out >
>   	while (!list_empty(&qgroup->groups)) {
>   		list = list_first_entry(&qgroup->groups,
> 
