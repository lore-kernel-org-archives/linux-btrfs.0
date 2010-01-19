From: jim owens <jowens@hp.com>
Subject: [RFC INFO PATCH 02/03] export use_mm and unuse_mm for filesystem
 modules.
Date: Tue, 19 Jan 2010 16:58:44 -0500
Message-ID: <4B562B14.3050208@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


required for btrfs directio worker threads.

Signed-off-by: jim owens <jowens@hp.com>
---
mm/mmu_context.c |    3 +++
1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index ded9081..daabf4d 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -3,6 +3,7 @@
 * See ../COPYING for licensing terms.
 */

+#include <linux/module.h>
#include <linux/mm.h>
#include <linux/mmu_context.h>
#include <linux/sched.h>
@@ -37,6 +38,7 @@ void use_mm(struct mm_struct *mm)
    if (active_mm != mm)
        mmdrop(active_mm);
}
+EXPORT_SYMBOL_GPL(use_mm);

/*
 * unuse_mm
@@ -56,3 +58,4 @@ void unuse_mm(struct mm_struct *mm)
    enter_lazy_tlb(mm, tsk);
    task_unlock(tsk);
}
+EXPORT_SYMBOL_GPL(unuse_mm);
-- 
1.5.6.3

