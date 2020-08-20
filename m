Return-Path: <SRS0=L84K=B6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C748FC433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 09:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD1EF207FB
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 09:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgHTJvh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 05:51:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:48406 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgHTJvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Aug 2020 05:51:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7E4C6AD19;
        Thu, 20 Aug 2020 09:51:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B5329DA87C; Thu, 20 Aug 2020 11:50:24 +0200 (CEST)
Date:   Thu, 20 Aug 2020 11:50:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v5 1/4] btrfs: extent_io: do extra check for extent
 buffer read write functions
Message-ID: <20200820095024.GX2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20200819063550.62832-1-wqu@suse.com>
 <20200819063550.62832-2-wqu@suse.com>
 <20200819171159.GT2026@twin.jikos.cz>
 <66f629fa-e636-6ab5-eda8-5299d996b2f4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66f629fa-e636-6ab5-eda8-5299d996b2f4@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:14:13AM +0800, Qu Wenruo wrote:
> >> +static inline int check_eb_range(const struct extent_buffer *eb,
> >> +				 unsigned long start, unsigned long len)
> >> +{
> >> +	/* start, start + len should not go beyond eb->len nor overflow */
> >> +	if (unlikely(start > eb->len || start + len > eb->len ||
> >> +		     len > eb->len)) {
> > 
> > Can the number of condition be reduced? If 'start + len' overflows, then
> > we don't need to check 'start > eb->len', and for the case where
> > start = 1024 and len = -1024 the 'len > eb-len' would be enough.
> 
> I'm afraid not.
> Although 'start > eb->len || len > eb->len' is enough to detect overflow
> case, it no longer detects cases like 'start = 2k, len = 3k' while
> eb->len == 4K case.
> 
> So we still need all 3 checks.

I was suggesting 'start + len > eb->len', not 'start > eb-len'.

"start > eb->len" is implied by "start + len > eb->len".
