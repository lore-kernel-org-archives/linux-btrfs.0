Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53502 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbcBLPWh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 10:22:37 -0500
Date: Fri, 12 Feb 2016 10:22:31 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 12/32] dio: unwritten conversion bug tests
Message-ID: <20160212152231.GA7928@thunk.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
 <20160211234037.2202.93885.stgit@birch.djwong.org>
 <20160212035253.GX14668@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160212035253.GX14668@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2016 at 02:52:53PM +1100, Dave Chinner wrote:
> On Thu, Feb 11, 2016 at 03:40:37PM -0800, Darrick J. Wong wrote:
> > Check that we don't expose old disk contents when a directio write to
> > an unwritten extent fails due to IO errors.  This primarily affects
> > XFS and ext4.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> aiocp.c: In function 'main':
> aiocp.c:407:1: warning: format '%d' expects argument of type 'int', but argument 3 has type 'off_t' [-Wformat=]
>  printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
>  ^
> 
> Followup patch is fine, I'll commit as is.

Dave, given that Darrick's patches is going to cause more
_scratch_mount occurences, how quickly do you plan to commit his
patchset?  Should I wait until he makes his change before I do the
s/_scratch_mount/_scratch_cycle_mount/ change?  Should I make that
change, and let you fix it up the commit?

Thanks,

					- Ted
