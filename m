From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: remove crc32c.h and use libcrc32c directly.
Date: Sun, 19 Apr 2009 19:11:49 -0400
Message-ID: <1240182709.8932.2.camel@think.oraclecorp.com>
References: <1240142561.3589.143.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240142561.3589.143.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-04-19 at 13:02 +0100, David Woodhouse wrote:
> There's no need to preserve this abstraction; it used to let us use
> hardware crc32c support directly, but libcrc32c now does that for us
> through the crypto API -- so we're already using the Intel crc32c
> acceleration where appropriate, without having to do anything special.
> As is right and proper.
> 

How does this enable the HW crc32c?  Unless I'm missing something you're
doing crc32c instead of btrfs_crc32c, but btrfs_crc32c was #defined to
crc32c?

-chris

> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  fs/btrfs/crc32c.h      |   29 -----------------------------
>  fs/btrfs/disk-io.c     |    4 ++--
>  fs/btrfs/extent-tree.c |    1 -
>  fs/btrfs/hash.h        |    4 ++--
>  4 files changed, 4 insertions(+), 34 deletions(-)
>  delete mode 100644 fs/btrfs/crc32c.h
> 
> diff --git a/fs/btrfs/crc32c.h b/fs/btrfs/crc32c.h
> deleted file mode 100644
> index 6e1b3de..0000000
> --- a/fs/btrfs/crc32c.h
> +++ /dev/null
> @@ -1,29 +0,0 @@
> -/*
> - * Copyright (C) 2008 Oracle.  All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public
> - * License v2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public
> - * License along with this program; if not, write to the
> - * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> - * Boston, MA 021110-1307, USA.
> - */
> -
> -#ifndef __BTRFS_CRC32C__
> -#define __BTRFS_CRC32C__
> -#include <linux/crc32c.h>
> -
> -/*
> - * this file used to do more for selecting the HW version of crc32c,
> - * perhaps it will one day again soon.
> - */
> -#define btrfs_crc32c(seed, data, length) crc32c(seed, data, length)
> -#endif
> -
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 92caa80..ce1d8d7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -26,8 +26,8 @@
>  #include <linux/workqueue.h>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> +#include <linux/crc32c.h>
>  #include "compat.h"
> -#include "crc32c.h"
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -172,7 +172,7 @@ out:
>  
>  u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
>  {
> -	return btrfs_crc32c(seed, data, len);
> +	return crc32c(seed, data, len);
>  }
>  
>  void btrfs_csum_final(u32 crc, char *result)
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 178df4c..cdc4f11 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -23,7 +23,6 @@
>  #include <linux/rcupdate.h>
>  #include "compat.h"
>  #include "hash.h"
> -#include "crc32c.h"
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "print-tree.h"
> diff --git a/fs/btrfs/hash.h b/fs/btrfs/hash.h
> index 2a020b2..db2ff97 100644
> --- a/fs/btrfs/hash.h
> +++ b/fs/btrfs/hash.h
> @@ -19,9 +19,9 @@
>  #ifndef __HASH__
>  #define __HASH__
>  
> -#include "crc32c.h"
> +#include <linux/crc32c.h>
>  static inline u64 btrfs_name_hash(const char *name, int len)
>  {
> -	return btrfs_crc32c((u32)~1, name, len);
> +	return crc32c((u32)~1, name, len);
>  }
>  #endif
> -- 
> 1.6.2.2
> 
> 

