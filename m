Return-Path: <SRS0=mA8v=TP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEE3C04E53
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 May 2019 11:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBDDE2053B
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 May 2019 11:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfEOLgx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 May 2019 07:36:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:43064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726953AbfEOLgw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 May 2019 07:36:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC707AF21
        for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2019 11:36:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 26423DA866; Wed, 15 May 2019 13:37:52 +0200 (CEST)
Date:   Wed, 15 May 2019 13:37:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: extent-tree: Refactor add_pinned_bytes() to
 add|sub_pinned_bytes()
Message-ID: <20190515113751.GO3138@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190514233348.10696-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514233348.10696-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 15, 2019 at 07:33:48AM +0800, Qu Wenruo wrote:
> Instead of using @sign to determine whether we're adding or subtracting.
> Even it only has 3 callers, it's still (and in fact already caused
> problem in the past) confusing to use.
> 
> Refactor add_pinned_bytes() to add_pinned_bytes() and sub_pinned_bytes()
> to explicitly show what we're doing.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> To David,
> 
> Would you please fold this patch to "btrfs: extent-tree: Fix a bug that
> btrfs is unable to add pinned bytes" in misc-next branch?

Folding a refactoring patch to a fix is not a good practice, I had a
second thought on that and let's have both patches. The fix will go to
5.2-rc and this cleanup will show up in the devel queue once the fix is
merged.

And the cleanup looks good to me, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
