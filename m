Return-Path: <SRS0=1y2F=3M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BDAC2D0DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Jan 2020 16:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C0D24125
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Jan 2020 16:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgAWQlB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 11:41:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:43482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAWQlB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Jan 2020 11:41:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 903EFAD78;
        Thu, 23 Jan 2020 16:40:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4B8CADA730; Thu, 23 Jan 2020 17:40:43 +0100 (CET)
Date:   Thu, 23 Jan 2020 17:40:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: scrub: Require mandatory block group RO for
 dev-replace
Message-ID: <20200123164043.GE3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20200123073759.23535-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123073759.23535-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 23, 2020 at 03:37:59PM +0800, Qu Wenruo wrote:
> 
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Fixes: 76a8efa171bf ("btrfs: Continue replace when set_block_ro failed")
> Fixes: b12de52896c0 ("btrfs: scrub: Don't check free space before marking a block group RO")

This one is in the 5.5-rc, so I'd like to get it to the final release. I
haven't read the discussion properly so please let me know if the patch
needs another round or fixups I can do. Time for the pull request is in
a day (2 at most as it's too close to the release) but given the type of
fix it's justified. Thanks.
