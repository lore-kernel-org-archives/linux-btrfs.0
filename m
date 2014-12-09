Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39539 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbaLIPmR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 10:42:17 -0500
Message-ID: <54871850.3020809@fb.com>
Date: Tue, 9 Dec 2014 10:42:08 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, <cyril.scetbon@free.fr>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: qgroup: free reserved in exceeding quota.
References: <BA68E495-8B7B-4F0F-A64B-0413B1480B9C@free.fr> <b5f44049f85f372a286a1c7e600d274dc03a2e25.1418124311.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <b5f44049f85f372a286a1c7e600d274dc03a2e25.1418124311.git.yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 06:27 AM, Dongsheng Yang wrote:
> When we exceed quota limit in writing, we will free
> some reserved extent when we need to drop but not free
> account in qgroup. It means, each time we exceed quota
> in writing, there will be some remain space in qg->reserved
> we can not use any more. If things go on like this, the
> all space will be ate up.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/extent-tree.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a84e00d..014b7f2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5262,8 +5262,11 @@ out_fail:
>   			to_free = 0;
>   	}
>   	spin_unlock(&BTRFS_I(inode)->lock);
> -	if (dropped)
> +	if (dropped) {
> +		if (root->fs_info->quota_enabled)
> +			btrfs_qgroup_free(root, dropped * root->nodesize);

This needs to be num_bytes + dropped * root->nodesize.  Thanks,

Josef
