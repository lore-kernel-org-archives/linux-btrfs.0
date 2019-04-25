Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C568FC282E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ED30217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbfDYKAB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:00:01 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:57848 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbfDYKAA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:00:00 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJb9q-0001r1-8n; Thu, 25 Apr 2019 11:59:10 +0200
Message-Id: <20190425094801.683039030@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:44:59 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-arch@vger.kernel.org
Subject: [patch V3 06/29] latency_top: Simplify stack trace handling
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace the indirection through struct stack_trace with an invocation of
the storage array based interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/latencytop.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -141,20 +141,6 @@ account_global_scheduler_latency(struct
 	memcpy(&latency_record[i], lat, sizeof(struct latency_record));
 }
 
-/*
- * Iterator to store a backtrace into a latency record entry
- */
-static inline void store_stacktrace(struct task_struct *tsk,
-					struct latency_record *lat)
-{
-	struct stack_trace trace;
-
-	memset(&trace, 0, sizeof(trace));
-	trace.max_entries = LT_BACKTRACEDEPTH;
-	trace.entries = &lat->backtrace[0];
-	save_stack_trace_tsk(tsk, &trace);
-}
-
 /**
  * __account_scheduler_latency - record an occurred latency
  * @tsk - the task struct of the task hitting the latency
@@ -191,7 +177,8 @@ void __sched
 	lat.count = 1;
 	lat.time = usecs;
 	lat.max = usecs;
-	store_stacktrace(tsk, &lat);
+
+	stack_trace_save_tsk(tsk, lat.backtrace, LT_BACKTRACEDEPTH, 0);
 
 	raw_spin_lock_irqsave(&latency_lock, flags);
 


