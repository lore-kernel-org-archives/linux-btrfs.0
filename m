Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:40854
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756186AbdD1F5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 01:57:19 -0400
Date: Fri, 28 Apr 2017 11:25:59 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170428055559.GA3998@giis.co.in>
References: <20170427100534.GA10404@giis.co.in>
 <3907c93a-c525-5874-8d14-594f66383261@cn.fujitsu.com>
 <016db1e7-c9d5-a8ec-1d64-cbd08f14503d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <016db1e7-c9d5-a8ec-1d64-cbd08f14503d@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Seems like its a known issue with older bitmaps.
http://linux-ext4.vger.kernel.narkive.com/wkNbJe0b/patch-debugfs-open-with-ext2-flag-64bits

Cheers.
Lakshmipathi.G

On Fri, Apr 28, 2017 at 09:48:10AM +0800, Qu Wenruo wrote:
> 
> 
> At 04/28/2017 09:27 AM, Qu Wenruo wrote:
> >At 04/27/2017 06:05 PM, Lakshmipathi.G wrote:
> >>Bug: Fail to convert 22TB EXT4 to BTRFS
> >>https://bugzilla.kernel.org/show_bug.cgi?id=194795
> >
> >Thanks for fixing it.
> >
> >While testing manually using LVM thin provision, although the convert
> >itself works, the converted image has something wrong on its size.
> >
> >The converted image is only 4T sized, not the correct size (20T) of my
> >original setup.
> >
> >This may not be the problem of your patch.
> >I'll double check the original code to ensure it works.
> 
> It's the method we get blocks count wrong.
> 
> We should do it just as dumpe2fs does:
> ------
> static __u64 e2p_blocks_count(struct ext2_super_block *super)
> {
> 	return super->s_blocks_count |
> 		(ext2fs_has_feature_64bit(super) ?
> 		(__u64) super->s_blocks_count_hi << 32 : 0);
> }
> ------
> 
> Current super->s_blocks_count can only handle U32_MAX, higher bits are in
> super->s_blocks_count_hi.
> 
> Thanks,
> Qu
> 
> >
> >Thanks,
> >Qu
> >
> >>
> >>Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> >>---
> >>  convert/source-ext2.c | 11 ++++++-----
> >>  1 file changed, 6 insertions(+), 5 deletions(-)
> >>
> >>diff --git a/convert/source-ext2.c b/convert/source-ext2.c
> >>index 1b0576b..275cb89 100644
> >>--- a/convert/source-ext2.c
> >>+++ b/convert/source-ext2.c
> >>@@ -34,8 +34,9 @@ static int ext2_open_fs(struct btrfs_convert_context
> >>*cctx, const char *name)
> >>      ext2_filsys ext2_fs;
> >>      ext2_ino_t ino;
> >>      u32 ro_feature;
> >>+    int open_flag = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
> >>-    ret = ext2fs_open(name, 0, 0, 0, unix_io_manager, &ext2_fs);
> >>+    ret = ext2fs_open(name, open_flag, 0, 0, unix_io_manager, &ext2_fs);
> >>      if (ret) {
> >>          fprintf(stderr, "ext2fs_open: %s\n", error_message(ret));
> >>          return -1;
> >>@@ -148,7 +149,7 @@ static int ext2_read_used_space(struct
> >>btrfs_convert_context *cctx)
> >>          return -ENOMEM;
> >>      for (i = 0; i < fs->group_desc_count; i++) {
> >>-        ret = ext2fs_get_block_bitmap_range(fs->block_map, blk_itr,
> >>+        ret = ext2fs_get_block_bitmap_range2(fs->block_map, blk_itr,
> >>                          block_nbytes * 8, block_bitmap);
> >>          if (ret) {
> >>              error("fail to get bitmap from ext2, %s",
> >>@@ -353,7 +354,7 @@ static int ext2_create_symlink(struct
> >>btrfs_trans_handle *trans,
> >>      int ret;
> >>      char *pathname;
> >>      u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
> >>-    if (ext2fs_inode_data_blocks(ext2_fs, ext2_inode)) {
> >>+    if (ext2fs_inode_data_blocks2(ext2_fs, ext2_inode)) {
> >>          btrfs_set_stack_inode_size(btrfs_inode, inode_size + 1);
> >>          ret = ext2_create_file_extents(trans, root, objectid,
> >>                  btrfs_inode, ext2_fs, ext2_ino,
> >>@@ -627,9 +628,9 @@ static int ext2_copy_extended_attrs(struct
> >>btrfs_trans_handle *trans,
> >>          ret = -ENOMEM;
> >>          goto out;
> >>      }
> >>-    err = ext2fs_read_ext_attr(ext2_fs, ext2_inode->i_file_acl, buffer);
> >>+    err = ext2fs_read_ext_attr2(ext2_fs, ext2_inode->i_file_acl,
> >>buffer);
> >>      if (err) {
> >>-        fprintf(stderr, "ext2fs_read_ext_attr: %s\n",
> >>+        fprintf(stderr, "ext2fs_read_ext_attr2: %s\n",
> >>              error_message(err));
> >>          ret = -1;
> >>          goto out;
> >>
> 
> 
