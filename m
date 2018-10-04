Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F773C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 11:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB1D206B2
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 11:24:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AB1D206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbeJDSRT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 14:17:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:44060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727183AbeJDSRT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 14:17:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8680AF95;
        Thu,  4 Oct 2018 11:24:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39D7EDA82D; Thu,  4 Oct 2018 13:24:25 +0200 (CEST)
Date:   Thu, 4 Oct 2018 13:24:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/42] btrfs: check if free bgs for commit
Message-ID: <20181004112424.GC29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-8-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928111821.24376-8-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 07:17:46AM -0400, Josef Bacik wrote:
> may_commit_transaction will skip committing the transaction if we don't
> have enough pinned space or if we're trying to find space for a SYSTEM
> chunk.  However if we have pending free block groups in this transaction
> we still want to commit as we may be able to allocate a chunk to make
> our reservation.  So instead of just returning ENOSPC, check if we have
> free block groups pending, and if so commit the transaction to allow us
> to use that free space.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 1213f573eea2..da73b3e5bc39 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4830,10 +4830,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  	if (!bytes)
>  		return 0;
>  
> -	/* See if there is enough pinned space to make this reservation */
> -	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
> -				   bytes,
> -				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
> +	trans = btrfs_join_transaction(fs_info->extent_root);
> +	if (IS_ERR(trans))
> +		return -ENOSPC;

Why do you set override the error to ENOSPC, instead of passing
PTR_ERR(trans)? There are more reasons why btrfs_join_transaction could
fail: EROFS after error, EDQUOT when quotas say no, ENOMEM from
ulist_add, that's just a sample I quickly found.
