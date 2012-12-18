Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35212 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab2LRPkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 10:40:25 -0500
Date: Tue, 18 Dec 2012 10:40:22 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jim Schutt <jaschut@sandia.gov>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
Message-ID: <20121218154022.GG2403@localhost.localdomain>
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <20121218144750.GB14017@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121218144750.GB14017@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 07:47:51AM -0700, Liu Bo wrote:
> On Tue, Dec 18, 2012 at 08:52:42AM -0500, Josef Bacik wrote:
> > On Wed, Dec 12, 2012 at 06:52:37PM -0700, Liu Bo wrote:
> > > An user reported that he has hit an annoying deadlock while playing with
> > > ceph based on btrfs.
> > > 
> > > Current updating device tree requires space from METADATA chunk,
> > > so we -may- need to do a recursive chunk allocation when adding/updating
> > > dev extent, that is where the deadlock comes from.
> > > 
> > > If we use SYSTEM metadata to update device tree, we can avoid the recursive
> > > stuff.
> > > 
> > 
> > This is going to cause us to allocate much more system chunks than we used to
> > which could land us in trouble.  Instead let's just keep us from re-entering if
> > we're already allocating a chunk.  We do the chunk allocation when we don't have
> > enough space for a cluster, but we'll likely have plenty of space to make an
> > allocation.  Can you give this patch a try Jim and see if it fixes your problem?
> > Thanks,
> 
> From the stack info Jim gave, returning ENOSPC to caller will end up with
> aborting to readonly if there is no others save the situation by 
> allocating another METADATA chunk, it is recursive allocation though.
> 

if (ret < 0 && ret != -ENOSPC)

it shouldn't abort, it should just drop empty_size and stop trying to allocate a
cluster and just allocate the blocks needed, and this is only for the recursive
chunk allocation, so after this succeeds we'll have a new chunk and the original
allocation will be able to carry on.  Thanks,

Josef
