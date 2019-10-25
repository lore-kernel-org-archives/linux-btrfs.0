Return-Path: <SRS0=FriU=YS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D480CA9EBD
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EEAA21E6F
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633209AbfJYQ6n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:58:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:50182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2633165AbfJYQ6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Oct 2019 12:58:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A665B4F4;
        Fri, 25 Oct 2019 16:58:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F3AA2DA785; Fri, 25 Oct 2019 18:58:52 +0200 (CEST)
Date:   Fri, 25 Oct 2019 18:58:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 2/2] btrfs: extent-tree: Ensure we trim ranges across
 block group boundary
Message-ID: <20191025165852.GS3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20191025085956.48352-1-wqu@suse.com>
 <20191025085956.48352-3-wqu@suse.com>
 <20191025122353.uh63eb7ub77dyhyp@MacBook-Pro-91.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025122353.uh63eb7ub77dyhyp@MacBook-Pro-91.local>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 25, 2019 at 08:23:54AM -0400, Josef Bacik wrote:
> > @@ -1341,10 +1351,19 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
> >  						  stripe->physical,
> >  						  stripe->length,
> >  						  &bytes);
> > -			if (!ret)
> > +			if (!ret) {
> >  				discarded_bytes += bytes;
> > -			else if (ret != -EOPNOTSUPP)
> > -				break; /* Logic errors or -ENOMEM, or -EIO but I don't know how that could happen JDM */
> > +			} else if (ret != -EOPNOTSUPP) {
> > +				/*
> > +				 * Logic errors or -ENOMEM, or -EIO but I don't
> > +				 * know how that could happen JDM
> > +				 *
> > +				 * Ans since there are two loops, explicitly
> 
> Hate for there to be a v5 at this point, but it should be "and".

Fixed and the first sentence of the comment needed to be updated anyway.
