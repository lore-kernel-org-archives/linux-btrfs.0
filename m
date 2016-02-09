Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18084 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbcBIHv3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 02:51:29 -0500
Date: Tue, 9 Feb 2016 18:37:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 06/23] dio unwritten conversion bug tests
Message-ID: <20160209073732.GJ19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011223.23099.3987.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209011223.23099.3987.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 08, 2016 at 05:12:23PM -0800, Darrick J. Wong wrote:
> Check that we don't expose old disk contents when a directio write to
> an unwritten extent fails due to IO errors.  This primarily affects
> XFS and ext4.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -252,7 +252,9 @@
>  247 auto quick rw
>  248 auto quick rw
>  249 auto quick rw
> +250 auto quick
>  251 ioctl trim
> +252 auto quick

Also should be in the prealloc group if we are testing unwritten
extent behaviour and the rw group because it's testing IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
