From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH v3 1/2] xfstests: make more tests generic
Date: Wed, 10 Aug 2011 11:38:43 -0500
Message-ID: <1312994323.2865.42.camel@doink>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
	 <c9703ec698de4de685eb6822773d3934452b8334.1312193821.git.sbehrens@giantdisaster.de>
	 <20110810155214.GE20461@twin.jikos.cz>
	 <20110810163322.GA30292@infradead.org>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: <xfs@oss.sgi.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-btrfs@vger.kernel.org>,
	Stefan Behrens <sbehrens@giantdisaster.de>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110810163322.GA30292@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-08-10 at 12:33 -0400, Christoph Hellwig wrote:
> On Wed, Aug 10, 2011 at 05:52:14PM +0200, David Sterba wrote:
> > there's a hardcoded path for mkfs.btrfs in common.rc:_scratch_mkfs_sized()
> > 
> > 335     btrfs)
> > 336         /sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
> > 337         ;;
> > 
> > I have a /usr/local/ installation of btrfsprogs from git,
> > _scratch_mkfs_sized() was not called for btrfs before.
> > 
> > Possible ways to fix this:
> > 1) use /sbin/mkfs -t $FSTYP like _scratch_mkfs, or
> > 2) set $MKFS_BTRFS_PROG like for some other filesystems
> > 
> > 
> > What is preferred?
> 
> Please send a patch for variant 2.  As soon as we have option using
> the generic mkfs wrapper sounds like a good idea.  In addition to that
> treating btrfs the same way as other filesystems is always good.

Whoops, we gave different answers.  Do what Christoph says...	-Alex

