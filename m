Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18084 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbcBIHvb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 02:51:31 -0500
Date: Tue, 9 Feb 2016 18:43:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 12/23] xfs/122: support refcount/rmap data structures
Message-ID: <20160209074330.GK19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011303.23099.40721.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209011303.23099.40721.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 08, 2016 at 05:13:03PM -0800, Darrick J. Wong wrote:
> Include the refcount and rmap structures in the golden output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/122     |    3 +++
>  tests/xfs/122.out |    4 ++++
>  tests/xfs/group   |    2 +-
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index e6697a2..758cb50 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -90,6 +90,9 @@ xfs_da3_icnode_hdr
>  xfs_dir3_icfree_hdr
>  xfs_dir3_icleaf_hdr
>  xfs_name
> +xfs_owner_info
> +xfs_refcount_irec
> +xfs_rmap_irec
>  xfs_alloctype_t
>  xfs_buf_cancel_t
>  xfs_bmbt_rec_32_t

So this is going to cause failures on any userspace that doesn't
know about these new types, right?

Should these be conditional in some way?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
