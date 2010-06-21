From: "jeff.liu" <jeff.liu@oracle.com>
Subject: Re: [PATCH RESEND] btrfs: Don't return extent in fiemap if we meet
 with a hole.
Date: Mon, 21 Jun 2010 15:36:29 +0800
Message-ID: <4C1F167D.3040908@oracle.com>
References: <1277102222-3310-1-git-send-email-tao.ma@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Tao Ma <tao.ma@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1277102222-3310-1-git-send-email-tao.ma@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Could you please also consider another tiny patch below combine with Tao's?
It fix extent flags to FIEMAP_FLAG_UNWRITTEN if it was fallocate(2) and its "em->block_start ==
EXTENT_MAP_LAST_BYTE".

>From 63904ff528842bcbe20e9d34763c5e689c2f7ace Mon Sep 17 00:00:00 2001
From: Jeff Liu <jeff.liu@oracle.com>
Date: Mon, 21 Jun 2010 15:28:36 +0800
Subject: [PATCH] Fix fiemap extent flag to FIEMAP_FLAG_UNWRITTEN if it is fallocated.

Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
---
 fs/btrfs/extent_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a4080c2..e68fd61 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3005,6 +3005,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		}
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			flags |= FIEMAP_EXTENT_ENCODED;
+		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+			flags |= FIEMAP_EXTENT_UNWRITTEN;

 		emflags = em->flags;
 		free_extent_map(em);
-- 
1.7.1


Thanks,
-Jeff

Tao Ma wrote:
> Hi Chris,
> 	could you please consider merging this patch? It should be
> trivial enough. It helps Jeff adding fiemap support to cp.
> 
> Regards,
> Tao
> 
> From 909effe7240be30dbc9403dd8cbb326587c3cc02 Mon Sep 17 00:00:00 2001
> From: Tao Ma <tao.ma@oracle.com>
> Date: Thu, 22 Apr 2010 12:38:57 +0800
> Subject: [PATCH RESEND] btrfs: Don't return extent in fiemap if we meet with a hole.
> 
> Recently, my colleague Jeff tried to add fiemap support to cp(1).
> http://www.mail-archive.com/bug-coreutils@gnu.org/msg19987.html
> 
> He just meet with a strange issue with following command:
> dd if=/dev/null of=/btrfs/sparse bs=1 seek=4096
> When we use fiemap to the file, btrfs returns an extent with len '4096'
> and flag 'unwritten' while actually there is no data allocated.
> 
> I just dived into this and to my surprise, it is done by btrfs
> intentionally. I checked other file systems which support fiemap.
> Actually with the file created by the script, ocfs2, ext3/4 and
> xfs all return zero extent. And according to the documentation file
> Documentation/filesystems/fiemap.txt, FIEMAP_EXTENT_UNWRITTEN should
> be used when the extent is allocated but it's data has not been
> initialized. So I think btrfs should work like other filesystems.
> 
> Cc: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> Tested-by: Jeff Liu <jeff.liu@oracle.com>
> ---
>  fs/btrfs/extent_io.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b177ed3..7eb4d77 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2951,7 +2951,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  	u64 disko = 0;
>  	struct extent_map *em = NULL;
>  	struct extent_state *cached_state = NULL;
> -	int end = 0;
> +	int end = 0, hole = 0;
>  	u64 em_start = 0, em_len = 0;
>  	unsigned long emflags;
>  	ret = 0;
> @@ -2978,12 +2978,13 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  
>  		disko = 0;
>  		flags = 0;
> +		hole = 0;
>  
>  		if (em->block_start == EXTENT_MAP_LAST_BYTE) {
>  			end = 1;
>  			flags |= FIEMAP_EXTENT_LAST;
>  		} else if (em->block_start == EXTENT_MAP_HOLE) {
> -			flags |= FIEMAP_EXTENT_UNWRITTEN;
> +			hole = 1;
>  		} else if (em->block_start == EXTENT_MAP_INLINE) {
>  			flags |= (FIEMAP_EXTENT_DATA_INLINE |
>  				  FIEMAP_EXTENT_NOT_ALIGNED);
> @@ -3015,10 +3016,12 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  			end = 1;
>  		}
>  
> -		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
> -					em_len, flags);
> -		if (ret)
> -			goto out_free;
> +		if (!hole) {
> +			ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
> +						      em_len, flags);
> +			if (ret)
> +				goto out_free;
> +		}
>  	}
>  out_free:
>  	free_extent_map(em);


-- 
With Windows 7, Microsoft is asserting legal control over your computer and is using this power to
abuse computer users.
