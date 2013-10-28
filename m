Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47030 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3J1PxZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 11:53:25 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 01F367C0434
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 09:53:25 -0600 (MDT)
Date: Mon, 28 Oct 2013 11:53:21 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: <xfs@oss.sgi.com>, Josef Bacik <jbacik@fusionio.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [patch 2/3] [PATCH 2/3] xfstests: add test for sysfs publication
 of btrfs info
Message-ID: <20131028155321.GC4543@localhost.localdomain>
References: <20131025205246.269327744@suse.com>
 <20131025205559.690510798@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131025205559.690510798@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 25, 2013 at 04:52:48PM -0400, Jeff Mahoney wrote:
> This tests the sysfs publishing for btrfs allocation and device
> membership info under a number of different layouts, similar to the
> btrfs replace test. We test the allocation files only for existence and
> that they contain numerical values. We test the device membership
> by mapping the devices used to create the file system to sysfs paths
> and matching them against the paths used for the device membership
> symlinks.
> 
> Since this is a new feature, it passes on kernels without
> a /sys/fs/btrfs/<fsid> directory.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  common/config       |   1 +
>  tests/btrfs/101     | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/101.out |   2 +
>  3 files changed, 191 insertions(+)
>  create mode 100755 tests/btrfs/101
>  create mode 100644 tests/btrfs/101.out
> 
> diff --git a/common/config b/common/config
> index 20c5b09..5f9e2e8 100644
> --- a/common/config
> +++ b/common/config
> @@ -208,6 +208,7 @@ case "$HOSTOS" in
>          export MKFS_UDF_PROG="`set_prog_path mkudffs`"
>          export MKFS_BTRFS_PROG="`set_btrfs_mkfs_prog_path_with_opts`"
>          export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
> +        export UDEVADM_PROG="`set_prog_path udevadm`"
>          export BTRFS_SHOW_SUPER_PROG="`set_prog_path btrfs-show-super`"
>          export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
>          export MKFS_NFS_PROG="false"
> diff --git a/tests/btrfs/101 b/tests/btrfs/101
> new file mode 100755
> index 0000000..9a2834b
> --- /dev/null
> +++ b/tests/btrfs/101
> @@ -0,0 +1,188 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/101
> +#
> +# Test of the btrfs sysfs publishing
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2013 SUSE.  All rights reserved.
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
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_require_scratch
> +_require_scratch_dev_pool
> +_require_command $UDEVADM_PROG udevadm

I don't think you need the extra udevadm here.  Thanks,

Josef
