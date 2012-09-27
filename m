Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2I0TuB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 15:50:01 -0400
Date: Thu, 27 Sep 2012 12:49:57 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v4 0/4] btrfs: extended inode refs
Message-ID: <20120927194957.GS8097@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1345494561-28758-1-git-send-email-mfasheh@suse.de> <20120925200446.GD6596@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120925200446.GD6596@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 04:04:46PM -0400, Chris Mason wrote:
> On Mon, Aug 20, 2012 at 02:29:17PM -0600, Mark Fasheh wrote:
> > 
> > Testing wise, the basic namespace operations work well (link, unlink, etc).
> > The rest has gotten less debugging (and I really don't have a great way of
> > testing the code in tree-log.c) Attached to this e-mail are btrfs-progs
> > patches which make testing of the changes possible.
> 
> Hi Mark,
> 
> I hit a few problems testing this, so I have the patch below that I plan
> on folding into your commits (to keep bisect from crashing in tree log).
> 
> Just let me know if this is a problem, or if you see any bugs in there.
> I'm still doing a last round of checks on it, but I wanted to send along
> early for comments.
> 
> The biggest change in here is to always check the ref_objectid when
> returning a backref.  Hash collisions mean we may return a ref for a
> completely different parent id otherwise.  I think I caught all the
> places missing that logic, but please double check me.

Ahh yes of course. I missed that in a couple key areas. Thanks for fixing
it.


> Other than that I went through and fixed up bugs in
> tree-log.c.  __add_inode_ref had a bunch of cut and paste errors, and you
> carefully preserved a huge use-after-free bug in the original
> add_inode_ref.

Cool, everything in there looks good to me. Thanks again Chris!
	--Mark

--
Mark Fasheh
