Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:56813 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbeHIKAu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 06:00:50 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 69FA8AC00EB
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Aug 2018 16:37:11 +0900 (JST)
Subject: Re: [PATCH v2] btrfs: qgroup: Dirty all qgroups before rescan
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180809070857.7456-1-wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <c723f21b-fefc-cfb7-c4dc-705c910b5f35@jp.fujitsu.com>
Date: Thu, 9 Aug 2018 16:36:57 +0900
MIME-Version: 1.0
In-Reply-To: <20180809070857.7456-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/09 16:08, Qu Wenruo wrote:
> [BUG]
> In the following case, rescan won't zero out the number of qgroup 1/0:
> ------
> $ mkfs.btrfs -fq $DEV
> $ mount $DEV /mnt
> 
> $ btrfs quota enable /mnt
> $ btrfs qgroup create 1/0 /mnt
> $ btrfs sub create /mnt/sub
> $ btrfs qgroup assign 0/257 1/0 /mnt
> 
> $ dd if=/dev/urandom of=/mnt/sub/file bs=1k count=1000
> $ btrfs sub snap /mnt/sub /mnt/snap
> $ btrfs quota rescan -w /mnt
> $ btrfs qgroup show -pcre /mnt
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257      1016.00KiB     16.00KiB         none         none 1/0     ---
> 0/258      1016.00KiB     16.00KiB         none         none ---     ---
> 1/0        1016.00KiB     16.00KiB         none         none ---     0/257
> 
> so far so good, but:
> 
> $ btrfs qgroup remove 0/257 1/0 /mnt
> WARNING: quotas may be inconsistent, rescan needed
> $ btrfs quota rescan -w /mnt
> $ btrfs qgroup show -pcre  /mnt
> qgoupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257      1016.00KiB     16.00KiB         none         none ---     ---
> 0/258      1016.00KiB     16.00KiB         none         none ---     ---
> 1/0        1016.00KiB     16.00KiB         none         none ---     ---
>            ^^^^^^^^^^     ^^^^^^^^ not cleared
> ------
> 
> [CAUSE]
> Before rescan we call qgroup_rescan_zero_tracking() to zero out all
> qgroups' accounting numbers.
> 
> However we don't mark all qgroups dirty, but rely on rescan to mark
> qgroups dirty.
> 
> If we have any high level qgroup but without any child (orphan group), it
> won't be marked dirty during rescan, since we can not reach that qgroup.
> 
> This will cause QGROUP_INFO items of orphan qgroups never get updated in
> quota tree, thus their numbers will stay the same in "btrfs qgroup show"
> output.
> 
> [FIX]
> Just mark all qgroups dirty in qgroup_rescan_zero_tracking(), so even we
> have orphan qgroups their QGROUP_INFO items will still get updated during
> rescan.
> 
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Fix some grammar errors in commit message.
> ---
>  fs/btrfs/qgroup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 48c1c3e7baf3..5a5372b33d96 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2864,6 +2864,7 @@ qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)
>  		qgroup->rfer_cmpr = 0;
>  		qgroup->excl = 0;
>  		qgroup->excl_cmpr = 0;
> +		qgroup_dirty(fs_info, qgroup);
>  	}
>  	spin_unlock(&fs_info->qgroup_lock);
>  }
> 
Yes, this and previous patch
  [PATCH] btrfs: qgroup: Don't populating excl numbers for snapshot src if it belongs to other qgroups
resolves the problem I see.

So, this will reset all the qgroup items not rescanned in first transaction commit
by btrfs_run_qgroups(), but I don't think it is a problem.

Tested-by/Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Thanks,
Misono

