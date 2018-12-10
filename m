Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24ED5C5CFFE
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECD802081F
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECD802081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbeLJR7K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:59:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:33952 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726959AbeLJR7K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 12:59:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8AA6DAEED;
        Mon, 10 Dec 2018 17:59:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9DB34DAB58; Mon, 10 Dec 2018 18:58:47 +0100 (CET)
Date:   Mon, 10 Dec 2018 18:58:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: scrub, move setup of nofs contexts higher in the
 stack
Message-ID: <20181210175847.GL23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181207132332.31774-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181207132332.31774-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 07, 2018 at 01:23:32PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Since scrub workers only do memory allocation with GFP_KERNEL when they
> need to perform repair, we can move the recent setup of the nofs context
> up to scrub_handle_errored_block() instead of setting it up down the call
> chain at insert_full_stripe_lock() and scrub_add_page_to_wr_bio(),
> removing some duplicate code and comment. So the only paths for which a
> scrub worker can do memory allocations using GFP_KERNEL are the following:
> 
>  scrub_bio_end_io_worker()
>    scrub_block_complete()
>      scrub_handle_errored_block()
>        lock_full_stripe()
>          insert_full_stripe_lock()
>            -> kmalloc with GFP_KERNEL
> 
>   scrub_bio_end_io_worker()
>     scrub_block_complete()
>       scrub_handle_errored_block()
>         scrub_write_page_to_dev_replace()
>           scrub_add_page_to_wr_bio()
>             -> kzalloc with GFP_KERNEL
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>

> @@ -867,6 +860,16 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)

> +	nofs_flag = memalloc_nofs_save();

>  	ret = lock_full_stripe(fs_info, logical, &full_stripe_locked);

>  	ret = unlock_full_stripe(fs_info, logical, full_stripe_locked);
> +	memalloc_nofs_restore(nofs_flag);

Though I don't see a technical reason for placing the restore after
unlock_full_stripe (no GFP_KERNEL allocations there and not in the
preceding block that does only kfree) it looks better to keep the proper
nesting of memalloc save/lock/unlock/memalloc restore. So agreed, just
that it's a new pattern I think it's good to spell it out.
