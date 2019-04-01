Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92197C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F69120883
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554123118;
	bh=L5czfGk/7aSpGUyWoW2t2YHwn+lDW5OMlXiFBEJR7II=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mDz6fQKo7fZW2+cF101G9TZewHrcpN6snjoBKsE61ZCRgX1/SJREu7FCGx5S15C77
	 4fR/WKBBeh7yKjG1KdXUNTduh49NRZUw6zd6H58VPeZksLEYy4ME+5viAqjKgWcP7p
	 I8Zu+MjYM0cLYpx2j6jRwAOFW07SvcEFZkjGCSLs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfDAMv5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfDAMv5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 08:51:57 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01CD42070D;
        Mon,  1 Apr 2019 12:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554123116;
        bh=L5czfGk/7aSpGUyWoW2t2YHwn+lDW5OMlXiFBEJR7II=;
        h=From:To:Cc:Subject:Date:From;
        b=DB/jCteR2CznQdnRL8OLUg2xVkjJngciwH8htQejNRW8sXnciQUimg0gijBIuGKuM
         Uf/n74o7rbZtBou/SeqnrHvmlGvbN0LArP/J2CKTrl0hSov4V3SVqpLU4OnVPXQlsP
         6EX3xv4grw1STL7hRpNJRBNcMDMW1IHwUYRK7M6w=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 6/7] fsstress: add operation for listing xattrs from files and directories
Date:   Mon,  1 Apr 2019 13:51:52 +0100
Message-Id: <20190401125152.10263-1-fdmanana@kernel.org>
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

 ltp/fsstress.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 1694c5a2..ff560d6e 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -72,6 +72,7 @@ typedef enum {
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
@@ -242,6 +244,7 @@ opdesc_t	ops[] = {
 	{ OP_GETDENTS, "getdents", getdents_f, 1, 0 },
 	{ OP_GETFATTR, "getfattr", getfattr_f, 2, 0 },
 	{ OP_LINK, "link", link_f, 1, 1 },
+	{ OP_LISTFATTR, "listfattr", listfattr_f, 1, 0 },
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
 	{ OP_MREAD, "mread", mread_f, 2, 0 },
@@ -3751,6 +3754,69 @@ link_f(int opno, long r)
 }
 
 void
+listfattr_f(int opno, long r)
+{
+	int		fd;
+	fent_t	        *fep;
+	int		e;
+	pathname_t	f;
+	int		v;
+	char            *buffer = NULL;
+	int             buffer_len;
+	DIR             *dir;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, &fep, &v)) {
+		if (v)
+			printf("%d/%d: listfattr - no filename\n", procid, opno);
+		free_pathname(&f);
+		return;
+	}
+	fd = open_file_or_dir(&f, O_RDONLY, &dir);
+	e = fd < 0 ? errno : 0;
+	if (fd < 0) {
+		if (v)
+			printf("%d/%d: listfattr - open %s failed %d\n",
+			       procid, opno, f.path, e);
+		free_pathname(&f);
+		return;
+	}
+	check_cwd();
+
+	e = flistxattr(fd, NULL, 0);
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
+	e = flistxattr(fd, buffer, buffer_len) < 0 ? errno : 0;
+	if (v)
+		printf("%d/%d: listfattr %s buffer length %d %d\n",
+		       procid, opno, f.path, buffer_len, e);
+out:
+	free(buffer);
+	free_pathname(&f);
+	close_file_or_dir(fd, dir);
+}
+
+void
 mkdir_f(int opno, long r)
 {
 	int		e;
-- 
2.11.0

