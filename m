Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C92AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 05:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3207E20811
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 05:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfC1FfN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 01:35:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:60712 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbfC1FfN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 01:35:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04009ACFB;
        Thu, 28 Mar 2019 05:35:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] fstests: log-writes: Add new option to replay/find next write to sector
Date:   Thu, 28 Mar 2019 13:35:07 +0800
Message-Id: <20190328053507.10191-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For kernel operation we have METADATA/FUA/FLUSH flags as a beacon, but
for user space write we don't have any useful flag unless the user space
tool call fsync() to generate a FLUSH bio.

This means for user space write, we don't really have an equivalent of
--next-fua to find super block write.

So this patch will add a new option, --next-write <sector> to
replay/find next write to certain sector.
And normally the <sector> should be super block sector number.

With that, we can replay to super block write even it's user space
triggering the write.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 src/log-writes/replay-log.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/log-writes/replay-log.c b/src/log-writes/replay-log.c
index c16df40e5741..0d0ec49c8a00 100644
--- a/src/log-writes/replay-log.c
+++ b/src/log-writes/replay-log.c
@@ -9,6 +9,7 @@
 enum option_indexes {
 	NEXT_FLUSH,
 	NEXT_FUA,
+	NEXT_WRITE,
 	START_ENTRY,
 	END_MARK,
 	LOG,
@@ -28,6 +29,7 @@ enum option_indexes {
 static struct option long_options[] = {
 	{"next-flush", no_argument, NULL, 0},
 	{"next-fua", no_argument, NULL, 0},
+	{"next-write", required_argument, NULL, 0},
 	{"start-entry", required_argument, NULL, 0},
 	{"end-mark", required_argument, NULL, 0},
 	{"log", required_argument, NULL, 0},
@@ -53,6 +55,8 @@ static void usage(void)
 	fprintf(stderr, "\t--limit <number> - number of entries to replay\n");
 	fprintf(stderr, "\t--next-flush - replay to/find the next flush\n");
 	fprintf(stderr, "\t--next-fua - replay to/find the next fua\n");
+	fprintf(stderr, "\t--next-write <sector> - replay to/find the next "
+			"write to <sector>\n");
 	fprintf(stderr, "\t--start-entry <entry> - start at the given "
 		"entry #\n");
 	fprintf(stderr, "\t--start-mark <mark> - mark to start from\n");
@@ -139,6 +143,7 @@ int main(int argc, char **argv)
 	char *logfile = NULL, *replayfile = NULL, *fsck_command = NULL;
 	struct log_write_entry *entry;
 	u64 stop_flags = 0;
+	u64 stop_sector = 0;
 	u64 start_entry = 0;
 	u64 start_sector = 0;
 	u64 end_sector = -1ULL;
@@ -173,6 +178,14 @@ int main(int argc, char **argv)
 		case NEXT_FUA:
 			stop_flags |= LOG_FUA_FLAG;
 			break;
+		case NEXT_WRITE:
+			stop_sector = strtoull(optarg, &tmp, 0);
+			if (tmp && *tmp != '\0') {
+				fprintf(stderr, "Invalid sector number\n");
+				exit(1);
+			}
+			tmp = NULL;
+			break;
 		case START_ENTRY:
 			start_entry = strtoull(optarg, &tmp, 0);
 			if (tmp && *tmp != '\0') {
@@ -324,7 +337,8 @@ int main(int argc, char **argv)
 		while ((ret = log_seek_next_entry(log, entry, 1)) == 0) {
 			num_entries++;
 			if ((run_limit && num_entries == run_limit) ||
-			    should_stop(entry, stop_flags, end_mark)) {
+			    should_stop(entry, stop_flags, end_mark) ||
+			    (stop_sector && entry->sector == stop_sector)) {
 				printf("%llu@%llu\n",
 				       (unsigned long long)log->cur_entry - 1,
 				       log->cur_pos / log->sectorsize);
-- 
2.21.0

