Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758198AbcCVDA0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 23:00:26 -0400
Date: Tue, 22 Mar 2016 11:00:23 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] fstests: test fsync on overlayfs merged directory
Message-ID: <20160322030023.GF11419@eguan.usersys.redhat.com>
References: <1458581952-18638-1-git-send-email-fdmanana@kernel.org>
 <1458582625-22039-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458582625-22039-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 05:50:25PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that calling fsync against a file using the merged directory does
> not result in a crash nor fails unexpectedly.
> 
> This is motivated by a change in overlayfs that resulted in a crash
> (invalid memory access) when the lower or upper directory belonged to
> a btrfs file system. The overlayfs change came in commit 4bacc9c9234
> (overlayfs: Make f_path always point to the overlay and f_inode to the
> underlay). At the moment there are two patches in the linux-fsdevel
> and linux-btrfs mailing lists to fix this problem:
> 
>   * vfs: add file_dentry()
>   * Btrfs: fix crash/invalid memory access on fsync when using overlayfs
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Removed leftover comment from debugging.
> 
>  tests/overlay/002     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/002.out |  3 +++
>  tests/overlay/group   |  1 +
>  3 files changed, 78 insertions(+)
>  create mode 100755 tests/overlay/002
>  create mode 100644 tests/overlay/002.out
> 
> diff --git a/tests/overlay/002 b/tests/overlay/002
> new file mode 100755
> index 0000000..e5aa610
> --- /dev/null
> +++ b/tests/overlay/002
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# FS QA Test 002
> +#
> +# Test that calling fsync against a file using the merged directory does not
> +# result in a crash nor fails unexpectedly.
> +#
> +# This is motivated by a change in overlayfs that resulted in a crash (invalid
> +# memory access) when the lower or upper directory belonged to a btrfs file
> +# system.
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Filipe Manana <fdmanana@suse.com>
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic

The supported fs should be "overlay"? overlay/001 has the same issue
though.

Looks good to me otherwise, test passed with XFS as underlying fs and
test crashed v4.5 kernel with btrfs as underlying fs, as expected.

Reviewed-by: Eryu Guan <eguan@redhat.com>
