Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52557 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbcFCOzC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 10:55:02 -0400
Subject: Re: [PATCH v10 17/21] btrfs: dedupe: Introduce interfaces to resume
 and cleanup dedupe info
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-18-git-send-email-quwenruo@cn.fujitsu.com>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <ff4d3485-7130-8cd3-50ed-518f1cba314f@fb.com>
Date: Fri, 3 Jun 2016 10:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <1459492512-31435-18-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/01/2016 02:35 AM, Qu Wenruo wrote:
> Since we will introduce a new on-disk based dedupe method, introduce new
> interfaces to resume previous dedupe setup.
>
> And since we introduce a new tree for status, also add disable handler
> for it.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c  | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/dedupe.h  |  13 ++++
>  fs/btrfs/disk-io.c |  25 ++++++-
>  fs/btrfs/disk-io.h |   1 +
>  4 files changed, 232 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index cfb7fea..a274c1c 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -21,6 +21,8 @@
>  #include "transaction.h"
>  #include "delayed-ref.h"
>  #include "qgroup.h"
> +#include "disk-io.h"
> +#include "locking.h"
>
>  struct inmem_hash {
>  	struct rb_node hash_node;
> @@ -102,10 +104,69 @@ static int init_dedupe_info(struct btrfs_dedupe_info **ret_info, u16 type,
>  	return 0;
>  }
>
> +static int init_dedupe_tree(struct btrfs_fs_info *fs_info,
> +			    struct btrfs_dedupe_info *dedupe_info)
> +{
> +	struct btrfs_root *dedupe_root;
> +	struct btrfs_key key;
> +	struct btrfs_path *path;
> +	struct btrfs_dedupe_status_item *status;
> +	struct btrfs_trans_handle *trans;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	trans = btrfs_start_transaction(fs_info->tree_root, 2);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}
> +	dedupe_root = btrfs_create_tree(trans, fs_info,
> +				       BTRFS_DEDUPE_TREE_OBJECTID);
> +	if (IS_ERR(dedupe_root)) {
> +		ret = PTR_ERR(dedupe_root);
> +		btrfs_abort_transaction(trans, fs_info->tree_root, ret);
> +		goto out;
> +	}
> +	dedupe_info->dedupe_root = dedupe_root;
> +
> +	key.objectid = 0;
> +	key.type = BTRFS_DEDUPE_STATUS_ITEM_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_insert_empty_item(trans, dedupe_root, path, &key,
> +				      sizeof(*status));
> +	if (ret < 0) {
> +		btrfs_abort_transaction(trans, fs_info->tree_root, ret);
> +		goto out;
> +	}
> +
> +	status = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +				struct btrfs_dedupe_status_item);
> +	btrfs_set_dedupe_status_blocksize(path->nodes[0], status,
> +					 dedupe_info->blocksize);
> +	btrfs_set_dedupe_status_limit(path->nodes[0], status,
> +			dedupe_info->limit_nr);
> +	btrfs_set_dedupe_status_hash_type(path->nodes[0], status,
> +			dedupe_info->hash_type);
> +	btrfs_set_dedupe_status_backend(path->nodes[0], status,
> +			dedupe_info->backend);
> +	btrfs_mark_buffer_dirty(path->nodes[0]);
> +out:
> +	btrfs_free_path(path);
> +	if (ret == 0)
> +		btrfs_commit_transaction(trans, fs_info->tree_root);

Still need to call btrfs_end_transaction() if we aborted to clean things 
up.  Thanks,

Josef
