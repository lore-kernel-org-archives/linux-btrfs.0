Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:49309 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756144AbdKOCrb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 21:47:31 -0500
Received: by mail-oi0-f50.google.com with SMTP id r190so6083749oie.6
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 18:47:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 14 Nov 2017 19:47:29 -0700
Message-ID: <CAJCQCtR5yEgcaACk0KK3bqFj3uhP8qcRVbtuoLUp02M14QVc4Q@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Klaus Agnoletti <klaus@agnoletti.dk>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 1:36 AM, Klaus Agnoletti <klaus@agnoletti.dk> wrote:

> Btrfs v3.17

Unrelated to the problem but this is pretty old.


> Linux box 3.16.0-4-amd64 #1 SMP Debian 3.16.43-2+deb8u5 (2017-09-19)

Also pretty old kernel.


> x86_64 GNU/Linux
> klaus@box:~$ sudo btrfs --version
> Btrfs v3.17
> klaus@box:~$ sudo btrfs fi df /mnt
> Data, RAID0: total=5.34TiB, used=5.14TiB
> System, RAID0: total=96.00MiB, used=384.00KiB
> Metadata, RAID0: total=7.22GiB, used=5.82GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B


The central two problems: failing hardware, and no copies of metadata.
By default, mkfs.btrfs does -draid0 -mraid1 for multiple device
volumes. Explicitly making metadata raid0 basically means it's a
disposable file system the instant there's a problem.

What do you get for
smartctl -l scterc /dev/

If you're lucky, this is really short. If it is something like 7
seconds, there's a chance the data in this sector can be recovered
with a longer recovery time set by the drive *and* also setting the
kernel's SCSI command timer to a value higher than 30 seconds (to
match whatever you pick for the drive's error timeout). I'd pull
something out of my ass like 60 seconds, or hell why not 120 seconds,
for both. Maybe then there won't be a UNC error and you can quickly
catch up your backups at the least.

But before trying device removal again, assuming changing the error
timeout to be higher is possible, the first thing I'd do is convert
metadata to raid1. Then remove the bad device.


-- 
Chris Murphy
