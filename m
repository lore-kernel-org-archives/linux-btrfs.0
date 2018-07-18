Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:46966 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731282AbeGRSTw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 14:19:52 -0400
Received: by mail-lf0-f41.google.com with SMTP id l16-v6so4030705lfc.13
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 10:40:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQrY2rz0CTntCO9szii7SveshtSMgCPz4JQqq16kfATNw@mail.gmail.com>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz> <2197534.TZSffJRfLT@merkaba>
 <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com> <1736761.B5nO4FXixV@merkaba>
 <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com> <CAJCQCtSZruKeM117EfQNQnEFuk_bswhhKnEnFVD2i7MHWU65RQ@mail.gmail.com>
 <d42d5c79-46df-4e11-0ba2-1adb9e073ed9@gmail.com> <CAJCQCtSpMi-GmJSQx+tjt+WjDqvEH5Z9yeUrYSjLFz+P4f2j2A@mail.gmail.com>
 <0a3a8550-3622-0c7b-bcf7-e2d7cabf6b4a@gmail.com> <CAJCQCtQrY2rz0CTntCO9szii7SveshtSMgCPz4JQqq16kfATNw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 18 Jul 2018 11:40:52 -0600
Message-ID: <CAJCQCtSV35cR5KS4dT0x5wYyMHXszdBFGT2Rt7XAMa4dDmC5uw@mail.gmail.com>
Subject: Re: Healthy amount of free space?
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Nikolay Borisov <nborisov@suse.com>, Wolf <wolf@wolfsden.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 11:14 AM, Chris Murphy <lists@colorremedies.com> wrote:

> I don't know for sure, but based on the addresses reported before and
> after dd for the fallocated tmp file, it looks like Btrfs is not using
> the originally fallocated addresses for dd. So maybe it is COWing into
> new blocks, but is just as quickly deallocating the fallocated blocks
> as it goes, and hence doesn't end up in enospc?

Previous thread is "Problem with file system" from August 2017. And
there's these reproduce steps from Austin which have fallocate coming
after the dd.

    truncate --size=4G ./test-fs
    mkfs.btrfs ./test-fs
    mkdir ./test
    mount -t auto ./test-fs ./test
    dd if=/dev/zero of=./test/test bs=65536 count=32768
    fallocate -l 2147483650 ./test/test && echo "Success!"


My test Btrfs is 2G not 4G, so I'm cutting the values of dd and
fallocate in half.

[chris@f28s btrfs]$ sudo dd if=/dev/zero of=tmp bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 7.13391 s, 147 MB/s
[chris@f28s btrfs]$ sync
[chris@f28s btrfs]$ df -h
Filesystem                Size  Used Avail Use% Mounted on
/dev/mapper/vg-btrfstest  2.0G 1018M  1.1G  50% /mnt/btrfs
[chris@f28s btrfs]$ sudo fallocate -l 1000m tmp


Succeeds. If I do it with a 1200M file for dd and fallocate 1200M over
it, this fails, but I kinda expect that because there's only 1.1G free
space. But maybe that's what you're saying is the bug, it shouldn't
fail?



-- 
Chris Murphy
