Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52750C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A38920651
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfDCO7t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:59:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726384AbfDCO7t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:59:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 930ABAC5A
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 14:59:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 51D7BDA8D8; Wed,  3 Apr 2019 17:00:57 +0200 (CEST)
Date:   Wed, 3 Apr 2019 17:00:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: tree-checker: Remove comprehensive root owner
 check
Message-ID: <20190403150057.GQ29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190403115919.17049-1-wqu@suse.com>
 <20190403115919.17049-2-wqu@suse.com>
 <20190403142142.GO29086@twin.jikos.cz>
 <3dc771f7-156b-0909-dd78-f6da539c1972@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3dc771f7-156b-0909-dd78-f6da539c1972@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 03, 2019 at 10:26:05PM +0800, Qu Wenruo wrote:
> On 2019/4/3 下午10:21, David Sterba wrote:
> > On Wed, Apr 03, 2019 at 07:59:19PM +0800, Qu Wenruo wrote:
> >> Commit 1ba98d086fe3 ("Btrfs: detect corruption when non-root leaf has
> >> zero item") introduced comprehensive root owner checker.
> > 
> > That's 4.7, so we might want to do stable backport to 4.9+.
> 
> It's just a performance optimization.
> 
> I'm not sure if we should backport such things even if we can solve the
> conflicts.

That's for the consideration, if the performance improvement is
significant, but due to other changes in the codebases it might not be
safe.

> >> However it's pretty expensive tree search to locate the owner root,
> >> especially when it get reused by mandatory read and write time
> >> tree-checker.
> >>
> >> This patch will remove that check, and completely rely on owner based
> >> empty leaf check, which is much faster and still works fine for most
> >> case.
> >>
> >> And since we skip the old root owner check, now write time tree check
> >> can be merged with btrfs_check_leaf_full().
> > 
> > And for that reason the change should be minimal, this patch depends on
> > current development queue so it's not suitable for the backport.
> > 
> > I'm thinking what to do here, I want to avoid patches that effectively
> > revert changes that are still in the development branch and haven't been
> > released.
> 
> OK, I'll resend write time tree checker patchset.

Wait, it's just one patch that needs update, "btrfs: Do mandatory tree
block check before submitting bio".

If the above patch is dropped, then the expensive checks in check_leaf
can be removed as you do in this patch, without the updates to
parameters.

> > This means to rework "btrfs: Do mandatory tree block check before
> > submitting bio", though it's deep in the branch, the scope of changes is
> > only 2 files so this should not cause any conflicts.
> 
> BTW, I'm a little interesting in the workflow on your side.
> 
> In this case, what's the correct way to handle them?
> Just remove those two related patches from misc-next branch and re-apply
> the newer version?

If you mean these two

  btrfs: disk-io: Show the timing of corrupted tree block explicitly
  btrfs: Do mandatory tree block check before submitting bio

we don't need to remove both, just the second one.

> Or remove all those write time tree checker and later enhancement
> patches and reapply them all?

No, why removing them? That's independent enhancement of the tree
checker. What needs to be removed is the call at write time.

> Either way, I hope to experience the same workflow so I could reduce
> your workload.

This is an infrequent case when a patch deep in the branch needs update
so the solution depends on the impact on the patches above it. Here it's
only minor conflict with a cleanup patch removing redundant fs_info from
check_leaf.

So that's trivial and we don't need to update the patches in place.
Further updates can be applied on top of misc-next (with the patch
removed).

The ideal workflow is:

1) patches are developed, tested by the developer
2) posted to mailinglist
3) after review added to a topic branch in for-next for wider testing
   - patchset revisions are easy to update as it's in a topic branch
4) after some time the patches get merged to misc-next and no updates are
   expected, beyond minor updates like coding style or changelog
5) patch goes to release branch and is effectively frozen, all fixes go
   as separate patches

So if you want to reduce my workload, spend more time on 1-3 so we
don't have to be creative when fixing problems we discover at 4-5.

I know this cannot be followed 100% times, but so far we've been able to
resolve all the situations and the number of times is overall low. So
it's bearable.
