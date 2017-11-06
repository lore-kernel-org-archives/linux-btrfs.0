Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:45575 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753924AbdKFURu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 15:17:50 -0500
Received: by mail-ot0-f181.google.com with SMTP id q99so10140116ota.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 12:17:49 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 6 Nov 2017 13:17:48 -0700
Message-ID: <CAJCQCtTsfNgSBDdnq0uFd1ZRRY0AWbv=rx5X1UUGp1i9hK-4hw@mail.gmail.com>
Subject: feedback on three different scrub methods
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just did scrubs on five different volumes using all three scrub
methods. There were no errors found, so the test leaves uncertain what
the error handling differences are between the three scrubs. But at
the least with no errors, there are also no disagreements between the
three methods.

1. Speed. Both normal online scrub and the btrfsck --check-data-csum
methods, I get ~275MB/s transfers per iotop. Whereas with --offline
scrub I'm seeing 60%-67% of that, or ~170MB/s transfers. That's
substantially slower. If it were using less CPU or the system more
responsive, it might be worth that trade off in time. But the CPU %
and system responsiveness for other tasks seemed the same, it just
took longer.

2. Each method reports different statistics in different formats. And
that's fine except I can't make heads or tails out of the information
presented, making it basically useless at least to this user.

[chris@f26s ~]$ sudo /srv/scratch/gitsworking/btrfs-progs/btrfs check
--check-data-csum /dev/mapper/sdd
Checking filesystem on /dev/mapper/sdd
UUID: f5adc913-bbea-4340-8b5f-3411e2cda642
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 601877024768 bytes used, no error found
total csum bytes: 586444884
total tree bytes: 1208827904
total fs tree bytes: 510672896
total extent tree bytes: 53755904
btree space waste bytes: 142065358
file data blocks allocated: 2213492944896
 referenced 1977848909824


[chris@f26s ~]$ sudo btrfs-progs/btrfs scrub start --offline
/dev/mapper/sdd
[sudo] password for chris:
Scrub result:
Tree bytes scrubbed: 2417655808
Tree extents scrubbed: 295124
Data bytes scrubbed: 2398080548864
Data extents scrubbed: 751158
Data bytes without csum: 297271296
Read error: 0
Verify error: 0
Csum error: 0

I'm not finding any way these add up. Seems like --offline's tree
bytes scrubbed + data bytes scrubbed should add up to
--check-data-csum's found bytes - waste bytes? But no, I have no idea
what I'm looking at or how it's useful to the user, but OK.


I used kernel 4.13.10 and btrfs-progs 4.13.3 for the usual 'btrfs
scrub start' and the less common 'btrfs check ----check-data-csum'
methods; and Qu's v4.11.1-89-gf939adf2 with offline_scrub checked out.




-- 
Chris Murphy
