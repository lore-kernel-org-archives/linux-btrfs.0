Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91B8C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 15:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B694120989
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 15:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbfA3PJ2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 10:09:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:41698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731513AbfA3PJ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 10:09:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B3AAB0C6
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 15:09:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 529F9DA78C; Wed, 30 Jan 2019 16:08:51 +0100 (CET)
Date:   Wed, 30 Jan 2019 16:08:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
Message-ID: <20190130150851.GT2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125050925.30754-5-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 25, 2019 at 01:09:17PM +0800, Qu Wenruo wrote:
> We have a BUG_ON() in flush_write_bio() to handle the return value of
> submit_one_bio().
> 
> Move the BUG_ON() one level up to all its callers.
> 
> No functional change, just to make later BUG_ON() cleanup more obvious.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent_io.c | 48 +++++++++++++++++++++++++++++++-------------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8a2335713a2d..6f1982f8ad5c 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -169,15 +169,21 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
>  	return blk_status_to_errno(ret);
>  }
>  
> -static void flush_write_bio(struct extent_page_data *epd)
> +/*
> + * A wrapper for submit_one_bio().
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
>  		epd->bio = NULL;
>  	}
> +	return ret;

Moving the BUG_ON one leve up is ok. I checked the callees of
submit_one_bio and it looks like the return value of btrfsic_submit_bio
is somehow missing. It should at least propagate return value of
submit_bio. This is is for another patchset though.
