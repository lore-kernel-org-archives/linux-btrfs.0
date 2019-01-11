Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EBBC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 10:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66D322177B
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 10:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RlWq3wfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbfAKKiL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 05:38:11 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43543 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729173AbfAKKiK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 05:38:10 -0500
Received: by mail-vs1-f66.google.com with SMTP id x1so8892994vsc.10;
        Fri, 11 Jan 2019 02:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=vFl7fuFZSjd24vwRqqfAk64m2cw96FcwCj6HHwIBcAc=;
        b=RlWq3wfjrg1KtyI0/hUrtqNVvcshDxGGjNxucZz3LNTTl7r1tKZwGBB1FF+QiqTnov
         UG3XaBc37PITh1L/nExBaS+2qVV8sqaX3kDSB6PLy2iFdUKWZR/zZm8RPrXbdyfY50Kx
         fEVxUQv22lGcyvh2YCOhqlQddVMXLjrZRhPuVigm/aR9XPj13AjaA7Rqo9GMhx9JIX+a
         u8CXMOESbhBxGqwYpCgbuXJrBkKJvN3HtPYnIbu3c1R1RCDuyLdExnkngbZ2G0sLlv+W
         i+5jKOertufXH372sAsjTF9kO+omP2sEN9yJsQabr9KHR5hqQHGzSqWbNs7K5YHowHJe
         Sd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=vFl7fuFZSjd24vwRqqfAk64m2cw96FcwCj6HHwIBcAc=;
        b=RmL2P5IVJrfB8mjmCdd4q3Xx8UdoXxmx59zv1Kw0lqRnxrc8TKqLzM8JAeYPZGgPBj
         3zjCRukaG3jLV6Giak0rlizxXQxwq4mAmLDnucY8u+86efCndXi/9Nn8TTWyxYXCX2if
         be8Dcf/oZOXASuaixvTqIhCDprHelAqj+4QMVo6cMq/W1UxVmzdche3T8qpLut7PU8SB
         4tnTApmLTn8jKu9CE7jW9Qe9s0oOHCWrnyrIzJIASb+XX9VNkG920BhCzv+pkwZVK4jO
         DtACj7gx06s3ZQgLrw8XZkHNTkbiKK3gpVrp1GFiIrRzfmcmCCjHySqLskB2GjqooLbg
         Xpaw==
X-Gm-Message-State: AJcUukdBzsZTNo3rL5TAOAJteXCVaHezI0r4jlHzx5/g0lzLtkW62Icj
        79qO/RNYjw348Y99sMGhiwYtcAxWAIGwGCDPCUh0PQ==
X-Google-Smtp-Source: ALg8bN5qobjc8En2NcPWubY3w4rZ/ciKxsiW/1jNWnP6xgk2BnGC7e8janBA6cWMvj6u/zUkRtGjK4Y02FXvfcMTvhg=
X-Received: by 2002:a67:c806:: with SMTP id u6mr5775646vsk.206.1547203088258;
 Fri, 11 Jan 2019 02:38:08 -0800 (PST)
MIME-Version: 1.0
References: <20190111050151.982-1-wqu@suse.com>
In-Reply-To: <20190111050151.982-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 11 Jan 2019 10:37:57 +0000
Message-ID: <CAL3q7H6a__fmUhaWvMsgAtOGF2wGkTBgHNDo_zMBuJZ4AdgUQQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 11, 2019 at 5:38 AM Qu Wenruo <wqu@suse.com> wrote:
>
> Commit fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting
> time out of commit trans") could cause ABBA deadlock between backref
> lookup with write lock hold (subvolume deletion) and other read/write
> operations.
>
> It's going to be fixed by "btrfs: qgroup: Don't trigger backref walk at
> delayed ref insert time".
>
> This test will generate pwrite background workload, along with
> constant subvolume creation and deletion to trigger the bug.
>
> It needs some time to generate enough files to bump the tree height to
> trigger the bug.
> In my test environment, with 'unsafe' cache mode for the VM, it triggers
> the bug at around 70~90 seconds. So I leave the default runtime to 120s
> to make sure the bug will be triggered.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
> changelog:
> v2:
> - Commit message grammar fix.
> - Remove unnecessary comment about how the bug is triggered.
> - Use better signal handle to avoid -EBUSY at umount.
> ---
>  tests/btrfs/179     | 116 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/179.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 119 insertions(+)
>  create mode 100755 tests/btrfs/179
>  create mode 100644 tests/btrfs/179.out
>
> diff --git a/tests/btrfs/179 b/tests/btrfs/179
> new file mode 100755
> index 000000000000..4a24ea419a7e
> --- /dev/null
> +++ b/tests/btrfs/179
> @@ -0,0 +1,116 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test 179
> +#
> +# Test if btrfs will lockup at subvolume deletion when qgroups are enabl=
ed.
> +#
> +# This bug is going to be fixed by a patch for the kernel titled
> +# "btrfs: qgroup: Don't trigger backref walk at delayed ref insert time"=
.
> +#
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D1       # failure is the default!
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
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +# default sleep interval
> +sleep_time=3D1
> +
> +# stress test runtime
> +runtime=3D120
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +mkdir -p "$SCRATCH_MNT/snapshots"
> +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/src" > /dev/null
> +$BTRFS_UTIL_PROG quota enable "$SCRATCH_MNT" > /dev/null
> +$BTRFS_UTIL_PROG quota rescan -w "$SCRATCH_MNT" > /dev/null
> +
> +fill_workload()
> +{
> +       trap "wait; exit" SIGTERM
> +       local i=3D0
> +       while true; do
> +               _pwrite_byte 0xcd 0 8K "$SCRATCH_MNT/src/large_$i" > /dev=
/null
> +               _pwrite_byte 0xcd 0 2K "$SCRATCH_MNT/src/inline_$i" > /de=
v/null
> +
> +               # Randomly remove some files for every 5 loop
> +               if [ $(( $i % 5 )) -eq 0 ]; then
> +                       victim=3D$(ls "$SCRATCH_MNT/src" | sort -R | head=
 -n1)
> +                       rm "$SCRATCH_MNT/src/$victim"
> +               fi
> +               i=3D$((i + 1))
> +       done
> +}
> +
> +snapshot_workload()
> +{
> +       trap "wait; exit" SIGTERM
> +       local i=3D0
> +       while true; do
> +               sleep $sleep_time
> +               $BTRFS_UTIL_PROG subvolume snapshot "$SCRATCH_MNT/src" \
> +                       "$SCRATCH_MNT/snapshots/$i" > /dev/null
> +               i=3D$((i + 1))
> +       done
> +}
> +
> +delete_workload()
> +{
> +       trap "wait; exit" SIGTERM
> +       while true; do
> +               sleep $((sleep_time * 2))
> +               victim=3D$(ls "$SCRATCH_MNT/snapshots" | sort -R | head -=
n1)
> +               $BTRFS_UTIL_PROG subvolume delete \
> +                       "$SCRATCH_MNT/snapshots/$victim" > /dev/null
> +       done
> +}
> +
> +fill_workload &
> +fill_pid=3D$!
> +
> +sleep $((sleep_time * 2))
> +snapshot_workload &
> +snapshot_pid=3D$!
> +delete_workload &
> +delete_pid=3D$!
> +
> +sleep $runtime
> +kill $fill_pid
> +wait $fill_pid
> +kill $snapshot_pid
> +wait $snapshot_pid
> +kill $delete_pid
> +wait $delete_pid
> +
> +# success, all done
> +echo "Silence is golden"
> +
> +status=3D0
> +exit
> diff --git a/tests/btrfs/179.out b/tests/btrfs/179.out
> new file mode 100644
> index 000000000000..cb9eba3d34b1
> --- /dev/null
> +++ b/tests/btrfs/179.out
> @@ -0,0 +1,2 @@
> +QA output created by 179
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 04c0254aa4bf..46dd3c9523c2 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -181,3 +181,4 @@
>  176 auto quick swap volume
>  177 auto quick swap balance
>  178 auto quick send
> +179 auto qgroup dangerous
> --
> 2.20.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
