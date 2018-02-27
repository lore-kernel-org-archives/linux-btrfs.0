Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58294 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbeB0JNO (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Feb 2018 04:13:14 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/4] btrfs-progs: check: Continue check even csum error is found
Date: Tue, 27 Feb 2018 17:12:58 +0800
Message-Id: <20180227091259.10877-4-wqu@suse.com>
In-Reply-To: <20180227091259.10877-1-wqu@suse.com>
References: <20180227091259.10877-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since data csum is not a fatal error compared to fs/extent trees,
continue check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/check/main.c b/check/main.c
index 15b3c402c9f5..22a78273be15 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9847,11 +9847,13 @@ int cmd_check(int argc, char **argv)
 
 	fprintf(stderr, "checking csums\n");
 	ret = check_csums(root);
-	err |= !!ret;
-	if (ret) {
+	/*
+	 * Data csum error is not fatal, and it may indicates more serious
+	 * corruption, continue checking.
+	 */
+	if (ret)
 		error("errors found in csum tree");
-		goto out;
-	}
+	err |= !!ret;
 
 	fprintf(stderr, "checking root refs\n");
 	/* For low memory mode, check_fs_roots_v2 handles root refs */
-- 
2.16.2

