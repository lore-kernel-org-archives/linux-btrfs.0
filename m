Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8E6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A8F82070D
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554123040;
	bh=WEB3JPm4RZFQ/wLvV4eLZmgt6RT4dBjCbdQbR3XmqKg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ogSxijgyFZdd7dEXPZKtAz7p5ywR9auCB9KPnwts8UvV1tawOkmyP5BuIw16Rq5+W
	 BMQNacaY+s34HBc1SrrIRVU13LLESpi5REFdzbrB1Wyn6tTL4mFYPl6GmIizspv96t
	 sRu1ybceABE+1LB6U+1uM4sfRQJzKKrLj+WX4zaw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfDAMuk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfDAMuj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 08:50:39 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5EF42070D;
        Mon,  1 Apr 2019 12:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554123038;
        bh=WEB3JPm4RZFQ/wLvV4eLZmgt6RT4dBjCbdQbR3XmqKg=;
        h=From:To:Cc:Subject:Date:From;
        b=id6ulD5GcZaoPx2E9xSNtvk+ITyv9BXgOYt8aQm6TQnqUc5ifouDEMr5Qrl9N2Hjt
         ge7kZTqkVHwvZbQNV1h25zxqp+uYcutvzThr6cyztsuSrxt1Bu2/hBzt/QsH0C+2u+
         ++RO1ivf/S3vnBc9jSbES0ukDwIVOoI2L2fZpKUQ=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 2/7] fsstress: allow afsync on directories too
Date:   Mon,  1 Apr 2019 13:50:33 +0100
Message-Id: <20190401125033.10059-1-fdmanana@kernel.org>
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

 ltp/fsstress.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 1169b840..13d4bebc 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1790,15 +1790,16 @@ afsync_f(int opno, long r)
 	struct iocb	iocb;
 	struct iocb	*iocbs[] = { &iocb };
 	struct io_event	event;
+	DIR             *dir;
 
 	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: afsync - no filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
-	fd = open_path(&f, O_WRONLY | O_DIRECT);
+	fd = open_file_or_dir(&f, O_WRONLY | O_DIRECT, &dir);
 	e = fd < 0 ? errno : 0;
 	check_cwd();
 	if (fd < 0) {
@@ -1815,7 +1816,7 @@ afsync_f(int opno, long r)
 			printf("%d/%d: afsync - io_submit %s %d\n",
 			       procid, opno, f.path, e);
 		free_pathname(&f);
-		close(fd);
+		close_file_or_dir(fd, dir);
 		return;
 	}
 	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
@@ -1823,7 +1824,7 @@ afsync_f(int opno, long r)
 			printf("%d/%d: afsync - io_getevents failed %d\n",
 			       procid, opno, e);
 		free_pathname(&f);
-		close(fd);
+		close_file_or_dir(fd, dir);
 		return;
 	}
 
@@ -1831,7 +1832,7 @@ afsync_f(int opno, long r)
 	if (v)
 		printf("%d/%d: afsync %s %d\n", procid, opno, f.path, e);
 	free_pathname(&f);
-	close(fd);
+	close_file_or_dir(fd, dir);
 #endif
 }
 
-- 
2.11.0

