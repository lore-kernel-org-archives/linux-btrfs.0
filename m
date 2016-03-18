Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33332 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbcCRL7r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 07:59:47 -0400
Received: by mail-oi0-f48.google.com with SMTP id d205so85918367oia.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 04:59:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458252975-1349-1-git-send-email-bo.li.liu@oracle.com>
References: <1458252975-1349-1-git-send-email-bo.li.liu@oracle.com>
Date: Fri, 18 Mar 2016 12:59:46 +0100
Message-ID: <CAHji151UcR5GV4Q-rUP8W_+Y706NohBwP8R0P8_9mBGZtjTyeQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix performance regression of writing to
 prealloc/nocow file
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(sorry for any duplicates, vger.org hates gmail)

On Thu, Mar 17, 2016 at 11:16 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> For nocow/prealloc files, we try our best to not allocate space, however,
> this ends up a huge performance regression since it's expensive to check
> if data is shared.
>
> Let's go back to only go check shared data once we're not able to allocate
> space.
>
> The test was made against a tmpfs backed loop device:
>
> xfs_io -f -c "falloc 0 400M" foobar
> xfs_io -c "pwrite -W -b 4096 0 400M" foobar
>
> Vanilla:
> wrote 419430400/419430400 bytes at offset 0
> 400 MiB, 102400 ops; 0:00:01.00 (200.015 MiB/sec and 51203.8403 ops/sec)
>
> Patched kernel:
> wrote 419430400/419430400 bytes at offset 0
> 400 MiB, 102400 ops; 0:00:01.00 (346.137 MiB/sec and 88610.9796 ops/sec)
(snip)

Doesn't this effectively do the same as

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=integration-4.6&id=4da2e26a2a32b174878744bd0f07db180c875f26

but in a slightly different way?

With a 4.4++ kernel (btrfs ~4.6) and the above patch I don't see this bad
performance (via loop on tmpfs):

$xfs_io -c "pwrite -W -b 4096 0 400M" foobar
wrote 419430400/419430400 bytes at offset 0
400 MiB, 102400 ops; 0.0000 sec (831.038 MiB/sec and 212745.6235 ops/sec)

Rewriting is even faster:

$xfs_io -c "pwrite -W -b 4096 0 400M" foobar
wrote 419430400/419430400 bytes at offset 0
400 MiB, 102400 ops; 0.0000 sec (1.124 GiB/sec and 294713.5752 ops/sec)

Looks decent enough considering the fsync.

-h
