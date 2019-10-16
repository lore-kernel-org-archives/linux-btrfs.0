Return-Path: <SRS0=uVIb=YJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4D2ECE59D
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Oct 2019 06:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CFCB20872
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Oct 2019 06:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389122AbfJPGj1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 02:39:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:57014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388357AbfJPGj1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Oct 2019 02:39:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 45DA5AD69;
        Wed, 16 Oct 2019 06:39:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools/lib/traceevent, perf tools: Handle %pU format correctly
Date:   Wed, 16 Oct 2019 14:39:20 +0800
Message-Id: <20191016063920.20791-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
For btrfs related events, there is a field for fsid, but perf never
parse it correctly.

 # perf trace -e btrfS:qgroup_meta_convert xfs_io -f -c "pwrite 0 4k" \
   /mnt/btrfs/file1
     0.000 xfs_io/77915 btrfs:qgroup_meta_reserve:(nil)U: refroot=5(FS_TREE) type=0x0 diff=2
                                                  ^^^^^^ Not a correct UUID
     ...

[CAUSE]
The pretty_print() function doesn't handle the %pU format correctly.
In fact it doesn't handle %pU as uuid at all.

[FIX]
Add a new functiono, print_uuid_arg(), to handle %pU correctly.

Now perf trace can at least print fsid correctly:
     0.000 xfs_io/79619 btrfs:qgroup_meta_reserve:23ad1511-dd83-47d4-a79c-e96625a15a6e refroot=5(FS_TREE) type=0x0 diff=2

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Please note in above case, the @type and @diff are not properly showed.
That's another problem, will be addressed in later patches.
---
 tools/lib/traceevent/event-parse.c | 38 ++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index d948475585ce..4f730ed527b0 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -18,6 +18,7 @@
 #include <errno.h>
 #include <stdint.h>
 #include <limits.h>
+#include <linux/uuid.h>
 #include <linux/time64.h>
 
 #include <netinet/in.h>
@@ -4508,6 +4509,33 @@ get_bprint_format(void *data, int size __maybe_unused,
 	return format;
 }
 
+static void print_uuid_arg(struct trace_seq *s, void *data, int size,
+			   struct tep_event *event, struct tep_print_arg *arg)
+{
+	const char *fmt;
+	unsigned char *buf;
+
+	fmt = "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x";
+	if (arg->type != TEP_PRINT_FIELD) {
+		trace_seq_printf(s, "ARG TYPE NOT FIELID but %d", arg->type);
+		return;
+	}
+
+	if (!arg->field.field) {
+		arg->field.field = tep_find_any_field(event, arg->field.name);
+		if (!arg->field.field) {
+			do_warning("%s: field %s not found",
+				   __func__, arg->field.name);
+			return;
+		}
+	}
+	buf = data + arg->field.field->offset;
+
+	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5],
+		         buf[6], buf[7], buf[8], buf[9], buf[10], buf[11], buf[12],
+			 buf[13], buf[14], buf[15]);
+}
+
 static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 			  struct tep_event *event, struct tep_print_arg *arg)
 {
@@ -5074,6 +5102,16 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 						arg = arg->next;
 						break;
 					}
+				} else if (*ptr == 'U') {
+					/* Those finetunings are ignored for now */
+					if (isalpha(ptr[1]))
+						ptr += 2;
+					else
+						ptr++;
+
+					print_uuid_arg(s, data, size, event, arg);
+					arg = arg->next;
+					break;
 				}
 
 				/* fall through */
-- 
2.23.0

