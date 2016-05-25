Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56530 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbcEYUs3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 16:48:29 -0400
Date: Wed, 25 May 2016 21:48:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Mason <clm@fb.com>, dsterba@suse.cz,
        Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] Btrfs: fix ->iterate_shared() by upgrading i_rwsem for
 delayed nodes
Message-ID: <20160525204821.GH14480@ZenIV.linux.org.uk>
References: <1e937bd41beebb68b1bf1201205059cb8f614dad.1463777299.git.osandov@fb.com>
 <20160525201129.GQ29147@twin.jikos.cz>
 <20160525202226.djc7dk4uhzuleets@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160525202226.djc7dk4uhzuleets@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 25, 2016 at 04:22:26PM -0400, Chris Mason wrote:
> On Wed, May 25, 2016 at 10:11:29PM +0200, David Sterba wrote:
> > On Fri, May 20, 2016 at 01:50:33PM -0700, Omar Sandoval wrote:
> > > Commit fe742fd4f90f ("Revert "btrfs: switch to ->iterate_shared()"")
> > > backed out the conversion to ->iterate_shared() for Btrfs because the
> > > delayed inode handling in btrfs_real_readdir() is racy. However, we can
> > > still do readdir in parallel if there are no delayed nodes.
> > 
> > So this is for current master (pre 4.7-rc1), I'll add an appropriate
> > merge point for to my for-next.
> 
> I'll get this bashed on in a big stress.sh run, but it looks good to me.

I really don't like that approach, TBH ;-/  Is there any reason to exclude
lookups for the duration of that thing?  Conversely, are we really OK
with changes to directory happening during that "unlock and relock exclusive"?
