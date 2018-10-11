Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2650C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954AB2077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 954AB2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbeJKTqQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:46:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:47170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbeJKTqQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:46:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A91AFAD77
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:19:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B741FDA737; Thu, 11 Oct 2018 14:19:13 +0200 (CEST)
Date:   Thu, 11 Oct 2018 14:19:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Validate btrfs_super_block::log_root_transid
Message-ID: <20181011121913.GO29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-3-wqu@suse.com>
 <29849d48-501f-fd2c-3225-eba07fc0915e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29849d48-501f-fd2c-3225-eba07fc0915e@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 09:57:22AM +0300, Nikolay Borisov wrote:
> > +	/*
> > +	 * Check log root transid against super block generation.
> > +	 *
> > +	 * Older kernel doesn't populate log_root_transid, only need to check
> > +	 * it when it's not zero.
> > +	 * Since replaying suspicious log tree can cause serious problem, refuse
> > +	 * to mount if it doesn't match.
> > +	 */
> > +	if (btrfs_super_log_root_transid(sb) &&
> > +	    btrfs_super_log_root_transid(sb) != generation + 1) {
> 
> nit: in the same vein as you do for btrfs_super_generation just assign
> super_log_root_Transid to a local var and use that. IMO it's more
> consistent with what's happening in this function.

While I see your point I think the way Qu did it is also fine, there's
not much duplication and I find it readable.
