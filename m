Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49933 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3IZN0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 09:26:39 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1581A9A0691
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Sep 2013 07:26:39 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
CC: <walken@google.com>, <linux-kernel@vger.kernel.org>, <mingo@kernel.org>,
        <peter@hurleysoftware.com>, <akpm@linux-foundation.org>
Subject: [PATCH 1/2] rwsem: add rwsem_is_contended V3
Date: Thu, 26 Sep 2013 09:26:35 -0400
Message-ID: <1380201996-17445-1-git-send-email-jbacik@fusionio.com>
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
V2->V3: fixed the comment and simplified the function as per Peter's
suggestions.

V1->V2: took everybodys suggestions and simplified it to just one function in
rwsem.h so it works for both the spinlock case and non-spinlock case.

 include/linux/rwsem.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 0616ffe..03f3b05 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -75,6 +75,17 @@ do {								\
 } while (0)
 
 /*
+ * This is the same regardless of which rwsem implementation that is being used.
+ * It is just a heuristic meant to be called by somebody alreadying holding the
+ * rwsem to see if somebody from an incompatible type is wanting access to the
+ * lock.
+ */
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	return !list_empty(&sem->wait_list);
+}
+
+/*
  * lock for reading
  */
 extern void down_read(struct rw_semaphore *sem);
-- 
1.8.3.1

