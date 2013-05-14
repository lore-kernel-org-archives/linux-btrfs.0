Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52884 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab3ENA7U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:20 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 20:59:19 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 05/12] VFS hot tracking, rcu: introduce one rcu macro for list
Date: Tue, 14 May 2013 08:59:37 +0800
Message-Id: <1368493184-5939-6-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  This rcu macro for list will be used in seq_list
rcu interfaces.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 include/linux/rculist.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 8089e35..a3fa055 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -218,6 +218,11 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	at->prev = last;
 }
 
+#define __list_for_each_rcu(pos, head)				\
+	for (pos = rcu_dereference(list_next_rcu(head));	\
+	     pos != head;						\
+	     pos = rcu_dereference(list_next_rcu(pos)))
+
 /**
  * list_entry_rcu - get the struct for this entry
  * @ptr:        the &struct list_head pointer.
-- 
1.7.11.7

