From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/2] tracing: update btrfs's tracepoints to use u64 interface
Date: Tue, 19 Apr 2011 09:35:31 +0800
Message-ID: <4DACE6E3.8080200@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com>	 <1301665762.2160.22.camel@gandalf.stny.rr.com>	 <4D9C2FF6.7090607@cn.fujitsu.com> <1303150309.7181.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1303150309.7181.51.camel@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>


To avoid 64->32 truncating WARNING, update btrfs's tracepoints.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 include/trace/events/btrfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f445cff..4114129 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -28,7 +28,7 @@ struct extent_buffer;
 		{ BTRFS_SHARED_DATA_REF_KEY, 	"SHARED_DATA_REF" })
 
 #define __show_root_type(obj)						\
-	__print_symbolic(obj,						\
+	__print_symbolic_u64(obj,					\
 		{ BTRFS_ROOT_TREE_OBJECTID, 	"ROOT_TREE"	},	\
 		{ BTRFS_EXTENT_TREE_OBJECTID, 	"EXTENT_TREE"	},	\
 		{ BTRFS_CHUNK_TREE_OBJECTID, 	"CHUNK_TREE"	},	\
@@ -125,7 +125,7 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 );
 
 #define __show_map_type(type)						\
-	__print_symbolic(type,						\
+	__print_symbolic_u64(type,					\
 		{ EXTENT_MAP_LAST_BYTE, "LAST_BYTE" 	},		\
 		{ EXTENT_MAP_HOLE, 	"HOLE" 		},		\
 		{ EXTENT_MAP_INLINE, 	"INLINE" 	},		\
-- 
1.6.5.2
