Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34459 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaGJBrh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 21:47:37 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 2FDB13EE0C2
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 10:47:36 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 296D2AC0A23
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 10:47:35 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id C6BCA1DB8040
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 10:47:34 +0900 (JST)
Message-ID: <53BDF0AD.7030006@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 10:47:25 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Kevin Brandstatter <icarusthecow@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Remove unused parameter "name" from btrfs_qgroup_create
References: <53B76E71.3010709@gmail.com>
In-Reply-To: <53B76E71.3010709@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/05 12:18), Kevin Brandstatter wrote:
> in btrfs_qgruop_create a fourth parameter "name" exists.
> however this parameter is not used anywhere in the function
> the only other place this function is called is ioctl and the call
> passes NULL as the name paremeter which would seem to indicate its
> lack of necessity.
>
> Signed-off-by: Kevin Brandstatter <kjbrandstatter@gmail.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   fs/btrfs/ioctl.c  | 3 +--
>   fs/btrfs/qgroup.c | 2 +-
>   fs/btrfs/qgroup.h | 3 +--
>   3 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 2a99f49..4b33d08 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4709,8 +4709,7 @@ static long btrfs_ioctl_qgroup_create(struct file
> *file, void __user *arg)
>
>       /* FIXME: check if the IDs really exist */
>       if (sa->create) {
> -        ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid,
> -                      NULL);
> +        ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid);
>       } else {
>           ret = btrfs_remove_qgroup(trans, root->fs_info, sa->qgroupid);
>       }
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 98cb6b2..3d1c8be 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1091,7 +1091,7 @@ out:
>   }
>
>   int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
> -            struct btrfs_fs_info *fs_info, u64 qgroupid, char *name)
> +            struct btrfs_fs_info *fs_info, u64 qgroupid)
>   {
>       struct btrfs_root *quota_root;
>       struct btrfs_qgroup *qgroup;
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 5952ff1..31403ca 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -69,8 +69,7 @@ int btrfs_add_qgroup_relation(struct
> btrfs_trans_handle *trans,
>   int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
>                     struct btrfs_fs_info *fs_info, u64 src, u64 dst);
>   int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
> -            struct btrfs_fs_info *fs_info, u64 qgroupid,
> -            char *name);
> +            struct btrfs_fs_info *fs_info, u64 qgroupid);
>   int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
>                     struct btrfs_fs_info *fs_info, u64 qgroupid);
>   int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
>

