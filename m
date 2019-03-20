Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28990C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 19:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E918D21873
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 19:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfCTTir (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:38:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:56304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbfCTTiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 15:38:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4F66AD88
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 19:38:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 889BFDA993; Wed, 20 Mar 2019 20:40:00 +0100 (CET)
Date:   Wed, 20 Mar 2019 20:39:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v5.3 03/11] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
Message-ID: <20190320193959.GA26179@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320062749.30953-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:27:41PM +0800, Qu Wenruo wrote:
> We have a BUG_ON() in flush_write_bio() to handle the return value of
> submit_one_bio().
> 
> Move the BUG_ON() one level up to all its callers.
> 
> This patch will introduce temporary variable, @flush_ret to keep code
> change minimal in this patch. That variable will be cleaned up when
> enhancing the error handling later.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/extent_io.c | 55 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 41 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index ca8b8e785cf3..58bf6ae29319 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -170,15 +170,28 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
>  	return blk_status_to_errno(ret);
>  }
>  
> -static void flush_write_bio(struct extent_page_data *epd)
> +/*
> + * A wrapper for submit_one_bio().

Such comments are not very useful, changed to "Submit bio from extent
page data via submit_one_bio".

> + *
> + * Return 0 if everything is OK.
> + * Return <0 for error.
> + */
> +static int __must_check flush_write_bio(struct extent_page_data *epd)
>  {
> -	if (epd->bio) {
> -		int ret;
> +	int ret = 0;
>  
> +	if (epd->bio) {
>  		ret = submit_one_bio(epd->bio, 0, 0);
> -		BUG_ON(ret < 0); /* -ENOMEM */
> +		/*
> +		 * Clean up of epd->bio is handled by its endio function.
> +		 * And endio is either triggered by successful bio execution
> +		 * or the error handler of submit bio hook.
> +		 * So at this point, no matter what happened, we don't need
> +		 * to clean up epd->bio.
> +		 */

That one is great.
