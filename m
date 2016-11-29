Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35358 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbcK2OdP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 09:33:15 -0500
Received: by mail-wm0-f44.google.com with SMTP id a197so239125293wmd.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 06:33:14 -0800 (PST)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 29 Nov 2016 17:32:32 +0300
Message-ID: <CAGqmi74qK2v0JCtAjan8aju+sK3LWPWwMgnJOP3i2srrqnLHSA@mail.gmail.com>
Subject: True size of btrfs data chunk
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, as wiki say https://btrfs.wiki.kernel.org/index.php/Glossary:
A part of a block group. Chunks are either 1 GiB in size (for data) or
256 MiB (for metadata).

Btrfs tools show me that allocated size is not 1GiB aligned, things
are changes? I miss something?

# btrfs fi df /; btrfs fi usage /;
Data, single: total=1.41GiB, used=704.47MiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=256.00MiB, used=54.30MiB
GlobalReserve, single: total=32.00MiB, used=0.00B
Overall:
   Device size:                   4.00GiB
   Device allocated:              1.69GiB
   Device unallocated:            2.31GiB
   Device missing:                  0.00B
   Used:                        758.79MiB
   Free (estimated):              3.03GiB      (min: 3.03GiB)
   Data ratio:                       1.00
   Metadata ratio:                   1.00
   Global reserve:               32.00MiB      (used: 0.00B)

Data,single: Size:1.41GiB, Used:704.47MiB
  /dev/sda1       1.41GiB

Metadata,single: Size:256.00MiB, Used:54.30MiB
  /dev/sda1     256.00MiB

System,single: Size:32.00MiB, Used:16.00KiB
  /dev/sda1      32.00MiB

Unallocated:
  /dev/sda1       2.31GiB

Thanks.
-- 
Have a nice day,
Timofey.
