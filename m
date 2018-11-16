Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9D5C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0624B2145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0624B2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbeKPQu4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 11:50:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:36734 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPQu4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 11:50:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 90077AE0B
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 06:39:50 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: Cleanup warning reported by
 -Wmissing-prototypes except free space tree
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181116061312.2848-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <0079c368-c495-49c6-0698-d1844ae747b3@suse.com>
Date:   Fri, 16 Nov 2018 08:39:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181116061312.2848-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 16.11.18 г. 8:13 ч., Qu Wenruo wrote:
> The following missing prototypes will be fixed:
> 1) btrfs.c::handle_special_globals()
> 2) check/mode-lowmem.c::repair_ternary_lowmem()
> 3) extent-tree.c::btrfs_search_overlap_extent()
>    Above 3 can be fixed by making them static
> 
> 4) utils.c::btrfs_check_nodesize()
>    Fixed by moving it to fsfeatures.c
> 
> 5) chunk-recover.c::btrfs_recover_chunk_tree()
> 6) super-recover.c::btrfs_recover_superblocks()
>    Fixed by moving the declaration from cmds-rescue.c to rescue.h
> 
> 7) utils-lib.c::arg_strtou64()
> 7) utils-lib.c::lookup_path_rootid()
>    Fixed by include "utils.h"
> 
> Free space tree is left untouched, as some unused functions are there
> for later write support.

Hm, I think freespace tree is more or less done, what else is there?
There is one function in there: set_free_space_tree_thresholds which i
think could be removed, can't remember why I backported it. And there
were some other that could just be made static.

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  btrfs.c             |  2 +-
>  check/mode-lowmem.c |  6 +++---
>  chunk-recover.c     |  1 +
>  cmds-rescue.c       |  4 +---
>  extent-tree.c       |  2 +-
>  fsfeatures.c        | 22 ++++++++++++++++++++++
>  rescue.h            | 14 ++++++++++++++
>  super-recover.c     |  1 +
>  utils-lib.c         |  1 +
>  utils.c             | 23 -----------------------
>  10 files changed, 45 insertions(+), 31 deletions(-)
>  create mode 100644 rescue.h
> 
> diff --git a/btrfs.c b/btrfs.c
> index 2d39f2ced3e8..78c468d2e050 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -210,7 +210,7 @@ static int handle_global_options(int argc, char **argv)
>  	return shift;
>  }
>  
> -void handle_special_globals(int shift, int argc, char **argv)
> +static void handle_special_globals(int shift, int argc, char **argv)
>  {
>  	int has_help = 0;
>  	int has_full = 0;
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 14bbc9ee6cb6..f56b5e8d45dc 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -953,9 +953,9 @@ out:
>   * returns 0 means success.
>   * returns not 0 means on error;
>   */
> -int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
> -			  u64 index, char *name, int name_len, u8 filetype,
> -			  int err)
> +static int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
> +				 u64 index, char *name, int name_len,
> +				 u8 filetype, int err)
>  {
>  	struct btrfs_trans_handle *trans;
>  	int stage = 0;
> diff --git a/chunk-recover.c b/chunk-recover.c
> index 1d30db51d8ed..1e554b8e8750 100644
> --- a/chunk-recover.c
> +++ b/chunk-recover.c
> @@ -40,6 +40,7 @@
>  #include "utils.h"
>  #include "btrfsck.h"
>  #include "commands.h"
> +#include "rescue.h"
>  
>  struct recover_control {
>  	int verbose;
> diff --git a/cmds-rescue.c b/cmds-rescue.c
> index 2bc50c0841ed..36e9e1277e40 100644
> --- a/cmds-rescue.c
> +++ b/cmds-rescue.c
> @@ -26,15 +26,13 @@
>  #include "commands.h"
>  #include "utils.h"
>  #include "help.h"
> +#include "rescue.h"
>  
>  static const char * const rescue_cmd_group_usage[] = {
>  	"btrfs rescue <command> [options] <path>",
>  	NULL
>  };
>  
> -int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
> -int btrfs_recover_superblocks(const char *path, int verbose, int yes);
> -
>  static const char * const cmd_rescue_chunk_recover_usage[] = {
>  	"btrfs rescue chunk-recover [options] <device>",
>  	"Recover the chunk tree by scanning the devices one by one.",
> diff --git a/extent-tree.c b/extent-tree.c
> index cd98633992ac..8c9cdeff3b02 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -3749,7 +3749,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
>   * Return >0 for not found.
>   * Return <0 for err
>   */
> -int btrfs_search_overlap_extent(struct btrfs_root *root,
> +static int btrfs_search_overlap_extent(struct btrfs_root *root,
>  				struct btrfs_path *path, u64 bytenr, u64 len)
>  {
>  	struct btrfs_key key;
> diff --git a/fsfeatures.c b/fsfeatures.c
> index 7d85d60f1277..201d0f576688 100644
> --- a/fsfeatures.c
> +++ b/fsfeatures.c
> @@ -225,3 +225,25 @@ u32 get_running_kernel_version(void)
>  	return version;
>  }
>  
> +int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
> +{
> +	if (nodesize < sectorsize) {
> +		error("illegal nodesize %u (smaller than %u)",
> +				nodesize, sectorsize);
> +		return -1;
> +	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
> +		error("illegal nodesize %u (larger than %u)",
> +			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
> +		return -1;
> +	} else if (nodesize & (sectorsize - 1)) {
> +		error("illegal nodesize %u (not aligned to %u)",
> +			nodesize, sectorsize);
> +		return -1;
> +	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
> +		   nodesize != sectorsize) {
> +		error("illegal nodesize %u (not equal to %u for mixed block group)",
> +			nodesize, sectorsize);
> +		return -1;
> +	}
> +	return 0;
> +}
> diff --git a/rescue.h b/rescue.h
> new file mode 100644
> index 000000000000..c9f6e7b80b16
> --- /dev/null
> +++ b/rescue.h
> @@ -0,0 +1,14 @@
> +/*
> + * Copyright (C) 2018 SUSE.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +int btrfs_recover_superblocks(const char *path, int verbose, int yes);
> +int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
> diff --git a/super-recover.c b/super-recover.c
> index 86b3df9867dc..a1af71786034 100644
> --- a/super-recover.c
> +++ b/super-recover.c
> @@ -34,6 +34,7 @@
>  #include "crc32c.h"
>  #include "volumes.h"
>  #include "commands.h"
> +#include "rescue.h"
>  
>  struct btrfs_recover_superblock {
>  	struct btrfs_fs_devices *fs_devices;
> diff --git a/utils-lib.c b/utils-lib.c
> index 044f93fc4446..5bb89f2f1a8d 100644
> --- a/utils-lib.c
> +++ b/utils-lib.c
> @@ -1,4 +1,5 @@
>  #include "kerncompat.h"
> +#include "utils.h"
>  #include <unistd.h>
>  #include <stdlib.h>
>  #include <limits.h>
> diff --git a/utils.c b/utils.c
> index a310300829eb..607a14e8f287 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2252,29 +2252,6 @@ int btrfs_tree_search2_ioctl_supported(int fd)
>  	return ret;
>  }
>  
> -int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
> -{
> -	if (nodesize < sectorsize) {
> -		error("illegal nodesize %u (smaller than %u)",
> -				nodesize, sectorsize);
> -		return -1;
> -	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
> -		error("illegal nodesize %u (larger than %u)",
> -			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
> -		return -1;
> -	} else if (nodesize & (sectorsize - 1)) {
> -		error("illegal nodesize %u (not aligned to %u)",
> -			nodesize, sectorsize);
> -		return -1;
> -	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
> -		   nodesize != sectorsize) {
> -		error("illegal nodesize %u (not equal to %u for mixed block group)",
> -			nodesize, sectorsize);
> -		return -1;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * Copy a path argument from SRC to DEST and check the SRC length if it's at
>   * most PATH_MAX and fits into DEST. DESTLEN is supposed to be exact size of
> 
