Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:35700 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdHaRyU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 13:54:20 -0400
Received: by mail-qt0-f174.google.com with SMTP id x36so1649722qtx.2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 10:54:19 -0700 (PDT)
MIME-Version: 1.0
From: Eric Wolf <19wolf@gmail.com>
Date: Thu, 31 Aug 2017 13:53:58 -0400
Message-ID: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
Subject: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having issues with a bad block(?) on my root ssd.

dmesg is consistently outputting "BTRFS critical (device sda2):
corrupt leaf, bad key order: block=293438636032, root=1, slot=11"

"btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
total bytes scrubbed: 53.41GiB with 2 errors
error details: verify=2
corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"

Running "btrfs check --repair /dev/sda2" from a live system stalls
after telling me corrupt leaf etc etc then "11 12". CPU usage hits
100% and disk activity remains at 0.
