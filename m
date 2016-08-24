Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21434 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbcHXKYI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 06:24:08 -0400
Subject: Re: [PATCH 01/13] btrfs-progs: pass OPEN_CTREE flags as unsigned
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
 <1471947917-5324-2-git-send-email-dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <1517b296-770a-983c-bbbf-0cb5520173c4@oracle.com>
Date: Wed, 24 Aug 2016 18:24:44 +0800
MIME-Version: 1.0
In-Reply-To: <1471947917-5324-2-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



All patches looks good. nice cleanups.


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks.


On 08/23/2016 06:25 PM, David Sterba wrote:
> As we're passing a set of flags, the enum type is not appropriate.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  btrfstune.c  |  2 +-
>  cmds-check.c |  2 +-
>  disk-io.c    | 12 ++++++------
>  disk-io.h    |  8 ++++----
>  4 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/btrfstune.c b/btrfstune.c
> index ac559fb9e3de..93b25e8cece8 100644
> --- a/btrfstune.c
> +++ b/btrfstune.c
> @@ -389,7 +389,7 @@ static void print_usage(void)
>  int main(int argc, char *argv[])
>  {
>  	struct btrfs_root *root;
> -	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_WRITES;
> +	unsigned ctree_flags = OPEN_CTREE_WRITES;
>  	int success = 0;
>  	int total = 0;
>  	int seeding_flag = 0;
> diff --git a/cmds-check.c b/cmds-check.c
> index fc15ce98f4bb..0ddfd24a4d8e 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -11178,7 +11178,7 @@ int cmd_check(int argc, char **argv)
>  	int readonly = 0;
>  	int qgroup_report = 0;
>  	int qgroups_repaired = 0;
> -	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
> +	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
>
>  	while(1) {
>  		int c;
> diff --git a/disk-io.c b/disk-io.c
> index 3647ecca7e63..279e38b74c39 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -932,7 +932,7 @@ static int find_best_backup_root(struct btrfs_super_block *super)
>  }
>
>  static int setup_root_or_create_block(struct btrfs_fs_info *fs_info,
> -				      enum btrfs_open_ctree_flags flags,
> +				      unsigned flags,
>  				      struct btrfs_root *info_root,
>  				      u64 objectid, char *str)
>  {
> @@ -961,7 +961,7 @@ static int setup_root_or_create_block(struct btrfs_fs_info *fs_info,
>  }
>
>  int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
> -			  enum btrfs_open_ctree_flags flags)
> +			  unsigned flags)
>  {
>  	struct btrfs_super_block *sb = fs_info->super_copy;
>  	struct btrfs_root *root;
> @@ -1217,7 +1217,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  					     u64 sb_bytenr,
>  					     u64 root_tree_bytenr,
>  					     u64 chunk_root_bytenr,
> -					     enum btrfs_open_ctree_flags flags)
> +					     unsigned flags)
>  {
>  	struct btrfs_fs_info *fs_info;
>  	struct btrfs_super_block *disk_super;
> @@ -1323,7 +1323,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
>  					 u64 sb_bytenr, u64 root_tree_bytenr,
>  					 u64 chunk_root_bytenr,
> -					 enum btrfs_open_ctree_flags flags)
> +					 unsigned flags)
>  {
>  	int fp;
>  	int ret;
> @@ -1356,7 +1356,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
>  }
>
>  struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
> -			      enum btrfs_open_ctree_flags flags)
> +			      unsigned flags)
>  {
>  	struct btrfs_fs_info *info;
>
> @@ -1371,7 +1371,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
>  }
>
>  struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
> -				 enum btrfs_open_ctree_flags flags)
> +				 unsigned flags)
>  {
>  	struct btrfs_fs_info *info;
>
> diff --git a/disk-io.h b/disk-io.h
> index d6fb9822614f..9ebb2366b933 100644
> --- a/disk-io.h
> +++ b/disk-io.h
> @@ -103,7 +103,7 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
>  struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
>  int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
>  int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
> -			  enum btrfs_open_ctree_flags flags);
> +			  unsigned flags);
>  void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
>  void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
>  int btrfs_scan_fs_devices(int fd, const char *path,
> @@ -113,13 +113,13 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
>  			  u64 chunk_root_bytenr);
>
>  struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
> -			      enum btrfs_open_ctree_flags flags);
> +			      unsigned flags);
>  struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
> -				 enum btrfs_open_ctree_flags flags);
> +				 unsigned flags);
>  struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
>  					 u64 sb_bytenr, u64 root_tree_bytenr,
>  					 u64 chunk_root_bytenr,
> -					 enum btrfs_open_ctree_flags flags);
> +					 unsigned flags);
>  int close_ctree_fs_info(struct btrfs_fs_info *fs_info);
>  static inline int close_ctree(struct btrfs_root *root)
>  {
>
