Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A11C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 15:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8145020839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 15:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8145020839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbeLLPgm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 10:36:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:39804 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726325AbeLLPgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 10:36:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8A3DAE60;
        Wed, 12 Dec 2018 15:36:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B2E22DA7E5; Wed, 12 Dec 2018 16:36:17 +0100 (CET)
Date:   Wed, 12 Dec 2018 16:36:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Martin Raiber <martin@urbackup.org>
Cc:     Chris Mason <clm@fb.com>, Ethan Lien <ethanlien@synology.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Message-ID: <20181212153616.GY23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Martin Raiber <martin@urbackup.org>,
        Chris Mason <clm@fb.com>, Ethan Lien <ethanlien@synology.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
 <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 03:22:40PM +0000, Martin Raiber wrote:
> On 12.12.2018 15:47 Chris Mason wrote:
> > On 28 May 2018, at 1:48, Ethan Lien wrote:
> >
> > It took me a while to trigger, but this actually deadlocks ;)  More 
> > below.
> >
> >> [Problem description and how we fix it]
> >> We should balance dirty metadata pages at the end of
> >> btrfs_finish_ordered_io, since a small, unmergeable random write can
> >> potentially produce dirty metadata which is multiple times larger than
> >> the data itself. For example, a small, unmergeable 4KiB write may
> >> produce:
> >>
> >>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
> >>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
> >>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
> >>
> >> Although we do call balance dirty pages in write side, but in the
> >> buffered write path, most metadata are dirtied only after we reach the
> >> dirty background limit (which by far only counts dirty data pages) and
> >> wakeup the flusher thread. If there are many small, unmergeable random
> >> writes spread in a large btree, we'll find a burst of dirty pages
> >> exceeds the dirty_bytes limit after we wakeup the flusher thread - 
> >> which
> >> is not what we expect. In our machine, it caused out-of-memory problem
> >> since a page cannot be dropped if it is marked dirty.
> >>
> >> Someone may worry about we may sleep in 
> >> btrfs_btree_balance_dirty_nodelay,
> >> but since we do btrfs_finish_ordered_io in a separate worker, it will 
> >> not
> >> stop the flusher consuming dirty pages. Also, we use different worker 
> >> for
> >> metadata writeback endio, sleep in btrfs_finish_ordered_io help us 
> >> throttle
> >> the size of dirty metadata pages.
> > In general, slowing down btrfs_finish_ordered_io isn't ideal because it 
> > adds latency to places we need to finish quickly.  Also, 
> > btrfs_finish_ordered_io is used by the free space cache.  Even though 
> > this happens from its own workqueue, it means completing free space 
> > cache writeback may end up waiting on balance_dirty_pages, something 
> > like this stack trace:
> >
> > [..]
> >
> > Eventually, we have every process in the system waiting on 
> > balance_dirty_pages(), and nobody is able to make progress on page 
> > writeback.
> >
> I had lockups with this patch as well. If you put e.g. a loop device on
> top of a btrfs file, loop sets PF_LESS_THROTTLE to avoid a feed back
> loop causing delays. The task balancing dirty pages in
> btrfs_finish_ordered_io doesn't have the flag and causes slow-downs. In
> my case it managed to cause a feedback loop where it queues other
> btrfs_finish_ordered_io and gets stuck completely.

This does not look like the artificial and hard to hit case that's in
the original patch. I'm thinking about sending a revert to 4.20-rc6, the
deadlock is IMO worse than OOM.
