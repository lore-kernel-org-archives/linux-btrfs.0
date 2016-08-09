Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36414 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcHIQuL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 12:50:11 -0400
Received: by mail-oi0-f46.google.com with SMTP id f189so25278819oig.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 09:50:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <42f95b05-d0f8-55e0-4280-3865d7162469@web.de>
References: <42f95b05-d0f8-55e0-4280-3865d7162469@web.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 9 Aug 2016 10:50:09 -0600
Message-ID: <CAJCQCtQ-eqxNi0HyxyNK61KK-zsZ5XzN9+TOw2ezbwuqCVicLQ@mail.gmail.com>
Subject: Re: Issue: errno:28 (No space left on device)
To: Thomas <c.monty@web.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 9, 2016 at 3:06 AM, Thomas <c.monty@web.de> wrote:

> thomas@pc8-nb:~$ uname -a
> Linux pc8-nb 4.6.1-towo.1-siduction-amd64 #1 SMP PREEMPT siduction 4.6-1
> (2016-06-04) x86_64 GNU/Linux

Try 4.5.7 or 4.7 and see if it fixes the problem, there's a related
patch in both of those that's not yet in 4.6 series. The patch mainly
permits using existing chunks for balance to consolidate extents,
rather than requiring new chunks. So you might also have to do a
filtered balance. I would probably start with -dusage=25 and see where
that gets you.


>     Device size:                  20.53GiB
>     Device allocated:             20.53GiB

>From Btrfs perspective the volume is "fully allocated" and as such
cannot create new data or metadata chunks. Whatever workload you're
doing at the time of enospc may be filling up data or metadata unused
space in existing chunks, triggering need for newly allocated chunk,
which can't happen because there's no space left for new chunks.


> Data,single: Size:19.76GiB, Used:17.81GiB
>    /dev/sda8      19.76GiB
>
> Metadata,single: Size:776.00MiB, Used:455.73MiB
>    /dev/sda8     776.00MiB

I'll guess there's some metadata centric workload, maybe with small
files that are being stored inline, that's filling up the metadata
chunks, leading to enospc.

If changing kernel versions doesn't work, then you'll need to add more
space somehow. The file system is ~90% full anyway.


-- 
Chris Murphy
