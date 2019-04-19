Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B56C282DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BD4520449
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555698682;
	bh=tDP6vqZu2GRscN2nvtTTBzUNCU8DnNFN7lQq2VCIACg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=el5iOI5lXkBVj+aXxTcPoc9xKgqtdV1vtZJu5J5Qud9DM7HyKPN1cfcB5U2T+L5BP
	 JOnUGLkguUUKips4gzehxZNhlpYG9eACcHbQs7gKnooucl1sxJIWslvF8/6lElyciS
	 xS9jJ50GpTEBMbg3WckjSx3arDjNH8uvz8zDHqlE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfDSSbV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfDSS3S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 14:29:18 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3C58218FF;
        Fri, 19 Apr 2019 10:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555671243;
        bh=tDP6vqZu2GRscN2nvtTTBzUNCU8DnNFN7lQq2VCIACg=;
        h=From:To:Cc:Subject:Date:From;
        b=KREVQm1BUro412Ozh3kxdYeH8Gg0rmmKLQtedF1bqTvZi9oMhSAaYWoP9Tg+yG6bD
         fF+plUeaqudFbjgkLAvC7lpzZdP6mtgAnRPHTkC1J5MHyxzI/neW+5GR1RsQPM/jUn
         N8BBwqW66LEpzcR0FSDNl0sgripnQiLV788FS13Q=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v4 2/7] fsstress: allow afsync on directories too
Date:   Fri, 19 Apr 2019 11:53:58 +0100
Message-Id: <20190419105358.11833-1-fdmanana@kernel.org>
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
V4: No changes.

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

