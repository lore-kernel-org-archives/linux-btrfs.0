Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60306 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3H3OOE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 10:14:04 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4F5A37C065C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:14:04 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <walken@google.com>, <mingo@elte.hu>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] rwsem: add rwsem_is_contended
Date: Fri, 30 Aug 2013 10:14:01 -0400
Message-ID: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
read lock on this rwsem while they scan the extent tree, and if need_resched()
they will drop the lock and schedule.  The transaction commit needs to take a
write lock for this rwsem for a very short period to switch out the commit
roots.  If there are a lot of threads doing this caching operation we can starve
out the committers which slows everybody out.  To address this we want to add
this functionality to see if our rwsem has anybody waiting to take a write lock
so we can drop it and schedule for a bit to allow the commit to continue.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
I've cc'ed people who seemed like they may be in charge/familiar with this code,
hopefully I got the right people.

 include/linux/rwsem.h |    1 +
 lib/rwsem.c           |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 0616ffe..61a8802 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -35,6 +35,7 @@ extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
+extern int rwsem_is_contended(struct rw_semaphore *sem);
 
 /* Include the arch specific part */
 #include <asm/rwsem.h>
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 19c5fa9..20858cd 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -287,6 +287,23 @@ struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 	return sem;
 }
 
+/*
+ * check to see if the rwsem we're holding has anybody waiting to acquire it.
+ */
+int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	if (!raw_spin_trylock_irqsave(&sem->wait_lock, flags))
+		return 1;
+	if (!list_empty(&sem->wait_list))
+		ret = 1;
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+	return ret;
+}
+
+EXPORT_SYMBOL(rwsem_is_contended);
 EXPORT_SYMBOL(rwsem_down_read_failed);
 EXPORT_SYMBOL(rwsem_down_write_failed);
 EXPORT_SYMBOL(rwsem_wake);
-- 
1.7.7.6

