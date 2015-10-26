Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33273 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbJZUU0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 16:20:26 -0400
Received: by lbbec13 with SMTP id ec13so46932105lbb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 13:20:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAvdE8RJc2eOR0ePdpWaqEeOzHx5xqr5gr0z7sE+cEcuHKhN3A@mail.gmail.com>
References: <CAAvdE8RJc2eOR0ePdpWaqEeOzHx5xqr5gr0z7sE+cEcuHKhN3A@mail.gmail.com>
Date: Mon, 26 Oct 2015 21:20:24 +0100
Message-ID: <CAPmG0jYRvLnkZG9-+aJdBr+6GphCob5rEi9qibAYa3V=kSOFEw@mail.gmail.com>
Subject: Re: BTRFS with 8TB SMR drives
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I decided to give this ST8000AS0002 a try for storing old snapshots,
although standardization for more optimal/native contol of SMR drives
is still ongoing.  I saw people got it working with 3.18 kernel, so
that gave confidence.

I wanted to see if i could get it running with 4.3.0-rc6 kernel (and
4.2.3 tools) on an H87M-Pro eSata (non-Intel) port. Filesystem is
btrfs all single profiles on top of dm-crypt and mounted with
compress-force=zlib,nossd (I use the drive via bcache but currently
with not attached to a cache device). The initial snapshot send |
receive action crashed after 1.2TB transferred, with all the
typical/known problems in dmesg

Then same trial, newly created fs, on 1 of the Intel sata ports. Also
the same timeouts seen in dmesg, but fs already corrupted after a few
GB of datatransfer. It seemed  that the drive was not able to handle
and store the filesystemdatastream that was being pushed onto it.

So I did  some step back and just created an ext4 on it and did and
rsync copy.Unfortunately, also the same timouts, port resets etc.

As the drive made the main system unstable, I hooked it up to an AMD
E-350 based board, also to try other kernels. Also on this board, no
success with 4.x kernels and also not with 3.18.22 in the first place.
But I figured out that a powercycle did the trick and not just a hard-
or softreset. So again created fs from scratch and mounted as
indicated.


Now it is 55% filled (3.9TiB) with 10 snapshots (done as increments
from the source fs from late 2013, with uncompressed allocation of
about 5.6 TiB). The whole datatransfer took about 4 days, which is
roughly 10x slower than what would be achieved if the drive were
non-SMR and in a fast (e.g. Core i7) system.

Although the task below took more than 8 minutes:
[322087.174089] Workqueue: events_unbound
btrfs_async_reclaim_metadata_space [btrfs]
... the fs and system runs OK.

My take is that this relatively low average datatransfer (one reason I
forced zlib compression) helped getting the task done successfully for
this device-managed SMR drive, but it is unsatisfying that there are
kernel version and computerystem dependencies. I had limited time for
preparing and setting up the datatransfer, so other configurations
with new kernels might also work, but I had most confidence upfront in
the one that has turned out to work. Maybe now that all data is on the
drive, I shrink the fs and create a test fs in a second partition.

On Sat, Oct 24, 2015 at 5:27 AM, Ken Long <kelargo1000@gmail.com> wrote:
> Hello,
>
> I have a a single version of this drive formatted with btrfs. Its my
> only btrfs drive on this machine.
> I'm getting similar errors. Is there any info I can provide to help
> troubleshoot this?
>
> Is a full dmesg still wanted?
>
> here's what I'm running-
>
> $ uname -a
> Linux machine 4.2.0-16-lowlatency #19-Ubuntu SMP PREEMPT Thu Oct 8
> 16:19:23 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
