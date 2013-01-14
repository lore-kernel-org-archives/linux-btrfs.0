Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab3ANOSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 09:18:15 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 9A96AA3E1C
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 15:18:14 +0100 (CET)
Date: Mon, 14 Jan 2013 15:18:14 +0100
From: Arvin Schnell <aschnell@suse.de>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130114141814.GA7265@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
In-Reply-To: <1357681304-2978-3-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Hi,

please find attached a patch to make the new libbtrfs usable from
C++ (at least for the parts snapper will likely need).

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany

--FCuugMFkClbJLl1L
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="libbtrfs-c++.diff"

diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..c51310a 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -40,6 +40,10 @@
 #include "send.h"
 #include "send-utils.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 static int g_verbose = 0;
 
 struct btrfs_send {
@@ -654,3 +658,7 @@ int cmd_send(int argc, char **argv)
 {
 	return cmd_send_start(argc, argv);
 }
+
+#ifdef __cplusplus
+}
+#endif
diff --git a/extent_io.c b/extent_io.c
index ebb35b2..70ecc48 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -48,7 +48,7 @@ static struct extent_state *alloc_extent_state(void)
 		return NULL;
 	state->refs = 1;
 	state->state = 0;
-	state->private = 0;
+	state->xprivate = 0;
 	return state;
 }
 
@@ -509,7 +509,7 @@ int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 		ret = -ENOENT;
 		goto out;
 	}
-	state->private = private;
+	state->xprivate = private;
 out:
 	return ret;
 }
@@ -530,7 +530,7 @@ int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 		ret = -ENOENT;
 		goto out;
 	}
-	*private = state->private;
+	*private = state->xprivate;
 out:
 	return ret;
 }
diff --git a/extent_io.h b/extent_io.h
index 4553859..6d8404d 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -54,7 +54,7 @@ struct extent_state {
 	u64 end;
 	int refs;
 	unsigned long state;
-	u64 private;
+	u64 xprivate;
 };
 
 struct extent_buffer {
@@ -93,8 +93,8 @@ int extent_buffer_uptodate(struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_buffer *eb);
 int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
 				struct extent_buffer *eb);
-int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
-int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
+int set_state_private(struct extent_io_tree *tree, u64 start, u64 xprivate);
+int get_state_private(struct extent_io_tree *tree, u64 start, u64 *xprivate);
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 u64 bytenr, u32 blocksize);
 struct extent_buffer *find_first_extent_buffer(struct extent_io_tree *tree,
diff --git a/ioctl.h b/ioctl.h
index b7f1ce3..56de39f 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -22,6 +22,10 @@
 #include <linux/ioctl.h>
 #include <time.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
 
@@ -439,4 +443,9 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 					struct btrfs_ioctl_qgroup_limit_args)
+
+#ifdef __cplusplus
+}
+#endif
+
 #endif
diff --git a/list.h b/list.h
index d31090c..50f4619 100644
--- a/list.h
+++ b/list.h
@@ -19,8 +19,8 @@
 #ifndef _LINUX_LIST_H
 #define _LINUX_LIST_H
 
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
+#define LIST_POISON1  ((struct list_head *) 0x00100100)
+#define LIST_POISON2  ((struct list_head *) 0x00200200)
 
 /*
  * Simple doubly linked list implementation.
@@ -54,17 +54,17 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
  * the prev/next entries already!
  */
 #ifndef CONFIG_DEBUG_LIST
-static inline void __list_add(struct list_head *new,
+static inline void __list_add(struct list_head *xnew,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
+	next->prev = xnew;
+	xnew->next = next;
+	xnew->prev = prev;
+	prev->next = xnew;
 }
 #else
-extern void __list_add(struct list_head *new,
+extern void __list_add(struct list_head *xnew,
 			      struct list_head *prev,
 			      struct list_head *next);
 #endif
@@ -78,12 +78,12 @@ extern void __list_add(struct list_head *new,
  * This is good for implementing stacks.
  */
 #ifndef CONFIG_DEBUG_LIST
-static inline void list_add(struct list_head *new, struct list_head *head)
+static inline void list_add(struct list_head *xnew, struct list_head *head)
 {
-	__list_add(new, head, head->next);
+	__list_add(xnew, head, head->next);
 }
 #else
-extern void list_add(struct list_head *new, struct list_head *head);
+extern void list_add(struct list_head *xnew, struct list_head *head);
 #endif
 
 
@@ -95,9 +95,9 @@ extern void list_add(struct list_head *new, struct list_head *head);
  * Insert a new entry before the specified head.
  * This is useful for implementing queues.
  */
-static inline void list_add_tail(struct list_head *new, struct list_head *head)
+static inline void list_add_tail(struct list_head *xnew, struct list_head *head)
 {
-	__list_add(new, head->prev, head);
+	__list_add(xnew, head->prev, head);
 }
 
 /*
@@ -137,18 +137,18 @@ extern void list_del(struct list_head *entry);
  * Note: if 'old' was empty, it will be overwritten.
  */
 static inline void list_replace(struct list_head *old,
-				struct list_head *new)
+				struct list_head *xnew)
 {
-	new->next = old->next;
-	new->next->prev = new;
-	new->prev = old->prev;
-	new->prev->next = new;
+	xnew->next = old->next;
+	xnew->next->prev = xnew;
+	xnew->prev = old->prev;
+	xnew->prev->next = xnew;
 }
 
 static inline void list_replace_init(struct list_head *old,
-					struct list_head *new)
+					struct list_head *xnew)
 {
-	list_replace(old, new);
+	list_replace(old, xnew);
 	INIT_LIST_HEAD(old);
 }
 /**
diff --git a/rbtree.h b/rbtree.h
index b636ddd..8f717a9 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -149,7 +149,7 @@ extern struct rb_node *rb_first(struct rb_root *);
 extern struct rb_node *rb_last(struct rb_root *);
 
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
-extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
+extern void rb_replace_node(struct rb_node *victim, struct rb_node *xnew,
 			    struct rb_root *root);
 
 static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
diff --git a/send-stream.h b/send-stream.h
index 9a17e32..9223018 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -18,6 +18,10 @@
 #ifndef SEND_STREAM_H_
 #define SEND_STREAM_H_
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct btrfs_send_ops {
 	int (*subvol)(const char *path, const u8 *uuid, u64 ctransid,
 		      void *user);
@@ -55,5 +59,8 @@ struct btrfs_send_ops {
 int btrfs_read_and_process_send_stream(int fd,
 				       struct btrfs_send_ops *ops, void *user);
 
+#ifdef __cplusplus
+}
+#endif
 
 #endif /* SEND_STREAM_H_ */
diff --git a/send-utils.h b/send-utils.h
index 8040c50..199dd03 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -26,6 +26,10 @@
 #include <btrfs/rbtree.h>
 #endif /* BTRFS_FLAT_INCLUDES */
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum subvol_search_type {
 	subvol_search_by_root_id,
 	subvol_search_by_uuid,
@@ -70,5 +74,8 @@ void subvol_uuid_search_add(struct subvol_uuid_search *s,
 char *path_cat(const char *p1, const char *p2);
 char *path_cat3(const char *p1, const char *p2, const char *p3);
 
+#ifdef __cplusplus
+}
+#endif
 
 #endif /* SEND_UTILS_H_ */
diff --git a/send.h b/send.h
index 48d425a..e8da785 100644
--- a/send.h
+++ b/send.h
@@ -19,6 +19,10 @@
 
 #include "ctree.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
 #define BTRFS_SEND_STREAM_VERSION 1
 
@@ -132,3 +136,7 @@ enum {
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
 #endif
+
+#ifdef __cplusplus
+}
+#endif

--FCuugMFkClbJLl1L--
