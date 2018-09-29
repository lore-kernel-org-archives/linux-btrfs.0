Return-Path: <SRS0=t/Of=ML=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E44C43143
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Sep 2018 16:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E13620895
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Sep 2018 16:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="le/pRoic"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E13620895
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbeI2XKC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Sep 2018 19:10:02 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:46137 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbeI2XKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Sep 2018 19:10:02 -0400
Received: by mail-vk1-f194.google.com with SMTP id b14-v6so2084676vke.13;
        Sat, 29 Sep 2018 09:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=wCMMVAOFUfPz2AqUhBqfKiQn9rzFmZ3mt99mCKMpe14=;
        b=le/pRoicHrkuoV8JDoXzlHhxRJ/1jfx1Eja0otUhuXblYzSicIW+ROT+ga9xDt4jZo
         Qb7z153h/dwqGkEkcf38tsvDzKIz2NBmHrRcJsmbB0l3bXinTE6qSobejEDci6jmCdG3
         l56wETh5bznt60Z+OC0/gD0s2LjtKeIP4umMfoBhvyNgch4wAYAqAEorm69V8APYZNN5
         Xa4dRMUWG4ZLRsZZZYVF4cNBKkx76CemxR4IiwC0HTvBZ9m4JwH8gEp05BW+9av4vHts
         PRqrUVjSQ5rHo/I4sv09qBEjY8pa04f7H0jfbQBhSHwAU4HcU8a8jzcUcwAc012TGRXe
         hN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=wCMMVAOFUfPz2AqUhBqfKiQn9rzFmZ3mt99mCKMpe14=;
        b=NCLp5pvIq/3z8XQul+3nMWc3HLQ1EhgAPD1yr9yCAqsbK8o04hfiZ64mbJsB6fl/9S
         mV1nzUTc448r1gid9e0qbIjborhH48NC8sO5S6Rh2VBiH1qqFtQhxRqGEN28hJ9h9Ui8
         2/bNLBvXXToBbWSMVhGmluiqYBQMaqFpphaj4/yBZvD5acTtlylS7yfYaaGZjdEqeGXp
         aAvFz5BHVqep8vKgdmccmVDvtlVVo1nmAF2eoVfQhJFBtfA5bFOwAa8bAgHUSa7SsHr6
         gzZdjEqxs0DSj+1LbbGVkgSLJar8vmBYx3EIu4CkkA8U6QgLGJqynDcZkDl5xd51oE7Y
         WV5A==
X-Gm-Message-State: ABuFfoiYIRrNllkMbGcSuhhx3yXRKUHKBVsaEhV2O4Pz/1DrXLGr5hot
        3Dk0GyFDTgDx9UAB1F81wmAPm66Ae1YfENG8ylioXg==
X-Google-Smtp-Source: ACcGV61nBNQWM8q4WxUFu/pIlpuh4RJh4HrAEwI4yobCgXeG+mq45K6OA0uWXvCU5YX3Sayt57YiKlwizLDLRX/kAhI=
X-Received: by 2002:a1f:e847:: with SMTP id f68-v6mr1354944vkh.31.1538239256764;
 Sat, 29 Sep 2018 09:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <1538146248-1759-1-git-send-email-anand.jain@oracle.com> <1538182287-9297-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1538182287-9297-1-git-send-email-anand.jain@oracle.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Sat, 29 Sep 2018 17:40:45 +0100
Message-ID: <CAL3q7H5psaV-gXWRykvhvTdV8m7EtZi=O-x4-fepcpS1p7HNpQ@mail.gmail.com>
Subject: Re: [PATCH v5] test unaligned punch hole at ENOSPC
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Sep 29, 2018 at 1:52 AM Anand Jain <anand.jain@oracle.com> wrote:
>
> Try to punch hole with unaligned size and offset when the FS is
> full. Mainly holes are punched at locations which are unaligned
> with the file extent boundaries when the FS is full by data.
> As the punching holes at unaligned location will involve
> truncating blocks instead of just dropping the extents, it shall
> involve reserving data and metadata space for delalloc and data
> alloc fails as the FS is full.
>
> btrfs_punch_hole()
>  btrfs_truncate_block()
>    btrfs_check_data_free_space() <-- ENOSPC
>
> We don't fail punch hole if the holes are aligned with the file
> extent boundaries as it shall involve just dropping the related
> extents.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4->v5:
>  Update the change log
>  Drop the directio option for xfs_io

Except for the direct IO and change log, all my previous comments and
questions weren't addressed/ answered.
Thanks.

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
>  tests/btrfs/172     | 74 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/btrfs/172.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 77 insertions(+)
>  create mode 100755 tests/btrfs/172
>  create mode 100644 tests/btrfs/172.out
>
> diff --git a/tests/btrfs/172 b/tests/btrfs/172
> new file mode 100755
> index 000000000000..1ecf01d862a2
> --- /dev/null
> +++ b/tests/btrfs/172
> @@ -0,0 +1,74 @@
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
> +# max_inline helps to create regular extent
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
> +echo "Fill fs upto ENOSPC" >> $seqres.full
> +dd status=3Dnone if=3D/dev/zero of=3D$SCRATCH_MNT/filler bs=3D512 >> $se=
qres.full 2>&1
> +sync
> +
> +hole_offset=3D0
> +hole_len=3D$unalign_by
> +$XFS_IO_PROG -f -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> +
> +hole_offset=3D$(($extent_size + $unalign_by))
> +hole_len=3D$(($extent_size - $unalign_by))
> +$XFS_IO_PROG -f -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
> +
> +hole_offset=3D$(($extent_size * 2 + $unalign_by))
> +hole_len=3D$(($extent_size * 5))
> +$XFS_IO_PROG -f -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
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
