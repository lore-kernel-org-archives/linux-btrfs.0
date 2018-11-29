Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDA9C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 19:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B8FB20868
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 19:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B8FB20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbeK3Gkh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 01:40:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:37560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbeK3Gkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 01:40:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4049CACC6
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 19:34:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 37C53DA6F5; Thu, 29 Nov 2018 20:33:46 +0100 (CET)
Date:   Thu, 29 Nov 2018 20:33:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Refactor btrfs_merge_bio_hook
Message-ID: <20181129193345.GC2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127185758.16220-1-nborisov@suse.com>
 <20181128164644.GV2842@twin.jikos.cz>
 <6f807f3e-1d9b-b349-02e5-48e8514d3016@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f807f3e-1d9b-b349-02e5-48e8514d3016@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 06:51:59PM +0200, Nikolay Borisov wrote:
> > Got me curious if we could get rid of the size parameter, it's 2x
> > PAGE_SIZE and could be something else in one case but it's not obvious
> > if it really happens.
> > 
> > Another thing I noticed is lack of proper error handling in all callers,
> > as its' 0, 1, and negative errno. The error would be interpreted as true
> > ie. add page to bio and continue.
> 
> Actually anything other than 0 is returned then the current bio is
> actually submitted (I presume you refer to the code in compression.c).
> As a matter of fact I think btrfs_bio_fits_in_stripe could even be
> turned to return a bool value.
> 
> THe only time this function could return an error is if the mapping
> logic goes haywire which could happen 'if (offset < stripe_offset) {' or
> we don't find a chunk for the given offset, which is unlikely.

Unlikely yes, but if it's possible to trigger the mapping failure eg. by
a crafted image, it should be handled. Besides the mapping errors, there
are EIO or ENOMEM in __btrfs_map_block or its callees. I see all other
callers of map block handle the errors.
