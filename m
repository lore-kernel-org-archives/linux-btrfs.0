Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbbFROi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 10:38:58 -0400
Date: Thu, 18 Jun 2015 16:38:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com, kzak@redhat.com,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: i_version vs iversion (Was: Re: [RFC PATCH v2 1/2] Btrfs: add
 noi_version option to disable MS_I_VERSION)
Message-ID: <20150618143856.GG6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <20150617153306.GY6761@twin.jikos.cz>
 <20150617155234.GB7773@localhost.localdomain>
 <20150617170118.GA6761@twin.jikos.cz>
 <20150618024607.GA8530@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150618024607.GA8530@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Moving the discussion to fsdevel.

Summary: disabling MS_I_VERSION brings some speedups to btrfs, but the
generic 'noiversion' option cannot be used to achieve that. It is
processed before it reaches btrfs superblock callback, where
MS_I_VERSION is forced.

The proposed fix is to add btrfs-specific i_version/noi_version to btrfs,
to which I object.

Continued below.

On Thu, Jun 18, 2015 at 10:46:09AM +0800, Liu Bo wrote:
> On Wed, Jun 17, 2015 at 07:01:18PM +0200, David Sterba wrote:
> > On Wed, Jun 17, 2015 at 11:52:36PM +0800, Liu Bo wrote:
> > > On Wed, Jun 17, 2015 at 05:33:06PM +0200, David Sterba wrote:
> > > > On Wed, Jun 17, 2015 at 03:54:31PM +0800, Liu Bo wrote:
> > > > > MS_I_VERSION is enabled by default for btrfs, this adds an alternative
> > > > > option to toggle it off.
> > > > 
> > > > There's an existing generic iversion/noiversion mount option pair, no
> > > > need to extra add it to btrfs.
> > > 
> > > I know, it doesn't work though.
> > 
> > Sigh, I see, btrfs forces MS_I_VERSION flag,
> > 0c4d2d95d06e920e0c61707e62c7fffc9c57f63a. I read 'enabled by default' as
> > that there's a standard way to override the defaults.
> > 
> > So the right way is not to do that but this will break everyhing that
> > relies on that behaviour at the moment. This means to add the exception
> > to the upper layers, either VFS or 'mount', which is not very likely to
> > happen.
> > 
> > The generic options do not reach the filesystem specific callbacks, so
> > we can't check it.
> 
> Ext4 also makes its own "i_version" option, so I think we can do the
> same thing until more filesystems require to do it in a generic way.

AFAICS, ext4 had added it's own i_version before iversion was added to
mount:

ext4:

Commit:      25ec56b518257a56d2ff41a941d288e4b5ff9488
Commit date: Mon Jan 28 23:58:27 2008 -0500
Subject:     ext4: Add inode version support in ext4

util-linux:

Commti:      4fa5e73d16828c94234ba0aeafaec2470f79011c
Commit date: Thu Nov 27 12:08:44 2008 +0100
Subject:     mount: add i_version support

I don't know the history, this looks like adding the options was not
coordinated.

> The performance benefit with no_iversion is obvious for fsync
> related workloads since we would avoid some expensive log commits.

It is obviuos, but I'd like to avoid cluttering the mount options
interface further.

xfs also forces I_VERSION if it detects the superblock version 5, so it
could use the same fix that would work for btrfs.

I see two possibilities that pretend to be generic and clean:

1) the filesystem MS_I_* defaults would be exported and processed up the
   mount call stack

2) pass the full mount options to the filesystem (if requested eg. by
   file_system_type::fs_flags bits).

The other ideas contain 'make an exception to ... ' which does not sound
appealing.
