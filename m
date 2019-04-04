Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A10C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 327AA20882
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554395401;
	bh=nir2zhAB+ffTaYpNhMvtmTE8peUYGNM+40t823StYIE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=vn0NCwHDPTj4dxpArvvsffm8K9f5K6TK+ESX4EJqJ/ktPlm8ZmWmW493mnRVwA5Oi
	 yJLaJ6xTbPGBPFQZdxidMa8OpcTNDyBhJTI9OSnjYHKLickluoPN+ykJThJyjPfquN
	 f8ESPVrsoLgn1hVzv/cJEr+uyfN99d1dtwHkx7XA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfDDQaA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfDDQaA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:30:00 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92701206BA;
        Thu,  4 Apr 2019 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554395399;
        bh=nir2zhAB+ffTaYpNhMvtmTE8peUYGNM+40t823StYIE=;
        h=From:To:Cc:Subject:Date:From;
        b=FxVVUaoz1f3NdgNHp/19vsNTex1PKS3ArHd4GUTKfPQ3qg6FocCUViq+MXAjXbLmQ
         9Vc/UdfxA8X6Waj8IKosHhCLkGp5R4jacDAKJ9qmEwa7hoSUdpR+/ZMp6qcUEY1ivX
         XPQdQUP4LAr/Uj4J7eSDsnnp2nvxVeWsJNe5p6S8=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3 1/7] fsstress: allow fsync on directories too
Date:   Thu,  4 Apr 2019 17:29:52 +0100
Message-Id: <20190404162952.19026-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently the fsync function can only be performed against regular files.
Allow it to operate on directories too, to increase test coverage and
allow for chances of finding bugs in a filesystem's implementation of
fsync against directories.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Added helper functions to open and close files or directories.
V3: Simplified helper to open file or directory, removed no longer needed
    helper for closing file or directory.

 ltp/fsstress.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 41a0155e..72c574da 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -324,6 +324,7 @@ void	make_freq_table(void);
 int	mkdir_path(pathname_t *, mode_t);
 int	mknod_path(pathname_t *, mode_t, dev_t);
 void	namerandpad(int, char *, int);
+int	open_file_or_dir(pathname_t *, int);
 int	open_path(pathname_t *, int);
 DIR	*opendir_path(pathname_t *);
 void	process_freq(char *);
@@ -1385,6 +1386,22 @@ namerandpad(int id, char *buf, int i)
 }
 
 int
+open_file_or_dir(pathname_t *name, int flags)
+{
+	int fd;
+
+	fd = open_path(name, flags);
+	if (fd != -1)
+		return fd;
+	if (fd == -1 && errno != EISDIR)
+		return fd;
+	/* Directories can not be opened in write mode. */
+	flags &= ~O_WRONLY;
+	flags |= O_RDONLY | O_DIRECTORY;
+	return open_path(name, flags);
+}
+
+int
 open_path(pathname_t *name, int oflag)
 {
 	char		buf[NAME_MAX + 1];
@@ -3455,13 +3472,13 @@ fsync_f(int opno, long r)
 	int		v;
 
 	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: fsync - no filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
-	fd = open_path(&f, O_WRONLY);
+	fd = open_file_or_dir(&f, O_WRONLY);
 	e = fd < 0 ? errno : 0;
 	check_cwd();
 	if (fd < 0) {
-- 
2.11.0

