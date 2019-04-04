Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2122C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0DE82147C
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554395447;
	bh=EzAI4a7HWvYtjqlxvOclAjDZHOy+aBvHzu1Mw4u/C3g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=QVwBElpqjevQ03qqoL+lPToOuPkqCrl10eQhmCyT2ib4Ta9vth3wtAea5zjqDiWXr
	 mrTy10L0E5F/xO6lpu8afIYPj7l1uSWqYf2lS4A/eSJH7Pl5VIQBBaBXGkL2wxxnZd
	 n+wAdTH07tsUl+TkzkJVdqsUDzk1T62ULtDyJX4g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbfDDQar (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfDDQar (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:30:47 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 571F1206BA;
        Thu,  4 Apr 2019 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554395446;
        bh=EzAI4a7HWvYtjqlxvOclAjDZHOy+aBvHzu1Mw4u/C3g=;
        h=From:To:Cc:Subject:Date:From;
        b=JRxb4PDWB4L1Z5rsUZdCb63ahMokrh9OEAZ+5j1BcUFIgi64RJIXuJTayRp+we1VC
         YNhweRGu9rlN1sBvpwOLHEf9GZ884GBhfvlcBd2T+JDdOSMFje1BRHrP9wOdPqG4VR
         cIbDn/5MUYjo+E9kQTkNok8gKqttR4QpNzc9RgMQ=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3 5/7] fsstress: add operation for deleting xattrs from files and directories
Date:   Thu,  4 Apr 2019 17:30:41 +0100
Message-Id: <20190404163041.19230-1-fdmanana@kernel.org>
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
V3: Simplified implementation to not need to open a file descriptor and
    use a path string instead.  

 ltp/fsstress.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 7c924e01..0bbb72d9 100644
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
@@ -230,6 +232,7 @@ opdesc_t	ops[] = {
 	{ OP_COPYRANGE, "copyrange", copyrange_f, 4, 1 },
 	{ OP_CREAT, "creat", creat_f, 4, 1 },
 	{ OP_DEDUPERANGE, "deduperange", deduperange_f, 4, 1},
+	{ OP_DELFATTR, "delfattr", delfattr_f, 2, 1 },
 	{ OP_DREAD, "dread", dread_f, 4, 0 },
 	{ OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
 	{ OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
@@ -3062,6 +3065,44 @@ creat_f(int opno, long r)
 }
 
 void
+delfattr_f(int opno, long r)
+{
+	fent_t	        *fep;
+	int		e;
+	pathname_t	f;
+	int		v;
+	char            name[XATTR_NAME_BUF_SIZE];
+	int             xattr_num;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, &fep, &v)) {
+		if (v)
+			printf("%d/%d: delfattr - no filename\n", procid, opno);
+		goto out;
+	}
+	check_cwd();
+
+	/*
+	 * If the file/dir has xattrs, pick one randomly, otherwise attempt to
+	 * remove a xattr that doesn't exist (removexattr should fail with
+	 * errno set to ENOATTR (61) in this case).
+	 */
+	if (fep->xattr_counter > 0)
+		xattr_num = (random() % fep->xattr_counter) + 1;
+	else
+		xattr_num = 0;
+
+	generate_xattr_name(xattr_num, name);
+
+	e = removexattr(f.path, name) < 0 ? errno : 0;
+	if (v)
+		printf("%d/%d: delfattr file %s name %s %d\n",
+		       procid, opno, f.path, name, e);
+out:
+	free_pathname(&f);
+}
+
+void
 dread_f(int opno, long r)
 {
 	int64_t		align;
-- 
2.11.0

