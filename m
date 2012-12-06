Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37819 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424565Ab2LFTJV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 14:09:21 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so6538290obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2012 11:09:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BFB3B2.8040405@friedels.name>
References: <50BFB3B2.8040405@friedels.name>
Date: Thu, 6 Dec 2012 13:09:20 -0600
Message-ID: <CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
Subject: Re: segmentation-fault in btrfsck (git-version)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 5, 2012 at 2:50 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Dear all,
>
> thanks for developing btrfsck!
> Now, I'd like to contribute -as far as I can. I'm not a developer, but I do
> have some linux-experience.
> I've been using btrfsck on two 3TB HDDs (mirrored) for a while now under
> Kernel 3.0. Now it's corrupt. I had some hard resets of the machine -which
> might have contributed. I do have a backup of the data -at least of the
> important stuff. Some TV-Recordings are missing. The reason I am writing is,
> to support the development.
>
> Unfortunately, btrfsck (latest git-version) crashes with a segmentation
> fault, when trying to repair this.
>
> Here's the backtrace:
> root 261 inode 64375 errors 400
> root 261 inode 64376 errors 400
> btrfsck: disk-io.c:382: __commit_transaction: Assertion `!(!eb || eb->start
> != start)' failed.
>
> Program received signal SIGABRT, Aborted.
> 0x00007ffff784c425 in raise () from /lib/x86_64-linux-gnu/libc.so.6
> (gdb)
> (gdb) backtrace
> #0  0x00007ffff784c425 in raise () from /lib/x86_64-linux-gnu/libc.so.6
> #1  0x00007ffff784fb8b in abort () from /lib/x86_64-linux-gnu/libc.so.6
> #2  0x00007ffff78450ee in ?? () from /lib/x86_64-linux-gnu/libc.so.6
> #3  0x00007ffff7845192 in __assert_fail () from
> /lib/x86_64-linux-gnu/libc.so.6
> #4  0x000000000040d3ae in __commit_transaction (trans=0x62e010,
> root=0xb66ae0) at disk-io.c:382
> #5  0x000000000040d4d8 in btrfs_commit_transaction (trans=0x62e010,
> root=0xb66ae0) at disk-io.c:415
> #6  0x000000000040743d in main (ac=<optimized out>, av=<optimized out>) at
> btrfsck.c:3587
>
>
> Now, here's where my debugging knowledge ends. Are you interested in
> debugging this further, or is it a known bug?
>

Line 382 in disk-io.c is:

BUG_ON(!eb || eb->start != start);

So, basically, btrfsck is intentionally crashing because it doesn't
know how to handle this condition.

Future refinements of btrfsck will probably include proper error
messages for issues that can't be handled, or perhaps even fix the
error.

It might be interesting for you to try a newer kernel, and use scrub
on this volume if you have the two disks RAIDed.
