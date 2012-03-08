From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/ulist: replace the magic number 128 with macro definition
 ULIST_SIZE_INCREMENT
Date: Thu, 08 Mar 2012 12:38:17 +0800
Message-ID: <4F5837B9.6000006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: sensille@gmx.net, Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Remove the magic number 128 in btrfs/ulist.c.
Introduce the macro definition ULIST_SIZE_INCREMENT in btrfs/ulist.h.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/ulist.c |    2 +-
 fs/btrfs/ulist.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 12f5147..b8a4506 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -154,7 +154,7 @@ int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
 	}
 
 	if (ulist->nnodes >= ulist->nodes_alloced) {
-		u64 new_alloced = ulist->nodes_alloced + 128;
+		u64 new_alloced = ulist->nodes_alloced + ULIST_SIZE_INCREMENT;
 		struct ulist_node *new_nodes;
 		void *old = NULL;
 
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 2e25dec..590e396 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -23,6 +23,11 @@
  * number of elements statically allocated inside struct ulist
  */
 #define ULIST_SIZE 16
+/*
+ * increment as dynamically allocated elements space grows
+ */
+#define ULIST_SIZE_INCREMENT 128
+
 
 /*
  * element of the list
-- 
1.7.1

