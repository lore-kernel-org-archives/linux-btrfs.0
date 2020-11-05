Return-Path: <SRS0=jnhB=EL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AC2C4742C
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 13:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15422151B
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 13:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgKENZQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 08:25:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:41310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730525AbgKENX7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Nov 2020 08:23:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AED24AC0C;
        Thu,  5 Nov 2020 13:23:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B234ADA6E3; Thu,  5 Nov 2020 14:22:18 +0100 (CET)
Date:   Thu, 5 Nov 2020 14:22:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH 4/8] btrfs: cleanup btrfs_discard_update_discardable usage
Message-ID: <20201105132218.GI6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
References: <cover.1603460665.git.josef@toxicpanda.com>
 <afb3c72b04191707f96001bc3698e14b4d3400a8.1603460665.git.josef@toxicpanda.com>
 <CAL3q7H5ddLEFbisuFmauK9=XX+sEPy-O4R7X1kp67YH4N1hfcw@mail.gmail.com>
 <fd63e33b-49ea-2150-eaef-e3fd19e5372a@toxicpanda.com>
 <CAL3q7H6hWx=VZDNZQjxzwEDw0-3TMUPtft5y3Mc-NSU4VBj2dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6hWx=VZDNZQjxzwEDw0-3TMUPtft5y3Mc-NSU4VBj2dw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 04, 2020 at 06:28:13PM +0000, Filipe Manana wrote:
> On Wed, Nov 4, 2020 at 6:21 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > On 11/4/20 10:54 AM, Filipe Manana wrote:
> > > On Fri, Oct 23, 2020 at 5:12 PM Josef Bacik <josef@toxicpanda.com> wrote:
> > >>
> > >> This passes in the block_group and the free_space_ctl, but we can get
> > >> this from the block group itself.  Part of this is because we call it
> > >> from __load_free_space_cache, which can be called for the inode cache as
> > >> well.  Move that call into the block group specific load section, wrap
> > >> it in the right lock that we need, and fix up the arguments to only take
> > >> the block group.  Add a lockdep_assert as well for good measure to make
> > >> sure we don't mess up the locking again.
> > >
> > > So this is actually 2 different things in one patch:
> > >
> > > 1) A cleanup to remove an unnecessary argument to
> > > btrfs_discard_update_discardable();
> > >
> > > 2) A bug because btrfs_discard_update_discardable() is not being
> > > called with the lock ->tree_lock held in one specific context.
> >
> > Yeah but the specific context is on load, so we won't have concurrent modifiers
> > to the tree until _after_ the cache is successfully loaded.  Of course this
> > patchset changes that so it's important now, but prior to this we didn't
> > necessarily need the lock, so it's not really a bug fix, just an adjustment.
> >
> > However I'm always happy to inflate my patch counts, makes me look good at
> > performance review time ;).  I'm happy to respin with it broken out.  Thanks,
> 
> Then make it 3! One more just to add the assertion!
> 
> I'm fine with it as it is, maybe just add an explicit note that we
> can't have concurrent access in the load case, so it's not fixing any
> bug, but just prevention.

Changelog updated to reflect that:

This passes in the block_group and the free_space_ctl, but we can get
this from the block group itself.  Part of this is because we call it
from __load_free_space_cache, which can be called for the inode cache as
well.

Move that call into the block group specific load section, wrap it in
the right lock that we need for the assertion (but otherwise this is
safe without the lock because this happens in single-thread context).

Fix up the arguments to only take the block group.  Add a lockdep_assert
as well for good measure to make sure we don't mess up the locking
again.
