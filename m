Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132BBC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52C820989
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfCRT2V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:28:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:57900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbfCRT2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 15:28:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57DD0AC5B
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 19:28:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C9FBFDA829; Mon, 18 Mar 2019 20:29:35 +0100 (CET)
Date:   Mon, 18 Mar 2019 20:29:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/9] Extent buffer locking cleanups
Message-ID: <20190318192933.GH3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1552489554.git.dsterba@suse.com>
 <4e3a4188-2c4e-ccc7-324c-69e0c5f0c528@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e3a4188-2c4e-ccc7-324c-69e0c5f0c528@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 09:26:37AM +0200, Nikolay Borisov wrote:
> 
> 
> On 13.03.19 г. 17:46 ч., David Sterba wrote:
> > The series moves several atomic counters under CONFIG_BTRFS_DEBUG. The
> > selected counters are not essential for the extent buffer locking to
> > work. There's some space saving (4x 4B at least) and the cachelines are
> > less stressed on non-debugging builds.
> > 
> > The final size is 264 from 280, getting to 256 would be nice but hard or
> > making the code unreadable. I have ideas to shave 7 more bytes but
> > that's for another patchset.
> > 
> > David Sterba (9):
> >   btrfs: add assertion helpers for spinning writers
> >   btrfs: use assertion helpers for spinning writers
> >   btrfs: add assertion helpers for spinning readers
> >   btrfs: use assertion helpers for spinning readers
> >   btrfs: add assertion helpers for extent buffer read lock counters
> >   btrfs: use assertion helpers for extent buffer read lock counters
> >   btrfs: add assertion helpers for extent buffer write lock counters
> >   btrfs: use assertion helpers for extent buffer write lock counters
> >   btrfs: switch extent_buffer::lock_nested to bool
> > 
> >  fs/btrfs/extent_io.c |  13 +++--
> >  fs/btrfs/extent_io.h |  11 ++--
> >  fs/btrfs/locking.c   | 133 ++++++++++++++++++++++++++++++-------------
> >  3 files changed, 107 insertions(+), 50 deletions(-)
> 
> Overall the series looks good, one thing I wonder is wouldn't it be
> better if you convert those WARN_ON to assert so that we fail fast in
> case the locking invariant are broken?

This probably makes sense, the patches copy the existing code without
other updates. As it is entirely under debug ifdef, BUG_ON would work
too so it's not dependent on asserts compiled in or not.
