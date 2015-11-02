Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52304 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbbKBXxY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 18:53:24 -0500
Date: Tue, 3 Nov 2015 10:53:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic test for fsync after hole punching
Message-ID: <20151102235309.GK10656@dastard>
References: <1446467577-32220-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446467577-32220-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2015 at 12:32:57PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that a file fsync works after punching a hole for the same file
> range multiple times, and that after log/journal replay the file's
> content and layout are correct.
> 
> This test is motivated by a bug found in btrfs, which is fixed by
> the following linux kernel patch:
> 
>   "Btrfs: fix hole punching when using the no-holes feature"
....
> +# This test was motivated by an issue found in btrfs when the btrfs no-holes
> +# feature is enabled (introduced in kernel 3.14). So enable the feature if the
> +# fs being tested is btrfs.
> +if [ $FSTYP == "btrfs" ]; then
> +	_require_btrfs_fs_feature "no_holes"
> +	_require_btrfs_mkfs_feature "no-holes"
> +	MKFS_OPTIONS="$MKFS_OPTIONS -O no-holes"
> +fi

This sort of transparent filesystem option should be tested by
executing the entire test suite with it enabled:

# MKFS_OPTIONS="-O no-holes" ./check -g auto

rather than only enabling for just this test.

> +# Silently drop all writes and unmount to simulate a crash/power failure.
> +_load_flakey_table $FLAKEY_DROP_WRITES
> +_unmount_flakey
> +
> +# Allow writes again, mount to trigger log replay and validate file contents.
> +_load_flakey_table $FLAKEY_ALLOW_WRITES
> +_mount_flakey

This is repeated often enough across many tests that a helper like:

# Silently drop all writes and unmount/remount to simulate a
# crash/power failure.
_flakey_drop_and_remount()
{
	_load_flakey_table $FLAKEY_DROP_WRITES
	_unmount_flakey

	_load_flakey_table $FLAKEY_ALLOW_WRITES
	_mount_flakey
}

is appropriate. Doesn't need to be in this patch, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
