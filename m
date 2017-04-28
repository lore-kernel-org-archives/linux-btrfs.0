Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:33540 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164560AbdD1Ju0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 05:50:26 -0400
Received: by mail-wr0-f171.google.com with SMTP id w50so30789254wrc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 02:50:26 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 2/3 v2] Prevent attempt to insert extent record with
 max_size==0  
From: Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <20170428141640.12429352@natsu>
Date: Fri, 28 Apr 2017 11:50:23 +0200
Cc: Roman Mamedov <rm@romanrm.net>
Message-Id: <74CAC383-4C3A-4C68-9B56-2AB28947E3E3@redhat.com>
References: <004EF35C-BB29-4B53-8BEC-B0DB38F0A301@redhat.com>
 <20170428141640.12429352@natsu>
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
index 2d3ebc1..c13f900 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6029,6 +6029,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 	struct extent_record *rec;
 	int ret = 0;
 
+	BUG_ON(tmpl->max_size == 0);
 	rec = malloc(sizeof(*rec));
 	if (!rec)
 		return -ENOMEM;
-- 
2.9.3

