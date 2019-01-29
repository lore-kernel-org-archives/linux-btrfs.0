Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C06AC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 07:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2884C2147A
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 07:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfA2HZ5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:25:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:42114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbfA2HZ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 02:25:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE066ADD7;
        Tue, 29 Jan 2019 07:25:55 +0000 (UTC)
Subject: Re: [PATCH 11/11] btrfs: add zstd compression level support
To:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-12-dennis@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c92b0233-5406-42a8-4444-a5ab503f726f@suse.com>
Date:   Tue, 29 Jan 2019 09:25:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190128212437.11597-12-dennis@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> Zstd compression requires different amounts of memory for each level of
> compression. The prior patches implemented indirection to allow for each
> compression type to manage their workspaces independently. This patch
> uses this indirection to implement compression level support for zstd.
> 
> As mentioned above, a requirement that differs zstd from zlib is that
> higher levels of compression require more memory. To manage this, each
> compression level has its own queue of workspaces. A global LRU is used
> to help with reclaim. To guarantee forward progress, a max level
> workspace is preallocated and hidden from the LRU.
> 
> When getting a workspace, it uses a bitmap to identify the levels that
> are populated and scans up. If it finds a workspace that is greater than
> it, it uses it, but does not update the last_used time and the
> corresponding place in the LRU. This provides a mechanism to decrease
> memory utilization as we only keep around workspaces that are sized
> appropriately for the in use compression levels.
> 
> By knowing which compression levels have available workspaces, we can
> recycle rather than always create new workspaces as well as take
> advantage of the preallocated max level for forward progress. If we hit
> memory pressure, we sleep on the max level workspace. We continue to
> rescan in case we can use a smaller workspace, but eventually should be
> able to obtain the max level workspace or allocate one again should
> memory pressure subside. The memory requirement for decompression is the
> same as level 1, and therefore can use any of available workspace.
> 
> The number of workspaces is bound by an upper limit of the workqueue's
> limit which currently is 2 (percpu limit). Second, a reclaim timer is
> used to free inactive/improperly sized workspaces. The reclaim timer is
> set to 67s to avoid colliding with transaction commit (every 30s) and
> attempts to reclaim any unused workspace older than 45s.
> 
> Repeating the experiment from v2 [1], the Silesia corpus was copied to a
> btrfs filesystem 10 times and then read back after dropping the caches.
> The btrfs filesystem was on an SSD.
> 
> Level   Ratio   Compression (MB/s)  Decompression (MB/s)
> 1       2.658        438.47                910.51
> 2       2.744        364.86                886.55
> 3       2.801        336.33                828.41
> 4       2.858        286.71                886.55
> 5       2.916        212.77                556.84
> 6       2.363        119.82                990.85
> 7       3.000        154.06                849.30
> 8       3.011        159.54                875.03
> 9       3.025        100.51                940.15
> 10      3.033        118.97                616.26
> 11      3.036         94.19                802.11
> 12      3.037         73.45                931.49
> 13      3.041         55.17                835.26
> 14      3.087         44.70                716.78
> 15      3.126         37.30                878.84
> 
> [1] https://lore.kernel.org/linux-btrfs/20181031181108.289340-1-terrelln@fb.com/
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Cc: Nick Terrell <terrelln@fb.com>
> Cc: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/super.c |   6 +-
>  fs/btrfs/zstd.c  | 229 +++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 226 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b28dff207383..0ecc513cb56c 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -544,9 +544,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  				btrfs_clear_opt(info->mount_opt, NODATASUM);
>  				btrfs_set_fs_incompat(info, COMPRESS_LZO);
>  				no_compress = 0;
> -			} else if (strcmp(args[0].from, "zstd") == 0) {
> +			} else if (strncmp(args[0].from, "zstd", 4) == 0) {
>  				compress_type = "zstd";
>  				info->compress_type = BTRFS_COMPRESS_ZSTD;
> +				info->compress_level =
> +					btrfs_compress_str2level(
> +							 BTRFS_COMPRESS_ZSTD,
> +							 args[0].from + 4);
>  				btrfs_set_opt(info->mount_opt, COMPRESS);
>  				btrfs_clear_opt(info->mount_opt, NODATACOW);
>  				btrfs_clear_opt(info->mount_opt, NODATASUM);
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index a951d4fe77f7..ce9b466c197f 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -6,20 +6,27 @@
>   */
>  
>  #include <linux/bio.h>
> +#include <linux/bitmap.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/sched/mm.h>
>  #include <linux/pagemap.h>
>  #include <linux/refcount.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/zstd.h>
>  #include "compression.h"
> +#include "ctree.h"
>  
>  #define ZSTD_BTRFS_MAX_WINDOWLOG 17
>  #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
>  #define ZSTD_BTRFS_DEFAULT_LEVEL 3
> +#define ZSTD_BTRFS_MAX_LEVEL 15
> +#define ZSTD_BTRFS_RECLAIM_NS (45 * NSEC_PER_SEC)
> +/* 67s to avoid clashing with transaction commit (every 30s) */
> +#define ZSTD_BTRFS_RECLAIM_JIFFIES (67 * HZ)

This is valid provided that transaction commit time is not overriden by
Opt_commit_interval. If it is such a problem to not clash with trans
commit maybe this should be calculated upon mount?

<snip>
