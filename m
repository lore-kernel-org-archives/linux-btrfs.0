Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37306 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753394AbdD1JNK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 05:13:10 -0400
Received: by mail-wm0-f54.google.com with SMTP id m123so40776840wma.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 02:13:09 -0700 (PDT)
Received: from [192.168.77.22] (val06-1-88-182-161-34.fbx.proxad.net. [88.182.161.34])
        by smtp.gmail.com with ESMTPSA id c5sm3386813wre.60.2017.04.28.02.13.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2017 02:13:08 -0700 (PDT)
From: Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 2/3] Prevent attempt to insert extent record with max_size==0
Message-Id: <B2B97803-5534-4A76-ADFA-4EEB287475BE@redhat.com>
Date: Fri, 28 Apr 2017 11:13:07 +0200
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When this happens, we will trip a BUG_ON(end < start) in insert_state
because in check_extent_refs, we use this max_size expecting it's not zero:

  set_extent_dirty(root->fs_info->excluded_extents,
                   rec->start,
                   rec->start + rec->max_size - 1);

See https://bugzilla.redhat.com/show_bug.cgi?id=1435567
for an example where this scenario occurs.

Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>
---
 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index 2d3ebc1..58e65d6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6029,6 +6029,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 	struct extent_record *rec;
 	int ret = 0;
 
+        BUG_ON(tmpl->max_size == 0);
 	rec = malloc(sizeof(*rec));
 	if (!rec)
 		return -ENOMEM;
-- 
2.9.3

