Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58098 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751713AbcF0CRF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 22:17:05 -0400
Subject: Re: [PATCH 04/31] btrfs: tests, move initialization into tests/
To: <jeffm@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-5-git-send-email-jeffm@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ad05794a-c417-ec49-d1b9-22eda06e141e@cn.fujitsu.com>
Date: Mon, 27 Jun 2016 10:17:02 +0800
MIME-Version: 1.0
In-Reply-To: <1466806524-27508-5-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/25/2016 06:14 AM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>
> We have all these stubs that only exist because they're called from
> btrfs_run_sanity_tests, which is a static inside super.c.  Let's just
> move it all into tests/btrfs-tests.c and only have one stub.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/super.c             | 43 ----------------------------------------
>  fs/btrfs/tests/btrfs-tests.c | 47 ++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/tests/btrfs-tests.h | 35 +++------------------------------
>  3 files changed, 48 insertions(+), 77 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a7b9a15..d8e48bb 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2323,49 +2323,6 @@ static void btrfs_print_mod_info(void)
>  			btrfs_crc32c_impl());
>  }
>
> -static int btrfs_run_sanity_tests(void)
> -{
> -	int ret, i;
> -	u32 sectorsize, nodesize;
> -	u32 test_sectorsize[] = {
> -		PAGE_SIZE,
> -	};
> -	ret = btrfs_init_test_fs();
> -	if (ret)
> -		return ret;
> -	for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
> -		sectorsize = test_sectorsize[i];
> -		for (nodesize = sectorsize;
> -		     nodesize <= BTRFS_MAX_METADATA_BLOCKSIZE;
> -		     nodesize <<= 1) {
> -			pr_info("BTRFS: selftest: sectorsize: %u  nodesize: %u\n",
> -				sectorsize, nodesize);
> -			ret = btrfs_test_free_space_cache(sectorsize, nodesize);
> -			if (ret)
> -				goto out;
> -			ret = btrfs_test_extent_buffer_operations(sectorsize,
> -				nodesize);
> -			if (ret)
> -				goto out;
> -			ret = btrfs_test_extent_io(sectorsize, nodesize);
> -			if (ret)
> -				goto out;
> -			ret = btrfs_test_inodes(sectorsize, nodesize);
> -			if (ret)
> -				goto out;
> -			ret = btrfs_test_qgroups(sectorsize, nodesize);
> -			if (ret)
> -				goto out;
> -			ret = btrfs_test_free_space_tree(sectorsize, nodesize);
> -			if (ret)
> -				goto out;
> -		}
> -	}
> -out:
> -	btrfs_destroy_test_fs();
> -	return ret;
> -}
> -
>  static int __init init_btrfs_fs(void)
>  {
>  	int err;
> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
> index 10eb249..d90c951 100644
> --- a/fs/btrfs/tests/btrfs-tests.c
> +++ b/fs/btrfs/tests/btrfs-tests.c
> @@ -54,7 +54,7 @@ struct inode *btrfs_new_test_inode(void)
>  	return new_inode(test_mnt->mnt_sb);
>  }
>
> -int btrfs_init_test_fs(void)
> +static int btrfs_init_test_fs(void)
>  {
>  	int ret;
>
> @@ -73,7 +73,7 @@ int btrfs_init_test_fs(void)
>  	return 0;
>  }
>
> -void btrfs_destroy_test_fs(void)
> +static void btrfs_destroy_test_fs(void)
>  {
>  	kern_unmount(test_mnt);
>  	unregister_filesystem(&test_type);
> @@ -220,3 +220,46 @@ void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans)
>  	INIT_LIST_HEAD(&trans->qgroup_ref_list);
>  	trans->type = __TRANS_DUMMY;
>  }
> +
> +int btrfs_run_sanity_tests(void)
> +{
> +	int ret, i;
> +	u32 sectorsize, nodesize;
> +	u32 test_sectorsize[] = {
> +		PAGE_SIZE,
> +	};
> +	ret = btrfs_init_test_fs();
> +	if (ret)
> +		return ret;
> +	for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
> +		sectorsize = test_sectorsize[i];
> +		for (nodesize = sectorsize;
> +		     nodesize <= BTRFS_MAX_METADATA_BLOCKSIZE;
> +		     nodesize <<= 1) {
> +			pr_info("BTRFS: selftest: sectorsize: %u  nodesize: %u\n",
> +				sectorsize, nodesize);
> +			ret = btrfs_test_free_space_cache(sectorsize, nodesize);
> +			if (ret)
> +				goto out;
> +			ret = btrfs_test_extent_buffer_operations(sectorsize,
> +				nodesize);
> +			if (ret)
> +				goto out;
> +			ret = btrfs_test_extent_io(sectorsize, nodesize);
> +			if (ret)
> +				goto out;
> +			ret = btrfs_test_inodes(sectorsize, nodesize);
> +			if (ret)
> +				goto out;
> +			ret = btrfs_test_qgroups(sectorsize, nodesize);
> +			if (ret)
> +				goto out;
> +			ret = btrfs_test_free_space_tree(sectorsize, nodesize);
> +			if (ret)
> +				goto out;
> +		}
> +	}
> +out:
> +	btrfs_destroy_test_fs();
> +	return ret;
> +}
> diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
> index 66fb6b70..e7d364f 100644
> --- a/fs/btrfs/tests/btrfs-tests.h
> +++ b/fs/btrfs/tests/btrfs-tests.h
> @@ -20,20 +20,19 @@
>  #define __BTRFS_TESTS
>
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +int btrfs_run_sanity_tests(void);
>
>  #define test_msg(fmt, ...) pr_info("BTRFS: selftest: " fmt, ##__VA_ARGS__)
>
>  struct btrfs_root;
>  struct btrfs_trans_handle;
>
> -int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize);
>  int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize);
> +int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize);

Anything special for the line move?
Otherwise it looks good for me.

Thanks,
Qu
>  int btrfs_test_extent_io(u32 sectorsize, u32 nodesize);
>  int btrfs_test_inodes(u32 sectorsize, u32 nodesize);
>  int btrfs_test_qgroups(u32 sectorsize, u32 nodesize);
>  int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize);
> -int btrfs_init_test_fs(void);
> -void btrfs_destroy_test_fs(void);
>  struct inode *btrfs_new_test_inode(void);
>  struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void);
>  void btrfs_free_dummy_root(struct btrfs_root *root);
> @@ -42,35 +41,7 @@ btrfs_alloc_dummy_block_group(unsigned long length, u32 sectorsize);
>  void btrfs_free_dummy_block_group(struct btrfs_block_group_cache *cache);
>  void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans);
>  #else
> -static inline int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
> -{
> -	return 0;
> -}
> -static inline int btrfs_test_extent_buffer_operations(u32 sectorsize,
> -	u32 nodesize)
> -{
> -	return 0;
> -}
> -static inline int btrfs_init_test_fs(void)
> -{
> -	return 0;
> -}
> -static inline void btrfs_destroy_test_fs(void)
> -{
> -}
> -static inline int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
> -{
> -	return 0;
> -}
> -static inline int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
> -{
> -	return 0;
> -}
> -static inline int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
> -{
> -	return 0;
> -}
> -static inline int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
> +static inline int btrfs_run_sanity_tests(void)
>  {
>  	return 0;
>  }
>


