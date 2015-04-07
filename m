Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35857 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbbDGJZu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 05:25:50 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1428397482-13658-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1428397482-13658-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Tue, 7 Apr 2015 10:25:49 +0100
Message-ID: <CAL3q7H5xTcsJ0kqNjnuc+_iTA=CpdR7TCzcwJj9vWyoKuwh3Fg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] fstests: btrfs/088: Check return value of
 "btrfs filesystem show" command executed on umounted device.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 10:04 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> The return value should always be 0 if no problem happens, but
> "btrfs filesystem show" executed on umounted device will always return 1
> even there is no problem.
>
> This testcase just checks it.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> Rebased to latest fstests.
> 087 is taken by Filipe's test case "fstests: test for btrfs transaction
> abortion on device with discard support", so take 088.

And I just sent some days ago tests numbered 088 and 089.
You should probably remove the number you assign to the tests from the
patch subject, Dave often renumbers them and it adds no value to the
subject.

> ---
>  tests/btrfs/088     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/088.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 74 insertions(+)
>  create mode 100644 tests/btrfs/088
>  create mode 100644 tests/btrfs/088.out
>
> diff --git a/tests/btrfs/088 b/tests/btrfs/088
> new file mode 100644
> index 0000000..768d2bf
> --- /dev/null
> +++ b/tests/btrfs/088
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/088
> +#
> +# Check return value of "btrfs filesystem show" command executed on
> +# umounted device.
> +# It should return 0 if nothing wrong happens.
> +#
> +# Regression in v3.18 btrfs-progs and fixed by the following patch:
> +#
> +#    btrfs-progs: Fix wrong return value when executing 'fi show' on
> +#    umounted device.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Fujitsu, Inc.  All Rights Reserved.
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
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter.btrfs
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_scratch_dev_pool

Do we really need a device pool here, isn't a single device fs enough?
If it needs a multiple devices fs, it would be a good idea to explain
why in a comment and mention the need for it in the test description.

Otherwise looks good to me.

Thanks

> +
> +rm -f $seqres.full
> +
> +FIRST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> +TOTAL_DEVS=`echo $SCRATCH_DEV_POOL | wc -w`
> +
> +_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +
> +_run_btrfs_util_prog filesystem show $FIRST_POOL_DEV | \
> +       _filter_btrfs_filesystem_show $TOTAL_DEVS
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/088.out b/tests/btrfs/088.out
> new file mode 100644
> index 0000000..c24480a
> --- /dev/null
> +++ b/tests/btrfs/088.out
> @@ -0,0 +1,2 @@
> +QA output created by 088
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index e9c15af..a053d14 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -89,3 +89,4 @@
>  084 auto quick send
>  085 auto quick metadata subvol
>  086 auto quick clone
> +088 auto quick
> --
> 2.3.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
