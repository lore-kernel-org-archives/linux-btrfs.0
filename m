Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34899 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdHVFTB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 01:19:01 -0400
Received: by mail-oi0-f49.google.com with SMTP id r200so39486658oie.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 22:19:01 -0700 (PDT)
MIME-Version: 1.0
From: Robert LeBlanc <robert@leblancnet.us>
Date: Mon, 21 Aug 2017 23:19:00 -0600
Message-ID: <CAANLjFo714ED=kMHZh0fTWc2WhQwkyZ4a7SZtThm9xwPghn1_Q@mail.gmail.com>
Subject: Re: Btrfs Raid5 issue.
To: lists@colorremedies.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris and Qu thanks for your help. I was able to restore the data off
the volume. I only could not read one file that I tried to rsync (a
MySQl bin log), but it wasn't critical as I had an off-site snapshot
from that morning and ownclould could resync the files that were
changed anyway. This turned out much better than the md RAID failure
that I had a year ago. Much faster recovery thanks to snapshots.

Is there anything you would like from this damaged filesystem to help
determine what went wrong and to help make btrfs better? If I don't
hear back from you in a day, I'll destroy it so that I can add the
disks into the new btrfs volumes to restore redundancy.

Bcache wasn't providing the performance I was hoping for, so I'm
putting the root and roots for my LXC containers on the SSDs (btrfs
RAID1) and the bulk stuff on the three spindle drives (btrfs RAID1).
For some reason, it seemed that the btrfs RAID5 setup required one of
the drives, but I thought I had data with RAID5 and metadata with 2
copies. Was I missing something else that prevented mounting with that
specific drive? I don't want to get into a situation where one drive
dies and I can't get to any data.

Thank you again.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
