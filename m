Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbaLBDGT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 22:06:19 -0500
Date: Tue, 2 Dec 2014 11:06:11 +0800
From: Eryu Guan <eguan@redhat.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: add btrfs test to stress chunk
 allocation/removal and fstrim
Message-ID: <20141202030611.GQ29912@dhcp-13-216.nay.redhat.com>
References: <1417015839-26985-1-git-send-email-fdmanana@suse.com>
 <1417453889-16317-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417453889-16317-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 01, 2014 at 05:11:29PM +0000, Filipe Manana wrote:
> Stress btrfs' block group allocation and deallocation while running
> fstrim in parallel. Part of the goal is also to get data block groups
> deallocated so that new metadata block groups, using the same physical
> device space ranges, get allocated while fstrim is running. This caused
> several issues ranging from invalid memory accesses, kernel crashes,
> metadata or data corruption, free space cache inconsistencies, free
> space leaks and memory leaks.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Addressed Dave's comments.
> 
>  tests/generic/038     | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/038.out |   2 +
>  tests/generic/group   |   1 +
>  3 files changed, 155 insertions(+)
>  create mode 100755 tests/generic/038
>  create mode 100644 tests/generic/038.out
> 
> diff --git a/tests/generic/038 b/tests/generic/038
> new file mode 100755
> index 0000000..217aa7a
> --- /dev/null
> +++ b/tests/generic/038
> @@ -0,0 +1,152 @@
> +#! /bin/bash
> +# FSQA Test No. 038
> +#
> +# This test was motivated by btrfs issues, but it's generic enough as it
> +# doesn't use any btrfs specific features.
> +#
> +# Stress btrfs' block group allocation and deallocation while running fstrim in
> +# parallel. Part of the goal is also to get data block groups deallocated so
> +# that new metadata block groups, using the same physical device space ranges,
> +# get allocated while fstrim is running. This caused several issues ranging
> +# from invalid memory accesses, kernel crashes, metadata or data corruption,
> +# free space cache inconsistencies, free space leaks and memory leaks.
> +#
> +# These issues were fixed by the following btrfs linux kernel patches:
> +#
> +#   Btrfs: fix invalid block group rbtree access after bg is removed
> +#   Btrfs: fix crash caused by block group removal
> +#   Btrfs: fix freeing used extents after removing empty block group
> +#   Btrfs: fix race between fs trimming and block group remove/allocation
> +#   Btrfs: fix race between writing free space cache and trimming
> +#   Btrfs: make btrfs_abort_transaction consider existence of new block groups
> +#   Btrfs: fix memory leak after block remove + trimming
> +#   Btrfs: fix extent map leak on chunk allocation failure
> +#
> +# The issues were found on a qemu/kvm guest with 4 virtual CPUs, 4Gb of ram and
> +# scsi-hd devices with discard support enabled (that means hole punching in the
> +# disk's image file is performed by the host).
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
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
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	rm -fr $tmp
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs

This should be "_supported_fs generic"

Thanks,
Eryu
