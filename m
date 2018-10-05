Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267BCC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 07:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF0F420645
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 07:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqu49y9a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF0F420645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbeJEOsf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:48:35 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:39995 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbeJEOsf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 10:48:35 -0400
Received: by mail-vk1-f194.google.com with SMTP id h20-v6so90126vke.7;
        Fri, 05 Oct 2018 00:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=OFaSISFePclcgna/voQG+cYCatF79KJFjPqyPf1dOGg=;
        b=aqu49y9a2uXQYefsYJyValzNITemxqRsxNG8aSdYyKbry2CrJB4eAkR5kEvp1kS+Zp
         KH/MItHqjgh2FEjg/6Gv1MTGSFqTjgTPu61oYMmTNKP6FcJ0gVw3JfyNOdxixtENcaHl
         xNdOZCJ4TmU74pPYGe+NLwy0fMAvNh/10IpEzj1iA1CTP2g5QiauSP9LbGWToyoNhkT1
         m00psy1R2i/8ZNSeyGe/SaqgKteOKwjTkHAXVBhb5GqwwhcWoqMjnKS57U3bxjNNI93h
         mWTeccFBDdrbcavfRCyFrOAVmsDuLr5Hhycv/YwBbNx+GfA8iaSVmeue4B/onVXZXhoT
         XgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=OFaSISFePclcgna/voQG+cYCatF79KJFjPqyPf1dOGg=;
        b=iFdM9jZRfBPGLl6GqwxhgJDJQ1iJCkBaLeJlk0+zSfxxRvllUiU8YOYMwqXzN8ReYI
         k9hEmF1g0BLmqurLV9HkHj0EB2gm/+i4+N/Uv9RcvXLrZtma460LhyHMP93KtqXOMeBh
         qJ2V5+eagTmbn6mDEaC6I+Sz3ILC1VLk1bfqWIP7/1DoElxBXEQq7WVrK+Kle8LU1kJ3
         yQS9STD3GVnssoR9i1DBDLCM+FiljGSM1dwJ+hBk61ax2EJIc6TcZ9/dLzeC5CPHV72g
         pnEvePIWUkXXpFOb93haY5LlBilrJSZ6lJSYYRmOxn88PvQJVnksMOeSissn/R+kgZDE
         iR/w==
X-Gm-Message-State: ABuFfojPPzFpd2060hcEqYxQ954mGpmn+aZ/iFROyss/UGbMBz+TlRTM
        /7AJ9Ly98mSim5yT8x6G9pkygz35RMQvH3SRCwg=
X-Google-Smtp-Source: ACcGV62ysKHNsHoWLjOLqqCE9MZ7s2Y3WVN5JZWX5IWPTNiLgGocz1XZfC/s7jNbg3UuMLjip8QDuOJRRn7VFXCyJnk=
X-Received: by 2002:a1f:280c:: with SMTP id o12-v6mr3928909vko.4.1538725863118;
 Fri, 05 Oct 2018 00:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <1538146248-1759-1-git-send-email-anand.jain@oracle.com> <1538271592-4086-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1538271592-4086-1-git-send-email-anand.jain@oracle.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 5 Oct 2018 08:50:51 +0100
Message-ID: <CAL3q7H5P7cOWGOj+MwSookeRDm=ZGSR+pLBbX-nC32x632xr7w@mail.gmail.com>
Subject: Re: [PATCH v6] test unaligned punch hole at ENOSPC
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Sep 30, 2018 at 2:40 AM Anand Jain <anand.jain@oracle.com> wrote:
>
> Try to punch hole with unaligned size and offset when the FS is
> full. Mainly holes are punched at locations which are unaligned
> with the file extent boundaries when the FS is full by data.
> As the punching holes at unaligned location will involve
> truncating blocks instead of just dropping the extents, it shall
> involve reserving data and metadata space for delalloc and so data
> alloc fails as the FS is full.
>
> btrfs_punch_hole()
>  btrfs_truncate_block()
>    btrfs_check_data_free_space() <-- ENOSPC
>
> We don't fail punch hole if the holes are aligned with the file
> extent boundaries as it shall involve just dropping the related
> extents, without truncating data extent blocks.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks!

> ---
> v5->v6:
>  fix comments at two places in the test case
>  drop -f when using xfs_io to punch hole
>  sync after dd is dropped
>  change log is slightly updated
> v4->v5:
>  Update the change log
>  Drop the directio option for xfs_io
> v3->v4:
>  Add to the group punch
> v2->v3:
>  Add _require_xfs_io_command "fpunch"
>  Add more logs to $seqfull.full
>    mount options and
>    group profile info
>  Add sync after dd upto ENOSPC
>  Drop fallocate -p and use xfs_io punch to create holes
>  Use a testfile instead of filler file so that easy to trace
> v1->v2: Use at least 256MB to test.
> This test case fails on btrfs as of now.
>  tests/btrfs/172     | 73 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/btrfs/172.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 76 insertions(+)
>  create mode 100755 tests/btrfs/172
>  create mode 100644 tests/btrfs/172.out
>
> diff --git a/tests/btrfs/172 b/tests/btrfs/172
> new file mode 100755
> index 000000000000..0dffb2dff40b
> --- /dev/null
> +++ b/tests/btrfs/172
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Oracle. All Rights Reserved.
> +#
> +# FS QA Test 172
> +#
> +# Test if the unaligned (by size and offset) punch hole is successful wh=
en FS
> +# is at ENOSPC.
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
> +_require_xfs_io_command "fpunch"
> +
> +_scratch_mkfs_sized $((256 * 1024 *1024)) >> $seqres.full
> +
> +# max_inline ensures data is not inlined within metadata extents
> +_scratch_mount "-o max_inline=3D0,nodatacow"
> +
> +cat /proc/self/mounts | grep $SCRATCH_DEV >> $seqres.full
> +$BTRFS_UTIL_PROG filesystem df $SCRATCH_MNT >> $seqres.full
> +
> +extent_size=3D$(_scratch_btrfs_sectorsize)
> +unalign_by=3D512
> +echo extent_size=3D$extent_size unalign_by=3D$unalign_by >> $seqres.full
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 $((extent_size * 10))" \
> +                                       $SCRATCH_MNT/testfile >> $seqres.=
full
> +
> +echo "Fill all space available for data and all unallocated space." >> $=
seqres.full
> +dd status=3Dnone if=3D/dev/zero of=3D$SCRATCH_MNT/filler bs=3D512 >> $se=
qres.full 2>&1
> +
> +hole_offset=3D0
> +hole_len=3D$unalign_by
> +$XFS_IO_PROG -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> +
> +hole_offset=3D$(($extent_size + $unalign_by))
> +hole_len=3D$(($extent_size - $unalign_by))
> +$XFS_IO_PROG -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> +
> +hole_offset=3D$(($extent_size * 2 + $unalign_by))
> +hole_len=3D$(($extent_size * 5))
> +$XFS_IO_PROG -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> +
> +# success, all done
> +echo "Silence is golden"
> +status=3D0
> +exit
> diff --git a/tests/btrfs/172.out b/tests/btrfs/172.out
> new file mode 100644
> index 000000000000..ce2de3f0d107
> --- /dev/null
> +++ b/tests/btrfs/172.out
> @@ -0,0 +1,2 @@
> +QA output created by 172
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index feffc45b6564..45782565c3b7 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -174,3 +174,4 @@
>  169 auto quick send
>  170 auto quick snapshot
>  171 auto quick qgroup
> +172 auto quick punch
> --
> 1.8.3.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
