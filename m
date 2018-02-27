Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:38960 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbeB0JNP (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Feb 2018 04:13:15 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/4] btrfs-progs: check: Distingusih csum checking output for --check-data-csum
Date: Tue, 27 Feb 2018 17:12:59 +0800
Message-Id: <20180227091259.10877-5-wqu@suse.com>
In-Reply-To: <20180227091259.10877-1-wqu@suse.com>
References: <20180227091259.10877-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No matter --check-data-csum is passed or not, btrfs check will always
output message like "checking csum".

This message could be a little confusing, change it according to
--check-data-csum option.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 22a78273be15..3f4a6bcac4df 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9845,7 +9845,11 @@ int cmd_check(int argc, char **argv)
 		goto out;
 	}
 
-	fprintf(stderr, "checking csums\n");
+	if (check_data_csum)
+		fprintf(stderr, "checking csums against data\n");
+	else
+		fprintf(stderr,
+			"checking csum items alone (without verifying data)\n");
 	ret = check_csums(root);
 	/*
 	 * Data csum error is not fatal, and it may indicates more serious
-- 
2.16.2

