Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:37350 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3JRRNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 13:13:31 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A21AB7C040A
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 11:13:30 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>, Josef Bacik <jbacik@fusionio.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <alpine.DEB.2.00.1310180840380.32045@cobra.newdream.net>
CC: <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1310171059080.5573@cobra.newdream.net>
 <20131018142554.GD6924@localhost.localdomain>
 <alpine.DEB.2.00.1310180840380.32045@cobra.newdream.net>
Message-ID: <20131018171316.4917.58200@localhost.localdomain>
Subject: Re: transaction commit deadlock on current rc
Date: Fri, 18 Oct 2013 13:13:16 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Sage Weil (2013-10-18 11:42:28)
> On Fri, 18 Oct 2013, Josef Bacik wrote:
> > On Thu, Oct 17, 2013 at 12:56:14PM -0700, Sage Weil wrote:
> > > Hey,
> > > 
> > > I'm seeing the deadlock below under a ceph-osd workload.  There may be a 
> > > subtle problem with the async transaction sequence (since nobody but ceph 
> > > uses that that I know of), but not obvious to me why 
> > > create_pending_snapshots would get stuck on btrfs_tree_lock...
> > > 
> > 
> > Can you do sysrq+w when this happens so I can see everybody who's blocked?
> > Thanks,
> 
> Oops, forgot to attach the bug link.  It's at
> 
>         http://tracker.ceph.com/attachments/download/1035/a
>         http://tracker.ceph.com/issues/6451
> 
> The machine is still hung.. if there is additional info I can gather 
> you can ping me on irc.  

Thanks Sage and Josef, I've got this one queued up pending an ack from
Sage.  But it's obviously not harmful, so I'll probably send this
afternoon either way.

-chris

