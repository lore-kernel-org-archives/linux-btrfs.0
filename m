Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9FAC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BBD021773
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553799315;
	bh=3r53Oh8MY2VrMULjE/3iC4Kzo8dj+hEo7jO01Cvc3jU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mR8Uyv3gLYd6yi6KIgcEhlEUv1D3yCyO+Bz05rAZa8QbFR4gmWaiXwexrC4cwe2Tb
	 hNeA6/9DcHYhf4aAZ2TnrfJA8xYs8ixUTcibGdnsysrgt2BMDxTEi2EuAZ3SJwjHST
	 itEYxX4aaPig6H7OsFWN/4yZyYijCXZYBHZgi1Pw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfC1SzP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 14:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfC1SzO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 14:55:14 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C3C2173C;
        Thu, 28 Mar 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553799314;
        bh=3r53Oh8MY2VrMULjE/3iC4Kzo8dj+hEo7jO01Cvc3jU=;
        h=From:To:Cc:Subject:Date:From;
        b=h/ocv+vQeH/PiLQ0Jx0rd/IXS1Q100F3/gMmVoafkDatN/ZhMYW6LjrJUHLxUSDGC
         BYy8A5SqHienbQGzhyEw8CgS8iAlaHH7noeEpGe2cl01iB6Q92xLpQAbAiykx12Tga
         jepRHf3zm58gfGKX6X2zfrJSvEbvNcJ2Epr1CZTA=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 6/7] fsstress: allow fsync on directories too
Date:   Thu, 28 Mar 2019 18:55:09 +0000
Message-Id: <20190328185509.29086-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently the fsync function can only be performed against regular files.
Allow it to operate on directories too, to increase test coverage and allow
for chances of finding bugs in a filesystem's implementation of fsync
against directories.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 ltp/fsstress.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 0fb9e399..bd058c04 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -3460,15 +3460,21 @@ fsync_f(int opno, long r)
 	pathname_t	f;
 	int		fd;
 	int		v;
+	DIR             *dir = NULL;
 
 	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: fsync - no filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
 	fd = open_path(&f, O_WRONLY);
+	if (fd < 0 && errno == EISDIR) {
+		dir = opendir_path(&f);
+		if (dir)
+			fd = dirfd(dir);
+	}
 	e = fd < 0 ? errno : 0;
 	check_cwd();
 	if (fd < 0) {
@@ -3476,13 +3482,18 @@ fsync_f(int opno, long r)
 			printf("%d/%d: fsync - open %s failed %d\n",
 				procid, opno, f.path, e);
 		free_pathname(&f);
+		if (dir)
+			closedir(dir);
 		return;
 	}
 	e = fsync(fd) < 0 ? errno : 0;
 	if (v)
 		printf("%d/%d: fsync %s %d\n", procid, opno, f.path, e);
 	free_pathname(&f);
-	close(fd);
+	if (dir)
+		closedir(dir);
+	else
+		close(fd);
 }
 
 void
-- 
2.11.0

