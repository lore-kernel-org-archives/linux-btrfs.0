Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:46128 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbeBVCXz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 21:23:55 -0500
Received: by mail-ua0-f180.google.com with SMTP id n48so2377875uae.13
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 18:23:54 -0800 (PST)
MIME-Version: 1.0
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Wed, 21 Feb 2018 20:23:53 -0600
Message-ID: <CA+EzBbCronNb25yxmn8zsSUwQqJC26fWJ+XmFo-jdBHSd9s3uA@mail.gmail.com>
Subject: btrfs crash consistency bug : Blocks allocated beyond eof are lost
To: linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On btrfs (as of kernel 4.15), say we fallocate a file with keep_size
option, followed by fdatasync() or fsync(). If we now crash, on
recovery we see a wrong block count and all the blocks allocated
beyond the eof are lost. This bug was reported(xfstest generic/468)
and patched on ext4[1], and a variant of this, that did not recover
the correct file size was patched in f2fs[2]. I am wondering why this
is still not fixed in btrfs. You can reproduce this bug on btrfs using
a tool called CrashMonkey that we are building at UT Austin, which is
a test harness for filesystem crash consistency checks[3]

To reproduce the bug, simply run :
 ./c_harness -f /dev/sda -d /dev/cow_ram0 -t btrfs -e 102400  -v
tests/generic_468.so

Is there a reason why this is not yet patched in btrfs? I don't see
why even after a fsync(), losing the blocks allocated beyond the eof
are acceptable.

[1] https://patchwork.kernel.org/patch/10120293/
[2] https://sourceforge.net/p/linux-f2fs/mailman/message/36104201/
[3] https://github.com/utsaslab/crashmonkey

Thanks,

Jayashree Mohan
2nd Year PhD in Computer Science
University of Texas at Austin.
