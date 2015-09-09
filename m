Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:46214 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbIIABq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 20:01:46 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 12658AC0290
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2015 09:01:43 +0900 (JST)
Subject: Re: [PATCH 01/19] btrfs: qgroup: New function declaration for new
 reserve implement
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1441702615-18333-2-git-send-email-quwenruo@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <55EF76D3.6000306@jp.fujitsu.com>
Date: Wed, 9 Sep 2015 09:01:23 +0900
MIME-Version: 1.0
In-Reply-To: <1441702615-18333-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu,

On 2015/09/08 17:56, Qu Wenruo wrote:
> Add new structures and functions for new qgroup reserve implement dirty
> phase.
> Which will focus on avoiding over-reserve as in that case, which means
> for already reserved dirty space range, we won't reserve space again.
> 
> This patch adds the needed structure declaration and comments.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/btrfs_inode.h |  4 ++++
>   fs/btrfs/qgroup.c      | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/qgroup.h      |  3 +++
>   3 files changed, 65 insertions(+)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 81220b2..e3ece65 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -24,6 +24,7 @@
>   #include "extent_io.h"
>   #include "ordered-data.h"
>   #include "delayed-inode.h"
> +#include "qgroup.h"
>   
>   /*
>    * ordered_data_close is set by truncate when a file that used
> @@ -195,6 +196,9 @@ struct btrfs_inode {
>   	struct timespec i_otime;
>   
>   	struct inode vfs_inode;
> +
> +	/* qgroup dirty map for data space reserve */
> +	struct btrfs_qgroup_data_rsv_map *qgroup_rsv_map;
>   };
>   
>   extern unsigned char btrfs_filetype_table[];
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index e9ace09..561c36d 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -91,6 +91,64 @@ struct btrfs_qgroup {
>   	u64 new_refcnt;
>   };
>   
> +/*
> + * Record one range of reserved space.
> + */
> +struct data_rsv_range {
> +	struct rb_node node;
> +	u64 start;
> +	u64 len;
> +};
> +
> +/*
> + * Record per inode reserved range.
> + * This is mainly used to resolve reserved space leaking problem.
> + * One of the cause is the mismatch with reserve and free.
> + *
> + * New qgroup will handle reserve in two phase.
> + * 1) Dirty phase.
> + *    Pages are just marked dirty, but not written to disk.
> + * 2) Flushed phase
> + *    Pages are written to disk, but transaction is not committed yet.
> + *

> + * At Diryt phase, we only need to focus on avoiding over-reserve.

         dirty

> + *
> + * The idea is like below.
> + * 1) Write [0,8K)
> + * 0	4K	8K	12K	16K
> + * |////////////|
> + * Reserve +8K, total reserved: 8K
> + *
> + * 2) Write [0,4K)
> + * 0	4K	8K	12K	16K
> + * |////////////|
> + * Reserve 0, total reserved 8K
> + *
> + * 3) Write [12K,16K)
> + * 0	4K	8K	12K	16K

> + * |////////////|	|///////|
> + * Reserve +4K, tocal reserved 12K

                   total

> + *
> + * 4) Flush [0,8K)
> + * Can happen without commit transaction, like fallocate will trigger the
> + * write.
> + * 0	4K	8K	12K	16K
> + *			|///////|

> + * Reserve 0, tocal reserved 12K

                 total

Thanks,
Tsutomu

> + * As the extent is written to disk, not dirty any longer, the range get
> + * removed.
> + * But as its delayed_refs is not run, its reserved space will not be freed.
> + * And things continue to Flushed phase.
> + *
> + * By this method, we can avoid over-reserve, which will lead to reserved
> + * space leak.
> + */
> +struct btrfs_qgroup_data_rsv_map {
> +	struct rb_root root;
> +	u64 reserved;
> +	spinlock_t lock;
> +};
> +
>   static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg, u64 seq,
>   					   int mod)
>   {
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 6387dcf..2f863a4 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -33,6 +33,9 @@ struct btrfs_qgroup_extent_record {
>   	struct ulist *old_roots;
>   };
>   
> +/* For per-inode dirty range reserve */
> +struct btrfs_qgroup_data_rsv_map;
> +
>   int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>   		       struct btrfs_fs_info *fs_info);
>   int btrfs_quota_disable(struct btrfs_trans_handle *trans,
> 


