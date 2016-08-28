Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35159 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755403AbcH1QXg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 12:23:36 -0400
Received: by mail-oi0-f44.google.com with SMTP id j203so22590655oih.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 09:23:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <17621472383031@web11m.yandex.ru>
References: <17621472383031@web11m.yandex.ru>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 28 Aug 2016 10:23:34 -0600
Message-ID: <CAJCQCtT8cjFkbg0q4pviE+dp4p93y1gPia9_kf5y4bpLH-pe8A@mail.gmail.com>
Subject: Re: Is there a performance advantage in using Btrfs subvolumes over
 raw (MBR/GPT) partitions on rotational disks?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 28, 2016 at 5:17 AM, Alexander Tomokhov <alexoundos@ya.ru> wrote:
> Let's say I use a 128GiB MBR partition for OS and remaining 800GiB+ on disk serves another purpose. Then all OS files will be physically close to each other on the disk, thus reducing seek times.
> If I use the whole disk for OS partition, then files will be spread across the disk and even OS-only operations will require hard drive heads to perform longer seeks.
>
> What effect have Btrfs subvolumes in this case if I use them instead of MBR partitions?

Writes to subvolumes doesn't directly affect where on disk the data is
written, those data extents will be put into a block group by the
allocator regardless of what subvolume the data originated from.

> Btrfs wiki says: "btrfs does write optimisation (sequential writes) across a filesystem", "subvolume write performance will benefit from this algorithm".

I'm pretty sure this means it's aggregating random writes such that
they end up being more like sequential writes, and is related to
delayed allocation. It may also be referring to the use of subvolumes
instead of directories for multiple write streams has better
concurrency handling and less contention.


-- 
Chris Murphy
