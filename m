Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53411C282DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 07:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B60B2084A
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 07:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfAUHnu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:43:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:59916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728477AbfAUHnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 02:43:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9FB2ACB5
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 06:27:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: Introduce "rescue=" mount option
Date:   Mon, 21 Jan 2019 14:27:17 +0800
Message-Id: <20190121062718.8063-3-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121062718.8063-1-wqu@suse.com>
References: <20190121062718.8063-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch introduces a new "rescue=" mount option for all those mount
options for data recovery.

Different rescue sub options are seperated by ':'.
(The original plan is to use ';', but ';' needs to be escaped/quoted,
or it will be interpreted by bash)

The following mount options are converted to "rescue=", old mount
options are deprecated but still available for compatibility purpose:

- usebackuproot
  Now it's "rescue=use_backup_root"

- nologreplay
  Now it's "rescue=no_log_replay"

The new underscore is here to make the option more readable and make
spell check happier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 65 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6a08f23e5600..0fb251e7bf5b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -310,7 +310,6 @@ enum {
 	Opt_datasum, Opt_nodatasum,
 	Opt_defrag, Opt_nodefrag,
 	Opt_discard, Opt_nodiscard,
-	Opt_nologreplay,
 	Opt_ratio,
 	Opt_rescan_uuid_tree,
 	Opt_skip_balance,
@@ -323,7 +322,6 @@ enum {
 	Opt_subvolid,
 	Opt_thread_pool,
 	Opt_treelog, Opt_notreelog,
-	Opt_usebackuproot,
 	Opt_user_subvol_rm_allowed,
 
 	/* Deprecated options */
@@ -341,6 +339,8 @@ enum {
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	Opt_ref_verify,
 #endif
+	/* Rescue options */
+	Opt_rescue, Opt_usebackuproot, Opt_nologreplay,
 	Opt_err,
 };
 
@@ -401,6 +401,7 @@ static const match_table_t tokens = {
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%u"},
 	{Opt_enospc_debug, "enospc_debug"},
 	{Opt_noenospc_debug, "noenospc_debug"},
+	{Opt_rescue, "rescue=%s"},
 #ifdef CONFIG_BTRFS_DEBUG
 	{Opt_fragment_data, "fragment=data"},
 	{Opt_fragment_metadata, "fragment=metadata"},
@@ -412,6 +413,55 @@ static const match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
+static const match_table_t rescue_tokens = {
+	{Opt_usebackuproot, "use_backup_root"},
+	{Opt_nologreplay, "no_log_replay"},
+	{Opt_err, NULL},
+};
+
+static int parse_rescue_options(struct btrfs_fs_info *info, const char *options)
+{
+	char *opts;
+	char *orig;
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int ret = 0;
+
+	opts = kstrdup(options, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+	orig = opts;
+
+	while ((p = strsep(&opts, ":")) != NULL) {
+		int token;
+
+		if (!*p)
+			continue;
+		token = match_token(p, rescue_tokens, args);
+		switch (token){
+		case Opt_usebackuproot:
+			btrfs_info(info,
+				   "trying to use backup root at mount time");
+			btrfs_set_opt(info->mount_opt, USEBACKUPROOT);
+			break;
+		case Opt_nologreplay:
+			btrfs_set_and_info(info, NOLOGREPLAY,
+					   "disabling log replay at mount time");
+			break;
+		case Opt_err:
+			btrfs_info(info, "unrecognized rescue option '%s'", p);
+			ret = -EINVAL;
+			goto out;
+		default:
+			break;
+		}
+
+	}
+out:
+	kfree(orig);
+	return ret;
+}
+
 /*
  * Regular mount options parser.  Everything that is needed only when
  * reading in a new superblock is parsed here.
@@ -661,6 +711,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 					     "enabling tree log");
 			break;
 		case Opt_nologreplay:
+			btrfs_warn(info,
+	"'nologreplay' is deprecated, use 'rescue=no_log_replay' instead");
 			btrfs_set_and_info(info, NOLOGREPLAY,
 					   "disabling log replay at mount time");
 			break;
@@ -749,6 +801,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 					     "disabling auto defrag");
 			break;
 		case Opt_usebackuproot:
+			btrfs_warn(info,
+	"'usebackuproot' is deprecated, use 'rescue=use_backup_root' instead");
 			btrfs_info(info,
 				   "trying to use backup root at mount time");
 			btrfs_set_opt(info->mount_opt, USEBACKUPROOT);
@@ -835,6 +889,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_set_opt(info->mount_opt, REF_VERIFY);
 			break;
 #endif
+		case Opt_rescue:
+			ret = parse_rescue_options(info, args[0].from);
+			if (ret < 0)
+				goto out;
+			break;
 		case Opt_err:
 			btrfs_info(info, "unrecognized mount option '%s'", p);
 			ret = -EINVAL;
@@ -1301,7 +1360,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(info, NOTREELOG))
 		seq_puts(seq, ",notreelog");
 	if (btrfs_test_opt(info, NOLOGREPLAY))
-		seq_puts(seq, ",nologreplay");
+		seq_puts(seq, ",rescue=no_log_replay");
 	if (btrfs_test_opt(info, FLUSHONCOMMIT))
 		seq_puts(seq, ",flushoncommit");
 	if (btrfs_test_opt(info, DISCARD))
-- 
2.20.1

