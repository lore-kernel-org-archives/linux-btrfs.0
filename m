Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161597AbcFBTIQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 15:08:16 -0400
Date: Thu, 2 Jun 2016 12:08:14 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160602190814.GQ7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160601211522.GI7633@wotan.suse.de>
 <20160602170732.GJ29147@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160602170732.GJ29147@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 07:07:32PM +0200, David Sterba wrote:
> On Wed, Jun 01, 2016 at 02:15:22PM -0700, Mark Fasheh wrote:
> > > +/* dynamically allocate and initialize a ref_root */
> > > +static struct ref_root *ref_root_alloc(void)
> > > +{
> > > +	struct ref_root *ref_tree;
> > > +
> > > +	ref_tree = kmalloc(sizeof(*ref_tree), GFP_KERNEL);
> > 
> > I'm pretty sure we want GFP_NOFS here.
> 
> Then please explain to me why/where the reasoning below is wrong:

The general reasoning of when to use GFP_NOFS below is fine, I don't
disagree with that at all. If there is no way a recursion back into btrfs
can't happen at that allocation site then we can use GFP_KERNEL.

That said, have you closely audited this path? Does the allocation happen
completely outside any locks that might be shared with the writeout path?
What happens if we have to do writeout of the inode being fiemapped in order
to allocate space? If the answer to all my questions is "there is no way
this can deadlock" then by all means, we should use GFP_KERNEL. Otherwise
GFP_NOFS is a sensible guard against possible future deadlocks.
	--Mark

--
Mark Fasheh
