Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:34733 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbcLDV2P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 16:28:15 -0500
Received: by mail-yw0-f177.google.com with SMTP id t125so243879852ywc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 13:28:15 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Dec 2016 14:28:13 -0700
Message-ID: <CAJCQCtTRXEcJmP8vu1uaJHME2UnosHPOP9vmQM3GBACoJDpLPA@mail.gmail.com>
Subject: crc32c_le performance hit
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

4.8.11-300.fc25.x86_64

I'm currently doing a btrfs send/receive and I'm seeing a rather large
hit for crc32c, bigger than aes-ni (the volume is on dm crypt), using
perf top.

  14.03%  btrfs                                    [.] __crc32c_le
  10.50%  [kernel]                                 [k] _aesni_enc4


Complete output is here for 1 month:
https://paste.fedoraproject.org/498914/

I don't remember crc32's taking this much CPU before, so it seems like
a regression but offhand I don't know when it started.

[chris@f25s ~]$ dmesg | grep crc32
[    4.226700] Btrfs loaded, crc32c=crc32c-intel


[chris@f25s ~]$ lsmod | grep crc
libcrc32c              16384  1 dm_persistent_data
crct10dif_pclmul       16384  0
crc32_pclmul           16384  0
crc32c_intel           24576  2



-- 
Chris Murphy
