Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36858 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935048AbcJRPCE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 11:02:04 -0400
Received: by mail-qk0-f172.google.com with SMTP id o68so343515927qkf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 08:02:04 -0700 (PDT)
MIME-Version: 1.0
From: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Date: Tue, 18 Oct 2016 17:02:03 +0200
Message-ID: <CAA3ktqmsf6S07MDrLhYfBJ2EYYConpHUj7A8FDWSZ09JsYP4eA@mail.gmail.com>
Subject: Btrfs dev del
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

One of the drives which I added to my array two days ago was most
likely already damaged when I bought it - 312 read errors while
scrubbing and lots of SMART errors. I want to take the drive out, go
to my hardware vendor and have it replaced. So I issued the command:
"btrfs dev del /dev/sdf /mnt/btrfs-raid". It has been going on for
about an hour now. It seems that removing the drive triggered a
balance operation - "btrfs fi show"  shows /dev/sdf as having Zero
Data on it, while the size of the data stored on the other drives is
increasing. What I would like to know is where btrfs takes the data to
be replicated from - from the others drive or from the device about to
be removed? I am using RAID1 on data, metadata and system so there
should be a good copy of all the files on /dev/sdf. I just want to be
certain that the damaged data on /dev/sdf are not spread around the
filesystem in which case restoring my backup would be the best idea.

Yours sincerely
Stefan
