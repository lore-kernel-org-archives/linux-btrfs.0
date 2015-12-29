Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbbL2SI7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 13:08:59 -0500
Date: Tue, 29 Dec 2015 19:06:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Sanidhya Solanki <jpage.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151229180643.GD4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <1451341195.7094.0.camel@scientia.net>
 <20151228153801.6561feff@gmail.com>
 <1451352069.7094.3.camel@scientia.net>
 <20151228164333.2b8d8336@gmail.com>
 <1451360528.7094.7.camel@scientia.net>
 <20151228190336.59a3f440@gmail.com>
 <1451363188.7094.23.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1451363188.7094.23.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2015 at 05:26:28AM +0100, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-28 at 19:03 -0500, Sanidhya Solanki wrote:
> > That sounds like an absolutely ghastly idea.
> *G* and it probably is ;)
> 
> 
> >  Lots of potential for
> > mistakes and potential data loss. I take up the offer to implement
> > such a feature. 
> > Only question is should it be in-place replacement or replace out to
> > another disk or storage type. Will wait for comments on that question
> > before implementing. 
> I guess you really should have a decent discussion with some of the
> core btrfs developers (which I am not) before doing any efforts on this
> (and possibly wasting great amounts of work).
> 
> I spoke largely from the user/admin side,... running a quite big
> storage Tier-2, we did many IO benchmarks over time (with different
> hardware RAID controllers) and also as our IO patterns changed over
> time...
> The result was that our preferred RAID chunk sizes changed over
> time,...
> 
> Being able to to an online conversion (i.e. on the mounted fs) would be
> nice of course (from the sysadmin's side of view)

In theory this is possible with current on-disk data structures. The
stripe length is property of btrfs_chunk and changing it should be
possible the same way we do other raid transformations. The
implementation might be tricky at some places, but basically boils down
to the "read-" and "write-" stripe size. Reading chunks would always
respect the stored size, writing new data would use eg. the
superblock->stripesize or other value provided by the user.

> but even if that
> doesn't seem feasible an offline conversion may be useful (one simply
> may not have enough space left elsewhere to move the data of and create
> a new fs with different RAID chunk size from scratch)

Currently the userspace tools are not capable of the balance/relocation
functionality equivalent.

> Both open of course many questions (how to deal with crashes, etc.)...
> maybe having a look at how mdadm handles similar problems could be
> worth.

The crash consistency should remain, other than that we'd have to
enhance the balance filters to process only the unconverted chunks to
continue.
