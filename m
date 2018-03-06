Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753821AbeCFTYS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 14:24:18 -0500
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v8 03/63] arm64: Turn flush_dcache_mmap_lock into a no-op
Date: Tue,  6 Mar 2018 11:23:13 -0800
Message-Id: <20180306192413.5499-4-willy@infradead.org>
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Matthew Wilcox <mawilcox@microsoft.com>

ARM64 doesn't walk the VMA tree in its flush_dcache_page()
implementation, so has no need to take the tree_lock.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cacheflush.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index bef9f418f089..550b0abea953 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -137,10 +137,8 @@ static inline void __flush_icache_all(void)
 	dsb(ish);
 }
 
-#define flush_dcache_mmap_lock(mapping) \
-	spin_lock_irq(&(mapping)->tree_lock)
-#define flush_dcache_mmap_unlock(mapping) \
-	spin_unlock_irq(&(mapping)->tree_lock)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
-- 
2.16.1

