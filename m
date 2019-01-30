Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CF6C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 15:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4780120989
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 15:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbfA3PTu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 10:19:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:43932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727765AbfA3PTt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 10:19:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A51D8B01C
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 15:19:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B044BDA78C; Wed, 30 Jan 2019 16:19:14 +0100 (CET)
Date:   Wed, 30 Jan 2019 16:19:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
Message-ID: <20190130151914.GU2900@twin.jikos.cz>
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

I'm not sure if resetting epd->bio to NULL is all that needs to be done
here. With the BUG_ON the error case never happens so if all goes fine
it's also ok to set it to NULL and continue. But the callers might need
to send the flush again.

It's not easy to trace the bio here, it's set indirectly in
submit_extent_page, submit_one_bio is another indirection, switching by
type and sometimes bio_endio is called in case of an error.
