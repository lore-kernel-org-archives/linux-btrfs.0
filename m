Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:34035 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754635AbcH3KW0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 06:22:26 -0400
Received: by mail-ua0-f181.google.com with SMTP id k90so24524755uak.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 03:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQhFHX2ba3gYUHw0XtbLousVz8s7ZxMnT1ThU46iOxNOA@mail.gmail.com>
References: <CAKzrAgTcrjN_qLqzqQ_izpB_AvypaGV=TGNEeH=-18GmOVjAAg@mail.gmail.com>
 <CAJCQCtQhFHX2ba3gYUHw0XtbLousVz8s7ZxMnT1ThU46iOxNOA@mail.gmail.com>
From: "ojab //" <ojab@ojab.ru>
Date: Tue, 30 Aug 2016 10:22:24 +0000
Message-ID: <CAKzrAgRQ6gkEgWZwG1emf0w5RURkj93L_A4--OK-PaPEf17XvQ@mail.gmail.com>
Subject: Re: `btrfs dev del` fails with `No space left on device`
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 29, 2016 at 9:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Aug 29, 2016 at 10:04 AM, ojab // <ojab@ojab.ru> wrote:
> What do you get for 'btrfs fi us <mp>'

$ sudo btrfs fi us /mnt/xxx/
Overall:
    Device size:                  3.64TiB
    Device allocated:             1.82TiB
    Device unallocated:           1.82TiB
    Device missing:                 0.00B
    Used:                     1.81TiB
    Free (estimated):             1.83TiB         (min: 943.55GiB)
    Data ratio:                  1.00
    Metadata ratio:                  2.00
    Global reserve:             512.00MiB         (used: 0.00B)

Data,RAID0: Size:1.81TiB, Used:1.80TiB
   /dev/sdb1        928.48GiB
   /dev/sdc1        928.48GiB

Metadata,RAID1: Size:3.00GiB, Used:2.15GiB
   /dev/sdb1          3.00GiB
   /dev/sdc1          3.00GiB

System,RAID1: Size:32.00MiB, Used:176.00KiB
   /dev/sdb1         32.00MiB
   /dev/sdc1         32.00MiB

Unallocated:
   /dev/sdb1          1.01MiB
   /dev/sdc1          1.00MiB
   /dev/sdd1          1.82TiB

>
> You can see what the state of block groups are with btrfs-debugfs
> which is in kdave btrfs-progs git. Chances are you need a larger
> value, -dusage=15 -musage=15 to free up space on devid 1 and 2. Then
> maybe devid 3 can be removed.

btrfs-debugfs output:
https://gist.github.com/ojab/a3c59983e8fb6679b8fdc0e88c0c9e60
Before `delete` the was about 60Gb of free space, looks like it was
filled during `delete` (I've seen similar behavior during `btrfs fi
defrag`) and I should use `-dusage=69` and up.

I don't quite understand what exactly btrfs is trying to do: I assume
that block groups should be relocated to the new/empty drive, but
during the delete `btrfs fi us` shows
Unallocated:
/dev/sdc1         16.00EiB

so deleted partition is counted as maximum possible empty drive and
blocks are relocated to it instead of new/empty drive? (kernel-4.7.2 &
btrfs-progs-4.7.1 here)
Is there any way to see where and why block groups are relocated
during `delete`?

//wbr ojab
