Return-Path: <SRS0=vkwB=B5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC49C433E3
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 11:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1C120772
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 11:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgHSLau (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 07:30:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:53176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgHSLas (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Aug 2020 07:30:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6AB67B7EF;
        Wed, 19 Aug 2020 11:31:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9B0F6DA703; Wed, 19 Aug 2020 13:29:41 +0200 (CEST)
Date:   Wed, 19 Aug 2020 13:29:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: detect nocow for swap after snapshot delete
Message-ID: <20200819112941.GK2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20200818180005.933061-1-boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818180005.933061-1-boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 18, 2020 at 11:00:05AM -0700, Boris Burkov wrote:
> can_nocow_extent and btrfs_cross_ref_exist both rely on a heuristic for
> detecting a must cow condition which is not exactly accurate, but saves
> unnecessary tree traversal. The incorrect assumption is that if the
> extent was created in a generation smaller than the last snapshot
> generation, it must be referenced by that snapshot. That is true, except
> the snapshot could have since been deleted, without affecting the last
> snapshot generation.
> 
> The original patch claimed a performance win from this check, but it
> also leads to a bug where you are unable to use a swapfile if you ever
> snapshotted the subvolume it's in.

Do you mean snapshotted and deleted? As I understand it:

- create fs
- create swapfile in a subvolume
- activate, use, deactivate it
- create snapshot, maybe changing the swapfile
- delete the snapshot, wait until it's gone
- swapfile activation fails, although there are no shared extents and
  the state is effectively the same as if it were created from scratch

> Make the check slower and more strict
> for the swapon case, without modifying the general cow checks as a
> compromise. Turning swap on does not seem to be a particularly
> performance sensitive operation, so incurring a possibly unnecessary
> btrfs_search_slot seems worthwhile for the added usability.

Yeah slowdown should be acceptable here, it's a one time action going
over some metadata.

> Note: Until the snapshot delete transaction is committed,
> check_committed_refs will still cause the logic to think that cow is
> necessary, so the user must sync before swapon.

How often could the snapshot deletion and swapfile activation happen at
the same time? Snapshotting subvolume with the swapfile requires
deactivation, snapshot/send/whatever and then activation. This sounds
like a realistic usecase.
