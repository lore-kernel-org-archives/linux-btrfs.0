Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0205DC282E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4F7F206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfDYKAp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:00:45 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:58054 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729813AbfDYKAn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:00:43 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJbA6-0001uB-F4; Thu, 25 Apr 2019 11:59:26 +0200
Message-Id: <20190425094802.716274532@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:45:10 +0200
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
Subject: [patch V3 17/29] lockdep: Remove unused trace argument from
 print_circular_bug()
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/lockdep.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1522,10 +1522,9 @@ static inline int class_equal(struct loc
 }
 
 static noinline int print_circular_bug(struct lock_list *this,
-				struct lock_list *target,
-				struct held_lock *check_src,
-				struct held_lock *check_tgt,
-				struct stack_trace *trace)
+				       struct lock_list *target,
+				       struct held_lock *check_src,
+				       struct held_lock *check_tgt)
 {
 	struct task_struct *curr = current;
 	struct lock_list *parent;
@@ -2206,7 +2205,7 @@ check_prev_add(struct task_struct *curr,
 			 */
 			save(trace);
 		}
-		return print_circular_bug(&this, target_entry, next, prev, trace);
+		return print_circular_bug(&this, target_entry, next, prev);
 	}
 	else if (unlikely(ret < 0))
 		return print_bfs_bug(ret);


