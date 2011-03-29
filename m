From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: add initial tracepoint support for btrfs
Date: Tue, 29 Mar 2011 15:47:12 +0800
Message-ID: <4D918E80.1010109@cn.fujitsu.com>
References: <4D8B28A3.7050105@cn.fujitsu.com> <1301141505-sup-3679@think> <1301273942-sup-2832@think> <4D9132DB.9000507@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9132DB.9000507@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/29/2011 09:16 AM, liubo wrote:
> On 03/28/2011 08:59 AM, Chris Mason wrote:
>> Excerpts from Chris Mason's message of 2011-03-26 08:12:04 -0400:
>>> Excerpts from liubo's message of 2011-03-24 07:18:59 -0400:
>>>> Tracepoints can provide insight into why btrfs hits bugs and be greatly
>>>> helpful for debugging, e.g
>>> This is really neat, I've queued it up.
>> Whoops, it has a lot of warnings when compiled on 32 bit machines.
>> Please take a look:
>>
>> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
>> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
>> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
>> include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
>> include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
>> include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
>> include/trace/events/btrfs.h:144:1: warning: large integer implicitly truncated to unsigned type
>>
> 
> Ahh, I figure it out.
> Will send a new version to clear warnings.
> 

Here is the patch to clear warnings.

From: Liu Bo <liubo2009@cn.fujitsu.com>

[PATCH] Btrfs: fix compile warnings of btrfs tracepoint on 32bit box

include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type

btrfs has defined some macros which value has ULL type, and when btrfs tracepoints
use these macros on 32bit box, values like "-1ULL" will be truncated.
This is where those warnings come from.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 include/trace/events/btrfs.h |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f445cff..27e67fd 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -36,9 +36,12 @@ struct extent_buffer;
 		{ BTRFS_FS_TREE_OBJECTID, 	"FS_TREE"	},	\
 		{ BTRFS_ROOT_TREE_DIR_OBJECTID, "ROOT_TREE_DIR"	},	\
 		{ BTRFS_CSUM_TREE_OBJECTID, 	"CSUM_TREE"	},	\
-		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
-		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
-		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
+		{ (unsigned long)BTRFS_TREE_LOG_OBJECTID, 		\
+						"TREE_LOG"	},	\
+		{ (unsigned long)BTRFS_TREE_RELOC_OBJECTID, 		\
+						"TREE_RELOC"},		\
+		{ (unsigned long)BTRFS_DATA_RELOC_TREE_OBJECTID, 	\
+						"DATA_RELOC_TREE" })
 
 #define show_root_type(obj)						\
 	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
@@ -126,13 +129,13 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 
 #define __show_map_type(type)						\
 	__print_symbolic(type,						\
-		{ EXTENT_MAP_LAST_BYTE, "LAST_BYTE" 	},		\
-		{ EXTENT_MAP_HOLE, 	"HOLE" 		},		\
-		{ EXTENT_MAP_INLINE, 	"INLINE" 	},		\
-		{ EXTENT_MAP_DELALLOC,	"DELALLOC" 	})
+		{ (unsigned long)EXTENT_MAP_LAST_BYTE,	"LAST_BYTE" },	\
+		{ (unsigned long)EXTENT_MAP_HOLE, 	"HOLE"      },	\
+		{ (unsigned long)EXTENT_MAP_INLINE, 	"INLINE"    },	\
+		{ (unsigned long)EXTENT_MAP_DELALLOC,	"DELALLOC"  })
 
 #define show_map_type(type)			\
-	type, (type >= EXTENT_MAP_LAST_BYTE) ? "-" :  __show_map_type(type)
+	type, (type >= EXTENT_MAP_LAST_BYTE) ? "-" : __show_map_type(type)
 
 #define show_map_flags(flag)						\
 	__print_flags(flag, "|",					\
-- 
1.6.5.2


> Thanks,
> liubo
> 
>> -chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

