Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34622 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbbKGPIC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 10:08:02 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1446835221-11905-1-git-send-email-jmaggard@netgear.com>
References: <1446835221-11905-1-git-send-email-jmaggard@netgear.com>
Date: Sat, 7 Nov 2015 15:08:01 +0000
Message-ID: <CAL3q7H6-DatA0-etkVrBjC5EA8n4mtk8oDbo4yG-BnEWUh0KvA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test quota disable during quota rescan
From: Filipe Manana <fdmanana@gmail.com>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 6, 2015 at 6:40 PM, Justin Maggard <jmaggard10@gmail.com> wrote:
> This test case tests if we are able to disable quotas on a filesystem
> while a quota rescan is running.  Up to now (4.3) this would result
> in a kernel NULL pointer dereference.
>
> Fixed by patch (btrfs: qgroup: fix quota disable during rescan).
>
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good and it triggers the bug without the btrfs kernel fix.

A side note, and if you would like you could do as a separate patch
imho, is to speedup creating the files by using multiple
jobs/processes (as we do in generic/038 for example) - the test takes
150 seconds on a debug kernel here, about 130 seconds were spent
creating the files. Same observation applies to your previous test
case as well.

Thanks for making this test.

> ---
>  tests/btrfs/115     | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/115.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 65 insertions(+)
>  create mode 100755 tests/btrfs/115
>  create mode 100644 tests/btrfs/115.out
>
> diff --git a/tests/btrfs/115 b/tests/btrfs/115
> new file mode 100755
> index 0000000..0d1cb3a
> --- /dev/null
> +++ b/tests/btrfs/115
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/115
> +#
> +# btrfs quota scan/disable sanity test
> +# Make sure that disabling quotas during a quota rescan doesn't crash
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 NETGEAR, Inc.  All Rights Reserved.
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
> +       cd /
> +       rm -f $tmp.*
> +}
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
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +for i in `seq 0 1 450000`; do
> +       echo -n > $SCRATCH_MNT/file.$i
> +done
> +echo 3 > /proc/sys/vm/drop_caches
> +$BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
> +$BTRFS_UTIL_PROG quota disable $SCRATCH_MNT
> +
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/115.out b/tests/btrfs/115.out
> new file mode 100644
> index 0000000..d9dd136
> --- /dev/null
> +++ b/tests/btrfs/115.out
> @@ -0,0 +1,2 @@
> +QA output created by 115
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 10ab26b..39b9aff 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -117,3 +117,4 @@
>  112 auto quick clone
>  113 auto quick compress clone
>  114 auto qgroup
> +115 auto qgroup
> --
> 2.6.3
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
