Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E53BC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 18:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15E5218AF
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 18:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfAaSO2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 13:14:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:54890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbfAaSO2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:14:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A65B4ACA8;
        Thu, 31 Jan 2019 18:14:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0C88DDA7D6; Thu, 31 Jan 2019 19:13:51 +0100 (CET)
Date:   Thu, 31 Jan 2019 19:13:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH 11/11] btrfs: add zstd compression level support
Message-ID: <20190131181351.GN2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-12-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-12-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:37PM -0500, Dennis Zhou wrote:
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

> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
>  #define ZSTD_BTRFS_MAX_WINDOWLOG 17
>  #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
>  #define ZSTD_BTRFS_DEFAULT_LEVEL 3
> +#define ZSTD_BTRFS_MAX_LEVEL 15
> +#define ZSTD_BTRFS_RECLAIM_NS (45 * NSEC_PER_SEC)
> +/* 67s to avoid clashing with transaction commit (every 30s) */
> +#define ZSTD_BTRFS_RECLAIM_JIFFIES (67 * HZ)

I think you can copy the relevant part of changelog here to explain the
logic of the levels and reclaim as it's scattered over several
functions. The description would give a nice overview in one place.
