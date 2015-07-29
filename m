Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21907 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbbG2BHN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 21:07:13 -0400
Date: Tue, 28 Jul 2015 21:07:02 -0400
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
Message-ID: <20150729010702.GA23543@ret.masoncoding.com>
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150728145021.GI6306@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150728145021.GI6306@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 04:50:21PM +0200, David Sterba wrote:
> On Tue, Jul 28, 2015 at 04:30:36PM +0800, Qu Wenruo wrote:
> > Although Liu Bo has already submitted a V10 version of his deduplication
> > implement, here is another implement for it.
> 
> What's the reason to start another implementation?

I'm really glad to see more experiments around dedup, its one of those
features we haven't fully explored.

[ ... ]

> 
> > Any early review or advice/question on the design is welcomed.
> 
> The implementation is looks simpler than the Liu Bo's, but (IMHO) at the
> cost of reduced funcionality.
> 
> Ideally, we merge one patchset with all desired functionality. Some kind
> of control interface is needed not only to enable/dsiable the whole
> feature but to affect the trade-offs (memory consumptin vs dedup
> efficiency vs speed), and that in a way that's flexible according to
> immediate needs.
> 
> The persistent dedup hash storage is not mandatory in theory, so we
> could implement an "in-memory tree only" mode, ie. what you're
> proposing, on top of Liu Bo's patchset.

Agree here, I'd love to see the two patch sets build on each other.
If dedup is really valuable, it's worth storing the hashes etc on disk.
But the work to confine the tradeoffs will make it much more usable over
the long term.

-chris
