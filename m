Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52826 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbcBLDx3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 22:53:29 -0500
Date: Fri, 12 Feb 2016 14:52:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 12/32] dio: unwritten conversion bug tests
Message-ID: <20160212035253.GX14668@dastard>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
 <20160211234037.2202.93885.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160211234037.2202.93885.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 03:40:37PM -0800, Darrick J. Wong wrote:
> Check that we don't expose old disk contents when a directio write to
> an unwritten extent fails due to IO errors.  This primarily affects
> XFS and ext4.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

aiocp.c: In function 'main':
aiocp.c:407:1: warning: format '%d' expects argument of type 'int', but argument 3 has type 'off_t' [-Wformat=]
 printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
 ^

Followup patch is fine, I'll commit as is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
