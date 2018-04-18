Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34446 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbeDRAC4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 20:02:56 -0400
Received: by mail-vk0-f42.google.com with SMTP id m76so1267164vka.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 17:02:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+EzBbDv8GKKgSVwAYwQAn5Q3-MMz2BLUeFcjn3uv6eNBKvs5g@mail.gmail.com>
References: <CA+EzBbDv8GKKgSVwAYwQAn5Q3-MMz2BLUeFcjn3uv6eNBKvs5g@mail.gmail.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Tue, 17 Apr 2018 19:02:54 -0500
Message-ID: <CA+EzBbA=3M29LjxxgjbGHTwgR2cP78emnaZy1SqJ3hvB=O=r1g@mail.gmail.com>
Subject: Re: Hard link not persisted on fsync
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@kernel.org>
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

A gentle reminder on the crash consistency bug that we found on btrfs:
Link count of a file is not persisted even after a fsync. We believe a
filesystem that ensures strictly ordered metadata behaviour should be
able to persist the hard link after a fsync on the original file.
Could you comment on why btrfs does not exhibit this behavior, and if
it's something you'd want to fix?

Thanks,
Jayashree Mohan



On Mon, Apr 16, 2018 at 9:35 AM, Jayashree Mohan
<jayashree2912@gmail.com> wrote:
> Hi,
>
> The following seems to be a crash consistency bug on btrfs, where in
> the link count is not persisted even after a fsync on the original
> file.
>
> Consider the following workload :
> creat foo
> link (foo, A/bar)
> fsync(foo)
> ---Crash---
>
> Now, on recovery we expect the metadata of foo to be persisted i.e
> have a link count of 2. However in btrfs, the link count is 1 and file
> A/bar is not persisted. The expected behaviour would be to persist the
> dependencies of inode foo. That is to say, shouldn't fsync of foo
> persist A/bar and correctly update the link count?
> Note that ext4, xfs and f2fs recover to the correct link count of 2
> for the above workload.
>
> Let us know what you think about this behavior.
>
> Thanks,
> Jayashree Mohan
