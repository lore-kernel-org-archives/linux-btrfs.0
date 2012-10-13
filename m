Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38094 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab2JMT1E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 15:27:04 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2406776eek.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 12:27:03 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: kreijack@gmail.com
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/3] Deleted the byte prefix with pretty_sizes().
Date: Sat, 13 Oct 2012 21:27:15 +0200
Message-Id: <1350156436-14439-3-git-send-email-kreijack@gmail.com>
In-Reply-To: <1350156436-14439-1-git-send-email-kreijack@gmail.com>
References: <1350156436-14439-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

When the function pretty_sizes() is used, the word "bytes" must
avoided.
---
 cmds-filesystem.c |    2 +-
 cmds-scrub.c      |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9c43d35..21cdd7f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -202,7 +202,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	super_bytes_used = pretty_sizes(device->super_bytes_used);
 
 	total = device->total_devs;
-	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
+	printf(" uuid: %s\n\tTotal devices %llu FS space used %s\n", uuidbuf,
 	       (unsigned long long)total, super_bytes_used);
 
 	free(super_bytes_used);
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 24be20f..69dfa7e 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -125,7 +125,7 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
 {
 	u64 err_cnt;
 	u64 err_cnt2;
-	char *bytes;
+	char *total;
 
 	err_cnt = p->read_errors +
 			p->csum_errors +
@@ -137,10 +137,10 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
 	if (p->malloc_errors)
 		printf("*** WARNING: memory allocation failed while scrubbing. "
 		       "results may be inaccurate\n");
-	bytes = pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed);
-	printf("\ttotal bytes scrubbed: %s with %llu errors\n", bytes,
+	total = pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed);
+	printf("\ttotal scrubbed: %s with %llu errors\n", total,
 		max(err_cnt, err_cnt2));
-	free(bytes);
+	free(total);
 	if (err_cnt || err_cnt2) {
 		printf("\terror details:");
 		PRINT_SCRUB_ERROR(p->read_errors, "read");
-- 
1.7.10.4

