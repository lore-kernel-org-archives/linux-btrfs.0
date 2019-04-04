Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8693BC4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 566C4206BA
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554395437;
	bh=uvTC6tiC+FydICQCu04fvhjudIz+oyFLBSEaCHIzHQU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=z0iuwcfi12NvWcUpqy8vOBwKIWxgRd4rokqvgnyeJ/0ObvW2+Jb16XHoxlWoBt5Qp
	 BT2HMjSyJrprW45tpGnS44y43T3EQL4UAUsHO5BIwrnIg7O8fp1/ElFqfUufc8nPZ4
	 bnLPncol0o5ObFuT9S9Zp5ry1On4mXIizz+tVkS8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfDDQag (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfDDQag (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:30:36 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56CEC206BA;
        Thu,  4 Apr 2019 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554395435;
        bh=uvTC6tiC+FydICQCu04fvhjudIz+oyFLBSEaCHIzHQU=;
        h=From:To:Cc:Subject:Date:From;
        b=T9jcuZ5f+QyyrXAQMwm/gGbVZOTsv31LN1EJx+9eCzRKDQUwKpLWJBpvCohuEE9Yr
         GpTCbjRFwteEZOLhwboWWIgYeram/P0c0gd8uXA78U7tQUOUhSnJmPvPOgtr+sub7R
         AW4UzvMTuyqmCTljlH6yqVzm2jWvjIfZLAAY9a1M=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3 4/7] fsstress: add operation for reading xattrs from files and directories
Date:   Thu,  4 Apr 2019 17:30:30 +0100
Message-Id: <20190404163030.19179-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The previous patch added support for an operation to set xattrs on regular
files and directories, this patch just adds one operation to read (get)
them.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use a different name for the operation (getfattr) and make use of the
    helper functions for opening and closing files or directories, introduced
    in the first patch of this series.
V3: Simplified implementation to not need to open a file descriptor and
    use a path string instead.  

 ltp/fsstress.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index d1db19da..7c924e01 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -69,6 +69,7 @@ typedef enum {
 	OP_FSYNC,
 	OP_GETATTR,
 	OP_GETDENTS,
+	OP_GETFATTR,
 	OP_LINK,
 	OP_MKDIR,
 	OP_MKNOD,
@@ -184,6 +185,7 @@ void	fsync_f(int, long);
 char	*gen_random_string(int);
 void	getattr_f(int, long);
 void	getdents_f(int, long);
+void	getfattr_f(int, long);
 void	link_f(int, long);
 void	mkdir_f(int, long);
 void	mknod_f(int, long);
@@ -237,6 +239,7 @@ opdesc_t	ops[] = {
 	{ OP_FSYNC, "fsync", fsync_f, 1, 1 },
 	{ OP_GETATTR, "getattr", getattr_f, 1, 0 },
 	{ OP_GETDENTS, "getdents", getdents_f, 1, 0 },
+	{ OP_GETFATTR, "getfattr", getfattr_f, 2, 0 },
 	{ OP_LINK, "link", link_f, 1, 1 },
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
@@ -3585,6 +3588,70 @@ getdents_f(int opno, long r)
 }
 
 void
+getfattr_f(int opno, long r)
+{
+	fent_t	        *fep;
+	int		e;
+	pathname_t	f;
+	int		v;
+	char            name[XATTR_NAME_BUF_SIZE];
+	char            *value = NULL;
+	int             value_len;
+	int             xattr_num;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, &fep, &v)) {
+		if (v)
+			printf("%d/%d: getfattr - no filename\n", procid, opno);
+		goto out;
+	}
+	check_cwd();
+
+	/*
+	 * If the file/dir has xattrs, pick one randomly, otherwise attempt
+	 * to read a xattr that doesn't exist (getxattr should fail with
+	 * errno set to ENOATTR (61) in this case).
+	 */
+	if (fep->xattr_counter > 0)
+		xattr_num = (random() % fep->xattr_counter) + 1;
+	else
+		xattr_num = 0;
+
+	generate_xattr_name(xattr_num, name);
+
+	value_len = getxattr(f.path, name, NULL, 0);
+	if (value_len < 0) {
+		if (v)
+			printf("%d/%d: getfattr file %s name %s failed %d\n",
+			       procid, opno, f.path, name, errno);
+		goto out;
+	}
+
+	/* A xattr without value.*/
+	if (value_len == 0) {
+		e = 0;
+		goto out_log;
+	}
+
+	value = malloc(value_len);
+	if (!value) {
+		if (v)
+			printf("%d/%d: getfattr file %s failed to allocate buffer with %d bytes\n",
+			       procid, opno, f.path, value_len);
+		goto out;
+	}
+
+	e = getxattr(f.path, name, value, value_len) < 0 ? errno : 0;
+out_log:
+	if (v)
+		printf("%d/%d: getfattr file %s name %s value length %d %d\n",
+		       procid, opno, f.path, name, value_len, e);
+out:
+	free(value);
+	free_pathname(&f);
+}
+
+void
 link_f(int opno, long r)
 {
 	int		e;
-- 
2.11.0

