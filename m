Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45514 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3ISPsL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 11:48:11 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EA8389A0404
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 09:48:10 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
CC: <walken@google.com>, <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
        <peter@hurleysoftware.com>, <akpm@linux-foundation.org>
Subject: [PATCH 1/2] rwsem: add rwsem_is_contended V2
Date: Thu, 19 Sep 2013 11:48:07 -0400
Message-ID: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs needs a simple way to know if it needs to let go of it's read lock on a
rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
this rwsem currently.  This is just a hueristic, it is meant to be light and not
100% accurate and called by somebody already holding on to the rwsem in either
read or write.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: took everybodys suggestions and simplified it to just one function in
rwsem.h so it works for both the spinlock case and non-spinlock case.

 include/linux/rwsem.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 0616ffe..c340493 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -75,6 +75,19 @@ do {								\
 } while (0)
 
 /*
+ * This is the same regardless of which rwsem implementation that is being used.
+ * It is just a heuristic meant to be called by somebody alreadying holding the
+ * rwsem to see if somebody from the opposite type is wanting access to the
+ * lock.
+ */
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	if (!list_empty(&sem->wait_list))
+		return 1;
+	return 0;
+}
+
+/*
  * lock for reading
  */
 extern void down_read(struct rw_semaphore *sem);
-- 
1.8.3.1

