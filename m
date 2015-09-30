Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbI3P3t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 11:29:49 -0400
Date: Wed, 30 Sep 2015 17:28:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        =?iso-8859-1?Q?Gabr=EDel_Arth=FAr_P=E9tursson?= <gabriel@system.is>,
        linux-btrfs@vger.kernel.org
Subject: Re: Add stripes filter
Message-ID: <20150930152847.GK11442@suse.cz>
Reply-To: dsterba@suse.cz
References: <1443463025.16163.6.camel@system.is>
 <20150929120029.GX11442@twin.jikos.cz>
 <560A7FAB.1040607@gmail.com>
 <20150929122139.GF25907@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20150929122139.GF25907@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 12:21:39PM +0000, Hugo Mills wrote:
> On Tue, Sep 29, 2015 at 08:10:19AM -0400, Austin S Hemmelgarn wrote:
> > On 2015-09-29 08:00, David Sterba wrote:
> > >On Mon, Sep 28, 2015 at 05:57:05PM +0000, Gabríel Arthúr Pétursson wrote:
> > >>The attached patches to linux and btrfs-progs add support for filtering
> > >>based on the number of strips in a block when balancing.
> > >
> > >What usecase do you want to address? As I understand it, this would help
> > >the raid56 rebalancing to process only blockgroups that are not spread
> > >accross enough devices.
> 
>    Exactly. Last week, I was trying to help Gabríel on IRC with a
> close-to-full filesystem balance it to add some new devices in a
> parity RAID configuration. He'd added the devices and balanced, but
> the usage was unequal across the devices. The only way I could think
> of dealing with it with the current tools was either to do a full
> balance repeatedly until it worked itself out, or to delve into the
> metadata with btrfs-debug-tree, and balance selected block groups
> individually.
> 
>    I whinged that we needed a filter to pick just the block groups
> that weren't "as full as possible", and Gabríel picked up the idea and
> ran with it.

That's great, thanks. The stripe filters are really missing.
