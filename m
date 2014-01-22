Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbaAVMUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 07:20:11 -0500
Date: Wed, 22 Jan 2014 13:20:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Sandy McArthur <sandymac@gmail.com>,
        Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140122122010.GG6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
 <52DD148E.3060200@gmail.com>
 <CAPs0BijBB0JTJd_-89Jo3OUozDKN8cCWA27=irBD+UoRShxPiw@mail.gmail.com>
 <52DE6747.4050404@gmail.com>
 <20140121165200.GF3314@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140121165200.GF3314@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 21, 2014 at 04:52:00PM +0000, Hugo Mills wrote:
> On Tue, Jan 21, 2014 at 07:25:43AM -0500, Austin S Hemmelgarn wrote:
> > > Maybe this happens already: Might a similar effect be automatically
> > > achieved by tracking per-device I/O load averages and distributing
> > > reads based on the I/O loads of possible read devices?
> > > 
> > That might be the case, it depends on how the I/O load averages are
> > calculated.  I actually hadn't realized BTRFS did this, I thought it
> > behaved more like MD RAID (that is, distributing the reads among devices
> > in a un-weighted round-robin fashion).
> 
>    I think David tried that a while ago, and the benchmarks were
> actually worse. I'm not sure how much investigation he did into why,
> though.

I haven't done any extensive testing, only streaming writes, and the
heuristic just batched writes by a given threshold before switching to
another mirror.  Load balancing was done without any logic that would
look at actual IO load of the devices. For me, the result was that
there's room for improvement.
