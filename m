Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:41800 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755527AbeDFNdQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Apr 2018 09:33:16 -0400
Received: by mail-wr0-f176.google.com with SMTP id s12so1786444wrc.8
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Apr 2018 06:33:16 -0700 (PDT)
MIME-Version: 1.0
From: Ben Parsons <9parsonsb@gmail.com>
Date: Fri, 6 Apr 2018 23:32:34 +1000
Message-ID: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
Subject: Bad magic on superblock on /dev/sda at 65536
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just had an unexpected restart and now my btrfs pool wont mount.
The error on mount is:

    "ERROR: unsupported checksum algorithm 41700"

and when running

    btrfs inspect-internal dump-super /dev/sda
    ERROR: bad magic on superblock on /dev/sda at 65536

I saw a thread in the mailing list about it:
https://www.spinics.net/lists/linux-btrfs/msg75326.html
However I am told on IRC that Qu fixed it using magic.

Any help would be much appreciated.

Thanks,
Ben
