Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeCINoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 08:44:16 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 22340AB35
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 13:44:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: sort and group mount option definitions
Date: Fri,  9 Mar 2018 14:41:53 +0100
Message-Id: <20180309134153.10796-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sort mount options by the primary name, followed by the 'no-'
counterpart if it exists. Group the deprecated and debugging options.
Enum and token defintions are synced.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 139 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 86 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 121b9d40ff8f..d41d5960ef4a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -308,21 +308,50 @@ static void btrfs_put_super(struct super_block *sb)
 }
 
 enum {
-	Opt_degraded, Opt_subvol, Opt_subvolid, Opt_device, Opt_nodatasum,
-	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
-	Opt_nossd, Opt_ssd_spread, Opt_nossd_spread, Opt_thread_pool, Opt_noacl,
-	Opt_compress, Opt_compress_type, Opt_compress_force,
-	Opt_compress_force_type, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_space_cache, Opt_space_cache_version, Opt_clear_cache,
-	Opt_user_subvol_rm_allowed, Opt_enospc_debug, Opt_subvolrootid,
-	Opt_defrag, Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
-	Opt_skip_balance, Opt_check_integrity,
+	Opt_acl, Opt_noacl,
+	Opt_clear_cache,
+	Opt_commit_interval,
+	Opt_compress,
+	Opt_compress_force,
+	Opt_compress_force_type,
+	Opt_compress_type,
+	Opt_degraded,
+	Opt_device,
+	Opt_fatal_errors,
+	Opt_flushoncommit, Opt_noflushoncommit,
+	Opt_inode_cache, Opt_noinode_cache,
+	Opt_max_inline,
+	Opt_barrier, Opt_nobarrier,
+	Opt_datacow, Opt_nodatacow,
+	Opt_datasum, Opt_nodatasum,
+	Opt_defrag, Opt_nodefrag,
+	Opt_discard, Opt_nodiscard,
+	Opt_nologreplay,
+	Opt_norecovery,
+	Opt_ratio,
+	Opt_rescan_uuid_tree,
+	Opt_skip_balance,
+	Opt_space_cache, Opt_no_space_cache,
+	Opt_space_cache_version,
+	Opt_ssd, Opt_nossd,
+	Opt_ssd_spread, Opt_nossd_spread,
+	Opt_subvol,
+	Opt_subvolid,
+	Opt_thread_pool,
+	Opt_treelog, Opt_notreelog,
+	Opt_usebackuproot,
+	Opt_user_subvol_rm_allowed,
+
+	/* Deprecated options */
+	Opt_alloc_start,
+	Opt_recovery,
+	Opt_subvolrootid,
+
+	/* Debugging options */
+	Opt_check_integrity,
 	Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
-	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
-	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
-	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
-	Opt_nologreplay, Opt_norecovery,
+	Opt_check_integrity_print_mask,
+	Opt_enospc_debug, Opt_noenospc_debug,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -333,59 +362,63 @@ enum {
 };
 
 static const match_table_t tokens = {
-	{Opt_degraded, "degraded"},
-	{Opt_subvol, "subvol=%s"},
-	{Opt_subvolid, "subvolid=%s"},
-	{Opt_device, "device=%s"},
-	{Opt_nodatasum, "nodatasum"},
-	{Opt_datasum, "datasum"},
-	{Opt_nodatacow, "nodatacow"},
-	{Opt_datacow, "datacow"},
-	{Opt_nobarrier, "nobarrier"},
-	{Opt_barrier, "barrier"},
-	{Opt_max_inline, "max_inline=%s"},
-	{Opt_alloc_start, "alloc_start=%s"},		/* deprecated */
-	{Opt_thread_pool, "thread_pool=%u"},
+	{Opt_acl, "acl"},
+	{Opt_noacl, "noacl"},
+	{Opt_clear_cache, "clear_cache"},
+	{Opt_commit_interval, "commit=%u"},
 	{Opt_compress, "compress"},
 	{Opt_compress_type, "compress=%s"},
 	{Opt_compress_force, "compress-force"},
 	{Opt_compress_force_type, "compress-force=%s"},
-	{Opt_ssd, "ssd"},
-	{Opt_ssd_spread, "ssd_spread"},
-	{Opt_nossd, "nossd"},
-	{Opt_nossd_spread, "nossd_spread"},
-	{Opt_acl, "acl"},
-	{Opt_noacl, "noacl"},
-	{Opt_notreelog, "notreelog"},
-	{Opt_treelog, "treelog"},
-	{Opt_nologreplay, "nologreplay"},
-	{Opt_norecovery, "norecovery"},
+	{Opt_degraded, "degraded"},
+	{Opt_device, "device=%s"},
+	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_noflushoncommit, "noflushoncommit"},
-	{Opt_ratio, "metadata_ratio=%u"},
+	{Opt_inode_cache, "inode_cache"},
+	{Opt_noinode_cache, "noinode_cache"},
+	{Opt_max_inline, "max_inline=%s"},
+	{Opt_barrier, "barrier"},
+	{Opt_nobarrier, "nobarrier"},
+	{Opt_datacow, "datacow"},
+	{Opt_nodatacow, "nodatacow"},
+	{Opt_datasum, "datasum"},
+	{Opt_nodatasum, "nodatasum"},
+	{Opt_defrag, "autodefrag"},
+	{Opt_nodefrag, "noautodefrag"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_nologreplay, "nologreplay"},
+	{Opt_norecovery, "norecovery"},
+	{Opt_ratio, "metadata_ratio=%u"},
+	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
+	{Opt_skip_balance, "skip_balance"},
 	{Opt_space_cache, "space_cache"},
-	{Opt_space_cache_version, "space_cache=%s"},
-	{Opt_clear_cache, "clear_cache"},
-	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
-	{Opt_enospc_debug, "enospc_debug"},
-	{Opt_noenospc_debug, "noenospc_debug"},
-	{Opt_subvolrootid, "subvolrootid=%d"},		/* deprecated */
-	{Opt_defrag, "autodefrag"},
-	{Opt_nodefrag, "noautodefrag"},
-	{Opt_inode_cache, "inode_cache"},
-	{Opt_noinode_cache, "noinode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
-	{Opt_recovery, "recovery"}, /* deprecated */
+	{Opt_space_cache_version, "space_cache=%s"},
+	{Opt_ssd, "ssd"},
+	{Opt_nossd, "nossd"},
+	{Opt_ssd_spread, "ssd_spread"},
+	{Opt_nossd_spread, "nossd_spread"},
+	{Opt_subvol, "subvol=%s"},
+	{Opt_subvolid, "subvolid=%s"},
+	{Opt_thread_pool, "thread_pool=%u"},
+	{Opt_treelog, "treelog"},
+	{Opt_notreelog, "notreelog"},
 	{Opt_usebackuproot, "usebackuproot"},
-	{Opt_skip_balance, "skip_balance"},
+	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
+
+	/* Deprecated options */
+	{Opt_alloc_start, "alloc_start=%s"},
+	{Opt_recovery, "recovery"},
+	{Opt_subvolrootid, "subvolrootid=%d"},
+
+	/* Debugging options */
 	{Opt_check_integrity, "check_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%u"},
-	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
-	{Opt_fatal_errors, "fatal_errors=%s"},
-	{Opt_commit_interval, "commit=%u"},
+	{Opt_enospc_debug, "enospc_debug"},
+	{Opt_noenospc_debug, "noenospc_debug"},
 #ifdef CONFIG_BTRFS_DEBUG
 	{Opt_fragment_data, "fragment=data"},
 	{Opt_fragment_metadata, "fragment=metadata"},
-- 
2.16.2

