Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:38970 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753572AbeFJSmZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Jun 2018 14:42:25 -0400
Received: by mail-ot0-f173.google.com with SMTP id l15-v6so20312656oth.6
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jun 2018 11:42:24 -0700 (PDT)
Received: from ?IPv6:2600:1702:1d00:db80:c142:6061:57c1:ec4b? ([2600:1702:1d00:db80:c142:6061:57c1:ec4b])
        by smtp.gmail.com with ESMTPSA id t77-v6sm14077365oie.3.2018.06.10.11.42.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 10 Jun 2018 11:42:23 -0700 (PDT)
From: Vote 539 <vote539@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: Filesystem read-only (btrbk, bad metadata, unable to find ref byte)
Message-Id: <9C0633CD-D4FC-4A93-9A6F-1EF185F4205D@gmail.com>
Date: Sun, 10 Jun 2018 11:42:21 -0700
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem that I use as a target for send/receive incremental snapshots.  I use btrbk to perform hourly backups.

The target filesystem was offline for a few days.  When I mounted it today, the filesystem was read-only, with dmesg errors:

    …
    [  167.004684] BTRFS error (device sda2): unable to find ref byte nr 40366194688 parent 0 root 6894  owner 1 offset 0
    [  167.004722] ------------[ cut here ]------------
    [  167.004735] WARNING: CPU: 0 PID: 1273 at /build/linux-E14mqW/linux-4.4.0/fs/btrfs/extent-tree.c:6553 __btrfs_free_extent.isra.68+0x8ff/0xd30 [btrfs]()
    [  167.004736] BTRFS: Transaction aborted (error -2)
    …
    [  167.005011] BTRFS: error (device sda2) in __btrfs_free_extent:6553: errno=-2 No such entry
    [  167.005041] BTRFS info (device sda2): forced readonly
    [  167.005044] BTRFS: error (device sda2) in btrfs_run_delayed_refs:2930: errno=-2 No such entry
    …

Full dmesg: https://pastebin.com/XNKJbN15

I unmounted the filesystem and ran btrfs check.  I let it run overnight.  Output:

    $ sudo btrfs check /dev/sda2
    Checking filesystem on /dev/sda2
    UUID: ea0dc14b-2a93-4721-bc9c-aa4ed069ee7d
    checking extents
    bad metadata [36962304, 36978688) crossing stripe boundary
    bad metadata [83689472, 83705856) crossing stripe boundary
    …
    ref mismatch on [24969854976 16384] extent item 0, found 1
    Backref 24969854976 parent 6894 root 6894 not found in extent tree
    backpointer mismatch on [24969854976 16384]
    …

Full btrfs check output: https://pastebin.com/9QxasQv5

Kernel version (Ubuntu 16.04 LTS):

    $ uname -a
    Linux oo-landfill1 4.4.0-127-generic #153-Ubuntu SMP Sat May 19 10:58:46 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

Questions:

1) How can I repair the disk such that incremental backups can pick up where they left off?

2) Will "btrfs check --repair" fix this kind of error?

3) How can I dump a snapshot into a flat file that I can use to restore the snapshot into a clean btrfs partition such that send/receive can pick up with incremental backups based on that snapshot?

4) Suggestions on how to avoid this issue in the future?  (This is the primary use for my box so I'm willing to change to a different distribution or GNU/Linux version if it plays nicer with btrfs)

Thanks,
Shane


