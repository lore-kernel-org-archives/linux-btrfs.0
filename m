Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35945 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752299AbcIIT2r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 15:28:47 -0400
Received: by mail-oi0-f47.google.com with SMTP id q188so45833469oia.3
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Sep 2016 12:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com> <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 9 Sep 2016 13:28:45 -0600
Message-ID: <CAJCQCtQpfJ9eji_KrNMsRkgEP=psL_PQc+nsPNJY8qAYey60VA@mail.gmail.com>
Subject: Re: btrfs kernel oops on mount
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: moparisthebest <admin@moparisthebest.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 9, 2016 at 12:47 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> The output from btrfs fi show and fi df both indicate that the filesystem is
> essentially completely full.

?What am I missing?

https://www.moparisthebest.com/btrfs/btrfsfishow.txt

There's thousands of GiB's totally unallocated. Just taking the last
two devices:

devid   13 size 3.64TiB used 3.04TiB path /dev/mapper/fourtb5
devid   14 size 7.28TiB used 6.21TiB path /dev/mapper/eighttb

There's plenty of room for it to allocate some 600GiB of new metadata
or data chunks, mirrored on just these two devices. None of the others
is totally full either.

Sounds like with enospc devs want to see a couple things beyond what I
asked for:

enospc_debug
grep -IR . /sys/fs/btrfs/UUID/allocation/

That's kinda hard to do right now if it's not mounting though...



-- 
Chris Murphy
