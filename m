Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbaFIOWg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jun 2014 10:22:36 -0400
Date: Mon, 9 Jun 2014 16:22:04 +0200
From: Karel Zak <kzak@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] mount: add btrfs to mount.8
Message-ID: <20140609142204.GF30975@x2.net.home>
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140605080311.GW9000@x2.net.home>
 <1402036359.17740.33.camel@localhost.localdomain>
 <20140606094428.GA30975@x2.net.home>
 <20140606100302.GB30975@x2.net.home>
 <5391E3D0.8050608@redhat.com>
 <20140607134150.GA22076@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140607134150.GA22076@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 07, 2014 at 06:41:50AM -0700, Christoph Hellwig wrote:
> On Fri, Jun 06, 2014 at 10:52:48AM -0500, Eric Sandeen wrote:
> > On 6/6/14, 5:03 AM, Karel Zak wrote:
> > > On Fri, Jun 06, 2014 at 11:44:28AM +0200, Karel Zak wrote:
> > >>  I personally have no problem to maintain information about arbitrary
> > >>  FS in mount.8, the problem are updates. Unfortunately, kernel FS developers
> > >>  don't care about the man page at all and it's very often not up to date.
> > > 
> > >  Hmm.. another possible way would be to create a script for util-linux
> > >  that will analyze kernel Documentation/filesystems/<fsname>.txt and
> > >  report changes that is necessary to make to mount.8. It should be
> > >  relative simple with git. I'll try it..
> > 
> > I like that idea.  Maybe <fsname.txt> will need a defined format, though,
> > right?  Maybe asciidoc?
> > 
> > I've still been meaning (in theory) to produce a mount manpage just for xfs.
> > I'm still willing to do that if the above doesn't pan out.  I just need
> > to get to it.  I'd be happy to do it for extN as well.
> 
> Autogenerating man pages from an adhoc format sounds like the wrong
> approach.  I'd much rather have proper man paged for every filesystem.
> With those we could also drop all that information from the kernel
> Documentation directory, where users won't looks for them anyway.
> 
> Eric, if you take care of xfs an extN I'll get started on man pages
> for the various "minor" filesystems that don't really have active
> maintainers.
> 
> Not sure if we should go for mount.<fstype>.8 man pages or just improve
> the <fstype>.5 pages, but I think the second one is more obvious.

I think <fstype>.5 provides opportunity to distribute more information
about the filesystem than just mount options only. See for example
nfs.5 where is complete overview about the filesystem.

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
