Return-Path: <SRS0=jnhB=EL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6140FC388F7
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 21:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B7520728
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 21:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732399AbgKEVeN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 16:34:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:47796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732046AbgKEVeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Nov 2020 16:34:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1B24EAC1D;
        Thu,  5 Nov 2020 21:34:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0A3DCDA6E3; Thu,  5 Nov 2020 22:32:32 +0100 (CET)
Date:   Thu, 5 Nov 2020 22:32:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: wait on v1 cache for log replay
Message-ID: <20201105213232.GM6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <01bacd1faab24648e9701e34318f7bfd6a1f098b.1604608527.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01bacd1faab24648e9701e34318f7bfd6a1f098b.1604608527.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 05, 2020 at 03:36:26PM -0500, Josef Bacik wrote:
> Filipe reported btrfs/159 and btrfs/201 failures with the latest
> misc-next, and bisected it to my change to always async the loading of
> the v1 cache.  This is because when replaying the log we expect that the
> free space cache will be read entirely before we start excluding space
> to replay.  However this obviously changed, and thus we ended up
> overwriting things that were allocated during replay.  Fix this by
> exporting the helper to wait on v1 space cache and use it for this
> exclusion step.  I've audited everywhere else and we are OK with all
> other callers.  Anywhere that also required reading the space cache in
> its entirety used btrfs_cache_block_group() with load_cache_only set,
> which waits for the cache to be loaded.  We do not use that here because
> we want to start caching the block group even if we aren't using the
> free space inode.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> Dave, this can be folded into 
> 
> 	btrfs: async load free space cache
> 
> and it'll be good to go.  I validated it fixed the report, just provided the
> changelog to explain what happened.

Folded to the patch, thanks. I've updated the change with the gist of
the changelog regarding log replay.
