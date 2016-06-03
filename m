Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52111 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752749AbcFCPD7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 11:03:59 -0400
Subject: Re: [PATCH v10 20/21] btrfs: dedupe: Add support for adding hash for
 on-disk backend
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-21-git-send-email-quwenruo@cn.fujitsu.com>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <4a21f07a-3f72-9d01-e775-6014b6137b9e@fb.com>
Date: Fri, 3 Jun 2016 11:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <1459492512-31435-21-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/01/2016 02:35 AM, Qu Wenruo wrote:
> Now on-disk backend can add hash now.
>
> Since all needed on-disk backend functions are added, also allow on-disk
> backend to be used, by changing DEDUPE_BACKEND_COUNT from 1(inmemory
> only) to 2 (inmemory + ondisk).
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/dedupe.h |  3 +-
>  2 files changed, 84 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index 7c5d58a..1f0178e 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -437,6 +437,87 @@ out:
>  	return 0;
>  }
>
> +static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
> +				struct btrfs_dedupe_info *dedupe_info,
> +				struct btrfs_path *path, u64 bytenr,
> +				int prepare_del);
> +static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
> +			      u64 *bytenr_ret, u32 *num_bytes_ret);
> +static int ondisk_add(struct btrfs_trans_handle *trans,
> +		      struct btrfs_dedupe_info *dedupe_info,
> +		      struct btrfs_dedupe_hash *hash)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_root *dedupe_root = dedupe_info->dedupe_root;
> +	struct btrfs_key key;
> +	u64 hash_offset;
> +	u64 bytenr;
> +	u32 num_bytes;
> +	int hash_len = btrfs_dedupe_sizes[dedupe_info->hash_type];
> +	int ret;
> +
> +	if (WARN_ON(hash_len <= 8 ||
> +	    !IS_ALIGNED(hash->bytenr, dedupe_root->sectorsize)))
> +		return -EINVAL;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	mutex_lock(&dedupe_info->lock);
> +
> +	ret = ondisk_search_bytenr(NULL, dedupe_info, path, hash->bytenr, 0);
> +	if (ret < 0)
> +		goto out;
> +	if (ret > 0) {
> +		ret = 0;
> +		goto out;
> +	}
> +	btrfs_release_path(path);
> +
> +	ret = ondisk_search_hash(dedupe_info, hash->hash, &bytenr, &num_bytes);
> +	if (ret < 0)
> +		goto out;
> +	/* Same hash found, don't re-add to save dedupe tree space */
> +	if (ret > 0) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	/* Insert hash->bytenr item */
> +	memcpy(&key.objectid, hash->hash + hash_len - 8, 8);

No magic numbers please.  Thanks,

Josef
