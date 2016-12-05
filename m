Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8761 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750841AbcLEHK1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 02:10:27 -0500
Subject: Re: [PATCH 1/2] btrfs-progs: Correct value printed by
 assertions/BUG_ON/WARN_ON
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <20161129162452.28402-1-rgoldwyn@suse.de>
CC: Goldwyn Rodrigues <rgoldwyn@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f0beaab1-a09c-cd3e-c00e-2727c3ec8ecd@cn.fujitsu.com>
Date: Mon, 5 Dec 2016 15:10:16 +0800
MIME-Version: 1.0
In-Reply-To: <20161129162452.28402-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Goldwyn and David,

This patch seems to cause btrfs test case 023 to fail.

Bisect leads me to this patch.


$ ./btrfs check ~/quota_balance_loop_backref.raw.restored
Checking filesystem on /home/adam/quota_balance_loop_backref.raw.restored
UUID: c33c5ce3-3ad9-4320-9201-c337c04e0051
checking extents
btrfs: cmds-check.c:12284: build_roots_info_cache: Assertion `!(ret == 
0)' failed.
Aborted (core dumped)


And gdb backref:
#0  0x00007ffff6fd204f in raise () from /usr/lib/libc.so.6
#1  0x00007ffff6fd347a in abort () from /usr/lib/libc.so.6
#2  0x00007ffff6fcaea7 in __assert_fail_base () from /usr/lib/libc.so.6
#3  0x00007ffff6fcaf52 in __assert_fail () from /usr/lib/libc.so.6
#4  0x0000000000440426 in build_roots_info_cache (info=0x6f43c0) at 
cmds-check.c:12284
#5  0x0000000000440945 in repair_root_items (info=0x6f43c0) at 
cmds-check.c:12412
#6  0x00000000004418c3 in cmd_check (argc=2, argv=0x7fffffffe100) at 
cmds-check.c:12892
#7  0x000000000040a74c in main (argc=2, argv=0x7fffffffe100) at btrfs.c:301


For frame 4:
(gdb) frame 4
#4  0x0000000000440426 in build_roots_info_cache (info=0x6f43c0) at 
cmds-check.c:12284
12284				ASSERT(ret == 0);
(gdb) list
12279				rii->cache_extent.start = root_id;
12280				rii->cache_extent.size = 1;
12281				rii->level = (u8)-1;
12282				entry = &rii->cache_extent;
12283				ret = insert_cache_extent(roots_info_cache, entry);
12284				ASSERT(ret == 0);
12285			} else {
12286				rii = container_of(entry, struct root_item_info,
12287						   cache_extent);
12288			}
(gdb) print ret
$1 = 0

For me, ASSERT(ret == 0) seems quite safe and common here.
Doesn't the patch changed the ASSERT() behavior?

Thanks,
Qu

At 11/30/2016 12:24 AM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> The values passed to BUG_ON/WARN_ON are negated(!) and printed, which
> results in printing the value zero for each bug/warning. For example:
> volumes.c:988: btrfs_alloc_chunk: Assertion `ret` failed, value 0
>
> This is not useful. Instead changed to print the value of the parameter
> passed to BUG_ON()/WARN_ON(). The value needed to be changed to long
> to accomodate pointers being passed.
>
> Also, consolidated assert() and BUG() into ifndef.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  kerncompat.h | 35 +++++++++++++++--------------------
>  1 file changed, 15 insertions(+), 20 deletions(-)
>
> diff --git a/kerncompat.h b/kerncompat.h
> index ed9a042..9bd25bd 100644
> --- a/kerncompat.h
> +++ b/kerncompat.h
> @@ -88,39 +88,36 @@ static inline void print_trace(void)
>  }
>
>  static inline void assert_trace(const char *assertion, const char *filename,
> -			      const char *func, unsigned line, int val)
> +			      const char *func, unsigned line, long val)
>  {
> -	if (val)
> +	if (!val)
>  		return;
>  	if (assertion)
> -		fprintf(stderr, "%s:%d: %s: Assertion `%s` failed, value %d\n",
> +		fprintf(stderr, "%s:%d: %s: Assertion `%s` failed, value %ld\n",
>  			filename, line, func, assertion, val);
>  	else
> -		fprintf(stderr, "%s:%d: %s: Assertion failed, value %d.\n",
> +		fprintf(stderr, "%s:%d: %s: Assertion failed, value %ld.\n",
>  			filename, line, func, val);
>  	print_trace();
>  	abort();
>  	exit(1);
>  }
>
> -#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 0)
> -#else
> -#define BUG() assert(0)
>  #endif
>
>  static inline void warning_trace(const char *assertion, const char *filename,
> -			      const char *func, unsigned line, int val,
> +			      const char *func, unsigned line, long val,
>  			      int trace)
>  {
> -	if (val)
> +	if (!val)
>  		return;
>  	if (assertion)
>  		fprintf(stderr,
> -			"%s:%d: %s: Warning: assertion `%s` failed, value %d\n",
> +			"%s:%d: %s: Warning: assertion `%s` failed, value %ld\n",
>  			filename, line, func, assertion, val);
>  	else
>  		fprintf(stderr,
> -			"%s:%d: %s: Warning: assertion failed, value %d.\n",
> +			"%s:%d: %s: Warning: assertion failed, value %ld.\n",
>  			filename, line, func, val);
>  #ifndef BTRFS_DISABLE_BACKTRACE
>  	if (trace)
> @@ -299,17 +296,15 @@ static inline long IS_ERR(const void *ptr)
>  #define vfree(x) free(x)
>
>  #ifndef BTRFS_DISABLE_BACKTRACE
> -#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, !(c))
> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, !(c), 1)
> +#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
> +#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c), 1)
> +#define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)!(c))
> +#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
>  #else
>  #define BUG_ON(c) assert(!(c))
> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, !(c), 0)
> -#endif
> -
> -#ifndef BTRFS_DISABLE_BACKTRACE
> -#define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (c))
> -#else
> -#define ASSERT(c) assert(c)
> +#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c), 0)
> +#define ASSERT(c) assert(!(c))
> +#define BUG() assert(0)
>  #endif
>
>  #define container_of(ptr, type, member) ({                      \
>


