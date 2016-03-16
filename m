Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.inoio.de ([5.9.143.11]:43188 "EHLO mail.inoio.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964968AbcCPJwY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 05:52:24 -0400
Received: from [IPv6:2a02:8108:4a40:7348:7e7a:91ff:fecb:ed87] (unknown [IPv6:2a02:8108:4a40:7348:7e7a:91ff:fecb:ed87])
	by mail.inoio.de (Postfix) with ESMTPSA id E10B11C413AB
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 10:45:29 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Ole Langbehn <ole@inoio.de>
Subject: [4.4.1] btrfs-transacti frequent high CPU usage despite little
 fragmentation
Message-ID: <56E92B38.10605@inoio.de>
Date: Wed, 16 Mar 2016 10:45:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

on my box, frequently, mostly while using firefox, any process doing
disk IO freezes while btrfs-transacti has a spike in CPU usage for more
than a minute.

I know about btrfs' fragmentation issue, but have a couple of questions:

* While btrfs-transacti is spiking, can I trace which files are the
culprit somehow?
* On my setup, with measured fragmentation, are the CPU spike durations
and freezes normal?
* Can I alleviate the situation by anything except defragmentation?

Any insight is appreciated.

Details:

I have a 1TB SSD with a large btrfs partition:

# btrfs filesystem usage /
Overall:
    Device size:                 915.32GiB
    Device allocated:            915.02GiB
    Device unallocated:          306.00MiB
    Device missing:                  0.00B
    Used:                        152.90GiB
    Free (estimated):            751.96GiB      (min: 751.96GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:901.01GiB, Used:149.35GiB
   /dev/sda2     901.01GiB

Metadata,single: Size:14.01GiB, Used:3.55GiB
   /dev/sda2      14.01GiB

System,single: Size:4.00MiB, Used:128.00KiB
   /dev/sda2       4.00MiB

Unallocated:
   /dev/sda2     306.00MiB


I've done the obvious and defragmented files. Some files were
defragmented from 10k+ to still more than 100 extents. But the problem
persisted or came back very quickly. Just now i re-ran defragmentation
with the following results (only showing files with more than 100
extents before fragmentation):

extents before / extents after / anonymized path
103 / 1 /home/foo/.mozilla/firefox/foo.default/formhistory.sqlite:
133 / 1
/home/foo/.thunderbird/foo.default/ImapMail/imap.example.org/ml-btrfs:
155 / 1 /var/log/messages:
158 / 30 /home/foo/.thunderbird/foo.default/ImapMail/mail.example.org/INBOX:
160 / 32 /home/foo/.thunderbird/foo.default/calendar-data/cache.sqlite:
255 / 255 /var/lib/docker/devicemapper/devicemapper/data:
550 / 1 /home/foo/.cache/chromium/Default/Cache/data_1:
627 / 1 /home/foo/.cache/chromium/Default/Cache/data_2:
1738 / 25 /home/foo/.cache/chromium/Default/Cache/data_3:
1764 / 77 /home/foo/.mozilla/firefox/foo.default/places.sqlite:
4414 / 284 /home/foo/.digikam/thumbnails-digikam.db:
6576 / 3 /home/foo/.digikam/digikam4.db:

So fragmentation came back quickly, and the firefox places.sqlite file
could explain why the system freezes while browsing.

BTW: I did a VACUUM on the sqlite db and afterwards it had 1 extent.
Expected, just saying that vacuuming seems to be a good measure for
defragmenting sqlite databases.

I am using snapper and have about 40 snapshots going back for some
months. Those are read only. Could that have any effect?

Cheers,

Ole


