From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] xfstests: make more tests generic
Date: Wed, 10 Aug 2011 12:43:14 -0400
Message-ID: <20110810164314.GA2308@infradead.org>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
 <c9703ec698de4de685eb6822773d3934452b8334.1312193821.git.sbehrens@giantdisaster.de>
 <20110810155214.GE20461@twin.jikos.cz>
 <1312994169.2865.41.camel@doink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	Stefan Behrens <sbehrens@giantdisaster.de>,
	linux-btrfs@vger.kernel.org
To: Alex Elder <aelder@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1312994169.2865.41.camel@doink>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 10, 2011 at 11:36:09AM -0500, Alex Elder wrote:
> > Possible ways to fix this:
> > 1) use /sbin/mkfs -t $FSTYP like _scratch_mkfs, or
> > 2) set $MKFS_BTRFS_PROG like for some other filesystems
> > 
> > 
> > What is preferred?
> 
> Whatever works.  My personal preference would be option (1)
> if it works, since it's does the generic thing directly
> rather than suggesting something special is needed for
> btrfs.  But if that doesn't work, consistency rules so
> MKFS_BTRFS_PROG "like for some other filesystems" is good.

Normally I'd agree with you, but I've run into problems with the
generic mkfs binary, as it parses some options that might otherwise
be left to the filesystem.  E.g. it parses -l by itself, which causes
problems when creating an xfs filesystem with an external log.

Note that any filesystem supported by _scratch_mkfs_sized is special;
there is no generic way to specify the size of a filesystem.

