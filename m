Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41969 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3JHRWA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 13:22:00 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 29EE79A03DE
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Oct 2013 11:22:00 -0600 (MDT)
Date: Tue, 8 Oct 2013 13:21:57 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>, <miaox@cn.fujitsu.com>,
        <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstest: an regression test for btrfs balance
Message-ID: <20131008172157.GD16461@localhost.localdomain>
References: <1381195275-9471-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1381195275-9471-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 09:21:15AM +0800, Gui Hecheng wrote:
> Originally, when executing "btrfs balance" right after
> "btrfs subvolume snaphot" & "btrfs subvolume delete",
> a kernel BUG arises.
> 
> This problem is caused by the patch:
> [PATCH 1/2] Btrfs: fix for patch "cleanup: don't check
> the same thing twice"
> The commit id: 48475471728f060bfd2e686f592ef208d3ba8b7d
> (in kernel/git/torvalds/linux.git)
> 
> handled by the patch:
> [PATCH 2/3] Btrfs: fix oops caused by the space balance
> and dead roots
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  tests/btrfs/319     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/319.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 74 insertions(+)
>  create mode 100755 tests/btrfs/319
>  create mode 100644 tests/btrfs/319.out
> 
> diff --git a/tests/btrfs/319 b/tests/btrfs/319
> new file mode 100755
> index 0000000..b49e760
> --- /dev/null
> +++ b/tests/btrfs/319
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/319
> +#

Just pick the next available number, so 012, no reason to jack up the numbers
like this.

> +# Btrfs balance tests
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Fujitsu.  All Rights Reserved.
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
> +here="`pwd`"
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_create_snapshot()
> +{
> +	for i in $(seq 20)
> +	do
> +		btrfs sub snapshot $SCRATCH_MNT $SCRATCH_MNT/snapshot0 >/dev/null
> +		btrfs sub delete $SCRATCH_MNT/snapshot0 >/dev/null
> +	done
> +}
> +
> +_balance()
> +{
> +	for i in $(seq 20)
> +	do
> +		btrfs balance start $SCRATCH_MNT >/dev/null
> +	done
> +}
> +
> +#get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +_setup_testdir
> +_require_scratch
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +echo "Tip: Run dmesg to see the error on failure"
> +
> +_create_snapshot &
> +
> +_balance &
> +
> +wait
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/319.out b/tests/btrfs/319.out
> new file mode 100644
> index 0000000..1d21523
> --- /dev/null
> +++ b/tests/btrfs/319.out
> @@ -0,0 +1,2 @@
> +QA output created by 319
> +Tip: Run dmesg to see the error on failure
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index d2fe030..201a475 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -14,3 +14,4 @@
>  009 auto quick
>  010 auto quick
>  011 auto
> +319 auto
> -- 
> 1.8.0.1

Otherwise this looks nice and straightforward, did you verify that it made the
box panic without Miao's fixes?  If you did just fixup the test number and you
can add

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
