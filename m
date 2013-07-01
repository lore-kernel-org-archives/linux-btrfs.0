Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47472 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3GAUju (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 16:39:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4BAF57C0427
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 14:39:50 -0600 (MDT)
Date: Mon, 1 Jul 2013 16:39:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Koen De Wit <koen.de.wit@oracle.com>
CC: Eric Sandeen <sandeen@redhat.com>, <xfs@oss.sgi.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfstests: btrfs/311: sparse copy between different
 filesystems/mountpoints
Message-ID: <20130701203947.GI4288@localhost.localdomain>
References: <51D1A734.3000805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51D1A734.3000805@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 01, 2013 at 05:58:44PM +0200, Koen De Wit wrote:
> Thanks Eric for reviewing and improving testcases btrfs/306, 309, 310 and
> 311 !
> 
> I had just one comment: on line 70 the output was redirected to $seqres.fll
> instead of $seqres.full. Corrected patch below.
> 
> # Check if creating a sparse copy ("reflink") of a file on btrfs
> # expectedly fails when it's done between different filesystems or
> # different mount points of the same filesystem.
> #
> # For both situations, these actions are executed:
> #    - Copy a file with the reflink=auto option.
> #      A normal copy should be created.
> #    - Copy a file with the reflink=always option. Should result in error,
> #      no file should be created.
> 
> [sandeen: mostly cosmetic changes]
> 
> Originally submitted as:
> xfstests: 301: sparse copy between different filesystems/mountpoints on
> btrfs
> 
> Signed-off-by: Koen De Wit <koen.de.wit@xxxxxxxxxx>
> Signed-off-by: Eric Sandeen <sandeen@xxxxxxxxxx>
> ---
>  tests/btrfs/311     |  107
> +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/311.out |   15 +++++++
>  tests/btrfs/group   |    4 ++
>  3 files changed, 126 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/311
>  create mode 100644 tests/btrfs/311.out
> 
> diff --git a/tests/btrfs/311 b/tests/btrfs/311
> new file mode 100755
> index 0000000..56ebd58
> --- /dev/null
> +++ b/tests/btrfs/311
> @@ -0,0 +1,107 @@
> +#! /bin/bash
> +# FS QA Test No. 311
> +#
> +# Check if creating a sparse copy ("reflink") of a file on btrfs
> +# expectedly fails when it's done between different filesystems or
> +# different mount points of the same filesystem.
> +#
> +# For both situations, these actions are executed:
> +#    - Copy a file with the reflink=auto option.
> +#      A normal copy should be created.
> +#    - Copy a file with the reflink=always option. Should result in error,
> +#      no file should be created.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013, Oracle and/or its affiliates.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    umount $SCRATCH_MNT &>/dev/null
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_cp_reflink
> +
> +SOURCE_DIR=$TEST_DIR/test-$seq
> +CROSS_DEV_DIR=$SCRATCH_MNT/test-$seq
> +# mount point & target for twice-mounted device
> +TEST_DIR2=$TEST_DIR/mount2
> +DUAL_MOUNT_DIR=$SCRATCH_MNT/test-bis-$seq
> +
> +rm -rf $SOURCE_DIR
> +mkdir $SOURCE_DIR
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs
> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $SOURCE_DIR/original \
> + >> $seqres.full
> +
> +_filter_testdirs()
> +{
> +    _filter_test_dir | _filter_scratch
> +}
> +
> +_create_reflinks_to()
> +{
> +    # auto reflink, should fall back to non-reflink
> +    rm -rf $1; mkdir $1
> +    echo "reflink=auto:"
> +    cp --reflink=auto $SOURCE_DIR/original $1/copy
> +    md5sum $SOURCE_DIR/original | _filter_testdirs
> +    md5sum $1/copy | _filter_testdirs
> +
> +    # always reflink, should fail outright
> +    rm -rf $1; mkdir $1
> +    echo "reflink=always:"
> +    cp --reflink=always $SOURCE_DIR/original $1/copyfail 2>&1 |
> _filter_testdirs

Line wrapped here ^^, patch doesn't apply, please fix and resubmit.  Thanks,

Josef
