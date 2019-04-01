Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4872CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14F2D2070D
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554123028;
	bh=fEKOGtvEIZr/jPevPjaQ2mAejqegP60lfWPUSSx5plo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=iovC0lGwRYNdj29J0sFBT1ctwpgCZogPtZPU8sbTBIgVE5Y66j22J/uJSGds7BOjp
	 VBKe7wRjQYIEaOm9DS2qn6JNcl0jmwsubY6wzX/2fbpsKld8hNq+7yyR3Wtma8yFTN
	 A+SfH7OMq3n0qVssP046/l02+SQXSdN/XNpBp9mc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfDAMu1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfDAMu1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 08:50:27 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C84206B7;
        Mon,  1 Apr 2019 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554123026;
        bh=fEKOGtvEIZr/jPevPjaQ2mAejqegP60lfWPUSSx5plo=;
        h=From:To:Cc:Subject:Date:From;
        b=rPzhu8wXHTW6ADvwi3kGkU3+m7zQsW/HmVn/W99pKLOQvbpqs8KYYzvvik9FQEkG/
         UylSi5VEE91E9kbSffvMFswbV0NTNCDdtnWck4M9Iv0uh0E9ia7IkzMNzN3kzsXgZU
         SLNFWvf6PJ1r8kmIu0+f8CSA2Gm3lvkF/C10yHvY=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 1/7] fsstress: allow fsync on directories too
Date:   Mon,  1 Apr 2019 13:50:18 +0100
Message-Id: <20190401125018.10009-1-fdmanana@kernel.org>
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

 ltp/fsstress.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 2223fd7d..1169b840 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -303,6 +303,7 @@ int	attr_remove_path(pathname_t *, const char *, int);
 int	attr_set_path(pathname_t *, const char *, const char *, const int, int);
 void	check_cwd(void);
 void	cleanup_flist(void);
+void	close_file_or_dir(int, DIR *);
 int	creat_path(pathname_t *, mode_t);
 void	dcache_enter(int, int);
 void	dcache_init(void);
@@ -324,6 +325,7 @@ void	make_freq_table(void);
 int	mkdir_path(pathname_t *, mode_t);
 int	mknod_path(pathname_t *, mode_t, dev_t);
 void	namerandpad(int, char *, int);
+int	open_file_or_dir(pathname_t *, int, DIR **);
 int	open_path(pathname_t *, int);
 DIR	*opendir_path(pathname_t *);
 void	process_freq(char *);
@@ -852,6 +854,15 @@ cleanup_flist(void)
 	}
 }
 
+void
+close_file_or_dir(int fd, DIR *dir)
+{
+	if (dir)
+		closedir(dir);
+	else
+		close(fd);
+}
+
 int
 creat_path(pathname_t *name, mode_t mode)
 {
@@ -1385,6 +1396,30 @@ namerandpad(int id, char *buf, int i)
 }
 
 int
+open_file_or_dir(pathname_t *name, int flags, DIR **dir)
+{
+	int fd;
+
+	fd = open_path(name, flags);
+	if (fd < 0 && errno == EISDIR) {
+		*dir = opendir_path(name);
+		if (*dir) {
+			fd = dirfd(*dir);
+			if (fd < 0) {
+				int e = errno;
+
+				closedir(*dir);
+				*dir = NULL;
+				errno = e;
+			}
+		}
+	} else {
+		*dir = NULL;
+	}
+	return fd;
+}
+
+int
 open_path(pathname_t *name, int oflag)
 {
 	char		buf[NAME_MAX + 1];
@@ -3440,15 +3475,16 @@ fsync_f(int opno, long r)
 	pathname_t	f;
 	int		fd;
 	int		v;
+	DIR             *dir;
 
 	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: fsync - no filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
-	fd = open_path(&f, O_WRONLY);
+	fd = open_file_or_dir(&f, O_WRONLY, &dir);
 	e = fd < 0 ? errno : 0;
 	check_cwd();
 	if (fd < 0) {
@@ -3462,7 +3498,7 @@ fsync_f(int opno, long r)
 	if (v)
 		printf("%d/%d: fsync %s %d\n", procid, opno, f.path, e);
 	free_pathname(&f);
-	close(fd);
+	close_file_or_dir(fd, dir);
 }
 
 void
-- 
2.11.0

