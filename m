Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51F8C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 01:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF892173C
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 01:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732708AbfBSB3a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 20:29:30 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726175AbfBSB3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 20:29:30 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 786ED8DF700A0C78086E;
        Tue, 19 Feb 2019 09:29:27 +0800 (CST)
Received: from [127.0.0.1] (10.134.22.195) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Feb 2019
 09:29:25 +0800
Subject: Re: [PATCH 1/2] fstests: generic, test fsync after succession of file
 renames
To:     <fdmanana@kernel.org>, <fstests@vger.kernel.org>
CC:     <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
References: <20190212180807.26368-1-fdmanana@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <1ef915e7-2c1e-872f-4686-0a636d822ddd@huawei.com>
Date:   Tue, 19 Feb 2019 09:29:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190212180807.26368-1-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019/2/13 2:08, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that after a combination of file renames, linking and creating a new
> file with the old name of a renamed file, if we fsync the new file, after
> a power failure we are able to mount the filesystem and all file names
> correspond to the correct inodes.
> 
> This test is motivated by a bug found in btrfs which is fixed by a patch
> for the linux kernel titled:
> 
>   "Btrfs: fix fsync after succession of renames of different files"
> 
> The test passes on ext4, xfs and patched btrfs, however at least in a
> 5.0-rc5 linux kernel, it fails on f2fs.

We have introduced one additional mount option to handle that case:

fsync_mode=%s

Control the policy of fsync. Currently supports "posix",
"strict", and "nobarrier". In "posix" mode, which is
default, fsync will follow POSIX semantics and does a
light operation to improve the filesystem performance.
In "strict" mode, fsync will be heavy and behaves in line
with xfs, ext4 and btrfs, where xfstest generic/342 will
pass, but the performance will regress. "nobarrier" is
based on "posix", but doesn't issue flush command for
non-atomic files likewise "nobarrier" mount option.

I've tested for confirmation, it passed both tests 526/527 on f2fs once I
changed mount option from default to fsync_mode=strict.

Filipe, could you please check that?

Thanks,

> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/generic/526     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/526.out |  5 ++++
>  tests/generic/group   |  1 +
>  3 files changed, 78 insertions(+)
>  create mode 100755 tests/generic/526
>  create mode 100644 tests/generic/526.out
> 
> diff --git a/tests/generic/526 b/tests/generic/526
> new file mode 100755
> index 00000000..d0b51f87
> --- /dev/null
> +++ b/tests/generic/526
> @@ -0,0 +1,72 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test No. 526
> +#
> +# Test that after a combination of file renames, linking and creating a new file
> +# with the old name of a renamed file, if we fsync the new file, after a power
> +# failure we are able to mount the filesystem and all file names correspond to
> +# the correct inodes.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmflakey
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_dm_target flakey
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +_init_flakey
> +_mount_flakey
> +
> +mkdir $SCRATCH_MNT/testdir
> +echo -n "foo" > $SCRATCH_MNT/testdir/fname1
> +echo -n "hello" > $SCRATCH_MNT/testdir/fname2
> +
> +# Make sure everything done so far is durably persisted.
> +sync
> +
> +# Rename and link files such that one new name corresponds to the name of
> +# another renamed file and one new file has the old name of one of the renamed
> +# files. Then fsync only the new file.
> +mv $SCRATCH_MNT/testdir/fname1 $SCRATCH_MNT/testdir/fname3
> +mv $SCRATCH_MNT/testdir/fname2 $SCRATCH_MNT/testdir/fname4
> +ln $SCRATCH_MNT/testdir/fname3 $SCRATCH_MNT/testdir/fname2
> +echo -n "bar" > $SCRATCH_MNT/testdir/fname1
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir/fname1
> +
> +# Simulate a power failure and mount the filesystem to check that all file names
> +# exist and correspond to the correct inodes.
> +_flakey_drop_and_remount
> +
> +echo "File fname1 data after power failure: $(cat $SCRATCH_MNT/testdir/fname1)"
> +echo "File fname2 data after power failure: $(cat $SCRATCH_MNT/testdir/fname2)"
> +echo "File fname3 data after power failure: $(cat $SCRATCH_MNT/testdir/fname3)"
> +echo "File fname4 data after power failure: $(cat $SCRATCH_MNT/testdir/fname4)"
> +
> +_unmount_flakey
> +
> +status=0
> +exit
> diff --git a/tests/generic/526.out b/tests/generic/526.out
> new file mode 100644
> index 00000000..83979d28
> --- /dev/null
> +++ b/tests/generic/526.out
> @@ -0,0 +1,5 @@
> +QA output created by 526
> +File fname1 data after power failure: bar
> +File fname2 data after power failure: foo
> +File fname3 data after power failure: foo
> +File fname4 data after power failure: hello
> diff --git a/tests/generic/group b/tests/generic/group
> index cfd003d3..492a5875 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -528,3 +528,4 @@
>  523 auto quick attr
>  524 auto quick
>  525 auto quick rw
> +526 auto quick log
> 

