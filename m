Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCPIKg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 04:10:36 -0400
Date: Thu, 16 Mar 2017 16:10:34 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] fstests: btrfs: Add testcase for btrfs dedupe and
 metadata balance race test
Message-ID: <20170316081034.GU14226@eguan.usersys.redhat.com>
References: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
 <20170316015028.20020-4-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316015028.20020-4-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 16, 2017 at 09:50:27AM +0800, Qu Wenruo wrote:
> Btrfs balance with inband dedupe enable/disable will expose a lot of
> hidden dedupe bug:
> 
> 1) Enable/disable race bug
> 2) Btrfs dedupe tree balance corrupted delayed_ref
> 3) Btrfs disable and balance will cause balance BUG_ON
> 
> Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  tests/btrfs/201     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/201.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 115 insertions(+)
>  create mode 100755 tests/btrfs/201
>  create mode 100644 tests/btrfs/201.out
> 
> diff --git a/tests/btrfs/201 b/tests/btrfs/201
> new file mode 100755
> index 00000000..d6913c13
> --- /dev/null
> +++ b/tests/btrfs/201
> @@ -0,0 +1,112 @@
> +#! /bin/bash
> +# FS QA Test 201
> +#
> +# Btrfs inband dedup enable/disable race with metadata balance
> +#
> +# This tests will test the following bugs exposed in development:
> +# 1) enable/disable race
> +# 2) tree balance cause delayed ref corruption
> +# 3) disable and balance cause BUG_ON
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
                   ^^^^ 2017, all these three patches need update too.
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
> +	killall $FSSTRESS_PROG &> /dev/null

$KILLALL_PROG and

_require_command "$KILLALL_PROG" killall

Thanks,
Eryu
