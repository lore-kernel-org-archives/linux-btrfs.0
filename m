Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58125 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab2FMUdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 16:33:21 -0400
Date: Wed, 13 Jun 2012 16:17:11 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: David Pottage <david@chrestomanci.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Leaving Oracle
Message-ID: <20120613201711.GC3140@shiny>
References: <20120607010448.GA26531@shiny>
 <4FD4E0F8.6030400@chrestomanci.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FD4E0F8.6030400@chrestomanci.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 10, 2012 at 12:01:28PM -0600, David Pottage wrote:
> On 07/06/12 02:04, Chris Mason wrote:
> > Hello everyone,
> >
> > Oracle has been a fantastic place to work, and I really appreciate their
> > support for my projects.  But, I've decided to take a new position at
> > Fusion-io.  I will start the new job on Monday, June 11.
> Congratulations.
> > Fusion-io really believes in open source, and I'm excited to help
> > them shape the future of high performance storage.
> 
> Are you sure about that?
> 
> I installed one of their IO Drive SSD cards in one of my employer's 
> servers, and while the driver source code was supplied, the licence was 
> definitely not open source. (See http://www.fusionio.com/legal/eula/)
> > 4.1         General Restrictions.  [...] you will not, and will not 
> > permit or authorize third parties to: (a) reproduce, modify, 
> > translate, enhance, decompile, disassemble, reverse engineer, or 
> > create derivative works of the Software; 
> 

Hi everyone,

Circling back around to this, now that I'm up and running again.

Most of your storage is hidden behind some kind of closed source
firmware.  With Fusion-io, you get a closed driver, and that has its own
long standing debates that won't get resolved here.

Fusion-io has a strong track record of contributing to Linux, and I'm
sure we'll keep hiring more developers that are well known in the
community.

Of course, Btrfs is a GPL project, and all the future work in Btrfs is
going to stay GPL.

The great thing about Fusion-io is they are very actively trying to
engage higher parts of the storage stack to take advantage of the
hardware.  Since these features need to be in upstream filesystems,
we'll have to hammer out nice generic apis to take advantage of
them.

(This is my favorite kind of we that really means Jens Axboe)

Anyone who wants to support a backend for the apis is welcome to do so,
and I'm sure they will change over time as we all figure out what works
best.

Long story short, yes, I am sure that Fusion-io cares about open source.
Oracle too, since a few people misread that line as a dig at Oracle.

-chris

