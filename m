Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:51373 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJDBOH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 21:14:07 -0400
Received: by mail-io0-f180.google.com with SMTP id l15so9230383iol.8
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 18:14:06 -0700 (PDT)
MIME-Version: 1.0
From: Soujanya Ponnapalli <soujanyap95@gmail.com>
Date: Tue, 3 Oct 2017 20:14:05 -0500
Message-ID: <CAPx+naU2Ydmr65XtAgVtdz=CU1+Sz4UgM9hvRubSsiMR1beGbw@mail.gmail.com>
Subject: [RFC] Is it advisable to use btrfs check --repair flag to fix/find errors?
To: linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Ashlie Martinez <ashmrtn@utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

We are researchers from UT Austin, working on building CrashMonkey[1], a
simple, flexible, file-system agnostic test framework to
systematically check file-systems for inconsistencies if a failure
occurs during a file operation.

Here is a brief description of what we are trying to do:

Firstly we mount the filesystem(fs), run a few tests on the mounted fs
and log the bio requests sent to the fs. We then construct different
crash states that are possible by starting with the snapshot of the
initial state of the disk and applying different permutations of a
subset of the logged bio requests, respecting the ordering rules set
by FUA and flush flags. Later, we run file system consistency
checks/repairs on these generated crash states to repair the possible
inconsistencies and find out if there are still any irreparable
inconsistencies. HotStorage'17 Paper, CrashMonkey[2]: A Framework to
Automatically Test File-System Crash Consistency has detailed
explanation of the methodology.

For this purpose, is it advisable to run btrfs check with --repair
flag to fix or find errors? We have seen - "Warning: Do not use
--repair unless you are advised to by a developer, an experienced user
or accept the fact that fsck cannot possibly fix all sorts of damage
that could happen to a filesystem because of software and hardware
bugs". Hence, please let us know what you think regarding this! Also,
the output of `btrfs check` only hints on saying something is wrong by
setting err to -1. Is there a way to find out what exactly was found
by btrfs?

Thanks,
Soujanya.

$ uname -r
4.4.0-62-generic

$ btrfs --version
btrfs-progs v4.4

$ btrfs fi show
Label: 'btrfs'  uuid: 3e6e7154-79b0-44b2-9193-945a86d61550
    Total devices 1 FS bytes used 392.00KiB
    devid    1 size 10.00GiB used 2.02GiB path /dev/sda3

$ btrfs fi df /mountpoint
Data, single: total=8.00MiB, used=264.00KiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=1.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

$ dmesg > dmesg.log
www.cs.utexas.edu/~soujanya/dmesg.log

[1] https://github.com/utsaslab/crashmonkey
[2] http://www.cs.utexas.edu/%7Evijay/papers/hotstorage17-crashmonkey.pdf
