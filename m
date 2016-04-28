Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52141 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbcD1N7R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 09:59:17 -0400
Subject: Re: [PATCH 2/2] btrfs: add test for replacing a missing device
To: Omar Sandoval <osandov@osandov.com>, <fstests@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
References: <cover.1461817486.git.osandov@fb.com>
 <dcf5aed04d3a85f33ec99e37fa0a17031c370ece.1461817486.git.osandov@fb.com>
CC: <kernel-team@fb.com>, Omar Sandoval <osandov@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <bfdaaebf-c026-8563-e247-784ee6253308@fb.com>
Date: Thu, 28 Apr 2016 09:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <dcf5aed04d3a85f33ec99e37fa0a17031c370ece.1461817486.git.osandov@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/28/2016 12:31 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> Now that _btrfs_get_profile_configs supports replace missing and the
> kernel doesn't crash when replacing a missing RAID 5/6 device, test it.
> Based on an earlier test from Wang Yanfeng.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  tests/btrfs/027     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/027.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 122 insertions(+)
>  create mode 100755 tests/btrfs/027
>  create mode 100644 tests/btrfs/027.out
>
> diff --git a/tests/btrfs/027 b/tests/btrfs/027
> new file mode 100755
> index 000000000000..f0844a14f8e6
> --- /dev/null
> +++ b/tests/btrfs/027
> @@ -0,0 +1,119 @@
> +#! /bin/bash
> +# FS QA Test 027
> +#
> +# Test replace of a missing device on various data and metadata profiles.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Facebook.  All Rights Reserved.
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
> +
> +_supported_fs generic
> +_supported_os IRIX Linux

Pretty sure we don't support btrfs on IRIX.  Fix that up and you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
