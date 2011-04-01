From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Fri, 1 Apr 2011 09:34:05 -0400
Message-ID: <20110401133405.GA17956@infradead.org>
References: <cover.1301542804.git.larry@elder-gods.org>
 <20110331063636.GA5297@infradead.org>
 <1301572893-sup-3464@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Larry D'Anna <larry@elder-gods.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Yan Zheng <zheng.z.yan@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301572893-sup-3464@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2011 at 08:02:22AM -0400, Chris Mason wrote:
> Excerpts from Christoph Hellwig's message of 2011-03-31 02:36:36 -0400:
> > On Thu, Mar 31, 2011 at 12:00:11AM -0400, Larry D'Anna wrote:
> > > This is a simple patch to allow reflinks to be made crossing subvolume
> > > boundaries.
> > 
> > NAK.  subvolumes will have to become vfsmounts sooner or later, and we
> > really must not support any operations spanning mountpoints.
> > 
> 
> Sorry, I disagree here.  reflinks were always intended to be able to
> span subvolumes.  There's no conflict at all because they span different
> inodes.

I don't think it's a good idea to introduce any user visible operations
over subvolume boundaries.  Currently we don't have any operations over
mount boundaries, which is pretty fumdamental to the unix filesystem
semantics.  If you want to change this please come up with a clear
description of the semantics and post it to linux-fsdevel for
discussion.  That of course requires a clear description of the
btrfs subvolumes, which is still completely missing.

