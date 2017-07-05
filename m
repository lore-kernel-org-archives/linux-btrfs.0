Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdGEPYN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Jul 2017 11:24:13 -0400
Subject: [PATCH 01/14] VFS: Don't use save/replace_mount_options if not
 using generic_show_options
From: David Howells <dhowells@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        reiserfs-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        Chris Mason <clm@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date: Wed, 05 Jul 2017 16:24:09 +0100
Message-ID: <149926824918.20611.721200514474820755.stgit@warthog.procyon.org.uk>
In-Reply-To: <149926824154.20611.6104595541055328700.stgit@warthog.procyon.org.uk>
References: <149926824154.20611.6104595541055328700.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs, debugfs, reiserfs and tracefs call save_mount_options() and reiserfs
calls replace_mount_options(), but they then implement their own
->show_options() methods and don't touch s_options, rendering the saved
options unnecessary.  I'm trying to eliminate s_options to make it easier
to implement a context-based mount where the mount options can be passed
individually over a file descriptor.

Remove the calls to save/replace_mount_options() call in these cases.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chris Mason <clm@fb.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>
cc: linux-btrfs@vger.kernel.org
cc: reiserfs-devel@vger.kernel.org
---

 fs/btrfs/super.c    |    1 -
 fs/debugfs/inode.c  |    2 --
 fs/reiserfs/super.c |    4 ----
 fs/tracefs/inode.c  |    2 --
 4 files changed, 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4f1cdd5058f1..8e9758b3eb23 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1164,7 +1164,6 @@ static int btrfs_fill_super(struct super_block *sb,
 		goto fail_close;
 	}
 
-	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
 	return 0;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index e892ae7d89f8..0dc9e9c0e0f8 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -203,8 +203,6 @@ static int debug_fill_super(struct super_block *sb, void *data, int silent)
 	struct debugfs_fs_info *fsi;
 	int err;
 
-	save_mount_options(sb, data);
-
 	fsi = kzalloc(sizeof(struct debugfs_fs_info), GFP_KERNEL);
 	sb->s_fs_info = fsi;
 	if (!fsi) {
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 685f1e056998..306e4e9d172d 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1599,8 +1599,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	}
 
 out_ok_unlocked:
-	if (new_opts)
-		replace_mount_options(s, new_opts);
 	return 0;
 
 out_err_unlock:
@@ -1916,8 +1914,6 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	char *qf_names[REISERFS_MAXQUOTAS] = {};
 	unsigned int qfmt = 0;
 
-	save_mount_options(s, data);
-
 	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 328e89c2cf83..bea8ad876bf9 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -270,8 +270,6 @@ static int trace_fill_super(struct super_block *sb, void *data, int silent)
 	struct tracefs_fs_info *fsi;
 	int err;
 
-	save_mount_options(sb, data);
-
 	fsi = kzalloc(sizeof(struct tracefs_fs_info), GFP_KERNEL);
 	sb->s_fs_info = fsi;
 	if (!fsi) {

