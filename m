Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44627 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaBRU3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:08 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 8/9] exportfs: update Exporting documentation
Date: Tue, 18 Feb 2014 15:29:04 -0500
Message-Id: <1392755345-12830-8-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

Minor documentation updates:
	- refer to d_obtain_alias rather than d_alloc_anon
	- explain when to use d_splice_alias and when
	  d_materialise_unique.
	- cut some details of d_splice_alias/d_materialise_unique
	  implementation.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 Documentation/filesystems/nfs/Exporting | 38 ++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/nfs/Exporting b/Documentation/filesystems/nfs/Exporting
index e543b1a..9b7de5b 100644
--- a/Documentation/filesystems/nfs/Exporting
+++ b/Documentation/filesystems/nfs/Exporting
@@ -66,23 +66,31 @@ b/ A per-superblock list "s_anon" of dentries which are the roots of
 
 c/ Helper routines to allocate anonymous dentries, and to help attach
    loose directory dentries at lookup time. They are:
-    d_alloc_anon(inode) will return a dentry for the given inode.
+    d_obtain_alias(inode) will return a dentry for the given inode.
       If the inode already has a dentry, one of those is returned.
       If it doesn't, a new anonymous (IS_ROOT and
         DCACHE_DISCONNECTED) dentry is allocated and attached.
       In the case of a directory, care is taken that only one dentry
       can ever be attached.
-    d_splice_alias(inode, dentry) will make sure that there is a
-      dentry with the same name and parent as the given dentry, and
-      which refers to the given inode.
-      If the inode is a directory and already has a dentry, then that
-      dentry is d_moved over the given dentry.
-      If the passed dentry gets attached, care is taken that this is
-      mutually exclusive to a d_alloc_anon operation.
-      If the passed dentry is used, NULL is returned, else the used
-      dentry is returned.  This corresponds to the calling pattern of
-      ->lookup.
-  
+    d_splice_alias(inode, dentry) or d_materialise_unique(dentry, inode)
+      will introduce a new dentry into the tree; either the passed-in
+      dentry or a preexisting alias for the given inode (such as an
+      anonymous one created by d_obtain_alias), if appropriate.  The two
+      functions differ in their handling of directories with preexisting
+      aliases:
+        d_splice_alias will use any existing IS_ROOT dentry, but it will
+	  return -EIO rather than try to move a dentry with a different
+	  parent.  This is appropriate for local filesystems, which
+	  should never see such an alias unless the filesystem is
+	  corrupted somehow (for example, if two on-disk directory
+	  entries refer to the same directory.)
+	d_obtain_alias will attempt to move any dentry.  This is
+	  appropriate for distributed filesystems, where finding a
+	  directory other than where we last cached it may be a normal
+	  consequence of concurrent operations on other hosts.
+      Both functions return NULL when the passed-in dentry is used,
+      following the calling convention of ->lookup.
+
  
 Filesystem Issues
 -----------------
@@ -120,12 +128,12 @@ struct which has the following members:
 
   fh_to_dentry (mandatory)
     Given a filehandle fragment, this should find the implied object and
-    create a dentry for it (possibly with d_alloc_anon).
+    create a dentry for it (possibly with d_obtain_alias).
 
   fh_to_parent (optional but strongly recommended)
     Given a filehandle fragment, this should find the parent of the
-    implied object and create a dentry for it (possibly with d_alloc_anon).
-    May fail if the filehandle fragment is too small.
+    implied object and create a dentry for it (possibly with
+    d_obtain_alias).  May fail if the filehandle fragment is too small.
 
   get_parent (optional but strongly recommended)
     When given a dentry for a directory, this should return  a dentry for
-- 
1.8.5.3

