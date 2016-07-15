Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1351 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbcGOGRV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 02:17:21 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6F6DjtN042204
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 02:17:21 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
	by mx0a-001b2d01.pphosted.com with ESMTP id 246k2130en-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 02:17:21 -0400
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 15 Jul 2016 16:17:12 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 137EB2BB005D
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:17:11 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6F6HBI420709514
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:17:11 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6F6HAOT009595
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:17:10 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allocate exact page array size in extent_buffer
Date: Fri, 15 Jul 2016 11:47:07 +0530
In-Reply-To: <1468499372-24687-1-git-send-email-dsterba@suse.com>
References: <1468499372-24687-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3567275.PIHfl50pLS@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, July 14, 2016 02:29:32 PM David Sterba wrote:
> The calculation of extent_buffer::pages size was done for 4k PAGE_SIZE,
> but this wastes 15 unused pointers on arches with large page size. Eg.
> on ppc64 this gives 15 * 8 = 120 bytes.
>

The non PAGE_SIZE aligned extent buffer usage in page straddling tests in
test_eb_bitmaps() need atleast one more page. So how about the following ...

#define INLINE_EXTENT_BUFFER_PAGES    (BTRFS_MAX_METADATA_BLOCKSIZE / PAGE_SIZE + 1)


> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h     | 6 ------
>  fs/btrfs/extent_io.c | 2 ++
>  fs/btrfs/extent_io.h | 8 +++++++-
>  3 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4274a7bfdaed..f914f6187753 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -66,12 +66,6 @@ struct btrfs_ordered_sum;
>  #define BTRFS_COMPAT_EXTENT_TREE_V0
> 
>  /*
> - * the max metadata block size.  This limit is somewhat artificial,
> - * but the memmove costs go through the roof for larger blocks.
> - */
> -#define BTRFS_MAX_METADATA_BLOCKSIZE 65536
> -
> -/*
>   * we can actually store much bigger names, but lets not confuse the rest
>   * of linux
>   */
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 75533adef998..6f468a1842e6 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4660,6 +4660,8 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
>  	/*
>  	 * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
>  	 */
> +	BUILD_BUG_ON(INLINE_EXTENT_BUFFER_PAGES * PAGE_SIZE
> +		!= BTRFS_MAX_METADATA_BLOCKSIZE);
>  	BUILD_BUG_ON(BTRFS_MAX_METADATA_BLOCKSIZE
>  		> MAX_INLINE_EXTENT_BUFFER_SIZE);
>  	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index c0c1c4fef6ce..edfa1a0ab82b 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -4,6 +4,12 @@
>  #include <linux/rbtree.h>
>  #include "ulist.h"
> 
> +/*
> + * The maximum metadata block size.  This limit is somewhat artificial,
> + * but the memmove costs go through the roof for larger blocks.
> + */
> +#define BTRFS_MAX_METADATA_BLOCKSIZE (65536U)
> +
>  /* bits for the extent state */
>  #define EXTENT_DIRTY		(1U << 0)
>  #define EXTENT_WRITEBACK	(1U << 1)
> @@ -118,7 +124,7 @@ struct extent_state {
>  #endif
>  };
> 
> -#define INLINE_EXTENT_BUFFER_PAGES 16
> +#define INLINE_EXTENT_BUFFER_PAGES    (BTRFS_MAX_METADATA_BLOCKSIZE / PAGE_SIZE)
>  #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_SIZE)
>  struct extent_buffer {
>  	u64 start;
> 

-- 
chandan

