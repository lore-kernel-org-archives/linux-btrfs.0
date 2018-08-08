Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:52174 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbeHHKAH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2018 06:00:07 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D909BAC015D
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Aug 2018 16:41:33 +0900 (JST)
Subject: Re: [PATCH] btrfs: qgroup: Don't populating excl numbers for snapshot
 src if it belongs to other qgroups
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180808060409.20048-1-wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <f6b41cc5-6827-4f6d-e8b5-ef5c3963293f@jp.fujitsu.com>
Date: Wed, 8 Aug 2018 16:41:08 +0900
MIME-Version: 1.0
In-Reply-To: <20180808060409.20048-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/08 15:04, Qu Wenruo wrote:
> When quota is enabled and we do a snapshot, we just update the 'excl'
> number of both snapshot src and dst to src's 'rfer' - nodesize.
> 
> It's a quick hack to avoid quota rescan every time we create a snapshot
> and it works if src doesn't belong to other qgroups.
> 
> But if we have higher level qgroups, such behavior only works for level
> 0 qgroups, and higher level qgroups don't get update, thus making qgroup
> number inconsistent.
> 
> The problem of updating higher level qgroup numbers is, it's way to
> complex.
> 
> Under the following case, it's pretty simple: (src is 257, dst is 258)
> 0/257 - 1/0, 0/258.
> 
> In this case, we only need to modify 1/0 to reduce its 'excl'
> 
> But under the following case, it will go out of control:
> 
> 0/257 - 1/0, 0/258 - 1/1 (using -i option), 1/0 - 2/0, 1/1 - 2/0.
> 
> So to make it simple, if snapshot src has higher level qgroups, just
> mark qgroup inconsistent and let later rescan to do its job.
> 
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index ec4351fd7537..2b3d2dd1b735 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2298,6 +2298,22 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>  		if (!srcgroup)
>  			goto unlock;
>  
> +		/*
> +		 * If snapshot source is belonging to high level qgroups, it
> +		 * will be a more complex to hack the numbers.
> +		 * E.g. source is 257, snapshot is 258:
> +		 * 0/257 - 1/0, creating snapshot 258 will need to update 1/0
> +		 * It's too complex when higher level qgroup is involved.
> +		 * Mark qgroup inconsistent for later rescan
> +		 */
> +		if (!list_empty(&srcgroup->groups)) {
> +			btrfs_info_rl(fs_info,
> +"src qgroup 0/%llu belongs to higher level qgroup, creating snapshot for it need qgroup rescan",
> +				      srcid);
> +			fs_info->qgroup_flags |=
> +				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +			goto unlock;
> +		}
>  		/*
>  		 * We call inherit after we clone the root in order to make sure
>  		 * our counts don't go crazy, so at this point the only
> 

Thanks for the quick fix.
Tested-by/Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

However there is still another problem about removing relation:

(4.18-rc7 with above patch)
$ mkfs.btrfs -fq $DEV
$ mount $DEV /mnt

$ btrfs quota enable /mnt
$ btrfs qgroup create 1/0 /mnt
$ btrfs sub create /mnt/sub
$ btrfs qgroup assign 0/257 1/0 /mnt

$ dd if=/dev/urandom of=/mnt/sub/file bs=1k count=1000
$ btrfs sub snap /mnt/sub /mnt/snap
$ dmesg | tail -n 1
BTRFS info (device sdb7): src qgroup 0/257 belongs to higher level qgroup,
 creating snapshot for it need qgroup rescan

$ btrfs quota rescan -w /mnt
$ btrfs qgroup show -pcre /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/257      1016.00KiB     16.00KiB         none         none 1/0     ---
0/258      1016.00KiB     16.00KiB         none         none ---     ---
1/0        1016.00KiB     16.00KiB         none         none ---     0/257
                          
so far so good, but:

$ btrfs qgroup remove 0/257 1/0 /mnt
WARNING: quotas may be inconsistent, rescan needed
$ btrfs quota rescan -w /mnt
$ btrfs qgroup show -pcre  /mnt
qgoupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/257      1016.00KiB     16.00KiB         none         none ---     ---
0/258      1016.00KiB     16.00KiB         none         none ---     ---
1/0        1016.00KiB     16.00KiB         none         none ---     ---
           ^^^^^^^^^^     ^^^^^^^^ not cleared

It seems some fix is needed for rescan too.

Thanks,
Misono

