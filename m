Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34320 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754402AbaLIPzo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 10:55:44 -0500
Message-ID: <54871B79.3090206@fb.com>
Date: Tue, 9 Dec 2014 10:55:37 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, <cyril.scetbon@free.fr>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: qgroup: Introduce a may_use to account space_info->bytes_may_use.
References: <b5f44049f85f372a286a1c7e600d274dc03a2e25.1418124311.git.yangds.fnst@cn.fujitsu.com> <be147b22171d958c2a346437356448e94691c520.1418124311.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <be147b22171d958c2a346437356448e94691c520.1418124311.git.yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 06:27 AM, Dongsheng Yang wrote:
> Currently, for pre_alloc or delay_alloc, the bytes will be accounted
> in space_info by the three guys.
> space_info->bytes_may_use --- space_info->reserved --- space_info->used.
> But on the other hand, in qgroup, there are only two counters to account the
> bytes, qgroup->reserved and qgroup->excl. And qg->reserved accounts
> bytes in space_info->bytes_may_use and qg->excl accounts bytes in
> space_info->used. So the bytes in space_info->reserved is not accounted
> in qgroup. If so, there is a window we can exceed the quota limit when
> bytes is in space_info->reserved.
>
> Example:
> 	# btrfs quota enable /mnt
> 	# btrfs qgroup limit -e 10M /mnt
> 	# for((i=0;i<20;i++));do fallocate -l 1M /mnt/data$i; done
> 	# sync
> 	# btrfs qgroup show -pcre /mnt
> qgroupid rfer     excl     max_rfer max_excl parent  child
> -------- ----     ----     -------- -------- ------  -----
> 0/5      20987904 20987904 0        10485760 ---     ---
>
> qg->excl is 20987904 larger than max_excl 10485760.
>
> This patch introduce a new counter named may_use to qgroup, then
> there are three counters in qgroup to account bytes in space_info
> as below.
> space_info->bytes_may_use --- space_info->reserved --- space_info->used.
> qgroup->may_use           --- qgroup->reserved     --- qgroup->excl
>
> With this patch applied:
> 	# btrfs quota enable /mnt
> 	# btrfs qgroup limit -e 10M /mnt
> 	# for((i=0;i<20;i++));do fallocate -l 1M /mnt/data$i; done
> fallocate: /mnt/data9: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data10: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data11: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data12: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data13: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data14: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data15: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data16: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data17: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data18: fallocate failed: Disk quota exceeded
> fallocate: /mnt/data19: fallocate failed: Disk quota exceeded
> 	# sync
> 	# btrfs qgroup show -pcre /mnt
> qgroupid rfer    excl    max_rfer max_excl parent  child
> -------- ----    ----    -------- -------- ------  -----
> 0/5      9453568 9453568 0        10485760 ---     ---
>
> Reported-by: Cyril SCETBON <cyril.scetbon@free.fr>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/extent-tree.c | 25 ++++++++++++++++++-
>   fs/btrfs/inode.c       | 22 +++++++++++++++-
>   fs/btrfs/qgroup.c      | 68 +++++++++++++++++++++++++++++++++++++++++++++++---
>   fs/btrfs/qgroup.h      |  4 +++
>   4 files changed, 113 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 014b7f2..9eaf268 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5500,8 +5500,13 @@ static int pin_down_extent(struct btrfs_root *root,
>
>   	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
>   			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
> -	if (reserved)
> +	if (reserved) {
> +		if (root->fs_info->quota_enabled)

You already have this check in btrfs_qgroup_update_reserved_bytes, just 
call it unconditionally everywhere in this patch.  Otherwise this looks 
good, thanks,

Josef
