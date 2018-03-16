Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:41624 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbeCPSUK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 14:20:10 -0400
Received: by mail-io0-f172.google.com with SMTP id m83so13633502ioi.8
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 11:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180314150311.20152-1-enadolski@suse.com>
References: <20180314150311.20152-1-enadolski@suse.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Fri, 16 Mar 2018 11:20:09 -0700
Message-ID: <CANQeFDA5Mgf1mynS-kwDMStLpot_ObxmPd7JOXZ2FmCKww4yyA@mail.gmail.com>
Subject: Re: [PATCH] missing initialization in btrfs_check_shared
To: Edmund Nadolski <enadolski@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 8:03 AM, Edmund Nadolski <enadolski@suse.com> wrote:
> This patch addresses an issue that causes fiemap to falsely
> report a shared extent.  The test case is as follows:
>
> # cat do_xfs_io
> xfs_io -f -d -c "pwrite -b 16k 0 64k" -c "fiemap -v" /media/scratch/file5
> sync
> xfs_io  -c "fiemap -v" /media/scratch/file5
>
> which gives the resulting output:
>
> # . do_xfs_io
> wrote 65536/65536 bytes at offset 0
> 64 KiB, 4 ops; 0.0000 sec (121.359 MiB/sec and 7766.9903 ops/sec)
> /media/scratch/file5:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        24576..24703       128 0x2001
> /media/scratch/file5:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        24576..24703       128   0x1
>
> This is because btrfs_check_shared calls find_parent_nodes
> repeatedly in a loop, passing a share_check struct to report
> the count of shared extent. But btrfs_check_shared does not
> re-initialize the count value to zero for subsequent calls
> from the loop, resulting in a false share count value. This
> is a regressive behavior from 4.13.
>
> With proper re-initialization the test result is as follows:
>
> # . do_xfs_io
> wrote 65536/65536 bytes at offset 0
> 64 KiB, 4 ops; 0.0000 sec (110.035 MiB/sec and 7042.2535 ops/sec)
> /media/scratch/file5:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        24576..24703       128   0x1
> /media/scratch/file5:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        24576..24703       128   0x1
>
> which corrects the regression.
>

A fstest case for this would be appreciated.

thanks,
liubo
