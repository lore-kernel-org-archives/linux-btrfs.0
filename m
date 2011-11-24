From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 06/99] btrfs: Add extent_state alloc/free tracing
Date: Wed, 23 Nov 2011 19:35:39 -0500
Message-ID: <20111124004220.512320610@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 While debugging the error handling patches, I found it useful to trace
 the allocation and freeing of extent_state structures. As a side note,
 a huge number of allocations have lifetimes in the < 10 us range.

 This patch adds the trace, including caller and object address.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c         |    2 +
 include/trace/events/btrfs.h |   44 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -141,6 +141,7 @@ static struct extent_state *alloc_extent
 #endif
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
+	trace_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
 }
 
@@ -158,6 +159,7 @@ void free_extent_state(struct extent_sta
 		list_del(&state->leak_list);
 		spin_unlock_irqrestore(&leak_lock, flags);
 #endif
+		trace_free_extent_state(state, _RET_IP_);
 		kmem_cache_free(extent_state_cache, state);
 	}
 }
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -6,6 +6,7 @@
 
 #include <linux/writeback.h>
 #include <linux/tracepoint.h>
+#include <trace/events/gfpflags.h>
 
 struct btrfs_root;
 struct btrfs_fs_info;
@@ -661,6 +662,49 @@ DEFINE_EVENT(btrfs__reserved_extent,  bt
 	TP_ARGS(root, start, len)
 );
 
+struct extent_state;
+TRACE_EVENT(alloc_extent_state,
+
+	TP_PROTO(struct extent_state *state, gfp_t mask, unsigned long IP),
+
+	TP_ARGS(state, mask, IP),
+
+	TP_STRUCT__entry(
+		__field(struct extent_state *, state)
+		__field(gfp_t, mask)
+		__field(unsigned long, ip)
+	),
+
+	TP_fast_assign(
+		__entry->state	= state,
+		__entry->mask	= mask,
+		__entry->ip	= IP
+	),
+
+	TP_printk("state=%p; mask = %s; caller = %pF", __entry->state,
+		  show_gfp_flags(__entry->mask), (void *)__entry->ip)
+);
+
+TRACE_EVENT(free_extent_state,
+
+	TP_PROTO(struct extent_state *state, unsigned long IP),
+
+	TP_ARGS(state, IP),
+
+	TP_STRUCT__entry(
+		__field(struct extent_state *, state)
+		__field(unsigned long, ip)
+	),
+
+	TP_fast_assign(
+		__entry->state	= state,
+		__entry->ip = IP
+	),
+
+	TP_printk(" state=%p; caller = %pF", __entry->state,
+		  (void *)__entry->ip)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */



