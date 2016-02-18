Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11096 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965422AbcBRBgI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 20:36:08 -0500
Date: Thu, 18 Feb 2016 12:30:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/2] fstests: generic test for directory fsync after
 rename operation
Message-ID: <20160218013046.GU14668@dastard>
References: <1455533663-7704-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455533663-7704-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2016 at 10:54:23AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we move one file between directories, fsync the parent
> directory of the old directory, power fail and remount the filesystem,
> the file is not lost and it's located at the destination directory.
> 
> This is motivated by a bug found in btrfs, which is fixed by the patch
> (for the linux kernel) titled:
> 
>   "Btrfs: fix file loss on log replay after renaming a file and fsync"
> 
> Tested against ext3, ext4, xfs, f2fs and reiserfs.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
....
> +# We expect our file foo to exist, have an entry in the new parent
> +# directory (c/) and not have anymore an entry in the old parent directory
> +# (a/b/).
> +[ -e $SCRATCH_MNT/a/b/foo ] && echo "File foo is still at directory a/b/"
> +[ -e $SCRATCH_MNT/c/foo ] || echo "File foo is not at directory c/"
> +
> +# The new file named bar should also exist.
> +[ -e $SCRATCH_MNT/a/bar ] || echo "File bar is missing"

This can all be replaced simply by:

ls -R $SCRATCH_MNT | _filter_scratch

Because the golden image match will tell us if files are missing or
in the wrong place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
