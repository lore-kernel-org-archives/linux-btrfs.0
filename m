Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36059 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938991AbcJXVxM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 17:53:12 -0400
Received: by mail-wm0-f43.google.com with SMTP id b80so128604246wme.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 14:53:12 -0700 (PDT)
MIME-Version: 1.0
From: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Date: Mon, 24 Oct 2016 23:53:05 +0200
Message-ID: <CAA3ktqnHVmYS_LdVq5AmWLb0fY27Rw_vy-YqKHHqwDy696+LTA@mail.gmail.com>
Subject: Scrubbing Errors after restoring backup
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

For reference please see this post.
https://mail-archive.com/linux-btrfs@vger.kernel.org/msg58461.html
Please note that I downgraded to btrfs-progs 4.6.1 as advised.

After exchanging the malfunctioning drive I re-created the filesystem
and restored the backup from my NAS. (I didnt entirely trust the
filesystem after so many errors) On completing the restoration I
manually started scrubbing, which ended with hundreds of checksum and
read errors on /dev/sda.
The drive checks out fine in smart and passed through all scheduled
SMART Self-Tests. The model is not identical to the two drives
recently added to the system - the new drives are WD Blue, the four
original ones are WD Greens.

I have resetted the output from btrfs dev stats and restarted the
scrubbing process. I am unsure how to interpret or explain the errors
of the last scrub run. I scrubbed regularly each month for nearly
three years and never had any errors. I would be grateful for any
advice how to proceed.

Yours sincerely
Stefan
