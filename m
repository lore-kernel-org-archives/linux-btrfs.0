Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35262 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425601AbdD1Jva (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 05:51:30 -0400
Received: by mail-wr0-f170.google.com with SMTP id z52so30734998wrc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 02:51:29 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 3/3 v2] Make max_size consistent with nr
From: Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <20170428141640.12429352@natsu>
Date: Fri, 28 Apr 2017 11:51:21 +0200
Cc: Roman Mamedov <rm@romanrm.net>
Message-Id: <B8A1E13A-A60F-428D-AA1F-71890BD758EE@redhat.com>
References: <004EF35C-BB29-4B53-8BEC-B0DB38F0A301@redhat.com>
 <20170428141640.12429352@natsu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we memset tmpl, max_size==0. This does not seem consistent with nr = 1.
In check_extent_refs, we will call:

  set_extent_dirty(root->fs_info->excluded_extents,
                   rec->start,
                   rec->start + rec->max_size - 1);

This ends up with BUG_ON(end < start) in insert_state.

Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>
---
 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index c13f900..d5e2966 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6193,6 +6193,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		tmpl.start = bytenr;
 		tmpl.nr = 1;
 		tmpl.metadata = 1;
+		tmpl.max_size = 1;
 
 		ret = add_extent_rec_nolookup(extent_cache, &tmpl);
 		if (ret)
-- 
2.9.3

