Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CF8C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2145E206B6
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388610AbfDRJJp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:09:45 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:34075 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388426AbfDRJHd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 05:07:33 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH30P-0001xS-En; Thu, 18 Apr 2019 11:06:53 +0200
Message-Id: <20190418084255.364915116@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 18 Apr 2019 10:41:44 +0200
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
Subject: [patch V2 25/29] livepatch: Simplify stack trace retrieval
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
 kernel/livepatch/transition.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -202,15 +202,15 @@ void klp_update_patch_state(struct task_
  * Determine whether the given stack trace includes any references to a
  * to-be-patched or to-be-unpatched function.
  */
-static int klp_check_stack_func(struct klp_func *func,
-				struct stack_trace *trace)
+static int klp_check_stack_func(struct klp_func *func, unsigned long *entries,
+				unsigned int nr_entries)
 {
 	unsigned long func_addr, func_size, address;
 	struct klp_ops *ops;
 	int i;
 
-	for (i = 0; i < trace->nr_entries; i++) {
-		address = trace->entries[i];
+	for (i = 0; i < nr_entries; i++) {
+		address = entries[i];
 
 		if (klp_target_state == KLP_UNPATCHED) {
 			 /*
@@ -254,29 +254,25 @@ static int klp_check_stack_func(struct k
 static int klp_check_stack(struct task_struct *task, char *err_buf)
 {
 	static unsigned long entries[MAX_STACK_ENTRIES];
-	struct stack_trace trace;
 	struct klp_object *obj;
 	struct klp_func *func;
-	int ret;
+	int ret, nr_entries;
 
-	trace.skip = 0;
-	trace.nr_entries = 0;
-	trace.max_entries = MAX_STACK_ENTRIES;
-	trace.entries = entries;
-	ret = save_stack_trace_tsk_reliable(task, &trace);
+	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
 	WARN_ON_ONCE(ret == -ENOSYS);
-	if (ret) {
+	if (ret < 0) {
 		snprintf(err_buf, STACK_ERR_BUF_SIZE,
 			 "%s: %s:%d has an unreliable stack\n",
 			 __func__, task->comm, task->pid);
 		return ret;
 	}
+	nr_entries = ret;
 
 	klp_for_each_object(klp_transition_patch, obj) {
 		if (!obj->patched)
 			continue;
 		klp_for_each_func(obj, func) {
-			ret = klp_check_stack_func(func, &trace);
+			ret = klp_check_stack_func(func, entries, nr_entries);
 			if (ret) {
 				snprintf(err_buf, STACK_ERR_BUF_SIZE,
 					 "%s: %s:%d is sleeping on function %s\n",


