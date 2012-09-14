Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60990 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab2INPDc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 11:03:32 -0400
Date: Fri, 14 Sep 2012 11:03:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix race in sync and freeze again
Message-ID: <20120914150329.GN12994@localhost.localdomain>
References: <1347633426-13674-1-git-send-email-jbacik@fusionio.com>
 <50534510.1080101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50534510.1080101@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 08:54:08AM -0600, Liu Bo wrote:
> On 09/14/2012 10:37 PM, Josef Bacik wrote:
> > I screwed this up, there is a race between checking if there is a running
> > transaction and actually starting a transaction in sync where we could race
> > with a freezer and get ourselves into trouble.  To fix this we need to make
> > a new join type to only do the try lock on the freeze stuff.  If it fails
> > we'll return EPERM and just return from sync.  This fixes a hang Liu Bo
> > reported when running xfstest 68 in a loop.  Thanks,
> > 
> 
> This is also a trylock, why don't we just add a trylock for sb_start_intwrite directly
> just as what I've done before, that'd be cleaner:
> 
> https://patchwork.kernel.org/patch/1318131/
> 

Yeah if we get a sb_start_intwrite_trylock() then we can switch to using that in
the future, but for now I'm not going to block behind something needing to be
accepted into someone elses tree in order to get this fixed in btrfs.  Also the
patch you've posted isn't right because we hold the rwsem and an ref, so we have
to drop the rwsem before calling btrfs_join_transaction and then we need to make
sure to do sb_end_intwrite() after we do the commit to clean up our ref, my
approach is cleaner since it still lets the transaction deal with all of that
cleanup and we don't have to play with the freeze rwsem.  Thanks,

Josef
