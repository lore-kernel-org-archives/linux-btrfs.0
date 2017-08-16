Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751772AbdHPSUs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 14:20:48 -0400
Date: Wed, 16 Aug 2017 20:19:24 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>, Chris Mason <clm@fb.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Message-ID: <20170816181924.GL2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
 <20170816131230.GA28619@clm-mbp.thefacebook.com>
 <1502890308.5446.5.camel@scientia.net>
 <152c3e70-72e2-0d26-e145-979f602257b7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <152c3e70-72e2-0d26-e145-979f602257b7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 16, 2017 at 09:53:57AM -0400, Austin S. Hemmelgarn wrote:
> > So apart from some central DBs for the storage management system
> > itself, CoW is mostly no issue for us.
> > But I've talked to some friend at the local super computing centre and
> > they have rather general issues with CoW at their virtualisation
> > cluster.
> > Like SUSE's snapper making many snapshots leading the storage images of
> > VMs apparently to explode (in terms of space usage).
> SUSE is pathological case of brain-dead defaults.  Snapper needs to 
> either die or have some serious sense beat into it.  When you turn off 
> the automatic snapshot generation for everything but updates and set the 
> retention policy to not keep almost everything, it's actually not bad at 
> all.

The defaults for timeline are really bad, the partition is almost never
big enough to hold 10 months worth of data updates, not to say 10 years.
A rolling distro can fill the space even with the daily or weeky
settings set to low numbers. But certain people had different oppinion
and I was not successful to change that. The least I did was to document
some of the usecases and the hints that could allow one to have a bit
more understanding of the effects.

https://github.com/kdave/btrfsmaintenance#tuning-periodic-snapshotting

> > For some of their storage backends there simply seem to be no de-
> > duplication available (or other reasons that prevent it's usage).
> If the snapshots are being CoW'ed, then dedupe won't save them any 
> space.  Also, nodatacow is inherently at odds with reflinks used for dedupe.
> > 
> >  From that I'd guess there would be still people who want the nice
> > features of btrfs (snapshots, checksumming, etc.), while still being
> > able to nodatacow in specific cases.
> Snapshots work fine with nodatacow, each block gets CoW'ed once when 
> it's first written to, and then goes back to being NOCOW.  The only 
> caveat is that you probably want to defrag either once everything has 
> been rewritten, or right after the snapshot.
