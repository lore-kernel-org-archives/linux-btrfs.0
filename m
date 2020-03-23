Return-Path: <SRS0=rDfT=5I=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1367EC4332E
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Mar 2020 19:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E169E2051A
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Mar 2020 19:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgCWTi7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 15:38:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgCWTi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Mar 2020 15:38:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF017ACD0;
        Mon, 23 Mar 2020 19:38:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6619DDA81D; Mon, 23 Mar 2020 20:38:27 +0100 (CET)
Date:   Mon, 23 Mar 2020 20:38:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check/lowmem: Fix a false alert caused by
 hole beyond isize check
Message-ID: <20200323193826.GN12659@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200321010303.124708-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321010303.124708-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 21, 2020 at 09:03:03AM +0800, Qu Wenruo wrote:
> Commit 91a12c0ddb00 ("btrfs-progs: fix lowmem check's handling of
> holes") makes lowmem mode check to skip hole detection after isize.
> 
> However it also skipped the extent end update if the extent ends just at
> isize.
> 
> This caused fsck-test/001 to fail with false hole error report.
> 
> Fix it by updating the @end parameter if we have an extent ends at inode
> size.
> 
> Fixes: 91a12c0ddb00 ("btrfs-progs: fix lowmem check's handling of holes")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> David, please fold the fix into the original patch.

Folded, thanks for the fix. The lowmem mode tests still don't pass for
me, have been failing since 5.1. I've now added a make target for it so
it's easier to run them without setting up the env variables.
