Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50431C10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 11:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E66F218D2
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 11:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfDJLHR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 07:07:17 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:59019 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731189AbfDJLGU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 07:06:20 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hEB3O-0005C8-63; Wed, 10 Apr 2019 13:06:06 +0200
Message-Id: <20190410103646.221275815@linutronix.de>
User-Agent: quilt/0.65
Date:   Wed, 10 Apr 2019 12:28:23 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: [RFC patch 29/41] btrfs: ref-verify: Simplify stack trace retrieval
References: <20190410102754.387743324@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace the indirection through struct stack_trace with an invocation of
the storage array based interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/ref-verify.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -205,28 +205,17 @@ static struct root_entry *lookup_root_en
 #ifdef CONFIG_STACKTRACE
 static void __save_stack_trace(struct ref_action *ra)
 {
-	struct stack_trace stack_trace;
-
-	stack_trace.max_entries = MAX_TRACE;
-	stack_trace.nr_entries = 0;
-	stack_trace.entries = ra->trace;
-	stack_trace.skip = 2;
-	save_stack_trace(&stack_trace);
-	ra->trace_len = stack_trace.nr_entries;
+	ra->trace_len = stack_trace_save(ra->trace, MAX_TRACE, 2);
 }
 
 static void __print_stack_trace(struct btrfs_fs_info *fs_info,
 				struct ref_action *ra)
 {
-	struct stack_trace trace;
-
 	if (ra->trace_len == 0) {
 		btrfs_err(fs_info, "  ref-verify: no stacktrace");
 		return;
 	}
-	trace.nr_entries = ra->trace_len;
-	trace.entries = ra->trace;
-	print_stack_trace(&trace, 2);
+	stack_trace_print(ra->trace, ra->trace_len, 2);
 }
 #else
 static void inline __save_stack_trace(struct ref_action *ra)


