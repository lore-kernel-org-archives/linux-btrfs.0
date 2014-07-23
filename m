Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaGWMli (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 08:41:38 -0400
Date: Wed, 23 Jul 2014 14:41:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Arvin Schnell <aschnell@suse.de>
Subject: Re: [PATCH] btrfs: extend BTRFS_IOC_SNAP_CREATE_V2 to snapshot by
 subvolid
Message-ID: <20140723124135.GM1553@suse.cz>
Reply-To: dsterba@suse.cz
References: <5330C6A8.5050206@suse.com>
 <537366D2.3080808@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537366D2.3080808@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 08:51:30AM -0400, Chris Mason wrote:
> On 03/24/2014 07:58 PM, Jeff Mahoney wrote:
> > The BTRFS_IOC_SNAP_CREATE_V2 ioctl is limited by requiring that a file
> > descriptor be passed in order to create the snapshot. This means that
> > snapshots may only be created of trees that are available in the mounted
> > namespace. We have a need to create snapshots from subvolumes outside
> > of the namespace. This is already possible by mounting the numbered
> > subvolume by ID on a separate mount point, creating the snapshot, and
> > unmounting it. That's a tedious and unnecessary process since the ioctl
> > can be extended so easily.
> > 
> > This patch adds a new BTRFS_SUBVOL_CREATE_SUBVOLID flag that instructs
> > the ioctl to use the fd argument (which is now a union) as a subvolume
> > id instead. The subvolume ID is used to look up the root and instantiate
> > the inode so proper permission checking takes place.
> 
> Can you please make this root only?  The file handle makes sure the
> admin hasn't intentionally hidden the subvol from the user, and this
> bypasses those permission checks.

I'll take care of this and send an updated patch.
