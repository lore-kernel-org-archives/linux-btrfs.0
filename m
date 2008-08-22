From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: optmize listxattr
Date: Fri, 22 Aug 2008 03:20:34 +0200
Message-ID: <20080822012034.GA10107@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The ->list handler is really not useful at all, because we always call
btrfs_xattr_generic_list anyway.  After this is done
find_btrfs_xattr_handler becomes unused, and it becomes obvious that the
temporary name buffer allocation isn't needed but we can directly copy
into the supplied buffer.

Tested with various getfattr -d calls on varying xattr lists.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/acl.c
===================================================================
--- btrfs-unstable.orig/acl.c	2008-08-21 22:07:12.000000000 -0300
+++ btrfs-unstable/acl.c	2008-08-21 22:07:32.000000000 -0300
@@ -318,14 +318,12 @@ int btrfs_acl_chmod(struct inode *inode)
 
 struct xattr_handler btrfs_xattr_acl_default_handler = {
 	.prefix = POSIX_ACL_XATTR_DEFAULT,
-	.list	= btrfs_xattr_generic_list,
 	.get	= btrfs_xattr_acl_default_get,
 	.set	= btrfs_xattr_acl_default_set,
 };
 
 struct xattr_handler btrfs_xattr_acl_access_handler = {
 	.prefix = POSIX_ACL_XATTR_ACCESS,
-	.list	= btrfs_xattr_generic_list,
 	.get	= btrfs_xattr_acl_access_get,
 	.set	= btrfs_xattr_acl_access_set,
 };
Index: btrfs-unstable/xattr.c
===================================================================
--- btrfs-unstable.orig/xattr.c	2008-08-21 22:07:12.000000000 -0300
+++ btrfs-unstable/xattr.c	2008-08-21 22:16:37.000000000 -0300
@@ -51,35 +51,6 @@ struct xattr_handler *btrfs_xattr_handle
 };
 
 /*
- * @param name - the xattr name
- * @return - the xattr_handler for the xattr, NULL if its not found
- *
- * use this with listxattr where we don't already know the type of xattr we
- * have
- */
-static struct xattr_handler *find_btrfs_xattr_handler(struct extent_buffer *l,
-						      unsigned long name_ptr,
-						      u16 name_len)
-{
-	struct xattr_handler *handler = NULL;
-	int i = 0;
-
-	for (handler = btrfs_xattr_handlers[i]; handler != NULL; i++,
-	     handler = btrfs_xattr_handlers[i]) {
-		u16 prefix_len = strlen(handler->prefix);
-
-		if (name_len < prefix_len)
-			continue;
-
-		if (memcmp_extent_buffer(l, handler->prefix, name_ptr,
-					 prefix_len) == 0)
-			break;
-	}
-
-	return handler;
-}
-
-/*
  * @param name_index - the index for the xattr handler
  * @return the xattr_handler if we found it, NULL otherwise
  *
@@ -118,19 +89,6 @@ static inline char *get_name(const char 
 	return ret;
 }
 
-size_t btrfs_xattr_generic_list(struct inode *inode, char *list,
-				size_t list_size, const char *name,
-				size_t name_len)
-{
-	if (list && (name_len+1) <= list_size) {
-		memcpy(list, name, name_len);
-		list[name_len] = '\0';
-	} else
-		return -ERANGE;
-
-	return name_len+1;
-}
-
 ssize_t btrfs_xattr_get(struct inode *inode, int name_index,
 			const char *attr_name, void *buffer, size_t size)
 {
@@ -278,11 +236,10 @@ ssize_t btrfs_listxattr(struct dentry *d
 	struct btrfs_item *item;
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
-	struct xattr_handler *handler;
 	int ret = 0, slot, advance;
-	size_t total_size = 0, size_left = size, written;
+	size_t total_size = 0, size_left = size;
 	unsigned long name_ptr;
-	char *name;
+	size_t name_len;
 	u32 nritems;
 
 	/*
@@ -344,37 +301,24 @@ ssize_t btrfs_listxattr(struct dentry *d
 
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
 
-		total_size += btrfs_dir_name_len(leaf, di)+1;
+		name_len = btrfs_dir_name_len(leaf, di);
+		total_size += name_len + 1;
 
 		/* we are just looking for how big our buffer needs to be */
 		if (!size)
 			continue;
 
-		/* find our handler for this xattr */
-		name_ptr = (unsigned long)(di + 1);
-		handler = find_btrfs_xattr_handler(leaf, name_ptr,
-						   btrfs_dir_name_len(leaf, di));
-		if (!handler) {
-			printk(KERN_ERR "btrfs: unsupported xattr found\n");
-			continue;
-		}
-
-		name = kmalloc(btrfs_dir_name_len(leaf, di), GFP_KERNEL);
-		read_extent_buffer(leaf, name, name_ptr,
-				   btrfs_dir_name_len(leaf, di));
-
-		/* call the list function associated with this xattr */
-		written = handler->list(inode, buffer, size_left, name,
-					btrfs_dir_name_len(leaf, di));
-		kfree(name);
-
-		if (written < 0) {
+		if (!buffer || (name_len + 1) > size_left) {
 			ret = -ERANGE;
 			break;
 		}
 
-		size_left -= written;
-		buffer += written;
+		name_ptr = (unsigned long)(di + 1);
+		read_extent_buffer(leaf, buffer, name_ptr, name_len);
+		buffer[name_len] = '\0';
+
+		size_left -= name_len + 1;
+		buffer += name_len + 1;
 	}
 	ret = total_size;
 
@@ -412,28 +356,24 @@ BTRFS_XATTR_SETGET_FUNCS(trusted, BTRFS_
 
 struct xattr_handler btrfs_xattr_security_handler = {
 	.prefix = XATTR_SECURITY_PREFIX,
-	.list	= btrfs_xattr_generic_list,
 	.get	= btrfs_xattr_security_get,
 	.set	= btrfs_xattr_security_set,
 };
 
 struct xattr_handler btrfs_xattr_system_handler = {
 	.prefix = XATTR_SYSTEM_PREFIX,
-	.list	= btrfs_xattr_generic_list,
 	.get	= btrfs_xattr_system_get,
 	.set	= btrfs_xattr_system_set,
 };
 
 struct xattr_handler btrfs_xattr_user_handler = {
 	.prefix	= XATTR_USER_PREFIX,
-	.list	= btrfs_xattr_generic_list,
 	.get	= btrfs_xattr_user_get,
 	.set	= btrfs_xattr_user_set,
 };
 
 struct xattr_handler btrfs_xattr_trusted_handler = {
 	.prefix = XATTR_TRUSTED_PREFIX,
-	.list	= btrfs_xattr_generic_list,
 	.get	= btrfs_xattr_trusted_get,
 	.set	= btrfs_xattr_trusted_set,
 };
Index: btrfs-unstable/xattr.h
===================================================================
--- btrfs-unstable.orig/xattr.h	2008-08-21 22:07:12.000000000 -0300
+++ btrfs-unstable/xattr.h	2008-08-21 22:07:32.000000000 -0300
@@ -47,12 +47,4 @@ ssize_t btrfs_xattr_get(struct inode *in
 int btrfs_xattr_set(struct inode *inode, int name_index, const char *name,
 			const void *value, size_t size, int flags);
 
-/*
- * the only reason this is public is for acl.c.  There may be a point where
- * acl.c doesn't need it, and if thats the case we need to remove it and make
- * it static in xattr.c
- */
-size_t btrfs_xattr_generic_list(struct inode *inode, char *list,
-				size_t list_size, const char *name,
-				size_t name_len);
 #endif /* __XATTR__ */
