Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF955C43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2B6E20674
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfLQRtg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:49:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:46790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfLQRtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 12:49:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 428D0ADDF;
        Tue, 17 Dec 2019 17:49:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8F695DA791; Tue, 17 Dec 2019 18:49:32 +0100 (CET)
Date:   Tue, 17 Dec 2019 18:49:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use helper to zero end of last page
Message-ID: <20191217174932.GI3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20191216185038.14913-1-dsterba@suse.com>
 <4ca3c941-c3c0-2128-e206-01a9eb96953e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ca3c941-c3c0-2128-e206-01a9eb96953e@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 17, 2019 at 05:31:14PM +0800, Anand Jain wrote:
> > -		if (page->index == end_index) {
> > -			char *userpage;
> > -			size_t zero_offset = offset_in_page(isize);
> > -
> > -			if (zero_offset) {
> > -				int zeros;
> > -				zeros = PAGE_SIZE - zero_offset;
> > -				userpage = kmap_atomic(page);
> > -				memset(userpage + zero_offset, 0, zeros);
> > -				flush_dcache_page(page);
> > -				kunmap_atomic(userpage);
> > -			}
> > -		}
> > +		if (page->index == end_index)
> > +			zero_user_segment(page, offset_in_page(isize), PAGE_SIZE);
> 
>   Before we zero-ed only when the page offset is not starting at 0.
>   Can you confirm and update the change log if that is ok.

If the page offset is 0 then this would mean the whole page will be
zeroed, but we can have entire page within i_size so that would
mistakenly clear the last page. So the check is still needed.

While reading the code around the index calculations for the last page I
also found some oddities and potential bugs so I'll drop this patch for
now so I can look at the bugs first.
