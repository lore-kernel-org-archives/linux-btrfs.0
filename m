Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:42515 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbBSSTJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 13:19:09 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1422492360-12243-1-git-send-email-gux.fnst@cn.fujitsu.com>
References: <1422492360-12243-1-git-send-email-gux.fnst@cn.fujitsu.com>
Date: Thu, 19 Feb 2015 18:19:06 +0000
Message-ID: <CAL3q7H4Ozf40iodhjfuaQLT0SXc8A_bJnBQugyf+EPsF3Xwuvg@mail.gmail.com>
Subject: Re: [PATCH v6] btrfs: add regression test for remount with
 thread_pool resized
From: Filipe David Manana <fdmanana@gmail.com>
To: Xing Gu <gux.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, eguan@redhat.com,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 29, 2015 at 12:46 AM, Xing Gu <gux.fnst@cn.fujitsu.com> wrote:
> Regression test for a btrfs issue of resizing 'thread_pool' when
> remount the fs.
>
> This regression was introduced by the following linux kernel commit:
>     btrfs: Added btrfs_workqueue_struct implemented ordered
>     execution based on kernel workqueue
>     08a9ff3264181986d1d692a4e6fce3669700c9f8
> And it was fixed by the following linux kernel commit:
>     btrfs: fix crash in remount(thread_pool=) case
>     800ee2247f483b6d05ed47ef3bbc90b56451746c
>
> Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
> ---
>  v5->v6: Add a filter to wipe "Performing full device TRIM" and
>          "Turning ON incompat feature" in common/filter:_filter_mkfs.
>
>  v4->v5: Redirect stderr to /dev/null.
>
>  v3->v4: Remove the check for a bug message.
>
>  v2->v3: Add the regresssion commit in description.
>          Remove "dmesg -c > /dev/null".
>          Echo "Silence is golden" to indicate that an empty output
>          file is expected.
>
>  v1->v2: Add the fix commit in description.
>          Add the check for a bug message.
> ---
>  common/filter       |  4 ++++
>  tests/btrfs/082     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/082.out |  2 ++
>  tests/btrfs/group   |  1 +
>  4 files changed, 72 insertions(+)
>  create mode 100755 tests/btrfs/082
>  create mode 100644 tests/btrfs/082.out
>
> diff --git a/common/filter b/common/filter
> index 05dbae6..71ef2e2 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -137,6 +137,10 @@ _filter_mkfs()
>      case $FSTYP in
>      xfs)
>         ;;
> +       btrfs)
> +       sed -e "/Performing full device TRIM/d" \
> +               -e "/Turning ON incompat feature/d"
> +       return ;;

Hi,
This change to the filter function makes generic/204 always fail like this:

generic/204 5s ... - output mismatch (see
/home/fdmanana/git/hub/xfstests/results//generic/204.out.bad)
    --- tests/generic/204.out 2014-11-17 20:59:50.958203000 +0000
    +++ /home/fdmanana/git/hub/xfstests/results//generic/204.out.bad
2015-02-19 18:03:34.772608767 +0000
    @@ -1,2 +1,3 @@
     QA output created by 204
    +./tests/generic/204: line 76: space / (isize + dbsize): division
by 0 (error token is "(isize + dbsize)")
     *** done
    ...
    (Run 'diff -u tests/generic/204.out
/home/fdmanana/git/hub/xfstests/results//generic/204.out.bad'  to see
the entire diff)


>      *)
>         cat - >/dev/null
>         perl -e 'print STDERR "dbsize=4096\nisize=256\n"'
> diff --git a/tests/btrfs/082 b/tests/btrfs/082
> new file mode 100755
> index 0000000..dd3c87e
> --- /dev/null
> +++ b/tests/btrfs/082
> @@ -0,0 +1,65 @@
> +#!/bin/bash
> +# FS QA Test No. btrfs/082
> +#
> +# Regression test for a btrfs issue of resizing 'thread_pool' when
> +# remount the fs.
> +#
> +# This regression was introduced by the following linux kernel commit:
> +#     btrfs: Added btrfs_workqueue_struct implemented ordered
> +#     execution based on kernel workqueue
> +#     08a9ff3264181986d1d692a4e6fce3669700c9f8
> +# And it was fixed by the following linux kernel commit:
> +#     btrfs: fix crash in remount(thread_pool=) case
> +#     800ee2247f483b6d05ed47ef3bbc90b56451746c
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
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
> +status=1       # failure is the default!
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
> +_scratch_mkfs |& _filter_mkfs
> +
> +_scratch_mount "-o thread_pool=6"
> +_scratch_mount "-o remount,thread_pool=10"
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/082.out b/tests/btrfs/082.out
> new file mode 100644
> index 0000000..2977f14
> --- /dev/null
> +++ b/tests/btrfs/082.out
> @@ -0,0 +1,2 @@
> +QA output created by 082
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index e29999b..fd2fa76 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -84,3 +84,4 @@
>  079 auto rw metadata
>  080 auto snapshot
>  081 auto quick clone
> +082 auto quick remount
> --
> 1.9.3
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
