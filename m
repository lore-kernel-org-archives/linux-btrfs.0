Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49015 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbdFLNOG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 09:14:06 -0400
Date: Mon, 12 Jun 2017 15:13:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/8] btrfs: btrfs_bio_clone never fails, skip error
 handling
Message-ID: <20170612131300.GJ25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496422340.git.dsterba@suse.com>
 <aa834758a79dc983410da678aac76d039b4cfdc2.1496422340.git.dsterba@suse.com>
 <20170607181937.GD7481@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170607181937.GD7481@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 11:19:37AM -0700, Omar Sandoval wrote:
> On Fri, Jun 02, 2017 at 06:58:36PM +0200, David Sterba wrote:
> > Update direct callers of btrfs_bio_clone that do error handling, that we
> > can now remove.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/inode.c   | 4 ----
> >  fs/btrfs/volumes.c | 1 -
> >  2 files changed, 5 deletions(-)
> > 
> >  
> >  		if (dev_nr < total_devs - 1) {
> >  			bio = btrfs_bio_clone(first_bio, GFP_NOFS);
> > -			BUG_ON(!bio); /* -ENOMEM */
> >  		} else
> >  			bio = first_bio;
> 
> Could you please get rid of the extra curly braces now, too?

Sure, patch updated.
