Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761564AbbA1UoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 15:44:06 -0500
Date: Wed, 28 Jan 2015 19:16:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 02/10] btrfs-progs: Add support to suppress tree block
 csum error output.
Message-ID: <20150128181641.GH3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1421649912-14539-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421649912-14539-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 19, 2015 at 02:45:04PM +0800, Qu Wenruo wrote:
> Add new open ctree flag OPEN_CTREE_SUPPRESS_ERROR to suppress tree block
> csum error output.
> 
> @@ -996,6 +996,7 @@ struct btrfs_fs_info {
>  	unsigned int on_restoring:1;
>  	unsigned int is_chunk_recover:1;
>  	unsigned int quota_enabled:1;
> +	unsigned int suppress_error:1;

This is confusing, it suppresses only csum errors.

> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -42,7 +42,8 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
>  	struct btrfs_fs_devices *fs_devices;
>  	int ret = 1;
>  
> -	if (buf->start != btrfs_header_bytenr(buf)) {
> +	if (buf->start != btrfs_header_bytenr(buf) &&
> +	    !root->fs_info->suppress_error) {

Though here it's used to skip block start mismatch error. But looking at
the rest of the code, it's better to put this check to the caller and
keep check_tree_block as is.

>  		printk("Check tree block failed, want=%Lu, have=%Lu\n",
>  		       buf->start, btrfs_header_bytenr(buf));
>  		return ret;
> @@ -118,6 +119,8 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
>  {
>  	u16 csum_size =
>  		btrfs_super_csum_size(root->fs_info->super_copy);
> +	if (verify && root->fs_info->suppress_error)
> +		return verify_tree_block_csum_silent(buf, csum_size);
>  	return csum_tree_block_size(buf, csum_size, verify);
>  }
>  
> @@ -282,10 +285,13 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
>  			return eb;
>  		}
>  		if (ignore) {
> -			if (check_tree_block(root, eb))
> -				printk("read block failed check_tree_block\n");
> -			else
> -				printk("Csum didn't match\n");
> +			if (check_tree_block(root, eb)) {
> +				if (!root->fs_info->suppress_error)
> +					printk("read block failed check_tree_block\n");
> +			} else {
> +				if (!root->fs_info->suppress_error)
> +					printk("Csum didn't match\n");
> +			}
>  			break;
>  		}
>  		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
> @@ -1112,6 +1118,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  	}
>  	if (flags & OPEN_CTREE_RESTORE)
>  		fs_info->on_restoring = 1;
> +	if (flags & OPEN_CTREE_SUPPRESS_ERROR)
> +		fs_info->suppress_error = 1;
>  
>  	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
>  				    (flags & OPEN_CTREE_RECOVER_SUPER));
> diff --git a/disk-io.h b/disk-io.h
> index e12870e..90ede6b 100644
> --- a/disk-io.h
> +++ b/disk-io.h
> @@ -33,6 +33,7 @@ enum btrfs_open_ctree_flags {
>  	OPEN_CTREE_RESTORE		= (1 << 4),
>  	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
>  	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
> +	OPEN_CTREE_SUPPRESS_ERROR	= (1 << 7), /* Suppress csum error */
>  };
>  
>  static inline u64 btrfs_sb_offset(int mirror)
