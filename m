Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33252 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933782AbdBVVcv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 16:32:51 -0500
Received: by mail-wm0-f66.google.com with SMTP id v77so2608313wmv.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 13:32:50 -0800 (PST)
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Benedikt Morbach <benedikt.morbach@googlemail.com>
Subject: [PATCH] btrfs-progs: send-dump: add missing newlines
Date: Wed, 22 Feb 2017 22:32:46 +0100
Message-Id: <20170222213246.29315-1-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

make sure to include newlines after commands that have only one
argument, such as 'unlink' or 'mkfile'

changes

    unlink          ./baz.0/file_autimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
    truncate        ./baz.0/file_a                  size=131072
    chmod           ./baz.0/file_a                  mode=644
    utimes          ./baz.0/file_a                  atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
    mkfile          ./baz.0/o258-11-0rename          ./baz.0/o258-11-0               dest=./baz.0/file_b
    utimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100

to

    unlink          ./baz.0/file_a
    utimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
    truncate        ./baz.0/file_a                  size=131072
    chmod           ./baz.0/file_a                  mode=644
    utimes          ./baz.0/file_a                  atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
    mkfile          ./baz.0/o258-11-0
    rename          ./baz.0/o258-11-0               dest=./baz.0/file_b
    utimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100

Signed-off-by: Benedikt Morbach <benedikt.morbach@googlemail.com>
---
 send-dump.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/send-dump.c b/send-dump.c
index 4c44246..67f7977 100644
--- a/send-dump.c
+++ b/send-dump.c
@@ -112,8 +112,10 @@ static int __print_dump(int subvol, void *user, const char *path,
 	/* Unified header */
 	printf("%-16s", title);
 	ret = print_path_escaped(out_path);
-	if (!fmt)
+	if (!fmt) {
+		putchar('\n');
 		return 0;
+	}
 	/* Short paths ale aligned to 32 chars */
 	while (ret++ < 32)
 		putchar(' ');
-- 
2.11.1

