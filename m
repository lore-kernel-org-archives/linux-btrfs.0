Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:45144 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbeCZPAG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 11:00:06 -0400
Received: by mail-pg0-f45.google.com with SMTP id y63so4226420pgy.12
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:00:06 -0700 (PDT)
MIME-Version: 1.0
From: Ashu Tiwary <ashuatibm@gmail.com>
Date: Mon, 26 Mar 2018 10:00:04 -0500
Message-ID: <CACJ+inTx=1tfrx0V-2gwq08xxMxvzCq7oBPGcPnH8xUhtX4uBQ@mail.gmail.com>
Subject: Corruption on Big Endian System
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It appears my system may have hit the issue reverted here (
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg74621.html
) ( [PATCH] Revert "btrfs: use proper endianness accessors for
super_copy" ); system is an IBM OpenPower 720 (Big Endian) running
Fedora 27; kernel was at 4.15.9; attempting to reboot after updating
system (including kernel to 4.15.10) caused system to not be able to
boot:

=====
         Mounting /sysroot...
[   34.644721] BTRFS warning (device dm-3): suspicious: generation <
chunk_root_generation: 15959351903540740096 < 17261735521269317632
[   34.644761] BTRFS info (device dm-3): disk space caching is enabled
[   34.644771] BTRFS info (device dm-3): has skinny extents
[   34.645925] BTRFS critical (device dm-3): unable to find logical
71472550772736 length 65536
[   34.645941] BTRFS critical (device dm-3): unable to find logical
71472550772736 length 65536
[   34.645952] BTRFS error (device dm-3): failed to read chunk root
[   34.807156] BTRFS error (device dm-3): open_ctree failed
[FAILED] Failed to mount /sysroot.
=====

It appears there is a manual method available to repair the corrupted
superblock: can that be made available?

Thanks,

-Ashu

--
Ashu Tiwary
ashuatibm@gmail.com
