Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35519 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755602AbdETIjG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 04:39:06 -0400
Received: by mail-io0-f179.google.com with SMTP id f102so58713030ioi.2
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 01:39:05 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id l19sm5056789ioe.3.2017.05.20.01.39.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 May 2017 01:39:04 -0700 (PDT)
Date: Sat, 20 May 2017 08:39:03 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] btrfs: Fail on removing qgroup if del_qgroup_item fails
Message-ID: <20170520083902.GA4204@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>

Previously, we were calling del_qgroup_item, and ignoring the return code
resulting in a potential to have divergent in-memory state without an
error. Perhaps, it makes sense to handle this error code, and put the
filesystem into a read only, or similar state.

This patch only adds reporting of the error.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/qgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a2add44..7e772ba 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1303,6 +1303,8 @@ static int __btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 		return -EBUSY;
 
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
+	if (ret)
+		goto out;
 
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
-- 
2.9.3

