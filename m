Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45601 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932479AbdEVBPD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 21:15:03 -0400
Subject: Re: [PATCH 2/8] btrfs: Fail on removing qgroup if del_qgroup_item
 fails
To: Sargun Dhillon <sargun@sargun.me>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <eff06906-08a0-4789-10fa-e0613a4ad848@cn.fujitsu.com>
Date: Mon, 22 May 2017 09:14:58 +0800
MIME-Version: 1.0
In-Reply-To: <20170520083902.GA4204@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170520083902.GA4204@ircssh-2.c.rugged-nimbus-611.internal>



At 05/20/2017 04:39 PM, Sargun Dhillon wrote:
> Previously, we were calling del_qgroup_item, and ignoring the return code
> resulting in a potential to have divergent in-memory state without an
> error. Perhaps, it makes sense to handle this error code, and put the
> filesystem into a read only, or similar state.
> 
> This patch only adds reporting of the error.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>   fs/btrfs/qgroup.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a2add44..7e772ba 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1303,6 +1303,8 @@ static int __btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
>   		return -EBUSY;
>   
>   	ret = del_qgroup_item(trans, quota_root, qgroupid);
> +	if (ret)
> +		goto out;

I think we should continue to remove in-memory qgroup relationship even 
we didn't find corresponding qgroup item.

IIRC it's better to catch less severe error like -ENOENT and continue.

Although normally previous find_qgroup_rb() should return -ENOENT before 
we continue to del_qgroup_item(), but catching -ENOENT here could make 
the code more robust.

Thanks,
Qu

>   
>   	while (!list_empty(&qgroup->groups)) {
>   		list = list_first_entry(&qgroup->groups,
> 


