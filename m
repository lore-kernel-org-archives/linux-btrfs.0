Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbcFUJe3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 05:34:29 -0400
Date: Tue, 21 Jun 2016 11:34:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, chandan@linux.vnet.ibm.com
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Message-ID: <20160621093457.GT4915@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <20160620160354.GR4915@twin.jikos.cz>
 <91d6f331-14de-5d1b-b73e-c24c0bfe950e@cn.fujitsu.com>
 <20160621091342.GS4915@suse.cz>
 <b42450d1-d929-7d8d-bbb7-126314002d92@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b42450d1-d929-7d8d-bbb7-126314002d92@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 21, 2016 at 05:26:23PM +0800, Qu Wenruo wrote:
> > Yeah, but I'm now concerned about the way both will be integrated in the
> > development or preview branches, not really the functionality itself.
> >
> > Now the conflicts are not trivial, so this takes extra time on my side
> > and I can't be sure about the result in the end if I put only minor
> > efforts to resolve the conflicts ("make it compile"). And I don't want
> > to do that too often.
> >
> > As stated in past discussions, the features of this impact should spend
> > one development cycle in for-next, even if it's not ready for merge or
> > there are reviews going on.
> >
> > The subpage patchset is now in a relatively good shape to start actual
> > testing, which already revealed some problems.
> >
> >
> I'm completely OK to do the rebase, but since I don't have 64K page size 
> machine to test the rebase, we can only test if 4K system is unaffected.
> 
> Although not much help, at least it would be better than making it compile.
> 
> Also such rebase may help us to expose bad design/unexpected corner case 
> in dedupe.
> So if it's OK, please let me try to do the rebase.

Well, if you base dedupe on subpage, then it could be hard to find the
patchset that introduces bugs, or combination of both. We should be able
to test the features independently, and thus I'm proposing to first find
some common patchset that makes that possible.
