Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB24BC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1F5821773
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553799304;
	bh=bNDzHfgV44T11IZFAURJobvn0KCy+ewH3JKQdg8NzT8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=JO2Wjh60HwCeFTYktOcOja8IZ74htTjUV79Kyd7t77MiiHSCF9uMJH65I6pRGdQIr
	 uQ/VFXKH6XKJ7aZUXj/LQAMlAhVTG4kKWeUB2roITUmEmDthUG/tzzL3CBGnwhs3wQ
	 AYAz7VNBIqFLgLkrmknJZW+jrgt2OF2pShEUd4/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfC1SzD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 14:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfC1SzD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 14:55:03 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8A3E2173C;
        Thu, 28 Mar 2019 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553799302;
        bh=bNDzHfgV44T11IZFAURJobvn0KCy+ewH3JKQdg8NzT8=;
        h=From:To:Cc:Subject:Date:From;
        b=c1JU9qqtS6i2g3Q9CzRqvVS9iQsXwc5GO+sD95+FLl9PU6b6iHba87ypdHQSegdYx
         4bqEfClOhU2GXTAFfFWZVQhGxuJm+PPQHt7GN77QVEnw2HiQOX6lABOjfMUofCi2Il
         al4QSQHJsgBipZDsy1zCBZ8QsQEIJ80YP6MFDGiw=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 5/7] fsstress: allow afsync on directories too
Date:   Thu, 28 Mar 2019 18:54:58 +0000
Message-Id: <20190328185458.29033-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently the afsync function can only be performed against regular files.
Allow it to operate on directories too, to increase test coverage and allow
for chances of finding bugs in the filesystem implementation of fsync
against directories.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 ltp/fsstress.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index ffe78ef7..0fb9e399 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1767,15 +1767,21 @@ afsync_f(int opno, long r)
 	struct iocb	iocb;
 	struct iocb	*iocbs[] = { &iocb };
 	struct io_event	event;
+	DIR             *dir = NULL;
 
 	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: afsync - no filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
 	fd = open_path(&f, O_WRONLY | O_DIRECT);
+	if (fd < 0 && errno == EISDIR) {
+		dir = opendir_path(&f);
+		if (dir)
+			fd = dirfd(dir);
+	}
 	e = fd < 0 ? errno : 0;
 	check_cwd();
 	if (fd < 0) {
@@ -1783,6 +1789,8 @@ afsync_f(int opno, long r)
 			printf("%d/%d: afsync - open %s failed %d\n",
 			       procid, opno, f.path, e);
 		free_pathname(&f);
+		if (dir)
+			closedir(dir);
 		return;
 	}
 
@@ -1791,24 +1799,24 @@ afsync_f(int opno, long r)
 		if (v)
 			printf("%d/%d: afsync - io_submit %s %d\n",
 			       procid, opno, f.path, e);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto out;
 	}
 	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
 		if (v)
 			printf("%d/%d: afsync - io_getevents failed %d\n",
 			       procid, opno, e);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto out;
 	}
 
 	e = event.res2;
 	if (v)
 		printf("%d/%d: afsync %s %d\n", procid, opno, f.path, e);
+out:
 	free_pathname(&f);
-	close(fd);
+	if (dir)
+		closedir(dir);
+	else
+		close(fd);
 #endif
 }
 
-- 
2.11.0

