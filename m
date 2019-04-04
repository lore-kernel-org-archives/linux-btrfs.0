Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D45C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 599DB20882
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554395412;
	bh=0K+bkepf8QSVkqfteodOJC1CapjATayOC9ARXTBb2SQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1Sdp9WktLR/1tTExsATYtnR7+8/hnndW6D1TLwIlzz3JtzHjIrhyhUysDCrBXfw5H
	 i60bUPQj6DYuTxxP09Xo0g1R6o/YWXYxDL60SD7TPOsEYCkxc+78QPCeS/Uv+0IK7Q
	 xWhSYmFJWZgR63fvVpwcUdxZyIYijt2GZSJM3NKE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfDDQaL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfDDQaL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:30:11 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6332720855;
        Thu,  4 Apr 2019 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554395411;
        bh=0K+bkepf8QSVkqfteodOJC1CapjATayOC9ARXTBb2SQ=;
        h=From:To:Cc:Subject:Date:From;
        b=evVb4LXVb2X3lO3X5mHPpVt+12g+VHQ1gp4fVzINuK++qBZEsCoKCv8Q8RyJ66zYj
         JLgmlX7lYvdekkpX+Mby+7dzFHF5/p77gYwhBRKUKm9dIMUvLidHdtcXJ78SV+yVTk
         3Y09cZslitm1zcK0H8Ta2Reyl0QwgSwYuyh07/EM=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3 2/7] fsstress: allow afsync on directories too
Date:   Thu,  4 Apr 2019 17:30:06 +0100
Message-Id: <20190404163006.19076-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently the afsync function can only be performed against regular files.
Allow it to operate on directories too, to increase test coverage and
allow for chances of finding bugs in a filesystem's implementation of
fsync against directories.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use the helper functions for opening and closing files or directories,
    introduced in the previous patch.
V3: Use the new simplified helper for opening a file or directory.

 ltp/fsstress.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 72c574da..3ec19143 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1395,8 +1395,8 @@ open_file_or_dir(pathname_t *name, int flags)
 		return fd;
 	if (fd == -1 && errno != EISDIR)
 		return fd;
-	/* Directories can not be opened in write mode. */
-	flags &= ~O_WRONLY;
+	/* Directories can not be opened in write mode nor direct mode. */
+	flags &= ~(O_WRONLY | O_DIRECT);
 	flags |= O_RDONLY | O_DIRECTORY;
 	return open_path(name, flags);
 }
@@ -1774,13 +1774,13 @@ afsync_f(int opno, long r)
 	struct io_event	event;
 
 	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: afsync - no filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
-	fd = open_path(&f, O_WRONLY | O_DIRECT);
+	fd = open_file_or_dir(&f, O_WRONLY | O_DIRECT);
 	e = fd < 0 ? errno : 0;
 	check_cwd();
 	if (fd < 0) {
-- 
2.11.0

