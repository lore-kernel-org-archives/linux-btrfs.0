Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34851 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdIAWlE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 18:41:04 -0400
Received: by mail-oi0-f48.google.com with SMTP id n18so12521034oig.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 15:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <208a4dda-0628-1e1b-1118-b8921f86fedd@gmail.com>
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
 <20170831163656.6be88191@natsu> <CAC+fKQXozVX4OsKOVxPEdRPkO=5iakEJenaxLHoaQ4FieSUmLA@mail.gmail.com>
 <437dddb7-6d3f-6ad8-7802-51b62e22d708@gmail.com> <CAC+fKQWFbdF6b3jGO_6hG_pNNzKobBYMeSNyEi5XRCf5YKa81Q@mail.gmail.com>
 <208a4dda-0628-1e1b-1118-b8921f86fedd@gmail.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Fri, 1 Sep 2017 18:41:02 -0400
Message-ID: <CAPL5yKcBp0ZeG942+5rwTbci88+dSN4uPuFe++7SeDLuw8mKpA@mail.gmail.com>
Subject: Re: mount time for big filesystems
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Juan Orti Alcaine <j.orti.alcaine@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        Roman Mamedov <rm@romanrm.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 1, 2017 at 11:20 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> No, that's not what I'm talking about.  You always get one bcache device per
> backing device, but multiple bcache devices can use the same physical cache
> device (that is, backing devices map 1:1 to bcache devices, but cache
> devices can map 1:N to bcache devices).  So, in other words, the layout I'm
> suggesting looks like this:
>
> This is actually simpler to manage for multiple reasons, and will avoid
> wasting space on the cache device because of random choices made by BTRFS
> when deciding where to read data.

Be careful with bcache - if you lose the SSD and it has dirty data on
it, your entire FS is gone.   I ended up contributing a number of
patches to the recovery tools digging my array out from that.   Even
if a single file is dirty, the new metadata tree will only exist on
the cache device, which doesn't honor barriers writing back to the
underlying storage.   That means it's likely to have a root pointing
at a metadata tree that's no longer there.  The recovery method is
finding an older root that has a complete tree, and recovery-walking
the entire FS from that.

I don't know if dm-cache honors write barriers from the cache to the
backing storage, but I would still recommend using them both in
write-through mode, not write-back.
