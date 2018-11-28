Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB283C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B7552081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 16:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7552081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbeK2DtU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 22:49:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:56558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728798AbeK2DtU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:49:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BFF9EAF7B
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 16:47:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A234DDAC7F; Wed, 28 Nov 2018 17:46:45 +0100 (CET)
Date:   Wed, 28 Nov 2018 17:46:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Refactor btrfs_merge_bio_hook
Message-ID: <20181128164644.GV2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127185758.16220-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127185758.16220-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:57:58PM +0200, Nikolay Borisov wrote:
> This function really checks whether adding more data to the bio will
> straddle a stripe/chunk. So first let's give it a more appropraite
> name - btrfs_bio_fits_in_stripe. Secondly, the offset parameter was
> never used to just remove it. Thirdly, pages are submitted to either
> btree or data inodes so it's guaranteed that tree->ops is set so replace
> the check with an ASSERT. Finally, document the parameters of the
> function. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> -			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE, bio, 0);
> +			submit = btrfs_bio_fits_in_stripe(page, PAGE_SIZE, bio,
> +							  0);

> -			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE,
> -					comp_bio, 0);
> +			submit = btrfs_bio_fits_in_stripe(page, PAGE_SIZE,
> +							  comp_bio, 0);


> -		if (tree->ops && btrfs_merge_bio_hook(page, offset, page_size,
> -						      bio, bio_flags))
> +		ASSERT(tree->ops);
> +		if (btrfs_bio_fits_in_stripe(page, page_size, bio, bio_flags))
>  			can_merge = false;

Got me curious if we could get rid of the size parameter, it's 2x
PAGE_SIZE and could be something else in one case but it's not obvious
if it really happens.

Another thing I noticed is lack of proper error handling in all callers,
as its' 0, 1, and negative errno. The error would be interpreted as true
ie. add page to bio and continue.
