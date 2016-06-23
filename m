Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcFWMRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 08:17:14 -0400
Date: Thu, 23 Jun 2016 14:17:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Message-ID: <20160623121738.GZ4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <b42450d1-d929-7d8d-bbb7-126314002d92@cn.fujitsu.com>
 <20160621093457.GT4915@suse.cz>
 <1580932.8KuVbA1pQp@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1580932.8KuVbA1pQp@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 21, 2016 at 10:25:19PM +0530, Chandan Rajendra wrote:
> > > I'm completely OK to do the rebase, but since I don't have 64K page size 
> > > machine to test the rebase, we can only test if 4K system is unaffected.
> > > 
> > > Although not much help, at least it would be better than making it compile.
> > > 
> > > Also such rebase may help us to expose bad design/unexpected corner case 
> > > in dedupe.
> > > So if it's OK, please let me try to do the rebase.
> > 
> > Well, if you base dedupe on subpage, then it could be hard to find the
> > patchset that introduces bugs, or combination of both. We should be able
> > to test the features independently, and thus I'm proposing to first find
> > some common patchset that makes that possible.
> 
> I am not sure if I understood the above statement correctly. Do you mean to
> commit the 'common/simple' patches from both the subpage-blocksize & dedupe
> patchset first and then bring in the complicated ones later?

That would be great yes, but ...

> If yes, then we have a problem doing that w.r.t subpage-blocksize
> patchset. The first few patches bring in the core changes necessary for the
> other remaining patches.

... not easily possible. I looked again for common functions that change
the singature and found only cow_file_range and run_delalloc_nocow. The
plan:

- separate patch that adds new parameters required by both patches to
  the functions
- update all call sites, add 0/NULL as defaults for the new unused
  parameters
- rebase both patches on top of this patch

How does this help: if a patch starts to use the new parameter, it
changes only the value at all call sites. This is much easier to verify
and merge manually compared to adding a new parameter to the middle of
the list, namely when the functions take 6+.

The other conflicts like conversion from PAGE_SIZE to the the block
oriented iterations will be harder, but these are usually localized and
can be resolved. We'll see if there are other options to reduce the
clashes but at the moment it's stuck at the two functions. Does that
explain it better?
