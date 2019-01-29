Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBB0C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 11:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D10AC20880
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 11:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxrRG0JD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfA2L0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 06:26:16 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:46139 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfA2L0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 06:26:15 -0500
Received: by mail-vs1-f65.google.com with SMTP id n10so11698624vso.13;
        Tue, 29 Jan 2019 03:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=lexXILQwQ0zzUEkPB9adLP6pWSMwqNPMM+YJjEPxpWk=;
        b=FxrRG0JDXoWu5fE8RSVbrYbOiLmTAsPsqHNw8Tm2AezHyuozlxUeAZSuUXwnZFcHoW
         gQ7l1kBjPAzpd9eiIOhFUG1VK1ySygq2WU3GeddfPaKP1Cf4UkpTr3PtJcouATpzcOte
         HgQ/nfXNdqh3bQuHzDD4LNnUSTn+nqOm0N0aCLkFR6yctEK5PhNb03fryKtkC2mLEblN
         TKGxHP9f7tPIJDoxmGvyPT9PTRT1zb/3pEUe3YFRwGm8s5K73LnVNwq2Qh/vS0YYxPBo
         tA0r9WI84CFW6DdVV926Vk2KdDHF8wEH9GbZ/76+tZfXmjli0qrEon25kbkhU+5zWzdv
         HXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=lexXILQwQ0zzUEkPB9adLP6pWSMwqNPMM+YJjEPxpWk=;
        b=OoQljJtJUmGx1PUifwlA+m7MSSpU8zZiBzvk+tbdrwqEoELf6teY5Jub/aPP4f33ga
         zxHuh/b2cMhXpZZbiGZ34n4qQKf+1KGF99LSFZOP3dOe4BMTZ4w4EAl37LQZEpKBPEh8
         DsXajDqXo3Ak7l8mlXoSvKcUvjlcFyirjM+iP0mQFbGkNMUFyPd2d5cRHap53SZNXdrs
         wVeim5eknK/xXoTsGb7kQRGEvf2zvIxRLrsO/0qZAYxZ9ZAZz6tLnXEqT2W3Xm62NLcs
         +Od3r95k8veZHnaGeDeh4NGHwTGsVTRZ8/DLJb+Bm6x5p0ZtXgU3Gz9qmFsnxOf1NXri
         c3dQ==
X-Gm-Message-State: AJcUuke+eeThutSFm0zDKeyNPyLgoJvUTciFnXLlrOnxS1C7CBlUmbfC
        QgB/L0gbPq0sbmU6MuujC314nIkaqof2YCAWq1DWQYbR
X-Google-Smtp-Source: ALg8bN750Hh+McrGInlcO3+sJdGpJbPIDnvxDyxllngi9aVxO2TxX3N+b8HxxnLVmrYXXEUfDGoncMVaF3gk9SekPmA=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr8737488vsa.99.1548761174246;
 Tue, 29 Jan 2019 03:26:14 -0800 (PST)
MIME-Version: 1.0
References: <20190129072749.494-1-wqu@suse.com>
In-Reply-To: <20190129072749.494-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 29 Jan 2019 11:26:03 +0000
Message-ID: <CAL3q7H7OvdJ0jub_nnUc_VYzDGc+mLfs5Q6-bLn4MdSFaOBGOw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Test if btrfs will report false ENOSPC error
 balnacing small metadata chunk
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 29, 2019 at 7:28 AM Qu Wenruo <wqu@suse.com> wrote:
>
> This is a long existing bug, caused by over-estimated metadata
> space_info::bytes_may_use.

Nop, this is a test case :)
The sentence should be more like "This is a test case for a long
existing bug, ...".

>
> There is one purposed patch for btrfs-progs to fix it, titled:

purposed -> proposed

> "btrfs-progs: balance: Sync the fs before balancing metadata chunks"
>
> The test case itself is almost the same as btrfs/181, which use small

use -> uses

> files to bump a reserved space to trigger the false alert.

a -> the

Also, for the subject, there's the typo "balnacing".

>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/182     | 60 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/182.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 63 insertions(+)
>  create mode 100755 tests/btrfs/182
>  create mode 100644 tests/btrfs/182.out
>
> diff --git a/tests/btrfs/182 b/tests/btrfs/182
> new file mode 100755
> index 00000000..61efcb9e
> --- /dev/null
> +++ b/tests/btrfs/182
> @@ -0,0 +1,60 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test 182
> +#
> +# Test if balance will report false ENOSPC error
> +#
> +# This is a long existing bug, caused by over-estimated metadata
> +# space_info::bytes_may_use.
> +# There is one purposed patch for btrfs-progs to fix it, titled:

purposed -> proposed

> +# "btrfs-progs: balance: Sync the fs before balancing metadata chunks"
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
> +nr_files=3D1024
> +
> +_scratch_mkfs > /dev/null
> +_scratch_mount
> +
> +$BTRFS_UTIL_PROG subv create "$SCRATCH_MNT/subvol" > /dev/null

subv -> subvolume

We always prefer full command names.

Other than that, it looks good.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> +
> +# Create some small files to take up enough metadata reserved space
> +for ((i =3D 0; i < $nr_files; i++)) do
> +       _pwrite_byte 0xcd 0 1K "$SCRATCH_MNT/subvol/file_$i" > /dev/null
> +done
> +
> +$BTRFS_UTIL_PROG balance start -m "$SCRATCH_MNT" > /dev/null
> +
> +# success, all done
> +echo "Silence is golden"
> +status=3D0
> +exit
> diff --git a/tests/btrfs/182.out b/tests/btrfs/182.out
> new file mode 100644
> index 00000000..53d28e50
> --- /dev/null
> +++ b/tests/btrfs/182.out
> @@ -0,0 +1,2 @@
> +QA output created by 182
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 0db485cb..e32c84e4 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -184,3 +184,4 @@
>  179 auto qgroup dangerous
>  180 auto quick qgroup limit
>  181 auto quick balance
> +182 auto quick balance
> --
> 2.18.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
