Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:30284 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbeGZIhk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 04:37:40 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 32BB0AC00BE
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 16:22:05 +0900 (JST)
Subject: Re: [PATCH] btrfs: qgroup: Auto kick in rescan if qgroup tree is
 initialized without rescan initialized
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180726065900.8469-1-wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <feefe6a2-c1ac-fa8e-85d0-e8c039eb6ebd@jp.fujitsu.com>
Date: Thu, 26 Jul 2018 16:21:49 +0900
MIME-Version: 1.0
In-Reply-To: <20180726065900.8469-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/07/26 15:59, Qu Wenruo wrote:
> Under certain case, btrfs/166 could cause power loss just after quota
> tree initialized but rescan not kicked in.
> 
> In this case, since flags of qgroup status item is just ON |
> INCONSISTENT, without RESCAN flag, rescan won't be kicked in in next
> mount.
> 
> Now kick in rescan automatically for such situation, so user won't need
> to do rescan manually.

How about setting all of BTRFS_QGROUP_STATUS_FLAG_ON/INCONSISTENT/RESCAN
at first place and calling qgroup_rescan_init(fs_info, 0, 0) 
(currently it is (fs_info, 0, 1)) in btrfs_quota_enable()?

I think with this approach, current btrfs-progs can work as expected too.

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c25dc47210a3..e62598fc354f 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -392,6 +392,17 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
>  			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
>  									  ptr);
>  			rescan_progress = btrfs_qgroup_status_rescan(l, ptr);
> +
> +			/*
> +			 * Qgroup is enabled but rescan hans't kicked in and
> +			 * power loss happened, kick rescan in
> +			 */
> +			if (rescan_progress == 0 &&
> +			    (BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
> +			     BTRFS_QGROUP_STATUS_FLAG_ON) ==
> +			    fs_info->qgroup_flags)
> +				fs_info->qgroup_flags |=
> +					BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>  			goto next1;
>  		}
>  
> 

