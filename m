Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35262 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdHVEzp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 00:55:45 -0400
Received: by mail-it0-f52.google.com with SMTP id 76so39729339ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 21:55:45 -0700 (PDT)
MIME-Version: 1.0
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Mon, 21 Aug 2017 21:55:44 -0700
Message-ID: <CAG+QAKWrsEgWQz23mVqOgS7r_nKX0SzuN=-U4xmiYmy1cM0pjw@mail.gmail.com>
Subject: btrfs corrupt message when mounting (but still mounts and no scrub errors.)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting messages like this when mounting:

[    4.034300] BTRFS info (device sdg3): bdev /dev/sdg3 errs: wr 0, rd
0, flush 0, corrupt 4, gen 0
[    4.034828] BTRFS info (device sdg3): bdev /dev/sdf3 errs: wr 0, rd
0, flush 0, corrupt 68, gen 0

But it mounts fine, and scrub says it is fine:

$  sudo btrfs scrub start -Bd /dev/sdf3
scrub device /dev/sdf3 (id 1) done
        scrub started at Mon Aug 21 21:34:10 2017 and finished after 00:02:55
        total bytes scrubbed: 28.33GiB with 0 errors

$ sudo btrfs scrub start -Bd /dev/sdg3
scrub device /dev/sdg3 (id 2) done
        scrub started at Mon Aug 21 21:49:47 2017 and finished after 00:02:28
        total bytes scrubbed: 28.33GiB with 0 errors

These are a pair of SSDs that I have been scrubbing at least weekly.

How do I clean them up?  And figure out what got corrupt?

(I'm also getting these.... but I think they aren't related?)

[    2.863461] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    2.863576] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    2.866105] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    2.866306] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   31.944514] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   31.946941] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   44.577598] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   44.582437] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   75.458058] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   75.466163] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   98.941941] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[   98.949956] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  115.825455] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  115.827832] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  221.219641] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  221.225138] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  251.208339] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  251.213116] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  266.214212] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  266.217727] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
