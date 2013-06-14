Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63383 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3FNI3X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 04:29:23 -0400
Received: by mail-qc0-f175.google.com with SMTP id k14so167411qcv.20
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 01:29:22 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Jun 2013 16:21:24 +0800
Message-ID: <CAKXJSOEhk5tYpJd3L4r9zNsEFHRihz+tZXv4hZ5gAmDF_1G9cQ@mail.gmail.com>
Subject: [PATCH] Btrfs: fix the comment typo for btrfs_attach_transaction_barrier
From: Wang Sheng-Hui <shhuiw@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The comment is for btrfs_attach_transaction_barrier, not for
btrfs_attach_transaction. Fix the typo.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0544587..6d4c595 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -490,7 +490,7 @@ struct btrfs_trans_handle
*btrfs_attach_transaction(struct btrfs_root *root)
 }

 /*
- * btrfs_attach_transaction() - catch the running transaction
+ * btrfs_attach_transaction_barrier() - catch the running transaction
  *
  * It is similar to the above function, the differentia is this one
  * will wait for all the inactive transactions until they fully
-- 
1.7.12.4
