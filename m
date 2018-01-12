Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:37926 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932859AbeALRm4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 12:42:56 -0500
Received: by mail-yb0-f196.google.com with SMTP id b132so3017792yba.5
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 09:42:56 -0800 (PST)
MIME-Version: 1.0
From: Maciej Piechotka <uzytkownik2@gmail.com>
Date: Fri, 12 Jan 2018 09:42:35 -0800
Message-ID: <CAMcAH6gNbtTfxQGU1pOKifgN3k7r14wB2dNdqVpoB6eZJphRuQ@mail.gmail.com>
Subject: Small btrfs corruptions on 4.14.13
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Yesterday, after update to 4.14.13 from 4.14.12 I got a corruptions of
btrfs. Each time transaction was aborted with error about something
being already present. Unfortunatly as logs were on btrfs partition as
well the only recovered part is:

Jan 11 20:52:30 babylon5 kernel: BTRFS: Transaction aborted (error -17)
Jan 11 20:52:30 babylon5 kernel: ------------[ cut here ]------------
Jan 11 20:52:30 babylon5 kernel: WARNING: CPU: 3 PID: 312 at
fs/btrfs/extent-tree.c:3089 btrfs_run_delayed_refs+0x249/0x260 [btrfs]
(after reboot)
Jan 11 21:01:02 babylon5 kernel: BTRFS warning (device dm-1): block
group 13971226624 has wrong amount of free space
Jan 11 21:01:02 babylon5 kernel: BTRFS warning (device dm-1): failed
to load free space cache for block group 13971226624, rebuilding it
now


First time it corrupted perf.js file in Firefox profile making seeming
zeroing it's entry (owner root:root, wrong file type, permissions
0000, timestamp on start of Unix epoch etc.). I could not find any
corruptions second time. After each time scrub finished without
problems.

Matt
