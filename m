Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E9FC10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BC782183F
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388690AbfDRJIF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:08:05 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:34155 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388665AbfDRJIE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 05:08:04 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH2ze-0001mB-SZ; Thu, 18 Apr 2019 11:06:07 +0200
Message-Id: <20190418084253.431851214@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 18 Apr 2019 10:41:23 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-arch@vger.kernel.org
Subject: [patch V2 04/29] backtrace-test: Simplify stack trace handling
References: <20190418084119.056416939@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace the indirection through struct stack_trace by using the storage
array based interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/backtracetest.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -48,19 +48,14 @@ static void backtrace_test_irq(void)
 #ifdef CONFIG_STACKTRACE
 static void backtrace_test_saved(void)
 {
-	struct stack_trace trace;
 	unsigned long entries[8];
+	unsigned int nr_entries;
 
 	pr_info("Testing a saved backtrace.\n");
 	pr_info("The following trace is a kernel self test and not a bug!\n");
 
-	trace.nr_entries = 0;
-	trace.max_entries = ARRAY_SIZE(entries);
-	trace.entries = entries;
-	trace.skip = 0;
-
-	save_stack_trace(&trace);
-	print_stack_trace(&trace, 0);
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
+	stack_trace_print(entries, nr_entries, 0);
 }
 #else
 static void backtrace_test_saved(void)


