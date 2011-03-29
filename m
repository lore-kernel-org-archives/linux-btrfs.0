From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: add initial tracepoint support for btrfs
Date: Tue, 29 Mar 2011 16:30:34 +0800
Message-ID: <4D9198AA.5050909@cn.fujitsu.com>
References: <4D8B28A3.7050105@cn.fujitsu.com> <1301141505-sup-3679@think> <1301273942-sup-2832@think> <4D9132DB.9000507@cn.fujitsu.com> <4D918E80.1010109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D918E80.1010109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this patch...

I just found we'd better revise the tracepoint side instead of btrfs side, will dig it more.

thanks,
liubo

> From: Liu Bo <liubo2009@cn.fujitsu.com>
> 
> [PATCH] Btrfs: fix compile warnings of btrfs tracepoint on 32bit box
> 
> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
> include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
> 
> btrfs has defined some macros which value has ULL type, and when btrfs tracepoints
> use these macros on 32bit box, values like "-1ULL" will be truncated.
> This is where those warnings come from.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  include/trace/events/btrfs.h |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index f445cff..27e67fd 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -36,9 +36,12 @@ struct extent_buffer;
>  		{ BTRFS_FS_TREE_OBJECTID, 	"FS_TREE"	},	\
>  		{ BTRFS_ROOT_TREE_DIR_OBJECTID, "ROOT_TREE_DIR"	},	\
>  		{ BTRFS_CSUM_TREE_OBJECTID, 	"CSUM_TREE"	},	\
> -		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
> -		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
> -		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
> +		{ (unsigned long)BTRFS_TREE_LOG_OBJECTID, 		\
> +						"TREE_LOG"	},	\
> +		{ (unsigned long)BTRFS_TREE_RELOC_OBJECTID, 		\
> +						"TREE_RELOC"},		\
> +		{ (unsigned long)BTRFS_DATA_RELOC_TREE_OBJECTID, 	\
> +						"DATA_RELOC_TREE" })
>  
>  #define show_root_type(obj)						\
>  	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
> @@ -126,13 +129,13 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
>  
>  #define __show_map_type(type)						\
>  	__print_symbolic(type,						\
> -		{ EXTENT_MAP_LAST_BYTE, "LAST_BYTE" 	},		\
> -		{ EXTENT_MAP_HOLE, 	"HOLE" 		},		\
> -		{ EXTENT_MAP_INLINE, 	"INLINE" 	},		\
> -		{ EXTENT_MAP_DELALLOC,	"DELALLOC" 	})
> +		{ (unsigned long)EXTENT_MAP_LAST_BYTE,	"LAST_BYTE" },	\
> +		{ (unsigned long)EXTENT_MAP_HOLE, 	"HOLE"      },	\
> +		{ (unsigned long)EXTENT_MAP_INLINE, 	"INLINE"    },	\
> +		{ (unsigned long)EXTENT_MAP_DELALLOC,	"DELALLOC"  })
>  
>  #define show_map_type(type)			\
> -	type, (type >= EXTENT_MAP_LAST_BYTE) ? "-" :  __show_map_type(type)
> +	type, (type >= EXTENT_MAP_LAST_BYTE) ? "-" : __show_map_type(type)
>  
>  #define show_map_flags(flag)						\
>  	__print_flags(flag, "|",					\

