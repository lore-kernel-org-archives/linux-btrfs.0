Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:48856 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932552Ab3CDVkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/14] btrfs-progs: free allocated metadump structure on restore failure
Date: Mon,  4 Mar 2013 16:39:55 -0600
Message-Id: <1362436804-16766-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't return w/ "metadump" still allocated

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-image.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index a54e6c9..5b0af28 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -765,11 +765,11 @@ static int wait_for_worker(struct mdrestore_struct *mdres)
 
 static int restore_metadump(const char *input, FILE *out, int num_threads)
 {
-	struct meta_cluster *cluster;
+	struct meta_cluster *cluster = NULL;
 	struct meta_cluster_header *header;
 	struct mdrestore_struct mdrestore;
 	u64 bytenr = 0;
-	FILE *in;
+	FILE *in = NULL;
 	int ret;
 
 	if (!strcmp(input, "-")) {
@@ -797,14 +797,15 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 		if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
 		    le64_to_cpu(header->bytenr) != bytenr) {
 			fprintf(stderr, "bad header in metadump image\n");
-			return 1;
+			ret = 1;
+			goto out;
 		}
 		ret = add_cluster(cluster, &mdrestore, &bytenr);
 		BUG_ON(ret);
 
 		wait_for_worker(&mdrestore);
 	}
-
+out:
 	mdrestore_destroy(&mdrestore);
 	free(cluster);
 	if (in != stdin)
-- 
1.7.1

