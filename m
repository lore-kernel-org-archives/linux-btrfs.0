Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932643AbdDGMA2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 08:00:28 -0400
Date: Fri, 7 Apr 2017 14:00:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 8/9] btrfs: qgroup: Introduce extent changeset for
 qgroup reserve functions
Message-ID: <20170407120025.GT4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-9-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313075216.5125-9-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:52:15PM +0800, Qu Wenruo wrote:
> @@ -3355,12 +3355,14 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
>  	struct btrfs_fs_info *fs_info = block_group->fs_info;
>  	struct btrfs_root *root = fs_info->tree_root;
>  	struct inode *inode = NULL;
> +	struct extent_changeset data_reserved;

Size of this structure is 40 bytes, and it's being added to many
functions. This will be noticeable on the stack consumption.

-extent-tree.c:btrfs_check_data_free_space              40 static
-extent-tree.c:cache_save_setup                         96 static
+extent-tree.c:btrfs_check_data_free_space              48 static
+extent-tree.c:cache_save_setup                         136 static
-file.c:__btrfs_buffered_write                          192 static
+file.c:__btrfs_buffered_write                          232 static
-file.c:btrfs_fallocate                                 208 static
+file.c:btrfs_fallocate                                 248 static
-inode-map.c:btrfs_save_ino_cache                       112 static
+inode-map.c:btrfs_save_ino_cache                       152 static
-inode.c:btrfs_direct_IO                                128 static
+inode.c:btrfs_direct_IO                                176 static
-inode.c:btrfs_writepage_fixup_worker                   88 static
+inode.c:btrfs_writepage_fixup_worker                   128 static
-inode.c:btrfs_truncate_block                           136 static
+inode.c:btrfs_truncate_block                           176 static
-inode.c:btrfs_page_mkwrite                             112 static
+inode.c:btrfs_page_mkwrite                             152 static
+ioctl.c:cluster_pages_for_defrag                       200 static
-ioctl.c:btrfs_defrag_file                              312 static
+ioctl.c:btrfs_defrag_file                              232 static
-qgroup.c:btrfs_qgroup_reserve_data                     136 static
+qgroup.c:btrfs_qgroup_reserve_data                     128 static
-relocation.c:prealloc_file_extent_cluster              152 static
+relocation.c:prealloc_file_extent_cluster              192 static

There are generic functions so this will affect non-qgroup workloads as
well. So there need to be a dynamic allocation (which would add another
point of failure), or reworked in another way.
