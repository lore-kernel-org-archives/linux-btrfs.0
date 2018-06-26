Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934063AbeFZOTy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 10:19:54 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 257F1ABDF
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 14:19:53 +0000 (UTC)
Date: Tue, 26 Jun 2018 16:17:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Add graceful handling of V0 extents
Message-ID: <20180626141659.GJ27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180625152156.GF27958@twin.jikos.cz>
 <1530021456-20749-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530021456-20749-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2018 at 04:57:36PM +0300, Nikolay Borisov wrote:
> Following the removal of the v0 handling code let's be courteous and
> print an error message when such extents are handled. In the cases
> where we have a transaction just abort it, otherwise just call
> btrfs_handle_fs_error. Both cases result in the FS being re-mounted RO.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

> -		ASSERT(key.type != BTRFS_EXTENT_REF_V0_KEY);
> -		if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
> +		if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
> +			err = -EINVAL;
> +			btrfs_print_v0_err(rc->extent_root->fs_info);
> +			btrfs_handle_fs_error(rc->extent_root->fs_info, err,
> +					      NULL);
> +			goto out;
> +		} else if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {

The v0 check should be made last as it's not expected to happen. I'm
commiting with this diff

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -787,13 +787,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
                        goto next;
                }
 
-               if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
-                       err = -EINVAL;
-                       btrfs_print_v0_err(rc->extent_root->fs_info);
-                       btrfs_handle_fs_error(rc->extent_root->fs_info, err,
-                                             NULL);
-                       goto out;
-               } else if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
+               if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
                        if (key.objectid == key.offset) {
                                /*
                                 * only root blocks of reloc trees use
@@ -838,6 +832,12 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
                        goto next;
                } else if (key.type != BTRFS_TREE_BLOCK_REF_KEY) {
                        goto next;
+               } else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+                       err = -EINVAL;
+                       btrfs_print_v0_err(rc->extent_root->fs_info);
+                       btrfs_handle_fs_error(rc->extent_root->fs_info, err,
+                                             NULL);
+                       goto out;
                }
 
                /* key.type == BTRFS_TREE_BLOCK_REF_KEY */
@@ -3734,11 +3734,7 @@ int add_data_references(struct reloc_control *rc,
                if (key.objectid != extent_key->objectid)
                        break;
 
-               if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
-                       btrfs_print_v0_err(eb->fs_info);
-                       btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
-                       ret = -EINVAL;
-               } else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
+               if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
                        ret = __add_tree_block(rc, key.offset, blocksize,
                                               blocks);
                } else if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
@@ -3746,6 +3742,10 @@ int add_data_references(struct reloc_control *rc,
                                              struct btrfs_extent_data_ref);
                        ret = find_data_references(rc, extent_key,
                                                   eb, dref, blocks);
+               } else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+                       btrfs_print_v0_err(eb->fs_info);
+                       btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
+                       ret = -EINVAL;
                } else {
                        ret = 0;
                }
