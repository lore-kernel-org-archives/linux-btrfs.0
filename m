Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbbHNLJY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 07:09:24 -0400
Date: Fri, 14 Aug 2015 19:09:21 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v5 3/3] xfstests: btrfs: test device delete with EIO on
 src dev
Message-ID: <20150814110921.GQ17933@dhcp-13-216.nay.redhat.com>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439549224-29784-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439549224-29784-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 06:47:04PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> This test case tests if the device delete works with
> the failed (EIO) source device. EIO errors are achieved
> usign the DM device.
> 
> This test would need following btrfs-progs and btrfs
> kernel patch
>    btrfs-progs: device delete to accept devid
>    Btrfs: device delete by devid
> 
> However when btrfs-progs patch is not found this test will
> not run, and when kernel patch is not found btrfs-progs
> will fail gracefully and thus the test script.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4->v5: rebase on latest xfstests code, and accepts Filipe comment
> v3->v4: rebase on latest xfstests code
> v2->v3: accepts Filipe Manana's review comments, thanks
> v1->v2: accepts Dave Chinner's review comments, thanks
>  common/rc           |  7 +++++
>  tests/btrfs/099     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/099.out | 11 +++++++
>  tests/btrfs/group   |  1 +
>  4 files changed, 101 insertions(+)
>  create mode 100755 tests/btrfs/099
>  create mode 100644 tests/btrfs/099.out
> 
> diff --git a/common/rc b/common/rc
> index 8d4da0e..31a0328 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2737,6 +2737,13 @@ _require_meta_uuid()
>  	umount $SCRATCH_MNT
>  }
>  
> +_require_btrfs_dev_del_by_devid()
> +{
> +	$BTRFS_UTIL_PROG device delete --help | egrep devid > /dev/null 2>&1
> +	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old "\
> +			"(must support 'btrfs device delete <devid> /<mnt>')"
> +}
> +
>  _get_total_inode()
>  {
>  	if [ -z "$1" ]; then
> diff --git a/tests/btrfs/099 b/tests/btrfs/099
> new file mode 100755
> index 0000000..4464e24
> --- /dev/null
> +++ b/tests/btrfs/099
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/099
> +#
> +# test device delete when the source device has EIO
> +#
> +# Copyright (c) 2015 Oracle.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +
> +_cleanup()
> +{
> +	_cleanup_dmerror
> +	rm -f $tmp

And here too, rm -f $tmp.*

Thanks,
Eryu
