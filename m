Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30422 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbaFJB1u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jun 2014 21:27:50 -0400
Date: Tue, 10 Jun 2014 11:27:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Xing Gu <gux.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add regression test for remount with thread_pool
 resized
Message-ID: <20140610012715.GI4453@dastard>
References: <1401439971-18589-1-git-send-email-gux.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401439971-18589-1-git-send-email-gux.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 30, 2014 at 04:52:51PM +0800, Xing Gu wrote:
> Regression test for resizing 'thread_pool' when remount the fs.

Ping for btrfs test reviewers - is this test useful at all?

> Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
> ---
>  tests/btrfs/055     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/055.out |  1 +
>  tests/btrfs/group   |  1 +
>  3 files changed, 57 insertions(+)
>  create mode 100755 tests/btrfs/055
>  create mode 100644 tests/btrfs/055.out
> 
> diff --git a/tests/btrfs/055 b/tests/btrfs/055
> new file mode 100755
> index 0000000..0a0dd34
> --- /dev/null
> +++ b/tests/btrfs/055
> @@ -0,0 +1,55 @@
> +#!/bin/bash
> +# FS QA Test No. btrfs/055
> +#
> +# Regression test for resizing 'thread_pool' when remount the fs.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
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
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +    rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +_scratch_mkfs > /dev/null 2>&1
> +
> +_scratch_mount "-o thread_pool=6"
> +
> +_scratch_mount "-o remount,thread_pool=10"
> +
> +status=0 ; exit
> diff --git a/tests/btrfs/055.out b/tests/btrfs/055.out
> new file mode 100644
> index 0000000..2fdd8f4
> --- /dev/null
> +++ b/tests/btrfs/055.out
> @@ -0,0 +1 @@
> +QA output created by 055
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index b668485..2c10c5b 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -57,3 +57,4 @@
>  052 auto quick
>  053 auto quick
>  054 auto quick
> +055 auto quick
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
