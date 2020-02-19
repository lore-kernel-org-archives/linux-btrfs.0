Return-Path: <SRS0=PNgT=4H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E61C34050
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FAAC24654
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgBSObe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 09:31:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:46946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbgBSObe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Feb 2020 09:31:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 43646ACCA;
        Wed, 19 Feb 2020 14:31:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A222EDA70E; Wed, 19 Feb 2020 15:31:14 +0100 (CET)
Date:   Wed, 19 Feb 2020 15:31:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Marc MERLIN <marc@merlins.org>
Cc:     Martin Steigerwald <martin@lichtvoll.de>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: do not zero f_bavail if we have available space
Message-ID: <20200219143114.GY2902@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Marc MERLIN <marc@merlins.org>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20200131143105.52092-1-josef@toxicpanda.com>
 <20200202175247.GB3929@twin.jikos.cz>
 <CAKhhfD7S=kcKLRURdNFZ8H4beS8=XjFvnOQXche7+SVOGFGC_w@mail.gmail.com>
 <2776783.E9KYCc1pZO@merkaba>
 <20200219134327.GD30993@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219134327.GD30993@merlins.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:27AM -0800, Marc MERLIN wrote:
> On Wed, Feb 19, 2020 at 10:17:24AM +0100, Martin Steigerwald wrote:
> > Marc MERLIN - 19.02.20, 01:42:57 CET:
> > > Has the patch gotten to any 5.5 release too?
> > 
> > Yes, as git log easily reveals.
> 
> Sorry if I suck, but right now I only have pre-made kernel releases from
> kernel.org.
> This bug in 5.4 messed up some of my dm-thin volumes which now took 28% of a dm-thin
> 14TB pool when the actual data is only using 4GB :( (at the same time it
> also shows my FS is full when of course it's not).
> 
> I'll likely have to destroy the dm-thin to recover that space (or maybe
> not, we'll see), but I'm travelling and don't really have countless time
> to allocate to this.
> If 5.5.4 is supposed to fix this too, I'll build it, install it and hope
> it reclaims my lost dm-thin space, and if not suck up the deletion,
> re-creation and backup/restore.

The fix got to stable 5.5.2 and 5.4.18. I don't know if dm-thin actually
allows that, but is there a non-destructive way to reclaim the space?
Like using fstrim (the filesystem can tell the underlying storage which
blocks are free). According to
http://man7.org/linux/man-pages/man7/lvmthin.7.html ("Manually manage
free data space of thin pool LV") this should work but I have no
practical experience with that.
