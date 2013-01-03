Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab3ACQMg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 11:12:36 -0500
Date: Thu, 3 Jan 2013 17:12:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Gene Czarcinski <gene@czarc.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Determining subvolumes
Message-ID: <20130103161232.GB20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50DAFDEE.3030204@czarc.net>
 <20121226135513.GU19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121226135513.GU19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 26, 2012 at 01:55:13PM +0000, Hugo Mills wrote:
> On Wed, Dec 26, 2012 at 08:38:54AM -0500, Gene Czarcinski wrote:
> > I know that I can find out what btrfs "volumes" are on a system with
> > the command:
> >      btrfs  fi  show
> > 
> > I can also check if a partition of disk is a btrfs volume with the command:
> >      blkid  -o value -s TYPE /dev/<disk|partition>
> > 
> > And, if I mount that btrfs volume with something like:
> >      mount -t btrfs /dev/<btrfs>  /mnt/btrfs
> > 
> > The, I can get a list of btrfs subvolumes on that volume with the command:
> >      btrfs  subvolume  list  /mnt/btrfs
> > 
> > My question:  Is there a way of finding out what subvolumes are
> > defined on a btrfs volume without mounting the volume?
> 
>    No. (Well, in theory the code is possible, but there's nothing I'm
> aware of that will do it)

It is possible to work with the filesystem offline, but lots of the
useful code is written only in kernel module (and accessed via ioctl()
calls from userspace).

Listing the subvolumes consists of:

* opening the filesystem (open_ctree_fs_info)
* search root tree for all ROOT_ITEM (via btrfs_search_slot)
  and also the found items recursively
* resolve the full path for each given root id (normally done via
  BTRFS_IOC_INO_LOOKUP) - btrfs_search_path_in_tree could be used almost
  verbatim (is not present in progs)

The existing functions to list subvolumes would need enhancing to work
both online and offline (eg. the filtering and printing code coud be
shared).

I don't know how far we should go to allow friendly access to an offline
volume. For debugging purposes it's usually enough to grep through
output of btrfs-debug-tree. Simple tasks like listing subvolumes or
manipulating default subvolume do not sound like a bad use case.


david
