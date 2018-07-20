Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727378AbeGTLYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 07:24:54 -0400
Date: Fri, 20 Jul 2018 12:37:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix bug of chunk type check
Message-ID: <20180720103709.GZ26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1532063858-32620-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1532063858-32620-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 01:17:38PM +0800, Gu Jinxiang wrote:
> chunk type BTRFS_BLOCK_GROUP_METADATA and BTRFS_BLOCK_GROUP_DATA
> should not be set in a non-mixed chunk at the same time.
> 
> Since BTRFS_BLOCK_GROUP_METADATA is 0x4 and BTRFS_BLOCK_GROUP_DATA is 0x1,
> BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA will be 0x0,
> so we should judge type is one of them separately.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Folded to the patch and updated the newly added %llu to 0x%llx and
switched mixed to bool, thanks.

The final version, for the record:

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6305,6 +6305,8 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
        u16 num_stripes;
        u16 sub_stripes;
        u64 type;
+       u64 features;
+       bool mixed = false;

        length = btrfs_chunk_length(leaf, chunk);
        stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
@@ -6343,6 +6345,32 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
                          btrfs_chunk_type(leaf, chunk));
                return -EIO;
        }
+
+       if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
+               btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
+               return -EIO;
+       }
+
+       if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
+           (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
+               btrfs_err(fs_info,
+                       "system chunk with data or metadata type: 0x%llx", type);
+               return -EIO;
+       }
+
+       features = btrfs_super_incompat_flags(fs_info->super_copy);
+       if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+               mixed = true;
+
+       if (!mixed) {
+               if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
+                   (type & BTRFS_BLOCK_GROUP_DATA)) {
+                       btrfs_err(fs_info,
+                       "mixed chunk type in non-mixed mode: 0x%llx", type);
+                       return -EIO;
+               }
+       }
+
        if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
            (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
            (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) |
