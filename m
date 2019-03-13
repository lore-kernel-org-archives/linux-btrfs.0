Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B58C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 11:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C77D2147C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 11:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfCMLag (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:30:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:38494 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbfCMLag (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 07:30:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7500BACEA
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 11:30:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2DA54DA9C4; Wed, 13 Mar 2019 12:31:50 +0100 (CET)
Date:   Wed, 13 Mar 2019 12:31:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v5.1 10/12] btrfs: extent_io: Kill the BUG_ON() in
 extent_write_cache_pages()
Message-ID: <20190313113149.GB31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-11-wqu@suse.com>
 <20190312003330.GY31119@twin.jikos.cz>
 <c327b20b-eb97-d1bf-6763-cf4df795f9f0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c327b20b-eb97-d1bf-6763-cf4df795f9f0@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 12, 2019 at 08:42:12AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/3/12 上午8:33, David Sterba wrote:
> > On Mon, Feb 18, 2019 at 01:27:51PM +0800, Qu Wenruo wrote:
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> >> ---
> >>  fs/btrfs/extent_io.c | 10 ++++++++--
> >>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> >> index 1572e892ec7b..480e138051f0 100644
> >> --- a/fs/btrfs/extent_io.c
> >> +++ b/fs/btrfs/extent_io.c
> >> @@ -3998,7 +3998,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
> >>  			 */
> >>  			if (!trylock_page(page)) {
> >>  				ret = flush_write_bio(epd);
> >> -				BUG_ON(ret < 0);
> >> +				if (ret < 0) {
> > 
> > This needs some more explanation why it's correct, there's conditional
> > locking and writeback status manipulation. Thanks.
> 
> Because flush_write_bio() handles the cleanup in its endio function.
> 
> Thus we don't need extra cleanup in this case.

Non-trivial changes need changelog, that's nothing new. Especially for
error handling you have to provide a proof that things don't get broken.

If you spend a week working on the code, everything is trivial, but only
for you and for a short period of time. That's why we need good
changelogs that make sense to other people and after a long period of
time. Thanks.
