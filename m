Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbcAEKrP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 05:47:15 -0500
Date: Tue, 5 Jan 2016 11:44:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Sanidhya Solanki <jpage.lkml@gmail.com>,
        David Sterba <dsterba@suse.cz>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20160105104455.GS4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20151228153801.6561feff@gmail.com>
 <1451352069.7094.3.camel@scientia.net>
 <20151228164333.2b8d8336@gmail.com>
 <1451360528.7094.7.camel@scientia.net>
 <20151228190336.59a3f440@gmail.com>
 <1451363188.7094.23.camel@scientia.net>
 <20151229180643.GD4227@twin.jikos.cz>
 <20160102065207.4eec760a@gmail.com>
 <56887B40.10105@gmx.com>
 <1451787985.6645.12.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1451787985.6645.12.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 03, 2016 at 03:26:25AM +0100, Christoph Anton Mitterer wrote:
> On Sun, 2016-01-03 at 09:37 +0800, Qu Wenruo wrote:
> > And since you are making the stripe size configurable, then user is 
> > responsible for any too large or too small stripe size setting.
> That pops up the questions, which raid chunk sizes the kernel,
> respectively the userland tools should allow for btrfs...
> 
> I'd guess only powers of 2, some minimum, some maximum.

We have a full 32 bit number space, so multiples of power of 2 are also
possible if that makes sense. In general we don't need to set additional
limitations besides minimum, maximum and "minimal step".

> Are there any concerns/constraints with too small/too big chunks when
> these play together with lower block layers (I'd guess not).

I don't think so.
