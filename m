Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58C9C282DA
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75064204EC
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555698825;
	bh=9RXCj8OHIWsuMAxW2auL4pF8XiqeYUBf+8hsTSCVZJQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=YrkDJXhpHCoVV3osI6B2RK4t7ppVuGdyuUXlDVRMCRuIcX/Kl0aFq5DU/ZATMleY0
	 xtzXdzFHRId9lbFVGRHmURSl0SWIsckTCvbDlZ+UTJfuBZLKSwILee5uqVf/H5O4Xe
	 9XwsvXpjYcilOT23Ghs56ty+KXBDuE5IKXEPLUSk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfDSSdm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfDSS3Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 14:29:16 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE76821902;
        Fri, 19 Apr 2019 10:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555671266;
        bh=9RXCj8OHIWsuMAxW2auL4pF8XiqeYUBf+8hsTSCVZJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Ix/VpuROGxQsL0Gz1XX07zQbdYWQFHkIotZHKZltbdFL1Z9NX/WHmH6gsjNdSEASA
         +Epg+0B16SVyqiD3tmHPZe1CXH4CXyldCr2CfgiDa31jeEn1F2KjTiYatUxhU9wgBg
         SRKHN+4xKeeHUctYjFWMbxIF44xWGW7BNqfpLlck=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v4 4/7] fsstress: add operation for reading xattrs from files and directories
Date:   Fri, 19 Apr 2019 11:54:22 +0100
Message-Id: <20190419105422.11934-1-fdmanana@kernel.org>
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
V4: Addressed Eryu's comments.

 ltp/fsstress.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b3ff8d92..f24dd42d 100644
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
@@ -237,6 +239,8 @@ opdesc_t	ops[] = {
 	{ OP_FSYNC, "fsync", fsync_f, 1, 1 },
 	{ OP_GETATTR, "getattr", getattr_f, 1, 0 },
 	{ OP_GETDENTS, "getdents", getdents_f, 1, 0 },
+	/* get extended attribute */
+	{ OP_GETFATTR, "getfattr", getfattr_f, 1, 0 },
 	{ OP_LINK, "link", link_f, 1, 1 },
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
@@ -3594,6 +3598,75 @@ getdents_f(int opno, long r)
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
+	 * to read a xattr that doesn't exist (fgetxattr should fail with
+	 * errno set to ENOATTR (61) in this case).
+	 */
+	if (fep->xattr_counter > 0)
+		xattr_num = (random() % fep->xattr_counter) + 1;
+	else
+		xattr_num = 0;
+
+	e = generate_xattr_name(xattr_num, name, sizeof(name));
+	if (e < 0) {
+		printf("%d/%d: getfattr - file %s failed to generate xattr name: %d\n",
+		       procid, opno, f.path, e);
+		goto out;
+	}
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

