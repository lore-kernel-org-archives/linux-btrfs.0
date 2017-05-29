Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53873 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750925AbdE2Nuq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 09:50:46 -0400
Date: Mon, 29 May 2017 15:49:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: bo.li.liu@oracle.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: add sanity check of extent item in scrub
Message-ID: <20170529134945.GE14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-7-bo.li.liu@oracle.com>
 <20170526183316.GN30842@twin.jikos.cz>
 <20170526202014.GD7859@lim.localdomain>
 <6375fc01-2e03-798e-5226-3a201c7d2ce5@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6375fc01-2e03-798e-5226-3a201c7d2ce5@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 29, 2017 at 09:48:19AM +0800, Qu Wenruo wrote:
> 
> 
> At 05/27/2017 04:20 AM, Liu Bo wrote:
> > On Fri, May 26, 2017 at 08:33:16PM +0200, David Sterba wrote:
> >> On Thu, May 25, 2017 at 06:26:31PM -0600, Liu Bo wrote:
> >>> Currently scrub only verify checksum of both metadata and data and
> >>> couldn't detect an invalid extent_item.
> >>
> >> This is a different kind of check that scrub was never designed to do.
> >> Scrub just verifies the checksums, not the sructural integrity. This has
> >> been referred to as an "on-line fsck". AFAIK xfs does not use 'scrub' in
> >> the same sense as btrfs, so things are going to be confusing for the
> >> users.
> >>
> >> The on-line fsck is still desired, but I'd like to see a discussion how
> >> exactly it should work, whether to extend scrub or add a new ioctl etc.
> >>
> > 
> > I was hesitating about scrub vs online fsck when posting, just thought
> > it'd be good when users got this error while doing a regular scrub
> > ahead of really getting into trouble.  If we have a plan for online
> > fsck, I'm happy to let fsck do the job.
> 
> IIRC on-line fsck will be too challenging for kernel.

Ok, we should define what's considered a sane 'fsck' subset that can be
done in kernel.

> Just check how current btrfs check does, it's doing tons of cross 
> checking for lowmem mode or uses tons of memory to record forward refs 
> and backward refs.

Full cross-ref validation is obviously quite heavy in terms of memory
resources and potential impact on the filesystem work.

> Doing it in kernel will be a disaster.
> 
> > 
> > Or we can do this kind of sanity check at the time when reading the
> > eb.
> 
> This seems more reasonable, just like what Su Yue did for 
> inode_ref/dir_item/dir_index.

Yeah that's what I had in mind, local sanity checks from information
available at the time. We can add such check independently and not
caling them on-line fsck anyway, so we can avoid overloading the scrub
stats.
