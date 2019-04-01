Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B192BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FDA52084B
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554123095;
	bh=5n8X03ptqXbxBooF6nwN4hsWR45oW9Rn9rNDORj2YHo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=eZREdlCQwoS+6cnh8H43yKe5npBj/LoCEUiE4wj5oRG3fdHV9HzUEHI7CB94XSDRp
	 JbhmCuWeMQzArCuN24pwyAQjQNJcj+ZGdcP8sxtdeJBz9K+lP9X6prV6MeZGHp+C7k
	 +pOhHypYj+lPwiaCK7UM1fJtujU6LAAAT0tibyn8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfDAMvf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfDAMve (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 08:51:34 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C9E206B7;
        Mon,  1 Apr 2019 12:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554123094;
        bh=5n8X03ptqXbxBooF6nwN4hsWR45oW9Rn9rNDORj2YHo=;
        h=From:To:Cc:Subject:Date:From;
        b=JCrFv7Qx9Z7cy11mbF2gIyHKcKNY4MUg6mpkvi+ebSKltJEqDA6AVbQiUd57Y7FX9
         A/t06cIWnw7n8GDqB49q4iYDCw8hL2wGIPugh/klct4eNhXmW4vv15uf95L2QqBYVv
         /ZXAZRJcqP4zOhS6JNkqOkmfSo6Xe4LzkqRghpjs=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 5/7] fsstress: add operation for deleting xattrs from files and directories
Date:   Mon,  1 Apr 2019 13:51:29 +0100
Message-Id: <20190401125129.10213-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The previous patches added support for operations to set and get xattrs on
regular files and directories, this patch just adds one operation to delete
xattrs on files and directories.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use a different name for the operation (delfattr) and make use of the
    helper functions for opening and closing files or directories, introduced
    in the first patch of this series.

 ltp/fsstress.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 53e6a847..1694c5a2 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -60,6 +60,7 @@ typedef enum {
 	OP_COPYRANGE,
 	OP_CREAT,
 	OP_DEDUPERANGE,
+	OP_DELFATTR,
 	OP_DREAD,
 	OP_DWRITE,
 	OP_FALLOCATE,
@@ -175,6 +176,7 @@ void	clonerange_f(int, long);
 void	copyrange_f(int, long);
 void	creat_f(int, long);
 void	deduperange_f(int, long);
+void	delfattr_f(int, long);
 void	dread_f(int, long);
 void	dwrite_f(int, long);
 void	fallocate_f(int, long);
@@ -228,6 +230,7 @@ opdesc_t	ops[] = {
 	{ OP_COPYRANGE, "copyrange", copyrange_f, 4, 1 },
 	{ OP_CREAT, "creat", creat_f, 4, 1 },
 	{ OP_DEDUPERANGE, "deduperange", deduperange_f, 4, 1},
+	{ OP_DELFATTR, "delfattr", delfattr_f, 2, 1 },
 	{ OP_DREAD, "dread", dread_f, 4, 0 },
 	{ OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
 	{ OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
@@ -3066,6 +3069,56 @@ creat_f(int opno, long r)
 }
 
 void
+delfattr_f(int opno, long r)
+{
+	int		fd;
+	fent_t	        *fep;
+	int		e;
+	pathname_t	f;
+	int		v;
+	char            name[XATTR_NAME_BUF_SIZE];
+	int             xattr_num;
+	DIR             *dir;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, &fep, &v)) {
+		if (v)
+			printf("%d/%d: delfattr - no filename\n", procid, opno);
+		free_pathname(&f);
+		return;
+	}
+	fd = open_file_or_dir(&f, O_WRONLY, &dir);
+	e = fd < 0 ? errno : 0;
+	if (fd < 0) {
+		if (v)
+			printf("%d/%d: delfattr - open %s failed %d\n",
+			       procid, opno, f.path, e);
+		free_pathname(&f);
+		return;
+	}
+	check_cwd();
+
+	/*
+	 * If the file/dir has xattrs, pick one randomly, otherwise attempt to
+	 * remove a xattr that doesn't exist (fremovexattr should fail with
+	 * errno set to ENOATTR (61) in this case).
+	 */
+	if (fep->xattr_counter > 0)
+		xattr_num = (random() % fep->xattr_counter) + 1;
+	else
+		xattr_num = 0;
+
+	generate_xattr_name(xattr_num, name);
+
+	e = fremovexattr(fd, name) < 0 ? errno : 0;
+	if (v)
+		printf("%d/%d: delfattr file %s name %s %d\n",
+		       procid, opno, f.path, name, e);
+	free_pathname(&f);
+	close_file_or_dir(fd, dir);
+}
+
+void
 dread_f(int opno, long r)
 {
 	int64_t		align;
-- 
2.11.0

