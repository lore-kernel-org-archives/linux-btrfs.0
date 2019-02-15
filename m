Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66F7C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 15:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 908AE20838
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 15:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbfBOPSz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 10:18:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:50186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727536AbfBOPSz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 10:18:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F793AD93;
        Fri, 15 Feb 2019 15:18:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1617ADA87D; Fri, 15 Feb 2019 16:20:18 +0100 (CET)
Date:   Fri, 15 Feb 2019 16:20:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Liu Bo <obuil.liubo@gmail.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
Message-ID: <20190215152018.GD9874@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Liu Bo <obuil.liubo@gmail.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190213142602.20436-1-jthumshirn@suse.de>
 <cbc103a1-3558-fac1-a45b-dcaf5d4d72ea@mendix.com>
 <01219372-4533-fb72-44fd-b2882c0614f6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01219372-4533-fb72-44fd-b2882c0614f6@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 14, 2019 at 05:21:54PM +0100, Johannes Thumshirn wrote:
> On 13/02/2019 15:32, Hans van Kranenburg wrote:
> [...]
> 
> >> +++ b/fs/btrfs/volumes.c
> >> @@ -6794,7 +6794,7 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
> >>  	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
> >>  	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
> >>  	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
> >> -	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
> >> +	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
> >>  	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
> >>  	     num_stripes != 1)) {
> >>  		btrfs_err(fs_info,
> >>
> > 
> > It looks like the RAID1 check has a similar problem. Shouldn't that
> > check also be != 2 ?
> 
> So looking at the code again I think num_stripes == 1 for RAID1 will
> result in the same division by 0 in calc_stripe_length().
> 
> I'll send a patch for RAID1 as well unless David speaks up and says he
> wants it amended in this one.

If the explanation and cause is the same, it's ok to put it into one
patch I think, but no strong preference here.
