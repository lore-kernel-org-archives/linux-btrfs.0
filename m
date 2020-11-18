Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAC7C5519F
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 18:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355CB24686
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 18:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgKRSYo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 13:24:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:59066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgKRSYo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Nov 2020 13:24:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9049B1A9;
        Wed, 18 Nov 2020 18:24:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B1352DA6E3; Wed, 18 Nov 2020 16:56:46 +0100 (CET)
Date:   Wed, 18 Nov 2020 16:56:46 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/14] btrfs: extent_io: Use detach_page_private() for
 alloc_extent_buffer()
Message-ID: <20201118155646.GA11899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201118085319.56668-1-wqu@suse.com>
 <20201118085319.56668-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118085319.56668-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 18, 2020 at 04:53:06PM +0800, Qu Wenruo wrote:
> index f305777ee1a3..55115f485d09 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5310,14 +5310,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>  				goto free_eb;
>  			}
>  			exists = NULL;
> +			WARN_ON(PageDirty(p));
>  
>  			/*
>  			 * Do this so attach doesn't complain and we need to
>  			 * drop the ref the old guy had.
>  			 */
> -			ClearPagePrivate(p);
> -			WARN_ON(PageDirty(p));
> -			put_page(p);
> +			detach_page_private(page);

Does this compile? The page is in 'p', not in 'page'. The code is moved
in the next patch but each patch needs to compile.
