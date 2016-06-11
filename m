Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbcFKQiI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 12:38:08 -0400
Date: Sun, 12 Jun 2016 00:38:04 +0800
From: Eryu Guan <eguan@redhat.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, fdmanana@gmail.com,
        mfasheh@suse.de
Subject: Re: [PATCH v2] fstests: btrfs: add test for qgroup handle extent
 de-reference
Message-ID: <20160611163804.GX5140@eguan.usersys.redhat.com>
References: <1464763211-17762-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464763211-17762-1-git-send-email-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 02:40:11PM +0800, Lu Fengqi wrote:
> Test if qgroup can handle extent de-reference during reallocation.
> "extent de-reference" means that reducing an extent's reference count
> or freeing an extent.
> Although current qgroup can handle it, we still need to prevent any
> regression which may break current qgroup.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  common/rc           |   4 +--
>  tests/btrfs/028     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/028.out |   2 ++
>  tests/btrfs/group   |   1 +
>  4 files changed, 107 insertions(+), 2 deletions(-)
>  create mode 100755 tests/btrfs/028
>  create mode 100644 tests/btrfs/028.out
> 
> diff --git a/common/rc b/common/rc
> index 51092a0..650d198 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3284,9 +3284,9 @@ _btrfs_get_profile_configs()
>  # stress btrfs by running balance operation in a loop
>  _btrfs_stress_balance()
>  {
> -	local btrfs_mnt=$1
> +	local options=$@
>  	while true; do
> -		$BTRFS_UTIL_PROG balance start $btrfs_mnt
> +		$BTRFS_UTIL_PROG balance start $options
>  	done
>  }
>  
> diff --git a/tests/btrfs/028 b/tests/btrfs/028
> new file mode 100755
> index 0000000..04a3508
> --- /dev/null
> +++ b/tests/btrfs/028
> @@ -0,0 +1,102 @@
> +#! /bin/bash
> +# FS QA Test 028
> +#
> +# Test if qgroup can handle extent de-reference during reallocation.
> +# "extent de-reference" means that reducing an extent's reference count
> +# or freeing an extent.
> +# Although current qgroup can handle it, we still need to prevent any
> +# regression which may break current qgroup.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Fujitsu. All Rights Reserved.
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
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +# Currently in btrfs the node/leaf size can not be smaller than the page
> +# size (but it can be greater than the page size). So use the largest
> +# supported node/leaf size (64Kb) so that the test can run on any platform
> +# that Linux supports.
> +_scratch_mkfs "--nodesize 64k"

I'm not sure if this is necessary, wouldn't mkfs.btrfs pick the proper
node/leaf size according to the platform at mkfs time?

Thanks,
Eryu
