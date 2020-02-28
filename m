Return-Path: <SRS0=r+Ws=4Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46027C3F2CD
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 16:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17C14246A0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 16:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgB1Q0j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 11:26:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:45936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1Q0j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Feb 2020 11:26:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7A10EB33A;
        Fri, 28 Feb 2020 16:26:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 26C74DA79B; Fri, 28 Feb 2020 17:26:17 +0100 (CET)
Date:   Fri, 28 Feb 2020 17:26:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: fix btrfs_calc_reclaim_metadata_size calculation
Message-ID: <20200228162616.GQ2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200221214110.3958008-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221214110.3958008-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 21, 2020 at 04:41:10PM -0500, Josef Bacik wrote:
> I noticed while running my snapshot torture test that we were getting a
> lot of metadata chunks allocated with very little actually used.
> Digging into this we would commit the transaction, still not have enough
> space, and then force a chunk allocation.
> 
> I noticed that we were barely flushing any delalloc at all, despite the
> fact that we had around 13gib of outstanding delalloc reservations.  It
> turns out this is because of our btrfs_calc_reclaim_metadata_size()
> calculation.  It _only_ takes into account the outstanding ticket sizes,
> which isn't the whole story.  In this particular workload we're slowly
> filling up the disk, which means our overcommit space will suddenly
> become a lot less, and our outstanding reservations will be well more
> than what we can handle.  However we are only flushing based on our
> ticket size, which is much less than we need to actually reclaim.
> 
> So fix btrfs_calc_reclaim_metadata_size() to take into account the
> overage in the case that we've gotten less available space suddenly.
> This makes it so we attempt to reclaim a lot more delalloc space, which
> allows us to make our reservations and we no longer are allocating a
> bunch of needless metadata chunks.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.

> ---
>  fs/btrfs/space-info.c | 44 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index f216ab72f5fc..26e1c492b9b5 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -306,25 +306,20 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
>  	return (global->size << 1);
>  }
>  
> -int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
> -			 struct btrfs_space_info *space_info, u64 bytes,
> -			 enum btrfs_reserve_flush_enum flush)
> +static inline u64
> +calc_available_free_space(struct btrfs_fs_info *fs_info,
> +			  struct btrfs_space_info *space_info,
> +			  enum btrfs_reserve_flush_enum flush)

It does not seem to be a candidate for 'static inline', it's not in a
header and the function body is beyond what looks suitable for inlining.
