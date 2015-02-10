Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:35252 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbBJRoe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 12:44:34 -0500
Received: by mail-yk0-f181.google.com with SMTP id 200so9619788ykr.12
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 09:44:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
	<pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net>
Date: Tue, 10 Feb 2015 18:44:33 +0100
Message-ID: <CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
From: "P. Remek" <p.remek1@googlemail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> What I /suspect/ is happening, is that at the 10 GiB files size, on
> original file creation, btrfs is creating a large file of several
> comparatively large extents (possibly 1 GiB each, the nominal data chunk
> size, tho it can be larger on large enough filesystems).  Note that btrfs
> will normally wait to sync, accumulating further writes into the file
> before actually writing it.  By default it's 30 seconds, but there's a
> mount option to change that.  So btrfs is probably waiting, then writing
> out all changes for the last 30 seconds at once, allowing it to use
> fairly large extents when it does so.

In the test, I use --direct=1 parameter for fio which basically does
O_DIRECT on target file. The O_DIRECT should guarantee that the
filesystem cache is bypassed and IO is sent directly to the
underlaying storage. Are you saying that btrfs buffers writes despite
of O_DIRECT?

I also tried to mount the filesystem with commit parameter set to a) 1
second and b) 1000 seconds as follows:

root@lab1:/# mount -o autodefrag,commit=1 /dev/mapper/prm-0 /mnt/vol1

It didn't chage the behavior - after about 30-40 second of running
there is a drop to 0 IOPs and lasts about 20 seconds.


> Those 70K IOPs are all the extra work the filesystem is doing in ordered
> to track those 4 KiB COWed writes!

This sounds like you are thinking that getting 70K IOPs is a bad thing
but I am testing performance which means higher IOPS = better result.
In other words, after second run when that target file already
existed, the performance improved significantly.

In the light of what you are saying it more looks like there is some
higher overhead when allocating completely new block of data for the
file compared to overhead with COW operation on already existing block
of data.



> I suppose you're already aware that you're running a rather outdated
> userspace/btrfs-progs (what I assume you meant by tools).  Userspace
> versions sync with the kernel cycle, with a particular 3.x.0 version
> typically being released a couple weeks after the kernel of the same
> version, usually with a couple 3.x.y, y-update releases following before
> the next kernel-synced x-version bump.

I was hoping that btrfs-progs doesn't have any influence on runtime
properties of the btrfs filesystem. As I am doing performance tests, I
hope that btrfs-progs version doesn't have any impact on the results.


Regards,
P.
