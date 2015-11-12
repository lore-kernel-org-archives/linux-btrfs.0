Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbbKLNKi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 08:10:38 -0500
Date: Thu, 12 Nov 2015 14:09:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Regression in btrfs: properly set the termination value of
 ctx->pos in readdir
Message-ID: <20151112130901.GJ6445@suse.cz>
Reply-To: dsterba@suse.cz
References: <56432D2A.5040506@profihost.ag>
 <CAHji153qQPDyO+Ajv3O+FE991DjPG3y1t35091s8t9S4+w5k3g@mail.gmail.com>
 <20151112103523.GI6445@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20151112103523.GI6445@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 11:35:23AM +0100, David Sterba wrote:
> On Wed, Nov 11, 2015 at 01:22:19PM +0100, Holger Hoffstätte wrote:
> > > the patch btrfs: properly set the termination value of ctx->pos in
> > > readdir introduces a regression to me.
> > >
> > > A lot of stuff runs in "endless" or long running loops.
> > 
> > Just tested this and can confirm something is off.
> > In a directory with several files, create a new directory and move all
> > files into the new subdir.
> > 
> > An immediately following ls will hang. The problem goes away after a
> > manual sync.
> 
> I can reproduce the hang, thanks.

The hang was triggered by use of trace_printk and I'm seeing several
strange bugs caused by added debugging, so I can't say I can reproduce
it yet.
