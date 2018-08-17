Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40252 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbeHQFpy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 01:45:54 -0400
Received: by mail-pf1-f176.google.com with SMTP id e13-v6so2862756pff.7
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 19:44:21 -0700 (PDT)
Received: from NJ-MILI-T480 ([209.249.181.2])
        by smtp.gmail.com with ESMTPSA id g69-v6sm934389pfd.23.2018.08.16.19.44.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Aug 2018 19:44:20 -0700 (PDT)
Date: Fri, 17 Aug 2018 10:44:19 +0800
From: "litaibaichina@gmail.com" <litaibaichina@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfsck out of memory for big fs
Mime-Version: 1.0
Message-ID: <201808171044160880896@gmail.com>
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Guys,

I had a big btrfs on a md device,  it be mounted , but after a while it will become ready only:
# btrfs fi df /data/
Data, single: total=24.46TiB, used=24.46TiB
System, DUP: total=8.00MiB, used=2.59MiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=81.00GiB, used=79.71GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=264.28MiB

# dmesg -T
[Thu Aug 16 18:16:31 2018] BTRFS error (device md127): parent transid verify failed on 26603622694912 wanted 185320 found 207817
[Thu Aug 16 18:16:31 2018] BTRFS error (device md127): parent transid verify failed on 26603622694912 wanted 185320 found 207817
[Thu Aug 16 18:16:31 2018] BTRFS warning (device md127): Skipping commit of aborted transaction.
[Thu Aug 16 18:16:31 2018] BTRFS: error (device md127) in cleanup_transaction:1864: errno=-5 IO failure
[Thu Aug 16 18:16:31 2018] BTRFS info (device md127): forced readonly
[Thu Aug 16 18:16:31 2018] BTRFS info (device md127): delayed_refs has NO entry

I want to use btrfsck to check it,  but it will OOM :
# btrfsck /dev/md127
Checking filesystem on /dev/md127
UUID: 6b87a52f-9a5f-4d03-b345-9d954c2ce259
checking extents
Killed

I am trying to use lowmem mode,  but as I tried before, it may OOM too,    any ideas ?

Thanks.
