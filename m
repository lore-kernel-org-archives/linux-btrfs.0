Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33208 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcAYAGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 19:06:43 -0500
Received: by mail-lb0-f178.google.com with SMTP id x4so66313156lbm.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 16:06:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Mon, 25 Jan 2016 01:06:21 +0100
Message-ID: <CAA7pwKNoYVUYT6QzGQxiz6jW9zEPvp6DjRxBPun6Z+SpDcuUjg@mail.gmail.com>
Subject: Re: uknown issues - different sha256 hash - files corruption
To: John Smith <lenovomi@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 January 2016 at 23:00, John Smith <lenovomi@gmail.com> wrote:
>
> Dear,
>
> I have cubox-i4, running debian with 4.4 kernel. The icy box
> IB-3664SU3 enclosure is attached into cubox using esata port,
> enclosure uses JM393 and JM539 chipsets.
>
> I use btrfs volume in raid0 created from the two drives, and lvm ext4
> volume that contains two drives also. When I copy (using rsync) big
> file (the one i copied is 130GB) from ext4 to btrfs the sha256 hash is
> differs.
>
> I did 2 tests, copy the source file from ext4 to btrfs, count sha256
> hash, each time the destination file on btrfs has different hash
> compared to the source file located on ext4 and even hashes from both
> runs of target files on btrfs differs.
>
> I run cmp -l <(hexdump source_file_ext4) <(hexdump target_file_btrfs).
> The snapshot of the result is here http://paste.debian.net/367678/,
> the is so many bytes with differences. The size of the source and
> target file is exactly the same.
>
>
> I also copied around 600GB of data set that contains small files,
> music, videos, etc... and i did sha256 on all the files ext4 vs btrfs
> - all was fine.
>
> Any idea what can cause that issue or how can i debug it in more detail?

The data must have become corrupted before it was written to the btrfs
volume, since you can read it back without data checksum errors.

Try copying the big file a couple of times but from btrfs to ext4 to
see if you get data checksum errors.

Run memcheck and long SMART tests on the disks.
