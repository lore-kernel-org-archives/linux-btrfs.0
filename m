Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E8FC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 14:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858F12086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 14:41:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 858F12086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbeLLOlU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 09:41:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:58104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbeLLOlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 09:41:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78FDCAFB6
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 14:41:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 07ACBDA7E5; Wed, 12 Dec 2018 15:40:54 +0100 (CET)
Date:   Wed, 12 Dec 2018 15:40:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Refactor main loop in extent_readpages
Message-ID: <20181212144052.GX23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181129164131.4716-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129164131.4716-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 29, 2018 at 06:41:31PM +0200, Nikolay Borisov wrote:
> extent_readpages processes all pages in the readlist in batches of 16,
> this is implemented by a single for loop but thanks to an if condition
> the loop does 2 things based on whether we've filled the batch or not.
> Additionally due to the structure of the code there is an additional
> check which deals with partial batches.
> 
> Streamline all of this by explicitly using two loops. The outter one is
> used to process all pages while the inner one just fills in the batch
> of 16 (currently). Due to this new structure the code guarantees that
> all pages are processed in the loop hence the code to deal with any
> leftovers is eliminated.
> 
> This also enable the compiler to inline __extent_readpages:
> 
> 	./scripts/bloat-o-meter fs/btrfs/extent_io.o extent_io.for
> 
> 	add/remove: 0/1 grow/shrink: 1/0 up/down: 660/-820 (-160)
> 	Function                                     old     new   delta
> 	extent_readpages                             476    1136    +660
> 	__extent_readpages                           820       -    -820
> 	Total: Before=44315, After=44155, chg -0.36%
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent_io.c | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8332c5f4b1c3..233f835dd6f8 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4093,43 +4093,38 @@ int extent_writepages(struct address_space *mapping,
>  int extent_readpages(struct address_space *mapping, struct list_head *pages,
>  		     unsigned nr_pages)

nr_pages becomes unused now. I've checked the MM code that calls here
and it's guaranteed that the number of list 'pages' members is same as
nr_pages.

>  {
> +#define BTRFS_PAGES_BATCH 16
> +
>  	struct bio *bio = NULL;
> -	unsigned page_idx;
>  	unsigned long bio_flags = 0;
> -	struct page *pagepool[16];
> -	struct page *page;
> +	struct page *pagepool[BTRFS_PAGES_BATCH];

I don't think we need the extra define, if

	struct page *pagepool[16];

	...

	for (nr = 0; nr < ARRAY_SIZE(pagepool) ...

Otherwise ok, nice cleanup.

Reviewed-by: David Sterba <dsterba@suse.com>
