Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18090 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbcBIHvb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 02:51:31 -0500
Date: Tue, 9 Feb 2016 18:36:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 10/23] xfs: more reflink tests
Message-ID: <20160209073622.GI19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011250.23099.50000.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209011250.23099.50000.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 08, 2016 at 05:12:50PM -0800, Darrick J. Wong wrote:
> Create a couple of XFS-specific tests -- one to check that growing
> and shrinking the refcount btree works and a second one to check
> what happens when we hit maximum refcount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs xfs
> +_require_scratch_reflink
> +_require_cp_reflink
....
> +
> +test -x "$here/src/punch-alternating" || _notrun "punch-alternating not built"

I suspect we need a _require rule for checking that something in
the test src directory has been built.

> +echo "Check scratch fs"
> +umount "$SCRATCH_MNT"
> +echo "check refcount after removing all files" >> "$seqres.full"
> +"$XFS_DB_PROG" -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' "$SCRATCH_DEV" >> "$seqres.full"
> +"$XFS_REPAIR_PROG" -o force_geometry -n "$SCRATCH_DEV" >> "$seqres.full" 2>&1
> +res=$?
> +if [ $res -eq 0 ]; then
> +	# If repair succeeds then format the device so that the post-test
> +	# check doesn't fail due to the single AG.
> +	_scratch_mkfs >> "$seqres.full" 2>&1
> +else
> +	_fail "xfs_repair fails"
> +fi
> +
> +# success, all done
> +status=0
> +exit

This is what _require_scratch_nocheck avoids.

i.e. do this instead:

_require_scratch_nocheck
.....

"$XFS_REPAIR_PROG" -o force_geometry -n "$SCRATCH_DEV" >> "$seqres.full" 2>&1 
status=$?
exit

Also, we really don't need the quotes around these global
variables.  They are just noise and lots of stuff will break if
those variables are set to something that requires them to be
quoted.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
