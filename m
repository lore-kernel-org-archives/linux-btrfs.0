Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C18C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0EB206BA
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554395426;
	bh=gHrOooBlhp+ENVOw5VsYc+T/Hlqsw0bVjGQ5i8WPwpo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=e5hOsCyeyhsfv8WoqxKmeuYMPBxnWxaqvyctzcIYAerBTpGb1n9C3Vg8bEVkFyMJb
	 W8azSWpF2diMDtWxzKMzZns9AZGPkpdRRaIk7MNfrhPN6Tb0WgUbwf/DbFZfaZXDtc
	 XUGeBYyMbpjEWjbVVUK0ON1QeDXuvknYg913Z2Jg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfDDQa0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfDDQaZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:30:25 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6BC420855;
        Thu,  4 Apr 2019 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554395424;
        bh=gHrOooBlhp+ENVOw5VsYc+T/Hlqsw0bVjGQ5i8WPwpo=;
        h=From:To:Cc:Subject:Date:From;
        b=Irbi0+bKKZWeXS9j5reOoxPiZXLzUfbFM6JM/VO3hKaRDuctaklaRRCY+SLgfjA01
         +QghRiVc6syptXyBc+lJE2DhVtddJ20mOunYhSTYoO6+/Xdrt8N3YEl136Tu3AqRgP
         hajKCsTU16lfFjfb9AWhEZ2rj9VV9R3ROUwNR2eY=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3 3/7] fsstress: add operation for setting xattrs on files and directories
Date:   Thu,  4 Apr 2019 17:30:18 +0100
Message-Id: <20190404163018.19129-1-fdmanana@kernel.org>
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
Values for the xattrs have at most 100 bytes, which is more than the
maximum size supported for all major filesystems.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use a different name for the operation (setfattr instead of the already
    taken setxattr) and make use of the helper functions for opening and
    closing files or directories, introduced in the first patch of this
    series.
V3: Simplified implementation to not need to open a file descriptor and
    use a path string instead.

 ltp/fsstress.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 131 insertions(+), 9 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 3ec19143..d1db19da 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -27,6 +27,7 @@
 io_context_t	io_ctx;
 #endif
 #include <sys/syscall.h>
+#include <sys/xattr.h>
 
 #ifndef FS_IOC_GETFLAGS
 #define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
@@ -84,6 +85,7 @@ typedef enum {
 	OP_RESVSP,
 	OP_RMDIR,
 	OP_SETATTR,
+	OP_SETFATTR,
 	OP_SETXATTR,
 	OP_SPLICE,
 	OP_STAT,
@@ -110,6 +112,7 @@ typedef struct opdesc {
 typedef struct fent {
 	int	id;
 	int	parent;
+	int	xattr_counter;
 } fent_t;
 
 typedef struct flist {
@@ -156,6 +159,8 @@ struct print_string {
 #define	MAXFSIZE	((1ULL << 63) - 1ULL)
 #define	MAXFSIZE32	((1ULL << 40) - 1ULL)
 
+#define XATTR_NAME_BUF_SIZE 18
+
 void	afsync_f(int, long);
 void	allocsp_f(int, long);
 void	aread_f(int, long);
@@ -176,6 +181,7 @@ void	fdatasync_f(int, long);
 void	fiemap_f(int, long);
 void	freesp_f(int, long);
 void	fsync_f(int, long);
+char	*gen_random_string(int);
 void	getattr_f(int, long);
 void	getdents_f(int, long);
 void	link_f(int, long);
@@ -194,6 +200,7 @@ void	rename_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setattr_f(int, long);
+void	setfattr_f(int, long);
 void	setxattr_f(int, long);
 void	splice_f(int, long);
 void	stat_f(int, long);
@@ -204,6 +211,7 @@ void	unlink_f(int, long);
 void	unresvsp_f(int, long);
 void	write_f(int, long);
 void	writev_f(int, long);
+char	*xattr_flag_to_string(int);
 
 opdesc_t	ops[] = {
      /* { OP_ENUM, "name", function, freq, iswrite }, */
@@ -245,6 +253,7 @@ opdesc_t	ops[] = {
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
 	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
+	{ OP_SETFATTR, "setfattr", setfattr_f, 4, 1 },
 	{ OP_SETXATTR, "setxattr", setxattr_f, 1, 1 },
 	{ OP_SPLICE, "splice", splice_f, 1, 1 },
 	{ OP_STAT, "stat", stat_f, 1, 0 },
@@ -296,7 +305,7 @@ char		*execute_cmd = NULL;
 int		execute_freq = 1;
 struct print_string	flag_str = {0};
 
-void	add_to_flist(int, int, int);
+void	add_to_flist(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
 int	attr_list_path(pathname_t *, char *, const int, int, attrlist_cursor_t *);
 int	attr_remove_path(pathname_t *, const char *, int);
@@ -315,6 +324,7 @@ int	fent_to_name(pathname_t *, flist_t *, fent_t *);
 void	fix_parent(int, int);
 void	free_pathname(pathname_t *);
 int	generate_fname(fent_t *, int, pathname_t *, int *, int *);
+void	generate_xattr_name(int, char *);
 int	get_fname(int, long, pathname_t *, flist_t **, fent_t **, int *);
 void	init_pathname(pathname_t *);
 int	lchown_path(pathname_t *, uid_t, gid_t);
@@ -716,7 +726,7 @@ translate_flags(int flags, const char *delim,
 }
 
 void
-add_to_flist(int ft, int id, int parent)
+add_to_flist(int ft, int id, int parent, int xattr_counter)
 {
 	fent_t	*fep;
 	flist_t	*ftp;
@@ -729,6 +739,7 @@ add_to_flist(int ft, int id, int parent)
 	fep = &ftp->fents[ftp->nfiles++];
 	fep->id = id;
 	fep->parent = parent;
+	fep->xattr_counter = xattr_counter;
 }
 
 void
@@ -1122,6 +1133,12 @@ generate_fname(fent_t *fep, int ft, pathname_t *name, int *idp, int *v)
 	return 1;
 }
 
+void generate_xattr_name(int xattr_num, char *buffer)
+{
+	memcpy(buffer, "user.x", 6);
+	sprintf(buffer + 6, "%d", xattr_num);
+}
+
 /*
  * Get file 
  * Input: "which" to choose the file-types eg. non-directory
@@ -3030,7 +3047,7 @@ creat_f(int opno, long r)
 			if (xfsctl(f.path, fd, XFS_IOC_FSSETXATTR, &a) < 0)
 				e1 = errno;
 		}
-		add_to_flist(type, id, parid);
+		add_to_flist(type, id, parid, 0);
 		close(fd);
 	}
 	if (v) {
@@ -3495,6 +3512,28 @@ fsync_f(int opno, long r)
 	close(fd);
 }
 
+char *
+gen_random_string(int len)
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
+		s[i] = charset[random() % sizeof(charset)];
+
+	return s;
+}
+
 void
 getattr_f(int opno, long r)
 {
@@ -3551,6 +3590,7 @@ link_f(int opno, long r)
 	int		e;
 	pathname_t	f;
 	fent_t		*fep;
+	fent_t		*fep_src;
 	flist_t		*flp;
 	int		id;
 	pathname_t	l;
@@ -3559,7 +3599,7 @@ link_f(int opno, long r)
 	int		v1;
 
 	init_pathname(&f);
-	if (!get_fname(FT_NOTDIR, r, &f, &flp, NULL, &v1)) {
+	if (!get_fname(FT_NOTDIR, r, &f, &flp, &fep_src, &v1)) {
 		if (v1)
 			printf("%d/%d: link - no file\n", procid, opno);
 		free_pathname(&f);
@@ -3586,7 +3626,7 @@ link_f(int opno, long r)
 	e = link_path(&f, &l) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(flp - flist, id, parid);
+		add_to_flist(flp - flist, id, parid, fep_src->xattr_counter);
 	if (v) {
 		printf("%d/%d: link %s %s %d\n", procid, opno, f.path, l.path,
 			e);
@@ -3626,7 +3666,7 @@ mkdir_f(int opno, long r)
 	e = mkdir_path(&f, 0777) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(FT_DIR, id, parid);
+		add_to_flist(FT_DIR, id, parid, 0);
 	if (v) {
 		printf("%d/%d: mkdir %s %d\n", procid, opno, f.path, e);
 		printf("%d/%d: mkdir add id=%d,parent=%d\n", procid, opno, id, parid);
@@ -3664,7 +3704,7 @@ mknod_f(int opno, long r)
 	e = mknod_path(&f, S_IFCHR|0444, 0) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(FT_DEV, id, parid);
+		add_to_flist(FT_DEV, id, parid, 0);
 	if (v) {
 		printf("%d/%d: mknod %s %d\n", procid, opno, f.path, e);
 		printf("%d/%d: mknod add id=%d,parent=%d\n", procid, opno, id, parid);
@@ -4040,12 +4080,14 @@ rename_f(int opno, long r)
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
@@ -4168,6 +4210,76 @@ setattr_f(int opno, long r)
 }
 
 void
+setfattr_f(int opno, long r)
+{
+	int		e;
+	pathname_t	f;
+	fent_t	        *fep;
+	int		v;
+	int             value_len;
+	char            name[XATTR_NAME_BUF_SIZE];
+	char            *value = NULL;
+	int             flag = 0;
+	int             xattr_num;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, &fep, &v)) {
+		if (v)
+			printf("%d/%d: setfattr - no filename\n", procid, opno);
+		goto out;
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
+		xattr_num = fep->xattr_counter + 1;
+		/*
+		 * Don't always use the create flag because even if our xattr
+		 * counter is 0, we may still have xattrs associated to this
+		 * file (this happens when xattrs are added to a file through
+		 * one of its other hard links), so we can end up updating an
+		 * existing xattr too.
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
+	value = gen_random_string(value_len);
+	if (!value && value_len > 0) {
+		if (v)
+			printf("%d/%d: setfattr - file %s failed to allocate value with %d bytes\n",
+			       procid, opno, f.path, value_len);
+		goto out;
+	}
+	generate_xattr_name(xattr_num, name);
+
+	e = setxattr(f.path, name, value, value_len, flag) < 0 ? errno : 0;
+	if (e == 0)
+		fep->xattr_counter++;
+	if (v)
+		printf("%d/%d: setfattr file %s name %s flag %s value length %d: %d\n",
+		       procid, opno, f.path, name, xattr_flag_to_string(flag),
+		       value_len, e);
+out:
+	free(value);
+	free_pathname(&f);
+}
+
+void
 stat_f(int opno, long r)
 {
 	int		e;
@@ -4229,7 +4341,7 @@ symlink_f(int opno, long r)
 	e = symlink_path(val, &f) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0)
-		add_to_flist(FT_SYM, id, parid);
+		add_to_flist(FT_SYM, id, parid, 0);
 	free(val);
 	if (v) {
 		printf("%d/%d: symlink %s %d\n", procid, opno, f.path, e);
@@ -4498,3 +4610,13 @@ writev_f(int opno, long r)
 	free_pathname(&f);
 	close(fd);
 }
+
+char *
+xattr_flag_to_string(int flag)
+{
+	if (flag == XATTR_CREATE)
+		return "create";
+	if (flag == XATTR_REPLACE)
+		return "replace";
+	return "none";
+}
-- 
2.11.0

