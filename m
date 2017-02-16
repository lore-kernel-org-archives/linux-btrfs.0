Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35386 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdBPUNl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 15:13:41 -0500
Received: by mail-vk0-f48.google.com with SMTP id x75so17426737vke.2
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Feb 2017 12:13:41 -0800 (PST)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Thu, 16 Feb 2017 15:13:40 -0500
Message-ID: <CAJtFHUTK-0m08usaak+_AVLntZnFZUswi5tq=vkiSVpacKW47A@mail.gmail.com>
Subject: Way to force allocation of more metadata?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It would be nice if there was an easy way to tell btrfs to allocate
another metadata chunk. For example, the below fs is full due to
exhausted metadata:

    Device size:                1013.28GiB
    Device allocated:           1013.28GiB
    Device unallocated:            2.00MiB
    Device missing:                  0.00B
    Used:                        981.94GiB
    Free (estimated):             15.16GiB      (min: 15.16GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              510.31MiB      (used: 0.00B)

             Data      Metadata  System
Id Path      RAID1     RAID1     RAID1    Unallocated
-- --------- --------- --------- -------- -----------
 1 /dev/sdv1 505.63GiB   1.00GiB  8.00MiB     1.00MiB
 2 /dev/sdw1 505.63GiB   1.00GiB  8.00MiB     1.00MiB
-- --------- --------- --------- -------- -----------
   Total     505.63GiB   1.00GiB  8.00MiB     2.00MiB
   Used      490.47GiB 510.88MiB 96.00KiB

I can delete a multi GB file and get several GB of unallocated space,
however if I try and copy big files to it again the same exact thing
happens. However, if I play with balance and deleting files and such
and manage to get it to allocate another metadata chunk while there is
unallocated space then the filesystem will happily fill up all of the
data chunks. Failing an automatic allocation out of global reserve, or
saving metadata as soon as unallocated space is available it would be
nice if I could just delete a file and then tell btrfs to allocate
more metadata immediately. Makes sense? No idea how easy this would be
to do, but seems like it should be a simple thing btrfs file could do.
