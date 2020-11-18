Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBC0C6369E
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 16:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB6FF24818
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 16:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgKRQ3u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 11:29:50 -0500
Received: from twin.jikos.cz ([91.219.245.39]:35394 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbgKRQ3t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Nov 2020 11:29:49 -0500
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
        by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id 0AIGTi7H020297
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Wed, 18 Nov 2020 17:29:45 +0100
Received: (from dave@localhost)
        by twin.jikos.cz (8.13.6/8.13.6/Submit) id 0AIGTiwc020294;
        Wed, 18 Nov 2020 17:29:44 +0100
Date:   Wed, 18 Nov 2020 17:29:44 +0100
From:   David Sterba <dave@jikos.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 22/24] btrfs: scrub: support subpage data scrub
Message-ID: <20201118162944.GC17322@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20201113125149.140836-1-wqu@suse.com>
 <20201113125149.140836-23-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113125149.140836-23-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 13, 2020 at 08:51:47PM +0800, Qu Wenruo wrote:
> @@ -1781,8 +1781,9 @@ static int scrub_checksum_data(struct scrub_block *sblock)
>  	struct scrub_ctx *sctx = sblock->sctx;
>  	struct btrfs_fs_info *fs_info = sctx->fs_info;
>  	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
> -	u8 csum[BTRFS_CSUM_SIZE];
>  	struct scrub_page *spage;
> +	u32 sectorsize = fs_info->sectorsize;
> +	u8 csum[BTRFS_CSUM_SIZE];
>  	char *kaddr;
>  
>  	BUG_ON(sblock->page_count < 1);
> @@ -1794,11 +1795,15 @@ static int scrub_checksum_data(struct scrub_block *sblock)
>  
>  	shash->tfm = fs_info->csum_shash;
>  	crypto_shash_init(shash);
> -	crypto_shash_digest(shash, kaddr, PAGE_SIZE, csum);
> +
> +	/*
> +	 * In scrub_pages() and scrub_pages_for_parity() we ensure
> +	 * each spage only contains just one sector of data.
> +	 */
> +	crypto_shash_digest(shash, kaddr, sectorsize, csum);

Temporary variable is not needed for single use (sectorsize).
