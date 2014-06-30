Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38133 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754010AbaF3D7n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 23:59:43 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/2] btrfs-progs: limit minimal num of args for btrfs-image
Date: Mon, 30 Jun 2014 11:54:12 +0800
Message-ID: <1404100452-8894-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <20140627123528.GC1553@twin.jikos.cz>
 <1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs-image requires at least 2 args to run,
one for the source dev/file, the other for the target dev/file.

This patch depends on patch:
	btrfs-progs: move the check_argc_* functions into utils.c

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: use check_argc_min instead
---
 btrfs-image.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index e0aabfd..3b27155 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2521,6 +2521,10 @@ int main(int argc, char *argv[])
 	}
 
 	argc = argc - optind;
+	set_argv0(argv);
+	if (check_argc_min(argc, 2))
+		print_usage();
+
 	dev_cnt = argc - 1;
 
 	if (create) {
-- 
1.8.1.4

