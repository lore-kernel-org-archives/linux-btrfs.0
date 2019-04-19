Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F632C282DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F12D2054F
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555698800;
	bh=Xz+YD92fkUAft3mcEtYRfZPbUulg1+Ixkkunu7U3XbE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ixDKckWN/j7BdVWbGDfMcUVNl71x745J2Jqbyo49XiJpo1l05rnI5pLjAoE4DLsMF
	 lFBGAeda5C8hXOIhxuUKpzc9G9lXS60OttwAWmU29C3vvsuEha4dPcb+oUkvtw1nMr
	 oUVxEzu4h5UtA/ejjgD65V5EYxs8x/EHen3UT+f4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfDSSdN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbfDSS3R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 14:29:17 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5377F21904;
        Fri, 19 Apr 2019 10:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555671294;
        bh=Xz+YD92fkUAft3mcEtYRfZPbUulg1+Ixkkunu7U3XbE=;
        h=From:To:Cc:Subject:Date:From;
        b=XC9Z8t+48aFWZYEtX/AIb11BSs12TSyAIxiIriHEVrJZy+82BSuj1cAjSpjFck0jO
         O7jypPT2/gqI8fWROW03ay6CJufzeA3R9x6/CMPFcNMwyDxMIGpGKlwdRWmXhCLqJz
         X7Tv4DCugzW6XkKj5UrAl+sHSv0t4uP/GcRH3uhI=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v4 5/7] fsstress: add operation for deleting xattrs from files and directories
Date:   Fri, 19 Apr 2019 11:54:48 +0100
Message-Id: <20190419105448.11984-1-fdmanana@kernel.org>
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
V4: Addressed Eryu's comments.

 ltp/fsstress.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index f24dd42d..74100948 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -82,6 +82,7 @@ typedef enum {
 	OP_READ,
 	OP_READLINK,
 	OP_READV,
+	OP_REMOVEFATTR,
 	OP_RENAME,
 	OP_RESVSP,
 	OP_RMDIR,
@@ -198,6 +199,7 @@ void	insert_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	readv_f(int, long);
+void	removefattr_f(int, long);
 void	rename_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
@@ -253,6 +255,8 @@ opdesc_t	ops[] = {
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_READV, "readv", readv_f, 1, 0 },
+	/* remove (delete) extended attribute */
+	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
@@ -4115,6 +4119,49 @@ readv_f(int opno, long r)
 }
 
 void
+removefattr_f(int opno, long r)
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
+			printf("%d/%d: removefattr - no filename\n", procid, opno);
+		goto out;
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
+	e = generate_xattr_name(xattr_num, name, sizeof(name));
+	if (e < 0) {
+		printf("%d/%d: removefattr - file %s failed to generate xattr name: %d\n",
+		       procid, opno, f.path, e);
+		goto out;
+	}
+
+	e = removexattr(f.path, name) < 0 ? errno : 0;
+	if (v)
+		printf("%d/%d: removefattr file %s name %s %d\n",
+		       procid, opno, f.path, name, e);
+out:
+	free_pathname(&f);
+}
+
+void
 rename_f(int opno, long r)
 {
 	fent_t		*dfep;
-- 
2.11.0

