Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33390 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968544AbdDSRj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 13:39:59 -0400
Received: by mail-yw0-f169.google.com with SMTP id 203so14904370ywe.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Apr 2017 10:39:58 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 19 Apr 2017 11:39:47 -0600
Message-ID: <CAJCQCtTbp2qkSHNyRNYm41civm+V_gsGkRBNHe+_7sgW+1fgjg@mail.gmail.com>
Subject: Reporting and monitoring storage events (blog)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

http://www-rhstorage.rhcloud.com/blog/vpodzime/reporting-and-monitoring-storage-events

I think the most useful part of this would be standardized messaging.
For the exact same defect state on disk (data corruption), I get two
different formatted messages depending on whether it's found passively
by reading the file, or with a scrub.

(this is 2x disk raid 1)

read file:
[256914.773712] BTRFS warning (device dm-6): csum failed ino 257 off 0
csum 3734069121 expected csum 1334657141
[256914.774594] BTRFS warning (device dm-6): csum failed ino 257 off 0
csum 3734069121 expected csum 1334657141
[256914.775892] BTRFS info (device dm-6): read error corrected: ino
257 off 0 (dev /dev/mapper/VG-b1 sector 2155520)

scrub volume:


[257313.636610] BTRFS warning (device dm-6): checksum error at logical
1103626240 on dev /dev/mapper/VG-b1, sector 2155520, root 5, inode
257, offset 0, length 4096, links 1 (path:
openSUSE-Tumbleweed-NET-x86_64-Current.iso)
[257313.636865] BTRFS error (device dm-6): bdev /dev/mapper/VG-b1
errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[257313.637737] BTRFS error (device dm-6): fixed up error at logical
1103626240 on dev /dev/mapper/VG-b1


Reading means there's a warning, scrubbing means there's an error? So
even the log level is different for the same problem?

And then the ambiguous "read error corrected" vs "fixed up error" -
the second one is more clear that the fix is pushed to a device "fixed
error on device" rather than just an in memory correction. But still,
they're different messages for the same problem and the auto healing.


-- 
Chris Murphy
