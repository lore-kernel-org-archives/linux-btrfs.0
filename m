From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 01/18] mm: export use_mm and unuse_mm for filesystem modules.
Date: Sun, 21 Mar 2010 23:18:54 -0400
Message-ID: <4BA6E19E.2080005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


required for btrfs directio worker threads.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 mm/mmu_context.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index ded9081..ecfb087 100644
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
@@ -56,3 +58,5 @@ void unuse_mm(struct mm_struct *mm)
 	enter_lazy_tlb(mm, tsk);
 	task_unlock(tsk);
 }
+EXPORT_SYMBOL_GPL(unuse_mm);
+
-- 
1.6.3.3
