Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839AbcFTPym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 11:54:42 -0400
Date: Mon, 20 Jun 2016 17:07:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] Btrfs: fix ->iterate_shared() by upgrading i_rwsem for
 delayed nodes
Message-ID: <20160620150704.GQ4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1e937bd41beebb68b1bf1201205059cb8f614dad.1463777299.git.osandov@fb.com>
 <20160525201129.GQ29147@twin.jikos.cz>
 <20160525202226.djc7dk4uhzuleets@floor.thefacebook.com>
 <20160617175554.GC28716@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160617175554.GC28716@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 10:55:54AM -0700, Omar Sandoval wrote:
> On Wed, May 25, 2016 at 04:22:26PM -0400, Chris Mason wrote:
> > On Wed, May 25, 2016 at 10:11:29PM +0200, David Sterba wrote:
> > > On Fri, May 20, 2016 at 01:50:33PM -0700, Omar Sandoval wrote:
> > > > Commit fe742fd4f90f ("Revert "btrfs: switch to ->iterate_shared()"")
> > > > backed out the conversion to ->iterate_shared() for Btrfs because the
> > > > delayed inode handling in btrfs_real_readdir() is racy. However, we can
> > > > still do readdir in parallel if there are no delayed nodes.
> > > 
> > > So this is for current master (pre 4.7-rc1), I'll add an appropriate
> > > merge point for to my for-next.
> > 
> > I'll get this bashed on in a big stress.sh run, but it looks good to me.
> > 
> > -chris
> > 
> 
> Chris/Dave, what's the plan for this? Since it's getting late for 4.7,
> should we just think harder for a proper solution for 4.8?

There are a few more fixes queued for rc5 so I can add this one as well.
It's been in for-next since the first posting but I haven't run any
specific tests.
