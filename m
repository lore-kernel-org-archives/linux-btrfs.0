Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38441 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031503AbdD1JNz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 05:13:55 -0400
Received: by mail-wm0-f48.google.com with SMTP id r190so40941230wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 02:13:43 -0700 (PDT)
Received: from [192.168.77.22] (val06-1-88-182-161-34.fbx.proxad.net. [88.182.161.34])
        by smtp.gmail.com with ESMTPSA id c5sm3386813wre.60.2017.04.28.02.13.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2017 02:13:37 -0700 (PDT)
From: Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 3/3] Make max_size consistent with nr
Message-Id: <004EF35C-BB29-4B53-8BEC-B0DB38F0A301@redhat.com>
Date: Fri, 28 Apr 2017 11:13:36 +0200
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
index 58e65d6..774e9b6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6193,6 +6193,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		tmpl.start = bytenr;
 		tmpl.nr = 1;
 		tmpl.metadata = 1;
+                tmpl.max_size = 1;
 
 		ret = add_extent_rec_nolookup(extent_cache, &tmpl);
 		if (ret)
-- 
2.9.3

