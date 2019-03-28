Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E603C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D83462173C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553799252;
	bh=M+3honXGH6YFbXRUbAZmEjgeNo6sdzUonaVrBVGm/3k=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Ga2+ma7kMXNAAWwINihbkZeM42fMXajRH/A0XQP1y3XVxTfLeUxlDkDIEEmXZQ62Z
	 jjwMUbJ7sJJe5hcLk+uJpSIimF4TTKxkRdMFAH/4mnalKA5SOogwtseGxxTvo+BWV3
	 O/rjMF++XVshlFfNyrVTz901GEeWTHXQ8wDSUgbU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfC1SyL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 14:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfC1SyL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 14:54:11 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D71D720823;
        Thu, 28 Mar 2019 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553799249;
        bh=M+3honXGH6YFbXRUbAZmEjgeNo6sdzUonaVrBVGm/3k=;
        h=From:To:Cc:Subject:Date:From;
        b=IvERS/GMZIf1Gv2WuRitV4qwEbggJFY0k0YgHkTR9IfLdggOpM2o/Mt+72I8Rgq+C
         xfLo1vcGlbReIa1mo+cbtonWjR7PjwQAl9SldhHqy+KM13eOOC7DrEoteugJ6qPmfK
         /hlP69VTdg/I/vzGIKmPsMC6KCLk/HhhMeTSqmRA=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/7] fsstress: add operation for setting xattrs on files and directories
Date:   Thu, 28 Mar 2019 18:54:04 +0000
Message-Id: <20190328185404.28879-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently fsstress does not exercise creating, reading or deleting xattrs
on files or directories. This change adds support for setting xattrs on
files and directories, using only the xattr user namespace (the other
namespaces are not general purpose and are used for security, capabilities,
ACLs, etc). This adds a counter for each file entry structure that keeps
track of the number of xattrs set for the file entry, and each new xattr
has a name that includes the counter's value (example: "user.x4").
Values for the xattrs have at most 100 bytes, which is much more than
the maximum size supported for all major filesystems.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 ltp/fsstress.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 141 insertions(+), 9 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index cc4f520e..03e40eb6 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -27,6 +27,7 @@
 io_context_t	io_ctx;
 #endif
 #include <sys/syscall.h>
+#include <sys/xattr.h>
 
 #ifndef FS_IOC_GETFLAGS
 #define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
@@ -85,6 +86,7 @@ typedef enum {
 	OP_RESVSP,
 	OP_RMDIR,
 	OP_SETATTR,
+	OP_SETXATTR,
 	OP_SPLICE,
 	OP_STAT,
 	OP_SYMLINK,
@@ -110,6 +112,7 @@ typedef struct opdesc {
 typedef struct fent {
 	int	id;
 	int	parent;
+	int     xattr_counter;
 } fent_t;
 
 typedef struct flist {
@@ -195,6 +198,7 @@ void	rename_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setattr_f(int, long);
+void	setxattr_f(int, long);
 void	splice_f(int, long);
 void	stat_f(int, long);
 void	symlink_f(int, long);
@@ -246,6 +250,7 @@ opdesc_t	ops[] = {
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
 	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
+	{ OP_SETXATTR, "setxattr", setxattr_f, 4, 1 },
 	{ OP_SPLICE, "splice", splice_f, 1, 1 },
 	{ OP_STAT, "stat", stat_f, 1, 0 },
 	{ OP_SYMLINK, "symlink", symlink_f, 2, 1 },
@@ -296,7 +301,7 @@ char		*execute_cmd = NULL;
 int		execute_freq = 1;
 struct print_string	flag_str = {0};
 
-void	add_to_flist(int, int, int);
+void	add_to_flist(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
 int	attr_list_path(pathname_t *, char *, const int, int, attrlist_cursor_t *);
 int	attr_remove_path(pathname_t *, const char *, int);
@@ -715,7 +720,7 @@ translate_flags(int flags, const char *delim,
 }
 
 void
-add_to_flist(int ft, int id, int parent)
+add_to_flist(int ft, int id, int parent, int xattr_counter)
 {
 	fent_t	*fep;
 	flist_t	*ftp;
@@ -728,6 +733,7 @@ add_to_flist(int ft, int id, int parent)
 	fep = &ftp->fents[ftp->nfiles++];
 	fep->id = id;
 	fep->parent = parent;
+	fep->xattr_counter = xattr_counter;
 }
 
 void
@@ -3000,7 +3006,7 @@ creat_f(int opno, long r)
 			if (xfsctl(f.path, fd, XFS_IOC_FSSETXATTR, &a) < 0)
 				e1 = errno;
 		}
-		add_to_flist(type, id, parid);
+		add_to_flist(type, id, parid, 0);
 		close(fd);
 	}
 	if (v) {
@@ -3527,9 +3533,10 @@ link_f(int opno, long r)
 	int		parid;
 	int		v;
 	int		v1;
+	fent_t		*fep_source;
 
 	init_pathname(&f);
-	if (!get_fname(FT_NOTDIR, r, &f, &flp, NULL, &v1)) {
+	if (!get_fname(FT_NOTDIR, r, &f, &flp, &fep_source, &v1)) {
 		if (v1)
 			printf("%d/%d: link - no file\n", procid, opno);
 		free_pathname(&f);
@@ -3556,7 +3563,7 @@ link_f(int opno, long r)
 	e = link_path(&f, &l) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(flp - flist, id, parid);
+		add_to_flist(flp - flist, id, parid, fep_source->xattr_counter);
 	if (v) {
 		printf("%d/%d: link %s %s %d\n", procid, opno, f.path, l.path,
 			e);
@@ -3596,7 +3603,7 @@ mkdir_f(int opno, long r)
 	e = mkdir_path(&f, 0777) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(FT_DIR, id, parid);
+		add_to_flist(FT_DIR, id, parid, 0);
 	if (v) {
 		printf("%d/%d: mkdir %s %d\n", procid, opno, f.path, e);
 		printf("%d/%d: mkdir add id=%d,parent=%d\n", procid, opno, id, parid);
@@ -3634,7 +3641,7 @@ mknod_f(int opno, long r)
 	e = mknod_path(&f, S_IFCHR|0444, 0) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(FT_DEV, id, parid);
+		add_to_flist(FT_DEV, id, parid, 0);
 	if (v) {
 		printf("%d/%d: mknod %s %d\n", procid, opno, f.path, e);
 		printf("%d/%d: mknod add id=%d,parent=%d\n", procid, opno, id, parid);
@@ -4010,12 +4017,14 @@ rename_f(int opno, long r)
 	e = rename_path(&f, &newf) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0) {
+		int xattr_counter = fep->xattr_counter;
+
 		if (flp - flist == FT_DIR) {
 			oldid = fep->id;
 			fix_parent(oldid, id);
 		}
 		del_from_flist(flp - flist, fep - flp->fents);
-		add_to_flist(flp - flist, id, parid);
+		add_to_flist(flp - flist, id, parid, xattr_counter);
 	}
 	if (v) {
 		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
@@ -4137,6 +4146,129 @@ setattr_f(int opno, long r)
 	close(fd);
 }
 
+char *gen_random_string(int len)
+{
+	static const char charset[] = "0123456789"
+		"abcdefghijklmnopqrstuvwxyz"
+		"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+	int i;
+	char *s;
+
+	if (len == 0)
+		return NULL;
+
+	s = malloc(len);
+	if (!s)
+		return NULL;
+
+	for (i = 0; i < len; i++)
+		s[i] = charset[random() % (sizeof(charset))];
+
+	return s;
+}
+
+char *xattr_flag_to_string(int flag)
+{
+	if (flag == XATTR_CREATE)
+		return "create";
+	if (flag == XATTR_REPLACE)
+		return "replace";
+	return "none";
+}
+
+void
+setxattr_f(int opno, long r)
+{
+	int		fd;
+	int		e;
+	pathname_t	f;
+	fent_t	        *fep;
+	int		v;
+	int             value_len;
+	char            name[18];
+	char            *value;
+	int             flag = 0;
+	int             xattr_num;
+	DIR             *dir = NULL;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, &fep, &v)) {
+		if (v)
+			printf("%d/%d: setxattr - no filename\n", procid, opno);
+		free_pathname(&f);
+		return;
+	}
+	fd = open_path(&f, O_WRONLY);
+	if (fd < 0 && errno == EISDIR) {
+		dir = opendir_path(&f);
+		if (dir)
+			fd = dirfd(dir);
+	}
+	e = fd < 0 ? errno : 0;
+	if (fd < 0) {
+		if (v)
+			printf("%d/%d: setxattr - open %s failed %d\n",
+			       procid, opno, f.path, e);
+		free_pathname(&f);
+		if (dir)
+			closedir(dir);
+		return;
+	}
+	check_cwd();
+
+	if ((fep->xattr_counter > 0) && (random() % 2)) {
+		/*
+		 * Use an existing xattr name for replacing its value or
+		 * create again a xattr that was previously deleted.
+		 */
+		xattr_num = (random() % fep->xattr_counter) + 1;
+		if (random() % 2)
+			flag = XATTR_REPLACE;
+	} else {
+		/* Use a new xattr name. */
+		fep->xattr_counter++;
+		xattr_num = fep->xattr_counter;
+		/*
+		 * Don't always use the create flag because even if our xattr
+		 * counter is 0, we may still have xattrs associated to this
+		 * file - this happens when xattrs are added to a file through
+		 * one of its other hard links.
+		 */
+		if (random() % 2)
+			flag = XATTR_CREATE;
+	}
+
+	/*
+	 * The maximum supported value size depends on the filesystem
+	 * implementation, but 100 bytes is a safe value for most filesystems
+	 * at least.
+	 */
+	value_len = random() % 101;
+
+	memcpy(name, "user.x", 6);
+	sprintf(name + 6, "%d", xattr_num);
+	value = gen_random_string(value_len);
+	if (!value && value_len > 0) {
+		if (v)
+			printf("%d/%d: setxattr - file %s failed to allocate value with %d bytes\n",
+			       procid, opno, f.path, value_len);
+		goto out;
+	}
+
+	e = fsetxattr(fd, name, value, value_len, flag) < 0 ? errno : 0;
+	if (v)
+		printf("%d/%d: setxattr file %s name %s flag %s value length %d: %d\n",
+		       procid, opno, f.path, name, xattr_flag_to_string(flag),
+		       value_len, e);
+out:
+	free(value);
+	free_pathname(&f);
+	if (dir)
+		closedir(dir);
+	else
+		close(fd);
+}
+
 void
 stat_f(int opno, long r)
 {
@@ -4199,7 +4331,7 @@ symlink_f(int opno, long r)
 	e = symlink_path(val, &f) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(FT_SYM, id, parid);
+		add_to_flist(FT_SYM, id, parid, 0);
 	free(val);
 	if (v) {
 		printf("%d/%d: symlink %s %d\n", procid, opno, f.path, e);
-- 
2.11.0

