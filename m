Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9A9C10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 16:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4022075B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 16:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfDKQ62 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 12:58:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:44658 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfDKQ62 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 12:58:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99FEFACBD;
        Thu, 11 Apr 2019 16:58:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A2649DA85B; Thu, 11 Apr 2019 18:59:35 +0200 (CEST)
Date:   Thu, 11 Apr 2019 18:59:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: simplify read_extent_buffer_pages a bit
Message-ID: <20190411165935.GA3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190411164059.4981-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411164059.4981-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 11, 2019 at 06:40:59PM +0200, Johannes Thumshirn wrote:
> Currently read_extent_buffer_pages() uses a 4 pass algorithm to read an
> extent buffer's pages from disk, all 4 stages looping over all pages of
> the extent buffer.
> 
> 1) Loop over all pages and lock them.
> 2) Loop over all pages and see if one is not marked as PageUptodate, so we
>    can break out of the function early.
> 3) Loop over all pages and if the page is !PageUptodate read the page,
>    otherwise unlock the page.
> 4) Loop over all pages and wait for stable pages.
> 
> Unify the 1st two for loops, we can count the number of uptodate pages
> after we have locked them without the need for re-starting the loop.

Effectively reverting 2571e739677f1e4c0c63f5ed49adcc0857923625 that
fixed a bug. Please have a look if something has really changed so that
the split loops are no longer necessary.
