Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6304C10F12
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9E0C2073F
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbfDQJeW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:34:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:51864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbfDQJeW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 05:34:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0E111AC69;
        Wed, 17 Apr 2019 09:34:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B046ADA871; Wed, 17 Apr 2019 11:35:28 +0200 (CEST)
Date:   Wed, 17 Apr 2019 11:35:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not start a transaction during fiemap
Message-ID: <20190417093528.GD20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190415082900.2023-1-fdmanana@kernel.org>
 <20190417000749.GA16405@hungrycats.org>
 <CAL3q7H6dz3jJ-YpBeMW_HM5t_RD11ezPAscadR1-CwhfccPHeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6dz3jJ-YpBeMW_HM5t_RD11ezPAscadR1-CwhfccPHeQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 17, 2019 at 09:22:44AM +0000, Filipe Manana wrote:
> On Wed, Apr 17, 2019 at 1:08 AM Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> >
> > On Mon, Apr 15, 2019 at 09:29:00AM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > During fiemap, for regular extents (non inline) we need to check if they
> > > are shared and if they are, set the shared bit. Checking if an extent is
> > > shared requires checking the delayed references of the currently running
> > > transaction, since some reference might have not yet hit the extent tree
> > > and be only in the in-memory delayed references.
> > >
> > > However we were using a transaction join for this, which creates a new
> > > transaction when there is no transaction currently running. That means
> > > that two more potential failures can happen: creating the transaction and
> > > committing it. Further, if no write activity is currently happening in the
> > > system, and fiemap calls keep being done, we end up creating and
> > > committing transactions that do nothing.
> >
> > Cool!
> >
> > Any chance we can do this for the LOGICAL_INO ioctl?  Last time I checked
> > (I admit that was a while ago), LOGICAL_INO cost about the same as
> > fsync(), because it creates transactions with btrfs_join_transaction a
> > few levels deep in the call stack, and gets blocked waiting for them
> > to complete.
> 
> So iterate_extent_inodes() should definitly use the attach API and not join for
> the same reasons. And I can fix that separately.
> 
> >
> > It looks like btrfs_ioctl_logical_to_ino can set:
> >
> >         path->search_commit_root = 1;
> >
> > just before calling iterate_inodes_from_logical, but I tried that once,
> > and my test filesystem blew up a few days later, so there might be
> > something subtle that I missed.  Or maybe my test filesystem was going
> > to blow up that day anyway--I just assumed that I don't know what I'm
> > doing, and didn't repeat the test.
> 
> Blew up? That's a very vague term... What do you mean with it? What
> happened exactly?
> 
> Setting search_commit_root should not cause any problems, the only
> thing that can happen is giving you non-accurate results
> because there might be relevant changes in the current transaction and
> therefore they are not visible yet from the commit roots.

If there's need to have both, ie. the accurate and non-accurate version,
the v2 of the ioctl accepts flags so it could be done.
