Return-Path: <SRS0=bXJ1=23=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BB8C33C8C
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jan 2020 13:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54AF72072E
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jan 2020 13:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgAFNou (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 08:44:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:56230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgAFNou (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Jan 2020 08:44:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 651A7B1F6;
        Mon,  6 Jan 2020 13:44:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4D531DA78B; Mon,  6 Jan 2020 14:44:33 +0100 (CET)
Date:   Mon, 6 Jan 2020 14:44:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/12] btrfs: add correction to handle -1 edge case in
 async discard
Message-ID: <20200106134433.GD3929@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <cover.1577999991.git.dennis@kernel.org>
 <f00ffdb40462c1dd9b611ee06cf19b2d495e398b.1577999991.git.dennis@kernel.org>
 <d4597613-c6e7-4ae3-e6bc-889d74c5db78@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4597613-c6e7-4ae3-e6bc-889d74c5db78@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jan 05, 2020 at 10:35:56PM +0200, Nikolay Borisov wrote:
> > +	/*
> > +	 * The following is to fix a potential -1 discrepenancy that I'm not
> > +	 * sure how to reproduce.  But given that this is the only place that
> > +	 * utilizes these numbers and this is only called by from
> > +	 * btrfs_finish_extent_commit() which is synchronized, we can correct
> > +	 * here.
> > +	 */
> > +	if (discardable_extents < 0)
> > +		atomic_add(-discardable_extents,
> > +			   &discard_ctl->discardable_extents);
> > +
> > +	if (discardable_bytes < 0)
> > +		atomic64_add(-discardable_bytes,
> > +			     &discard_ctl->discardable_bytes);
> > +
> > +	if (discardable_extents <= 0) {
> > +		spin_unlock(&discard_ctl->lock);
> > +		return;
> > +	}
> 
> Perhaps a WARN_ON for each of those conditions? AFAIU this is papering
> over a real issue which is still not fully diagnosed, no? In this case
> if someone hits it in the wild they could come back with some stack traces?

I don't think the stacktrace itself would help us, the call chain will
be always the same. We need a reproducer for it and random user reports
would likely not help either, besides that the issue happens. Some sort
of developer-only warning would be desirable though.
