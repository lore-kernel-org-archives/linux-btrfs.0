Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323DAC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01CEC217D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550509055;
	bh=833AhtYNEdCN5QHN4RhPLemCXmIQpROEAaIvtSTmo+8=;
	h=From:To:Subject:Date:List-ID:From;
	b=hZSAXspMkfc8NeJfZK+rq0GYJvjR6WJzomNF6v9+nBmP98+ct4Zo67QWNxjPqB7dP
	 AP8ViEsUztySOkcfuxknENFTNLcorFo74vsA4RVGOTlNJnJDlkRVl6lljKKyi9fM+z
	 EccFxeTf8Yx46o3fvRNZ59oWA4POePdDev2PF/jA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390586AbfBRQ5e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 11:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733069AbfBRQ5d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 11:57:33 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D996217D9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550509052;
        bh=833AhtYNEdCN5QHN4RhPLemCXmIQpROEAaIvtSTmo+8=;
        h=From:To:Subject:Date:From;
        b=hGq7jebukOfwfZMpIOHTXfr5qP9EkgGNoyI2DI8KGcjeeevIacFqqFjtCAdBskCpM
         ld+QPUKqcYPXZdkQkTjN3vGs7cE6xfMpbW05ofboEwi/8thn72nVGCftmGVg7MIJzJ
         beuY6AxqxBtGnMvQIwR2+HEzgi3ZJ06e0qGo3AI4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: add missing error handling after doing leaf/node binary search
Date:   Mon, 18 Feb 2019 16:57:26 +0000
Message-Id: <20190218165726.22884-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The function map_private_extent_buffer() can return an -EINVAL error, and
it is called by generic_bin_search() which will return back the error. The
btrfs_bin_search() function in turn calls generic_bin_search() and the
key_search() function calls btrfs_bin_search(), so both can return the
-EINVAL error coming from the map_private_extent_buffer() function. Some
callers of these functions were ignoring that these functions can return
an error, so fix them to deal with error return values.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c      | 6 ++++++
 fs/btrfs/relocation.c | 6 ++++++
 fs/btrfs/tree-log.c   | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5a6c39b44c84..5b9f602fb9e2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3005,6 +3005,8 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 		 */
 		prev_cmp = -1;
 		ret = key_search(b, key, level, &prev_cmp, &slot);
+		if (ret < 0)
+			goto done;
 
 		if (level != 0) {
 			int dec = 0;
@@ -5156,6 +5158,10 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 		nritems = btrfs_header_nritems(cur);
 		level = btrfs_header_level(cur);
 		sret = btrfs_bin_search(cur, min_key, level, &slot);
+		if (sret < 0) {
+			ret = sret;
+			goto out;
+		}
 
 		/* at the lowest level, we're done, setup the path and exit */
 		if (level == path->lowest_level) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 272b287f8cf0..434a5b159b65 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1802,6 +1802,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		BUG_ON(level < lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, level, &slot);
+		if (ret < 0)
+			break;
 		if (ret && slot > 0)
 			slot--;
 
@@ -2685,6 +2687,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 			if (!lowest) {
 				ret = btrfs_bin_search(upper->eb, key,
 						       upper->level, &slot);
+				if (ret < 0)
+					break;
 				BUG_ON(ret);
 				bytenr = btrfs_node_blockptr(upper->eb, slot);
 				if (node->eb->start == bytenr)
@@ -2720,6 +2724,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 		} else {
 			ret = btrfs_bin_search(upper->eb, key, upper->level,
 					       &slot);
+			if (ret < 0)
+				break;
 			BUG_ON(ret);
 		}
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8c9e87f5ec58..81a357a32837 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3772,6 +3772,8 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 		found_key.type = 0;
 		ret = btrfs_bin_search(path->nodes[0], &found_key, 0,
 				       &start_slot);
+		if (ret < 0)
+			break;
 
 		ret = btrfs_del_items(trans, log, path, start_slot,
 				      path->slots[0] - start_slot + 1);
-- 
2.11.0

