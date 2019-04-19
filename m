Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C6C282E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10EB3204EC
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555698783;
	bh=DCUCna3mHUDw8Zvkxe4Nntuy7Hba1z0r1fDJrMvqC+I=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=tEC+RvzJkcGwkFeh/azkbXF5nWNaHJ/mtwVHhbP3PmYxYkIW/PeLkstzFi1V/hkf0
	 6MSZD3aJ9s2gTG0GNNofEOEPdzKyvoUO3uKQnsB6XQdARhqSFLvhFTg3gtM5k2wsM4
	 spBuVpq5CS5DR+lvVNnkAjqfOXZr85WQJZw4D5xc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfDSScz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfDSS3R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 14:29:17 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F0721905;
        Fri, 19 Apr 2019 10:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555671306;
        bh=DCUCna3mHUDw8Zvkxe4Nntuy7Hba1z0r1fDJrMvqC+I=;
        h=From:To:Cc:Subject:Date:From;
        b=0JhKbidJjCD2zIdvuENOVED58crFb1aQlBP2xRhCeBLRLZehuSRv1PSATmjEmWC4d
         KHIUa4Xap5w68pmkb4BVYWDzXB0EE3pn522yjsB/IgIQl6W1cceNzP5ETINb5htpIL
         8tJ+mYvSXx7FgmNLJFQ+Eas+caR0AutA+DMCx+/E=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v4 6/7] fsstress: add operation for listing xattrs from files and directories
Date:   Fri, 19 Apr 2019 11:55:00 +0100
Message-Id: <20190419105500.12034-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The previous patches added support for operations to set, get and delete
xattrs on regular files and directories, this patch just adds an operation
to list the xattrs of a file/directory.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: New patch in the series, the first version of the patchset did not include
    this patch.
V3: Simplified implementation to not need to open a file descriptor and
    use a path string instead.  
V4: Addressed Eryu's comments.

 ltp/fsstress.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 74100948..450cf4f1 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -71,6 +71,7 @@ typedef enum {
 	OP_GETDENTS,
 	OP_GETFATTR,
 	OP_LINK,
+	OP_LISTFATTR,
 	OP_MKDIR,
 	OP_MKNOD,
 	OP_MREAD,
@@ -188,6 +189,7 @@ void	getattr_f(int, long);
 void	getdents_f(int, long);
 void	getfattr_f(int, long);
 void	link_f(int, long);
+void	listfattr_f(int, long);
 void	mkdir_f(int, long);
 void	mknod_f(int, long);
 void	mread_f(int, long);
@@ -244,6 +246,8 @@ opdesc_t	ops[] = {
 	/* get extended attribute */
 	{ OP_GETFATTR, "getfattr", getfattr_f, 1, 0 },
 	{ OP_LINK, "link", link_f, 1, 1 },
+	/* list extent attributes */
+	{ OP_LISTFATTR, "listfattr", listfattr_f, 1, 0 },
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
 	{ OP_MREAD, "mread", mread_f, 2, 0 },
@@ -3723,6 +3727,56 @@ link_f(int opno, long r)
 }
 
 void
+listfattr_f(int opno, long r)
+{
+	fent_t	        *fep;
+	int		e;
+	pathname_t	f;
+	int		v;
+	char            *buffer = NULL;
+	int             buffer_len;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, &fep, &v)) {
+		if (v)
+			printf("%d/%d: listfattr - no filename\n", procid, opno);
+		goto out;
+	}
+	check_cwd();
+
+	e = listxattr(f.path, NULL, 0);
+	if (e < 0) {
+		if (v)
+			printf("%d/%d: listfattr %s failed %d\n",
+			       procid, opno, f.path, errno);
+		goto out;
+	}
+	buffer_len = e;
+	if (buffer_len == 0) {
+		if (v)
+			printf("%d/%d: listfattr %s - has no extended attributes\n",
+			       procid, opno, f.path);
+		goto out;
+	}
+
+	buffer = malloc(buffer_len);
+	if (!buffer) {
+		if (v)
+			printf("%d/%d: listfattr %s failed to allocate buffer with %d bytes\n",
+			       procid, opno, f.path, buffer_len);
+		goto out;
+	}
+
+	e = listxattr(f.path, buffer, buffer_len) < 0 ? errno : 0;
+	if (v)
+		printf("%d/%d: listfattr %s buffer length %d %d\n",
+		       procid, opno, f.path, buffer_len, e);
+out:
+	free(buffer);
+	free_pathname(&f);
+}
+
+void
 mkdir_f(int opno, long r)
 {
 	int		e;
-- 
2.11.0

