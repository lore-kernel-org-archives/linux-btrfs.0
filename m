Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33632 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031084AbbKEKhf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 05:37:35 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1446684636-32730-1-git-send-email-jmaggard@netgear.com>
References: <1446684636-32730-1-git-send-email-jmaggard@netgear.com>
Date: Thu, 5 Nov 2015 10:37:34 +0000
Message-ID: <CAL3q7H4tFT+2R3QXJe2gmYK+iKw0ANyfHcL2V2wqgEQwVVyQrw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: test unmount during quota rescan
From: Filipe Manana <fdmanana@gmail.com>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 5, 2015 at 12:50 AM, Justin Maggard <jmaggard10@gmail.com> wrote:
> This test case tests if we are able to unmount a filesystem while
> a quota rescan is running.  Up to now (4.3) this would result
> in a kernel NULL pointer dereference.
>
> Fixed by patch (btrfs: qgroup: exit the rescan worker during umount).
>
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---

Btw, for future patches/versions, here after the --- you should
mention what changed between versions of the patch.

thanks

>  tests/btrfs/114     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/114.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 64 insertions(+)
>  create mode 100644 tests/btrfs/114
>  create mode 100644 tests/btrfs/114.out
>
> diff --git a/tests/btrfs/114 b/tests/btrfs/114
> new file mode 100644
> index 0000000..0a0e8ba
> --- /dev/null
> +++ b/tests/btrfs/114
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/114
> +#
> +# btrfs quota scan/unmount sanity test
> +# Make sure that unmounting during a quota rescan doesn't crash
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
> +_scratch_unmount
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/114.out b/tests/btrfs/114.out
> new file mode 100644
> index 0000000..a2aa4a2
> --- /dev/null
> +++ b/tests/btrfs/114.out
> @@ -0,0 +1,2 @@
> +QA output created by 114
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 7cf7dd7..10ab26b 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -116,3 +116,4 @@
>  111 auto quick send
>  112 auto quick clone
>  113 auto quick compress clone
> +114 auto qgroup
> --
> 2.6.2
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
