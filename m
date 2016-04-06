Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38325 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbcDFVkI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 17:40:08 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160406213034.GF2187@wotan.suse.de>
References: <20160406213034.GF2187@wotan.suse.de>
Date: Wed, 6 Apr 2016 22:40:02 +0100
Message-ID: <CAL3q7H7XdZbOkzfE=Q2B2wAN5UDEm+bzrEkPu--SKaeCo=0huQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test snapshot create with invalid parent qgroup
From: Filipe Manana <fdmanana@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 6, 2016 at 10:30 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> Test that an invalid parent qgroup does not cause snapshot create to
> force the FS readonly.
>
> In btrfs, create_pending_snapshot() will go readonly on _any_ error return from
> btrfs_qgroup_inherit(). If qgroups are enabled, a user can crash their fs by
> just making a snapshot and asking it to inherit from an invalid qgroup.
>
> This patch does exactly that test. If the FS goes readonly that will be
> reported and we will know that a regression was introduced.
>
> The btrfs fix this patch relates to can be found at the following url:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/54755
>
> Thanks,
>         --Mark
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, just a few minor notes below.
Thanks.

> ---
>  tests/btrfs/119     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/119.out |  2 ++

Should be 121 (and should match the comment in the test file).

>  tests/btrfs/group   |  1 +
>  3 files changed, 73 insertions(+)
>  create mode 100755 tests/btrfs/119
>  create mode 100644 tests/btrfs/119.out
>
> diff --git a/tests/btrfs/119 b/tests/btrfs/119
> new file mode 100755
> index 0000000..1692160
> --- /dev/null
> +++ b/tests/btrfs/119
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/120

Doesn't match the tests' file name.

> +#
> +# Test that an invalid parent qgroup does not cause snapshot create to
> +# force the FS readonly.
> +#
> +# This issue is fixed by the following btrfs patch:
> +#  [PATCH] btrfs: handle non-fatal errors in btrfs_qgroup_inherit()
> +#  http://thread.gmane.org/gmane.comp.file-systems.btrfs/54755
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs
> +_scratch_mount
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +# The qgroup '1/10' does not exist and should be silently ignored
> +_run_btrfs_util_prog subvolume snapshot -i 1/10 $SCRATCH_MNT $SCRATCH_MNT/snap1
> +
> +_scratch_unmount

No need to call unmount here. The fstests framework does it
automatically for us.

> +
> +echo "Silence is golden"
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/119.out b/tests/btrfs/119.out
> new file mode 100644
> index 0000000..8e2ee9e
> --- /dev/null
> +++ b/tests/btrfs/119.out
> @@ -0,0 +1,2 @@
> +QA output created by 120
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index a2fa412..19f4910 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -119,3 +119,4 @@
>  116 auto quick metadata
>  117 auto quick send clone
>  118 auto quick snapshot metadata
> +119 auto quick qgroup

Plus the "snapshot" group.

> --
> 2.1.4
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
