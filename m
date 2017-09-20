Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:56690 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdITJSa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 05:18:30 -0400
Received: by mail-oi0-f54.google.com with SMTP id b184so1628249oii.13
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 02:18:30 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 20 Sep 2017 12:17:49 +0300
Message-ID: <CAGqmi7574by+tZhqfgKYtMQVkCEJtmMa0jpGZAq-8xg3s4K42w@mail.gmail.com>
Subject: RFC: crc32c vs xxhash32/64 (ARM)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
About 3 years ago Liu Bo has try add xxhash support to btrfs[1].
For now (Kernel 4.14) kernel have a native library for xxhash.

Main reason to not add that support is what:
 - CRC32C - has hardware support and amazing fast
 - CRC32C - Can fix 1 bit error
   (Yes that possible, but that not used in btrfs and i hard to find
example of correction in the kernel)
   So that a not a valuable reason.

xxhash32/64 did not have a HW support but must outperform CRC32c in SW mode.

I'm not sure that ARM boxes, as example, some NAS have a HW crc32c.
([2] show that CRC32 can have HW on some types of ARMv8).
([3] for ARM v8.1-A CRC hw must be)

May be that make a sense to add support for both xxhash32/64?
And do some type of testing on module load like raid6 have, and use
fastest for newly written data?

I test speed on xxhash32/64 and crc32c, and use fastest function for
new written data?

Thanks!

P.S.
May be some one has ARMv8 boxes?
Can you check which module used by btrfs:
~ dmesg| grep crc
[    0.666469] Btrfs loaded, crc32c=crc32c-intel
May be you want/can test xxhash32/64 on arm, i backport kernel version in [4].
(But [4] doesn't have HW CRC32 support, i hard to find example
userspace implementation to stole on github and didn't have ARM box)

Links:
1. http://linux-btrfs.vger.kernel.narkive.com/pO9lOshJ/patch-2-3-crypto-xxhash-add-tests
2. https://github.com/torvalds/linux/blob/5518b69b76680a4f2df96b1deca260059db0c2de/arch/arm/crypto/crc32-ce-glue.c
3. https://en.wikipedia.org/wiki/ARM_architecture#ARMv8.1-A
4. https://github.com/Nefelim4ag/CRC32C_AND_8Byte_parity
-- 
Have a nice day,
Timofey.
