Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbcFUJNP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 05:13:15 -0400
Date: Tue, 21 Jun 2016 11:13:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, chandan@linux.vnet.ibm.com
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Message-ID: <20160621091342.GS4915@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <20160620160354.GR4915@twin.jikos.cz>
 <91d6f331-14de-5d1b-b73e-c24c0bfe950e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <91d6f331-14de-5d1b-b73e-c24c0bfe950e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 21, 2016 at 08:36:49AM +0800, Qu Wenruo wrote:
> > I'm looking how well does this patchset merges with the rest, so far
> > there are excpected conflicts with Chandan's subpage-blocksize
> > patchset. For the easy parts, we can add stub patches to extend
> > functions like cow_file_range with parameters that are added by the
> > other patch.
> >
> > Honestly I don't know which patchset to take first. As the
> > subpage-blockszie is in the core, there are no user visibility and
> > interface questions, but it must not cause any regressions.
> >
> > Dedupe is optional, not default, and we have to mainly make sure it does
> > not have any impact when turned off.
> >
> > So I see three possible ways:
> >
> > * merge subpage first, as it defines the API, adapt dedupe
> 
> Personally, I'd like to merge subpage first.
> 
> AFAIK, it's more important than dedupe.
> It affects whether a fs created in 64K page size environment can be 
> mounted on a 4K page size system.

Yeah, but I'm now concerned about the way both will be integrated in the
development or preview branches, not really the functionality itself.

Now the conflicts are not trivial, so this takes extra time on my side
and I can't be sure about the result in the end if I put only minor
efforts to resolve the conflicts ("make it compile"). And I don't want
to do that too often.

As stated in past discussions, the features of this impact should spend
one development cycle in for-next, even if it's not ready for merge or
there are reviews going on.

The subpage patchset is now in a relatively good shape to start actual
testing, which already revealed some problems.
