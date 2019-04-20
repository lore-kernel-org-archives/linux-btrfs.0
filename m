Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897DFC282DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 14:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DC5A21479
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555769679;
	bh=7gTKLk/0ESkyDJ9ZkfZuQdE0kArCmaJJQ1plpqcuXhE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AL/r9sJ8ZhcHPOYE4eiFI4+LmDji862KnZ76ik0+/C8VBp3RqKi00QvYUyUkKCsHj
	 f43cIigdEOLwkqOGGY/rVcRTdY66kZy12mQTHBx9nlFpLTShYq4/Q/snRg2E9g+Z8Y
	 FgepjQLtOs3JD3dJWCitYqwuqZfmkAD1ORuX9S24=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfDTOOi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 10:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfDTOOi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 10:14:38 -0400
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 093DE21479;
        Sat, 20 Apr 2019 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555769677;
        bh=7gTKLk/0ESkyDJ9ZkfZuQdE0kArCmaJJQ1plpqcuXhE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cdTOh1Y9pTRi32l8+B92IbcdpK8UN5600NUguxgSQzBlLhXvY298Vi9lChJeokWvm
         1NDCEhKyI0D0xm9FaFxPBdnbdpBS0v+iGiwOK6XvcvEVX0NXr1NsZSScarge3j/qcx
         etzkQWNZQnV2MJW/2inEveOijo+D6jBbP4qweiA8=
Received: by mail-vs1-f54.google.com with SMTP id e2so4140731vsc.13;
        Sat, 20 Apr 2019 07:14:37 -0700 (PDT)
X-Gm-Message-State: APjAAAUFIQHFl+wg6q7/HMdLKvq1e00ZQhhj6HT4B9urEA0dIncEGWwf
        yGW4QCjK91/H9kJ6cLFqgOsFyaCQEFgRJb0iWrk=
X-Google-Smtp-Source: APXvYqww36gq1KdQ+KC7iSzopcppAJcoTxb7AXEv95DGS0/HOLR1pj8iaUFisRy9koO7HTcCu0u7CJVWcpve3n4nbW4=
X-Received: by 2002:a67:f3c3:: with SMTP id j3mr4980795vsn.206.1555769675994;
 Sat, 20 Apr 2019 07:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190415083121.2338-1-fdmanana@kernel.org>
In-Reply-To: <20190415083121.2338-1-fdmanana@kernel.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Sat, 20 Apr 2019 14:14:25 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6j_TM+J9o9hc=oxDO+pFzQmur5ignSA3xgiUN4LoZx8Q@mail.gmail.com>
Message-ID: <CAL3q7H6j_TM+J9o9hc=oxDO+pFzQmur5ignSA3xgiUN4LoZx8Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test send with deduplication running concurrently
To:     fstests <fstests@vger.kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 9:32 AM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> Stress send running in parallel with deduplication against files that
> belong to the snapshots used by send. The goal is to hit assertion failures
> and BUG_ONs when send is running, or send finding an inconsistent snapshot
> that leads to a failure (reported in dmesg/syslog) and results in an EIO
> error returned to user space. The test needs big trees (snapshots) with
> large differences between the parent and send snapshots in order to hit
> such issues with a good probability.
>
> This currently fails in btrfs, and there is a patch for the linux kernel
> that fixes it and is titled:
>
>   "Btrfs: fix race between send and deduplication that lead to failures
>    and crashes"
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Eryu, can you please skip this patch for now? I want to do a v2,
likely next week, which tests a few more things.
Thanks.

> ---
>  tests/btrfs/186     | 247 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/186.out |   3 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 251 insertions(+)
>  create mode 100755 tests/btrfs/186
>  create mode 100644 tests/btrfs/186.out
>
> diff --git a/tests/btrfs/186 b/tests/btrfs/186
> new file mode 100755
> index 00000000..ca1a5638
> --- /dev/null
> +++ b/tests/btrfs/186
> @@ -0,0 +1,247 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FSQA Test No. 186
> +#
> +# Stress send running in parallel with deduplication against files that belong
> +# to the snapshots used by send. The goal is to hit assertion failures and
> +# BUG_ONs when send is running, or send finding an inconsistent snapshot that
> +# leads to a failure (reported in dmesg/syslog) and results in an EIO error
> +# returned to user space. The test needs big trees (snapshots) with large
> +# differences between the parent and send snapshots in order to hit such issues
> +# with a good probability.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
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
> +. ./common/attr
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch_dedupe
> +_require_attrs
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +test_log_dir=$TEST_DIR/btrfs-test-$seq
> +
> +rm -fr $test_log_dir
> +mkdir $test_log_dir
> +
> +dedupe_two_files()
> +{
> +       trap "wait; exit" SIGTERM
> +
> +       local log_file=$1
> +       local f1=$(find $SCRATCH_MNT/snap1 -type f | shuf -n 1)
> +       local f2=$(find $SCRATCH_MNT/snap2 -type f | shuf -n 1)
> +
> +       if (( RANDOM % 2 )); then
> +               local tmp=$f1
> +               f1=$f2
> +               f2=$tmp
> +       fi
> +
> +       $XFS_IO_PROG -r -c "dedupe $f1 0 0 64K" $f2 >/dev/null 2>>$log_file
> +}
> +
> +dedupe_files_loop()
> +{
> +       trap "wait; exit" SIGTERM
> +
> +       while true; do
> +               for ((i = 1; i <= 10; i++)); do
> +                       dedupe_two_files "${test_log_dir}/dedup_${i}.log" &
> +               done
> +               wait
> +       done
> +}
> +
> +full_send_loop()
> +{
> +       trap "wait; exit" SIGTERM
> +
> +       local count=$1
> +
> +       for ((i = 1; i <= $count; i++)); do
> +               local send_stream_file=$send_files_dir/full_$i.send
> +
> +               # The send command may run successfully or it might return an
> +               # error. If the error happens due to the kernel ioctl returning
> +               # -EAGAIN, it's because a concurrent deduplication is ongoing
> +               # against the same root (snapshot) send tried to work on.
> +               # We will check later (in dmesg/syslog) for errors other then
> +               # the expected one due to concurrent deduplication and for
> +               # any reported error from send other than EAGAIN.
> +               $BTRFS_UTIL_PROG send --no-data -f /dev/null $SCRATCH_MNT/snap1 \
> +                       >/dev/null 2>>$test_log_dir/full_send.log
> +       done
> +}
> +
> +inc_send_loop()
> +{
> +       trap "wait; exit" SIGTERM
> +
> +       local count=$1
> +
> +       for ((i = 1; i <= $count; i++)); do
> +               # The send command may run successfully or it might return an
> +               # error. If the error happens due to the kernel ioctl returning
> +               # -EAGAIN, it's because a concurrent deduplication is ongoing
> +               # against the same root (snapshot) send tried to work on.
> +               # We will check later (in dmesg/syslog) for errors other then
> +               # the expected one due to concurrent deduplication and for
> +               # any reported error from send other than EAGAIN.
> +               $BTRFS_UTIL_PROG send --no-data -f /dev/null \
> +                       -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2 >/dev/null \
> +                       2>>$test_log_dir/inc_send.log
> +       done
> +}
> +
> +# Number of files created before first snapshot. Must be divisable by 4.
> +nr_initial_files=50000
> +# Number of files created after the first snapshot. Must be divisable by 4.
> +nr_more_files=50000
> +
> +# Create initial files.
> +step=$((nr_initial_files / 4))
> +for ((n = 0; n < 4; n++)); do
> +       offset=$((step * $n))
> +       (
> +               for ((i = 1; i <= step; i++)); do
> +                       $XFS_IO_PROG -f -c "pwrite -S 0xea 0 64K" \
> +                               $SCRATCH_MNT/file_$((i + offset)) >/dev/null
> +               done
> +       ) &
> +       create_pids[$n]=$!
> +done
> +wait ${create_pids[@]}
> +
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1 \
> +       | _filter_scratch
> +
> +# Add some more files, so that that are substantial differences between the
> +# two test snapshots used for an incremental send later.
> +
> +# Create more files.
> +step=$((nr_more_files / 4))
> +for ((n = 0; n < 4; n++)); do
> +       offset=$((nr_initial_files + step * $n))
> +       (
> +               for ((i = 1; i <= step; i++)); do
> +                       $XFS_IO_PROG -f -c "pwrite -S 0xea 0 64K" \
> +                               $SCRATCH_MNT/file_$((i + offset)) >/dev/null
> +               done
> +       ) &
> +       create_pids[$n]=$!
> +done
> +wait ${create_pids[@]}
> +
> +# Add some xattrs to all files, so that every leaf and node of the fs tree is
> +# COWed. Adding more files does only adds leafs and nodes to the tree's right
> +# side, since inode numbers are based on a counter and form the first part
> +# (objectid) of btree keys (we only modifying the right most leaf of the tree).
> +# Use large values for the xattrs to quickly increase the height of the tree.
> +xattr_value=$(printf '%0.sX' $(seq 1 3800))
> +
> +# Split the work into 4 workers working on consecutive ranges to avoid contention
> +# on the same leafs as much as possible.
> +step=$(((nr_more_files + nr_initial_files) / 4))
> +for ((n = 0; n < 4; n++)); do
> +       offset=$((step * $n))
> +       (
> +               for ((i = 1; i <= step; i++)); do
> +                       $SETFATTR_PROG -n 'user.x1' -v $xattr_value \
> +                               $SCRATCH_MNT/file_$((i + offset))
> +               done
> +       ) &
> +       setxattr_pids[$n]=$!
> +done
> +wait ${setxattr_pids[@]}
> +
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2 \
> +       | _filter_scratch
> +
> +full_send_loop 5 &
> +full_send_pid=$!
> +
> +inc_send_loop 10 &
> +inc_send_pid=$!
> +
> +dedupe_files_loop &
> +dedupe_pid=$!
> +
> +wait $full_send_pid
> +wait $inc_send_pid
> +
> +kill $dedupe_pid
> +wait $dedupe_pid
> +
> +# Check for errors messages that happen due to inconsistent snapshot caused by
> +# deduplication running in parallel with send, causing btree nodes/leafs to
> +# disappear and getting reused while send is using them.
> +#
> +# Example messages:
> +#
> +# BTRFS error (device sdc): did not find backref in send_root. inode=63292, \
> +#     offset=0, disk_byte=5228134400 found extent=5228134400
> +#
> +# BTRFS error (device sdc): parent transid verify failed on 32243712 wanted 24 \
> +#     found 27
> +#
> +_dmesg_since_test_start | egrep -e '\bBTRFS error \(device [A-Za-z0-9]*?\): '
> +
> +# Check for errors the send ioctl returned. Only EAGAIN errors are expected,
> +# every other error is unexpected and must make the test fail.
> +
> +echo "Errors from full send operations:" >>$seqres.full
> +egrep -v -e "At subvol $SCRATCH_MNT/snap1" \
> +       -e "ERROR: send ioctl failed with -11: Resource temporarily unavailable" \
> +       $test_log_dir/full_send.log >>$seqres.full
> +if [ $? -eq 0 ]; then
> +       echo "Unexpected errors from full send operations, check $seqres.full"
> +else
> +       echo "none" >>$seqres.full
> +fi
> +
> +echo "Errors from incremental send operations:" >>$seqres.full
> +egrep -v -e "At subvol $SCRATCH_MNT/snap2" \
> +       -e "ERROR: send ioctl failed with -11: Resource temporarily unavailable" \
> +       $test_log_dir/inc_send.log >>$seqres.full
> +if [ $? -eq 0 ]; then
> +       echo "Unexpected errors from incremental send operations, check $seqres.full"
> +else
> +       echo "none" >>$seqres.full
> +fi
> +
> +# Check for errors from deduplication. Only EAGIN errors are expected.
> +echo "Errors from deduplication operations:" >>$seqres.full
> +egrep -v -e "XFS_IOC_FILE_EXTENT_SAME: Resource temporarily unavailable" \
> +       ${test_log_dir}/dedup_*.log >>$seqres.full
> +if [ $? -eq 0 ]; then
> +       echo "Unexpected errors from deduplication operations, check $seqres.full"
> +else
> +       echo "none" >>$seqres.full
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/186.out b/tests/btrfs/186.out
> new file mode 100644
> index 00000000..42bcc0e6
> --- /dev/null
> +++ b/tests/btrfs/186.out
> @@ -0,0 +1,3 @@
> +QA output created by 186
> +Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/snap1'
> +Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/snap2'
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 6b81ecce..8bfda602 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -188,3 +188,4 @@
>  183 auto quick clone compress punch
>  184 auto quick volume
>  185 auto quick send volume
> +186 auto send dedupe clone
> --
> 2.11.0
>
