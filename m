Return-Path: <SRS0=DdMj=SV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFECC282DA
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46DD9204EC
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Apr 2019 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555698786;
	bh=6sznOSxUxOgb9ELlknscYeWRRT9ONpA3sEm9TI1UQ7c=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=K5OYxvV5mnIC8WNeODP6ZPwEUVSzt7UTBpQwN/4JSskg1vJL8Lc0eZiEQcBqwKUHc
	 2rX0MkV7/tt6o+vyiOiPfv4NQEQfY9qj1rGEd8FXCKySNE20iDSl5LwxZ8tf1LdHS8
	 HI4BPefCqYIFKP7s2eTlEGL9hrLNtb2D+yAVQIQQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfDSScz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbfDSS3R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Apr 2019 14:29:17 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34628218FD;
        Fri, 19 Apr 2019 10:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555671232;
        bh=6sznOSxUxOgb9ELlknscYeWRRT9ONpA3sEm9TI1UQ7c=;
        h=From:To:Cc:Subject:Date:From;
        b=Wqlfc7yhO5/uV9rPSqQa+mUy/lRe7mtxNvalD474aiA4elzVZ+F7Ou+ilpGbT8vKb
         ao2OAGFr0QaQqK99r/1wTIqSSkkEBW1ErIp9OsKexekMYighnnDM3YILKqcE1erSFQ
         6ikSG5iqUFdULGgfQXTzXcdTNeXNS+EsQOfBmPRM=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v4 1/7] fsstress: allow fsync on directories too
Date:   Fri, 19 Apr 2019 11:53:45 +0100
Message-Id: <20190419105345.11777-1-fdmanana@kernel.org>
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
V4: No changes.

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

