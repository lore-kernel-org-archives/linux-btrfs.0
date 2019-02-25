Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A24EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE1E520842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfBYSQz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 13:16:55 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:33782 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbfBYSQz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 13:16:55 -0500
Received: from [2a02:a31c:853f:a300::6] (helo=umbar.angband.pl)
        by tartarus.angband.pl with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gyKo6-00029H-E0; Mon, 25 Feb 2019 19:16:51 +0100
Received: from kilobyte by umbar.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@umbar.angband.pl>)
        id 1gyKo4-0002hL-LL; Mon, 25 Feb 2019 19:16:48 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@versity.com>
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Mon, 25 Feb 2019 19:16:44 +0100
Message-Id: <20190225181644.10262-2-kilobyte@angband.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190225181644.10262-1-kilobyte@angband.pl>
References: <20190225181644.10262-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a02:a31c:853f:a300::6
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH resend 2/2] btrfs-progs: defrag: open files RO on new enough kernels
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Defragging an executable conflicts both way with it being run, resulting in
ETXTBSY.  This either makes defrag fail or prevents the program from being
executed.

Kernels 4.19-rc1 and later allow defragging files you could have possibly
opened rw, even if the passed descriptor is ro (commit 616d374efa23).

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 cmds-filesystem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b8beec13..0eb052dc 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -26,6 +26,7 @@
 #include <ftw.h>
 #include <mntent.h>
 #include <linux/limits.h>
+#include <linux/version.h>
 #include <getopt.h>
 
 #include <btrfsutil.h>
@@ -39,12 +40,14 @@
 #include "list_sort.h"
 #include "disk-io.h"
 #include "help.h"
+#include "fsfeatures.h"
 
 /*
  * for btrfs fi show, we maintain a hash of fsids we've already printed.
  * This way we don't print dups if a given FS is mounted more than once.
  */
 static struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
+static mode_t defrag_open_mode = O_RDONLY;
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
@@ -880,7 +883,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
 		if (defrag_global_verbose)
 			printf("%s\n", fpath);
-		fd = open(fpath, O_RDWR);
+		fd = open(fpath, defrag_open_mode);
 		if (fd < 0) {
 			goto error;
 		}
@@ -917,6 +920,9 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	int compress_type = BTRFS_COMPRESS_NONE;
 	DIR *dirstream;
 
+	if (get_running_kernel_version() < KERNEL_VERSION(4,19,0))
+		defrag_open_mode = O_RDWR;
+
 	/*
 	 * Kernel has a different default (256K) that is supposed to be safe,
 	 * but it does not defragment very well. The 32M will likely lead to
@@ -1017,7 +1023,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		int defrag_err = 0;
 
 		dirstream = NULL;
-		fd = open_file_or_dir(argv[i], &dirstream);
+		fd = open_file_or_dir3(argv[i], &dirstream, defrag_open_mode);
 		if (fd < 0) {
 			error("cannot open %s: %m", argv[i]);
 			ret = -errno;
-- 
2.20.1

