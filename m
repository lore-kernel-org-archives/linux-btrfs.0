Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35934 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037683AbdDUKJt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 06:09:49 -0400
Received: by mail-io0-f175.google.com with SMTP id o22so123939091iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 03:09:48 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id f19sm379221itf.19.2017.04.21.03.09.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Apr 2017 03:09:47 -0700 (PDT)
Date: Fri, 21 Apr 2017 10:09:46 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: allow processes with cap_sys_resource to exceed quota
Message-ID: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch allows processes with CAP_SYS_RESOURCE to exceed the qgroup
limit. It's useful for administrative programs, such as log rotation,
that may need to temporarily use more disk space in order to free up
a greater amount of overall disk space without yielding more disk
space to the rest of userland.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/qgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a59801d..b0af39c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2349,6 +2349,9 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 
 static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
 {
+	if (capable(CAP_SYS_RESOURCE))
+		return true;
+
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 	    qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
 		return false;
-- 
2.9.3

