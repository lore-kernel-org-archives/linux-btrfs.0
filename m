Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:56506 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab3JRWkP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 18:40:15 -0400
Date: Fri, 18 Oct 2013 15:40:14 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Chris Mason <chris.mason@fusionio.com>
cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: transaction commit deadlock on current rc
In-Reply-To: <20131018171316.4917.58200@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1310181539270.20032@cobra.newdream.net>
References: <alpine.DEB.2.00.1310171059080.5573@cobra.newdream.net> <20131018142554.GD6924@localhost.localdomain> <alpine.DEB.2.00.1310180840380.32045@cobra.newdream.net> <20131018171316.4917.58200@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Oct 2013, Chris Mason wrote:
> Quoting Sage Weil (2013-10-18 11:42:28)
> > On Fri, 18 Oct 2013, Josef Bacik wrote:
> > > On Thu, Oct 17, 2013 at 12:56:14PM -0700, Sage Weil wrote:
> > > > Hey,
> > > > 
> > > > I'm seeing the deadlock below under a ceph-osd workload.  There may be a 
> > > > subtle problem with the async transaction sequence (since nobody but ceph 
> > > > uses that that I know of), but not obvious to me why 
> > > > create_pending_snapshots would get stuck on btrfs_tree_lock...
> > > > 
> > > 
> > > Can you do sysrq+w when this happens so I can see everybody who's blocked?
> > > Thanks,
> > 
> > Oops, forgot to attach the bug link.  It's at
> > 
> >         http://tracker.ceph.com/attachments/download/1035/a
> >         http://tracker.ceph.com/issues/6451
> > 
> > The machine is still hung.. if there is additional info I can gather 
> > you can ping me on irc.  
> 
> Thanks Sage and Josef, I've got this one queued up pending an ack from
> Sage.  But it's obviously not harmful, so I'll probably send this
> afternoon either way.

This is passing my initial tests!  It'll be subjected to the full firehose 
later tonight; I'll let you know if anything comes up.

Thanks!
sage
