Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:33534 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbeDWER1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 00:17:27 -0400
Received: by mail-it0-f50.google.com with SMTP id x144-v6so8270089itc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Apr 2018 21:17:26 -0700 (PDT)
MIME-Version: 1.0
From: Patrick Mitchell <patricklmitchell9@gmail.com>
Date: Mon, 23 Apr 2018 00:17:25 -0400
Message-ID: <CA+2BD2dv4ZCdhB37OvvQsr4mWT84knZ1ahVtuEFsFrSJR6vy8g@mail.gmail.com>
Subject: btrfs check : check/main.c:3654: check_owner_ref: BUG_ON
 `rec->is_root` triggered, value `
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arch, kernel 4.15.14, btrfs progs 4.15.1.

Had some SATA drives dropout.  Have a few btrfs volumes with parent
transid verify failed errors, that all mount.

This volume has nothing I care about, so I'm just reporting it since
it looks like a bug.  None of my other volumes having issues cause
core dumps.  Happy to send whatever other info might help track it
down.


# btrfs check /dev/lvm/snapper1
Checking filesystem on /dev/lvm/snapper1
UUID: ef6f4923-0a03-4e41-9655-e24a13a1d879
parent transid verify failed on 862240768 wanted 29524 found 29182
parent transid verify failed on 862240768 wanted 29524 found 29182
checking extents
check/main.c:3654: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1
btrfs(+0x5f98c)[0x55ec9db9198c]
btrfs(+0x12ad6)[0x55ec9db44ad6]
btrfs(+0x18c7f)[0x55ec9db4ac7f]
btrfs(+0x199c6)[0x55ec9db4b9c6]
btrfs(+0x19fc0)[0x55ec9db4bfc0]
btrfs(cmd_check+0xf63)[0x55ec9db94423]
btrfs(main+0x81)[0x55ec9db4e441]
/usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f6923f2ff4a]
btrfs(_start+0x2a)[0x55ec9db4e55a]
[1]    9612 abort (core dumped)  btrfs check /dev/lvm/snapper1
