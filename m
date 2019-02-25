Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD5AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE8FB213A2
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfBYMDv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:03:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:44996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbfBYMDv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:03:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF9BFAFCF
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 12:03:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 88D96DAA70; Mon, 25 Feb 2019 13:05:11 +0100 (CET)
Date:   Mon, 25 Feb 2019 13:05:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH v3] btrfs: factor our read/write stage off
 csum_tree_block() into its callers
Message-ID: <20190225120511.GM9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>
References: <20190219124353.22948-1-jthumshirn@suse.de>
 <20190222145508.GE9874@twin.jikos.cz>
 <7e2a667b-819b-7594-9b94-65f6ef710434@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e2a667b-819b-7594-9b94-65f6ef710434@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 12:17:36PM +0100, Johannes Thumshirn wrote:
> On 22/02/2019 15:55, David Sterba wrote:
> >>  
> >> -	return csum_tree_block(fs_info, eb, 0);
> >> +	if (WARN_ON(csum_tree_block(eb, result)))
> > 
> > I think the warn should go to csum_tree_block when the mapping function
> > returns 1, there's even a comment explaining why it can't normally
> > happen. The reason for the warning in csum_dirty_buffer is not very
> > clear from the context.
> > 
> > Otherwise ok, the verify or write semantics of a function that (by name)
> > only calculates checksum is confusing. Thanks.
> 
> Sure. Would it make sense to split this into two patches?

Yeah, makes sense. One to move the verify part and another to add the
WARN_ON. Thanks.
